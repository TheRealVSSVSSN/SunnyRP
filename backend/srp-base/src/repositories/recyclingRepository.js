const db = require('./db');

/**
 * Create a recycling run record.
 * @param {Object} params
 * @param {number} params.characterId
 * @param {number} params.materials
 * @returns {Promise<Object>}
 */
async function createRun({ characterId, materials }) {
  const [result] = await db.query(
    'INSERT INTO recycling_runs (character_id, materials) VALUES (?, ?)',
    [characterId, materials],
  );
  const id = result.insertId;
  return { id, characterId, materials };
}

/**
 * List recycling runs for a character.
 * @param {number} characterId
 * @returns {Promise<Array>}
 */
async function listRunsByCharacter(characterId) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, materials, created_at AS createdAt FROM recycling_runs WHERE character_id = ? ORDER BY id DESC',
    [characterId],
  );
  return rows;
}

/**
 * Delete recycling runs older than the cutoff.
 * @param {Date} cutoff
 * @returns {Promise<number>}
 */
async function deleteOlderThan(cutoff) {
  const [result] = await db.query('DELETE FROM recycling_runs WHERE created_at < ?', [cutoff]);
  return result.affectedRows || 0;
}

module.exports = { createRun, listRunsByCharacter, deleteOlderThan };
