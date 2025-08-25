const { query } = require('./db');

// Fetch all active admissions
async function getActiveAdmissions() {
  return query(
    'SELECT id, character_id AS characterId, reason, bed, admitted_at AS admittedAt, notes FROM hospital_admissions WHERE discharged_at IS NULL'
  );
}

// Create a new admission if none active for character
async function createAdmission({ characterId, reason, bed, notes }) {
  const existing = await query(
    'SELECT id, character_id AS characterId, reason, bed, admitted_at AS admittedAt, notes FROM hospital_admissions WHERE character_id = ? AND discharged_at IS NULL',
    [characterId]
  );
  if (existing.length) {
    return existing[0];
  }
  const result = await query(
    'INSERT INTO hospital_admissions (character_id, reason, bed, notes) VALUES (?, ?, ?, ?)',
    [characterId, reason, bed || null, notes || null]
  );
  const insertId = result.insertId || result[0]?.insertId;
  const rows = await query(
    'SELECT id, character_id AS characterId, reason, bed, admitted_at AS admittedAt, notes FROM hospital_admissions WHERE id = ?',
    [insertId]
  );
  return rows[0] || null;
}

// Discharge an admission
async function dischargeAdmission(id) {
  await query('UPDATE hospital_admissions SET discharged_at = CURRENT_TIMESTAMP WHERE id = ? AND discharged_at IS NULL', [id]);
  const rows = await query(
    'SELECT id, character_id AS characterId, reason, bed, admitted_at AS admittedAt, discharged_at AS dischargedAt, notes FROM hospital_admissions WHERE id = ?',
    [id]
  );
  return rows[0] || null;
}

module.exports = {
  getActiveAdmissions,
  createAdmission,
  dischargeAdmission,
};
