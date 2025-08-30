const mechanicRepo = require('../repositories/mechanicRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'mechanic-process';
const INTERVAL_MS = 10000; // every 10s

async function processOrders() {
  const pending = await mechanicRepo.listPending();
  const now = Date.now();
  for (const order of pending) {
    if (now - new Date(order.createdAt).getTime() > 15000) {
      await mechanicRepo.completeOrder(order.id);
      const payload = { id: order.id, vehiclePlate: order.vehiclePlate, characterId: order.characterId };
      websocket.broadcast('mechanic', 'orders.completed', payload);
      hooks.dispatch('mechanic.orders.completed', payload);
    }
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, processOrders };
