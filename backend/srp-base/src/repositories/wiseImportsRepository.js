const db = require('./db');

async function createOrder({ characterId, model }) {
  const status = 'pending';
  const createdAt = Date.now();
  const result = await db.query(
    'INSERT INTO wise_import_orders (character_id, model, status, created_at) VALUES (?, ?, ?, ?)',
    [characterId, model, status, createdAt],
  );
  return { id: result.insertId, characterId, model, status, createdAt };
}

async function listOrdersByCharacter(characterId, limit = 50) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, model, status, created_at AS createdAt FROM wise_import_orders WHERE character_id = ? ORDER BY created_at DESC LIMIT ?',
    [characterId, limit],
  );
  return rows;
}

module.exports = { createOrder, listOrdersByCharacter };
