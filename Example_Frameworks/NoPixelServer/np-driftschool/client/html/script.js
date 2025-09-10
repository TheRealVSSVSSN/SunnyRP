let open = false;

const send = (endpoint, data = {}) => {
  fetch(`https://np-driftschool/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  });
};

const closeMenu = () => {
  open = false;
  document.getElementById('testdrive').style.display = 'none';
  send('closemenu');
};

window.addEventListener('message', (event) => {
  if (event.data.type === 'enabletestdrive') {
    open = event.data.enable;
    document.getElementById('testdrive').style.display = open ? 'block' : 'none';
  }
});

document.getElementById('car-list').addEventListener('click', (e) => {
  const item = e.target.closest('li');
  if (!item) return;
  send('spawntestdrive', { model: item.dataset.model });
  closeMenu();
});

document.getElementById('close').addEventListener('click', closeMenu);
