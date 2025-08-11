const hotbar = document.getElementById('hotbar');
const ICONS = {
    water: '💧',
    bread: '🍞',
};

function iconFor(key) {
    if (ICONS[key]) return ICONS[key];
    if (key && key.startsWith('WEAPON_')) return '🔫';
    return '📦';
}

function render(slots) {
    hotbar.innerHTML = '';
    const max = Number((window.GetConvar && GetConvar('srp_inv_hotbar_slots', '5')) || 5);
    const map = {};
    (slots || []).forEach(s => map[s.slot] = s);

    for (let i = 1; i <= max; i++) {
        const data = map[i];
        const el = document.createElement('div');
        el.className = 'slot';
        el.innerHTML = `<div class="idx">${i}</div>
      <div class="icon ${data && data.key && data.key.startsWith('WEAPON_') ? 'weapon' : ''}">${data ? iconFor(data.key) : ''}</div>
      <div class="qty">${data && data.qty > 1 ? data.qty : ''}</div>`;
        hotbar.appendChild(el);
    }
}

window.addEventListener('message', (e) => {
    const a = e.data?.action;
    const p = e.data?.payload;
    if (a === 'hotbar') render(p);
    else if (a === 'consumed') {
        // flash any slot that has this item (simple)
        [...hotbar.children].forEach(ch => ch.classList.add('flash'));
        setTimeout(() => [...hotbar.children].forEach(ch => ch.classList.remove('flash')), 600);
    }
});

// blank start
render([]);