const db = require('./db');

/**
 * Retrieve all gangs.
 * @returns {Promise<Array>} list of gangs
 */
async function listGangs() {
  const [rows] = await db.query('SELECT * FROM gangs');
  return rows;
}

/**
 * Create a new gang.
 * @param {string} name - Gang name
 * @returns {Promise<Object>} created gang
 */
async function createGang(name) {
  const [result] = await db.query('INSERT INTO gangs (name) VALUES (?)', [name]);
  return { id: result.insertId, name };
}

/**
 * Update an existing gang.
 * @param {number} id - Gang ID
 * @param {string} name - New gang name
 * @returns {Promise<Object>} updated gang
 */
async function updateGang(id, name) {
  await db.query('UPDATE gangs SET name = ? WHERE id = ?', [name, id]);
  const [rows] = await db.query('SELECT * FROM gangs WHERE id = ?', [id]);
  return rows[0];
}

/**
 * Add a member to a gang.
 * @param {number} gangId - Gang ID
 * @param {number} playerId - Player ID
 * @param {string} role - Role within the gang
 * @returns {Promise<Object>} created membership record
 */
async function addMember(gangId, playerId, role = 'member') {
  const [result] = await db.query(
    'INSERT INTO gang_members (gang_id, player_id, role) VALUES (?, ?, ?)',
    [gangId, playerId, role],
  );
  return { id: result.insertId, gangId, playerId, role };
}

/**
 * Remove a member from a gang.
 * @param {number} gangId - Gang ID
 * @param {number} playerId - Player ID
 * @returns {Promise<void>}
 */
async function removeMember(gangId, playerId) {
  await db.query('DELETE FROM gang_members WHERE gang_id = ? AND player_id = ?', [gangId, playerId]);
}

module.exports = {
  listGangs,
  createGang,
  updateGang,
  addMember,
  removeMember,
};