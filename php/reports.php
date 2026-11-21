<?php
require_once __DIR__ . '/lib/auth.php';
require_once __DIR__ . '/lib/report_period.php';
try {
    require '../db.php';
} catch (PDOException $e) {
    http_response_code(500);
    exit('Database connection failed: ' . htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8'));
}

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

$pageTitle = 'Reports';
$pageStyles = ['reports.css?v=20261121-5'];

$reports = [];
$years = [(int)date('Y')];
$selectedDate = '';
$selectedMonth = '';
$selectedYear = '';
$staffId = null;
$pageError = '';
$pageSuccess = '';
$selectedReportType = '';
$searchQuery = is_string($_GET['search'] ?? null) ? trim($_GET['search']) : '';

try {
    $staffStmt = $pdo->prepare('SELECT libstaff_id FROM library_staff WHERE user_id = ?');
    $staffStmt->execute([$_SESSION['user_id']]);
    $staffId = $staffStmt->fetchColumn();
    if ($staffId === false) {
        $staffId = null;
    }

    $currentYear = (int)date('Y');
    $minYear = (int)$pdo->query('SELECT MIN(YEAR(date_borrowed)) FROM borrows')->fetchColumn();
    if ($minYear < 2000 || $minYear > $currentYear) {
        $minYear = $currentYear;
    }
    $years = range($currentYear, $minYear);

    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST' && isset($_POST['generate_report'])) {
        $selectedReportType = is_string($_POST['report_type'] ?? null) ? $_POST['report_type'] : '';
        $selectedDate = is_string($_POST['period_date'] ?? null) ? $_POST['period_date'] : '';
        $selectedMonth = is_string($_POST['period_month'] ?? null) ? $_POST['period_month'] : '';
        $selectedYear = is_string($_POST['period_year'] ?? null) ? $_POST['period_year'] : '';
        $csrfToken = is_string($_POST['csrf_token'] ?? null) ? $_POST['csrf_token'] : '';

        if (!hash_equals($_SESSION['csrf_token'], $csrfToken)) {
            $pageError = 'Your session expired. Refresh the page and try again.';
        } elseif ($staffId === null) {
            $pageError = 'No library staff record is linked to your account.';
        } elseif (!in_array($selectedReportType, ['Weekly', 'Monthly', 'Annual'], true)) {
            $pageError = 'Choose a valid report type.';
        } else {
            $periodStart = null;
            if ($selectedReportType === 'Weekly') {
                $picked = DateTimeImmutable::createFromFormat('!Y-m-d', $selectedDate);
                if ($picked !== false && $picked->format('Y-m-d') === $selectedDate) {
                    $periodStart = $picked->modify('monday this week');
                }
            } elseif (ctype_digit($selectedYear) && (int)$selectedYear >= 2000 && (int)$selectedYear <= (int)date('Y')) {
                if ($selectedReportType === 'Annual') {
                    $periodStart = new DateTimeImmutable(sprintf('%04d-01-01', (int)$selectedYear));
                } elseif (ctype_digit($selectedMonth) && (int)$selectedMonth >= 1 && (int)$selectedMonth <= 12) {
                    $periodStart = new DateTimeImmutable(sprintf('%04d-%02d-01', (int)$selectedYear, (int)$selectedMonth));
                }
            }

            if ($periodStart === null) {
                $pageError = 'Choose a valid period.';
            } elseif ($periodStart > new DateTimeImmutable('today')) {
                $pageError = 'Choose a period that has already started.';
            } else {
                $insertStmt = $pdo->prepare(
                    'INSERT INTO reports (libstaff_id, report_type, date_generated, period_start)
                     VALUES (?, ?, CURRENT_TIMESTAMP, ?)'
                );
                $insertStmt->execute([$staffId, $selectedReportType, $periodStart->format('Y-m-d')]);

                header('Location: reports.php?generated=' . rawurlencode($pdo->lastInsertId()));
                exit;
            }
        }
    }

    $generatedId = $_GET['generated'] ?? '';
    if (is_string($generatedId) && ctype_digit($generatedId)) {
        $pageSuccess = 'Report #' . $generatedId . ' generated successfully.';
    }

    $reportsStmt = $pdo->query(
        'SELECT report_id, libstaff_id, report_type, date_generated, period_start
         FROM reports
         ORDER BY report_id DESC'
    );
    foreach ($reportsStmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
        try {
            $start = report_period_start((string)$row['report_type'], $row['period_start'], new DateTimeImmutable($row['date_generated']));
            $row['period_label'] = report_period_label((string)$row['report_type'], $start);
        } catch (Exception $labelError) {
            $row['period_label'] = '';
        }
        $haystack = implode(' ', [$row['report_id'], $row['libstaff_id'], $row['report_type'], $row['date_generated'], $row['period_label']]);
        if ($searchQuery === '' || stripos($haystack, $searchQuery) !== false) {
            $reports[] = $row;
        }
    }
} catch (PDOException $e) {
    $driverErrorCode = (int)($e->errorInfo[1] ?? 0);
    $pageError = $driverErrorCode === 4025
        ? 'The reports table is out of date. Re-import sql/booktrace.sql into the booktrace database, then try again.'
        : 'Unable to load or generate reports: ' . $e->getMessage();
}

$isPostError = $pageError !== '' && ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST';
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
        <h2 class="page-title">Reports</h2>
        <p class="page-note">Generate a report, then select a row to view its summary and charts.</p>

        <?php if ($pageError !== '' && !$isPostError): ?>
            <p class="alert-danger" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
        <?php endif; ?>
        <?php if ($pageSuccess !== ''): ?>
            <p class="alert-success" role="status"><?php echo htmlspecialchars($pageSuccess); ?></p>
        <?php endif; ?>
        <?php if ($staffId === null && $pageError === ''): ?>
            <p class="alert-danger" role="alert">No library staff record is linked to your account.</p>
        <?php endif; ?>

        <div class="reports-toolbar">
            <form method="GET" action="reports.php" class="reports-search">
                <div class="search-row">
                    <i class="bi bi-search"></i>
                    <input
                        type="text"
                        id="report-search"
                        name="search"
                        value="<?php echo htmlspecialchars($searchQuery); ?>"
                        placeholder="Report ID, staff ID, type, period or date"
                        autocomplete="off"
                    >
                </div>
                <button class="btn-primary" type="submit">Search</button>
                <?php if ($searchQuery !== ''): ?>
                    <a class="btn-secondary" href="reports.php">Clear</a>
                <?php endif; ?>
            </form>

            <div class="reports-actions">
                <form method="GET" action="view_report.php">
                    <input type="hidden" name="id" id="selected-report-id">
                    <button class="btn-secondary" type="submit" id="view-report-button" disabled>
                        <i class="bi bi-eye"></i> View Report
                    </button>
                </form>
                <button class="btn-primary" type="button" id="open-report-modal" <?php echo $staffId === null ? 'disabled' : ''; ?>>
                    <i class="bi bi-plus-lg"></i> Add Report
                </button>
            </div>
        </div>

        <div class="reports-scroll">
            <table class="mini-table">
                <thead>
                    <tr>
                        <th>Report ID</th>
                        <th>Library Staff ID</th>
                        <th>Report Type</th>
                        <th>Period</th>
                        <th>Date Generated</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($reports)): ?>
                        <?php foreach ($reports as $report): ?>
                            <tr class="selectable-row" data-report-id="<?php echo htmlspecialchars((string)$report['report_id']); ?>" tabindex="0" aria-selected="false">
                                <td><?php echo htmlspecialchars((string)$report['report_id']); ?></td>
                                <td><?php echo htmlspecialchars((string)$report['libstaff_id']); ?></td>
                                <td><?php echo htmlspecialchars((string)$report['report_type']); ?></td>
                                <td><?php echo htmlspecialchars($report['period_label']); ?></td>
                                <td><?php echo htmlspecialchars((string)$report['date_generated']); ?></td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="5" class="empty-cell">No reports found.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </section>
</main>

<dialog class="bp-dialog report-dialog" id="report-dialog" data-open="<?php echo $isPostError ? '1' : '0'; ?>">
    <form method="POST" action="reports.php" class="bp-form">
        <h3>Generate Report</h3>
        <p class="page-note">Report ID and date are assigned automatically.</p>

        <?php if ($isPostError): ?>
            <p class="alert-danger" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
        <?php endif; ?>

        <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>">

        <div class="field-group">
            <label for="report-staff-id">Library Staff ID</label>
            <input id="report-staff-id" type="text" value="<?php echo htmlspecialchars((string)$staffId); ?>" readonly>
        </div>

        <div class="field-group">
            <label for="report-type">Report Type</label>
            <select id="report-type" name="report_type" required>
                <option value="">Choose a report type</option>
                <?php foreach (['Weekly', 'Monthly', 'Annual'] as $reportType): ?>
                    <option value="<?php echo htmlspecialchars($reportType); ?>" <?php echo $selectedReportType === $reportType ? 'selected' : ''; ?>>
                        <?php echo htmlspecialchars($reportType); ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="field-group period-field" data-for="Weekly" hidden>
            <label for="period-date">Any day in the week</label>
            <input id="period-date" name="period_date" type="date" max="<?php echo date('Y-m-d'); ?>" value="<?php echo htmlspecialchars($selectedDate); ?>" disabled>
            <span class="period-hint" id="period-hint"></span>
        </div>

        <div class="field-group period-field" data-for="Monthly" hidden>
            <label for="period-month">Month</label>
            <select id="period-month" name="period_month" disabled>
                <option value="">Choose a month</option>
                <?php foreach (['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'] as $monthIndex => $monthName): ?>
                    <option value="<?php echo $monthIndex + 1; ?>" <?php echo $selectedMonth === (string)($monthIndex + 1) ? 'selected' : ''; ?>><?php echo $monthName; ?></option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="field-group period-field" data-for="Monthly Annual" hidden>
            <label for="period-year">Year</label>
            <select id="period-year" name="period_year" disabled>
                <option value="">Choose a year</option>
                <?php foreach ($years as $year): ?>
                    <option value="<?php echo $year; ?>" <?php echo $selectedYear === (string)$year ? 'selected' : ''; ?>><?php echo $year; ?></option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="actions-row">
            <button class="btn-secondary" type="button" id="cancel-report-modal">Cancel</button>
            <button class="btn-primary" type="submit" name="generate_report" value="1">Generate Report</button>
        </div>
    </form>
</dialog>

<script src="../js/reports.js"></script>

</body>
</html>
