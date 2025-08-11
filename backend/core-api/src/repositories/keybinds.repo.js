import knex from './db.js';

export async function getBinds(playerId, charId) {
    const q = knex('keybinds').where({ player_id: playerId });
    if (charId) q.andWhere({ character_id: charId });
    const rows = await q.select('*');
    return rows.map(r => ({
        name: r.name, device: r.device, key: r.key,
        desc: (r.meta && r.meta.desc) || null, meta: r.meta || null,
    }));
}

export async function upsertMany(playerId, charId, binds = []) {
    const trx = await knex.transaction();
    try {
        for (const b of binds) {
            await trx('keybinds')
                .insert({
                    player_id: playerId,
                    character_id: charId || null,
                    name: b.name, device: b.device || 'keyboard', key: b.key || 'NONE',
                    meta: b.meta || null,
                    updated_at: trx.fn.now()
                })
                .onConflict(['player_id', 'character_id', 'name'])
                .merge({ device: b.device || 'keyboard', key: b.key || 'NONE', meta: b.meta || null, updated_at: trx.fn.now() });
        }
        await trx.commit();
    } catch (e) {
        await trx.rollback();
        throw e;
    }
}