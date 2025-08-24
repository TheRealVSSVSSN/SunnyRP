const db = require('./db');

/**
 * Retrieve all boats available for purchase.
 * Returns array of { id, model, price }.
 * @returns {Promise<object[]>}
 */
async function listBoats() {
  return db.query('SELECT id, model, price FROM boatshop_boats ORDER BY id', []);
}

/**
 * Purchase a boat for a character. Inserts into vehicles table using
 * characterId as owner. Returns { id, price } or null if boat not found.
 * @param {{characterId: string, boatId: number, plate: string, properties?: object}} params
 * @returns {Promise<{id: number, price: number}|null>}
 */
async function purchaseBoat({ characterId, boatId, plate, properties }) {
  const rows = await db.query('SELECT model, price FROM boatshop_boats WHERE id = ?', [boatId]);
  if (!rows || rows.length === 0) return null;
  const { model, price } = rows[0];
  const props = JSON.stringify(properties || {});
  const result = await db.pool.query(
    'INSERT INTO vehicles (player_id, model, plate, properties) VALUES (?, ?, ?, ?)',
    [characterId, model, plate, props],
  );
  return { id: result[0].insertId, price };
}

module.exports = {
  listBoats,
  purchaseBoat,
};
