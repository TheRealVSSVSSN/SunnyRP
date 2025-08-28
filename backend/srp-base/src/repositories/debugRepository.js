const os = require('os');
const db = require('./db');

/**
 * Gather basic server diagnostics for debugging purposes.
 * @returns {Promise<{uptime:number,memory:number,timestamp:string,loadavg:number[]}>>}
 */
async function getSystemInfo() {
  return {
    uptime: process.uptime(),
    memory: process.memoryUsage().rss,
    timestamp: new Date().toISOString(),
    loadavg: os.loadavg(),
  };
}

/**
 * Insert a debug log entry.
 * @param {{level:string,message:string,context?:object,accountId?:string,characterId?:number,source?:string}} log
 * @returns {Promise<object>} inserted row
 */
async function insertLog({ level, message, context = null, accountId = null, characterId = null, source = null }) {
  await db.query(
    'INSERT INTO debug_logs (level, message, context, account_id, character_id, source, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())',
    [level, message, context ? JSON.stringify(context) : null, accountId, characterId, source],
  );
  const rows = await db.query(
    'SELECT id, level, message, context, account_id AS accountId, character_id AS characterId, source, created_at AS createdAt FROM debug_logs ORDER BY id DESC LIMIT 1',
  );
  const row = rows[0];
  return { ...row, context: row.context ? JSON.parse(row.context) : null };
}

/**
 * List debug logs with filters.
 * @param {{level?:string, since?:string, limit?:number, accountId?:string, characterId?:number}} filters
 * @returns {Promise<object[]>}
 */
async function listLogs({ level, since, limit = 100, accountId, characterId }) {
  const clauses = [];
  const params = [];
  if (level) {
    clauses.push('level = ?');
    params.push(level);
  }
  if (since) {
    clauses.push('created_at >= ?');
    params.push(since);
  }
  if (accountId) {
    clauses.push('account_id = ?');
    params.push(accountId);
  }
  if (characterId) {
    clauses.push('character_id = ?');
    params.push(characterId);
  }
  const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
  const rows = await db.query(
    `SELECT id, level, message, context, account_id AS accountId, character_id AS characterId, source, created_at AS createdAt FROM debug_logs ${where} ORDER BY id DESC LIMIT ?`,
    [...params, Math.max(1, Math.min(1000, limit))],
  );
  return rows.map((r) => ({ ...r, context: r.context ? JSON.parse(r.context) : null }));
}

/**
 * Create a debug marker (ephemeral drawing instruction for clients).
 * @param {{type:string,data:object,ttlMs?:number,createdBy?:number}} marker
 * @returns {Promise<object>} stored marker
 */
async function createMarker({ type, data, ttlMs = 60000, createdBy = null }) {
  const expiresAt = ttlMs ? new Date(Date.now() + ttlMs) : null;
  await db.query(
    'INSERT INTO debug_markers (type, data, created_by, created_at, expires_at) VALUES (?, ?, ?, NOW(), ?)',
    [type, JSON.stringify(data || {}), createdBy, expiresAt ? expiresAt.toISOString().slice(0, 19).replace('T', ' ') : null],
  );
  const rows = await db.query(
    'SELECT id, type, data, created_by AS createdBy, created_at AS createdAt, expires_at AS expiresAt FROM debug_markers ORDER BY id DESC LIMIT 1',
  );
  const row = rows[0];
  return { ...row, data: row.data ? JSON.parse(row.data) : {} };
}

/**
 * List active markers (optionally filter by type).
 * @param {{type?:string}} filters
 * @returns {Promise<object[]>}
 */
async function listActiveMarkers({ type } = {}) {
  const clauses = ['(expires_at IS NULL OR expires_at > NOW())'];
  const params = [];
  if (type) {
    clauses.push('type = ?');
    params.push(type);
  }
  const where = `WHERE ${clauses.join(' AND ')}`;
  const rows = await db.query(
    `SELECT id, type, data, created_by AS createdBy, created_at AS createdAt, expires_at AS expiresAt FROM debug_markers ${where} ORDER BY id DESC LIMIT 1000`,
    params,
  );
  return rows.map((r) => ({ ...r, data: r.data ? JSON.parse(r.data) : {} }));
}

/**
 * Delete a marker by id.
 * @param {number} id
 * @returns {Promise<boolean>} true if deleted
 */
async function deleteMarker(id) {
  const res = await db.query('DELETE FROM debug_markers WHERE id = ?', [id]);
  return res.affectedRows > 0;
}

/** Purge expired markers; return deleted ids. */
async function purgeExpiredMarkers() {
  const rows = await db.query('SELECT id FROM debug_markers WHERE expires_at IS NOT NULL AND expires_at <= NOW()');
  if (!rows.length) return [];
  const ids = rows.map((r) => r.id);
  await db.query('DELETE FROM debug_markers WHERE id IN (' + ids.map(() => '?').join(',') + ')', ids);
  return ids;
}

/** Purge debug logs older than cutoff ISO date string. */
async function purgeOldLogs(cutoffIso) {
  await db.query('DELETE FROM debug_logs WHERE created_at < ?', [cutoffIso]);
}

module.exports = {
  getSystemInfo,
  insertLog,
  listLogs,
  createMarker,
  listActiveMarkers,
  deleteMarker,
  purgeExpiredMarkers,
  purgeOldLogs,
};
