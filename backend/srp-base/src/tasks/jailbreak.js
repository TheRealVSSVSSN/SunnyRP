const jailbreakRepo = require('../repositories/jailbreakRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');
const config = require('../config/env');

const JOB_NAME = 'jailbreak-expire';
const INTERVAL_MS = 60000;

async function expireStale() {
  const attempts = await jailbreakRepo.expireStale(config.jailbreak.maxActiveMs);
  attempts.forEach((attempt) => {
    websocket.broadcast('jailbreaks', 'expired', { attempt });
    dispatcher.dispatch('jailbreak.expired', { attempt });
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, expireStale };
