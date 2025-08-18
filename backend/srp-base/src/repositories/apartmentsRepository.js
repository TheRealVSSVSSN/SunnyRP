const db = require('./db');

/**
 * List all apartments.
 * @returns {Promise<Array>} list of apartments
 */
async function listApartments() {
  const [rows] = await db.query('SELECT * FROM apartments');
  return rows;
}

/**
 * Create a new apartment.
 * @param {string} name - Apartment name
 * @param {Object|null} location - Location object
 * @param {number} price - Price of the apartment
 * @returns {Promise<Object>} created apartment
 */
async function createApartment(name, location = null, price = 0) {
  const [result] = await db.query(
    'INSERT INTO apartments (name, location, price) VALUES (?, ?, ?)',
    [name, location ? JSON.stringify(location) : null, price],
  );
  return { id: result.insertId, name, location, price };
}

/**
 * Assign a resident to an apartment.
 * @param {number} apartmentId - Apartment ID
 * @param {number} playerId - Player ID
 * @returns {Promise<Object>} created assignment
 */
async function assignResident(apartmentId, playerId) {
  const [result] = await db.query(
    'INSERT INTO apartment_residents (apartment_id, player_id) VALUES (?, ?)',
    [apartmentId, playerId],
  );
  return { id: result.insertId, apartmentId, playerId };
}

/**
 * Remove a resident from an apartment.
 * @param {number} apartmentId - Apartment ID
 * @param {number} playerId - Player ID
 * @returns {Promise<void>}
 */
async function vacateResident(apartmentId, playerId) {
  await db.query('DELETE FROM apartment_residents WHERE apartment_id = ? AND player_id = ?', [apartmentId, playerId]);
}

module.exports = {
  listApartments,
  createApartment,
  assignResident,
  vacateResident,
};