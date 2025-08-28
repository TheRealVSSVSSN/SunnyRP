const config = require('../config/env');
const repo = require('../repositories/debugRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'debug-maintenance';
const INTERVAL_MS = config.debug.markerCleanupIntervalMs || 60000;

async function purgeOld() {
  // Purge expired markers
  const expired = await repo.purgeExpiredMarkers();
  for (const id of expired) {
    const payload = { id };
    websocket.broadcast('debug', 'marker.expired', payload);
    hooks.dispatch('debug.marker.expired', payload);
  }
  // Purge logs older than retention
  const cutoff = new Date(Date.now() - config.debug.retentionMs).toISOString().slice(0, 19).replace('T', ' ');
  await repo.purgeOldLogs(cutoff);
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };

