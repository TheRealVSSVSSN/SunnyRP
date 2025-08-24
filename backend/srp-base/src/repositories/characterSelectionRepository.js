const db = require('./db');

/**
 * Set the selected character for an account.
 * Idempotent: repeated calls update the existing record.
 * @param {string} ownerHex
 * @param {number} characterId
 */
async function setSelected(ownerHex, characterId) {
  await db.query(
    'INSERT INTO character_selections (owner_hex, character_id, selected_at) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE character_id = VALUES(character_id), selected_at = VALUES(selected_at)',
    [ownerHex, characterId],
  );
}

/**
 * Retrieve the selected character for an account.
 * @param {string} ownerHex
 * @returns {Promise<number|null>}
 */
async function getSelected(ownerHex) {
  const rows = await db.query(
    'SELECT character_id AS characterId FROM character_selections WHERE owner_hex = ? LIMIT 1',
    [ownerHex],
  );
  return rows[0]?.characterId || null;
}

/**
 * Clear the selection for an account.
 * @param {string} ownerHex
 */
async function clear(ownerHex) {
  await db.query('DELETE FROM character_selections WHERE owner_hex = ?', [ownerHex]);
}

module.exports = { setSelected, getSelected, clear };
