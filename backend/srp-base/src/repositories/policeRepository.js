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
 * Assign a character as a police officer.
 * @param {number} characterId - Character ID
 * @param {string} rank - Officer rank
 * @param {number} onDuty - Whether the officer is on duty (1 or 0)
 * @returns {Promise<Object>} created officer record
 */
async function assignOfficer(characterId, rank = 'officer', onDuty = 0) {
  const [result] = await db.query(
    'INSERT INTO police_officers (character_id, rank, on_duty) VALUES (?, ?, ?)',
    [characterId, rank, onDuty],
  );
  return { id: result.insertId, characterId, rank, onDuty };
}

/**
 * Update a police officer's rank.
 * @param {number} id - Officer record ID
 * @param {string} rank - New rank
 */
async function updateOfficer(id, rank) {
  await db.query('UPDATE police_officers SET rank = ? WHERE id = ?', [rank, id]);
  const [rows] = await db.query('SELECT * FROM police_officers WHERE id = ?', [id]);
  return rows[0];
}

/**
 * Set on-duty status for a character.
 * @param {number} characterId
 * @param {number} onDuty (1 or 0)
 */
async function setDuty(characterId, onDuty) {
  await db.query(
    'UPDATE police_officers SET on_duty = ?, updated_at = CURRENT_TIMESTAMP WHERE character_id = ?',
    [onDuty, characterId],
  );
  const [rows] = await db.query('SELECT * FROM police_officers WHERE character_id = ?', [characterId]);
  return rows[0];
}

/**
 * Set officers off duty if their updated_at is older than cutoff.
 * Returns affected officers.
 */
async function setOffDutyOlderThan(cutoff) {
  const [rows] = await db.query(
    'SELECT id, character_id FROM police_officers WHERE on_duty = 1 AND updated_at < ?',
    [cutoff],
  );
  if (rows.length) {
    const ids = rows.map((r) => r.id);
    await db.query(`UPDATE police_officers SET on_duty = 0 WHERE id IN (${ids.map(() => '?').join(',')})`, ids);
  }
  return rows;
}

module.exports = {
  listOfficers,
  assignOfficer,
  updateOfficer,
  setDuty,
  setOffDutyOlderThan,
};