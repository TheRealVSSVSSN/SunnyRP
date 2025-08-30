const db = require('./db');

/**
 * Create a new mechanic order for vehicle upgrades or repairs.
 * @param {string} vehiclePlate
 * @param {number} characterId
 * @param {string|null} description
 * @returns {Promise<object>} created order
 */
async function createOrder(vehiclePlate, characterId, description = null) {
  const [result] = await db.query(
    'INSERT INTO mechanic_orders (vehicle_plate, character_id, description) VALUES (?, ?, ?)',
    [vehiclePlate, characterId, description]
  );
  return { id: result.insertId, vehiclePlate, characterId, description, status: 'pending' };
}

/**
 * Retrieve a mechanic order by id.
 * @param {number} id
 * @returns {Promise<object|null>}
 */
async function getOrder(id) {
  const [rows] = await db.query(
    'SELECT id, vehicle_plate AS vehiclePlate, character_id AS characterId, description, status, created_at AS createdAt, completed_at AS completedAt FROM mechanic_orders WHERE id = ?',
    [id]
  );
  return rows[0] || null;
}

/**
 * List all pending orders.
 * @returns {Promise<Array>}
 */
async function listPending() {
  const [rows] = await db.query(
    "SELECT id, vehicle_plate AS vehiclePlate, character_id AS characterId, description, status, created_at AS createdAt FROM mechanic_orders WHERE status = 'pending'"
  );
  return rows;
}

/**
 * Mark an order as completed.
 * @param {number} id
 * @returns {Promise<void>}
 */
async function completeOrder(id) {
  await db.query(
    "UPDATE mechanic_orders SET status = 'completed', completed_at = NOW() WHERE id = ?",
    [id]
  );
}

module.exports = { createOrder, getOrder, listPending, completeOrder };
