const db = require('./db');

async function createFlight({ characterId, purpose }) {
  const result = await db.query(
    'INSERT INTO heli_flights (character_id, purpose) VALUES (?, ?)',
    [characterId, purpose],
  );
  const id = result.insertId;
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, purpose, start_time AS startTime, end_time AS endTime FROM heli_flights WHERE id = ?',
    [id],
  );
  return rows[0] || null;
}

async function endFlight({ flightId }) {
  const result = await db.query(
    'UPDATE heli_flights SET end_time = NOW() WHERE id = ? AND end_time IS NULL',
    [flightId],
  );
  if (result.affectedRows === 0) return null;
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, purpose, start_time AS startTime, end_time AS endTime FROM heli_flights WHERE id = ?',
    [flightId],
  );
  return rows[0] || null;
}

async function listFlightsByCharacter(characterId, limit = 50) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, purpose, start_time AS startTime, end_time AS endTime FROM heli_flights WHERE character_id = ? ORDER BY id DESC LIMIT ?',
    [characterId, limit],
  );
  return rows;
}

module.exports = { createFlight, endFlight, listFlightsByCharacter };
