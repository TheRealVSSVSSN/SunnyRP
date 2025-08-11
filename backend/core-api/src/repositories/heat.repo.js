import { db } from './db.js';

export async function get(char_id, area = 'city') {
    return await db('heat').where({ char_id: Number(char_id), area: String(area) }).first();
}
export async function upsert(char_id, area, value) {
    const cur = await get(char_id, area);
    if (!cur) {
        await db('heat').insert({ char_id: Number(char_id), area: String(area), value: Number(value) });
    } else {
        await db('heat').where({ id: cur.id }).update({ value: Number(value), updated_at: db.fn.now() });
    }
    return await get(char_id, area);
}
export async function log(char_id, area, delta, reason, position) {
    await db('heat_log').insert({
        char_id: Number(char_id), area: String(area), delta: Number(delta),
        reason: String(reason || 'unknown'),
        position: position ? JSON.stringify(position) : null
    });
}