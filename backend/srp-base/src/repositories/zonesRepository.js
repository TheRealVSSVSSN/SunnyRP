const db = require('./db');

/**
 * List all zones.
 * @returns {Promise<Array>}
 */
async function listZones() {
  const [rows] = await db.query(
    'SELECT id, name, type, data, created_by AS createdBy, created_at AS createdAt, expires_at AS expiresAt FROM zones WHERE expires_at IS NULL OR expires_at > NOW()',
    [],
  );
  return rows.map((row) => ({
    ...row,
    data: JSON.parse(row.data),
    expiresAt: row.expiresAt ? row.expiresAt.toISOString() : null,
  }));
}

/**
 * Create a new zone.
 * @param {string} name - Zone name
 * @param {string} type - Zone shape type
 * @param {object} data - Zone coordinates or dimensions
 * @param {number|null} createdBy - Optional character identifier
 * @returns {Promise<object>} created zone
 */
async function createZone(name, type, data, createdBy = null, expiresAt = null) {
  const [result] = await db.query(
    'INSERT INTO zones (name, type, data, created_by, expires_at) VALUES (?, ?, ?, ?, ?)',
    [name, type, JSON.stringify(data), createdBy, expiresAt],
  );
  return { id: result.insertId, name, type, data, createdBy, expiresAt };
}

/**
 * Delete a zone by ID.
 * @param {number} id - Zone identifier
 * @returns {Promise<void>}
 */
async function deleteZone(id) {
  await db.query('DELETE FROM zones WHERE id = ?', [id]);
}

/**
 * Remove zones whose expiration time has passed.
 * @returns {Promise<number[]>} array of deleted zone IDs
 */
async function removeExpiredZones() {
  const [rows] = await db.query(
    'SELECT id FROM zones WHERE expires_at IS NOT NULL AND expires_at <= NOW()',
    [],
  );
  const ids = rows.map((r) => r.id);
  if (ids.length) {
    await db.query('DELETE FROM zones WHERE id IN (?)', [ids]);
  }
  return ids;
}

module.exports = {
  listZones,
  createZone,
  deleteZone,
  removeExpiredZones,
};
