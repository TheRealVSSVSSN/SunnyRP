const db = require('./db');

async function createTrack({ characterId, label, url }) {
  const createdAt = Date.now();
  const result = await db.query(
    'INSERT INTO wise_audio_tracks (character_id, label, url, created_at) VALUES (?, ?, ?, ?)',
    [characterId, label, url, createdAt],
  );
  return { id: result.insertId, characterId, label, url, createdAt };
}

async function listTracksByCharacter(characterId, limit = 50) {
  const rows = await db.query(
    'SELECT id, character_id AS characterId, label, url, created_at AS createdAt FROM wise_audio_tracks WHERE character_id = ? ORDER BY created_at DESC LIMIT ?',
    [characterId, limit],
  );
  return rows;
}

module.exports = { createTrack, listTracksByCharacter };
