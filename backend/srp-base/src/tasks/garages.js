const config = require('../config/env');
const repo = require('../repositories/garagesRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'garage-vehicle-purge';
const INTERVAL_MS = 3600000; // hourly

async function purgeRetrieved() {
  try {
    const cutoff = new Date(Date.now() - config.garages.retentionMs);
    await repo.deleteRetrievedBefore(cutoff);
  } catch (err) {
    logger.error({ err }, 'Failed to purge retrieved garage vehicles');
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeRetrieved };

