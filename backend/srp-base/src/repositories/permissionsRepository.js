const db = require('./db');

/**
 * Permissions repository.  Provides CRUD operations for the
 * permissions table.  Permissions (scopes) grant additional
 * capabilities to a player beyond the default.  Scopes are
 * represented as strings (e.g. 'admin', 'police', 'ems').
 */

/**
 * Retrieve the list of scopes granted to a player.
 *
 * @param {string} playerId
 * @returns {Promise<string[]>}
 */
async function getPlayerScopes(playerId) {
  const rows = await db.query('SELECT scope FROM permissions WHERE player_id = ?', [playerId]);
  return rows.map((r) => r.scope);
}

/**
 * Grant a permission (scope) to a player.  Duplicate grants are
 * ignored by using INSERT IGNORE.  Returns the resulting scopes
 * after the operation.
 *
 * @param {string} playerId
 * @param {string} scope
 */
async function grant(playerId, scope) {
  await db.query('INSERT IGNORE INTO permissions (player_id, scope, granted_at) VALUES (?, ?, NOW())', [playerId, scope]);
  return getPlayerScopes(playerId);
}

/**
 * Revoke a permission from a player.  Returns the resulting scopes.
 *
 * @param {string} playerId
 * @param {string} scope
 */
async function revoke(playerId, scope) {
  await db.query('DELETE FROM permissions WHERE player_id = ? AND scope = ?', [playerId, scope]);
  return getPlayerScopes(playerId);
}

module.exports = { getPlayerScopes, grant, revoke };