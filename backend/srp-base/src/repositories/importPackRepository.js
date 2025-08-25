const db = require('./db');

async function createOrder({ characterId, packageName, price }) {
  const status = 'pending';
  const createdAt = Date.now();
  const [result] = await db.pool.query(
    'INSERT INTO import_pack_orders (character_id, package, price, status, created_at) VALUES (?, ?, ?, ?, ?)',
    [characterId, packageName, price, status, createdAt],
  );
  return {
    id: result.insertId,
    characterId,
    package: packageName,
    price,
    status,
    createdAt,
    deliveredAt: null,
    canceledAt: null,
  };
}

async function listOrdersByCharacter(characterId, limit = 50) {
  return db.query(
    'SELECT id, character_id AS characterId, package, price, status, created_at AS createdAt, delivered_at AS deliveredAt, canceled_at AS canceledAt FROM import_pack_orders WHERE character_id = ? ORDER BY created_at DESC LIMIT ?',
    [characterId, limit],
  );
}

async function getOrder(id, characterId) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, package, price, status, created_at AS createdAt, delivered_at AS deliveredAt, canceled_at AS canceledAt FROM import_pack_orders WHERE id = ? AND character_id = ? LIMIT 1',
    [id, characterId],
  );
  return rows[0];
}

async function markDelivered(id) {
  const deliveredAt = Date.now();
  const [result] = await db.pool.query(
    'UPDATE import_pack_orders SET status = ?, delivered_at = ? WHERE id = ? AND status <> ?',
    ['delivered', deliveredAt, id, 'delivered'],
  );
  return result.affectedRows;
}

async function cancelOrder(id, characterId) {
  const canceledAt = Date.now();
  const [result] = await db.pool.query(
    'UPDATE import_pack_orders SET status = ?, canceled_at = ? WHERE id = ? AND character_id = ? AND status = ?',
    ['canceled', canceledAt, id, characterId, 'pending'],
  );
  return result.affectedRows;
}

module.exports = {
  createOrder,
  listOrdersByCharacter,
  getOrder,
  markDelivered,
  cancelOrder,
};
