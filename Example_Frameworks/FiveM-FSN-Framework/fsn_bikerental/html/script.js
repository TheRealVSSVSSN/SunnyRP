document.addEventListener('DOMContentLoaded', () => {
  window.addEventListener('message', (event) => {
    if (event.data.type === 'enableui') {
      document.body.style.display = event.data.enable ? 'block' : 'none';
    }
  });

  document.addEventListener('keyup', (e) => {
    if (e.key === 'Escape') {
      fetch('https://fsn_bikerental/escape', { method: 'POST', body: '{}' });
    }
  });

  document.querySelectorAll('button[data-model]').forEach((btn) => {
    btn.addEventListener('click', () => {
      const model = btn.dataset.model;
      const price = Number(btn.dataset.price);
      fetch('https://fsn_bikerental/rentBike', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ model, price })
      });
    });
  });
});
