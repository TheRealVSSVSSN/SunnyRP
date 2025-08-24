const db = require('./db');

/**
 * List all zones.
 * @returns {Promise<Array>}
 */
async function listZones() {
  const [rows] = await db.query(
    'SELECT id, name, type, data, created_by AS createdBy, created_at AS createdAt FROM zones',
    [],
  );
  return rows.map((row) => ({ ...row, data: JSON.parse(row.data) }));
}

/**
 * Create a new zone.
 * @param {string} name - Zone name
 * @param {string} type - Zone shape type
 * @param {object} data - Zone coordinates or dimensions
 * @param {number|null} createdBy - Optional character identifier
 * @returns {Promise<object>} created zone
 */
async function createZone(name, type, data, createdBy = null) {
  const [result] = await db.query(
    'INSERT INTO zones (name, type, data, created_by) VALUES (?, ?, ?, ?)',
    [name, type, JSON.stringify(data), createdBy],
  );
  return { id: result.insertId, name, type, data, createdBy };
}

/**
 * Delete a zone by ID.
 * @param {number} id - Zone identifier
 * @returns {Promise<void>}
 */
async function deleteZone(id) {
  await db.query('DELETE FROM zones WHERE id = ?', [id]);
}

module.exports = {
  listZones,
  createZone,
  deleteZone,
};
