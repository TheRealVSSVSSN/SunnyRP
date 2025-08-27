const hudRepo = require('../repositories/vehicleStatusRepository');
const config = require('../config/env');

const JOB_NAME = 'hud-status-prune';
const INTERVAL_MS = 60 * 60 * 1000; // hourly

async function pruneOld() {
  const ttl = config.hudStatusTtlMs || 60 * 60 * 1000; // default 1h
  await hudRepo.pruneStale(ttl);
}

module.exports = { JOB_NAME, INTERVAL_MS, pruneOld };
