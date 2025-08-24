const db = require('./db');

/**
 * List favorite emotes for a character.
 *
 * @param {number} characterId - Character identifier
 * @returns {Promise<Array>} Array of favorite emote records
 */
async function listCharacterEmotes(characterId) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, emote, created_at AS createdAt FROM character_emotes WHERE character_id = ? ORDER BY id ASC',
    [characterId],
  );
  return rows.map((row) => ({
    id: row.id,
    characterId: row.characterId,
    emote: row.emote,
    createdAt: row.createdAt,
  }));
}

/**
 * Add a favorite emote for a character. Uses INSERT IGNORE to remain idempotent.
 *
 * @param {Object} params
 * @param {number} params.characterId - Character identifier
 * @param {string} params.emote - Emote command name
 * @returns {Promise<Object>} Persisted favorite record
 */
async function addCharacterEmote({ characterId, emote }) {
  await db.query('INSERT IGNORE INTO character_emotes (character_id, emote) VALUES (?, ?)', [characterId, emote]);
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, emote, created_at AS createdAt FROM character_emotes WHERE character_id = ? AND emote = ? LIMIT 1',
    [characterId, emote],
  );
  return rows[0] || null;
}

/**
 * Remove a favorite emote for a character.
 *
 * @param {Object} params
 * @param {number} params.characterId - Character identifier
 * @param {string} params.emote - Emote command name
 * @returns {Promise<void>}
 */
async function removeCharacterEmote({ characterId, emote }) {
  await db.query('DELETE FROM character_emotes WHERE character_id = ? AND emote = ?', [characterId, emote]);
}

module.exports = {
  listCharacterEmotes,
  addCharacterEmote,
  removeCharacterEmote,
};
