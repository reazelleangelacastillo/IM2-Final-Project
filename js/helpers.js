window.helpers = {
    esc(value) {
        const d = document.createElement('div');
        d.textContent = value === null || value === undefined ? '' : String(value);
        return d.innerHTML;
    },

    formatDateTime(value) {
        if (!value) {
            return '';
        }
        const d = new Date(String(value).replace(' ', 'T'));
        return isNaN(d) ? window.helpers.esc(value) : d.toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });
    },

    peso(value) {
        return '₱' + Number(value).toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    },

    show(box, text, kind) {
        box.textContent = text;
        box.className = 'panel-message ' + (kind || 'info');
        box.hidden = text === '';
    },

    api(url) {
        const failure = { ok: false, error: 'Could not reach the server. Please log in again and retry.' };
        return {
            async getJson(params) {
                try {
                    const res = await fetch(url + '?' + new URLSearchParams(params), { credentials: 'same-origin' });
                    return await res.json();
                } catch (e) {
                    return failure;
                }
            },
            async postJson(data) {
                try {
                    const res = await fetch(url, { method: 'POST', body: new URLSearchParams(data), credentials: 'same-origin' });
                    return await res.json();
                } catch (e) {
                    return failure;
                }
            }
        };
    }
};
