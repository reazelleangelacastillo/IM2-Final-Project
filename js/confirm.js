(function () {
    const dialog = document.getElementById('confirm-dialog');
    const titleBox = document.getElementById('confirm-title');
    const messageBox = document.getElementById('confirm-message');
    const actionsBox = document.getElementById('confirm-actions');

    function makeButton(label, kind) {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = kind === 'danger' ? 'btn-danger' : kind === 'primary' ? 'btn-primary' : 'btn-secondary';
        btn.textContent = label;
        return btn;
    }

    window.bpConfirm = function (options) {
        return new Promise(function (resolve) {
            let chosen = null;
            titleBox.textContent = options.title || 'Please confirm';
            messageBox.textContent = options.message || '';
            actionsBox.innerHTML = '';

            const cancel = makeButton(options.cancelLabel || 'Cancel', 'secondary');
            cancel.addEventListener('click', function () {
                chosen = null;
                dialog.close();
            });
            actionsBox.appendChild(cancel);

            (options.buttons || [{ label: 'Confirm', value: true, kind: 'primary' }]).forEach(function (b) {
                const btn = makeButton(b.label, b.kind || 'primary');
                btn.addEventListener('click', function () {
                    chosen = b.value;
                    dialog.close();
                });
                actionsBox.appendChild(btn);
            });

            dialog.addEventListener('close', function () {
                resolve(chosen);
            }, { once: true });
            dialog.showModal();
        });
    };
})();
