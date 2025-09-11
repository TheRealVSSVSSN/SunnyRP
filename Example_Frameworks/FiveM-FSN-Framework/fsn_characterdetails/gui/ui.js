/*--------------------------------------------------------------------------

    ActionMenu
    Created by WolfKnight
    Additional help from lowheartrate, TheStonedTurtle, and Briglair.
    Refactored to vanilla JS

--------------------------------------------------------------------------*/

document.addEventListener('DOMContentLoaded', () => {
  init();
  const actionContainer = document.getElementById('ass');

  window.addEventListener('message', (event) => {
    const item = event.data;

    if (item.showmenu) {
      resetMenu();
      actionContainer.style.display = 'block';
    }

    if (item.hidemenu) {
      actionContainer.style.display = 'none';
    }
  });
});

// Hides all div elements that contain a data-parent.
function resetMenu() {
  document.querySelectorAll('div').forEach((element) => {
    if (element.dataset.parent) {
      element.style.display = 'none';
    } else {
      element.style.display = 'block';
    }
  });
}

// Configures every button click to use its data-action or data-sub.
function init() {
  document.querySelectorAll('.menuoption').forEach((button) => {
    const action = button.dataset.action;
    const sub = button.dataset.sub;

    if (action) {
      button.addEventListener('click', () => {
        sendData('ButtonClick', action);
      });
    }

    if (sub) {
      button.addEventListener('click', () => {
        const element = document.getElementById(sub);
        if (element) {
          element.style.display = 'block';
        }
        button.parentElement.style.display = 'none';
      });
    }
  });
}

// Send data to Lua for processing.
function sendData(name, data) {
  fetch(`https://fsn_characterdetails/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  })
    .then((response) => response.text())
    .then((resp) => {
      if (resp !== 'ok') {
        console.log(resp);
      }
    })
    .catch((err) => console.error('NUI callback error:', err));
}
