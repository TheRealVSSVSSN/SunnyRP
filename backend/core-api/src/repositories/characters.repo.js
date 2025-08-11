import { db } from './db.js';

export async function countByUser(userId) {
    const row = await db('characters').where({ user_id: userId }).andWhere('deleted_at', null).count({ c: 'id' }).first();
    return Number(row?.c || 0);
}

export async function listByUser(userId) {
    const chars = await db('characters').where({ user_id: userId }).andWhere('deleted_at', null).orderBy('slot', 'asc');
    const states = await db('character_state').whereIn('character_id', chars.map(c => c.id));
    const byCid = Object.fromEntries(states.map(s => [s.character_id, s]));
    return chars.map(c => ({ ...c, state: byCid[c.id] || null }));
}

export async function nextFreeSlot(userId) {
    const rows = await db('characters').select('slot').where({ user_id: userId }).andWhere('deleted_at', null);
    const used = new Set(rows.map(r => r.slot));
    let s = 1; while (used.has(s)) s++; return s;
}

export async function createCharacter({ user_id, slot, first_name, last_name, dob, gender }) {
    const [id] = await db('characters').insert({ user_id, slot, first_name, last_name, dob, gender }).returning('id');
    const cid = typeof id === 'object' ? id.id : id;
    await db('character_state').insert({ character_id: cid, position: null, routing_bucket: 0, last_played_at: null });
    return cid;
}

export async function characterBelongsTo(userId, charId) {
    const c = await db('characters').where({ id: charId, user_id: userId }).andWhere('deleted_at', null).first();
    return !!c;
}

export async function softDeleteCharacter(userId, charId) {
    await db('characters').where({ id: charId, user_id: userId }).update({ deleted_at: db.fn.now() });
}

export async function getCharacterState(charId) {
    const c = await db('characters').where({ id: charId }).first();
    const s = await db('character_state').where({ character_id: charId }).first();
    return { character: c, state: s };
}

export async function setCharacterState(charId, { position = null, routing_bucket = 0, touch = false }) {
    const patch = {};
    if (position !== undefined) patch.position = JSON.stringify(position);
    if (routing_bucket !== undefined) patch.routing_bucket = routing_bucket;
    if (touch) patch.last_played_at = db.fn.now();
    await db('character_state').where({ character_id: charId }).update(patch);
}