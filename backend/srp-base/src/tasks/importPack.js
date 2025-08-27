const repo = require('../repositories/importPackRepository');
const config = require('../config/env');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'import-pack-expiry';
const INTERVAL_MS = config.importPack.cleanupIntervalMs || 60000;

async function expireStale() {
  const expired = await repo.expireOrders(Date.now());
  expired.forEach((order) => {
    websocket.broadcast('import-pack', 'order.expired', order);
    hooks.dispatch('import-pack.order.expired', order);
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, expireStale };
