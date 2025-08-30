const db = require('./db');

async function list(limit = 50, offset = 0) {
  return db.query(
    'SELECT id, name, description, restricted_police AS police, restricted_ems AS ems, restricted_judge AS judge FROM commands ORDER BY id LIMIT ? OFFSET ?',
    [limit, offset]
  );
}

async function create({ name, description = '', police = false, ems = false, judge = false }) {
  const result = await db.query(
    'INSERT INTO commands (name, description, restricted_police, restricted_ems, restricted_judge) VALUES (?, ?, ?, ?, ?)',
    [name, description, police ? 1 : 0, ems ? 1 : 0, judge ? 1 : 0]
  );
  return { id: result.insertId, name, description, police, ems, judge };
}

async function remove(id) {
  await db.query('DELETE FROM commands WHERE id = ?', [id]);
}

module.exports = {
  list,
  create,
  remove,
};
