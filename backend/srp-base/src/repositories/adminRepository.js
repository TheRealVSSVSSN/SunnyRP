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

module.exports = {
  banPlayer,
};
