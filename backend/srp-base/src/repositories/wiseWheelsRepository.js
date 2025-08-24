const db = require('./db');

async function createSpin({ characterId, prize }) {
  const createdAt = Date.now();
  const result = await db.query(
    'INSERT INTO wise_wheels_spins (character_id, prize, created_at) VALUES (?, ?, ?)',
    [characterId, prize, createdAt],
  );
  return { id: result.insertId, characterId, prize, createdAt };
}

async function listSpinsByCharacter(characterId, limit = 50) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, prize, created_at AS createdAt FROM wise_wheels_spins WHERE character_id = ? ORDER BY created_at DESC LIMIT ?',
    [characterId, limit],
  );
  return rows;
}

module.exports = { createSpin, listSpinsByCharacter };
