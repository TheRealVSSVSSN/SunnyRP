const root = document.getElementById('root');

// Taskbar state
let task = null;
const elTask = document.getElementById('taskbar');
const elLabel = document.getElementById('taskbar-label');
const elProg = document.getElementById('taskbar-progress');
let raf = 0;

function step() {
    if (!task) return;
    const now = performance.now();
    const t = Math.max(0, Math.min(1, (now - task.t0) / task.duration));
    elProg.style.width = (t * 100).toFixed(2) + '%';
    if (t < 1) raf = requestAnimationFrame(step);
}

function showTaskbar(payload) {
    task = { id: payload.id, label: payload.label || 'Working...', duration: payload.duration || 5000, t0: performance.now() };
    elLabel.textContent = task.label;
    elProg.style.width = '0%';
    elTask.classList.remove('hidden');
    cancelAnimationFrame(raf);
    raf = requestAnimationFrame(step);
}

function endTaskbar() {
    elTask.classList.add('hidden');
    cancelAnimationFrame(raf);
    task = null;
}

window.addEventListener('message', (evt) => {
    const { app, action, payload } = evt.data || {};
    if (app !== 'srp') return;

    if (action === 'taskStart') showTaskbar(payload);
    else if (action === 'taskEnd' || action === 'taskCancel') endTaskbar();
    else if (action === 'bindsLoaded') {
        // Optionally display a toast; for now, noop
    }
});

// NUI global error -> post back (server will forward)
window.addEventListener('error', (e) => {
    fetch(`https://${GetParentResourceName()}/srp:nui:error`, {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: e.message || 'unknown', stack: String(e.error || e.filename || ''), ts: Date.now() })
    });
});