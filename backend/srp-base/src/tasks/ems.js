const emsRepo = require('../repositories/emsRepository');
const config = require('../config/env');
const dispatcher = require('../hooks/dispatcher');

const JOB_NAME = 'ems-shift-sync';
const INTERVAL_MS = config.ems.broadcastIntervalMs || 60000;

async function syncShifts(wss) {
  const maxMs = config.ems.maxShiftDurationMs || 12 * 60 * 60 * 1000;
  const cutoff = Date.now() - maxMs;
  const active = await emsRepo.getActiveShifts();
  for (const shift of active) {
    const start = new Date(shift.startTime).getTime();
    if (start < cutoff) {
      const ended = await emsRepo.endShift(shift.id);
      if (ended) {
        if (wss) wss.broadcast('ems', 'shift.ended', ended);
        dispatcher.dispatch('ems.shift.ended', ended);
      }
    }
  }
  const updated = await emsRepo.getActiveShifts();
  if (wss) wss.broadcast('ems', 'shifts.active', updated);
  dispatcher.dispatch('ems.shifts.active', updated);
}

module.exports = { JOB_NAME, INTERVAL_MS, syncShifts };
