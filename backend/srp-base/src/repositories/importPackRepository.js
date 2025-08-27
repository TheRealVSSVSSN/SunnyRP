const db = require('./db');
const config = require('../config/env');

async function createOrder({ characterId, packageName, price }) {
  const status = 'pending';
  const createdAt = Date.now();
  const expiresAt = createdAt + (config.importPack.expiryMs || 86400000);
  const [result] = await db.pool.query(
    'INSERT INTO import_pack_orders (character_id, package, price, status, created_at, expires_at) VALUES (?, ?, ?, ?, ?, ?)',
    [characterId, packageName, price, status, createdAt, expiresAt],
  );
  return {
    id: result.insertId,
    characterId,
    package: packageName,
    price,
    status,
    createdAt,
    expiresAt,
    deliveredAt: null,
    canceledAt: null,
    expiredAt: null,
  };
}

async function listOrdersByCharacter(characterId, limit = 50) {
  return db.query(
    'SELECT id, character_id AS characterId, package, price, status, created_at AS createdAt, expires_at AS expiresAt, delivered_at AS deliveredAt, canceled_at AS canceledAt, expired_at AS expiredAt FROM import_pack_orders WHERE character_id = ? ORDER BY created_at DESC LIMIT ?',
    [characterId, limit],
  );
}

async function getOrder(id, characterId) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, package, price, status, created_at AS createdAt, expires_at AS expiresAt, delivered_at AS deliveredAt, canceled_at AS canceledAt, expired_at AS expiredAt FROM import_pack_orders WHERE id = ? AND character_id = ? LIMIT 1',
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

async function expireOrders(now = Date.now()) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, package, price, status, created_at AS createdAt, expires_at AS expiresAt FROM import_pack_orders WHERE status = ? AND expires_at <= ?',
    ['pending', now],
  );
  if (!rows.length) return [];
  const ids = rows.map((r) => r.id);
  const placeholders = ids.map(() => '?').join(',');
  await db.pool.query(
    `UPDATE import_pack_orders SET status = ?, expired_at = ? WHERE id IN (${placeholders})`,
    ['expired', now, ...ids],
  );
  return rows.map((r) => ({ ...r, status: 'expired', expiredAt: now }));
}

module.exports = {
  createOrder,
  listOrdersByCharacter,
  getOrder,
  markDelivered,
  cancelOrder,
  expireOrders,
};
