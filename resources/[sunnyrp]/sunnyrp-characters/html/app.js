const NUI = `https://${GetParentResourceName()}`;
let state = { list: [], maxSlots: 3 };

window.addEventListener('message', (e) => {
    const data = e.data || {};
    if (data.type === 'char:list') {
        state.list = data.data.list || [];
        state.maxSlots = data.data.maxSlots || 3;
        if (data.data.error) showError(data.data.error); else hideError();
        render();
    }
    if (data.type === 'char:close') {
        document.getElementById('wrap').style.display = 'none';
    }
});

function showError(msg) { const el = document.getElementById('error'); el.textContent = msg; el.style.display = 'block'; }
function hideError() { const el = document.getElementById('error'); el.style.display = 'none'; }

function render() {
    const list = document.getElementById('list');
    list.innerHTML = '';
    const used = state.list.length;
    const max = state.maxSlots === 0 ? 'Unlimited' : state.maxSlots;

    for (const c of state.list) {
        const card = document.createElement('div'); card.className = 'card';
        const left = document.createElement('div');
        left.innerHTML = `<strong>Slot ${c.slot}:</strong> ${c.first_name} ${c.last_name}
      <span class="small">• $${(c.balances?.cash || 0)} cash / $${(c.balances?.bank || 0)} bank</span>`;
        const actions = document.createElement('div'); actions.className = 'actions';
        const sel = document.createElement('button'); sel.textContent = 'Select'; sel.onclick = () => selectChar(c.id);
        const del = document.createElement('button'); del.textContent = 'Delete'; del.onclick = () => delChar(c.id);
        actions.appendChild(sel); actions.appendChild(del);
        card.appendChild(left); card.appendChild(actions);
        list.appendChild(card);
    }

    document.getElementById('slots').textContent = `Used slots: ${used} / ${max}`;
}

function post(name, body) {
    return fetch(`${NUI}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body || {}) });
}

document.getElementById('btnCreate').addEventListener('click', () => {
    const payload = {
        first_name: document.getElementById('fn').value || 'John',
        last_name: document.getElementById('ln').value || 'Doe',
        dob: document.getElementById('dob').value || '',
        gender: document.getElementById('gender').value || ''
    };
    post('srp:characters:create', payload);
});

function selectChar(id) { post('srp:characters:select', { characterId: id }); }
function delChar(id) { post('srp:characters:delete', { characterId: id }); }