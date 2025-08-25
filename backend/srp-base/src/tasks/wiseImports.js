const repo = require('../repositories/wiseImportsRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');
const cronRepo = require('../repositories/cronRepository');
const logger = require('../utils/logger');

const INTERVAL_MS = 600000; // 10 minutes
const JOB_NAME = 'wise-imports-ready';

cronRepo
  .createJob({
    name: JOB_NAME,
    schedule: `interval:${INTERVAL_MS}`,
    payload: null,
    priority: 0,
    nextRun: new Date(Date.now() + INTERVAL_MS).toISOString(),
  })
  .catch((err) => logger.error({ err }, 'Failed to ensure wise-imports cron job'));

async function notifyReady() {
  const cutoff = Date.now() - INTERVAL_MS;
  const pending = await repo.listPendingOlderThan(cutoff);
  for (const order of pending) {
    const updatedAt = await repo.markReady(order.id);
    if (updatedAt) {
      const payload = { id: order.id, characterId: order.characterId, model: order.model, status: 'ready', updatedAt };
      websocket.broadcast('wise-imports', 'order-ready', { order: payload });
      hooks.dispatch('wise-imports.order.ready', payload);
    }
  }
}

module.exports = { notifyReady, INTERVAL_MS, JOB_NAME };
