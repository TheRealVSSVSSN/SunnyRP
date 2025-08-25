const repo = require('../repositories/dispatchRepository');
const config = require('../config/env');

async function purgeOld() {
  const ttl = config.dispatch.retentionMs || 24 * 60 * 60 * 1000;
  const cutoff = Date.now() - ttl;
  await repo.deleteOlderThan(cutoff);
}

module.exports = { purgeOld };
