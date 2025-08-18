const db = require('./db');

/**
 * Inventory repository.  Provides CRUD operations for a player's
 * inventory.  Each entry consists of a player_id, an item name
 * and a quantity.  Quantities are always non‑negative.  When a
 * quantity reaches zero the row is deleted entirely.
 */

/**
 * Retrieve the inventory for a given player.  Returns an array of
 * objects each containing the item name and quantity.  If the
 * player has no items the array will be empty.
 *
 * @param {string} playerId
 * @returns {Promise<object[]>}
 */
async function getInventory(playerId) {
  return db.query(
    'SELECT item, quantity FROM inventory WHERE player_id = ?',
    [playerId],
  );
}

/**
 * Add an item to a player's inventory.  If the item already exists
 * the quantity is incremented, otherwise a new row is inserted.
 *
 * @param {string} playerId
 * @param {string} item
 * @param {number} quantity
 * @returns {Promise<{quantity: number}>}
 */
async function addItem(playerId, item, quantity) {
  const rows = await db.query(
    'SELECT id, quantity FROM inventory WHERE player_id = ? AND item = ?',
    [playerId, item],
  );
  if (rows.length > 0) {
    const newQty = rows[0].quantity + quantity;
    await db.query('UPDATE inventory SET quantity = ? WHERE id = ?', [newQty, rows[0].id]);
    return { quantity: newQty };
  }
  await db.query(
    'INSERT INTO inventory (player_id, item, quantity) VALUES (?, ?, ?)',
    [playerId, item, quantity],
  );
  return { quantity };
}

/**
 * Remove an item from a player's inventory.  Decrements the
 * quantity and deletes the row when it reaches zero.  Returns the
 * new quantity or zero if the item was removed entirely.
 *
 * @param {string} playerId
 * @param {string} item
 * @param {number} quantity
 * @returns {Promise<{quantity: number}>}
 */
async function removeItem(playerId, item, quantity) {
  const rows = await db.query(
    'SELECT id, quantity FROM inventory WHERE player_id = ? AND item = ?',
    [playerId, item],
  );
  if (rows.length === 0) {
    return { quantity: 0 };
  }
  let newQty = rows[0].quantity - quantity;
  if (newQty <= 0) {
    await db.query('DELETE FROM inventory WHERE id = ?', [rows[0].id]);
    newQty = 0;
  } else {
    await db.query('UPDATE inventory SET quantity = ? WHERE id = ?', [newQty, rows[0].id]);
  }
  return { quantity: newQty };
}

module.exports = { getInventory, addItem, removeItem };