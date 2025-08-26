const db = require('./db');

async function list() {
  return db.query(
    'SELECT name, enabled, updated_at AS updatedAt FROM ipl_states',
    [],
  );
}

async function set(name, enabled) {
  await db.query(
    'INSERT INTO ipl_states (name, enabled) VALUES (?, ?) ON DUPLICATE KEY UPDATE enabled = VALUES(enabled), updated_at = CURRENT_TIMESTAMP',
    [name, enabled ? 1 : 0],
  );
}

async function remove(name) {
  await db.query('DELETE FROM ipl_states WHERE name = ?', [name]);
}

module.exports = { list, set, remove };
