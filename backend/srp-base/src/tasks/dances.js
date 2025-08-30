const config = require('../config/env');
const repo = require('../repositories/dancesRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'dances-purge';
const INTERVAL_MS = 3600000; // 1 hour

async function purgeOld() {
  const cutoff = Date.now() - config.dances.retentionMs;
  const expired = await repo.purgeOldDisabled(cutoff);
  expired.forEach((row) => {
    websocket.broadcast('dances', 'animationExpired', row);
    hooks.dispatch('dances.animationExpired', row);
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
