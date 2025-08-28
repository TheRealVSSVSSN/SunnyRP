const db = require('./db');

async function listByCharacter(characterId) {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, name, breed, active, created_at AS createdAt FROM k9_units WHERE character_id = ? AND retired_at IS NULL',
    [characterId],
  );
  return rows;
}

async function listActive() {
  const [rows] = await db.query(
    'SELECT id, character_id AS characterId, name, breed, active, created_at AS createdAt FROM k9_units WHERE active = 1 AND retired_at IS NULL',
  );
  return rows;
}

async function createK9({ characterId, name, breed }) {
  const [result] = await db.query(
    'INSERT INTO k9_units (character_id, name, breed) VALUES (?, ?, ?)',
    [characterId, name, breed],
  );
  return {
    id: result.insertId,
    characterId,
    name,
    breed,
    active: 0,
  };
}

async function setActive(characterId, k9Id, active) {
  const [result] = await db.query(
    'UPDATE k9_units SET active = ? WHERE id = ? AND character_id = ? AND retired_at IS NULL',
    [active ? 1 : 0, k9Id, characterId],
  );
  return result.affectedRows;
}

async function retireK9(characterId, k9Id) {
  const [result] = await db.query(
    'UPDATE k9_units SET retired_at = CURRENT_TIMESTAMP, active = 0 WHERE id = ? AND character_id = ? AND retired_at IS NULL',
    [k9Id, characterId],
  );
  return result.affectedRows;
}

module.exports = {
  listByCharacter,
  listActive,
  createK9,
  setActive,
  retireK9,
};
