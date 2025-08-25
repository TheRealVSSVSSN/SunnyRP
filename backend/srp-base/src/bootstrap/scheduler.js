const logger = require('../utils/logger');

const tasks = [];

function schedule(task) {
  const delay = task.intervalMs + (task.jitter ? Math.random() * task.jitter : 0);
  setTimeout(async () => {
    try {
      await task.fn();
    } catch (err) {
      logger.error({ err }, `Scheduler task ${task.name} failed`);
    }
    schedule(task);
  }, delay);
}

function register(name, fn, intervalMs, options = {}) {
  const task = { name, fn, intervalMs, jitter: options.jitter || 0 };
  tasks.push(task);
  schedule(task);
}

module.exports = { register };
