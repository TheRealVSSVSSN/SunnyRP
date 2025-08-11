import { db } from './db.js';
export async function grant(business_id, char_id, role = 'cashier') {
    const [id] = await db('business_employees').insert({ business_id: Number(business_id), char_id: Number(char_id), role }).onConflict(['business_id', 'char_id']).ignore().returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function setRole(business_id, char_id, role) {
    await db('business_employees').where({ business_id: Number(business_id), char_id: Number(char_id) }).update({ role: String(role) });
}
export async function revoke(business_id, char_id) {
    await db('business_employees').where({ business_id: Number(business_id), char_id: Number(char_id) }).delete();
}
export async function list(business_id) {
    return await db('business_employees').where({ business_id: Number(business_id), active: true }).orderBy('role', 'asc');
}
export async function hasRole(business_id, char_id, roles) {
    const r = await db('business_employees').where({ business_id: Number(business_id), char_id: Number(char_id) }).first();
    if (!r) return false;
    return Array.isArray(roles) ? roles.includes(r.role) : r.role === roles;
}