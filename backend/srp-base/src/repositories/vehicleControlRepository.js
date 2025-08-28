const db = require('./db');

/**
 * Retrieve vehicle control state by plate.
 * @param {string} plate
 * @returns {Promise<object|null>}
 */
async function getByPlate(plate) {
  const rows = await db.query(
    'SELECT plate, siren_muted AS sirenMuted, lx_siren_state AS lxSirenState, powercall_state AS powercallState, air_manu_state AS airManuState, indicator_state AS indicatorState, updated_at AS updatedAt FROM vehicle_control_states WHERE plate = ?',[plate]);
  return rows[0] || null;
}

/**
 * Upsert vehicle control state for a plate. Undefined fields keep existing values.
 * @param {string} plate
 * @param {object} state
 * @returns {Promise<number>} affected rows
 */
async function upsert(plate, state) {
  const {
    sirenMuted = null,
    lxSirenState = null,
    powercallState = null,
    airManuState = null,
    indicatorState = null,
  } = state;
  const result = await db.query(
    `INSERT INTO vehicle_control_states
      (plate, siren_muted, lx_siren_state, powercall_state, air_manu_state, indicator_state, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, NOW())
      ON DUPLICATE KEY UPDATE
        siren_muted = COALESCE(VALUES(siren_muted), siren_muted),
        lx_siren_state = COALESCE(VALUES(lx_siren_state), lx_siren_state),
        powercall_state = COALESCE(VALUES(powercall_state), powercall_state),
        air_manu_state = COALESCE(VALUES(air_manu_state), air_manu_state),
        indicator_state = COALESCE(VALUES(indicator_state), indicator_state),
        updated_at = NOW()`,
    [plate, sirenMuted, lxSirenState, powercallState, airManuState, indicatorState],
  );
  return result.affectedRows;
}

/**
 * Delete control states last updated before cutoff.
 * @param {Date} cutoff
 * @returns {Promise<number>} number removed
 */
async function deleteOlderThan(cutoff) {
  const result = await db.query('DELETE FROM vehicle_control_states WHERE updated_at < ?', [cutoff]);
  return result.affectedRows;
}

module.exports = { getByPlate, upsert, deleteOlderThan };
