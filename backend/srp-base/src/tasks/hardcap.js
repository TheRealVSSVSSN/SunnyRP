const config = require('../config/env');
const hardcapRepo = require('../repositories/hardcapRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const JOB_NAME = 'hardcap-session-expiry';
const INTERVAL_MS = 60_000;

async function purgeStale() {
  const expired = await hardcapRepo.purgeStale(config.hardcap.sessionTimeoutMs);
  expired.forEach((session) => {
    websocket.broadcast('hardcap', 'session.expired', session);
    dispatcher.dispatch('hardcap.session.expired', session);
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeStale };
