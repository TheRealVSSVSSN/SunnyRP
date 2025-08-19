const db = require('./db');

/**
 * Create a new weed plant record.
 *
 * @param {Object} coords - Object with x, y, z coordinates
 * @param {string} seed - Seed identifier for the plant
 * @param {number} ownerId - Player ID of the plant owner
 * @returns {Promise<Object>} The created weed plant record
 */
async function createWeedPlant(coords, seed, ownerId) {
  const [result] = await db.query(
    'INSERT INTO weed_plants (coords, seed, owner_id, growth) VALUES (?, ?, ?, 0)',
    [JSON.stringify(coords), seed, ownerId],
  );
  return {
    id: result.insertId,
    coords,
    seed,
    ownerId,
    growth: 0,
  };
}

/**
 * Delete a weed plant by ID.
 *
 * @param {number} id - The ID of the weed plant to delete
 * @returns {Promise<void>}
 */
async function deleteWeedPlant(id) {
  await db.query('DELETE FROM weed_plants WHERE id = ?', [id]);
}

/**
 * Update growth value for a weed plant.
 *
 * @param {number} id - Weed plant ID
 * @param {number} growth - New growth value
 * @returns {Promise<Object>} Updated weed plant record
 */
async function updateWeedPlant(id, growth) {
  await db.query('UPDATE weed_plants SET growth = ? WHERE id = ?', [growth, id]);
  const [rows] = await db.query('SELECT id, coords, seed, owner_id AS ownerId, growth FROM weed_plants WHERE id = ?', [id]);
  return rows[0];
}

/**
 * Retrieve all weed plants.
 *
 * @returns {Promise<Array>} List of weed plant records
 */
async function getAllWeedPlants() {
  const [rows] = await db.query('SELECT id, coords, seed, owner_id AS ownerId, growth FROM weed_plants');
  return rows.map((row) => ({
    id: row.id,
    coords: JSON.parse(row.coords),
    seed: row.seed,
    ownerId: row.ownerId,
    growth: row.growth,
  }));
}

module.exports = {
  createWeedPlant,
  deleteWeedPlant,
  updateWeedPlant,
  getAllWeedPlants,
};