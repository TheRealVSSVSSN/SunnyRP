let state = {
    phone: null,
    contacts: [],
    inbox: [],
    ads: [],
    currentApp: 'messages',
    lastInboxId: null,
};

function showPhone(show) {
    document.querySelector('#phone').classList.toggle('show', !!show);
}
function switchApp(app) {
    state.currentApp = app;
    document.querySelectorAll('.screen').forEach(el => el.classList.remove('active'));
    document.querySelector('#app-' + app).classList.add('active');
}
function renderBasics() {
    document.querySelector('#p-number').textContent = state.phone?.number || 'No Number';
}
function renderInbox() {
    const list = document.querySelector('#sms-list');
    list.innerHTML = '';
    for (const m of state.inbox) {
        const div = document.createElement('div');
        div.className = 'msg';
        div.textContent = `[${m.from_number}] ${m.text}`;
        list.appendChild(div);
    }
}
function renderContacts() {
    const list = document.querySelector('#contacts-list');
    list.innerHTML = '';
    for (const c of state.contacts) {
        const div = document.createElement('div');
        div.className = 'contact';
        div.innerHTML = `<span>${c.name} — ${c.number}</span><button data-id="${c.id}" class="del">Delete</button>`;
        list.appendChild(div);
    }
    list.querySelectorAll('.del').forEach(btn => {
        btn.addEventListener('click', () => {
            fetchNui('contacts_delete', { phoneId: state.phone.id, id: Number(btn.dataset.id) });
        });
    });
}
function renderAds() {
    const list = document.querySelector('#ads-list');
    list.innerHTML = '';
    for (const a of state.ads) {
        const div = document.createElement('div');
        div.className = 'ad';
        div.innerHTML = `<strong>${a.title}</strong><div>${a.body}</div><div style="color:#8b949e;font-size:12px">${a.phone_number || ''}</div>`;
        list.appendChild(div);
    }
}

function fetchNui(name, data) {
    return fetch(`https://${GetParentResourceName()}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data || {}) })
        .then(r => r.json()).catch(() => ({}));
}

window.addEventListener('message', (e) => {
    const msg = e.data || {};
    if (msg.action === 'loading') {
        showPhone(true);
        switchApp('messages');
        document.querySelector('#loading').classList.add('active');
    }
    if (msg.action === 'open') {
        state.phone = msg.data.phone;
        state.contacts = msg.data.contacts || [];
        state.inbox = msg.data.inbox || [];
        state.ads = msg.data.ads || [];
        state.lastInboxId = state.inbox.length ? state.inbox[state.inbox.length - 1].id : null;
        document.querySelector('#loading').classList.remove('active');
        switchApp('messages');
        renderBasics(); renderContacts(); renderInbox(); renderAds();
    }
    if (msg.action === 'close') { showPhone(false); }
    if (msg.action === 'sms_echo' || msg.action === 'sms_push') {
        // Normalize to messages schema (server inbox returns fields with *_number)
        const m = msg.data;
        state.inbox.push({ id: m.id, from_number: m.from, to_number: m.to, text: m.text });
        renderInbox();
    }
    if (msg.action === 'sms_bulk') {
        const list = msg.data || [];
        if (list.length) {
            state.inbox = state.inbox.concat(list);
            state.lastInboxId = state.inbox[state.inbox.length - 1].id;
            renderInbox();
        }
    }
    if (msg.action === 'contacts_update') {
        state.contacts = msg.data || [];
        renderContacts();
    }
});

document.querySelectorAll('.app-btn').forEach(b => b.addEventListener('click', () => switchApp(b.dataset.app)));
document.querySelector('#btn-close').addEventListener('click', () => fetchNui('close', {}));

document.querySelector('#sms-text').addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
        const to = document.querySelector('#sms-to').value.replace(/\D/g, '').slice(0, 10);
        const text = document.querySelector('#sms-text').value.slice(0, 500);
        if (!to || !text) return;
        fetchNui('sms_send', { from: state.phone.number, to, text });
        document.querySelector('#sms-text').value = '';
    }
});

document.querySelector('#c-save').addEventListener('click', () => {
    const name = document.querySelector('#c-name').value.trim();
    const number = document.querySelector('#c-number').value.replace(/\D/g, '').slice(0, 10);
    if (!name || !number) return;
    fetchNui('contacts_save', { phoneId: state.phone.id, contact: { name, number, favorite: false } });
    document.querySelector('#c-name').value = ''; document.querySelector('#c-number').value = '';
});

document.querySelector('#ad-post').addEventListener('click', () => {
    const title = document.querySelector('#ad-title').value.trim();
    const body = document.querySelector('#ad-body').value.trim();
    if (!title || !body) return;
    fetchNui('ads_post', { number: state.phone.number, title, body });
    document.querySelector('#ad-title').value = ''; document.querySelector('#ad-body').value = '';
});