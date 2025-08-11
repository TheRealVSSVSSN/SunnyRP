const knex = require('./db'); // your project exports knex instance here

const KEY = 'base';

async function getLiveConfig() {
    const row = await knex('config_live').where({ key: KEY }).first();
    return row ? row.value : null;
}

/**
 * Deep-merge (JSON_MERGE_PATCH) updates into stored JSON.
 * MySQL 8+ required for JSON functions.
 */
async function patchLiveConfig(partial) {
    await knex('config_live')
        .insert({ key: KEY, value: partial })
        .onConflict('key')
        .merge({
            value: knex.raw('JSON_MERGE_PATCH(value, ?)', [JSON.stringify(partial)]),
            updated_at: knex.fn.now()
        });
    return getLiveConfig();
}

async function listFlags() {
    const rows = await knex('feature_flags').select('name', 'enabled', 'updated_at');
    return rows;
}

async function setFlag(name, enabled) {
    await knex('feature_flags')
        .insert({ name, enabled: !!enabled })
        .onConflict('name')
        .merge({ enabled: !!enabled, updated_at: knex.fn.now() });
    return { name, enabled: !!enabled };
}

module.exports = {
    getLiveConfig,
    patchLiveConfig,
    listFlags,
    setFlag,
};