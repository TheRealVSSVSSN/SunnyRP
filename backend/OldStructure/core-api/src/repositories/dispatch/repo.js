import { db } from './db.js';

export async function createCall(row) {
    const [id] = await db('dispatch_calls').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function getCall(id) {
    const c = await db('dispatch_calls').where({ id }).first();
    if (!c) return null;
    const units = await db('dispatch_units').where({ call_id: id });
    return { ...c, units };
}
export async function attachUnit(callId, unit) {
    try {
        const [id] = await db('dispatch_units').insert({ call_id: callId, ...unit }).returning('id');
        return typeof id === 'object' ? id.id : id;
    } catch {
        return null; // already attached or constraint fail
    }
}
export async function updateUnit(callId, charId, patch) {
    await db('dispatch_units').where({ call_id: callId, unit_char_id: charId }).update(patch);
}
export async function setStatus(callId, status) {
    await db('dispatch_calls').where({ id: callId }).update({ status, updated_at: db.fn.now() });
}
export async function listOpen(kind) {
    let q = db('dispatch_calls').whereIn('status', ['open', 'active']).orderBy('id', 'desc');
    if (kind) q = q.where({ kind });
    return await q.limit(100);
}