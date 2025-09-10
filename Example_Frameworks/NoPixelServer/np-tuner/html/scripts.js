// Type: Client-Side Script
// Name: scripts.js
// Use: Handles tuner UI interactions
// Created: 2025-09-10
// By: VSSVSSN

document.addEventListener('DOMContentLoaded', () => {
  const documentWidth = document.documentElement.clientWidth;
  const documentHeight = document.documentElement.clientHeight;
  const cursor = document.getElementById('cursor');
  let cursorX = documentWidth / 2;
  let cursorY = documentHeight / 2;

  function updateCursorPos() {
    cursor.style.left = `${cursorX + 2}px`;
    cursor.style.top = `${cursorY + 2}px`;
  }

  document.querySelector('.btntuneSystem').addEventListener('click', () => {
    fetch('https://np-tuner/tuneSystem', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        boost: document.getElementById('boost').value,
        fuel: document.getElementById('fuel').value,
        gears: document.getElementById('gears').value,
        braking: document.getElementById('braking').value,
        drive: document.getElementById('drive').value
      })
    });
  });

  document.querySelector('.btnDefault').addEventListener('click', () => {
    document.getElementById('boost').value = 0;
    document.getElementById('fuel').value = 0;
    document.getElementById('gears').value = 0;
    document.getElementById('braking').value = 5;
    document.getElementById('drive').value = 5;
  });

  document.querySelector('.btnSport').addEventListener('click', () => {
    document.getElementById('boost').value = 10;
    document.getElementById('fuel').value = 10;
    document.getElementById('gears').value = 10;
  });

  window.addEventListener('message', event => {
    const item = event.data;
    if (item.openSection === 'openNotepad') {
      document.querySelector('.notepad-container').style.display = 'block';
      const read = document.getElementById('Ticket-form-JailRead');
      if (read) read.style.display = 'none';
      document.getElementById('Ticket-form-Jail').style.display = 'block';
      cursor.style.display = 'block';
      if (item.boost) document.getElementById('boost').value = item.boost;
      if (item.fuel) document.getElementById('fuel').value = item.fuel;
      if (item.gears) document.getElementById('gears').value = item.gears;
      if (item.braking) document.getElementById('braking').value = item.braking;
      if (item.drive) document.getElementById('drive').value = item.drive;
    }
    if (item.openSection === 'close') {
      document.querySelector('.notepad-container').style.display = 'none';
      cursor.style.display = 'none';
    }
  });

  document.addEventListener('mousemove', event => {
    cursorX = event.pageX;
    cursorY = event.pageY;
    updateCursorPos();
  });

  document.addEventListener('keyup', event => {
    if (event.key === 'Escape') {
      fetch('https://np-tuner/close', { method: 'POST', body: '{}' });
    }
  });
});
