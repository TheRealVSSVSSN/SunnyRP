const db = require('./db');

/**
 * List all police officers.
 * @returns {Promise<Array>} list of officers
 */
async function listOfficers() {
  const [rows] = await db.query('SELECT * FROM police_officers');
  return rows;
}

/**
 * Assign a player as a police officer.
 * @param {number} playerId - Player ID
 * @param {string} rank - Officer rank
 * @param {number} onDuty - Whether the officer is on duty (1 or 0)
 * @returns {Promise<Object>} created officer record
 */
async function assignOfficer(playerId, rank = 'officer', onDuty = 0) {
  const [result] = await db.query(
    'INSERT INTO police_officers (player_id, rank, on_duty) VALUES (?, ?, ?)',
    [playerId, rank, onDuty],
  );
  return { id: result.insertId, playerId, rank, onDuty };
}

/**
 * Update a police officer's rank or duty status.
 * @param {number} id - Officer record ID
 * @param {Object} data - Fields to update
 * @returns {Promise<Object>} updated officer record
 */
async function updateOfficer(id, data) {
  const fields = [];
  const values = [];
  if (data.rank) {
    fields.push('rank = ?');
    values.push(data.rank);
  }
  if (data.onDuty !== undefined) {
    fields.push('on_duty = ?');
    values.push(data.onDuty);
  }
  if (fields.length === 0) {
    const [rows] = await db.query('SELECT * FROM police_officers WHERE id = ?', [id]);
    return rows[0];
  }
  values.push(id);
  await db.query(`UPDATE police_officers SET ${fields.join(', ')} WHERE id = ?`, values);
  const [rows] = await db.query('SELECT * FROM police_officers WHERE id = ?', [id]);
  return rows[0];
}

module.exports = {
  listOfficers,
  assignOfficer,
  updateOfficer,
};