(function () {
    const api = 'borrower_search.php';
    const { esc, formatDateTime, peso } = window.helpers;
    const searchInput = document.getElementById('borrower-search');
    const resultsBox = document.getElementById('borrower-results');
    const messageBox = document.getElementById('borrower-message');
    const cardBox = document.getElementById('borrower-card');
    const dialog = document.getElementById('borrower-dialog');
    const form = document.getElementById('borrower-form');
    const formTitle = document.getElementById('borrower-form-title');
    const formAlert = document.getElementById('borrower-form-alert');
    const formWarning = document.getElementById('borrower-form-warning');
    const existingBtn = document.getElementById('bf-existing');
    const overrideBtn = document.getElementById('bf-override');
    let timer = null;
    let formMode = 'register';
    let currentId = null;

    function showMessage(text, kind) {
        window.helpers.show(messageBox, text, kind);
    }

    async function safe(fn) {
        try {
            return await fn();
        } catch (e) {
            showMessage('Could not reach the server. Please log in again and retry.', 'error');
            return null;
        }
    }

    async function getJson(params) {
        const res = await fetch(api + '?' + new URLSearchParams(params), { credentials: 'same-origin' });
        if (res.redirected && new URL(res.url).pathname.toLowerCase().endsWith('/login.php')) {
            window.location.assign(res.url);
            return null;
        }
        return res.json();
    }

    async function postJson(data) {
        const res = await fetch(api, { method: 'POST', body: new URLSearchParams(data), credentials: 'same-origin' });
        if (res.redirected && new URL(res.url).pathname.toLowerCase().endsWith('/login.php')) {
            window.location.assign(res.url);
            return null;
        }
        return res.json();
    }

    function clearResults() {
        resultsBox.hidden = true;
        resultsBox.innerHTML = '';
    }

    function clearCard() {
        cardBox.hidden = true;
        cardBox.innerHTML = '';
        currentId = null;
        document.dispatchEvent(new CustomEvent('borrower:cleared'));
    }

    function renderResults(results, query) {
        showMessage('');
        if (results.length === 0) {
            resultsBox.innerHTML = '<div class="no-match"><p>No borrower found.</p></div>';
            resultsBox.hidden = false;
            return;
        }
        resultsBox.innerHTML = results.map(r =>
            '<button type="button" class="result-row" data-id="' + esc(r.borrower_id) + '">' +
            '<span class="result-name">' + esc(r.name) + '</span>' +
            '<span class="result-meta">' + esc(r.borrower_id) + ' &middot; ' + esc(r.category) + '</span>' +
            (r.unpaid ? '<span class="tag tag-red">Unpaid Fine</span>' : '') +
            (r.overdue ? '<span class="tag tag-red">Overdue</span>' : '') +
            '</button>'
        ).join('');
        resultsBox.hidden = false;
    }

    function prefillFromQuery(query) {
        if (/^\d+$/.test(query) || /^bor\d+$/i.test(query)) {
            return {};
        }
        const words = query.split(/\s+/);
        return { first_name: words[0] || '', last_name: words.slice(1).join(' ') };
    }

    async function runSearch() {
        const q = searchInput.value.trim();
        if (q === '') {
            clearResults();
            return;
        }
        const data = await safe(() => getJson({ action: 'search', q: q }));
        if (!data || searchInput.value.trim() !== q) {
            return;
        }
        if (data.exact) {
            clearResults();
            loadCard(data.exact);
            return;
        }
        renderResults(data.results, q);
    }

    function renderCard(data) {
        const p = data.profile;
        currentId = p.borrower_id;
        const s = data.status;
        const fullName = p.first_name + (p.middle_initial ? ' ' + p.middle_initial + '.' : '') + ' ' + p.last_name;
        const overdue = s.overdue_titles.length ? s.overdue_titles.map(esc).join(', ') : 'None';
        const borrowRows = data.borrows.length
            ? data.borrows.map(b =>
                '<tr><td>' + esc(b.title) + '</td><td>' + esc(b.copy_id) + '</td><td>' + formatDateTime(b.due_date) + '</td>' +
                '<td>' + (Number(b.is_overdue) ? '<span class="tag tag-red">Overdue</span>' : '') + '</td></tr>'
            ).join('')
            : '<tr><td colspan="4" class="empty-cell">No books currently borrowed.</td></tr>';
        const reasons = data.reasons.length ? '<ul>' + data.reasons.map(r => '<li>' + esc(r) + '</li>').join('') + '</ul>' : '';

        cardBox.innerHTML =
            '<div class="card-head"><div><h3>' + esc(fullName) + '</h3><span class="muted">' + esc(p.borrower_id) + ' &middot; ' + esc(p.category) + '</span></div>' +
            '<div class="card-actions"><button type="button" class="btn-secondary" id="card-edit"><i class="bi bi-pencil-square"></i> Edit</button>' +
            '<button type="button" class="btn-danger" id="card-delete"><i class="bi bi-trash3-fill"></i> Delete</button></div></div>' +
            '<div class="verdict verdict-' + esc(data.verdict.toLowerCase()) + '"><strong>' + esc(data.verdict) + '</strong>' + reasons + '</div>' +
            '<div class="info-grid">' +
            '<div class="info-section"><h4>Profile</h4><dl>' +
            '<dt>Birth Date</dt><dd>' + esc(p.birth_date) + '</dd>' +
            '<dt>Gender</dt><dd>' + esc(p.gender) + '</dd>' +
            '<dt>Address</dt><dd>' + esc(p.address || 'Not provided') + '</dd>' +
            '<dt>ID Type</dt><dd>' + esc(p.id_type) + '</dd>' +
            '<dt>ID Number</dt><dd>' + esc(p.id_number) + '</dd></dl></div>' +
            '<div class="info-section"><h4>Status</h4><dl>' +
            '<dt>Books Held</dt><dd>' + s.active_borrows + ' of ' + s.max_books + '</dd>' +
            '<dt>Unpaid Fine</dt><dd>' + peso(s.unpaid_fine_total) + '</dd>' +
            '<dt>Overdue Titles</dt><dd>' + overdue + '</dd></dl></div></div>' +
            '<h4>Current Borrows</h4><table class="mini-table"><thead><tr><th>Title</th><th>Copy</th><th>Due</th><th></th></tr></thead><tbody>' + borrowRows + '</tbody></table>';
        cardBox.hidden = false;

        document.getElementById('card-edit').addEventListener('click', () => openForm('edit', p));
        document.getElementById('card-delete').addEventListener('click', () => deleteBorrower(p.borrower_id));
        document.dispatchEvent(new CustomEvent('borrower:selected', {
            detail: {
                borrower_id: p.borrower_id,
                name: fullName,
                verdict: data.verdict,
                reasons: data.reasons,
                active_borrows: s.active_borrows,
                max_books: s.max_books
            }
        }));
    }

    async function loadCard(id) {
        const data = await safe(() => getJson({ action: 'card', id: id }));
        if (!data) {
            return;
        }
        if (!data.ok) {
            showMessage(data.error, 'error');
            return;
        }
        clearResults();
        showMessage('');
        renderCard(data);
    }

    async function deleteBorrower(id) {
        const choice = await bpConfirm({
            title: 'Delete Borrower',
            message: 'Delete borrower ' + id + '? This cannot be undone.',
            buttons: [{ label: 'Delete', value: true, kind: 'danger' }]
        });
        if (!choice) {
            return;
        }
        const res = await safe(() => postJson({ action: 'delete', borrower_id: id }));
        if (!res) {
            return;
        }
        if (res.ok) {
            clearCard();
            searchInput.value = '';
            showMessage('Borrower deleted.', 'success');
        } else {
            showMessage(res.error, 'error');
        }
    }

    function resetFormAlerts() {
        formAlert.hidden = true;
        formWarning.hidden = true;
        existingBtn.hidden = true;
        overrideBtn.hidden = true;
        existingBtn.dataset.id = '';
    }

    function openForm(mode, values) {
        formMode = mode;
        form.reset();
        resetFormAlerts();
        formTitle.textContent = mode === 'edit' ? 'Edit Borrower' : 'Register Borrower';
        document.getElementById('bf-borrower-id').value = mode === 'edit' ? values.borrower_id : '';
        Array.from(form.elements).forEach(el => {
            if (el.name && values && values[el.name] !== undefined && values[el.name] !== null && el.name !== 'borrower_id') {
                el.value = values[el.name];
            }
        });
        dialog.showModal();
    }

    async function submitForm(override) {
        resetFormAlerts();
        const data = Object.fromEntries(new FormData(form));
        data.action = formMode === 'edit' ? 'update' : 'register';
        if (override) {
            data.override = '1';
        }
        const res = await safe(() => postJson(data));
        if (!res) {
            return;
        }
        if (res.ok) {
            dialog.close();
            searchInput.value = '';
            loadCard(res.borrower_id);
            return;
        }
        if (res.warning) {
            formWarning.textContent = res.warning + ' (' + res.matches.map(m => m.borrower_id + ' ' + m.name).join(', ') + ')';
            formWarning.hidden = false;
            overrideBtn.hidden = false;
            return;
        }
        formAlert.textContent = res.error;
        formAlert.hidden = false;
        if (res.existing) {
            existingBtn.dataset.id = res.existing;
            existingBtn.hidden = false;
        }
    }

    searchInput.addEventListener('input', () => {
        clearTimeout(timer);
        timer = setTimeout(runSearch, 250);
    });

    resultsBox.addEventListener('click', (e) => {
        const row = e.target.closest('.result-row');
        if (row) {
            searchInput.value = '';
            loadCard(row.dataset.id);
        }
    });

    form.addEventListener('submit', (e) => {
        e.preventDefault();
        submitForm(false);
    });
    overrideBtn.addEventListener('click', () => submitForm(true));
    existingBtn.addEventListener('click', () => {
        const id = existingBtn.dataset.id;
        dialog.close();
        loadCard(id);
    });
    document.addEventListener('borrower:refresh', () => {
        if (currentId) {
            loadCard(currentId);
        }
    });
    document.getElementById('register-new-btn').addEventListener('click', () => openForm('register', prefillFromQuery(searchInput.value.trim())));
    document.getElementById('bf-cancel').addEventListener('click', () => dialog.close());
})();
