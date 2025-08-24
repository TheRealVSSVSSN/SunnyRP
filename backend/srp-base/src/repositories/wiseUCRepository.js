const db = require('./db');

async function upsertProfile({ characterId, alias, active }) {
  const ts = Date.now();
  await db.query(
    `INSERT INTO wise_uc_profiles (character_id, alias, active, created_at, updated_at)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE alias = VALUES(alias), active = VALUES(active), updated_at = VALUES(updated_at)`,
    [characterId, alias, active ? 1 : 0, ts, ts],
  );
  return getProfileByCharacter(characterId);
}

async function getProfileByCharacter(characterId) {
  const rows = await db.query(
    'SELECT character_id AS characterId, alias, active, created_at AS createdAt, updated_at AS updatedAt FROM wise_uc_profiles WHERE character_id = ?',
    [characterId],
  );
  return rows[0];
}

module.exports = { upsertProfile, getProfileByCharacter };
