import * as repo from '../repositories/keybinds.repo.js';

export async function list(playerId, charId) {
    if (!playerId) throw new Error('playerId required');
    return repo.getBinds(playerId, charId);
}

export async function save(playerId, charId, binds) {
    if (!playerId) throw new Error('playerId required');
    if (!Array.isArray(binds)) throw new Error('binds must be an array');
    await repo.upsertMany(playerId, charId, binds);
    return { saved: binds.length };
}

export default { list, save };