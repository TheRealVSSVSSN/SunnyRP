const { query } = require('./db');

/**
 * Repository for loot items. Handles creating, retrieving,
 * updating and deleting loot records.
 */

async function getItems() {
  const rows = await query('SELECT * FROM loot_items ORDER BY created_at DESC LIMIT 100');
  return rows;
}

async function getItem(id) {
  const rows = await query('SELECT * FROM loot_items WHERE id = ?', [id]);
  return rows[0] || null;
}

async function createItem({ owner_id, item_type, value, coordinates, metadata }) {
  const result = await query(
    'INSERT INTO loot_items (owner_id, item_type, value, coordinates, metadata) VALUES (?, ?, ?, ?, ?)',
    [owner_id, item_type, value || 0, coordinates ? JSON.stringify(coordinates) : null, metadata ? JSON.stringify(metadata) : null],
  );
  const insertId = result.insertId || result[0]?.insertId;
  return getItem(insertId);
}

async function updateItem(id, { owner_id, item_type, value, coordinates, metadata }) {
  await query(
    'UPDATE loot_items SET owner_id = COALESCE(?, owner_id), item_type = COALESCE(?, item_type), value = COALESCE(?, value), coordinates = COALESCE(?, coordinates), metadata = COALESCE(?, metadata), updated_at = CURRENT_TIMESTAMP WHERE id = ?',
    [owner_id || null, item_type || null, value || null, coordinates ? JSON.stringify(coordinates) : null, metadata ? JSON.stringify(metadata) : null, id],
  );
  return getItem(id);
}

async function deleteItem(id) {
  const result = await query('DELETE FROM loot_items WHERE id = ?', [id]);
  return (result.affectedRows || result[0]?.affectedRows) > 0;
}

module.exports = {
  getItems,
  getItem,
  createItem,
  updateItem,
  deleteItem,
};