document.addEventListener('DOMContentLoaded', () => {
  const radioForm = document.getElementById('Radio-Form');
  const radioChannelInput = document.getElementById('RadioChannel');
  const powerBtn = document.getElementById('power');
  const volumeUpBtn = document.getElementById('volumeUp');
  const volumeDownBtn = document.getElementById('volumeDown');
  const overlay = document.querySelector('.full-screen');
  const container = document.querySelector('.radio-container');

  let radioChannel = '0.0';
  let emergency = false;
  let powered = false;

  const post = (url, data = {}) => {
    fetch(`https://radio/${url}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data)
    });
  };

  const closeGui = () => {
    if (powered) {
      const channelNum = parseFloat(radioChannel);
      if (channelNum < 100.0 || channelNum > 999.9) {
        if (!(channelNum < 10 && emergency)) {
          radioChannel = '0.0';
        }
      }
      post('close', { channel: radioChannel });
    } else {
      post('cleanClose');
    }
  };

  const closeSave = () => {
    if (powered) {
      const parsed = parseFloat(radioChannelInput.value);
      radioChannel = parsed ? parsed.toFixed(1) : '0.0';
    }
    closeGui();
  };

  window.addEventListener('message', event => {
    const item = event.data;
    if (item.reset) closeGui();
    if (item.set) radioChannel = item.setChannel;
    if (typeof item.open === 'boolean') {
      emergency = item.jobType;
      if (item.open) {
        if (radioChannel !== '0.0' && powered) {
          radioChannelInput.value = radioChannel;
        } else if (powered) {
          radioChannelInput.value = '';
          radioChannelInput.placeholder = '100.0-999.9';
          radioChannelInput.disabled = false;
        } else {
          radioChannelInput.value = '';
          radioChannelInput.placeholder = 'Off';
          radioChannelInput.disabled = true;
        }
        overlay.style.display = 'block';
        container.style.display = 'block';
        radioChannelInput.focus();
      } else {
        overlay.style.display = 'none';
        container.style.display = 'none';
      }
    }
  });

  radioForm.addEventListener('submit', e => {
    e.preventDefault();
    closeSave();
  });

  powerBtn.addEventListener('click', () => {
    if (!powered) {
      powered = true;
      radioChannelInput.disabled = false;
      radioChannelInput.focus();
      radioChannelInput.value = radioChannel === '0.0' ? '' : radioChannel;
      radioChannelInput.placeholder = '100.0-999.9';
      post('click');
      post('poweredOn', { channel: radioChannel });
    } else {
      powered = false;
      post('click');
      post('poweredOff');
      radioChannelInput.value = '';
      radioChannelInput.placeholder = 'Off';
      radioChannelInput.disabled = true;
    }
  });

  volumeUpBtn.addEventListener('click', () => {
    post('click');
    post('volumeUp');
  });

  volumeDownBtn.addEventListener('click', () => {
    post('click');
    post('volumeDown');
  });

  document.addEventListener('keyup', e => {
    if (e.key === 'Escape') closeSave();
  });
});
