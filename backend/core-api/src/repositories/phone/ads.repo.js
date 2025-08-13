import { db } from './db.js';
export async function create(row) { const [id] = await db('ads').insert(row).returning('id'); return typeof id === 'object' ? id.id : id; }
export async function list({ active = true, limit = 50 } = {}) {
    let qb = db('ads').where({ approved: true });
    if (active != null) qb = qb.andWhere({ active: !!active });
    return await qb.orderBy('id', 'desc').limit(Math.min(limit, 200));
}
export async function byChar(char_id, limit = 100) {
    return await db('ads').where({ char_id: Number(char_id) }).orderBy('id', 'desc').limit(Math.min(limit, 300));
}
export async function setActive(id, active) { await db('ads').where({ id: Number(id) }).update({ active: !!active }); }