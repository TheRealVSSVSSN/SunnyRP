const db = require('./db');

/**
 * List queue priority entries. Optionally filter by accountId.
 * @param {number} [accountId]
 * @param {number} [limit=50]
 * @returns {Promise<Array>}
 */
async function listPriorities(accountId, limit = 50) {
  if (accountId) {
    const rows = await db.query(
      'SELECT account_id AS accountId, priority, reason, expires_at AS expiresAt, created_at AS createdAt, updated_at AS updatedAt FROM queue_priorities WHERE account_id = ? ORDER BY priority DESC LIMIT ?',
      [accountId, limit],
    );
    return rows;
  }
  const rows = await db.query(
    'SELECT account_id AS accountId, priority, reason, expires_at AS expiresAt, created_at AS createdAt, updated_at AS updatedAt FROM queue_priorities ORDER BY priority DESC LIMIT ?',
    [limit],
  );
  return rows;
}

/**
 * Upsert a queue priority entry for an account.
 * @param {Object} params
 * @param {number} params.accountId
 * @param {number} params.priority
 * @param {string} [params.reason]
 * @param {Date} [params.expiresAt]
 * @returns {Promise<Object>}
 */
async function upsertPriority({ accountId, priority, reason, expiresAt }) {
  await db.query(
    'INSERT INTO queue_priorities (account_id, priority, reason, expires_at) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE priority = VALUES(priority), reason = VALUES(reason), expires_at = VALUES(expires_at), updated_at = CURRENT_TIMESTAMP',
    [accountId, priority, reason || null, expiresAt || null],
  );
  const [row] = await db.query(
    'SELECT account_id AS accountId, priority, reason, expires_at AS expiresAt, created_at AS createdAt, updated_at AS updatedAt FROM queue_priorities WHERE account_id = ?',
    [accountId],
  );
  return row;
}

/**
 * Remove a queue priority entry for an account.
 * @param {number} accountId
 * @returns {Promise<void>}
 */
async function removePriority(accountId) {
  await db.query('DELETE FROM queue_priorities WHERE account_id = ?', [accountId]);
}

/**
 * Purge expired queue priorities and return affected account IDs.
 * @returns {Promise<number[]>}
 */
async function purgeExpired() {
  const rows = await db.query(
    'SELECT account_id FROM queue_priorities WHERE expires_at IS NOT NULL AND expires_at < NOW()',
  );
  if (rows.length) {
    await db.query('DELETE FROM queue_priorities WHERE expires_at IS NOT NULL AND expires_at < NOW()');
  }
  return rows.map((r) => r.account_id);
}

module.exports = {
  listPriorities,
  upsertPriority,
  removePriority,
  purgeExpired,
};
