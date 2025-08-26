const cameraRepo = require('../repositories/cameraRepository');
const config = require('../config/env');

const JOB_NAME = 'camera-photo-purge';
const INTERVAL_MS = config.camera.cleanupIntervalMs;

async function purgeOld() {
  await cameraRepo.deletePhotosOlderThan(config.camera.retentionMs);
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
