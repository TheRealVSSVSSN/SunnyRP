// Updated: 2024-11-28
/**
 * In-memory repository for accounts and characters.
 */
const accounts = new Map();
let nextId = 1;

export async function listCharacters(accountId) {
  return accounts.get(accountId) || [];
}

export async function createCharacter(accountId, data) {
  const chars = accounts.get(accountId) || [];
  const character = { id: nextId++, firstName: data.firstName, lastName: data.lastName };
  chars.push(character);
  accounts.set(accountId, chars);
  return character;
}

export async function selectCharacter(accountId, characterId) {
  const chars = accounts.get(accountId) || [];
  return chars.find((c) => c.id === characterId) || null;
}

export async function deleteCharacter(accountId, characterId) {
  const chars = accounts.get(accountId) || [];
  const idx = chars.findIndex((c) => c.id === characterId);
  if (idx !== -1) {
    chars.splice(idx, 1);
    accounts.set(accountId, chars);
    return true;
  }
  return false;
}
