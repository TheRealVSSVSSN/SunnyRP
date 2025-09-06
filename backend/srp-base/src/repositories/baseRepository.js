class BaseRepository {
  constructor() {
    this.accounts = new Map();
    this.seq = 1;
  }

  listCharacters(accountId) {
    const acc = this.accounts.get(accountId);
    if (!acc) return [];
    return Array.from(acc.characters.values());
  }

  createCharacter(accountId, data) {
    const id = String(this.seq++);
    const acc = this.accounts.get(accountId) || { characters: new Map(), selected: null };
    const character = { id, name: data.name };
    acc.characters.set(id, character);
    this.accounts.set(accountId, acc);
    return character;
  }

  deleteCharacter(accountId, characterId) {
    const acc = this.accounts.get(accountId);
    if (!acc) return false;
    const existed = acc.characters.delete(characterId);
    if (acc.selected === characterId) acc.selected = null;
    return existed;
  }

  selectCharacter(accountId, characterId) {
    const acc = this.accounts.get(accountId);
    if (!acc) throw new Error('account_not_found');
    const char = acc.characters.get(characterId);
    if (!char) throw new Error('character_not_found');
    acc.selected = characterId;
    return char;
  }
}

module.exports = new BaseRepository();
