(function () {
    const api = 'fines_api.php';
    const { esc, formatDateTime, peso } = window.helpers;
    const { getJson, postJson } = window.helpers.api(api);
    const summaryGrid = document.getElementById('summary-grid');
    const filterRow = document.getElementById('filter-row');
    const searchInput = document.getElementById('fine-search');
    const resultBox = document.getElementById('fine-result');
    const fineList = document.getElementById('fine-list');
    const overdueList = document.getElementById('overdue-list');
    let filter = 'All';
    let timer = null;

    function show(text, kind) {
        window.helpers.show(resultBox, text, kind);
    }

    async function loadSummary() {
        const data = await getJson({ action: 'summary' });
        if (!data.ok) {
            summaryGrid.innerHTML = '';
            return;
        }
        const s = data.summary;
        summaryGrid.innerHTML =
            '<div class="summary-card"><div class="summary-label">Unpaid Fines</div><div class="summary-value">' + peso(s.unpaid_total) +
            '</div><div class="summary-sub">' + s.unpaid_count + ' fine(s)</div></div>' +
            '<div class="summary-card"><div class="summary-label">Paid Fines</div><div class="summary-value">' + peso(s.paid_total) +
            '</div><div class="summary-sub">' + s.paid_count + ' fine(s)</div></div>' +
            '<div class="summary-card"><div class="summary-label">Borrowers with Unpaid Fines</div><div class="summary-value">' + s.borrowers_with_unpaid +
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
            '<th>Hours Late</th><th>Rate</th><th>Amount</th><th>Assessed</th><th>Status</th><th>Paid On</th><th></th></tr></thead><tbody>' +
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
            '<th>Due</th><th>Hours Late</th><th>Fine So Far</th></tr></thead><tbody>' +
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
        const choice = await bpConfirm({
            title: 'Mark Fine as Paid',
            message: 'Fine ' + btn.dataset.id + '\n' + btn.dataset.name + '\nAmount: ' + peso(btn.dataset.amount),
            buttons: [{ label: 'Mark as Paid', value: true, kind: 'primary' }]
        });
        if (!choice) {
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
