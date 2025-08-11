import { db } from './db.js';

export async function listForChar(charId) {
    // Owned or access list (keys/leases) or for sale/rent (public)
    const owned = db('properties').where({ owner_char_id: Number(charId) });
    const access = db('properties as p')
        .join('property_access as a', 'a.property_id', 'p.id')
        .where('a.char_id', Number(charId))
        .select('p.*');
    const union = db.union([owned, access], true).orderBy('id', 'asc');
    return await union;
}
export async function get(id) { return await db('properties').where({ id: Number(id) }).first(); }
export async function bySlug(slug) { return await db('properties').where({ slug }).first(); }
export async function create(row) {
    const [id] = await db('properties').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function update(id, patch) {
    await db('properties').where({ id: Number(id) }).update({ ...patch, updated_at: db.fn.now() });
    return await get(id);
}