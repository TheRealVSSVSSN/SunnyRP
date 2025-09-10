/*
    -- Type: State Module
    -- Name: LoadingScreen
    -- Use: Handles progress bars, logging, and background rotation for the loading screen
    -- Created: 2025-09-10
    -- By: VSSVSSN
*/

(() => {
  const technicalStages = ['INIT_BEFORE_MAP_LOADED', 'MAP', 'INIT_AFTER_MAP_LOADED', 'INIT_SESSION'];
  const loadingWeights = [0.15, 0.4, 0.15, 0.3];
  const loadingTotals = [70, 70, 70, 220];
  const totalWidth = 99.1;

  const state = {
    currentStage: 0,
    currentCount: 0,
    progress: new Array(technicalStages.length).fill(0),
    stageVisible: new Array(technicalStages.length).fill(false),
    log: [],
    showLog: false,
    lastBackground: -1
  };

  const progressMax = loadingWeights.map(w => w * totalWidth);
  let count = 0;

  function updateProgress() {
    const debug = document.getElementById('debug');
    debug.innerHTML = '';
    for (let i = 0; i <= state.currentStage; i++) {
      if ((state.progress[i] > 0 || !state.progress[i - 1]) && !state.stageVisible[i]) {
        const bar = document.getElementById(`${technicalStages[i]}-bar`);
        const label = document.getElementById(`${technicalStages[i]}-label`);
        if (bar) {
          bar.style.display = 'inline-block';
          state.stageVisible[i] = true;
        }
        if (label) label.style.display = 'inline-block';
      }

      const barEl = document.getElementById(`${technicalStages[i]}-bar`);
      const labelEl = document.getElementById(`${technicalStages[i]}-label`);
      if (barEl) barEl.style.width = `${state.progress[i] * progressMax[i]}%`;
      if (labelEl) labelEl.style.width = `${progressMax[i]}%`;
      debug.innerHTML += `${technicalStages[i]}: ${state.progress[i]}<br />`;
    }
  }

  function doProgress(stage) {
    const idx = technicalStages.indexOf(stage);
    if (idx === -1) return;
    if (idx > state.currentStage) {
      while (state.currentStage < idx) {
        state.progress[state.currentStage] = 1;
        state.currentStage++;
      }
      state.currentCount = 1;
    } else {
      state.currentCount++;
    }
    state.progress[state.currentStage] = Math.min(state.currentCount / loadingTotals[idx], 1);
    updateProgress();
  }

  function printLog(type, str) {
    state.log.push({ type, str });
  }

  function refreshLog() {
    if (!state.showLog) return;
    const container = document.getElementById('log');
    container.innerHTML = state.log.slice(-10).map(e => `[${e.type}] ${e.str}`).join('<br />');
  }

  function toggleLog() {
    state.showLog = !state.showLog;
    document.getElementById('log-container').style.display = state.showLog ? 'block' : 'none';
  }

  document.addEventListener('keydown', e => {
    if (e.key === 'g' || e.key === 'G') toggleLog();
  });

  setInterval(refreshLog, 100);

  const handlers = {
    startInitFunction(data) {
      printLog(1, `Running ${data.type} init functions`);
      if (data.type) doProgress(data.type);
    },
    startInitFunctionOrder(data) {
      count = data.count;
      printLog(1, `[${data.type}] Running functions of order ${data.order} (${data.count} total)`);
      if (data.type) doProgress(data.type);
    },
    initFunctionInvoking(data) {
      printLog(3, `Invoking ${data.name} ${data.type} init (${data.idx} of ${count})`);
      if (data.type) doProgress(data.type);
    },
    initFunctionInvoked(data) {
      if (data.type) doProgress(data.type);
    },
    endInitFunction(data) {
      printLog(1, `Done running ${data.type} init functions`);
      if (data.type) doProgress(data.type);
    },
    startDataFileEntries(data) {
      count = data.count;
      printLog(1, 'Loading map');
      if (data.type) doProgress(data.type);
    },
    onDataFileEntry(data) {
      printLog(3, `Loading ${data.name}`);
      if (data.type) doProgress(data.type);
    },
    endDataFileEntries() {
      printLog(1, 'Done loading map');
    },
    performMapLoadFunction() {
      doProgress('MAP');
    },
    onLogLine(data) {
      printLog(3, data.message);
    }
  };

  window.addEventListener('message', e => {
    const handler = handlers[e.data.eventName];
    if (handler) handler(e.data);
  });

  const usedBackgrounds = [];

  function randomBackground(max) {
    let index = Math.floor(Math.random() * max);
    if (index === state.lastBackground) {
      index = Math.floor(Math.random() * max);
    }
    state.lastBackground = index;
    return index;
  }

  function generateBackground() {
    const images = document.querySelectorAll('#background img');
    if (usedBackgrounds.length === images.length) {
      usedBackgrounds.length = 0;
    }
    let idx = randomBackground(images.length);
    while (usedBackgrounds.includes(idx)) {
      idx = randomBackground(images.length);
    }
    usedBackgrounds.push(idx);
    images.forEach((img, i) => {
      img.style.opacity = i === idx ? 1 : 0;
      if (i === idx) triggerAnimation(img.id);
    });
  }

  function triggerAnimation(id) {
    const el = document.getElementById(id);
    el.style.animation = 'none';
    void el.offsetHeight;
    el.style.animation = null;
  }

  setInterval(generateBackground, 9000);

  generateBackground();
  updateProgress();
})();
