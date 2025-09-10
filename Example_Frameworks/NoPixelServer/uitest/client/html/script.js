const cursor = document.getElementById('cursor');
let cursorX = window.innerWidth / 2;
let cursorY = window.innerHeight / 2;

let btnCount = 0;
let btnSelected = 0;
let currentMenu = 1;
let buttonHeight = 0;

function updateCursor() {
  cursor.style.left = `${cursorX}px`;
  cursor.style.top = `${cursorY}px`;
}

function clickAt(x, y) {
  const el = document.elementFromPoint(x, y);
  if (el) {
    el.focus();
    el.click();
  }
}

function post(action, data = {}) {
  fetch(`https://uitest/${action}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  });
}

window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.type === 'enableui') {
    const form = document.getElementById('login-form');
    form.innerHTML = '';
    btnCount = 0;
    btnSelected = 0;
    cursor.style.display = data.enable ? 'block' : 'none';
    document.body.style.display = data.enable ? 'block' : 'none';
  } else if (data.type === 'endOfCurrentMenu') {
    if (data.isEnd) {
      if (currentMenu > 1) {
        const prevMenu = document.querySelector(`.menu${currentMenu}`);
        if (prevMenu) {
          prevMenu.style.left = `${-320 + currentMenu * 280}px`;
        }
      }
      currentMenu += 1;
      buttonHeight = 0;
    } else {
      currentMenu = 0;
    }
  } else if (data.type === 'addButton') {
    const form = document.getElementById('login-form');
    const btn = document.createElement('button');
    btnCount += 1;
    const id = `btn${btnCount}`;
    btn.id = id;
    btn.className = `button button1 menu${currentMenu}`;
    btn.value = data.functionname;
    btn.type = 'button';
    btn.dataset.menu = currentMenu;

    let startTop = -170;
    let startLeft = 10;

    if (data.buttonType === 'animSets') startTop = -470;
    if (data.buttonType === 'tattoo') startLeft = 810;
    if (data.buttonType === 'hair2') { startLeft = 810; startTop = -1147; }
    if (data.buttonType === 'hair') { startLeft = 550; startTop = -560; }
    if (data.buttonType === 'hairclose') { startLeft = -260; startTop = 420; }
    if (data.buttonType === 'haircloseaids') { startLeft = 0; startTop = 330; }
    if (data.buttonType === 'hairnextprev') { startLeft = 260; startTop = 285; }

    btn.style.left = `${startLeft + currentMenu * 280}px`;
    btn.style.top = `${startTop + buttonHeight * 45}px`;
    btn.textContent = data.name;

    if (data.buttonType === 'police') {
      btn.style.backgroundImage = "url('nui://uitest/client/html/menuButtonPolice.png')";
    } else if (data.buttonType === 'medic') {
      btn.style.backgroundImage = "url('nui://uitest/client/html/menuButtonEms.png')";
    } else if (data.buttonType === 'judge') {
      btn.style.backgroundImage = "url('nui://uitest/client/html/menuButtonJudge.png')";
    } else {
      btn.style.backgroundImage = "url('nui://uitest/client/html/menuButton.png')";
    }

    btn.onclick = () => {
      post('runfunction', { functionset: data.functionname, buttonType: data.buttonType, name: data.name });
    };

    btn.onmouseover = () => {
      const prev = document.getElementById(`btn${btnSelected}`);
      if (prev) prev.classList.remove('selected');
      btnSelected = btnCount;
      btn.classList.add('selected');
    };

    form.appendChild(btn);
    buttonHeight += 1;

    if (btnCount === 1) {
      btnSelected = 1;
      btn.classList.add('selected');
    }
  } else if (data.type === 'addButton3') {
    const form = document.getElementById('login-form');
    const btn = document.createElement('button');
    btnCount += 1;
    const id = `btn${btnCount}`;
    btn.id = id;
    btn.className = 'button button2';
    btn.value = data.functionname;
    btn.type = 'button';
    btn.textContent = data.name;
    btn.onclick = () => post('runfunction', { functionset: data.functionname });
    btn.onmouseover = () => {
      const prev = document.getElementById(`btn${btnSelected}`);
      if (prev) prev.classList.remove('selected');
      btnSelected = btnCount;
      btn.classList.add('selected');
    };
    form.appendChild(btn);
    if (btnCount === 1) {
      btnSelected = 1;
      btn.classList.add('selected');
    }
  } else if (data.type === 'click') {
    const prev = document.getElementById(`btn${btnSelected}`);
    if (prev) prev.classList.remove('selected');
    clickAt(cursorX - 1, cursorY - 1);
  } else if (data.type === 'up') {
    btnUp();
  } else if (data.type === 'down') {
    btnDown();
  }
});

document.addEventListener('mousemove', (event) => {
  cursorX = event.pageX;
  cursorY = event.pageY;
  updateCursor();
  btnDeSelect();
});

document.addEventListener('keyup', (e) => {
  if (e.which === 27 || e.which === 113) post('escape');
  if (e.which === 37) post('left');
  if (e.which === 39) post('right');
  if (e.which === 38) post('up');
  if (e.which === 40) post('down');
  if (e.which === 13) btnEnter();
});

function btnUp() {
  const prev = document.getElementById(`btn${btnSelected}`);
  if (prev) prev.classList.remove('selected');
  btnSelected -= 1;
  if (btnSelected <= 0) btnSelected = btnCount;
  const btn = document.getElementById(`btn${btnSelected}`);
  if (btn) btn.classList.add('selected');
}

function btnDown() {
  const prev = document.getElementById(`btn${btnSelected}`);
  if (prev) prev.classList.remove('selected');
  btnSelected += 1;
  if (btnSelected > btnCount) btnSelected = 1;
  const btn = document.getElementById(`btn${btnSelected}`);
  if (btn) btn.classList.add('selected');
}

function btnEnter() {
  if (btnSelected > 0) {
    const btn = document.getElementById(`btn${btnSelected}`);
    if (btn && typeof btn.onclick === 'function') {
      btn.onclick();
    }
  }
}

function btnDeSelect() {
  const btn = document.getElementById(`btn${btnSelected}`);
  if (btn) btn.classList.remove('selected');
}
