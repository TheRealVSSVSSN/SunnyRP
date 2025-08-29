const minimapRepo = require('../repositories/minimapRepository');

const JOB_NAME = 'minimap-blips-broadcast';
const INTERVAL_MS = 30000;

async function broadcastBlips(wss) {
  const blips = await minimapRepo.listBlips();
  wss.broadcast('world', 'minimap.blips', { blips });
}

module.exports = { JOB_NAME, INTERVAL_MS, broadcastBlips };
