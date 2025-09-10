window.addEventListener('DOMContentLoaded', () => {
  const container = document.querySelector('.signup-b');
  const icon = document.getElementById('voice');

  const tools = {
    electricLock: 'electronic.png',
    physicalPick: 'lockpick.png',
    physicalThermite: 'thermite.png',
    cardedlock: 'gruppe62.png',
    cardedlock2: 'gruppe622.png',
    airLock: 'airlock.png'
  };

  function renderToolOptions(tool) {
    const img = tools[tool];
    if (img) {
      container.style.display = 'inline';
      icon.src = img;
    } else {
      container.style.display = 'none';
    }
  }

  window.addEventListener('message', (event) => {
    const { openSection, tool } = event.data;
    if (openSection === 'toolSelect') {
      renderToolOptions(tool);
    }
  });
});

