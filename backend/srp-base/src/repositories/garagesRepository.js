const db = require('./db');

/**
 * Get a list of all garages.
 * @returns {Promise<Array>} list of garages
 */
async function listGarages() {
  const [rows] = await db.query('SELECT * FROM garages');
  return rows;
}

/**
 * Create a new garage.
 * @param {string} name - Garage name
 * @param {Object|null} location - Location object (will be JSON stringified)
 * @param {number} capacity - Maximum number of vehicles
 * @returns {Promise<Object>} created garage
 */
async function createGarage(name, location = null, capacity = 10) {
  const [result] = await db.query(
    'INSERT INTO garages (name, location, capacity) VALUES (?, ?, ?)',
    [name, location ? JSON.stringify(location) : null, capacity],
  );
  return { id: result.insertId, name, location, capacity };
}

/**
 * Update an existing garage.
 * Accepts partial update: only provided fields will be updated.
 * @param {number} id - Garage ID
 * @param {Object} data - Fields to update
 * @returns {Promise<Object>} updated garage
 */
async function updateGarage(id, data) {
  const fields = [];
  const values = [];
  if (data.name) {
    fields.push('name = ?');
    values.push(data.name);
  }
  if (data.location) {
    fields.push('location = ?');
    values.push(JSON.stringify(data.location));
  }
  if (data.capacity) {
    fields.push('capacity = ?');
    values.push(data.capacity);
  }
  if (fields.length === 0) {
    // Nothing to update
    const [rows] = await db.query('SELECT * FROM garages WHERE id = ?', [id]);
    return rows[0];
  }
  values.push(id);
  await db.query(`UPDATE garages SET ${fields.join(', ')} WHERE id = ?`, values);
  const [rows] = await db.query('SELECT * FROM garages WHERE id = ?', [id]);
  return rows[0];
}

/**
 * Delete a garage.
 * @param {number} id - Garage ID
 * @returns {Promise<void>}
 */
async function deleteGarage(id) {
  await db.query('DELETE FROM garages WHERE id = ?', [id]);
}

/**
 * Store a vehicle in a garage.
 * @param {number} garageId - Garage ID
 * @param {number} vehicleId - Vehicle ID
 * @returns {Promise<Object>} inserted record
 */
async function storeVehicle(garageId, vehicleId, characterId) {
  const [result] = await db.query(
    'INSERT INTO garage_vehicles (garage_id, vehicle_id, character_id) VALUES (?, ?, ?)',
    [garageId, vehicleId, characterId],
  );
  return { id: result.insertId, garageId, vehicleId, characterId };
}

/**
 * Mark a vehicle as retrieved from a garage.
 * @param {number} garageId - Garage ID
 * @param {number} vehicleId - Vehicle ID
 * @returns {Promise<void>}
 */
async function retrieveVehicle(garageId, vehicleId, characterId) {
  await db.query(
    'UPDATE garage_vehicles SET retrieved_at = NOW() WHERE garage_id = ? AND vehicle_id = ? AND character_id = ? AND retrieved_at IS NULL',
    [garageId, vehicleId, characterId],
  );
}

/**
 * List vehicles stored by a character in a garage.
 * @param {number} garageId - Garage ID
 * @param {number} characterId - Character ID
 * @returns {Promise<Array>} stored vehicles
 */
async function listGarageVehicles(garageId, characterId) {
  const [rows] = await db.query(
    'SELECT id, garage_id AS garageId, vehicle_id AS vehicleId, character_id AS characterId, stored_at AS storedAt, retrieved_at AS retrievedAt FROM garage_vehicles WHERE garage_id = ? AND character_id = ? AND retrieved_at IS NULL',
    [garageId, characterId],
  );
  return rows;
}

/**
 * Remove retrieved vehicle records older than the provided cutoff.
 * @param {Date} cutoff - Records with retrieved_at before this date are deleted
 * @returns {Promise<void>}
 */
async function deleteRetrievedBefore(cutoff) {
  await db.query('DELETE FROM garage_vehicles WHERE retrieved_at IS NOT NULL AND retrieved_at < ?', [cutoff]);
}

module.exports = {
  listGarages,
  createGarage,
  updateGarage,
  deleteGarage,
  storeVehicle,
  retrieveVehicle,
  listGarageVehicles,
  deleteRetrievedBefore,
};
