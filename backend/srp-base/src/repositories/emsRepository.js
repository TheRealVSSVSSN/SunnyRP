const { query } = require('./db');

/**
 * Repository for EMS records. Provides CRUD operations on ems_records.
 */

async function getRecords() {
  const rows = await query('SELECT * FROM ems_records ORDER BY created_at DESC LIMIT 100');
  return rows;
}

async function getRecord(id) {
  const rows = await query('SELECT * FROM ems_records WHERE id = ?', [id]);
  return rows[0] || null;
}

async function createRecord({ patient_id, doctor_id, treatment, status }) {
  const result = await query(
    'INSERT INTO ems_records (patient_id, doctor_id, treatment, status) VALUES (?, ?, ?, ?)',
    [patient_id, doctor_id, treatment, status || 'open'],
  );
  const insertId = result.insertId || result[0]?.insertId;
  return getRecord(insertId);
}

async function updateRecord(id, { treatment, status }) {
  await query(
    'UPDATE ems_records SET treatment = COALESCE(?, treatment), status = COALESCE(?, status), updated_at = CURRENT_TIMESTAMP WHERE id = ?',
    [treatment || null, status || null, id],
  );
  return getRecord(id);
}

async function deleteRecord(id) {
  const result = await query('DELETE FROM ems_records WHERE id = ?', [id]);
  return (result.affectedRows || result[0]?.affectedRows) > 0;
}

module.exports = {
  getRecords,
  getRecord,
  createRecord,
  updateRecord,
  deleteRecord,
};