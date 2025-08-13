import { db } from './db.js';
export async function start(property_id, char_id, rent_cents, period = 'weekly') {
    const [id] = await db('leases')
        .insert({ property_id: Number(property_id), char_id: Number(char_id), rent_cents: Number(rent_cents), period })
        .onConflict(['property_id', 'char_id']).ignore()
        .returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function stop(property_id, char_id) {
    await db('leases').where({ property_id: Number(property_id), char_id: Number(char_id) }).update({ active: false });
}
export async function current(property_id, char_id) {
    return await db('leases').where({ property_id: Number(property_id), char_id: Number(char_id), active: true }).first();
}