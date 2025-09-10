document.addEventListener('DOMContentLoaded', () => {
  const cursor = document.getElementById('cursor');
  const notepad = document.querySelector('.notepad-container');
  const writeForm = document.getElementById('Ticket-form-Jail');
  const readForm = document.getElementById('Ticket-form-JailRead');
  const noteInput = document.getElementById('notepadInfof');
  const noteRead = document.getElementById('notepadInfofRead');
  let cursorX = document.documentElement.clientWidth / 2;
  let cursorY = document.documentElement.clientHeight / 2;

  const entityMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;', '`': '&#x60;', '=': '&#x3D;' };
  const escapeHtml = str => String(str).replace(/[&<>"'`=\/]/g, s => entityMap[s]);

  function updateCursor() {
    cursor.style.left = (cursorX + 2) + 'px';
    cursor.style.top = (cursorY + 2) + 'px';
  }

  document.querySelector('.btnDrop').addEventListener('click', e => {
    e.preventDefault();
    fetch('https://np-notepad/drop', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ noteText: escapeHtml(noteInput.value) })
    });
  });

  window.addEventListener('message', event => {
    const item = event.data;

    if (item.openSection === 'openNotepadRead') {
      notepad.style.display = 'block';
      writeForm.style.display = 'none';
      readForm.style.display = 'block';
      cursor.style.display = 'block';
      noteRead.value = item.TextRead;
    }

    if (item.openSection === 'openNotepad') {
      notepad.style.display = 'block';
      readForm.style.display = 'none';
      writeForm.style.display = 'block';
      cursor.style.display = 'block';
    }

    if (item.openSection === 'close') {
      notepad.style.display = 'none';
      cursor.style.display = 'none';
    }
  });

  document.addEventListener('mousemove', event => {
    cursorX = event.pageX;
    cursorY = event.pageY;
    updateCursor();
  });

  document.addEventListener('keyup', e => {
    if (e.key === 'Escape') {
      fetch('https://np-notepad/close', { method: 'POST', body: '{}' });
    }
  });
});
