const db = require('./db');

/**
 * Repository for managing per-player ammunition counts.  Each player
 * may have multiple weapon types tracked with separate counts.  This
 * repository exposes functions to retrieve a player's current ammo
 * map and to update the count for a specific weapon type.  All
 * queries use parameterised SQL to prevent injection.
 */

/**
 * Retrieve the current ammunition counts for a player.
 *
 * @param {string} playerId - The unique identifier for the player.
 * @returns {Promise<Object>} A mapping of weapon type names to ammo counts.
 */
async function getPlayerAmmo(playerId) {
  const [rows] = await db.query(
    'SELECT weapon_type, ammo FROM player_ammo WHERE player_id = ?',
    [playerId],
  );
  const ammo = {};
  for (const row of rows) {
    ammo[row.weapon_type] = row.ammo;
  }
  return ammo;
}

/**
 * Update the ammunition count for a specific weapon type for a player.
 * If an entry does not exist, it will be created; otherwise the
 * existing record will be updated.  Returns the full ammo map for
 * the player after the update.
 *
 * @param {string} playerId - The unique identifier for the player.
 * @param {string} weaponType - The weapon type name (e.g. WEAPON_PISTOL).
 * @param {number} ammoCount - The number of rounds remaining.
 * @returns {Promise<Object>} The updated ammo map for the player.
 */
async function updatePlayerAmmo(playerId, weaponType, ammoCount) {
  await db.query(
    'INSERT INTO player_ammo (player_id, weapon_type, ammo) VALUES (?, ?, ?)\n' +
      '  ON DUPLICATE KEY UPDATE ammo = VALUES(ammo)',
    [playerId, weaponType, ammoCount],
  );
  return getPlayerAmmo(playerId);
}

module.exports = {
  getPlayerAmmo,
  updatePlayerAmmo,
};