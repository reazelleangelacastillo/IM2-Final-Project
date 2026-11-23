(function () {
    var addDialog = document.getElementById('add-staff-dialog');
    var resetDialog = document.getElementById('reset-dialog');
    var resetId = document.getElementById('reset-staff-id');
    var resetName = document.getElementById('reset-staff-name');

    function openDialog(dialog) {
        if (!dialog.open) {
            dialog.showModal();
        }
    }

    document.getElementById('open-add-staff').addEventListener('click', function () {
        openDialog(addDialog);
    });
    document.getElementById('cancel-add-staff').addEventListener('click', function () {
        addDialog.close();
    });
    document.getElementById('cancel-reset').addEventListener('click', function () {
        resetDialog.close();
    });

    document.querySelectorAll('.js-reset').forEach(function (button) {
        button.addEventListener('click', function () {
            resetId.value = button.dataset.staffId;
            resetName.textContent = button.dataset.name;
            resetDialog.querySelectorAll('input[type="password"]').forEach(function (input) {
                input.value = '';
            });
            openDialog(resetDialog);
        });
    });

    if (addDialog.dataset.open === '1') {
        openDialog(addDialog);
    }
    if (resetDialog.dataset.open === '1') {
        openDialog(resetDialog);
    }
})();
