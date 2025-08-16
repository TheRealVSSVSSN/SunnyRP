const wrap = document.getElementById('wrap');
const list = document.getElementById('list');

window.addEventListener('message', (e) => {
    if (e.data?.type === 'mdt:open') { wrap.style.display = 'block'; refresh(); }
    if (e.data?.type === 'mdt:list') { render(e.data.data || []); }
    if (e.data?.type === 'mdt:created') { refresh(); }
});
document.getElementById('close').onclick = () => { wrap.style.display = 'none'; fetch(`https://${GetParentResourceName()}/mdt:close`, { method: 'POST' }) }
document.getElementById('refresh').onclick = () => refresh();
document.getElementById('create').onclick = () => {
    const title = document.getElementById('title').value;
    const body = document.getElementById('body').value;
    const type = document.getElementById('rtype').value;
    ncb('mdt:create', { title, body, type });
};

function refresh() {
    const type = document.getElementById('type').value;
    ncb('mdt:list', { type });
}
function render(rows) {
    list.innerHTML = '';
    rows.forEach(r => {
        const div = document.createElement('div');
        div.className = 'item';
        div.innerHTML = `<strong>#${r.id}</strong> <span style="color:#8b949e">[${r.type}]</span> — ${escapeHtml(r.title)}`;
        list.appendChild(div);
    });
}
function ncb(name, body) {
    fetch(`https://${GetParentResourceName()}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body || {}) });
}
function escapeHtml(s) { return ('' + s).replace(/[&<>"']/g, (m) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m])) }