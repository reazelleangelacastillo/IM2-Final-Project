<div class="borrower-panel" id="borrower-panel">
    <div class="panel-head">
        <div>
            <h2 class="page-title"><i class="bi bi-person-badge"></i> Find borrower</h2>
            <p class="page-note">Search by borrower ID or name, or register a new borrower.</p>
        </div>
        <button type="button" class="btn-primary" id="register-new-btn"><i class="bi bi-person-plus"></i> Register new borrower</button>
    </div>
    <div class="search-row">
        <i class="bi bi-search"></i>
        <input type="text" id="borrower-search" placeholder="Borrower ID (BOR012 or 12) or name" autocomplete="off">
    </div>
    <div id="borrower-results" class="results-list" hidden></div>
    <div id="borrower-message" class="panel-message" hidden></div>
    <div id="borrower-card" class="info-card" hidden></div>
</div>

<dialog id="borrower-dialog" class="bp-dialog">
    <form id="borrower-form" class="bp-form" autocomplete="off">
        <h3 id="borrower-form-title">Register borrower</h3>
        <div id="borrower-form-alert" class="alert-danger" hidden></div>
        <div id="borrower-form-warning" class="alert-warning" hidden></div>
        <input type="hidden" name="borrower_id" id="bf-borrower-id">
        <div class="bp-grid">
            <div class="field-group">
                <label for="bf-first-name">First name</label>
                <input type="text" id="bf-first-name" name="first_name" maxlength="50" required>
            </div>
            <div class="field-group">
                <label for="bf-middle-initial">Middle initial</label>
                <input type="text" id="bf-middle-initial" name="middle_initial" maxlength="1">
            </div>
            <div class="field-group">
                <label for="bf-last-name">Last name</label>
                <input type="text" id="bf-last-name" name="last_name" maxlength="50" required>
            </div>
            <div class="field-group">
                <label for="bf-birth-date">Birth date</label>
                <input type="date" id="bf-birth-date" name="birth_date" max="<?php echo date('Y-m-d'); ?>" required>
            </div>
            <div class="field-group">
                <label for="bf-gender">Gender</label>
                <select id="bf-gender" name="gender" required>
                    <option value="">Select</option>
                    <option>Male</option>
                    <option>Female</option>
                </select>
            </div>
            <div class="field-group">
                <label for="bf-category">Category</label>
                <select id="bf-category" name="category" required>
                    <option value="">Select</option>
                    <option>Student</option>
                    <option>Teacher</option>
                    <option>Researcher</option>
                    <option>Community Resident</option>
                    <option>Other</option>
                </select>
            </div>
            <div class="field-group">
                <label for="bf-id-type">ID type</label>
                <input type="text" id="bf-id-type" name="id_type" maxlength="100" list="bf-id-types" required>
                <datalist id="bf-id-types">
                    <option value="National ID">
                    <option value="Driver's License">
                    <option value="Passport">
                    <option value="School ID">
                    <option value="Voter's ID">
                    <option value="Barangay ID">
                </datalist>
            </div>
            <div class="field-group">
                <label for="bf-id-number">ID number</label>
                <input type="text" id="bf-id-number" name="id_number" maxlength="30" required>
            </div>
            <div class="field-group">
                <label for="bf-barangay">Barangay (optional)</label>
                <input type="text" id="bf-barangay" name="barangay" maxlength="100">
            </div>
            <div class="field-group">
                <label for="bf-municipality">Municipality (optional)</label>
                <input type="text" id="bf-municipality" name="municipality" maxlength="100">
            </div>
            <div class="field-group">
                <label for="bf-province">Province (optional)</label>
                <input type="text" id="bf-province" name="province" maxlength="100">
            </div>
            <div class="field-group">
                <label for="bf-email">Email (optional)</label>
                <input type="email" id="bf-email" name="email" maxlength="100">
            </div>
        </div>
        <div class="actions-row">
            <button type="button" class="btn-secondary" id="bf-existing" hidden>View existing record</button>
            <button type="button" class="btn-secondary" id="bf-override" hidden>Register anyway</button>
            <button type="button" class="btn-secondary" id="bf-cancel">Cancel</button>
            <button type="submit" class="btn-primary" id="bf-save">Save</button>
        </div>
    </form>
</dialog>

<script>
(function () {
    const api = 'borrower_search.php';
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

    function showMessage(text, kind) {
        messageBox.textContent = text;
        messageBox.className = 'panel-message ' + (kind || 'info');
        messageBox.hidden = text === '';
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
        return res.json();
    }

    async function postJson(data) {
        const res = await fetch(api, { method: 'POST', body: new URLSearchParams(data), credentials: 'same-origin' });
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
            (r.unpaid ? '<span class="tag tag-red">Unpaid fine</span>' : '') +
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
            '<dt>Birth date</dt><dd>' + esc(p.birth_date) + '</dd>' +
            '<dt>Gender</dt><dd>' + esc(p.gender) + '</dd>' +
            '<dt>Address</dt><dd>' + esc(p.address || 'Not provided') + '</dd>' +
            '<dt>ID type</dt><dd>' + esc(p.id_type) + '</dd>' +
            '<dt>ID number</dt><dd>' + esc(p.id_number) + '</dd></dl></div>' +
            '<div class="info-section"><h4>Status</h4><dl>' +
            '<dt>Books held</dt><dd>' + s.active_borrows + ' of ' + s.max_books + '</dd>' +
            '<dt>Unpaid fine</dt><dd>' + peso(s.unpaid_fine_total) + '</dd>' +
            '<dt>Overdue titles</dt><dd>' + overdue + '</dd></dl></div></div>' +
            '<h4>Current borrows</h4><table class="mini-table"><thead><tr><th>Title</th><th>Copy</th><th>Due</th><th></th></tr></thead><tbody>' + borrowRows + '</tbody></table>';
        cardBox.hidden = false;

        document.getElementById('card-edit').addEventListener('click', () => openForm('edit', p));
        document.getElementById('card-delete').addEventListener('click', () => deleteBorrower(p.borrower_id));
        document.dispatchEvent(new CustomEvent('borrower:selected', {
            detail: { borrower_id: p.borrower_id, name: fullName, verdict: data.verdict, reasons: data.reasons }
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
        if (!window.confirm('Delete borrower ' + id + '? This cannot be undone.')) {
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
        formTitle.textContent = mode === 'edit' ? 'Edit borrower' : 'Register borrower';
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
</script>
