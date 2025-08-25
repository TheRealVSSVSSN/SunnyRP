const repo = require('../repositories/baseEventsRepository');
const config = require('../config/env');

async function purgeOld() {
  const ttl = config.baseEvents.retentionMs || 30 * 24 * 60 * 60 * 1000;
  const cutoff = Date.now() - ttl;
  await repo.deleteOlderThan(cutoff);
}

module.exports = { purgeOld, JOB_NAME: 'base-events-purge', INTERVAL_MS: 3600000 };
