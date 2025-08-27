const coordinatesRepo = require('../repositories/coordinatesRepository');

const JOB_NAME = 'coordinates-purge';
const INTERVAL_MS = 24 * 60 * 60 * 1000; // daily

async function purgeOld() {
  await coordinatesRepo.purgeOldCoords(30);
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
