import * as repo from '../repositories/config.repo.js';

function isObject(o) { return typeof o === 'object' && o !== null && !Array.isArray(o); }

export async function getLive() {
    const cfg = await repo.getLiveConfig();
    return cfg || {};
}

export async function patchLive(patch) {
    if (!isObject(patch)) throw new Error('Invalid payload');
    const merged = await repo.patchLiveConfig(patch);
    return merged;
}

export async function setFeatureFlag(name, enabled) {
    if (!name || typeof name !== 'string') throw new Error('name required');
    return repo.setFlag(name, !!enabled);
}

export async function listFeatureFlags() {
    return repo.listFlags();
}

export default { getLive, patchLive, setFeatureFlag, listFeatureFlags };