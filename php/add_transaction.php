<?php
require_once __DIR__ . '/includes/auth.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transactions | BookTrace</title>
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/transactions.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<?php require __DIR__ . '/includes/header.php'; ?>

<main class="page-container">
    <section class="card">
        <?php require __DIR__ . '/includes/borrower_panel.php'; ?>
    </section>

    <section class="card" id="return-section">
        <h2 class="page-title"><i class="bi bi-box-arrow-in-down"></i> Return Books</h2>
        <p class="page-note" id="return-scope">All active borrows.</p>
        <div id="return-result" class="panel-message" hidden></div>
        <div id="return-list"></div>
    </section>

    <section class="card" id="borrow-section" hidden>
        <h2 class="page-title"><i class="bi bi-box-arrow-up"></i> Borrow a Book</h2>
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

<?php require __DIR__ . '/includes/confirm_dialog.php'; ?>

<script>
(function () {
    const api = 'transactions_api.php';
    const returnScope = document.getElementById('return-scope');
    const returnResult = document.getElementById('return-result');
    const returnList = document.getElementById('return-list');
    const borrowSection = document.getElementById('borrow-section');
    const borrowBlocked = document.getElementById('borrow-blocked');
    const borrowResult = document.getElementById('borrow-result');
    const borrowForm = document.getElementById('borrow-form');
    const copySearch = document.getElementById('copy-search');
    const copyResults = document.getElementById('copy-results');
    const copySelected = document.getElementById('copy-selected');
    const duePreview = document.getElementById('due-preview');
    const borrowSubmit = document.getElementById('borrow-submit');
    let borrower = null;
    let chosen = [];
    let slots = 0;
    let copyTimer = null;

    function esc(value) {
        const d = document.createElement('div');
        d.textContent = value === null || value === undefined ? '' : String(value);
        return d.innerHTML;
    }

    function formatDateTime(value) {
        const d = new Date(String(value).replace(' ', 'T'));
        return isNaN(d) ? esc(value) : d.toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });
    }

    function peso(value) {
        return '₱' + Number(value).toFixed(2);
    }

    function show(box, text, kind) {
        box.textContent = text;
        box.className = 'panel-message ' + (kind || 'info');
        box.hidden = text === '';
    }

    async function getJson(params) {
        try {
            const res = await fetch(api + '?' + new URLSearchParams(params), { credentials: 'same-origin' });
            return await res.json();
        } catch (e) {
            return { ok: false, error: 'Could not reach the server. Please log in again and retry.' };
        }
    }

    async function postJson(data) {
        try {
            const res = await fetch(api, { method: 'POST', body: new URLSearchParams(data), credentials: 'same-origin' });
            return await res.json();
        } catch (e) {
            return { ok: false, error: 'Could not reach the server. Please log in again and retry.' };
        }
    }

    async function loadReturns() {
        const params = { action: 'active' };
        if (borrower) {
            params.borrower_id = borrower.borrower_id;
        }
        const data = await getJson(params);
        if (!data.ok) {
            returnList.innerHTML = '';
            show(returnResult, data.error, 'error');
            return;
        }
        returnScope.textContent = borrower ? 'Active borrows of ' + borrower.name + '.' : 'All active borrows.';
        if (data.borrows.length === 0) {
            returnList.innerHTML = '<p class="empty-cell">No active borrows.</p>';
            return;
        }
        const showWho = !borrower;
        returnList.innerHTML = '<table class="mini-table"><thead><tr><th>Transaction</th>' +
            (showWho ? '<th>Borrower</th>' : '') +
            '<th>Title</th><th>Copy</th><th>Due</th><th>Hours Late</th><th>Fine Now</th><th></th></tr></thead><tbody>' +
            data.borrows.map(b =>
                '<tr><td>' + esc(b.borrow_id) + '</td>' +
                (showWho ? '<td>' + esc(b.borrower_name) + '<br><span class="muted">' + esc(b.borrower_id) + '</span></td>' : '') +
                '<td>' + esc(b.title) + '</td><td>' + esc(b.copy_id) + '</td><td>' + formatDateTime(b.due_date) + '</td>' +
                '<td>' + (Number(b.hours_late) > 0 ? '<span class="tag tag-red">' + esc(b.hours_late) + '</span>' : '0') + '</td>' +
                '<td>' + peso(b.fine_now) + '</td>' +
                '<td><button type="button" class="btn-secondary return-btn" data-id="' + esc(b.borrow_id) +
                '" data-hours="' + esc(b.hours_late) + '" data-fine="' + esc(b.fine_now) + '">Return</button></td></tr>'
            ).join('') + '</tbody></table>';
    }

    function refresh() {
        if (borrower) {
            document.dispatchEvent(new CustomEvent('borrower:refresh'));
        } else {
            loadReturns();
        }
    }

    returnList.addEventListener('click', async (e) => {
        const btn = e.target.closest('.return-btn');
        if (!btn) {
            return;
        }
        const hours = Number(btn.dataset.hours);
        const fine = Number(btn.dataset.fine);
        const late = hours > 0 && fine > 0;
        const choice = await bpConfirm({
            title: 'Return Book',
            message: late
                ? 'Return ' + btn.dataset.id + ' now?\nIt is ' + hours + ' hour(s) late. Fine: about ' + peso(fine) + '.\nCollect the payment now, or leave the fine unpaid for later.'
                : 'Return ' + btn.dataset.id + ' now?',
            buttons: late
                ? [
                    { label: 'Return, Pay Later', value: 'later', kind: 'secondary' },
                    { label: 'Return and Collect Payment', value: 'pay', kind: 'primary' }
                ]
                : [{ label: 'Return', value: 'later', kind: 'primary' }]
        });
        if (!choice) {
            return;
        }
        btn.disabled = true;
        const res = await postJson({ action: 'return', borrow_id: btn.dataset.id, pay: choice === 'pay' ? '1' : '0' });
        if (!res.ok) {
            show(returnResult, res.error, 'error');
            btn.disabled = false;
            return;
        }
        if (res.fine_id && res.paid) {
            show(returnResult, 'Returned ' + res.transaction_id + '. Fine ' + res.fine_id + ' of ' + peso(res.fine_amount) + ' collected and recorded as Paid (' + res.hours_late + ' hour(s) late).', 'success');
        } else if (res.fine_id) {
            show(returnResult, 'Returned ' + res.transaction_id + '. Fine ' + res.fine_id + ' of ' + peso(res.fine_amount) + ' recorded as Unpaid (' + res.hours_late + ' hour(s) late). The borrower cannot borrow until it is paid.', 'error');
        } else {
            show(returnResult, 'Returned ' + res.transaction_id + '. No fine.', 'success');
        }
        refresh();
    });

    function renderChosen() {
        if (chosen.length === 0) {
            copySelected.hidden = true;
            copySelected.innerHTML = '';
        } else {
            copySelected.innerHTML = '<div class="chip-list">' + chosen.map(c =>
                '<span class="chip"><strong>' + esc(c.title) + '</strong> <span class="muted">' + esc(c.id) + '</span>' +
                '<button type="button" class="chip-remove" data-id="' + esc(c.id) + '" aria-label="Remove">&times;</button></span>'
            ).join('') + '</div><p class="page-note slot-note">' + chosen.length + ' of ' + slots + ' available slot(s) used.</p>';
            copySelected.hidden = false;
        }
        const full = chosen.length >= slots;
        copySearch.disabled = full;
        copySearch.placeholder = full ? 'Limit reached' : 'Search available copies by title or copy ID';
        borrowSubmit.disabled = chosen.length === 0;
        borrowSubmit.textContent = chosen.length > 1 ? 'Borrow ' + chosen.length + ' Books' : 'Borrow';
    }

    function resetCopyStep() {
        chosen = [];
        copySearch.value = '';
        copyResults.hidden = true;
        copyResults.innerHTML = '';
        renderChosen();
    }

    async function loadDuePreview() {
        const data = await getJson({ action: 'policy' });
        duePreview.textContent = data.ok
            ? 'If borrowed now, due ' + formatDateTime(data.policy.due_preview) + ' (' + data.policy.loan_period_days + ' day loan).'
            : '';
    }

    async function searchCopies() {
        const q = copySearch.value.trim();
        const data = await getJson({ action: 'copies', q: q });
        if (!data.ok || copySearch.value.trim() !== q) {
            return;
        }
        if (data.copies.length === 0) {
            copyResults.innerHTML = '<div class="no-match"><p>No copy found.</p></div>';
        } else {
            copyResults.innerHTML = data.copies.map(c =>
                '<button type="button" class="result-row" data-id="' + esc(c.copy_id) + '" data-title="' + esc(c.title) + '"' + (c.selectable ? '' : ' disabled') + '>' +
                '<span class="result-name">' + esc(c.title) + '</span>' +
                '<span class="result-meta">' + esc(c.copy_id) + ' &middot; ' + esc(c.shelf_location) +
                (c.due_back ? ' &middot; Due back ' + formatDateTime(c.due_back) : '') + '</span>' +
                '<span class="tag ' + (c.selectable ? 'tag-green' : 'tag-grey') + '">' + esc(c.label) + '</span></button>'
            ).join('');
        }
        copyResults.hidden = false;
    }

    copySearch.addEventListener('input', () => {
        clearTimeout(copyTimer);
        copyTimer = setTimeout(searchCopies, 250);
    });

    copyResults.addEventListener('click', (e) => {
        const row = e.target.closest('.result-row');
        if (!row || row.disabled) {
            return;
        }
        if (chosen.length < slots && !chosen.some(c => c.id === row.dataset.id)) {
            chosen.push({ id: row.dataset.id, title: row.dataset.title });
        }
        copyResults.hidden = true;
        copySearch.value = '';
        renderChosen();
        if (!copySearch.disabled) {
            copySearch.focus();
        }
    });

    copySelected.addEventListener('click', (e) => {
        const btn = e.target.closest('.chip-remove');
        if (!btn) {
            return;
        }
        chosen = chosen.filter(c => c.id !== btn.dataset.id);
        renderChosen();
    });

    borrowSubmit.addEventListener('click', async () => {
        if (!borrower || chosen.length === 0) {
            return;
        }
        borrowSubmit.disabled = true;
        const titles = Object.fromEntries(chosen.map(c => [c.id, c.title]));
        const res = await postJson({ action: 'borrow', borrower_id: borrower.borrower_id, copy_ids: chosen.map(c => c.id).join(',') });
        if (!res.ok) {
            show(borrowResult, res.error, 'error');
            borrowSubmit.disabled = false;
            return;
        }
        const lines = res.results.map(r => r.ok
            ? 'Borrowed ' + titles[r.copy_id] + ' (' + r.copy_id + '): ' + r.transaction_id + ', due ' + formatDateTime(r.due_date) + '.'
            : 'Not borrowed ' + titles[r.copy_id] + ' (' + r.copy_id + '): ' + r.error);
        show(borrowResult, lines.join('\n'), res.results.every(r => r.ok) ? 'success' : 'error');
        resetCopyStep();
        refresh();
    });

    document.addEventListener('borrower:selected', (e) => {
        const d = e.detail;
        if (!borrower || borrower.borrower_id !== d.borrower_id) {
            show(borrowResult, '', 'info');
            show(returnResult, '', 'info');
        }
        borrower = d;
        slots = Math.max(0, Number(d.max_books) - Number(d.active_borrows));
        borrowSection.hidden = false;
        resetCopyStep();
        if (d.verdict === 'Blocked') {
            borrowForm.hidden = true;
            borrowBlocked.innerHTML = '<strong>Cannot borrow.</strong><ul>' + d.reasons.map(r => '<li>' + esc(r) + '</li>').join('') + '</ul>';
            borrowBlocked.hidden = false;
        } else {
            borrowBlocked.hidden = true;
            borrowForm.hidden = false;
            loadDuePreview();
        }
        loadReturns();
    });

    document.addEventListener('borrower:cleared', () => {
        borrower = null;
        borrowSection.hidden = true;
        show(borrowResult, '', 'info');
        show(returnResult, '', 'info');
        loadReturns();
    });

    loadReturns();
})();
</script>

</body>
</html>
