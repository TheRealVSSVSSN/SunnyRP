const db = require('./db');

/**
 * Record a car wash for a vehicle and reset its dirt level.
 *
 * @param {Object} params
 * @param {number} params.characterId
 * @param {string} params.plate
 * @param {string} params.location
 * @param {number} params.cost
 * @returns {Promise<{id:number}>}
 */
async function recordWash({ characterId, plate, location, cost }) {
  const result = await db.query(
    'INSERT INTO carwash_transactions (character_id, plate, location, cost) VALUES (?, ?, ?, ?)',
    [characterId, plate, location, cost],
  );
  await db.query(
    'INSERT INTO vehicle_cleanliness (plate, dirt_level) VALUES (?, 0) ON DUPLICATE KEY UPDATE dirt_level = 0',
    [plate],
  );
  return { id: result.insertId };
}

/**
 * Retrieve recent car wash history for a character.
 * @param {number} characterId
 * @returns {Promise<object[]>}
 */
async function getHistory(characterId) {
  return db.query(
    'SELECT id, plate, location, cost, washed_at FROM carwash_transactions WHERE character_id = ? ORDER BY washed_at DESC LIMIT 50',
    [characterId],
  );
}

/**
 * Get the dirt level for a vehicle plate.
 * @param {string} plate
 * @returns {Promise<number|null>}
 */
async function getDirtByPlate(plate) {
  const rows = await db.query(
    'SELECT dirt_level FROM vehicle_cleanliness WHERE plate = ?',
    [plate],
  );
  if (rows.length === 0) {
    return null;
  }
  return rows[0].dirt_level;
}

/**
 * Set the dirt level for a vehicle plate.
 * @param {string} plate
 * @param {number} dirt
 * @returns {Promise<number>} affected rows
 */
async function setDirtByPlate(plate, dirt) {
  const result = await db.query(
    'INSERT INTO vehicle_cleanliness (plate, dirt_level) VALUES (?, ?) ON DUPLICATE KEY UPDATE dirt_level = VALUES(dirt_level)',
    [plate, dirt],
  );
  return result.affectedRows;
}

/**
 * Increment dirt level for all tracked vehicles up to a maximum.
 * Returns list of updated plates and new dirt levels.
 * @param {number} delta
 * @param {number} max
 * @returns {Promise<Array<{plate:string,dirt_level:number}>>}
 */
async function incrementDirt(delta, max) {
  const rows = await db.query('SELECT plate, dirt_level FROM vehicle_cleanliness WHERE dirt_level < ?', [max]);
  if (!rows.length) return [];
  await db.query(
    'UPDATE vehicle_cleanliness SET dirt_level = LEAST(dirt_level + ?, ?) WHERE dirt_level < ?'
      , [delta, max, max],
  );
  return rows.map((r) => ({ plate: r.plate, dirt_level: Math.min(r.dirt_level + delta, max) }));
}

module.exports = {
  recordWash,
  getHistory,
  getDirtByPlate,
  setDirtByPlate,
  incrementDirt,
};
