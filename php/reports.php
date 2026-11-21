<?php
require_once __DIR__ . '/lib/auth.php';
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
$pageStyles = ['reports.css?v=20261121-4'];

$reports = [];
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

    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST' && isset($_POST['generate_report'])) {
        $selectedReportType = is_string($_POST['report_type'] ?? null) ? $_POST['report_type'] : '';
        $csrfToken = is_string($_POST['csrf_token'] ?? null) ? $_POST['csrf_token'] : '';

        if (!hash_equals($_SESSION['csrf_token'], $csrfToken)) {
            $pageError = 'Your session expired. Refresh the page and try again.';
        } elseif ($staffId === null) {
            $pageError = 'No library staff record is linked to your account.';
        } elseif (!in_array($selectedReportType, ['Weekly', 'Monthly', 'Annual'], true)) {
            $pageError = 'Choose a valid report type.';
        } else {
            $insertStmt = $pdo->prepare(
                'INSERT INTO reports (libstaff_id, report_type, date_generated)
                 VALUES (?, ?, CURRENT_TIMESTAMP)'
            );
            $insertStmt->execute([$staffId, $selectedReportType]);

            header('Location: reports.php?generated=' . rawurlencode($pdo->lastInsertId()));
            exit;
        }
    }

    $generatedId = $_GET['generated'] ?? '';
    if (is_string($generatedId) && ctype_digit($generatedId)) {
        $pageSuccess = 'Report #' . $generatedId . ' generated successfully.';
    }

    if ($searchQuery !== '') {
        $reportsStmt = $pdo->prepare(
            "SELECT report_id, libstaff_id, report_type, date_generated
             FROM reports
             WHERE CAST(report_id AS CHAR) LIKE ?
                OR COALESCE(libstaff_id, '') LIKE ?
                OR report_type LIKE ?
                OR COALESCE(DATE_FORMAT(date_generated, '%Y-%m-%d %H:%i:%s'), '') LIKE ?
             ORDER BY report_id DESC"
        );
        $searchTerm = '%' . $searchQuery . '%';
        $reportsStmt->execute([$searchTerm, $searchTerm, $searchTerm, $searchTerm]);
    } else {
        $reportsStmt = $pdo->query(
            'SELECT report_id, libstaff_id, report_type, date_generated
             FROM reports
             ORDER BY report_id DESC'
        );
    }
    $reports = $reportsStmt->fetchAll(PDO::FETCH_ASSOC);
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
                        placeholder="Report ID, staff ID, type or date"
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
                                <td><?php echo htmlspecialchars((string)$report['date_generated']); ?></td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="4" class="empty-cell">No reports found.</td>
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

        <div class="actions-row">
            <button class="btn-secondary" type="button" id="cancel-report-modal">Cancel</button>
            <button class="btn-primary" type="submit" name="generate_report" value="1">Generate Report</button>
        </div>
    </form>
</dialog>

<script src="../js/reports.js"></script>

</body>
</html>
