const worldRepo = require('../repositories/worldRepository');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'timecycle-expiry';
const INTERVAL_MS = 60000; // 1 minute

async function expireAndBroadcast(wss) {
  try {
    const override = await worldRepo.getTimecycleOverride();
    if (override && override.expiresAt && new Date(override.expiresAt) <= new Date()) {
      await worldRepo.clearTimecycleOverride();
      if (wss) {
        wss.broadcast('world', 'timecycle.clear', {});
      }
      hooks.dispatch('world.timecycle.clear', {});
    }
  } catch (err) {
    // scheduler logs errors
  }
}

module.exports = { JOB_NAME, INTERVAL_MS, expireAndBroadcast };
