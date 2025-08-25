const db = require('./db');

async function createOrder({ characterId, packageName }) {
  const status = 'pending';
  const createdAt = Date.now();
  const [result] = await db.pool.query(
    'INSERT INTO import_pack_orders (character_id, package, status, created_at) VALUES (?, ?, ?, ?)',
    [characterId, packageName, status, createdAt],
  );
  return { id: result.insertId, characterId, package: packageName, status, createdAt };
}

async function listOrdersByCharacter(characterId, limit = 50) {
  return db.query(
    'SELECT id, character_id AS characterId, package, status, created_at AS createdAt, delivered_at AS deliveredAt FROM import_pack_orders WHERE character_id = ? ORDER BY created_at DESC LIMIT ?',
    [characterId, limit],
  );
}

async function markDelivered(id) {
  const deliveredAt = Date.now();
  const [result] = await db.pool.query(
    'UPDATE import_pack_orders SET status = ?, delivered_at = ? WHERE id = ? AND status <> ?'
    , ['delivered', deliveredAt, id, 'delivered'],
  );
  return result.affectedRows;
}

module.exports = {
  createOrder,
  listOrdersByCharacter,
  markDelivered,
};
