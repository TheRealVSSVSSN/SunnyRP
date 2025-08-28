const db = require('./db');

/**
 * Create a jailbreak attempt.
 * @param {{characterId: number, prison: string}} params
 * @returns {Promise<object>}
 */
async function createAttempt({ characterId, prison }) {
  const [result] = await db.pool.query(
    'INSERT INTO jailbreak_attempts (character_id, prison) VALUES (?, ?)',
    [characterId, prison],
  );
  const id = result.insertId;
  const rows = await db.query(
    'SELECT id, character_id AS characterId, prison, status, started_at AS startedAt, ended_at AS endedAt, success FROM jailbreak_attempts WHERE id = ?',
    [id],
  );
  return rows[0];
}

/**
 * Complete a jailbreak attempt.
 * @param {{id: number, success: boolean}} params
 * @returns {Promise<object|null>}
 */
async function completeAttempt({ id, success }) {
  const status = success ? 'completed' : 'failed';
  const [result] = await db.pool.query(
    'UPDATE jailbreak_attempts SET status = ?, ended_at = CURRENT_TIMESTAMP, success = ? WHERE id = ?',
    [status, success ? 1 : 0, id],
  );
  if (result.affectedRows === 0) return null;
  const rows = await db.query(
    'SELECT id, character_id AS characterId, prison, status, started_at AS startedAt, ended_at AS endedAt, success FROM jailbreak_attempts WHERE id = ?',
    [id],
  );
  return rows[0];
}

/**
 * List active jailbreak attempts.
 * @returns {Promise<object[]>}
 */
async function listActiveAttempts() {
  return db.query(
    'SELECT id, character_id AS characterId, prison, status, started_at AS startedAt FROM jailbreak_attempts WHERE status = ?',
    ['active'],
  );
}

/**
 * Mark active attempts older than the provided age as failed.
 * @param {number} maxAgeMs
 * @returns {Promise<object[]>} expired attempts
 */
async function expireStale(maxAgeMs) {
  const seconds = Math.floor(maxAgeMs / 1000);
  const [result] = await db.pool.query(
    `UPDATE jailbreak_attempts
     SET status = 'failed', ended_at = CURRENT_TIMESTAMP, success = 0
     WHERE status = 'active' AND started_at < (CURRENT_TIMESTAMP - INTERVAL ? SECOND)`,
    [seconds],
  );
  if (result.affectedRows === 0) return [];
  return db.query(
    `SELECT id, character_id AS characterId, prison, status,
            started_at AS startedAt, ended_at AS endedAt, success
       FROM jailbreak_attempts
      WHERE status = 'failed'
        AND ended_at >= (CURRENT_TIMESTAMP - INTERVAL ? SECOND)`,
    [seconds],
  );
}

module.exports = {
  createAttempt,
  completeAttempt,
  listActiveAttempts,
  expireStale,
};
