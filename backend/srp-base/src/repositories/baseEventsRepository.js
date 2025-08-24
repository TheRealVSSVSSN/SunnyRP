const db = require('./db');

/**
 * Insert a base event log entry.
 *
 * @param {Object} params
 * @param {string} params.accountId - Owning account hex ID
 * @param {number} params.characterId - Active character ID
 * @param {string} params.eventType - Event type identifier
 * @param {object|null} params.metadata - Optional metadata JSON
 * @returns {Promise<Object>} Inserted event record
 */
async function logEvent({ accountId, characterId, eventType, metadata }) {
  const [result] = await db.query(
    'INSERT INTO base_event_logs (account_id, character_id, event_type, metadata) VALUES (?, ?, ?, ?)',
    [accountId, characterId, eventType, metadata ? JSON.stringify(metadata) : null],
  );
  return {
    id: result.insertId,
    accountId,
    characterId,
    eventType,
    metadata: metadata || null,
  };
}

/**
 * Retrieve recent base event logs.
 *
 * @param {Object} params
 * @param {number} params.limit - Max number of events to fetch
 * @returns {Promise<Array>} Array of event records
 */
async function listEvents({ limit }) {
  const [rows] = await db.query(
    'SELECT id, account_id AS accountId, character_id AS characterId, event_type AS eventType, metadata, UNIX_TIMESTAMP(created_at) * 1000 AS createdAt FROM base_event_logs ORDER BY id DESC LIMIT ?',[limit],
  );
  return rows.map((row) => ({
    id: row.id,
    accountId: row.accountId,
    characterId: row.characterId,
    eventType: row.eventType,
    metadata: row.metadata ? JSON.parse(row.metadata) : null,
    createdAt: row.createdAt,
  }));
}

module.exports = {
  logEvent,
  listEvents,
};
