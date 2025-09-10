document.addEventListener('DOMContentLoaded', () => {
  // Element references
  const cursor = document.getElementById('cursor');
  const container = document.querySelector('.evidence-container');
  const caseId = document.getElementById('caseId');
  const list = document.getElementById('fishList');

  // Track cursor position
  let cursorX = window.innerWidth / 2;
  let cursorY = window.innerHeight / 2;

  // Update cursor sprite placement
  function updateCursor() {
    cursor.style.left = `${cursorX + 10}px`;
    cursor.style.top = `${cursorY + 10}px`;
  }

  // Handle NUI messages from Lua
  window.addEventListener('message', (event) => {
    const item = event.data;

    if (item.type === 'click') {
      return;
    }

    if (item.openSection === 'fishOpen') {
      container.style.display = 'block';
      cursor.style.display = 'block';
      caseId.textContent = item.NUICaseId || '';
      list.innerHTML = '';
    }

    if (item.openSection === 'fishUpdate') {
      const row = document.createElement('p');
      row.className = 'something';

      const nameEl = document.createElement('p');
      nameEl.className = 'evidenceType';
      nameEl.textContent = item.name;
      row.appendChild(nameEl);

      const sizeEl = document.createElement('p');
      sizeEl.className = 'evidenceAmount';
      sizeEl.textContent = item.size;
      row.appendChild(sizeEl);

      list.appendChild(row);
    }

    if (item.openSection === 'close') {
      container.style.display = 'none';
      cursor.style.display = 'none';
    }
  });

  // Update cursor on mouse move
  document.addEventListener('mousemove', (event) => {
    cursorX = event.pageX;
    cursorY = event.pageY;
    updateCursor();
  });

  // Close GUI on ESC key
  document.addEventListener('keyup', (event) => {
    if (event.key === 'Escape') {
      fetch('https://np-fish/close', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: '{}'
      });
    }
  });
});
