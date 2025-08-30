const repo = require('../repositories/dealersRepository');
const dispatcher = require('../hooks/dispatcher');
const logger = require('../utils/logger');

const JOB_NAME = 'dealer-offer-purge';
const INTERVAL_MS = 60000; // 1 minute

async function purgeExpired(wss) {
  try {
    const ids = await repo.deleteExpired(new Date());
    ids.forEach((id) => {
      const payload = { id };
      if (wss && wss.broadcast) {
        wss.broadcast('dealers', 'offer.expired', payload);
      }
      dispatcher.dispatch('dealers.offer.expired', payload);
    });
  } catch (err) {
    logger.error({ err }, 'Failed to purge dealer offers');
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeExpired };
