const repo = require('../repositories/interactSoundRepository');
const config = require('../config/env');

async function purgeOld() {
  const ttl = config.interactSound.retentionMs || 7 * 24 * 60 * 60 * 1000;
  const cutoff = Date.now() - ttl;
  await repo.deleteOlderThan(cutoff);
}

module.exports = { purgeOld };
