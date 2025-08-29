const db = require('./db');

/**
 * Create a ban entry for a player.
 *
 * @param {string} playerId - Unique identifier for the player.
 * @param {string} reason - Reason for the ban.
 * @param {Date|null} until - Optional expiration timestamp; null for permanent ban.
 * @returns {Promise<void>} Resolves when the ban has been persisted.
 */
async function banPlayer(playerId, reason, until) {
  await db.query(
    'INSERT INTO bans (player_id, reason, until) VALUES (?, ?, ?)',
    [playerId, reason, until],
  );
}

/**
 * Record a noclip toggle event for a player.
 *
 * @param {string} playerId - Player receiving noclip.
 * @param {string} actorId - Admin or developer performing the action.
 * @param {boolean} enabled - Whether noclip is enabled.
 */
async function setNoclip(playerId, actorId, enabled) {
  await db.query(
    'INSERT INTO noclip_events (player_id, actor_id, enabled) VALUES (?, ?, ?)',
    [playerId, actorId, enabled ? 1 : 0],
  );
}

module.exports = {
  banPlayer,
  setNoclip,
};
