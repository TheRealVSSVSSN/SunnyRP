const { query } = require('./db');

/**
 * List custody entries for an evidence item.
 * @param {number} evidenceId
 * @returns {Promise<object[]>}
 */
async function listByItem(evidenceId) {
  return query(
    'SELECT id, evidence_id AS evidenceId, handler_id AS handlerId, action, notes, created_at AS createdAt FROM evidence_chain WHERE evidence_id = ? ORDER BY created_at ASC',
    [evidenceId],
  );
}

/**
 * Add a custody entry for an evidence item.
 * @param {number} evidenceId
 * @param {number} handlerId
 * @param {string} action
 * @param {string} [notes]
 * @returns {Promise<object>}
 */
async function addEntry(evidenceId, handlerId, action, notes) {
  const result = await query(
    'INSERT INTO evidence_chain (evidence_id, handler_id, action, notes) VALUES (?, ?, ?, ?)',
    [evidenceId, handlerId, action, notes || null],
  );
  const id = result.insertId || result[0]?.insertId;
  const rows = await query(
    'SELECT id, evidence_id AS evidenceId, handler_id AS handlerId, action, notes, created_at AS createdAt FROM evidence_chain WHERE id = ?',
    [id],
  );
  return rows[0];
}

module.exports = { listByItem, addEntry };
