(function () {
    var dialog = document.getElementById('report-dialog');
    var openBtn = document.getElementById('open-report-modal');
    var cancelBtn = document.getElementById('cancel-report-modal');
    var typeSelect = document.getElementById('report-type');
    var selectedId = document.getElementById('selected-report-id');
    var viewBtn = document.getElementById('view-report-button');
    var rows = document.querySelectorAll('.selectable-row');

    function openDialog() {
        if (!dialog.open) {
            dialog.showModal();
        }
        typeSelect.focus();
    }

    function selectRow(row) {
        selectedId.value = row.dataset.reportId;
        viewBtn.disabled = false;
        rows.forEach(function (other) {
            other.classList.toggle('selected-row', other === row);
            other.setAttribute('aria-selected', other === row ? 'true' : 'false');
        });
    }

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
