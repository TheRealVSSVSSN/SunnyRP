document.addEventListener('DOMContentLoaded', () => {
  const body = document.querySelector('.body');
  const warrantsContainer = document.querySelector('.warrants-container');
  const publicContainer = document.querySelector('.public-container');
  const doctorContainer = document.querySelector('.doctor-container');

  const containers = [warrantsContainer, publicContainer, doctorContainer];

  function closeAll() {
    containers.forEach(el => {
      el.style.opacity = 0;
      el.style.display = 'none';
    });
    body.style.opacity = 0;
    body.style.display = 'none';
  }

  function openContainer(target) {
    body.style.display = 'block';
    body.style.opacity = 1;
    containers.forEach(el => {
      if (el === target) {
        el.style.display = 'block';
        el.style.opacity = 1;
        el.style.top = '5%';
      } else {
        el.style.top = '105%';
        el.style.display = 'none';
        el.style.opacity = 0;
      }
    });
  }

  window.addEventListener('message', (event) => {
    const item = event.data;
    if (item.openWarrants) {
      closeAll();
      openContainer(warrantsContainer);
    } else if (item.openDoctors) {
      closeAll();
      openContainer(doctorContainer);
    } else if (item.openSection === 'publicrecords') {
      closeAll();
      openContainer(publicContainer);
    } else if (item.closeGUI) {
      closeAll();
    }
  });

  function handleKeyUp(e) {
    if (e.key === 'Escape') {
      fetch('https://np-warrants/close', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: '{}'
      }).catch(() => {});
      closeAll();
    }
  }

  document.addEventListener('keyup', handleKeyUp);

  document.querySelectorAll('.warrants-container iframe, .public-container iframe, .doctor-container iframe').forEach((iframe) => {
    iframe.addEventListener('load', () => {
      iframe.contentWindow.addEventListener('keyup', handleKeyUp);
    });
  });
});
