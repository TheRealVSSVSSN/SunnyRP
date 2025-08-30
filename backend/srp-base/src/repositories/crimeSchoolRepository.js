const db = require('./db');

/**
 * Get the crime school progress for a given character.
 * @param {number} characterId - The character identifier
 * @returns {Promise<object|null>} progress record or null
 */
async function getProgress(characterId) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, stage, created_at AS createdAt, updated_at AS updatedAt FROM crime_school WHERE character_id = ?',
    [characterId],
  );
  return rows[0] || null;
}

/**
 * Update or create crime school progress for a character.
 * If no record exists, inserts one.  Otherwise updates the stage and updated_at.
 * @param {number} characterId - Character identifier
 * @param {string} stage - Progress stage
 * @returns {Promise<object>} updated or created record
 */
async function updateProgress(characterId, stage) {
  const [existing] = await db.query('SELECT id FROM crime_school WHERE character_id = ?', [characterId]);
  if (existing.length === 0) {
    const [result] = await db.query('INSERT INTO crime_school (character_id, stage) VALUES (?, ?)', [characterId, stage]);
    return { id: result.insertId, characterId, stage };
  }
  await db.query('UPDATE crime_school SET stage = ?, updated_at = NOW() WHERE character_id = ?', [stage, characterId]);
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, stage, created_at AS createdAt, updated_at AS updatedAt FROM crime_school WHERE character_id = ?',
    [characterId],
  );
  return rows[0];
}

/**
 * Remove progress records older than the provided cutoff date.
 * @param {Date} cutoff - Records with updated_at before this are deleted
 */
async function deleteOlderThan(cutoff) {
  await db.query('DELETE FROM crime_school WHERE updated_at IS NOT NULL AND updated_at < ?', [cutoff]);
}

module.exports = {
  getProgress,
  updateProgress,
  deleteOlderThan,
};