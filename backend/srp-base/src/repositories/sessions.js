import crypto from 'crypto';
import { query } from '../db/index.js';

export async function listWhitelist(limit = 1000) {
  return query(
    `SELECT account_id AS accountId, power
     FROM users_whitelist
     ORDER BY power DESC, account_id ASC
     LIMIT ?`,
    [limit]
  );
}

export async function addWhitelist(accountId, power = 0) {
  await query(
    `INSERT INTO users_whitelist (account_id, power)
     VALUES (?, ?)
     ON DUPLICATE KEY UPDATE power = VALUES(power)`,
    [accountId, power]
  );
}

export async function removeWhitelist(accountId) {
  await query(
    `DELETE FROM users_whitelist WHERE account_id = ?`,
    [accountId]
  );
}

export async function getHardCap() {
  const rows = await query(
    `SELECT max_players AS maxPlayers FROM session_limits WHERE id = 1`
  );
  if (rows.length === 0) {
    return Number(process.env.SESSION_HARD_CAP || 32);
  }
  return rows[0].maxPlayers;
}

export async function setHardCap(maxPlayers) {
  await query(
    `INSERT INTO session_limits (id, max_players)
     VALUES (1, ?)
     ON DUPLICATE KEY UPDATE max_players = VALUES(max_players)`,
    [maxPlayers]
  );
}

export async function verifyLoginPassword(password) {
  const rows = await query(`SELECT password_hash FROM session_password WHERE id = 1`);
  if (rows.length === 0) return false;
  const hash = crypto.createHash('sha256').update(password).digest('hex');
  return rows[0].password_hash === hash;
}

export async function setLoginPassword(password) {
  const hash = crypto.createHash('sha256').update(password).digest('hex');
  await query(
    `INSERT INTO session_password (id, password_hash)
     VALUES (1, ?)
     ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash)`,
    [hash]
  );
}

export async function getCID(characterId) {
  const rows = await query(
    `SELECT cid FROM character_cids WHERE character_id = ?`,
    [characterId]
  );
  return rows.length ? rows[0].cid : null;
}

export async function assignCID(characterId) {
  await query(
    `INSERT INTO character_cids (character_id)
     VALUES (?)
     ON DUPLICATE KEY UPDATE character_id = VALUES(character_id)`,
    [characterId]
  );
  const rows = await query(
    `SELECT cid FROM character_cids WHERE character_id = ?`,
    [characterId]
  );
  return rows[0].cid;
}

export async function isHospitalized(characterId) {
  const rows = await query(
    `SELECT admitted_at FROM hospitalizations WHERE character_id = ?`,
    [characterId]
  );
  return rows.length > 0;
}

export async function hospitalize(characterId) {
  await query(
    `INSERT INTO hospitalizations (character_id)
     VALUES (?)
     ON DUPLICATE KEY UPDATE admitted_at = admitted_at`,
    [characterId]
  );
}

export async function discharge(characterId) {
  await query(
    `DELETE FROM hospitalizations WHERE character_id = ?`,
    [characterId]
  );
}
export async function recordSpawn(characterId, x, y, z, heading) {
  await query(
    `INSERT INTO character_spawns (character_id, x, y, z, heading)
     VALUES (?, ?, ?, ?, ?)`,
    [characterId, x, y, z, heading]
  );
}
