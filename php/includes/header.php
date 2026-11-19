<?php
$currentPage = basename($_SERVER['PHP_SELF']);
$navItems = [
    'librarian_dashboard.php#books-table' => 'Books',
    'librarian_dashboard.php#periodicals-table' => 'Periodicals',
    'add_transaction.php' => 'Transactions',
    'fines.php' => 'Fines',
    'policy.php' => 'Borrowing Policy',
    'reports.php' => 'Reports',
];
?>
<header class="topbar">
    <div class="brand-navigation">
        <div class="logo-section">
            <h1>BookTrace</h1>
            <p class="eyebrow">Staff Panel</p>
        </div>
        <nav class="table-navigation" aria-label="Main navigation">
            <?php foreach ($navItems as $href => $label): ?>
                <?php $isActive = strpos($href, '#') === false && $currentPage === $href; ?>
                <a href="<?php echo htmlspecialchars($href); ?>"<?php echo $isActive ? ' class="active" aria-current="page"' : ''; ?>><?php echo htmlspecialchars($label); ?></a>
            <?php endforeach; ?>
        </nav>
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
