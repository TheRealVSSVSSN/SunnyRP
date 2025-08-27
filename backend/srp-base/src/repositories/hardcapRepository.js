const db = require('./db');

/**
 * Retrieve hardcap configuration and current player count.
 * @returns {Promise<{maxPlayers:number,reservedSlots:number,currentPlayers:number}>}
 */
async function getStatus() {
  const [cfg] = await db.query(
    'SELECT max_players AS maxPlayers, reserved_slots AS reservedSlots FROM hardcap_config WHERE id = 1',
  );
  const [{ count }] = await db.query(
    'SELECT COUNT(*) AS count FROM hardcap_sessions WHERE disconnected_at IS NULL',
  );
  return { maxPlayers: cfg ? cfg.maxPlayers : 0, reservedSlots: cfg ? cfg.reservedSlots : 0, currentPlayers: count };
}

/**
 * Update hardcap configuration.
 * @param {Object} params
 * @param {number} params.maxPlayers
 * @param {number} [params.reservedSlots]
 * @returns {Promise<{maxPlayers:number,reservedSlots:number}>}
 */
async function updateConfig({ maxPlayers, reservedSlots = 0 }) {
  await db.query(
    'UPDATE hardcap_config SET max_players = ?, reserved_slots = ?, updated_at = CURRENT_TIMESTAMP WHERE id = 1',
    [maxPlayers, reservedSlots],
  );
  const [row] = await db.query(
    'SELECT max_players AS maxPlayers, reserved_slots AS reservedSlots FROM hardcap_config WHERE id = 1',
  );
  return row;
}

/**
 * Add an active session for a character.
 * Verifies the character belongs to the account.
 * @param {Object} params
 * @param {number} params.accountId
 * @param {number} params.characterId
 * @returns {Promise<{id:number,accountId:number,characterId:number,connectedAt:string,disconnectedAt:null}>}
 */
async function createSession({ accountId, characterId }) {
  const [owner] = await db.query(
    'SELECT 1 FROM characters WHERE id = ? AND account_id = ?',
    [characterId, accountId],
  );
  if (!owner) {
    throw new Error('CHARACTER_NOT_FOUND');
  }
  const result = await db.query(
    'INSERT INTO hardcap_sessions (account_id, character_id) VALUES (?, ?)',
    [accountId, characterId],
  );
  const [row] = await db.query(
    'SELECT id, account_id AS accountId, character_id AS characterId, connected_at AS connectedAt, disconnected_at AS disconnectedAt FROM hardcap_sessions WHERE id = ?',
    [result.insertId],
  );
  return row;
}

/**
 * Mark a session as disconnected.
 * @param {number} id
 * @returns {Promise<boolean>}
 */
async function endSession(id) {
  const result = await db.query(
    'UPDATE hardcap_sessions SET disconnected_at = CURRENT_TIMESTAMP WHERE id = ? AND disconnected_at IS NULL',
    [id],
  );
  return result.affectedRows > 0;
}

/**
 * Mark sessions as disconnected if they have been active longer than the timeout.
 * @param {number} timeoutMs
 * @returns {Promise<Array<{id:number,accountId:number,characterId:number}>>}
 */
async function purgeStale(timeoutMs) {
  const seconds = Math.floor(timeoutMs / 1000);
  const rows = await db.query(
    'SELECT id, account_id AS accountId, character_id AS characterId FROM hardcap_sessions WHERE disconnected_at IS NULL AND connected_at < DATE_SUB(NOW(), INTERVAL ? SECOND)',
    [seconds],
  );
  if (rows.length) {
    const ids = rows.map((r) => r.id);
    await db.query(
      'UPDATE hardcap_sessions SET disconnected_at = CURRENT_TIMESTAMP WHERE id IN (?)',
      [ids],
    );
  }
  return rows;
}

module.exports = {
  getStatus,
  updateConfig,
  createSession,
  endSession,
  purgeStale,
};
