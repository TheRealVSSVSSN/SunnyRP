const connectqueueRepo = require('../repositories/connectqueueRepository');
const websocket = require('../realtime/websocket');
const dispatcher = require('../hooks/dispatcher');

const JOB_NAME = 'connectqueue-expiry';
const INTERVAL_MS = 60_000;

async function purgeExpired() {
  const expired = await connectqueueRepo.purgeExpired();
  expired.forEach((accountId) => {
    const payload = { accountId };
    websocket.broadcast('connectqueue', 'priority.expired', payload);
    dispatcher.dispatch('connectqueue.priority.expired', payload);
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeExpired };
