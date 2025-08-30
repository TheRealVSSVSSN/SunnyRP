const config = require('../config/env');
const contractsRepo = require('../repositories/contractsRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'contracts-purge';
const INTERVAL_MS = 3600000; // hourly

async function purgeOld() {
  try {
    const cutoff = new Date(Date.now() - (config.contracts.retentionMs || 86400000));
    await contractsRepo.purgeExpired(cutoff);
  } catch (err) {
    logger.error({ err }, 'Failed to purge expired contracts');
  }
}

module.exports = { purgeOld, JOB_NAME, INTERVAL_MS };
