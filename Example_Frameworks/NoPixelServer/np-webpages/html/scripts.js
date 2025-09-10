'use strict';

document.addEventListener('DOMContentLoaded', () => {
  const calculator = document.querySelector('.calculator');
  const iframe = document.querySelector('iframe');

  window.addEventListener('message', (event) => {
    const { openSection } = event.data || {};
    if (openSection === 'calculator') {
      calculator.style.opacity = '1';
    } else if (openSection === 'close') {
      calculator.style.opacity = '0';
    }
  });

  const close = () => {
    fetch('https://np-webpages/close', {
      method: 'POST',
      body: JSON.stringify({})
    });
  };

  const keyHandler = (e) => {
    if (e.key === 'Escape') {
      close();
    }
  };

  document.addEventListener('keyup', keyHandler);
  iframe.addEventListener('load', () => {
    iframe.contentWindow.addEventListener('keyup', keyHandler);
  });
});
