const repo = require('../repositories/emsVehiclesRepository');
const config = require('../config/env');

const JOB_NAME = 'ems-vehicle-spawn-purge';
const INTERVAL_MS = config.emsVehicles.purgeIntervalMs || 3600000;

async function purgeOld() {
  const retention = config.emsVehicles.retentionMs || 2592000000;
  const cutoff = Date.now() - retention;
  await repo.deleteSpawnsBefore(cutoff);
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
