document.addEventListener('DOMContentLoaded', () => {
  const notifyWrap = document.querySelector('.notify-wrap');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.runProgress) {
      const fade = Number(data.fadesent) || 5000;
      const colorId = `colorsent${data.colorsent}`;
      const existing = document.getElementById(colorId);
      if (existing) existing.remove();

      const element = document.createElement('div');
      element.id = colorId;
      element.classList.add('notification-bg');

      switch (Number(data.colorsent)) {
        case 2:
          element.classList.add('red');
          break;
        case 69:
          element.classList.add('taxi');
          break;
        case 155:
          element.classList.add('medical');
          break;
        default:
          break;
      }

      element.textContent = data.textsent || '';
      notifyWrap.prepend(element);

      requestAnimationFrame(() => element.classList.add('show'));
      setTimeout(() => element.classList.add('hide'), fade / 2);
      setTimeout(() => element.remove(), fade);
    } else if (data.closeProgress) {
      notifyWrap.innerHTML = '';
    }
  });
});
