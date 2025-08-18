const db = require('./db');

/**
 * Repository for managing door state.  Doors represent world objects
 * that can be locked or unlocked.  Each door is uniquely
 * identified by a string `door_id` which comes from the game
 * configuration (e.g. hash or name).  The position property is
 * stored as JSON and should contain x, y, z coordinates along
 * with any other metadata required by the client.  The state is
 * stored as TINYINT(1) for boolean semantics.
 */

async function getAll() {
  const [rows] = await db.query('SELECT door_id, name, state, position, heading, created_at, updated_at FROM doors');
  return rows.map(r => ({
    doorId: r.door_id,
    name: r.name,
    locked: !!r.state,
    position: r.position ? JSON.parse(r.position) : null,
    heading: r.heading,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  }));
}

async function get(doorId) {
  const [rows] = await db.query('SELECT door_id, name, state, position, heading, created_at, updated_at FROM doors WHERE door_id = ?', [doorId]);
  const r = rows[0];
  if (!r) return null;
  return {
    doorId: r.door_id,
    name: r.name,
    locked: !!r.state,
    position: r.position ? JSON.parse(r.position) : null,
    heading: r.heading,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  };
}

async function createOrUpdate({ doorId, name, locked, position, heading }) {
  // Determine if door exists
  const [rows] = await db.query('SELECT id FROM doors WHERE door_id = ?', [doorId]);
  const state = locked ? 1 : 0;
  const posJson = position ? JSON.stringify(position) : null;
  if (rows.length > 0) {
    await db.query(
      'UPDATE doors SET name = ?, state = ?, position = ?, heading = ?, updated_at = NOW() WHERE door_id = ?',
      [name, state, posJson, heading, doorId],
    );
  } else {
    await db.query(
      'INSERT INTO doors (door_id, name, state, position, heading) VALUES (?, ?, ?, ?, ?)',
      [doorId, name, state, posJson, heading],
    );
  }
  return get(doorId);
}

async function setState(doorId, locked) {
  const state = locked ? 1 : 0;
  await db.query('UPDATE doors SET state = ?, updated_at = NOW() WHERE door_id = ?', [state, doorId]);
  return get(doorId);
}

module.exports = {
  getAll,
  get,
  createOrUpdate,
  setState,
};