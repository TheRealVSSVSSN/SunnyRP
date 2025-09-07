/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

class BaseRepository {
  constructor() {
    this.accounts = new Map();
  }

  listCharacters(accountId) {
    const acc = this.accounts.get(accountId);
    return acc ? acc.characters : [];
  }

  createCharacter(accountId, data) {
    const acc = this.accounts.get(accountId) || { characters: [], seq: 1, selected: null };
    const id = String(acc.seq++);
    const character = { id, firstName: data.firstName, lastName: data.lastName };
    acc.characters.push(character);
    this.accounts.set(accountId, acc);
    return character;
  }

  selectCharacter(accountId, characterId) {
    const acc = this.accounts.get(accountId);
    if (!acc) return null;
    const char = acc.characters.find(c => c.id === characterId);
    if (!char) return null;
    acc.selected = characterId;
    return char;
  }

  deleteCharacter(accountId, characterId) {
    const acc = this.accounts.get(accountId);
    if (!acc) return false;
    const idx = acc.characters.findIndex(c => c.id === characterId);
    if (idx === -1) return false;
    acc.characters.splice(idx, 1);
    if (acc.selected === characterId) acc.selected = null;
    return true;
  }
}

module.exports = new BaseRepository();
