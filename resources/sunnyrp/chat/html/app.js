const feed = document.getElementById('feed');
const wrap = document.getElementById('inputWrap');
const input = document.getElementById('chatInput');

function escapeHTML(s) {
    const d = document.createElement('div');
    d.innerText = String(s ?? '');
    return d.innerHTML;
}

function addMessage(m) {
    const el = document.createElement('div');
    el.className = `msg ${m.channel}`;
    const who = (m.from && typeof m.from === 'number') ? `#${m.from}` : '';
    el.innerHTML = `
    <div class="meta">[${m.channel.toUpperCase()}] ${who}</div>
    <div class="text">${escapeHTML(m.text)}</div>
  `;
    feed.prepend(el);
    // trim
    while (feed.children.length > 15) feed.removeChild(feed.lastChild);
}

function openInput() {
    wrap.classList.remove('hidden');
    input.value = '';
    input.focus();
}
function closeInput() {
    wrap.classList.add('hidden');
    input.blur();
}

// NUI hooks
window.addEventListener('message', (e) => {
    const data = e.data || {};
    if (data.action === 'open') openInput();
    else if (data.action === 'close') closeInput();
    else if (data.action === 'message') addMessage(data.payload);
});

// UX
document.addEventListener('keydown', (e) => {
    if (wrap.classList.contains('hidden')) return;
    if (e.key === 'Escape') {
        fetch(`https://sunnyrp-chat/close`, { method: 'POST', body: '{}' });
    }
});
input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
        const text = input.value || '';
        fetch(`https://sunnyrp-chat/submit`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ text })
        }).then(() => closeInput());
    }
});