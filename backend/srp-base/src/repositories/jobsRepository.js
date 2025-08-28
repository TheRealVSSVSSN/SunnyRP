const db = require('./db');

/**
 * Jobs repository.  Handles persistence of job definitions and
 * character job assignments.  Jobs represent organisations or roles
 * that characters can join, such as police, EMS, mechanic, etc.
 * Assignments track which characters belong to which jobs, their
 * grade within the job and whether they are on duty.
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
 * Assign a job to a character.  Inserts or updates the character_jobs
 * record with on_duty set to 0.  Returns the assigned record.
 *
 * @param {number} characterId
 * @param {number} jobId
 * @param {number} [grade]
 * @returns {Promise<{characterId: number, jobId: number, grade: number, onDuty: boolean, hiredAt: Date}>}
 */
async function assignJob(characterId, jobId, grade = 0) {
  await db.query(
    'INSERT INTO character_jobs (character_id, job_id, grade, on_duty) VALUES (?, ?, ?, 0) ON DUPLICATE KEY UPDATE grade = VALUES(grade)',
    [characterId, jobId, grade],
  );
  const rows = await db.query(
    'SELECT character_id AS characterId, job_id AS jobId, grade, on_duty AS onDuty, hired_at AS hiredAt FROM character_jobs WHERE character_id = ? AND job_id = ?',
    [characterId, jobId],
  );
  return rows[0];
}

/**
 * Set a character's on_duty status for a given job.  Creates the
 * assignment if it does not already exist.  Returns the updated
 * record.
 *
 * @param {number} characterId
 * @param {number} jobId
 * @param {boolean} onDuty
 * @returns {Promise<object>}
 */
async function setDuty(characterId, jobId, onDuty) {
  await db.query(
    'INSERT INTO character_jobs (character_id, job_id, on_duty) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE on_duty = VALUES(on_duty)',
    [characterId, jobId, onDuty ? 1 : 0],
  );
  const rows = await db.query(
    'SELECT character_id AS characterId, job_id AS jobId, grade, on_duty AS onDuty, hired_at AS hiredAt FROM character_jobs WHERE character_id = ? AND job_id = ?',
    [characterId, jobId],
  );
  return rows[0];
}

/**
 * Retrieve a character's job assignments.  Returns an array of
 * assignments with job details and duty status.
 *
 * @param {number} characterId
 * @returns {Promise<object[]>}
 */
async function getCharacterJobs(characterId) {
  return db.query(
    `SELECT cj.character_id AS characterId, cj.job_id AS jobId, cj.grade, cj.on_duty AS onDuty, cj.hired_at AS hiredAt,
            j.name, j.label, j.description
     FROM character_jobs cj
     JOIN jobs j ON cj.job_id = j.id
     WHERE cj.character_id = ?`,
    [characterId],
  );
}

/**
 * List all on-duty characters grouped by job name. Returns an array
 * of objects like `{ job: 'police', characterId: 123 }` for each
 * active duty assignment. Used by the scheduler to broadcast duty
 * rosters so clients do not need to poll.
 *
 * @returns {Promise<Array<{job: string, characterId: number}>>}
 */
async function listOnDutyRoster() {
  return db.query(
    `SELECT j.name AS job, cj.character_id AS characterId
       FROM character_jobs cj
       JOIN jobs j ON cj.job_id = j.id
      WHERE cj.on_duty = 1`,
  );
}

module.exports = {
  listJobs,
  createJob,
  getJob,
  getJobByName,
  assignJob,
  setDuty,
  getCharacterJobs,
  listOnDutyRoster,
  /**
   * Count the number of characters currently assigned to a given job.  This
   * helper is used by modules like broadcaster to enforce limits on how
   * many characters can hold a particular role at one time.  It joins the
   * jobs table on character_jobs to look up by job name.  The on_duty
   * status is ignored so that both off and on duty assignments are
   * counted.  Returns a numeric count.
   *
   * @param {string} name Name of the job (e.g. 'broadcaster').
   * @returns {Promise<number>}
   */
  async countCharactersForJob(name) {
    const rows = await db.query(
      `SELECT COUNT(*) AS count
         FROM character_jobs cj
         JOIN jobs j ON cj.job_id = j.id
        WHERE j.name = ?`,
      [name],
    );
    return rows[0]?.count || 0;
  },
};