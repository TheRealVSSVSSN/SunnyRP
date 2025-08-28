const hackingRepo = require('../repositories/hackingRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');
const config = require('../config/env');

const JOB_NAME = 'hacking-purge';
const INTERVAL_MS = 60000;

async function purgeOld() {
  const removed = await hackingRepo.deleteOldAttempts(config.hacking.retentionMs);
  if (removed > 0) {
    const payload = { removed };
    websocket.broadcast('hacking', 'attempts.purged', payload);
    dispatcher.dispatch('hacking.attempts.purged', payload);
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
