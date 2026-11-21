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

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

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
        ? 'The reports table still restricts report types. Import sql/upgrade_report_generation.sql into the booktrace database, then try again.'
        : 'Unable to load or generate reports: ' . $e->getMessage();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Reports - BookTrace</title>
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/reports.css?v=20261121-2">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<?php require __DIR__ . '/lib/header.php'; ?>
    <div class="dashboard-wrapper">
        <div class="main-card">
            <div class="card-header-row">
                <h1 class="page-title">Available Reports</h1>
                <div class="report-header-actions">
                    <button class="add-btn" type="button" id="open-report-modal" <?php echo $staffId === null ? 'disabled' : ''; ?>>
                        + Add Report
                    </button>
                </div>
            </div>

            <?php if ($pageError !== ''): ?>
                <p class="notice notice-error" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
            <?php endif; ?>
            <?php if ($pageSuccess !== ''): ?>
                <p class="notice notice-success" role="status"><?php echo htmlspecialchars($pageSuccess); ?></p>
            <?php endif; ?>
            <?php if ($staffId === null && $pageError === ''): ?>
                <p class="notice notice-error" role="alert">No library staff record is linked to your account.</p>
            <?php endif; ?>

            <div class="table-toolbar">
                <form method="GET" action="reports.php" class="report-search">
                    <label class="sr-only" for="report-search">Search all report fields</label>
                    <input
                        type="search"
                        id="report-search"
                        name="search"
                        value="<?php echo htmlspecialchars($searchQuery); ?>"
                        placeholder="Search reports by ID, staff, type, or date..."
                    >
                    <button class="search-btn" type="submit">Search</button>
                    <?php if ($searchQuery !== ''): ?>
                        <a class="clear-search-btn" href="reports.php">Clear</a>
                    <?php endif; ?>
                </form>

                <form method="GET" action="view_report.php" class="view-report-form">
                    <input type="hidden" name="id" id="selected-report-id">
                    <button class="view-report-btn" type="submit" id="view-report-button" disabled>View Report</button>
                </form>
            </div>

            <div class="table-responsive">
                <table class="dashboard-table">
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
                                    <td colspan="4" class="empty-state">No records found.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="report-modal" aria-hidden="true">
        <section class="report-modal" role="dialog" aria-modal="true" aria-labelledby="report-modal-title">
            <div class="modal-header">
                <div>
                    <h2 id="report-modal-title">Generate Report</h2>
                    <p>Report ID and generation date/time are assigned automatically.</p>
                </div>
                <button class="modal-close" type="button" id="close-report-modal" aria-label="Close">&times;</button>
            </div>

            <form method="POST" class="report-form">
                <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>">

                <label for="report-staff-id">Library Staff ID</label>
                <input id="report-staff-id" type="text" value="<?php echo htmlspecialchars((string)$staffId); ?>" readonly>

                <label for="report-generated-at">Date and Time</label>
                <input id="report-generated-at" type="text" value="Set automatically when generated" readonly>

                <label for="report-id">Report ID</label>
                <input id="report-id" type="text" value="Assigned automatically by the database" readonly>

                <label for="report-type">Report Type</label>
                <select id="report-type" name="report_type" required>
                    <option value="">Choose a report type</option>
                    <?php foreach (['Weekly', 'Monthly', 'Annual'] as $reportType): ?>
                        <option value="<?php echo htmlspecialchars($reportType); ?>" <?php echo $selectedReportType === $reportType ? 'selected' : ''; ?>>
                            <?php echo htmlspecialchars($reportType); ?>
                        </option>
                    <?php endforeach; ?>
                </select>

                <div class="modal-actions">
                    <button class="cancel-btn" type="button" id="cancel-report-modal">Cancel</button>
                    <button class="generate-btn" type="submit" name="generate_report" value="1">Generate Report</button>
                </div>
            </form>
        </section>
    </div>

    <script>
        const reportModal = document.getElementById('report-modal');
        const reportType = document.getElementById('report-type');

        function openReportModal() {
            reportModal.classList.add('is-open');
            reportModal.setAttribute('aria-hidden', 'false');
            reportType.focus();
        }

        function closeReportModal() {
            reportModal.classList.remove('is-open');
            reportModal.setAttribute('aria-hidden', 'true');
        }

        document.getElementById('open-report-modal').addEventListener('click', openReportModal);
        document.getElementById('close-report-modal').addEventListener('click', closeReportModal);
        document.getElementById('cancel-report-modal').addEventListener('click', closeReportModal);

        const selectedReportId = document.getElementById('selected-report-id');
        const viewReportButton = document.getElementById('view-report-button');

        function selectReportRow(row) {
            selectedReportId.value = row.dataset.reportId;
            viewReportButton.disabled = false;
            document.querySelectorAll('.selectable-row').forEach(function (otherRow) {
                otherRow.classList.toggle('selected-row', otherRow === row);
                otherRow.setAttribute('aria-selected', otherRow === row ? 'true' : 'false');
            });
        }

        document.querySelectorAll('.selectable-row').forEach(function (row) {
            row.addEventListener('click', function () {
                selectReportRow(row);
            });
            row.addEventListener('keydown', function (event) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    selectReportRow(row);
                }
            });
        });

        reportModal.addEventListener('click', function (event) {
            if (event.target === reportModal) {
                closeReportModal();
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape' && reportModal.classList.contains('is-open')) {
                closeReportModal();
            }
        });

        <?php if ($pageError !== '' && ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST'): ?>
            openReportModal();
        <?php endif; ?>
    </script>
</body>
</html>
