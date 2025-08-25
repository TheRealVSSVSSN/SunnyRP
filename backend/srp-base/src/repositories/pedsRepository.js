const db = require('./db');

/**
 * Retrieve ped state for a character.
 * @param {number} characterId
 * @returns {Promise<Object|null>}
 */
async function getCharacterPed(characterId) {
  const [rows] = await db.query(
    'SELECT character_id AS characterId, model, health, armor, updated_at AS updatedAt FROM character_peds WHERE character_id = ? LIMIT 1',
    [characterId],
  );
  return rows[0] || null;
}

/**
 * Upsert ped state for a character.
 * @param {Object} params
 * @param {number} params.characterId
 * @param {string} params.model
 * @param {number} params.health
 * @param {number} params.armor
 * @returns {Promise<Object|null>}
 */
async function upsertCharacterPed({ characterId, model, health, armor }) {
  await db.query(
    'INSERT INTO character_peds (character_id, model, health, armor) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE model = VALUES(model), health = VALUES(health), armor = VALUES(armor), updated_at = CURRENT_TIMESTAMP',
    [characterId, model, health, armor],
  );
  return getCharacterPed(characterId);
}

module.exports = {
  getCharacterPed,
  upsertCharacterPed,
};
