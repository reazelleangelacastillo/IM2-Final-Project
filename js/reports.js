(function () {
    var dialog = document.getElementById('report-dialog');
    var openBtn = document.getElementById('open-report-modal');
    var cancelBtn = document.getElementById('cancel-report-modal');
    var typeSelect = document.getElementById('report-type');
    var dateInput = document.getElementById('period-date');
    var hint = document.getElementById('period-hint');
    var fields = document.querySelectorAll('.period-field');
    var selectedId = document.getElementById('selected-report-id');
    var viewBtn = document.getElementById('view-report-button');
    var rows = document.querySelectorAll('.selectable-row');

    function openDialog() {
        if (!dialog.open) {
            dialog.showModal();
        }
        typeSelect.focus();
    }

    function formatDay(date) {
        return date.toLocaleDateString('en-US', { month: 'short', day: '2-digit' });
    }

    function updateHint() {
        hint.textContent = '';
        if (!dateInput.value) {
            return;
        }
        var parts = dateInput.value.split('-');
        var picked = new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
        var offset = (picked.getDay() + 6) % 7;
        var monday = new Date(picked.getFullYear(), picked.getMonth(), picked.getDate() - offset);
        var sunday = new Date(monday.getFullYear(), monday.getMonth(), monday.getDate() + 6);
        hint.textContent = 'Covers ' + formatDay(monday) + ' to ' + formatDay(sunday) + ', ' + sunday.getFullYear();
    }

    function updateFields() {
        var type = typeSelect.value;
        fields.forEach(function (field) {
            var show = type !== '' && field.dataset.for.split(' ').indexOf(type) !== -1;
            field.hidden = !show;
            field.querySelectorAll('input, select').forEach(function (control) {
                control.disabled = !show;
                control.required = show;
            });
        });
        updateHint();
    }

    function selectRow(row) {
        selectedId.value = row.dataset.reportId;
        viewBtn.disabled = false;
        rows.forEach(function (other) {
            other.classList.toggle('selected-row', other === row);
            other.setAttribute('aria-selected', other === row ? 'true' : 'false');
        });
    }

    typeSelect.addEventListener('change', updateFields);
    dateInput.addEventListener('input', updateHint);
    updateFields();

    if (openBtn) {
        openBtn.addEventListener('click', openDialog);
    }
    cancelBtn.addEventListener('click', function () {
        dialog.close();
    });

    rows.forEach(function (row) {
        row.addEventListener('click', function () {
            selectRow(row);
        });
        row.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                selectRow(row);
            }
        });
    });

    if (dialog.dataset.open === '1') {
        openDialog();
    }
})();
