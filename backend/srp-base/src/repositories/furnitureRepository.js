const db = require('./db');

/**
 * List all furniture items for a character.
 *
 * @param {number} characterId
 * @returns {Promise<Array>}
 */
async function listFurniture(characterId) {
  const rows = await db.query(
    'SELECT id, item, x, y, z, heading, created_at AS createdAt, updated_at AS updatedAt FROM furniture WHERE character_id = ? ORDER BY id ASC',
    [characterId],
  );
  return rows.map((row) => ({
    id: row.id,
    item: row.item,
    x: row.x,
    y: row.y,
    z: row.z,
    heading: row.heading,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
}

/**
 * Create a furniture item for a character.
 *
 * @param {Object} params
 * @param {number} params.characterId
 * @param {string} params.item
 * @param {number} params.x
 * @param {number} params.y
 * @param {number} params.z
 * @param {number} [params.heading]
 * @returns {Promise<Object>}
 */
async function createFurniture({ characterId, item, x, y, z, heading }) {
  const result = await db.query(
    'INSERT INTO furniture (character_id, item, x, y, z, heading) VALUES (?, ?, ?, ?, ?, ?)',
    [characterId, item, x, y, z, heading || null],
  );
  const id = result.insertId;
  return { id, item, x, y, z, heading: heading || null };
}

/**
 * Delete a furniture item by id ensuring it belongs to the character.
 *
 * @param {number} characterId
 * @param {number} id
 * @returns {Promise<void>}
 */
async function deleteFurniture(characterId, id) {
  await db.query('DELETE FROM furniture WHERE id = ? AND character_id = ?', [id, characterId]);
}

/**
 * Delete furniture entries older than the provided cutoff timestamp.
 *
 * @param {Date} cutoff
 * @returns {Promise<number>} number of rows removed
 */
async function deleteOlderThan(cutoff) {
  const result = await db.query('DELETE FROM furniture WHERE updated_at < ?', [cutoff]);
  return result.affectedRows || 0;
}

module.exports = {
  listFurniture,
  createFurniture,
  deleteFurniture,
  deleteOlderThan,
};
