const db = require('./db');

/**
 * Retrieve vehicle HUD status for a character. Defaults to false/zero when none exist.
 * @param {number} characterId
 * @returns {Promise<Object>}
 */
async function getStatus(characterId) {
  const rows = await db.query(
    'SELECT character_id AS characterId, seatbelt, harness, nitrous FROM character_vehicle_status WHERE character_id = ?',
    [characterId],
  );
  if (rows.length === 0) {
    return { characterId, seatbelt: false, harness: false, nitrous: 0 };
  }
  const row = rows[0];
  return {
    characterId: row.characterId,
    seatbelt: row.seatbelt === 1,
    harness: row.harness === 1,
    nitrous: row.nitrous || 0,
  };
}

/**
 * Upsert vehicle HUD status for a character.
 * @param {number} characterId
 * @param {Object} status
 * @param {boolean} status.seatbelt
 * @param {boolean} status.harness
 * @param {number} status.nitrous
 * @returns {Promise<Object>}
 */
async function upsertStatus(characterId, { seatbelt, harness, nitrous }) {
  await db.query(
    'INSERT INTO character_vehicle_status (character_id, seatbelt, harness, nitrous, updated_at) VALUES (?, ?, ?, ?, NOW()) ON DUPLICATE KEY UPDATE seatbelt = VALUES(seatbelt), harness = VALUES(harness), nitrous = VALUES(nitrous), updated_at = NOW()',
    [characterId, seatbelt ? 1 : 0, harness ? 1 : 0, nitrous || 0],
  );
  return { characterId, seatbelt: !!seatbelt, harness: !!harness, nitrous: nitrous || 0 };
}

/**
 * Remove stale vehicle HUD status entries older than the supplied TTL.
 * @param {number} ttlMs
 */
async function pruneStale(ttlMs) {
  await db.query(
    'DELETE FROM character_vehicle_status WHERE updated_at < DATE_SUB(NOW(), INTERVAL ? SECOND)',
    [Math.floor(ttlMs / 1000)],
  );
}

module.exports = { getStatus, upsertStatus, pruneStale };
