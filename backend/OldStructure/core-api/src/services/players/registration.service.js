import * as repo from '../repositories/registration.repo.js';

function isObject(o) { return typeof o === 'object' && o !== null && !Array.isArray(o); }

export async function getStatus(playerId) {
    if (!playerId) throw new Error('playerId required');
    const row = await repo.getStatus(playerId);
    if (!row) throw new Error('not_found');
    return row;
}

export async function update(playerId, patch) {
    if (!playerId) throw new Error('playerId required');
    if (!isObject(patch)) throw new Error('invalid_patch');
    const row = await repo.updateVerification(playerId, patch);
    if (!row) throw new Error('not_found');
    return row;
}

export default { getStatus, update };