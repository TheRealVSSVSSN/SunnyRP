const db = require('./db');

/**
 * Vehicles repository.  Responsible for persisting players' vehicles
 * and their metadata.  Each vehicle has an owning player, model,
 * license plate and a JSON properties blob which may include
 * modifications, colours, etc.  A unique index on plate can be
 * added via migrations if desired.
 */

/**
 * Retrieve all vehicles owned by a player.  Returns an array of
 * vehicles with id, player_id, model, plate and properties JSON.
 *
 * @param {string} playerId
 * @returns {Promise<object[]>}
 */
async function getVehicles(playerId) {
  return db.query(
    'SELECT id, player_id AS playerId, model, plate, properties FROM vehicles WHERE player_id = ?',
    [playerId],
  );
}

/**
 * Register a new vehicle to a player.  Expects model, plate and
 * optional properties (an object).  Returns the generated ID.
 *
 * @param {{playerId: string, model: string, plate: string, properties?: object}} params
 * @returns {Promise<{id: number}>}
 */
async function registerVehicle({ playerId, model, plate, properties }) {
  const props = JSON.stringify(properties || {});
  const result = await db.pool.query(
    'INSERT INTO vehicles (player_id, model, plate, properties) VALUES (?, ?, ?, ?)',
    [playerId, model, plate, props],
  );
  return { id: result[0].insertId };
}

/**
 * Update an existing vehicle.  Accepts a partial data object and
 * only updates provided fields.  Properties are JSON merged by
 * replacing the existing object entirely.  Returns the number of
 * affected rows.
 *
 * @param {number} id
 * @param {{model?: string, plate?: string, properties?: object}} data
 * @returns {Promise<number>}
 */
async function updateVehicle(id, data) {
  const fields = [];
  const values = [];
  if (data.model !== undefined) {
    fields.push('model = ?');
    values.push(data.model);
  }
  if (data.plate !== undefined) {
    fields.push('plate = ?');
    values.push(data.plate);
  }
  if (data.properties !== undefined) {
    fields.push('properties = ?');
    values.push(JSON.stringify(data.properties));
  }
  if (fields.length === 0) return 0;
  values.push(id);
  const result = await db.pool.query(
    `UPDATE vehicles SET ${fields.join(', ')} WHERE id = ?`,
    values,
  );
  return result[0].affectedRows;
}

/**
 * List vehicles available for purchase.  This placeholder function
 * returns an empty array.  In a full implementation a
 * vehicles_shop table would define available models, prices and
 * stock levels.  This can later be extended to support import
 * dealerships and tuning packages.
 *
 * @returns {Promise<object[]>}
 */
async function listShopVehicles() {
  return [];
}

module.exports = {
  getVehicles,
  registerVehicle,
  updateVehicle,
  listShopVehicles,
};