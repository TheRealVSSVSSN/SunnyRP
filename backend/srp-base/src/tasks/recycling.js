const config = require('../config/env');
const repo = require('../repositories/recyclingRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'recycling-purge';
const INTERVAL_MS = 3600000; // hourly

async function purgeOld() {
  try {
    const cutoff = new Date(Date.now() - config.recycling.retentionMs);
    const removed = await repo.deleteOlderThan(cutoff);
    if (removed) logger.info({ removed }, 'Pruned stale recycling runs');
  } catch (err) {
    logger.error({ err }, 'Failed to prune recycling runs');
  }
}

module.exports = { purgeOld, JOB_NAME, INTERVAL_MS };
