<?php
require_once __DIR__ . '/lib/auth.php';
try {
    require '../db.php';
} catch (PDOException $e) {
    http_response_code(500);
    exit('Database connection failed: ' . htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8'));
}

if (empty($_SESSION['user_id']) || !in_array($_SESSION['user_type'] ?? '', ['Librarian', 'Library Clerk'], true)) {
    header('Location: login.php');
    exit;
}

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

if (!is_string($reportId) || !ctype_digit($reportId)) {
    http_response_code(400);
    $pageError = 'A valid report ID is required.';
} else {
    try {
        $stmt = $pdo->prepare(
            'SELECT report_id, libstaff_id, report_type, date_generated
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
            $currentWeekStart = $generatedAt->modify('monday this week')->setTime(0, 0);

            switch ($report['report_type']) {
                case 'Weekly':
                    $periodStart = $currentWeekStart->modify('-1 week');
                    $periodEnd = $currentWeekStart;
                    $reportPeriodLabel = 'Previous calendar week';
                    break;
                case 'Monthly':
                    $periodStart = $generatedAt->modify('first day of this month')->setTime(0, 0);
                    $periodEnd = $periodStart->modify('+1 month');
                    $reportPeriodLabel = $generatedAt->format('F Y');
                    break;
                case 'Annual':
                    $periodStart = $generatedAt->setDate((int)$generatedAt->format('Y'), 1, 1)->setTime(0, 0);
                    $periodEnd = $periodStart->modify('+1 year');
                    $reportPeriodLabel = $generatedAt->format('Y');
                    break;
                default:
                    throw new UnexpectedValueException('This report has an unsupported report type.');
            }

            $activityStmt = $pdo->prepare(
                "SELECT activity_date,
                        SUM(event_type = 'borrowed') AS books_borrowed,
                        SUM(event_type = 'returned') AS books_returned,
                        COUNT(DISTINCT CASE WHEN event_type = 'borrowed' THEN user_id END) AS borrowers
                 FROM (
                     SELECT DATE(date_borrowed) AS activity_date, 'borrowed' AS event_type, user_id
                     FROM borrows
                     WHERE date_borrowed >= ? AND date_borrowed < ?
                     UNION ALL
                     SELECT DATE(date_returned) AS activity_date, 'returned' AS event_type, user_id
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

            $dateRange = new DatePeriod($periodStart, new DateInterval('P1D'), $periodEnd);
            foreach ($dateRange as $date) {
                $dateKey = $date->format('Y-m-d');
                $activity = $activityByDate[$dateKey] ?? [];
                $booksBorrowed = (int)($activity['books_borrowed'] ?? 0);
                $booksReturned = (int)($activity['books_returned'] ?? 0);
                $totalBooksBorrowed += $booksBorrowed;
                $totalBooksReturned += $booksReturned;
                $reportDates[] = [
                    'date' => $dateKey,
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Details - BookTrace</title>
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/reports.css?v=20261121-2">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<?php require __DIR__ . '/lib/header.php'; ?>
    <div class="dashboard-wrapper">
        <main class="main-card">
            <div class="report-action-buttons">
                <a class="back-report-link" href="reports.php">&larr; Back to Available Reports</a>
            </div>
            <h1 class="page-title detail-page-title">Report Details</h1>

            <?php if ($pageError !== ''): ?>
                <p class="notice notice-error" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
            <?php elseif ($report !== null): ?>
                <?php if ($reportDates !== []): ?>
                    <section class="report-summary" aria-labelledby="report-summary-title">
                        <h2 class="detail-section-title" id="report-summary-title">Report Summary</h2>
                        <div class="summary-cards">
                            <div class="summary-card">
                                <span class="summary-card-label">Books Borrowed</span>
                                <strong class="summary-card-value"><?php echo number_format($totalBooksBorrowed); ?></strong>
                            </div>
                            <div class="summary-card">
                                <span class="summary-card-label">Books Returned</span>
                                <strong class="summary-card-value"><?php echo number_format($totalBooksReturned); ?></strong>
                            </div>
                            <div class="summary-card">
                                <span class="summary-card-label">Active Borrowers</span>
                                <strong class="summary-card-value"><?php echo number_format(count($activeBorrowers)); ?></strong>
                            </div>
                            <div class="summary-card">
                                <span class="summary-card-label">Transactions</span>
                                <strong class="summary-card-value"><?php echo number_format($transactionCount); ?></strong>
                            </div>
                        </div>
                        <div class="summary-charts">
                            <div class="chart-card">
                                <h3>Daily Activity</h3>
                                <canvas id="dailyActivityChart" aria-label="Line chart of daily borrowed and returned books"></canvas>
                            </div>
                            <div class="chart-card chart-card-small">
                                <h3>Borrowed vs. Returned</h3>
                                <canvas id="borrowReturnChart" aria-label="Doughnut chart comparing borrowed and returned books"></canvas>
                            </div>
                        </div>
                    </section>
                <?php endif; ?>

                <dl class="report-details">
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
                        <dt>Date and Time Generated</dt>
                        <dd><?php echo htmlspecialchars((string)($report['date_generated'] ?? 'Not recorded')); ?></dd>
                    </div>
                </dl>

                <?php if ($reportDates !== []): ?>
                    <section class="report-activity">
                        <h2 class="detail-section-title">Daily Activity: <?php echo htmlspecialchars($reportPeriodLabel); ?></h2>
                        <p class="activity-period-note">
                            Borrowers are counted once per day based on distinct users who borrowed at least one book that day.
                        </p>
                        <div class="table-responsive">
                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>Date</th>
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

                        <h2 class="detail-section-title">TRANSACTIONS</h2>
                        <div class="table-responsive">
                            <table class="dashboard-table">
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
                                            <td colspan="6" class="empty-state">No transactions in this reporting period.</td>
                                        </tr>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </section>
                <?php endif; ?>
            <?php endif; ?>
        </main>
    </div>

    <?php if ($reportDates !== []): ?>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            const reportDates = <?php echo json_encode(array_column($reportDates, 'date'), JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>;
            const borrowedCounts = <?php echo json_encode(array_column($reportDates, 'books_borrowed'), JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>;
            const returnedCounts = <?php echo json_encode(array_column($reportDates, 'books_returned'), JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>;

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
                    scales: {
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
