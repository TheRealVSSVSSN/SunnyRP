const Properties = require('../repositories/propertiesRepository');

const JOB_NAME = 'properties-expire';
const INTERVAL_MS = 3600000; // hourly

async function releaseExpired() {
  await Properties.releaseExpiredLeases();
}

module.exports = { JOB_NAME, INTERVAL_MS, releaseExpired };
