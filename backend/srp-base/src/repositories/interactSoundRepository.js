const db = require('./db');

async function recordPlay({ characterId, sound, volume, playedAt }) {
  const ts = playedAt || Date.now();
  await db.query(
    'INSERT INTO interact_sound_plays (character_id, sound, volume, played_at) VALUES (?, ?, ?, ?)',
    [characterId, sound, volume, ts],
  );
  return { characterId, sound, volume, playedAt: ts };
}

async function listPlaysByCharacter(characterId, limit = 50) {
  const [rows] = await db.query(
    'SELECT sound, volume, played_at AS playedAt FROM interact_sound_plays WHERE character_id = ? ORDER BY played_at DESC LIMIT ?'
    , [characterId, limit],
  );
  return rows;
}

module.exports = { recordPlay, listPlaysByCharacter };
