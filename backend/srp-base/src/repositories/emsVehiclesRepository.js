const db = require('./db');

async function logSpawn(characterId, vehicleType) {
  const [result] = await db.pool.query(
    'INSERT INTO ems_vehicle_spawns (character_id, vehicle_type) VALUES (?, ?)',
    [characterId, vehicleType],
  );
  const rows = await db.query(
    'SELECT id, character_id AS characterId, vehicle_type AS vehicleType, created_at AS createdAt FROM ems_vehicle_spawns WHERE id = ?',
    [result.insertId],
  );
  return rows[0];
}

async function deleteSpawnsBefore(cutoffMs) {
  await db.query(
    'DELETE FROM ems_vehicle_spawns WHERE created_at < FROM_UNIXTIME(?)',
    [Math.floor(cutoffMs / 1000)],
  );
}

module.exports = {
  logSpawn,
  deleteSpawnsBefore,
};
