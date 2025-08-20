const db = require('./db');

/**
 * Repository for secondary jobs.  Players may hold one or more
 * secondary jobs in addition to their primary role.  Each record
 * associates a character with a job name and timestamps when the
 * assignment was created or updated.
 */

/**
 * List all secondary jobs for a given player.  Returns an array of
 * objects with `id`, `playerId`, `job`, `createdAt` and `updatedAt`
 * properties.  If the player has no secondary jobs, an empty array
 * is returned.
 *
 * @param {string} playerId Character identifier to filter by
 * @returns {Promise<Array<{id:number,playerId:string,job:string,createdAt:string,updatedAt:string}>>}
 */
async function listSecondaryJobs(playerId) {
  const rows = await db.query(
    'SELECT id, player_id AS playerId, job, created_at AS createdAt, updated_at AS updatedAt FROM secondary_jobs WHERE player_id = ?',
    [playerId],
  );
  return rows.map((row) => ({
    id: row.id,
    playerId: row.playerId,
    job: row.job,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
}

/**
 * Create a new secondary job assignment.  Inserts a row into the
 * secondary_jobs table and returns the new record ID.
 *
 * @param {{playerId: string, job: string}} params
 * @returns {Promise<number>} The ID of the created record
 */
async function createSecondaryJob({ playerId, job }) {
  const [result] = await db.query(
    'INSERT INTO secondary_jobs (player_id, job) VALUES (?, ?)',
    [playerId, job],
  );
  // mysql2 may return insertId either on the result object or nested in the
  // first element of a result array; support both shapes.
  const insertId = result.insertId || result[0]?.insertId;
  return insertId;
}

/**
 * Delete all secondary jobs for the specified player.  Returns the
 * number of rows removed.  Deleting jobs is idempotent; repeated
 * calls with the same player ID will return 0 after the first call.
 *
 * @param {string} playerId Character identifier
 * @returns {Promise<number>} Number of deleted rows
 */
async function deleteSecondaryJobs(playerId) {
  const result = await db.query(
    'DELETE FROM secondary_jobs WHERE player_id = ?',
    [playerId],
  );
  // mysql2 returns affectedRows either on the result object or nested
  // inside an array.  Normalise to a number.
  const affected = result.affectedRows || result[0]?.affectedRows || 0;
  return affected;
}

module.exports = {
  listSecondaryJobs,
  createSecondaryJob,
  deleteSecondaryJobs,
};