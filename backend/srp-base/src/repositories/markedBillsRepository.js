const db = require('./db');

/**
 * Get current marked bills balance for a character.
 * @param {number|string} characterId
 * @returns {Promise<number>}
 */
async function getAmount(characterId) {
  const rows = await db.query('SELECT amount FROM character_marked_bills WHERE character_id = ?', [characterId]);
  return rows[0]?.amount || 0;
}

/**
 * Add marked bills to a character.
 * @param {number|string} characterId
 * @param {number} amount
 * @returns {Promise<{amount:number}>}
 */
async function add(characterId, amount) {
  await db.pool.query(
    'INSERT INTO character_marked_bills (character_id, amount) VALUES (?, ?) ON DUPLICATE KEY UPDATE amount = amount + VALUES(amount)',
    [characterId, amount],
  );
  return { amount: await getAmount(characterId) };
}

/**
 * Remove marked bills from a character if sufficient balance exists.
 * @param {number|string} characterId
 * @param {number} amount
 * @returns {Promise<{amount:number}>}
 */
async function subtract(characterId, amount) {
  const [res] = await db.pool.query(
    'UPDATE character_marked_bills SET amount = amount - ? WHERE character_id = ? AND amount >= ?',
    [amount, characterId, amount],
  );
  if (!res.affectedRows) {
    throw new Error('INSUFFICIENT_FUNDS');
  }
  return { amount: await getAmount(characterId) };
}

module.exports = { getAmount, add, subtract };
