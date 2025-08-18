const db = require('./db');

/**
 * Repository for logging errors and warnings originating from the
 * client or server.  Each log entry captures the level, a
 * descriptive message, the source (client/server), and an
 * optional stack trace.  Use this repository to persist
 * errors in a dedicated table for later analysis.
 */

async function log({ source = 'unknown', level = 'error', message, stack = null }) {
  await db.query(
    'INSERT INTO error_log (source, level, message, stack) VALUES (?, ?, ?, ?)',
    [source, level, message, stack],
  );
}

async function list({ limit = 100, level } = {}) {
  let sql = 'SELECT id, source, level, message, stack, created_at FROM error_log';
  const params = [];
  if (level) {
    sql += ' WHERE level = ?';
    params.push(level);
  }
  sql += ' ORDER BY created_at DESC LIMIT ?';
  params.push(Number(limit));
  const [rows] = await db.query(sql, params);
  return rows.map(r => ({
    id: r.id,
    source: r.source,
    level: r.level,
    message: r.message,
    stack: r.stack,
    createdAt: r.created_at,
  }));
}

module.exports = {
  log,
  list,
};