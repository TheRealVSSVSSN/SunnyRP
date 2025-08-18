const db = require('./db');

/**
 * List all active blips.  Returns blips that have not yet
 * expired (expires_at is null or in the future).
 * @returns {Promise<Array>}
 */
async function listBlips() {
  const [rows] = await db.query(
    'SELECT id, type, coords, created_by AS createdBy, created_at AS createdAt, expires_at AS expiresAt FROM blips WHERE expires_at IS NULL OR expires_at > NOW()',
    [],
  );
  return rows;
}

/**
 * Create a new blip.
 * @param {string} type - Blip type (e.g. crime, dispatch)
 * @param {object} coords - Coordinates object with x, y, z
 * @param {number|null} createdBy - Optional player identifier
 * @param {string|null} expiresAt - Optional ISO timestamp for expiry
 * @returns {Promise<object>} created blip
 */
async function createBlip(type, coords, createdBy = null, expiresAt = null) {
  const [result] = await db.query(
    'INSERT INTO blips (type, coords, created_by, expires_at) VALUES (?, ?, ?, ?)',
    [type, JSON.stringify(coords), createdBy, expiresAt],
  );
  return { id: result.insertId, type, coords, createdBy, expiresAt };
}

/**
 * Delete a blip by ID.
 * @param {number} id - Blip identifier
 * @returns {Promise<void>}
 */
async function deleteBlip(id) {
  await db.query('DELETE FROM blips WHERE id = ?', [id]);
}

module.exports = {
  listBlips,
  createBlip,
  deleteBlip,
};