import test from 'node:test';
import assert from 'node:assert/strict';
import { setSchedulerQuery, getSchedulerRun, setSchedulerRun, listSchedulerRuns } from '../src/repositories/scheduler.js';

//[[
// Type: Test
// Name: Scheduler persistence
// Use: Ensures scheduler run times are stored and retrieved from persistence
// Created: 2025-09-09
// By: VSSVSSN
//]]
test('scheduler run persistence round-trip', async () => {
  const store = new Map();
  setSchedulerQuery(async (sql, params) => {
    if (sql.startsWith('SELECT last_run FROM scheduler_runs')) {
      const run = store.get(params[0]);
      return run ? [{ last_run: run }] : [];
    }
    if (sql.startsWith('SELECT task_name, last_run FROM scheduler_runs')) {
      return Array.from(store.entries()).map(([task_name, last_run]) => ({ task_name, last_run }));
    }
    if (sql.startsWith('INSERT INTO scheduler_runs')) {
      store.set(params[0], params[1]);
      return [{ affectedRows: 1 }];
    }
    throw new Error('unexpected SQL');
  });

  const now = new Date();
  await setSchedulerRun('alpha', now);
  const fetched = await getSchedulerRun('alpha');
  assert.strictEqual(fetched.toISOString(), now.toISOString());

  await setSchedulerRun('beta', now);
  const all = await listSchedulerRuns();
  const simplified = all.map(r => ({ task_name: r.task_name, last_run: r.last_run.toISOString() }));
  simplified.sort((a, b) => a.task_name.localeCompare(b.task_name));
  assert.deepEqual(simplified, [
    { task_name: 'alpha', last_run: now.toISOString() },
    { task_name: 'beta', last_run: now.toISOString() }
  ]);
});
