const db = require('./db');

/**
 * Get the crime school progress for a given player.
 * @param {number} playerId - The player's identifier
 * @returns {Promise<object|null>} progress record or null
 */
async function getProgress(playerId) {
  const [rows] = await db.query(
    'SELECT id, player_id AS playerId, stage, created_at AS createdAt, updated_at AS updatedAt FROM crime_school WHERE player_id = ?',
    [playerId],
  );
  return rows[0] || null;
}

/**
 * Update or create crime school progress for a player.
 * If no record exists, inserts one.  Otherwise updates the stage and updated_at.
 * @param {number} playerId - Player identifier
 * @param {string} stage - Progress stage
 * @returns {Promise<object>} updated or created record
 */
async function updateProgress(playerId, stage) {
  const [existing] = await db.query('SELECT id FROM crime_school WHERE player_id = ?', [playerId]);
  if (existing.length === 0) {
    const [result] = await db.query(
      'INSERT INTO crime_school (player_id, stage) VALUES (?, ?)',
      [playerId, stage],
    );
    return { id: result.insertId, playerId, stage };
  }
  await db.query(
    'UPDATE crime_school SET stage = ?, updated_at = NOW() WHERE player_id = ?',
    [stage, playerId],
  );
  const [rows] = await db.query(
    'SELECT id, player_id AS playerId, stage, created_at AS createdAt, updated_at AS updatedAt FROM crime_school WHERE player_id = ?',
    [playerId],
  );
  return rows[0];
}

module.exports = {
  getProgress,
  updateProgress,
};