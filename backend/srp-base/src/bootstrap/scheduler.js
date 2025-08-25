const logger = require('../utils/logger');

const tasks = [];

function schedule(task) {
  const jitter = task.jitter ? Math.random() * task.jitter : 0;
  const delay = Math.max(task.nextRun + jitter - Date.now(), 0);
  setTimeout(async () => {
    task.lastRun = Date.now();
    try {
      await task.fn(task);
    } catch (err) {
      logger.error({ err }, `Scheduler task ${task.name} failed`);
    }
    task.nextRun += task.intervalMs;
    schedule(task);
  }, delay);
}

function register(name, fn, intervalMs, options = {}) {
  const task = {
    name,
    fn,
    intervalMs,
    jitter: options.jitter || 0,
    lastRun: 0,
    nextRun: Date.now() + intervalMs,
  };
  tasks.push(task);
  schedule(task);
}

module.exports = { register, tasks };
