const db = require('./db');

/**
 * Jobs repository.  Handles persistence of job definitions and
 * player job assignments.  Jobs represent organisations or roles
 * that players can join, such as police, EMS, mechanic, etc.
 * Assignments track which players belong to which jobs and
 * whether they are on duty.
 */

/**
 * List all defined jobs.  Returns an array of job objects.
 *
 * @returns {Promise<object[]>}
 */
async function listJobs() {
  return db.query('SELECT id, name, label, description, created_at AS createdAt FROM jobs');
}

/**
 * Create a new job.  The name must be unique.  Returns the
 * newly created job record.
 *
 * @param {{name: string, label?: string, description?: string}} data
 * @returns {Promise<object>}
 */
async function createJob({ name, label = null, description = null }) {
  const result = await db.pool.query(
    'INSERT INTO jobs (name, label, description) VALUES (?, ?, ?)',
    [name, label, description],
  );
  const id = result[0].insertId;
  const rows = await db.query('SELECT id, name, label, description, created_at AS createdAt FROM jobs WHERE id = ?', [id]);
  return rows[0];
}

/**
 * Get a single job by its ID.  Returns null if not found.
 *
 * @param {number} id
 * @returns {Promise<object|null>}
 */
async function getJob(id) {
  const rows = await db.query(
    'SELECT id, name, label, description, created_at AS createdAt FROM jobs WHERE id = ? LIMIT 1',
    [id],
  );
  return rows[0] || null;
}

/**
 * Retrieve a job record by its name.  Returns null if no job with
 * that name exists.  Useful for modules that need to look up jobs
 * by a stable identifier, such as the broadcaster role.
 *
 * @param {string} name
 * @returns {Promise<object|null>}
 */
async function getJobByName(name) {
  const rows = await db.query(
    'SELECT id, name, label, description, created_at AS createdAt FROM jobs WHERE name = ? LIMIT 1',
    [name],
  );
  return rows[0] || null;
}

/**
 * Assign a job to a player.  Inserts or updates the player_jobs
 * record with on_duty set to 0.  Returns the assigned record.
 *
 * @param {string} playerId
 * @param {number} jobId
 * @returns {Promise<{player_id: string, job_id: number, on_duty: boolean, hired_at: Date}>}
 */
async function assignJob(playerId, jobId) {
  // Upsert assignment; MySQL 5.7 syntax using ON DUPLICATE KEY UPDATE
  await db.query(
    'INSERT INTO player_jobs (player_id, job_id, on_duty) VALUES (?, ?, 0) ON DUPLICATE KEY UPDATE on_duty = VALUES(on_duty)',
    [playerId, jobId],
  );
  const rows = await db.query(
    'SELECT player_id AS playerId, job_id AS jobId, on_duty AS onDuty, hired_at AS hiredAt FROM player_jobs WHERE player_id = ? AND job_id = ?',
    [playerId, jobId],
  );
  return rows[0];
}

/**
 * Set a player's on_duty status for a given job.  Creates the
 * assignment if it does not already exist.  Returns the updated
 * record.
 *
 * @param {string} playerId
 * @param {number} jobId
 * @param {boolean} onDuty
 * @returns {Promise<object>}
 */
async function setDuty(playerId, jobId, onDuty) {
  await db.query(
    'INSERT INTO player_jobs (player_id, job_id, on_duty) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE on_duty = VALUES(on_duty)',
    [playerId, jobId, onDuty ? 1 : 0],
  );
  const rows = await db.query(
    'SELECT player_id AS playerId, job_id AS jobId, on_duty AS onDuty, hired_at AS hiredAt FROM player_jobs WHERE player_id = ? AND job_id = ?',
    [playerId, jobId],
  );
  return rows[0];
}

/**
 * Retrieve a player's job assignments.  Returns an array of
 * assignments with job details and duty status.
 *
 * @param {string} playerId
 * @returns {Promise<object[]>}
 */
async function getPlayerJobs(playerId) {
  return db.query(
    `SELECT pj.player_id AS playerId, pj.job_id AS jobId, pj.on_duty AS onDuty, pj.hired_at AS hiredAt,
            j.name, j.label, j.description
     FROM player_jobs pj
     JOIN jobs j ON pj.job_id = j.id
     WHERE pj.player_id = ?`,
    [playerId],
  );
}

module.exports = {
  listJobs,
  createJob,
  getJob,
  getJobByName,
  assignJob,
  setDuty,
  getPlayerJobs,
  /**
   * Count the number of players currently assigned to a given job.  This
   * helper is used by modules like broadcaster to enforce limits on how
   * many players can hold a particular role at one time.  It joins the
   * jobs table on player_jobs to look up by job name.  The on_duty
   * status is ignored so that both off and on duty assignments are
   * counted.  Returns a numeric count.
   *
   * @param {string} name Name of the job (e.g. 'broadcaster').
   * @returns {Promise<number>}
   */
  async countPlayersForJob(name) {
    const rows = await db.query(
      `SELECT COUNT(*) AS count
         FROM player_jobs pj
         JOIN jobs j ON pj.job_id = j.id
        WHERE j.name = ?`,
      [name],
    );
    return rows[0]?.count || 0;
  },
};