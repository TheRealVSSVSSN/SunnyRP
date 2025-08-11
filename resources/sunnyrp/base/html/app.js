window.addEventListener('message', (e) => {
    const data = e.data || {};
    if (data.type === 'hello') {
        document.getElementById('status').textContent = 'Server says: ' + data.payload;
    }
    if (data.type === 'toggle') {
        document.getElementById('root').style.display = data.show ? 'grid' : 'none';
    }
});

document.getElementById('pingBtn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/nui:ping`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ time: Date.now() })
    }).then(r => r.json()).then(j => {
        document.getElementById('status').textContent = 'NUICallback ok: ' + JSON.stringify(j);
    });
});