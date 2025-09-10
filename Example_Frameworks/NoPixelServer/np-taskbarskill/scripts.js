let percent = 0;

const progressBar = document.getElementById('progress-bar');
const skillProgress = document.querySelector('.skillprogress');
const wrapper = document.querySelector('.divwrap');

// Handle key press for ending the task
// E key submits the current progress to the client
window.addEventListener('keydown', (event) => {
  if (event.key === 'e' || event.key === 'E') {
    closeMain();
    fetch(`https://np-taskbarskill/taskEnd`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({ taskResult: percent })
    });
  }
});

function openMain() {
  wrapper.style.display = 'block';
}

function closeMain() {
  wrapper.style.display = 'none';
}

// Listen for messages from Lua
window.addEventListener('message', (event) => {
  const item = event.data;

  if (item.runProgress) {
    percent = 0;
    openMain();
    progressBar.style.width = '0%';
    skillProgress.style.left = `${item.chance}%`;
    skillProgress.style.width = `${item.skillGap}%`;
    skillProgress.style.backgroundColor = 'rgba(255,250,250,0.4)';
  }

  if (item.runUpdate) {
    percent = item.Length;
    progressBar.style.width = `${item.Length}%`;

    if (item.Length < (item.chance + item.skillGap) && item.Length > item.chance) {
      skillProgress.style.backgroundColor = 'rgba(120,50,50,0.9)';
    } else {
      skillProgress.style.backgroundColor = 'rgba(255,250,250,0.4)';
    }
  }

  if (item.closeFail) {
    closeMain();
    fetch(`https://np-taskbarskill/taskCancel`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({})
    });
  }

  if (item.closeProgress) {
    closeMain();
  }
});
