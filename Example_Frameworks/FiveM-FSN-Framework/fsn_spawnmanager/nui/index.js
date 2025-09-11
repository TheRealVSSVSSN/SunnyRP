(function () {
  const spawnMenu = document.querySelector('.spawnmenu');
  const selections = document.querySelector('.selections');
  const spawnButton = document.querySelector('.spawnbutton');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.hide) {
      spawnMenu.style.display = 'none';
      return;
    }

    if (data.locs) {
      selections.innerHTML = '';
      spawnButton.style.display = 'none';

      data.locs.forEach((loc, i) => {
        const div = document.createElement('div');
        div.className = 'selection' + (loc.selected ? ' selected' : '');
        div.textContent = loc.name;
        div.onclick = () => camToLoc(i);
        selections.appendChild(div);

        if (loc.selected) {
          spawnButton.style.display = 'block';
        }
      });

      spawnMenu.style.display = 'block';
    }
  });

  window.camToLoc = (id) => {
    fetch('https://fsn_spawnmanager/camToLoc', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({ loc: id })
    });
  };

  window.spawn = () => {
    fetch('https://fsn_spawnmanager/spawnAtLoc', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({})
    });
  };
})();

