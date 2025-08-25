const repo = require('../repositories/wiseWheelsRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'wise-wheels-expire';
const INTERVAL_MS = 3600000; // 1 hour
const RETENTION_MS = 30 * 24 * 60 * 60 * 1000; // 30 days

async function purgeOld() {
  const cutoff = Date.now() - RETENTION_MS;
  const ids = await repo.purgeOldSpins(cutoff);
  ids.forEach((id) => {
    websocket.broadcast('wise-wheels', 'spin.expired', { id });
    hooks.dispatch('wise-wheels.spin.expired', { id });
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
