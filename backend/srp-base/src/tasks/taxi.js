const taxiRepo = require('../repositories/taxiRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');
const config = require('../config/env');

const JOB_NAME = 'taxi-request-expiry';
const INTERVAL_MS = 60000;

async function expireRequests() {
  const count = await taxiRepo.cancelStaleRequests(config.taxi.requestTtlMs);
  if (count > 0) {
    const payload = { expired: count };
    websocket.broadcast('taxi', 'request.expired', payload);
    dispatcher.dispatch('taxi.request.expired', payload);
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, expireRequests };
