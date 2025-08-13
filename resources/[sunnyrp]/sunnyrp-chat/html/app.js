const feed = document.getElementById('feed');
const composer = document.getElementById('composer');
const input = document.getElementById('input');

let open = false;

function pushMessage({ channel, text, color }) {
    const div = document.createElement('div');
    div.className = 'msg';
    const c = color || [255, 255, 255];
    div.style.color = `rgb(${c[0]}, ${c[1]}, ${c[2]})`;
    const tag = channel ? `<span class="tag">[${channel}]</span>` : '';
    div.innerHTML = `${tag}${text}`;
    feed.prepend(div);
    // limit
    while (feed.childNodes.length > 40) {
        feed.lastChild.remove();
    }
}

function openComposer() {
    open = true;
    composer.classList.remove('hidden');
    input.value = '';
    input.focus();
}

function closeComposer() {
    open = false;
    composer.classList.add('hidden');
    input.blur();
}

window.addEventListener('message', (e) => {
    const data = e.data || {};
    if (data.action === 'open') openComposer();
    if (data.action === 'close') closeComposer();
    if (data.action === 'push') pushMessage(data.payload || {});
});

document.addEventListener('keydown', (e) => {
    if (!open) return;
    if (e.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/close`, { method: 'POST', body: '{}' });
    }
    if (e.key === 'Enter') {
        const text = (input.value || '').trim();
        fetch(`https://${GetParentResourceName()}/submit`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ text })
        });
    }
});