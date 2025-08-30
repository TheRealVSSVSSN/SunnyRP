const db = require('./db');

async function createMessage({ characterId, message }) {
  await db.query('INSERT INTO broadcast_messages (character_id, message) VALUES (?, ?)', [characterId, message]);
  const [row] = await db.query(
    'SELECT id, character_id AS characterId, message, created_at AS createdAt FROM broadcast_messages ORDER BY id DESC LIMIT 1',
  );
  return row;
}

async function getRecentMessages(limit) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, message, created_at AS createdAt FROM broadcast_messages ORDER BY id DESC LIMIT ?',
    [limit],
  );
  return rows;
}

async function deleteOlderThan(cutoff) {
  const result = await db.query('DELETE FROM broadcast_messages WHERE created_at < ?', [cutoff]);
  return result.affectedRows || 0;
}

module.exports = { createMessage, getRecentMessages, deleteOlderThan };
