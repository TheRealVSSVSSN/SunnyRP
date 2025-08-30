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

/**
 * Remove all active bans for a player and log the action.
 *
 * @param {string} playerId - Player identifier to unban.
 * @param {string} actorId - Admin performing the unban.
 * @param {string} reason - Reason provided for unbanning.
 * @returns {Promise<void>} Resolves when the ban has been lifted.
 */
async function unbanPlayer(playerId, actorId, reason) {
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query('DELETE FROM bans WHERE player_id = ?', [playerId]);
    await conn.query(
      'INSERT INTO unban_events (player_id, actor_id, reason) VALUES (?, ?, ?)',
      [playerId, actorId, reason],
    );
    await conn.commit();
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

/**
 * Check if a player currently has an active ban.
 *
 * @param {string} playerId - Player identifier to check.
 * @returns {Promise<{ banned: boolean, reason: string|null, until: Date|null }>}
 */
async function isPlayerBanned(playerId) {
  const rows = await db.query('SELECT reason, until FROM bans WHERE player_id = ? LIMIT 1', [playerId]);
  if (!rows[0]) return { banned: false, reason: null, until: null };
  return { banned: true, reason: rows[0].reason, until: rows[0].until };
}

module.exports = {
  banPlayer,
  setNoclip,
  unbanPlayer,
  isPlayerBanned,
};
