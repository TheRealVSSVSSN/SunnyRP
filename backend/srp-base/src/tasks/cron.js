const parser = require('cron-parser');
const cronRepo = require('../repositories/cronRepository');
const websocket = require('../realtime/websocket');
const hooks = require('../hooks/dispatcher');
const logger = require('../utils/logger');

const JOB_NAME = 'cron-executor';
const INTERVAL_MS = 60000; // check every minute

async function runDue() {
  try {
    const jobs = await cronRepo.getDueJobs();
    for (const job of jobs) {
      // Broadcast over WebSocket
      websocket.broadcast('cron', 'execute', job);
      // Dispatch to webhooks
      hooks.dispatch('cron.execute', job);
      let nextRun;
      try {
        const iter = parser.parseExpression(job.schedule, { currentDate: new Date(job.nextRun) });
        nextRun = iter.next().toISOString();
      } catch (err) {
        logger.error({ err, job }, 'Failed to parse cron schedule');
        // fallback: run again in one hour
        nextRun = new Date(Date.now() + 3600000).toISOString();
      }
      await cronRepo.markRan(job.id, nextRun);
    }
  } catch (err) {
    logger.error({ err }, 'Cron executor failed');
  }
}

module.exports = { runDue, JOB_NAME, INTERVAL_MS };
