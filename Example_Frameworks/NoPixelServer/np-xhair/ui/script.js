document.addEventListener('DOMContentLoaded', () => {
  const crosshair = document.getElementById('crosshair');

  window.addEventListener('message', (event) => {
    const action = event.data && event.data.action;
    if (action === 'show') {
      crosshair.style.display = 'block';
    } else if (action === 'hide') {
      crosshair.style.display = 'none';
    }
  });
});

