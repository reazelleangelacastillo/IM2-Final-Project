<?php
require_once __DIR__ . '/lib/auth.php';
$pageTitle = 'Fines';
$pageStyles = ['fines.css'];
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
        <h2 class="page-title"><i class="bi bi-cash-coin"></i> Fines</h2>
        <p class="page-note">Fines are recorded when an overdue book is returned.</p>
        <div class="summary-grid" id="summary-grid"></div>
    </section>

    <section class="card">
        <div class="fines-toolbar">
            <div class="filter-row" id="filter-row">
                <button type="button" class="filter-btn active" data-filter="All">All</button>
                <button type="button" class="filter-btn" data-filter="Unpaid">Unpaid</button>
                <button type="button" class="filter-btn" data-filter="Paid">Paid</button>
            </div>
            <div class="search-row toolbar-search">
                <i class="bi bi-search"></i>
                <input type="text" id="fine-search" placeholder="Borrower, borrower ID, fine ID or transaction" autocomplete="off">
            </div>
        </div>
        <div id="fine-result" class="panel-message" hidden></div>
        <div class="table-wrap" id="fine-list"></div>
    </section>

    <section class="card">
        <h2 class="page-title"><i class="bi bi-hourglass-split"></i> Overdue Now</h2>
        <p class="page-note">Books overdue and not yet returned. These are not fines yet. A fine is recorded when the book is returned.</p>
        <div class="table-wrap" id="overdue-list"></div>
    </section>
</main>

<?php require __DIR__ . '/lib/confirm_dialog.php'; ?>

<script src="../js/fines.js"></script>

</body>
</html>
