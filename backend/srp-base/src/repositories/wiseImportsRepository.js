const db = require('./db');

async function createOrder({ characterId, model }) {
  const status = 'pending';
  const createdAt = Date.now();
  const updatedAt = createdAt;
  const result = await db.query(
    'INSERT INTO wise_import_orders (character_id, model, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?)',
    [characterId, model, status, createdAt, updatedAt],
  );
  return { id: result.insertId, characterId, model, status, createdAt, updatedAt };
}

async function listOrdersByCharacter(characterId, limit = 50) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, model, status, created_at AS createdAt, updated_at AS updatedAt FROM wise_import_orders WHERE character_id = ? ORDER BY created_at DESC LIMIT ?',
    [characterId, limit],
  );
  return rows;
}

async function listPendingOlderThan(cutoff) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, model FROM wise_import_orders WHERE status = ? AND created_at < ?',
    ['pending', cutoff],
  );
  return rows;
}

async function markReady(id) {
  const updatedAt = Date.now();
  const res = await db.query(
    'UPDATE wise_import_orders SET status = ?, updated_at = ? WHERE id = ? AND status = ?',
    ['ready', updatedAt, id, 'pending'],
  );
  return res.affectedRows > 0 ? updatedAt : null;
}

async function deliverOrder(id, characterId) {
  const updatedAt = Date.now();
  const res = await db.query(
    'UPDATE wise_import_orders SET status = ?, updated_at = ? WHERE id = ? AND character_id = ? AND status = ?',
    ['delivered', updatedAt, id, characterId, 'ready'],
  );
  return res.affectedRows > 0;
}

module.exports = {
  createOrder,
  listOrdersByCharacter,
  listPendingOlderThan,
  markReady,
  deliverOrder,
};
