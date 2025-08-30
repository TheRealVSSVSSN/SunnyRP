const db = require('./db');

async function listAnimations() {
  const [rows] = await db.query(
    'SELECT id, name, dict, animation, disabled, created_at AS createdAt, updated_at AS updatedAt FROM dance_animations WHERE disabled = 0 ORDER BY id ASC',
  );
  return rows;
}

async function createAnimation({ name, dict, animation }) {
  await db.query(
    'INSERT INTO dance_animations (name, dict, animation) VALUES (?, ?, ?)',
    [name, dict, animation],
  );
  const [rows] = await db.query(
    'SELECT id, name, dict, animation, disabled, created_at AS createdAt, updated_at AS updatedAt FROM dance_animations WHERE name = ? AND dict = ? AND animation = ? ORDER BY id DESC LIMIT 1',
    [name, dict, animation],
  );
  return rows[0] || null;
}

async function disableAnimation(id) {
  await db.query('UPDATE dance_animations SET disabled = 1, updated_at = CURRENT_TIMESTAMP WHERE id = ?', [id]);
}

async function purgeOldDisabled(cutoffMs) {
  const cutoff = new Date(cutoffMs);
  const [rows] = await db.query(
    'SELECT id, name, dict, animation FROM dance_animations WHERE disabled = 1 AND updated_at < ?',
    [cutoff],
  );
  if (rows.length > 0) {
    await db.query('DELETE FROM dance_animations WHERE disabled = 1 AND updated_at < ?', [cutoff]);
  }
  return rows;
}

module.exports = {
  listAnimations,
  createAnimation,
  disableAnimation,
  purgeOldDisabled,
};
