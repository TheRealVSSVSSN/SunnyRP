const db = require('./db');

/**
 * Fetch interior for a given apartment and character.
 * @param {number} apartmentId
 * @param {number} characterId
 * @returns {Promise<Object|null>} interior record or null
 */
async function getInterior(apartmentId, characterId) {
  const [rows] = await db.query(
    'SELECT * FROM interiors WHERE apartment_id = ? AND character_id = ?',
    [apartmentId, characterId],
  );
  return rows[0] || null;
}

/**
 * Save interior template for an apartment and character.
 * Upserts on apartment_id.
 * @param {number} apartmentId
 * @param {number} characterId
 * @param {Object} template
 * @returns {Promise<Object>} saved interior
 */
async function setInterior(apartmentId, characterId, template) {
  await db.query(
    `INSERT INTO interiors (apartment_id, character_id, template)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE template = VALUES(template), updated_at = CURRENT_TIMESTAMP`,
    [apartmentId, characterId, JSON.stringify(template)],
  );
  const [rows] = await db.query(
    'SELECT * FROM interiors WHERE apartment_id = ? AND character_id = ?',
    [apartmentId, characterId],
  );
  return rows[0];
}

module.exports = {
  getInterior,
  setInterior,
};
