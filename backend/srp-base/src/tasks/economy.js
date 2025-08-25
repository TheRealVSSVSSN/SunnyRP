const config = require('../config/env');
const invoiceRepo = require('../repositories/invoiceRepository');
const logger = require('../utils/logger');

const JOB_NAME = 'invoice-purge';
const INTERVAL_MS = 3600000; // hourly

async function purgeOld() {
  try {
    const cutoff = new Date(Date.now() - (config.invoiceRetentionMs || 30 * 24 * 3600 * 1000));
    await invoiceRepo.purgeSettled(cutoff);
  } catch (err) {
    logger.error({ err }, 'Failed to purge invoices');
  }
}

module.exports = { purgeOld, JOB_NAME, INTERVAL_MS };
