/*
  Type: Script
  Name: scripts.js
  Use: Renders keypad UI and communicates with the Lua client
  Created: 2024-02-16
  By: VSSVSSN
*/

const wrap = document.getElementById('wrap');
const pinCode = document.getElementById('PINcode');

function buildKeypad() {
  const form = document.createElement('form');
  form.id = 'PINform';
  form.autocomplete = 'off';

  const box = document.createElement('input');
  box.id = 'PINbox';
  box.type = 'password';
  box.disabled = true;
  form.appendChild(box);
  form.appendChild(document.createElement('br'));

  const layout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['clear', '0', 'enter']
  ];

  layout.forEach(row => {
    row.forEach(val => {
      const btn = document.createElement('input');
      btn.type = 'button';
      btn.className = 'PINbutton';
      btn.value = val;

      if (val === 'clear' || val === 'enter') {
        btn.classList.add(val);
      }

      btn.addEventListener('click', () => {
        if (val === 'clear') {
          box.value = '';
        } else if (val === 'enter') {
          submitPin(box.value);
        } else {
          box.value += val;
        }
      });

      form.appendChild(btn);
    });
    form.appendChild(document.createElement('br'));
  });

  pinCode.appendChild(form);
}

function openContainer() {
  wrap.style.display = 'block';
  const box = document.getElementById('PINbox');
  if (box) box.value = '';
}

function closeContainer() {
  wrap.style.display = 'none';
  const box = document.getElementById('PINbox');
  if (box) box.value = '';
}

function sendNui(name, data = {}) {
  fetch(`https://np-keypad/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  });
}

function submitPin(value) {
  if (value) {
    sendNui('complete', { pin: value });
    document.getElementById('PINbox').value = '';
  }
}

window.addEventListener('message', event => {
  const item = event.data;
  if (item.open) {
    openContainer();
  }
  if (item.close) {
    closeContainer();
  }
});

document.addEventListener('keydown', e => {
  const box = document.getElementById('PINbox');
  if (wrap.style.display !== 'block') return;

  if (e.key === 'Escape') {
    sendNui('close');
  } else if (e.key === 'Enter') {
    submitPin(box.value);
  } else if (/^[0-9]$/.test(e.key)) {
    box.value += e.key;
  }
});

document.addEventListener('DOMContentLoaded', buildKeypad);

