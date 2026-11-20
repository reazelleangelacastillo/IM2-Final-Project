<?php
require_once __DIR__ . '/includes/auth.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fines | BookTrace</title>
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/transactions.css">
    <link rel="stylesheet" href="../css/fines.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<?php require __DIR__ . '/includes/header.php'; ?>

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
        <h2 class="page-title"><i class="bi bi-hourglass-split"></i> Overdue now</h2>
        <p class="page-note">Books overdue and not yet returned. These are not fines yet. A fine is recorded when the book is returned.</p>
        <div class="table-wrap" id="overdue-list"></div>
    </section>
</main>

<script>
(function () {
    const api = 'fines_api.php';
    const summaryGrid = document.getElementById('summary-grid');
    const filterRow = document.getElementById('filter-row');
    const searchInput = document.getElementById('fine-search');
    const resultBox = document.getElementById('fine-result');
    const fineList = document.getElementById('fine-list');
    const overdueList = document.getElementById('overdue-list');
    let filter = 'All';
    let timer = null;

    function esc(value) {
        const d = document.createElement('div');
        d.textContent = value === null || value === undefined ? '' : String(value);
        return d.innerHTML;
    }

    function formatDateTime(value) {
        if (!value) {
            return '';
        }
        const d = new Date(String(value).replace(' ', 'T'));
        return isNaN(d) ? esc(value) : d.toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });
    }

    function peso(value) {
        return '₱' + Number(value).toFixed(2);
    }

    function show(text, kind) {
        resultBox.textContent = text;
        resultBox.className = 'panel-message ' + (kind || 'info');
        resultBox.hidden = text === '';
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

    async function loadSummary() {
        const data = await getJson({ action: 'summary' });
        if (!data.ok) {
            summaryGrid.innerHTML = '';
            return;
        }
        const s = data.summary;
        summaryGrid.innerHTML =
            '<div class="summary-card"><div class="summary-label">Unpaid fines</div><div class="summary-value">' + peso(s.unpaid_total) +
            '</div><div class="summary-sub">' + s.unpaid_count + ' fine(s)</div></div>' +
            '<div class="summary-card"><div class="summary-label">Paid fines</div><div class="summary-value">' + peso(s.paid_total) +
            '</div><div class="summary-sub">' + s.paid_count + ' fine(s)</div></div>' +
            '<div class="summary-card"><div class="summary-label">Borrowers with unpaid fines</div><div class="summary-value">' + s.borrowers_with_unpaid +
            '</div><div class="summary-sub">Blocked from borrowing</div></div>';
    }

    async function loadFines() {
        const data = await getJson({ action: 'list', status: filter, q: searchInput.value.trim() });
        if (!data.ok) {
            fineList.innerHTML = '';
            show(data.error, 'error');
            return;
        }
        if (data.fines.length === 0) {
            fineList.innerHTML = '<p class="empty-cell">No fines found.</p>';
            return;
        }
        fineList.innerHTML = '<table class="mini-table"><thead><tr><th>Fine</th><th>Transaction</th><th>Borrower</th><th>Title</th>' +
            '<th>Hours late</th><th>Rate</th><th>Amount</th><th>Assessed</th><th>Status</th><th>Paid on</th><th></th></tr></thead><tbody>' +
            data.fines.map(f =>
                '<tr><td>' + esc(f.fine_id) + '</td><td>' + esc(f.borrow_id) + '</td>' +
                '<td>' + esc(f.borrower_name) + '<br><span class="muted">' + esc(f.borrower_id) + '</span></td>' +
                '<td>' + esc(f.title) + '</td><td>' + esc(f.hours_late) + '</td><td>' + peso(f.rate_applied) + '/hr</td>' +
                '<td>' + peso(f.amount) + '</td><td>' + formatDateTime(f.date_assessed) + '</td>' +
                '<td><span class="tag ' + (f.status === 'Paid' ? 'tag-green' : 'tag-red') + '">' + esc(f.status) + '</span></td>' +
                '<td>' + formatDateTime(f.date_paid) + '</td>' +
                '<td>' + (f.status === 'Unpaid'
                    ? '<button type="button" class="btn-secondary pay-btn" data-id="' + esc(f.fine_id) + '" data-amount="' + esc(f.amount) +
                      '" data-name="' + esc(f.borrower_name) + '">Mark as Paid</button>'
                    : '') + '</td></tr>'
            ).join('') + '</tbody></table>';
    }

    async function loadOverdue() {
        const data = await getJson({ action: 'overdue' });
        if (!data.ok) {
            overdueList.innerHTML = '';
            return;
        }
        if (data.overdue.length === 0) {
            overdueList.innerHTML = '<p class="empty-cell">No overdue books right now.</p>';
            return;
        }
        overdueList.innerHTML = '<table class="mini-table"><thead><tr><th>Transaction</th><th>Borrower</th><th>Title</th><th>Copy</th>' +
            '<th>Due</th><th>Hours late</th><th>Fine so far</th></tr></thead><tbody>' +
            data.overdue.map(o =>
                '<tr><td>' + esc(o.transaction_id) + '</td>' +
                '<td>' + esc(o.borrower_name) + '<br><span class="muted">' + esc(o.borrower_id) + '</span></td>' +
                '<td>' + esc(o.title) + '</td><td>' + esc(o.copy_id) + '</td><td>' + formatDateTime(o.due_date) + '</td>' +
                '<td><span class="tag tag-red">' + esc(o.hours_late) + '</span></td><td>' + peso(o.live_fine) + '</td></tr>'
            ).join('') + '</tbody></table>';
    }

    function reloadAll() {
        loadSummary();
        loadFines();
        loadOverdue();
    }

    filterRow.addEventListener('click', (e) => {
        const btn = e.target.closest('.filter-btn');
        if (!btn) {
            return;
        }
        filter = btn.dataset.filter;
        filterRow.querySelectorAll('.filter-btn').forEach(b => b.classList.toggle('active', b === btn));
        loadFines();
    });

    searchInput.addEventListener('input', () => {
        clearTimeout(timer);
        timer = setTimeout(loadFines, 250);
    });

    fineList.addEventListener('click', async (e) => {
        const btn = e.target.closest('.pay-btn');
        if (!btn) {
            return;
        }
        if (!window.confirm('Mark fine ' + btn.dataset.id + ' (' + peso(btn.dataset.amount) + ', ' + btn.dataset.name + ') as paid?')) {
            return;
        }
        btn.disabled = true;
        const res = await postJson({ action: 'pay', fine_id: btn.dataset.id });
        if (!res.ok) {
            show(res.error, 'error');
            btn.disabled = false;
            reloadAll();
            return;
        }
        show('Fine ' + res.fine_id + ' marked as paid.', 'success');
        reloadAll();
    });

    reloadAll();
})();
</script>

</body>
</html>
