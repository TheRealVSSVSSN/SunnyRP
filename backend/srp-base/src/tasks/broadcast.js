const config = require('../config/env');
const repo = require('../repositories/broadcastRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'broadcast-purge';
const INTERVAL_MS = 3600000; // hourly

async function purgeOld() {
  try {
    const cutoff = new Date(Date.now() - config.broadcast.retentionMs);
    const removed = await repo.deleteOlderThan(cutoff.toISOString().slice(0, 19).replace('T', ' '));
    if (removed) logger.info({ removed }, 'Pruned stale broadcast messages');
  } catch (err) {
    logger.error({ err }, 'Failed to prune broadcast messages');
  }
}

module.exports = { purgeOld, JOB_NAME, INTERVAL_MS };
