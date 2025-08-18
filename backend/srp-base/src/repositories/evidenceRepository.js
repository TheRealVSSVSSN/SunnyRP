const { query } = require('./db');

/**
 * Repository for evidence items. Handles listing, retrieval and
 * mutation of evidence records.
 */

async function getItems() {
  const rows = await query('SELECT * FROM evidence_items ORDER BY created_at DESC LIMIT 100');
  return rows;
}

async function getItem(id) {
  const rows = await query('SELECT * FROM evidence_items WHERE id = ?', [id]);
  return rows[0] || null;
}

async function createItem({ type, description, location, owner, metadata }) {
  const result = await query(
    'INSERT INTO evidence_items (type, description, location, owner, metadata) VALUES (?, ?, ?, ?, ?)',
    [type, description, location || null, owner || null, metadata ? JSON.stringify(metadata) : null],
  );
  const insertId = result.insertId || result[0]?.insertId;
  return getItem(insertId);
}

async function updateItem(id, { type, description, location, owner, metadata }) {
  await query(
    'UPDATE evidence_items SET type = COALESCE(?, type), description = COALESCE(?, description), location = COALESCE(?, location), owner = COALESCE(?, owner), metadata = COALESCE(?, metadata), updated_at = CURRENT_TIMESTAMP WHERE id = ?',
    [type || null, description || null, location || null, owner || null, metadata ? JSON.stringify(metadata) : null, id],
  );
  return getItem(id);
}

async function deleteItem(id) {
  const result = await query('DELETE FROM evidence_items WHERE id = ?', [id]);
  return (result.affectedRows || result[0]?.affectedRows) > 0;
}

module.exports = {
  getItems,
  getItem,
  createItem,
  updateItem,
  deleteItem,
};