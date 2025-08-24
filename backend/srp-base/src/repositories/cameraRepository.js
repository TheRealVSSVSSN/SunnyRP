const db = require('./db');

/**
 * List photos for a character ordered by id ascending.
 * @param {number} characterId
 * @returns {Promise<Array>}
 */
async function listPhotosByCharacter(characterId) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, image_url AS imageUrl, description, created_at AS createdAt, updated_at AS updatedAt FROM camera_photos WHERE character_id = ? ORDER BY id ASC',
    [characterId],
  );
  return rows.map((row) => ({
    id: row.id,
    characterId: row.characterId,
    imageUrl: row.imageUrl,
    description: row.description,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
}

/**
 * Create a photo record.
 * @param {Object} params
 * @param {number} params.characterId
 * @param {string} params.imageUrl
 * @param {string} [params.description]
 * @returns {Promise<Object>}
 */
async function createPhoto({ characterId, imageUrl, description = null }) {
  const [result] = await db.query(
    'INSERT INTO camera_photos (character_id, image_url, description) VALUES (?, ?, ?)',
    [characterId, imageUrl, description],
  );
  const id = result.insertId;
  return {
    id,
    characterId,
    imageUrl,
    description,
  };
}

/**
 * Delete a photo by id.
 * @param {number} id
 * @returns {Promise<void>}
 */
async function deletePhoto(id) {
  await db.query('DELETE FROM camera_photos WHERE id = ?', [id]);
}

module.exports = {
  listPhotosByCharacter,
  createPhoto,
  deletePhoto,
};
