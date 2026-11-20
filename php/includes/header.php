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
                <?php
                $hashPos = strpos($href, '#');
                $isActive = $hashPos === false && $currentPage === $href;
                $section = $hashPos === false ? '' : substr($href, $hashPos + 1);
                ?>
                <a href="<?php echo htmlspecialchars($href); ?>"<?php echo $isActive ? ' class="active" aria-current="page"' : ''; ?><?php echo $section !== '' ? ' data-section="' . htmlspecialchars($section) . '"' : ''; ?>><?php echo htmlspecialchars($label); ?></a>
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
<?php if ($currentPage === 'librarian_dashboard.php'): ?>
<script>
(function () {
    const links = Array.from(document.querySelectorAll('.table-navigation a[data-section]'));

    function setActive(id) {
        links.forEach(function (link) {
            const on = link.dataset.section === id;
            link.classList.toggle('active', on);
            if (on) {
                link.setAttribute('aria-current', 'location');
            } else {
                link.removeAttribute('aria-current');
            }
        });
    }

    function currentSection() {
        const sections = links.map(function (l) { return document.getElementById(l.dataset.section); }).filter(Boolean);
        if (sections.length === 0) {
            return '';
        }
        if (window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 2) {
            return sections[sections.length - 1].id;
        }
        let id = sections[0].id;
        sections.forEach(function (s) {
            if (s.getBoundingClientRect().top - 180 <= 0) {
                id = s.id;
            }
        });
        return id;
    }

    function update() {
        setActive(currentSection());
    }

    links.forEach(function (link) {
        link.addEventListener('click', function () {
            setActive(link.dataset.section);
        });
    });
    window.addEventListener('scroll', update, { passive: true });
    window.addEventListener('load', update);
    window.addEventListener('hashchange', update);
})();
</script>
<?php endif; ?>
