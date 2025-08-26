const carwashRepo = require('../repositories/carwashRepository');

const JOB_NAME = 'carwash-dirt-tick';
const INTERVAL_MS = 15 * 60 * 1000; // 15 minutes
const DELTA = 1;
const MAX_DIRT = 100;

async function tick(wss) {
  const updated = await carwashRepo.incrementDirt(DELTA, MAX_DIRT);
  updated.forEach((row) => {
    wss.broadcast('vehicles', 'dirt.update', { plate: row.plate, dirt: row.dirt_level });
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, tick };
