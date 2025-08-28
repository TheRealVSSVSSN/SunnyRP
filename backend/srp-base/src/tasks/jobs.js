const jobsRepo = require('../repositories/jobsRepository');
const dispatcher = require('../hooks/dispatcher');

const JOB_NAME = 'jobs-roster-sync';
const INTERVAL_MS = 60000; // 1 minute

async function syncRoster(wss) {
  const roster = await jobsRepo.listOnDutyRoster();
  if (wss) wss.broadcast('jobs', 'jobs.roster', { roster });
  dispatcher.dispatch('jobs.roster', { roster });
}

module.exports = { JOB_NAME, INTERVAL_MS, syncRoster };
