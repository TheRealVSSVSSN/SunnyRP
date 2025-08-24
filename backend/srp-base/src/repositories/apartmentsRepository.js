const db = require('./db');

/**
 * List apartments. Optionally filter by resident character.
 * @param {number|null} characterId
 * @returns {Promise<Array>} list of apartments
 */
async function listApartments(characterId = null) {
  if (characterId) {
    const [rows] = await db.query(
      `SELECT a.* FROM apartments a
       JOIN apartment_residents ar ON ar.apartment_id = a.id
       WHERE ar.character_id = ?`,
      [characterId],
    );
    return rows;
  }
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
 * @param {number} characterId - Character ID
 * @returns {Promise<Object>} created assignment
 */
async function assignResident(apartmentId, characterId) {
  const [result] = await db.query(
    'INSERT INTO apartment_residents (apartment_id, character_id) VALUES (?, ?)',
    [apartmentId, characterId],
  );
  return { id: result.insertId, apartmentId, characterId };
}

/**
 * Remove a resident from an apartment.
 * @param {number} apartmentId - Apartment ID
 * @param {number} characterId - Character ID
 * @returns {Promise<void>}
 */
async function vacateResident(apartmentId, characterId) {
  await db.query(
    'DELETE FROM apartment_residents WHERE apartment_id = ? AND character_id = ?',
    [apartmentId, characterId],
  );
}

module.exports = {
  listApartments,
  createApartment,
  assignResident,
  vacateResident,
};
