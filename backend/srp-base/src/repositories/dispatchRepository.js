const { query } = require('./db');

/**
 * Repository for dispatch alerts and codes. Provides CRUD operations on
 * the dispatch tables. All functions return plain JavaScript objects.
 */

async function getAlerts() {
  const rows = await query('SELECT * FROM dispatch_alerts ORDER BY created_at DESC LIMIT 100');
  return rows;
}

async function getAlert(id) {
  const rows = await query('SELECT * FROM dispatch_alerts WHERE id = ?', [id]);
  return rows[0] || null;
}

async function createAlert({ code, title, description, sender, coords }) {
  const result = await query(
    'INSERT INTO dispatch_alerts (code, title, description, sender, coords) VALUES (?, ?, ?, ?, ?)',
    [code, title, description || null, sender || null, coords ? JSON.stringify(coords) : null],
  );
  const insertId = result.insertId || result[0]?.insertId;
  return getAlert(insertId);
}

async function acknowledgeAlert(id) {
  const result = await query('UPDATE dispatch_alerts SET status = ? WHERE id = ?', ['acknowledged', id]);
  return (result.affectedRows || result[0]?.affectedRows) > 0;
}

async function getCodes() {
  const rows = await query('SELECT * FROM dispatch_codes ORDER BY code ASC');
  return rows;
}

async function deleteOlderThan(cutoff) {
  await query('DELETE FROM dispatch_alerts WHERE created_at < FROM_UNIXTIME(?)', [Math.floor(cutoff / 1000)]);
}

module.exports = {
  getAlerts,
  getAlert,
  createAlert,
  acknowledgeAlert,
  getCodes,
  deleteOlderThan,
};