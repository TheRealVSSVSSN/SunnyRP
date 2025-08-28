const config = require('../config/env');
const repo = require('../repositories/vehicleControlRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'vehicle-control-prune';
const INTERVAL_MS = 3600000; // hourly

async function purgeOld() {
  try {
    const cutoff = new Date(Date.now() - config.vehicleControl.retentionMs);
    const removed = await repo.deleteOlderThan(cutoff);
    if (removed) logger.info({ removed }, 'Pruned stale vehicle control states');
  } catch (err) {
    logger.error({ err }, 'Failed to prune vehicle control states');
  }
}

module.exports = { purgeOld, JOB_NAME, INTERVAL_MS };
