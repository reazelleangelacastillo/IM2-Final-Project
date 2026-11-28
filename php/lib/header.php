<?php
$currentPage = basename($_SERVER['PHP_SELF']);
if ($currentPage === 'view_report.php') {
    $currentPage = 'reports.php';
}
$currentView = ($_GET['view'] ?? '') === 'periodicals' ? 'periodicals' : 'books';
$navItems = [
    'librarian_dashboard.php?view=books' => 'Books',
    'librarian_dashboard.php?view=periodicals' => 'Periodicals',
    'add_transaction.php' => 'Transactions',
    'fines.php' => 'Fines',
    'policy.php' => 'Borrowing Policy',
    'reports.php' => 'Reports',
];
if (($_SESSION['user_type'] ?? '') === 'Librarian') {
    $navItems['staff.php'] = 'Staff';
}
?>
<header class="topbar">
    <div class="brand-navigation">
        <div class="logo-section">
            <h1>BookTrace</h1>
            <p class="eyebrow">Staff Panel</p>
        </div>
        <details class="navigation-menu">
            <summary class="navigation-toggle">
                <span class="book-stack-icon" aria-hidden="true">
                    <span></span>
                    <span></span>
                    <span></span>
                </span>
                <span>Menu</span>
            </summary>
            <nav class="table-navigation" aria-label="Main navigation">
                <p class="navigation-heading">Main menu</p>
                <?php foreach ($navItems as $href => $label): ?>
                    <?php
                    $navFile = strtok($href, '?');
                    $navQuery = (string) parse_url($href, PHP_URL_QUERY);
                    parse_str($navQuery, $navParams);
                    $isActive = $navFile === $currentPage && ($navQuery === '' || ($navParams['view'] ?? '') === $currentView);
                    ?>
                    <a href="<?php echo htmlspecialchars($href); ?>"<?php echo $isActive ? ' class="active" aria-current="page"' : ''; ?>><?php echo htmlspecialchars($label); ?></a>
                <?php endforeach; ?>
            </nav>
        </details>
    </div>

    <div class="header-actions">
        <span class="staff-identity">
            <?php echo htmlspecialchars($_SESSION['user_name']); ?> (<?php echo htmlspecialchars($_SESSION['user_type']); ?>)
        </span>
        <a href="logout.php" class="back-btn">
            <i class="bi bi-box-arrow-right"></i>
            Logout
        </a>
    </div>
</header>
