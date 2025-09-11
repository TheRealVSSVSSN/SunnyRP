document.addEventListener('DOMContentLoaded', () => {
  const cursor = document.getElementById('cursor');
  const home = document.querySelector('.home');
  const container = document.querySelector('.evidence-container');
  const header = document.querySelector('.evidence-container-header');
  const listContainer = document.querySelector('.container2');

  let cursorX = window.innerWidth / 2;
  let cursorY = window.innerHeight / 2;

  const updateCursor = () => {
    cursor.style.left = `${cursorX + 10}px`;
    cursor.style.top = `${cursorY + 10}px`;
  };

  const showUI = () => {
    home.style.display = 'block';
    container.style.display = 'block';
    header.style.display = 'block';
    cursor.style.display = 'block';
  };

  const hideUI = () => {
    home.style.display = 'none';
    container.style.display = 'none';
    header.style.display = 'none';
    cursor.style.display = 'none';
    listContainer.innerHTML = '';
  };

  window.addEventListener('message', (event) => {
    const item = event.data;
    if (item.openSection === 'truckerOpen') {
      showUI();
    } else if (item.openSection === 'truckerUpdate') {
      const wrapper = document.createElement('div');
      wrapper.innerHTML = `<div class="bubble-container2"> Delivery to ${item.street2} </div><div class="bubble-container3"> Click to accept. </div><hr>`;
      wrapper.addEventListener('click', () => {
        fetch('https://truckerjob/selectedJob', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ jobType: item.jobType, jobId: item.jobId })
        });
      });
      listContainer.appendChild(wrapper);
    } else if (item.openSection === 'close') {
      hideUI();
    }
  });

  document.onmousemove = (e) => {
    cursorX = e.pageX;
    cursorY = e.pageY;
    updateCursor();
  };

  document.onkeyup = (e) => {
    if (e.key === 'Escape') {
      fetch('https://truckerjob/close', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: '{}'
      });
    }
  };
});
