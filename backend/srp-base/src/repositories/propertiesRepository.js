const db = require('./db');

/**
 * List properties with optional filters.
 * @param {Object} filters
 * @param {string|null} filters.type
 * @param {number|null} filters.ownerCharacterId
 * @returns {Promise<Array>}
 */
async function list({ type = null, ownerCharacterId = null } = {}) {
  let sql = 'SELECT * FROM properties WHERE 1=1';
  const params = [];
  if (type) {
    sql += ' AND type = ?';
    params.push(type);
  }
  if (ownerCharacterId) {
    sql += ' AND owner_character_id = ?';
    params.push(ownerCharacterId);
  }
  return db.query(sql, params);
}

/**
 * Get a single property by id.
 * @param {number} id
 * @returns {Promise<Object|null>}
 */
async function get(id) {
  const rows = await db.query('SELECT * FROM properties WHERE id = ?', [id]);
  return rows[0] || null;
}

/**
 * Create a new property.
 * @param {Object} data
 * @param {string} data.type
 * @param {string} data.name
 * @param {Object|null} data.location
 * @param {number} data.price
 * @param {number|null} data.ownerCharacterId
 * @param {string|null} data.expiresAt ISO string
 * @returns {Promise<Object>}
 */
async function create({ type, name, location = null, price = 0, ownerCharacterId = null, expiresAt = null }) {
  const result = await db.query(
    'INSERT INTO properties (type, name, location, price, owner_character_id, expires_at) VALUES (?, ?, ?, ?, ?, ?)',
    [type, name, location ? JSON.stringify(location) : null, price, ownerCharacterId, expiresAt],
  );
  return { id: result.insertId, type, name, location, price, ownerCharacterId, expiresAt };
}

/**
 * Update a property.
 * @param {number} id
 * @param {Object} fields
 * @returns {Promise<Object|null>}
 */
async function update(id, fields) {
  const sets = [];
  const params = [];
  if (fields.type !== undefined) {
    sets.push('type = ?');
    params.push(fields.type);
  }
  if (fields.name !== undefined) {
    sets.push('name = ?');
    params.push(fields.name);
  }
  if (fields.location !== undefined) {
    sets.push('location = ?');
    params.push(fields.location ? JSON.stringify(fields.location) : null);
  }
  if (fields.price !== undefined) {
    sets.push('price = ?');
    params.push(fields.price);
  }
  if (fields.ownerCharacterId !== undefined) {
    sets.push('owner_character_id = ?');
    params.push(fields.ownerCharacterId);
  }
  if (fields.expiresAt !== undefined) {
    sets.push('expires_at = ?');
    params.push(fields.expiresAt);
  }
  if (!sets.length) {
    return get(id);
  }
  sets.push('updated_at = CURRENT_TIMESTAMP');
  params.push(id);
  await db.query(`UPDATE properties SET ${sets.join(', ')} WHERE id = ?`, params);
  return get(id);
}

/**
 * Delete a property.
 * @param {number} id
 * @returns {Promise<void>}
 */
async function remove(id) {
  await db.query('DELETE FROM properties WHERE id = ?', [id]);
}

/**
 * Release leases that have expired.
 * @returns {Promise<void>}
 */
async function releaseExpiredLeases() {
  await db.query(
    'UPDATE properties SET owner_character_id = NULL, expires_at = NULL WHERE expires_at IS NOT NULL AND expires_at < NOW()',
  );
}

module.exports = { list, get, create, update, remove, releaseExpiredLeases };
