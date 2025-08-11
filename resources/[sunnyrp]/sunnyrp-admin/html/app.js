const root = document.getElementById('wrap');
const playersDiv = document.getElementById('players');
let players = [];
let selected = null;

window.addEventListener('message', (e) => {
    if (e.data?.type === 'admin:open') {
        root.style.display = 'block';
        fetch(`https://${GetParentResourceName()}/admin:requestPlayers`, { method: 'POST' });
    } else if (e.data?.type === 'admin:players') {
        players = e.data.data || [];
        renderPlayers();
    }
});

document.getElementById('close').onclick = () => {
    root.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/admin:close`, { method: 'POST' });
};

document.getElementById('refresh').onclick = () => {
    fetch(`https://${GetParentResourceName()}/admin:requestPlayers`, { method: 'POST' });
};

document.querySelectorAll('button[data-action]').forEach(btn => {
    btn.onclick = () => {
        if (!selected) return status('Select a player first.');
        const action = btn.dataset.action;
        const params = { target_src: selected.src };
        if (action === 'cleanup') params.radius = Number(document.getElementById('radius').value || 120);
        if (action === 'kick' || action === 'ban') params.reason = document.getElementById('reason').value || '';
        ncb('admin:action', { action, params });
    };
});

document.getElementById('search').oninput = (e) => renderPlayers(e.target.value.toLowerCase());

function renderPlayers(filter = '') {
    playersDiv.innerHTML = '';
    players
        .filter(p => `${p.name} ${p.src} ${p.job_code}`.toLowerCase().includes(filter))
        .forEach(p => {
            const row = document.createElement('div');
            row.className = 'player' + (selected && selected.src === p.src ? ' active' : '');
            row.innerHTML = `<div><strong>${p.name}</strong> <span style="color:#8b949e">(#${p.src}, ${p.job_code || 'civ'})</span></div>
                       <div>${p.health ?? ''}</div>`;
            row.onclick = () => { selected = p; renderPlayers(filter); };
            playersDiv.appendChild(row);
        });
}

function status(msg) { document.getElementById('status').textContent = msg; }

function ncb(name, body) {
    fetch(`https://${GetParentResourceName()}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
}