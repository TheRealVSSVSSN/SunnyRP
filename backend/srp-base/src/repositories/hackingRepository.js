const db = require('./db');

async function createAttempt({ characterId, target, success }) {
  const [result] = await db.query(
    'INSERT INTO hacking_attempts (character_id, target, success) VALUES (?, ?, ?)',
    [characterId, target, success ? 1 : 0],
  );
  const id = result.insertId;
  return { id, characterId, target, success: !!success, createdAt: new Date() };
}

async function listRecent(characterId, limit = 10) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, target, success, created_at AS createdAt FROM hacking_attempts WHERE character_id = ? ORDER BY id DESC LIMIT ?',
    [characterId, limit],
  );
  return rows.map((r) => ({ ...r, success: r.success === 1 }));
}

async function deleteOldAttempts(ttlMs) {
  const cutoff = new Date(Date.now() - ttlMs);
  const [result] = await db.query('DELETE FROM hacking_attempts WHERE created_at < ?', [cutoff]);
  return result.affectedRows || 0;
}

module.exports = { createAttempt, listRecent, deleteOldAttempts };
