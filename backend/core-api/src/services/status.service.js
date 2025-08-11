import { getStatus, upsertStatus, patchStatus } from '../repositories/status.repo.js';

export async function ensureStatus(characterId) {
    const r = await getStatus(characterId);
    return r || upsertStatus(characterId, {});
}

export async function fetchStatus(characterId) {
    return await ensureStatus(characterId);
}

export async function applyStatusPatch(characterId, body) {
    return await patchStatus(characterId, {
        values: body.values || {},
        deltas: body.deltas || {}
    });
}