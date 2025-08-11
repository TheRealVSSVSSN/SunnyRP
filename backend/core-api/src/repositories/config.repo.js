import knex from './db.js';

const KEY = 'base';

export async function getLiveConfig() {
    const row = await knex('config_live').where({ key: KEY }).first();
    return row ? row.value : null;
}

export async function patchLiveConfig(partial) {
    await knex('config_live')
        .insert({ key: KEY, value: partial })
        .onConflict('key')
        .merge({
            value: knex.raw('JSON_MERGE_PATCH(value, ?)', [JSON.stringify(partial)]),
            updated_at: knex.fn.now()
        });
    return getLiveConfig();
}

export async function listFlags() {
    return knex('feature_flags').select('name', 'enabled', 'updated_at');
}

export async function setFlag(name, enabled) {
    await knex('feature_flags')
        .insert({ name, enabled: !!enabled })
        .onConflict('name')
        .merge({ enabled: !!enabled, updated_at: knex.fn.now() });
    return { name, enabled: !!enabled };
}

export default { getLiveConfig, patchLiveConfig, listFlags, setFlag };