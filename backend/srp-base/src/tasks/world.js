const iplRepo = require('../repositories/iplRepository');
const worldRepo = require('../repositories/worldRepository');

const JOB_NAME = 'world-ipl-sync';
const INTERVAL_MS = 60000;
const STATE_JOB_NAME = 'world-state-sync';
const STATE_INTERVAL_MS = 30000;

async function broadcastIpls(wss) {
  const ipls = await iplRepo.list();
  wss.broadcast('world', 'ipl.sync', { ipls });
}

async function broadcastState(wss) {
  const state = await worldRepo.getWorldState();
  if (state) wss.broadcast('world', 'state.sync', state);
}

module.exports = {
  JOB_NAME,
  INTERVAL_MS,
  STATE_JOB_NAME,
  STATE_INTERVAL_MS,
  broadcastIpls,
  broadcastState,
};
