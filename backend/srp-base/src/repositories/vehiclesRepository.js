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
  getHarnessByPlate,
  updateHarnessByPlate,
  changePlate,
  // New: vehicle condition helpers
  getVehicleConditionByPlate,
  updateVehicleConditionByPlate,
  updateVehicleDegradationByPlate,
};

/**
 * Retrieve the condition for a vehicle identified by its plate.
 * Returns an object with engineDamage, bodyDamage, fuel and an array of
 * eight degradation values (or null if no degradation recorded).
 *
 * @param {string} plate
 * @returns {Promise<{engineDamage:number, bodyDamage:number, fuel:number, degradation:number[]}|null>}
 */
async function getVehicleConditionByPlate(plate) {
  const rows = await db.query(
    'SELECT engine_damage AS engineDamage, body_damage AS bodyDamage, fuel, degradation FROM vehicles WHERE plate = ?',
    [plate],
  );
  if (!rows || rows.length === 0) return null;
  const row = rows[0];
  let degradationArr = null;
  if (row.degradation) {
    // degradation stored as comma‑separated string
    degradationArr = row.degradation.split(',').map((v) => parseInt(v, 10));
  }
  return {
    engineDamage: row.engineDamage,
    bodyDamage: row.bodyDamage,
    fuel: row.fuel,
    degradation: degradationArr,
  };
}

/**
 * Update the engine, body and fuel values for a vehicle.  Returns the number of
 * rows updated.  Missing fields are ignored.
 *
 * @param {string} plate
 * @param {{engineDamage?: number, bodyDamage?: number, fuel?: number}} data
 * @returns {Promise<number>}
 */
async function updateVehicleConditionByPlate(plate, data) {
  const fields = [];
  const values = [];
  if (data.engineDamage !== undefined) {
    fields.push('engine_damage = ?');
    values.push(data.engineDamage);
  }
  if (data.bodyDamage !== undefined) {
    fields.push('body_damage = ?');
    values.push(data.bodyDamage);
  }
  if (data.fuel !== undefined) {
    fields.push('fuel = ?');
    values.push(data.fuel);
  }
  if (fields.length === 0) return 0;
  values.push(plate);
  const result = await db.pool.query(
    `UPDATE vehicles SET ${fields.join(', ')} WHERE plate = ?`,
    values,
  );
  return result[0].affectedRows;
}

/**
 * Update the degradation array for a vehicle.  Expects an array of eight integers.
 * Converts the array to a comma‑separated string for storage.  Returns the
 * number of rows updated.
 *
 * @param {string} plate
 * @param {number[]} degradation
 * @returns {Promise<number>}
 */
async function updateVehicleDegradationByPlate(plate, degradation) {
  if (!Array.isArray(degradation)) return 0;
  const degrStr = degradation.join(',');
  const result = await db.pool.query(
    'UPDATE vehicles SET degradation = ? WHERE plate = ?',
    [degrStr, plate],
  );
  return result[0].affectedRows;
}

/**
 * Retrieve the current harness durability for a given vehicle plate.  If the
 * vehicle does not exist or has no harness value, null is returned.
 *
 * @param {string} plate
 * @returns {Promise<number|null>}
 */
async function getHarnessByPlate(plate) {
  const rows = await db.query(
    'SELECT harness FROM vehicles WHERE plate = ?',
    [plate],
  );
  if (rows && rows.length > 0) {
    return rows[0].harness;
  }
  return null;
}

/**
 * Update the harness durability for a vehicle identified by plate.  Returns
 * the number of rows updated (0 if no vehicle was found).
 *
 * @param {string} plate
 * @param {number} durability
 * @returns {Promise<number>}
 */
async function updateHarnessByPlate(plate, durability) {
  const result = await db.pool.query(
    'UPDATE vehicles SET harness = ? WHERE plate = ?',
    [durability, plate],
  );
  return result[0].affectedRows;
}

/**
 * Change the license plate of a vehicle.  Updates the plate if the old
 * plate exists.  Returns the number of rows updated.
 *
 * @param {string} oldPlate
 * @param {string} newPlate
 * @returns {Promise<number>}
 */
async function changePlate(oldPlate, newPlate) {
  const result = await db.pool.query(
    'UPDATE vehicles SET plate = ? WHERE plate = ?',
    [newPlate, oldPlate],
  );
  return result[0].affectedRows;
}