const db = require('./db');

/**
 * Create a taxi ride request.
 * @param {Object} params
 * @param {number} params.passengerId
 * @param {number} params.pickupX
 * @param {number} params.pickupY
 * @param {number} params.pickupZ
 * @returns {Promise<Object>}
 */
async function createRequest({ passengerId, pickupX, pickupY, pickupZ }) {
  const [result] = await db.query(
    'INSERT INTO taxi_rides (passenger_character_id, pickup_x, pickup_y, pickup_z) VALUES (?, ?, ?, ?)',
    [passengerId, pickupX, pickupY, pickupZ],
  );
  const id = result.insertId;
  return {
    id,
    passengerCharacterId: passengerId,
    pickupX,
    pickupY,
    pickupZ,
    status: 'requested',
  };
}

/**
 * List taxi ride requests by status.
 * @param {string} status
 * @returns {Promise<Array>}
 */
async function listRequestsByStatus(status) {
  const [rows] = await db.query(
    'SELECT id, passenger_character_id AS passengerCharacterId, driver_character_id AS driverCharacterId, pickup_x AS pickupX, pickup_y AS pickupY, pickup_z AS pickupZ, status, created_at AS createdAt FROM taxi_rides WHERE status = ? ORDER BY id ASC',
    [status],
  );
  return rows;
}

/**
 * Accept a taxi ride request.
 * @param {Object} params
 * @param {number} params.requestId
 * @param {number} params.driverId
 * @returns {Promise<Object|null>}
 */
async function acceptRequest({ requestId, driverId }) {
  const [result] = await db.query(
    'UPDATE taxi_rides SET driver_character_id = ?, status = \'accepted\', accepted_at = NOW() WHERE id = ? AND status = \'requested\'',
    [driverId, requestId],
  );
  if (result.affectedRows === 0) return null;
  const [rows] = await db.query(
    'SELECT id, passenger_character_id AS passengerCharacterId, driver_character_id AS driverCharacterId, pickup_x AS pickupX, pickup_y AS pickupY, pickup_z AS pickupZ, status, created_at AS createdAt, accepted_at AS acceptedAt FROM taxi_rides WHERE id = ?',
    [requestId],
  );
  return rows[0] || null;
}

/**
 * Complete a taxi ride request.
 * @param {Object} params
 * @param {number} params.requestId
 * @param {number} params.driverId
 * @param {number} params.dropoffX
 * @param {number} params.dropoffY
 * @param {number} params.dropoffZ
 * @param {number} params.fare
 * @returns {Promise<Object|null>}
 */
async function completeRequest({ requestId, driverId, dropoffX, dropoffY, dropoffZ, fare }) {
  const [result] = await db.query(
    'UPDATE taxi_rides SET dropoff_x = ?, dropoff_y = ?, dropoff_z = ?, fare = ?, status = \'completed\', completed_at = NOW() WHERE id = ? AND driver_character_id = ? AND status = \'accepted\'',
    [dropoffX, dropoffY, dropoffZ, fare, requestId, driverId],
  );
  if (result.affectedRows === 0) return null;
  const [rows] = await db.query(
    'SELECT id, passenger_character_id AS passengerCharacterId, driver_character_id AS driverCharacterId, pickup_x AS pickupX, pickup_y AS pickupY, pickup_z AS pickupZ, dropoff_x AS dropoffX, dropoff_y AS dropoffY, dropoff_z AS dropoffZ, fare, status, created_at AS createdAt, accepted_at AS acceptedAt, completed_at AS completedAt FROM taxi_rides WHERE id = ?',
    [requestId],
  );
  return rows[0] || null;
}

/**
 * List completed rides for a character.
 * @param {number} characterId
 * @param {string} role 'driver' or 'passenger'
 * @returns {Promise<Array>}
 */
async function listRidesByCharacter(characterId, role = 'passenger') {
  const column = role === 'driver' ? 'driver_character_id' : 'passenger_character_id';
  const [rows] = await db.query(
    `SELECT id, passenger_character_id AS passengerCharacterId, driver_character_id AS driverCharacterId, pickup_x AS pickupX, pickup_y AS pickupY, pickup_z AS pickupZ, dropoff_x AS dropoffX, dropoff_y AS dropoffY, dropoff_z AS dropoffZ, fare, status, created_at AS createdAt, accepted_at AS acceptedAt, completed_at AS completedAt FROM taxi_rides WHERE ${column} = ? AND status = 'completed' ORDER BY id DESC LIMIT 50`,
    [characterId],
  );
  return rows;
}

/**
 * Cancel ride requests older than the provided TTL.
 * @param {number} ttlMs
 * @returns {Promise<number>} number of rows updated
 */
async function cancelStaleRequests(ttlMs) {
  const cutoff = new Date(Date.now() - ttlMs);
  const [result] = await db.query(
    "UPDATE taxi_rides SET status = 'cancelled' WHERE status IN ('requested','accepted') AND created_at < ?",
    [cutoff],
  );
  return result.affectedRows || 0;
}

module.exports = {
  createRequest,
  listRequestsByStatus,
  acceptRequest,
  completeRequest,
  listRidesByCharacter,
  cancelStaleRequests,
};
