import { db } from './db.js';

export async function bySlug(slug) { return await db('businesses').where({ slug }).first(); }
export async function get(id) { return await db('businesses').where({ id: Number(id) }).first(); }
export async function update(id, patch) { await db('businesses').where({ id: Number(id) }).update({ ...patch, updated_at: db.fn.now() }); return await get(id); }
export async function create(row) { const [id] = await db('businesses').insert(row).returning('id'); return typeof id === 'object' ? id.id : id; }
export async function list(q = {}) {
    let qb = db('businesses').orderBy('id', 'asc');
    if (q.type) qb = qb.where({ type: q.type });
    if (q.open != null) qb = qb.where({ open: q.open === 'true' || q.open === true });
    return await qb.limit(200);
}