window.addEventListener('DOMContentLoaded', () => {
  const powerBtn = document.getElementById('power');
  const volUpBtn = document.getElementById('volumeUp');
  const volDownBtn = document.getElementById('volumeDown');
  const changeBtn = document.getElementById('radioChange');
  const display = document.getElementById('displayStation');
  const container = document.querySelector('.radio-container');
  const fullscreen = document.querySelector('.full-screen');

  let powered = true;
  const stations = [1982.9, 0.0];
  let currentStation = 1;

  const post = (endpoint, data = {}) => {
    fetch(`https://stereo/${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
  };

  const closeGui = () => {
    if (powered) {
      post('close', { channel: stations[currentStation] });
    } else {
      post('cleanClose');
    }
  };

  const closeSave = () => {
    closeGui();
  };

  window.addEventListener('message', (event) => {
    const item = event.data;
    if (item.reset === true) {
      closeGui();
    }
    if (item.set === true) {
      const idx = stations.indexOf(item.setChannel);
      if (idx !== -1) currentStation = idx;
    }
    if (item.open === true) {
      display.textContent = powered && stations[currentStation] !== 0.0 ? stations[currentStation] : '0000.0';
      fullscreen.style.display = 'flex';
      container.style.display = 'block';
    }
    if (item.open === false) {
      fullscreen.style.display = 'none';
      container.style.display = 'none';
    }
  });

  powerBtn.addEventListener('click', () => {
    if (!powered) {
      powered = true;
      post('click');
      post('poweredOn', { channel: stations[currentStation] });
      display.textContent = stations[currentStation];
    } else {
      powered = false;
      post('click');
      post('poweredOff');
      display.textContent = '0000.0';
    }
  });

  volUpBtn.addEventListener('click', () => {
    post('click');
    post('volumeUp');
  });

  volDownBtn.addEventListener('click', () => {
    post('click');
    post('volumeDown');
  });

  changeBtn.addEventListener('click', () => {
    if (powered) {
      currentStation = (currentStation + 1) % stations.length;
      display.textContent = stations[currentStation] === 0.0 ? '0000.0' : stations[currentStation];
      post('channelChange', { channel: stations[currentStation] });
    }
    post('click');
  });

  document.addEventListener('keyup', (e) => {
    if (e.key === 'Escape') {
      closeSave();
    }
  });
});

