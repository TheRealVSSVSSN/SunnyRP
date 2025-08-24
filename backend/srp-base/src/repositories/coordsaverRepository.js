const db = require('./db');

/**
 * List all saved coordinates for a character.
 *
 * @param {number} characterId
 * @returns {Promise<Array>}
 */
async function listCoords(characterId) {
  const [rows] = await db.query(
    'SELECT id, name, x, y, z, heading, created_at AS createdAt, updated_at AS updatedAt FROM character_coords WHERE character_id = ? ORDER BY id ASC',
    [characterId],
  );
  return rows.map((row) => ({
    id: row.id,
    name: row.name,
    x: row.x,
    y: row.y,
    z: row.z,
    heading: row.heading,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
}

/**
 * Save a coordinate for a character. If a coordinate with the same name
 * exists for the character it will be updated.
 *
 * @param {Object} params
 * @param {number} params.characterId
 * @param {string} params.name
 * @param {number} params.x
 * @param {number} params.y
 * @param {number} params.z
 * @param {number} [params.heading]
 * @returns {Promise<Object>}
 */
async function saveCoord({ characterId, name, x, y, z, heading }) {
  await db.query(
    `INSERT INTO character_coords (character_id, name, x, y, z, heading)
     VALUES (?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE x = VALUES(x), y = VALUES(y), z = VALUES(z), heading = VALUES(heading)`,
    [characterId, name, x, y, z, heading],
  );
  const [rows] = await db.query(
    'SELECT id, name, x, y, z, heading, created_at AS createdAt, updated_at AS updatedAt FROM character_coords WHERE character_id = ? AND name = ?',
    [characterId, name],
  );
  return rows[0];
}

/**
 * Delete a saved coordinate by id for a character.
 *
 * @param {number} characterId
 * @param {number} id
 * @returns {Promise<void>}
 */
async function deleteCoord(characterId, id) {
  await db.query('DELETE FROM character_coords WHERE character_id = ? AND id = ?', [characterId, id]);
}

module.exports = {
  listCoords,
  saveCoord,
  deleteCoord,
};
