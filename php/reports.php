<?php
$host = 'localhost';
$dbname = 'queryshelf';
$username = 'root'; 
$password = '';     

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $stmt = $pdo->query("SELECT report_id, libclerk_id, report_type, date_generated FROM reports");
    $reports = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Clerk Dashboard - Reports</title>
    <link rel="stylesheet" href="../css/reports.css">
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body>

    <div class="dashboard-wrapper">
        <div class="top-navbar">
            <a href="tables.php" class="nav-btn">TABLES</a>
            <a href="reports.php" class="nav-btn active">REPORTS</a>
            <a href="publications.php" class="nav-btn">PUBLICATIONS</a>
            <a href="borrow_history.php" class="nav-btn">BORROW HISTORY</a>
        </div>

        <div class="main-card">
            <div class="card-header-row">
                <h1 class="page-title">Available Reports</h1>
                <button class="add-btn">+ Add Report</button>
            </div>

            <div class="table-responsive">
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>Report ID</th>
                            <th>Clerk ID</th>
                            <th>Report Type</th>
                            <th>Date Generated</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($reports)): ?>
                            <?php foreach ($reports as $report): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($report['report_id']); ?></td>
                                    <td><?php echo htmlspecialchars($report['libclerk_id']); ?></td>
                                    <td><?php echo htmlspecialchars($report['report_type']); ?></td>
                                    <td><?php echo htmlspecialchars($report['date_generated']); ?></td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="4" style="text-align: center; color: #757575;">No records found.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>