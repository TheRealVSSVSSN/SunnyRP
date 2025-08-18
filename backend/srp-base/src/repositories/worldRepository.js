const db = require('./db');

/**
 * World repository.  Provides methods for reading and updating the
 * global world configuration (time, weather, density), recording
 * death/kill events and saving arbitrary coordinate entries.
 * The world tables enable persistent tracking of global state and
 * events which can be consumed by FiveM scripts or analytics.
 */

/**
 * Fetch the most recent world state.  Returns null if no state has
 * been recorded yet.
 *
 * @returns {Promise<object|null>}
 */
async function getWorldState() {
  const rows = await db.query(
    'SELECT id, time, weather, density, updated_at AS updatedAt FROM world_state ORDER BY id DESC LIMIT 1',
    [],
  );
  return rows[0] || null;
}

/**
 * Persist a new world state.  Accepts an object with time,
 * weather and density properties.  Each new state is appended to
 * the table, preserving history.
 *
 * @param {{time?: string, weather?: string, density?: any}} state
 */
async function updateWorldState(state) {
  const { time = null, weather = null, density = null } = state;
  await db.query(
    'INSERT INTO world_state (time, weather, density) VALUES (?, ?, ?)',
    [time, weather, JSON.stringify(density)],
  );
}

/**
 * Record a world event (death, kill or other).  The event type is
 * stored along with player identifiers, weapon used, coordinates
 * and arbitrary metadata.
 *
 * @param {{type: string, playerId: string, killerId?: string, weapon?: string, coords?: object, meta?: object}} event
 */
async function recordEvent(event) {
  const { type, playerId, killerId = null, weapon = null, coords = {}, meta = {} } = event;
  await db.query(
    'INSERT INTO world_events (type, player_id, killer_id, weapon, coords, meta) VALUES (?, ?, ?, ?, ?, ?)',
    [
      type,
      playerId,
      killerId,
      weapon,
      JSON.stringify(coords || {}),
      JSON.stringify(meta || {}),
    ],
  );
}

/**
 * Save a coordinates entry.  Useful for admin commands or zone
 * creation in Lua scripts.  Each entry has a label and an
 * arbitrary JSON coordinates object.
 *
 * @param {{playerId: string, label: string, coords: object}} entry
 */
async function saveCoordinates(entry) {
  const { playerId, label, coords } = entry;
  await db.query(
    'INSERT INTO saved_coords (player_id, label, coords) VALUES (?, ?, ?)',
    [playerId, label, JSON.stringify(coords)],
  );
}

module.exports = {
  getWorldState,
  updateWorldState,
  recordEvent,
  saveCoordinates,
};