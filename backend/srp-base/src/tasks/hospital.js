const hospitalRepo = require('../repositories/hospitalRepository');
const config = require('../config/env');
const dispatcher = require('../hooks/dispatcher');

const JOB_NAME = 'hospital-admissions-sync';
const INTERVAL_MS = config.hospital.broadcastIntervalMs || 60000;

async function syncAdmissions(wss) {
  const maxMs = config.hospital.maxAdmissionDurationMs || 6 * 60 * 60 * 1000;
  const cutoff = Date.now() - maxMs;
  const active = await hospitalRepo.getActiveAdmissions();
  for (const adm of active) {
    const start = new Date(adm.admittedAt).getTime();
    if (start < cutoff) {
      const discharged = await hospitalRepo.dischargeAdmission(adm.id);
      if (discharged) {
        if (wss) wss.broadcast('hospital', 'admission.discharged', discharged);
        dispatcher.dispatch('hospital.admission.discharged', discharged);
      }
    }
  }
  const updated = await hospitalRepo.getActiveAdmissions();
  if (wss) wss.broadcast('hospital', 'admissions.active', updated);
  dispatcher.dispatch('hospital.admissions.active', updated);
}

module.exports = { JOB_NAME, INTERVAL_MS, syncAdmissions };
