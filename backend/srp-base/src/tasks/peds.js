const pedsRepo = require('../repositories/pedsRepository');

const JOB_NAME = 'peds-health-regen';
const INTERVAL_MS = 60000; // 1 minute

async function regenAndBroadcast(wss) {
  const amount = 1;
  try {
    const count = await pedsRepo.regenAll(amount);
    if (wss && count > 0) {
      wss.broadcast('peds', 'healthRegen', { amount, count });
    }
  } catch (err) {
    // swallow errors; scheduler logs externally
  }
}

module.exports = { regenAndBroadcast, JOB_NAME, INTERVAL_MS };
