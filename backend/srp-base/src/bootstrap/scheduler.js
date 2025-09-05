import { setTimeout as delay } from 'timers/promises';
import { randomInt } from 'crypto';
import { logger } from '../util/logger.js';
import { getSchedulerRun, setSchedulerRun } from '../repositories/scheduler.js';
import { purgeErrors, getRestartSchedule, clearRestartSchedule } from '../repositories/telemetry.js';
import { emitEvent } from '../websockets/gateway.js';

const tasks = [];
const controllers = new Set();

export function registerTask(name, intervalMs, handler) {
  tasks.push({ name, intervalMs, handler, lastRun: 0 });
}

async function runTask(task, signal) {
  while (!signal.aborted) {
    const start = Date.now();
    try {
      await task.handler(task.lastRun);
      task.lastRun = Date.now();
      await setSchedulerRun(task.name, new Date(task.lastRun));
    } catch (err) {
      logger.error({ err, task: task.name }, 'scheduler task error');
    }
    const elapsed = Date.now() - start;
    const wait = Math.max(0, task.intervalMs - elapsed) + randomInt(0, 500);
    try {
      await delay(wait, null, { signal });
    } catch (err) {
      if (err.name === 'AbortError') break;
      throw err;
    }
  }
}

export const scheduler = {
  async start() {
    registerTask('heartbeat', 60_000, async () => logger.debug('scheduler heartbeat'));
    registerTask('telemetry_purge', 3_600_000, async () => purgeErrors(7));
    registerTask('restart_check', 60_000, async () => {
      const sched = await getRestartSchedule();
      if (sched && new Date(sched.restartAt).getTime() <= Date.now()) {
        emitEvent('telemetry', 'restart', '*', { reason: sched.reason });
        await clearRestartSchedule();
      }
    });
    for (const task of tasks) {
      const last = await getSchedulerRun(task.name);
      if (last) task.lastRun = new Date(last).getTime();
      const controller = new AbortController();
      controllers.add(controller);
      runTask(task, controller.signal).finally(() => controllers.delete(controller));
    }
  },
  stop() {
    for (const controller of controllers) {
      controller.abort();
    }
  }
};
