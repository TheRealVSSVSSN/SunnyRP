const config = require('../config/env');
const FurnitureRepository = require('../repositories/furnitureRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'furniture-purge';
const INTERVAL_MS = 86400000; // daily

async function purgeOld() {
  try {
    const cutoff = new Date(Date.now() - config.furniture.retentionMs);
    const removed = await FurnitureRepository.deleteOlderThan(cutoff);
    if (removed) logger.info({ removed }, 'Pruned stale furniture records');
  } catch (err) {
    logger.error({ err }, 'Failed to prune furniture records');
  }
}

module.exports = { purgeOld, JOB_NAME, INTERVAL_MS };
