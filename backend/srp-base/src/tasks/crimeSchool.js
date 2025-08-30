const crimeSchoolRepo = require('../repositories/crimeSchoolRepository');
const env = require('../config/env');

const JOB_NAME = 'crime-school-expiry';
const INTERVAL_MS = env.crimeSchool?.purgeIntervalMs || 3600000; // 1h
const RETENTION_DAYS = env.crimeSchool?.retentionDays || 30;

async function purgeOld() {
  const cutoff = new Date(Date.now() - RETENTION_DAYS * 24 * 60 * 60 * 1000);
  await crimeSchoolRepo.deleteOlderThan(cutoff);
}

module.exports = { JOB_NAME, INTERVAL_MS, purgeOld };
