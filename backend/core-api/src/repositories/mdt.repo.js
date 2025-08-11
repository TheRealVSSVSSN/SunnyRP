import { db } from './db.js';

export async function createReport(row) {
    const [id] = await db('reports').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function updateReport(id, patch) {
    await db('reports').where({ id }).update({ ...patch, updated_at: db.fn.now() });
}
export async function getReport(id) {
    const r = await db('reports').where({ id }).first();
    if (!r) return null;
    const evidence = await db('evidence').where({ report_id: id }).orderBy('id', 'asc');
    return { ...r, evidence };
}
export async function removeReport(id) {
    await db('reports').where({ id }).delete();
}
export async function listReports(q = {}) {
    let qb = db('reports').orderBy('id', 'desc');
    if (q.type) qb = qb.where({ type: q.type });
    if (q.author_char_id) qb = qb.where({ author_char_id: Number(q.author_char_id) });
    if (q.q) qb = qb.whereILike('title', `%${q.q}%`);
    return await qb.limit(Math.min(Number(q.limit || 50), 200)).offset(Number(q.offset || 0));
}