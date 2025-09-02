import { query } from '../db/index.js';

export async function getWeather() {
  const rows = await query('SELECT weather FROM weather_state WHERE id = 1');
  if (rows.length === 0) {
    return 'CLEAR';
  }
  return rows[0].weather;
}

export async function setWeather(weather) {
  await query(
    `INSERT INTO weather_state (id, weather)
     VALUES (1, ?)
     ON DUPLICATE KEY UPDATE weather = VALUES(weather)`,
    [weather]
  );
}

export async function listZones() {
  return query('SELECT id, name, data FROM world_zones ORDER BY id');
}

export async function createZone(name, data) {
  const res = await query(
    `INSERT INTO world_zones (name, data) VALUES (?, ?)`,
    [name, JSON.stringify(data)]
  );
  return res.insertId;
}

export async function deleteZone(id) {
  await query(`DELETE FROM world_zones WHERE id = ?`, [id]);
}

export async function listBarriers() {
  return query('SELECT id, zone_id AS zoneId, data FROM world_barriers ORDER BY id');
}

export async function createBarrier(zoneId, data) {
  const res = await query(
    `INSERT INTO world_barriers (zone_id, data) VALUES (?, ?)`,
    [zoneId, JSON.stringify(data)]
  );
  return res.insertId;
}

export async function deleteBarrier(id) {
  await query(`DELETE FROM world_barriers WHERE id = ?`, [id]);
}
export async function saveCoords(characterId, x, y, z, heading) {
  await query(
    `INSERT INTO character_coords (character_id, x, y, z, heading)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE x = VALUES(x), y = VALUES(y), z = VALUES(z), heading = VALUES(heading)`,
    [characterId, x, y, z, heading]
  );
}

export async function getCoords(characterId) {
  const rows = await query(
    `SELECT x, y, z, heading FROM character_coords WHERE character_id = ?`,
    [characterId]
  );
  return rows[0] || null;
}

export async function saveEntityCoords(entityId, x, y, z, heading) {
  await query(
    `INSERT INTO infinity_entities (entity_id, x, y, z, heading)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE x = VALUES(x), y = VALUES(y), z = VALUES(z), heading = VALUES(heading)`,
    [entityId, x, y, z, heading]
  );
}

export async function getEntityCoords(entityId) {
  const rows = await query(
    `SELECT x, y, z, heading FROM infinity_entities WHERE entity_id = ?`,
    [entityId]
  );
  return rows[0] || null;
}

export async function purgeStaleEntities(thresholdMs) {
  const seconds = Math.floor(thresholdMs / 1000);
  await query(
    `DELETE FROM infinity_entities WHERE updated_at < (NOW() - INTERVAL ? SECOND)`,
    [seconds]
  );
}
