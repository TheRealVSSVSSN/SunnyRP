import { db } from './db.js';
export async function grant(property_id, char_id, access_type = 'key', expires_at = null) {
    try {
        const [id] = await db('property_access')
            .insert({ property_id: Number(property_id), char_id: Number(char_id), access_type, expires_at })
            .returning('id');
        return typeof id === 'object' ? id.id : id;
    } catch { return null; }
}
export async function revoke(property_id, char_id) {
    await db('property_access').where({ property_id: Number(property_id), char_id: Number(char_id) }).delete();
}
export async function list(property_id) {
    return await db('property_access').where({ property_id: Number(property_id) }).orderBy('id', 'asc');
}
export async function hasAccess(property_id, char_id) {
    const p = await db('properties').where({ id: Number(property_id) }).first();
    if (p?.owner_char_id === Number(char_id)) return true;
    const a = await db('property_access').where({ property_id: Number(property_id), char_id: Number(char_id) }).first();
    if (!a) return false;
    if (a.expires_at && new Date(a.expires_at) < new Date()) return false;
    return true;
}