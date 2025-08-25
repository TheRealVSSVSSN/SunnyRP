const config = require('../config/env');
const AssetsRepository = require('../repositories/assetsRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'assets-prune';
const INTERVAL_MS = 3600000; // hourly

async function pruneOld() {
  try {
    const cutoff = new Date(Date.now() - config.assets.retentionMs);
    const removed = await AssetsRepository.deleteOlderThan(cutoff);
    if (removed) logger.info({ removed }, 'Pruned stale assets');
  } catch (err) {
    logger.error({ err }, 'Failed to prune assets');
  }
}

module.exports = { pruneOld, JOB_NAME, INTERVAL_MS };
