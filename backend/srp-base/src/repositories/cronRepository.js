const db = require('./db');

/**
 * Retrieve all scheduled cron jobs.
 * Jobs may be global or scoped to an account/character.
 * @returns {Promise<Array>} List of cron job records
 */
async function getAllJobs() {
  const rows = await db.query(
    'SELECT id, name, schedule, payload, account_id AS accountId, character_id AS characterId, priority, next_run AS nextRun, last_run AS lastRun, created_at AS createdAt, updated_at AS updatedAt FROM cron_jobs ORDER BY id ASC',
  );
  return rows.map((row) => ({
    id: row.id,
    name: row.name,
    schedule: row.schedule,
    payload: row.payload ? JSON.parse(row.payload) : null,
    accountId: row.accountId,
    characterId: row.characterId,
    priority: row.priority,
    nextRun: row.nextRun,
    lastRun: row.lastRun,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
}

/**
 * Create or replace a cron job by name.
 * Uses INSERT ... ON DUPLICATE KEY UPDATE for idempotency.
 *
 * @param {Object} params
 * @param {string} params.name
 * @param {string} params.schedule
 * @param {Object|null} [params.payload]
 * @param {number|null} [params.accountId]
 * @param {number|null} [params.characterId]
 * @param {number} params.priority
 * @param {string} params.nextRun ISO datetime string
 * @returns {Promise<Object>} Stored cron job
 */
async function createJob({ name, schedule, payload, accountId, characterId, priority, nextRun }) {
  await db.query(
    'INSERT INTO cron_jobs (name, schedule, payload, account_id, character_id, priority, next_run) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE schedule = VALUES(schedule), payload = VALUES(payload), account_id = VALUES(account_id), character_id = VALUES(character_id), priority = VALUES(priority), next_run = VALUES(next_run)',
    [name, schedule, payload ? JSON.stringify(payload) : null, accountId, characterId, priority, nextRun],
  );
  const rows = await db.query(
    'SELECT id, name, schedule, payload, account_id AS accountId, character_id AS characterId, priority, next_run AS nextRun, last_run AS lastRun, created_at AS createdAt, updated_at AS updatedAt FROM cron_jobs WHERE name = ?',
    [name],
  );
  const row = rows[0];
  return {
    id: row.id,
    name: row.name,
    schedule: row.schedule,
    payload: row.payload ? JSON.parse(row.payload) : null,
    accountId: row.accountId,
    characterId: row.characterId,
    priority: row.priority,
    nextRun: row.nextRun,
    lastRun: row.lastRun,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  };
}

async function updateLastRun(name, lastRun) {
  await db.query('UPDATE cron_jobs SET last_run = ? WHERE name = ?', [lastRun, name]);
}

/**
 * Fetch cron jobs that are due to run.
 * Jobs are ordered by priority (desc) then next_run.
 *
 * @param {number} [limit=50] maximum number of jobs to return
 * @returns {Promise<Array>} due cron jobs
 */
async function getDueJobs(limit = 50) {
  const rows = await db.query(
    'SELECT id, name, schedule, payload, account_id AS accountId, character_id AS characterId, priority, next_run AS nextRun, last_run AS lastRun, created_at AS createdAt, updated_at AS updatedAt FROM cron_jobs WHERE next_run <= NOW() ORDER BY priority DESC, next_run ASC LIMIT ?',
    [limit],
  );
  return rows.map((row) => ({
    id: row.id,
    name: row.name,
    schedule: row.schedule,
    payload: row.payload ? JSON.parse(row.payload) : null,
    accountId: row.accountId,
    characterId: row.characterId,
    priority: row.priority,
    nextRun: row.nextRun,
    lastRun: row.lastRun,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
}

/**
 * Update job next_run and last_run after execution.
 *
 * @param {number} id cron job id
 * @param {string} nextRun ISO datetime for next execution
 */
async function markRan(id, nextRun) {
  await db.query('UPDATE cron_jobs SET last_run = NOW(), next_run = ? WHERE id = ?', [nextRun, id]);
}

module.exports = {
  getAllJobs,
  createJob,
  updateLastRun,
  getDueJobs,
  markRan,
};
