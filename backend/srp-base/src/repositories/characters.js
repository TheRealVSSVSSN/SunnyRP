import { query } from '../db/index.js';

export async function getCharacters(accountId) {
  return query(
    'SELECT id, first_name AS firstName, last_name AS lastName, created_at AS createdAt FROM characters WHERE account_id = ? AND deleted_at IS NULL',
    [accountId]
  );
}

export async function createCharacter(accountId, { firstName, lastName }) {
  const result = await query(
    'INSERT INTO characters (account_id, first_name, last_name) VALUES (?, ?, ?)',
    [accountId, firstName, lastName]
  );
  return { id: result.insertId };
}

export async function selectCharacter(accountId, characterId) {
  await query(
    'REPLACE INTO account_selected_character (account_id, character_id) VALUES (?, ?)',
    [accountId, characterId]
  );
}

export async function deleteCharacter(accountId, characterId) {
  await query(
    'UPDATE characters SET deleted_at = NOW() WHERE id = ? AND account_id = ? AND deleted_at IS NULL',
    [characterId, accountId]
  );
}

export async function ownsCharacter(accountId, characterId) {
  const rows = await query(
    'SELECT 1 FROM characters WHERE id = ? AND account_id = ? AND deleted_at IS NULL',
    [characterId, accountId]
  );
  return rows.length > 0;
}
