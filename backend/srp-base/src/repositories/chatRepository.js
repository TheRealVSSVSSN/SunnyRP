const db = require('./db');

/**
 * List chat messages for a character ordered by id descending.
 * @param {number} characterId
 * @param {number} limit
 * @returns {Promise<Array>}
 */
async function listMessagesByCharacter(characterId, limit = 50) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, channel, message, created_at AS createdAt FROM chat_messages WHERE character_id = ? ORDER BY id DESC LIMIT ?',
    [characterId, limit],
  );
  return rows.map((row) => ({
    id: row.id,
    characterId: row.characterId,
    channel: row.channel,
    message: row.message,
    createdAt: row.createdAt,
  }));
}

/**
 * Create a chat message.
 * @param {Object} params
 * @param {number} params.characterId
 * @param {string} params.channel
 * @param {string} params.message
 * @returns {Promise<Object>}
 */
async function createMessage({ characterId, channel, message }) {
  const [result] = await db.query(
    'INSERT INTO chat_messages (character_id, channel, message) VALUES (?, ?, ?)',
    [characterId, channel, message],
  );
  const id = result.insertId;
  return { id, characterId, channel, message };
}

module.exports = {
  listMessagesByCharacter,
  createMessage,
};
