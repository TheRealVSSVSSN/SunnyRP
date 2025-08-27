const config = require('../config/env');
const repo = require('../repositories/emotesRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'emotes-purge';
const INTERVAL_MS = 3600000; // 1 hour

async function purgeOld() {
  const cutoff = Date.now() - config.emotes.retentionMs;
  const expired = await repo.purgeOldEmotes(cutoff);
  expired.forEach((row) => {
    websocket.broadcast('emotes', 'favoriteExpired', row);
    hooks.dispatch('emotes.favoriteExpired', row);
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
