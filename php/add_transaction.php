<?php
require_once __DIR__ . '/lib/auth.php';
$pageTitle = 'Transactions';
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
        <?php require __DIR__ . '/lib/borrower_panel.php'; ?>
    </section>

    <section class="card" id="return-section">
        <h2 class="page-title">Return Books</h2>
        <p class="page-note" id="return-scope">All active borrows.</p>
        <div id="return-result" class="panel-message" hidden></div>
        <div id="return-list"></div>
    </section>

    <section class="card" id="borrow-section" hidden>
        <h2 class="page-title">Borrow a Book</h2>
        <div id="borrow-blocked" class="alert-warning" hidden></div>
        <div id="borrow-result" class="panel-message" hidden></div>
        <div id="borrow-form" hidden>
            <div class="search-row">
                <i class="bi bi-search"></i>
                <input type="text" id="copy-search" placeholder="Search available copies by title or copy ID" autocomplete="off">
            </div>
            <div id="copy-results" class="results-list" hidden></div>
            <div id="copy-selected" class="selected-copy" hidden></div>
            <p class="page-note" id="due-preview"></p>
            <div class="actions-row">
                <button type="button" class="btn-primary" id="borrow-submit" disabled>Borrow</button>
            </div>
        </div>
    </section>
</main>

<?php require __DIR__ . '/lib/confirm_dialog.php'; ?>

<script src="../js/transactions.js"></script>

</body>
</html>
