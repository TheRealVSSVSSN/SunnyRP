const repo = require('../repositories/policeRepository');
const config = require('../config/env');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');

const JOB_NAME = 'police-duty-check';
const INTERVAL_MS = config.police.checkIntervalMs || 300000;

async function clearStale() {
  const cutoff = new Date(Date.now() - config.police.dutyTimeoutMs);
  const offDuty = await repo.setOffDutyOlderThan(cutoff);
  offDuty.forEach((o) => {
    const payload = { characterId: o.character_id, onDuty: 0 };
    websocket.broadcast('police', 'duty', payload);
    hooks.dispatch('police.duty', payload);
  });
}

module.exports = { JOB_NAME, INTERVAL_MS, clearStale };
