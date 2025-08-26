const iplRepo = require('../repositories/iplRepository');

const JOB_NAME = 'world-ipl-sync';
const INTERVAL_MS = 60000;

async function broadcastIpls(wss) {
  const ipls = await iplRepo.list();
  wss.broadcast('world', 'ipl.sync', { ipls });
}

module.exports = { JOB_NAME, INTERVAL_MS, broadcastIpls };
