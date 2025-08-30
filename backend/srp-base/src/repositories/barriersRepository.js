const db = require('./db');

/**
 * Repository for world barriers. Barriers are physical objects
 * that can block roads or areas. They have an open/closed state
 * and optional expiry for automatic reopening.
 */

async function getAll() {
  const rows = await db.query(
    'SELECT id, model, position, heading, state, expires_at, placed_by, created_at, updated_at FROM barriers'
  );
  return rows.map((r) => ({
    id: r.id,
    model: r.model,
    position: JSON.parse(r.position),
    heading: r.heading,
    state: !!r.state,
    expiresAt: r.expires_at,
    placedBy: r.placed_by,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  }));
}

async function create({ model, position, heading, placedBy }) {
  const pos = JSON.stringify(position);
  const result = await db.query(
    'INSERT INTO barriers (model, position, heading, placed_by) VALUES (?, ?, ?, ?)',
    [model, pos, heading || 0, placedBy]
  );
  return get(result.insertId);
}

async function get(id) {
  const rows = await db.query(
    'SELECT id, model, position, heading, state, expires_at, placed_by, created_at, updated_at FROM barriers WHERE id = ?',
    [id]
  );
  const r = rows[0];
  if (!r) return null;
  return {
    id: r.id,
    model: r.model,
    position: JSON.parse(r.position),
    heading: r.heading,
    state: !!r.state,
    expiresAt: r.expires_at,
    placedBy: r.placed_by,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  };
}

async function setState(id, state, ttlSec) {
  const expires = state && ttlSec ? { sql: 'DATE_ADD(NOW(), INTERVAL ? SECOND)', params: [ttlSec] } : null;
  if (expires) {
    await db.query(
      'UPDATE barriers SET state = ?, expires_at = DATE_ADD(NOW(), INTERVAL ? SECOND), updated_at = NOW() WHERE id = ?',
      [state ? 1 : 0, ttlSec, id]
    );
  } else {
    await db.query(
      'UPDATE barriers SET state = ?, expires_at = NULL, updated_at = NOW() WHERE id = ?',
      [state ? 1 : 0, id]
    );
  }
  return get(id);
}

async function closeExpired() {
  const rows = await db.query(
    'SELECT id FROM barriers WHERE state = 1 AND expires_at IS NOT NULL AND expires_at <= NOW()'
  );
  if (!rows.length) return [];
  const ids = rows.map((r) => r.id);
  const placeholders = ids.map(() => '?').join(',');
  await db.query(
    `UPDATE barriers SET state = 0, expires_at = NULL, updated_at = NOW() WHERE id IN (${placeholders})`,
    ids
  );
  return ids;
}

module.exports = { getAll, create, get, setState, closeExpired };
