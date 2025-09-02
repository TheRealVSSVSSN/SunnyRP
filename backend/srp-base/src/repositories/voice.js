import { query } from '../db/index.js';

export async function listChannel(channelId) {
  return query(
    `SELECT character_id AS characterId, joined_at AS joinedAt
     FROM voice_channels
     WHERE channel_id = ?
     ORDER BY joined_at ASC`,
    [channelId]
  );
}

export async function joinChannel(channelId, characterId) {
  await query(
    `INSERT INTO voice_channels (channel_id, character_id)
     VALUES (?, ?)
     ON DUPLICATE KEY UPDATE joined_at = CURRENT_TIMESTAMP`,
    [channelId, characterId]
  );
}

export async function leaveChannel(channelId, characterId) {
  await query(
    `DELETE FROM voice_channels
     WHERE channel_id = ? AND character_id = ?`,
    [channelId, characterId]
  );
}

export async function purgeStaleChannels(thresholdMs) {
  const seconds = Math.floor(thresholdMs / 1000);
  await query(
    `DELETE FROM voice_channels
     WHERE joined_at < (NOW() - INTERVAL ? SECOND)`,
    [seconds]
  );
}

export async function listBroadcast() {
  return query(
    `SELECT character_id AS characterId, updated_at AS updatedAt
     FROM voice_broadcast
     WHERE active = 1
     ORDER BY updated_at ASC`
  );
}

export async function setBroadcast(characterId, active, limit = 5) {
  if (active) {
    const rows = await query(
      `SELECT COUNT(*) AS cnt FROM voice_broadcast WHERE active = 1`
    );
    if (rows[0].cnt >= limit) throw new Error('Broadcast limit reached');
  }
  await query(
    `INSERT INTO voice_broadcast (character_id, active)
     VALUES (?, ?)
     ON DUPLICATE KEY UPDATE active = VALUES(active), updated_at = CURRENT_TIMESTAMP`,
    [characterId, active ? 1 : 0]
  );
}

export async function getBroadcast(characterId) {
  const rows = await query(
    `SELECT active FROM voice_broadcast WHERE character_id = ?`,
    [characterId]
  );
  return rows.length ? Boolean(rows[0].active) : false;
}
