<?php
require_once __DIR__ . '/lib/auth.php';
require_once __DIR__ . '/lib/report_period.php';
try {
    require '../db.php';
} catch (PDOException $e) {
    http_response_code(500);
    exit('Database connection failed: ' . htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8'));
}

$pageTitle = 'Report Details';
$pageStyles = ['reports.css?v=20261121-5'];

$report = null;
$pageError = '';
$reportDates = [];
$transactions = [];
$reportPeriodLabel = '';
$dailyActivity = [];
$reportId = $_GET['id'] ?? '';
$totalBooksBorrowed = 0;
$totalBooksReturned = 0;
$activeBorrowers = [];
$transactionCount = 0;
$grain = 'day';
$grainName = 'Day';

if (!is_string($reportId) || !ctype_digit($reportId)) {
    http_response_code(400);
    $pageError = 'A valid report ID is required.';
} else {
    try {
        $stmt = $pdo->prepare(
            'SELECT report_id, libstaff_id, report_type, date_generated, period_start
             FROM reports
             WHERE report_id = ?'
        );
        $stmt->execute([$reportId]);
        $report = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($report === false) {
            http_response_code(404);
            $pageError = 'The requested report was not found.';
        } elseif (empty($report['date_generated'])) {
            $pageError = 'This report has no generation date, so its reporting period cannot be determined.';
        } else {
            $generatedAt = new DateTimeImmutable($report['date_generated']);
            $periodStart = report_period_start((string)$report['report_type'], $report['period_start'], $generatedAt);

            switch ($report['report_type']) {
                case 'Weekly':
                    $periodEnd = $periodStart->modify('+1 week');
                    $reportPeriodLabel = report_period_label('Weekly', $periodStart);
                    $grain = 'day';
                    $grainName = 'Day';
                    break;
                case 'Monthly':
                    $periodEnd = $periodStart->modify('+1 month');
                    $reportPeriodLabel = report_period_label('Monthly', $periodStart);
                    $grain = 'week';
                    $grainName = 'Week';
                    break;
                case 'Annual':
                    $periodEnd = $periodStart->modify('+1 year');
                    $reportPeriodLabel = report_period_label('Annual', $periodStart);
                    $grain = 'month';
                    $grainName = 'Month';
                    break;
                default:
                    throw new UnexpectedValueException('This report has an unsupported report type.');
            }

            $bucketSql = [
                'day' => 'DATE(%s)',
                'week' => 'DATE_SUB(DATE(%s), INTERVAL WEEKDAY(%s) DAY)',
                'month' => "DATE_FORMAT(%s, '%%Y-%%m-01')"
            ][$grain];
            $bucketBorrowed = str_replace('%s', 'date_borrowed', $bucketSql);
            $bucketReturned = str_replace('%s', 'date_returned', $bucketSql);
            $bucketBorrowed = str_replace('%%', '%', $bucketBorrowed);
            $bucketReturned = str_replace('%%', '%', $bucketReturned);

            $activityStmt = $pdo->prepare(
                "SELECT activity_date,
                        SUM(event_type = 'borrowed') AS books_borrowed,
                        SUM(event_type = 'returned') AS books_returned,
                        COUNT(DISTINCT CASE WHEN event_type = 'borrowed' THEN user_id END) AS borrowers
                 FROM (
                     SELECT {$bucketBorrowed} AS activity_date, 'borrowed' AS event_type, user_id
                     FROM borrows
                     WHERE date_borrowed >= ? AND date_borrowed < ?
                     UNION ALL
                     SELECT {$bucketReturned} AS activity_date, 'returned' AS event_type, user_id
                     FROM borrows
                     WHERE date_returned >= ? AND date_returned < ?
                 ) AS report_activity
                 GROUP BY activity_date"
            );
            $startDateTime = $periodStart->format('Y-m-d H:i:s');
            $endDateTime = $periodEnd->format('Y-m-d H:i:s');
            $activityStmt->execute([$startDateTime, $endDateTime, $startDateTime, $endDateTime]);

            $transactionsStmt = $pdo->prepare(
                'SELECT borrow_id, user_id, copy_id, date_borrowed, due_date, date_returned
                 FROM borrows
                 WHERE (date_borrowed >= ? AND date_borrowed < ?)
                    OR (date_returned >= ? AND date_returned < ?)
                 ORDER BY COALESCE(date_borrowed, date_returned), borrow_id'
            );
            $transactionsStmt->execute([$startDateTime, $endDateTime, $startDateTime, $endDateTime]);
            $transactions = $transactionsStmt->fetchAll(PDO::FETCH_ASSOC);
            $transactionCount = count($transactions);
            foreach ($transactions as $transaction) {
                if (!empty($transaction['user_id'])) {
                    $activeBorrowers[(string)$transaction['user_id']] = true;
                }
            }

            $activityByDate = [];
            foreach ($activityStmt->fetchAll(PDO::FETCH_ASSOC) as $activity) {
                $activityByDate[$activity['activity_date']] = $activity;
            }

            $buckets = [];
            if ($grain === 'day') {
                foreach (new DatePeriod($periodStart, new DateInterval('P1D'), $periodEnd) as $date) {
                    $buckets[] = ['key' => $date->format('Y-m-d'), 'label' => $date->format('D M d')];
                }
            } elseif ($grain === 'week') {
                $cursor = $periodStart->modify('monday this week')->setTime(0, 0);
                $lastDay = $periodEnd->modify('-1 day');
                while ($cursor < $periodEnd) {
                    $labelStart = max($cursor, $periodStart);
                    $labelEnd = min($cursor->modify('+6 days'), $lastDay);
                    $buckets[] = [
                        'key' => $cursor->format('Y-m-d'),
                        'label' => $labelStart->format('M d') . ' - ' . $labelEnd->format('M d')
                    ];
                    $cursor = $cursor->modify('+1 week');
                }
            } else {
                $cursor = $periodStart;
                while ($cursor < $periodEnd) {
                    $buckets[] = ['key' => $cursor->format('Y-m-01'), 'label' => $cursor->format('M Y')];
                    $cursor = $cursor->modify('+1 month');
                }
            }

            foreach ($buckets as $bucket) {
                $dateKey = $bucket['key'];
                $activity = $activityByDate[$dateKey] ?? [];
                $booksBorrowed = (int)($activity['books_borrowed'] ?? 0);
                $booksReturned = (int)($activity['books_returned'] ?? 0);
                $totalBooksBorrowed += $booksBorrowed;
                $totalBooksReturned += $booksReturned;
                $reportDates[] = [
                    'date' => $bucket['label'],
                    'books_borrowed' => $booksBorrowed,
                    'books_returned' => $booksReturned,
                    'borrowers' => (int)($activity['borrowers'] ?? 0)
                ];
            }
        }
    } catch (PDOException $e) {
        $pageError = 'Unable to load report details: ' . $e->getMessage();
    } catch (UnexpectedValueException $e) {
        $pageError = $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <?php require __DIR__ . '/lib/head.php'; ?>
</head>
<body>

<?php require __DIR__ . '/lib/header.php'; ?>

<main class="page-container">
    <section class="card">
        <a class="btn-secondary back-link" href="reports.php"><i class="bi bi-arrow-left"></i> Back to Reports</a>
        <h2 class="page-title">Report Details</h2>

        <?php if ($pageError !== ''): ?>
            <p class="alert-danger" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
        <?php elseif ($report !== null): ?>
            <p class="page-note"><?php echo htmlspecialchars((string)$report['report_type']); ?> report<?php echo $reportPeriodLabel !== '' ? ' &middot; ' . htmlspecialchars($reportPeriodLabel) : ''; ?></p>
            <dl class="report-info">
                <div>
                    <dt>Report ID</dt>
                    <dd><?php echo htmlspecialchars((string)$report['report_id']); ?></dd>
                </div>
                <div>
                    <dt>Library Staff ID</dt>
                    <dd><?php echo htmlspecialchars((string)($report['libstaff_id'] ?? 'Not assigned')); ?></dd>
                </div>
                <div>
                    <dt>Report Type</dt>
                    <dd><?php echo htmlspecialchars((string)$report['report_type']); ?></dd>
                </div>
                <div>
                    <dt>Date Generated</dt>
                    <dd><?php echo htmlspecialchars((string)($report['date_generated'] ?? 'Not recorded')); ?></dd>
                </div>
            </dl>
        <?php endif; ?>
    </section>

    <?php if ($pageError === '' && $report !== null && $reportDates !== []): ?>
        <section class="card">
            <h2 class="page-title">Summary</h2>
            <div class="report-stats">
                <div class="stat-card">
                    <div class="stat-label">Books Borrowed</div>
                    <div class="stat-value"><?php echo number_format($totalBooksBorrowed); ?></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Books Returned</div>
                    <div class="stat-value"><?php echo number_format($totalBooksReturned); ?></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Active Borrowers</div>
                    <div class="stat-value"><?php echo number_format(count($activeBorrowers)); ?></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Transactions</div>
                    <div class="stat-value"><?php echo number_format($transactionCount); ?></div>
                </div>
            </div>
        </section>

        <section class="card">
            <h2 class="page-title">Charts</h2>
            <div class="chart-grid">
                <div class="chart-box">
                    <h3>Activity by <?php echo $grainName; ?></h3>
                    <div class="chart-canvas">
                        <canvas id="dailyActivityChart" aria-label="Line chart of daily borrowed and returned books"></canvas>
                    </div>
                </div>
                <div class="chart-box">
                    <h3>Borrowed vs Returned</h3>
                    <div class="chart-canvas">
                        <canvas id="borrowReturnChart" aria-label="Doughnut chart comparing borrowed and returned books"></canvas>
                    </div>
                </div>
            </div>
        </section>

        <section class="card">
            <h2 class="page-title">Activity by <?php echo $grainName; ?>: <?php echo htmlspecialchars($reportPeriodLabel); ?></h2>
            <p class="page-note">Borrowers are counted once per <?php echo strtolower($grainName); ?>, based on distinct users who borrowed at least one book in that <?php echo strtolower($grainName); ?>.</p>
            <div class="reports-scroll">
                <table class="mini-table">
                    <thead>
                        <tr>
                            <th><?php echo $grainName; ?></th>
                            <th>Books Borrowed</th>
                            <th>Books Returned</th>
                            <th>Borrowers</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($reportDates as $dailyRow): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($dailyRow['date']); ?></td>
                                <td><?php echo htmlspecialchars((string)$dailyRow['books_borrowed']); ?></td>
                                <td><?php echo htmlspecialchars((string)$dailyRow['books_returned']); ?></td>
                                <td><?php echo htmlspecialchars((string)$dailyRow['borrowers']); ?></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="card">
            <h2 class="page-title">Transactions</h2>
            <div class="reports-scroll">
                <table class="mini-table">
                    <thead>
                        <tr>
                            <th>Borrow ID</th>
                            <th>User ID</th>
                            <th>Copy ID</th>
                            <th>Date Borrowed</th>
                            <th>Due Date</th>
                            <th>Date Returned</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if ($transactions !== []): ?>
                            <?php foreach ($transactions as $transaction): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars((string)$transaction['borrow_id']); ?></td>
                                    <td><?php echo htmlspecialchars((string)$transaction['user_id']); ?></td>
                                    <td><?php echo htmlspecialchars((string)($transaction['copy_id'] ?? '')); ?></td>
                                    <td><?php echo htmlspecialchars((string)($transaction['date_borrowed'] ?? '')); ?></td>
                                    <td><?php echo htmlspecialchars((string)($transaction['due_date'] ?? '')); ?></td>
                                    <td><?php echo htmlspecialchars((string)($transaction['date_returned'] ?? '')); ?></td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="6" class="empty-cell">No transactions in this reporting period.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </section>
    <?php endif; ?>
</main>

<?php if ($pageError === '' && $report !== null && $reportDates !== []): ?>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const reportDates = <?php echo json_encode(array_column($reportDates, 'date'), JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>;
        const borrowedCounts = <?php echo json_encode(array_column($reportDates, 'books_borrowed'), JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>;
        const returnedCounts = <?php echo json_encode(array_column($reportDates, 'books_returned'), JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>;

        Chart.defaults.font.family = "'Poppins', sans-serif";
        Chart.defaults.elements.point.hoverRadius = 5;

        new Chart(document.getElementById('dailyActivityChart'), {
            type: 'line',
            data: {
                labels: reportDates,
                datasets: [
                    {
                        label: 'Books Borrowed',
                        data: borrowedCounts,
                        borderColor: '#003580',
                        backgroundColor: 'rgba(0, 53, 128, 0.12)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.25
                    },
                    {
                        label: 'Books Returned',
                        data: returnedCounts,
                        borderColor: '#4f9bd2',
                        backgroundColor: 'rgba(79, 155, 210, 0.12)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.25
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                },
                interaction: {
                    mode: 'index',
                    intersect: false
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        });

        new Chart(document.getElementById('borrowReturnChart'), {
            type: 'doughnut',
            data: {
                labels: ['Books Borrowed', 'Books Returned'],
                datasets: [{
                    data: [<?php echo (int)$totalBooksBorrowed; ?>, <?php echo (int)$totalBooksReturned; ?>],
                    backgroundColor: ['#003580', '#4f9bd2'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '68%',
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>
<?php endif; ?>

</body>
</html>
