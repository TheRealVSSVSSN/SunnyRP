const k9Repo = require('../repositories/k9Repository');
const JOB_NAME = 'k9-active-broadcast';
const INTERVAL_MS = 60000;

async function broadcastActive(wss) {
  const units = await k9Repo.listActive();
  wss.broadcast('police', 'k9.activeList', { units });
}

module.exports = { JOB_NAME, INTERVAL_MS, broadcastActive };
