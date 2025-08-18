const { query } = require('./db');

/**
 * Repository for player keys. Keys grant access to vehicles, properties
 * or other resources.  Supports assignment, revocation and listing.
 */

async function assignKey({ player_id, key_type, target_id, metadata }) {
  const result = await query(
    'INSERT INTO keys (player_id, key_type, target_id, metadata) VALUES (?, ?, ?, ?)',
    [player_id, key_type, target_id, metadata ? JSON.stringify(metadata) : null],
  );
  const insertId = result.insertId || result[0]?.insertId;
  return getKey(insertId);
}

async function getKey(id) {
  const rows = await query('SELECT * FROM keys WHERE id = ?', [id]);
  return rows[0] || null;
}

async function revokeKey(id) {
  const result = await query('DELETE FROM keys WHERE id = ?', [id]);
  return (result.affectedRows || result[0]?.affectedRows) > 0;
}

async function listKeysForPlayer(player_id) {
  const rows = await query('SELECT * FROM keys WHERE player_id = ?', [player_id]);
  return rows;
}

module.exports = {
  assignKey,
  getKey,
  revokeKey,
  listKeysForPlayer,
};