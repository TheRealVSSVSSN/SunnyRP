const db = require('./db');

async function createOffer({ item, price, expiresAt }) {
  const result = await db.query(
    'INSERT INTO dealer_offers (item, price, expires_at) VALUES (?, ?, ?)',
    [item, price, expiresAt],
  );
  const id = result.insertId || (Array.isArray(result) ? result[0].insertId : null);
  return { id, item, price, expiresAt };
}

async function listActiveOffers() {
  const rows = await db.query(
    'SELECT id, item, price, expires_at AS expiresAt FROM dealer_offers WHERE expires_at > NOW() ORDER BY id DESC',
  );
  return rows;
}

async function deleteExpired(now) {
  const expired = await db.query('SELECT id FROM dealer_offers WHERE expires_at <= ?', [now]);
  if (!expired.length) return [];
  const ids = expired.map((r) => r.id);
  const placeholders = ids.map(() => '?').join(',');
  await db.query(`DELETE FROM dealer_offers WHERE id IN (${placeholders})`, ids);
  return ids;
}

module.exports = { createOffer, listActiveOffers, deleteExpired };
