import { query } from '../db/index.js';

export async function listPlayers({ sort = 'displayName' } = {}) {
  const column = sort === 'ping' ? 'ping' : 'display_name';
  return query(
    `SELECT character_id AS characterId, account_id AS accountId, display_name AS displayName, job, ping, updated_at AS updatedAt
     FROM scoreboard_players ORDER BY ${column} ASC`
  );
}

export async function upsertPlayer({ characterId, accountId, displayName, job = '', ping }) {
  await query(
    `INSERT INTO scoreboard_players (character_id, account_id, display_name, job, ping)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE display_name = VALUES(display_name), job = VALUES(job), ping = VALUES(ping), updated_at = CURRENT_TIMESTAMP`,
    [characterId, accountId, displayName, job, ping]
  );
}

export async function removePlayer(characterId) {
  await query(
    `DELETE FROM scoreboard_players WHERE character_id = ?`,
    [characterId]
  );
}

export async function purgeStalePlayers(thresholdMs) {
  const seconds = Math.floor(thresholdMs / 1000);
  await query(
    `DELETE FROM scoreboard_players WHERE updated_at < (NOW() - INTERVAL ? SECOND)`,
    [seconds]
  );
}

export async function countPlayers() {
  const rows = await query('SELECT COUNT(*) AS count FROM scoreboard_players');
  return rows[0]?.count || 0;
}
