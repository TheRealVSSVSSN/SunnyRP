const repo = require('../repositories/config.repo');

async function getLive() {
    const cfg = await repo.getLiveConfig();
    return cfg || {};
}

async function patchLive(patch) {
    // minimal validation – real app should zod/joi this
    if (typeof patch !== 'object' || !patch) throw new Error('Invalid payload');
    const merged = await repo.patchLiveConfig(patch);
    return merged;
}

async function setFeatureFlag(name, enabled) {
    return repo.setFlag(name, !!enabled);
}

async function listFeatureFlags() {
    return repo.listFlags();
}

module.exports = {
    getLive,
    patchLive,
    setFeatureFlag,
    listFeatureFlags,
};