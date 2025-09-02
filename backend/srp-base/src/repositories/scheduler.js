import { query as dbQuery } from '../db/index.js';

let queryFn = dbQuery;

//[[
// Type: Function
// Name: setSchedulerQuery
// Use: Overrides query function, primarily for testing
// Created: 2025-09-09
// By: VSSVSSN
//]]
export function setSchedulerQuery(fn) {
  queryFn = fn;
}

//[[
// Type: Function
// Name: getSchedulerRun
// Use: Retrieves last run timestamp for a task
// Created: 2025-09-01
// By: VSSVSSN
//]]
export async function getSchedulerRun(name) {
  const rows = await queryFn('SELECT last_run FROM scheduler_runs WHERE task_name = ?', [name]);
  return rows[0]?.last_run || null;
}

//[[
// Type: Function
// Name: listSchedulerRuns
// Use: Lists all scheduler tasks and their last run times
// Created: 2025-09-06
// By: VSSVSSN
//]]
export async function listSchedulerRuns() {
  return queryFn('SELECT task_name, last_run FROM scheduler_runs');
}

//[[
// Type: Function
// Name: setSchedulerRun
// Use: Upserts last run timestamp for a task
// Created: 2025-09-01
// By: VSSVSSN
//]]
export async function setSchedulerRun(name, date) {
  await queryFn(
    'INSERT INTO scheduler_runs (task_name, last_run) VALUES (?, ?) ON DUPLICATE KEY UPDATE last_run = VALUES(last_run)',
    [name, date]
  );
}
