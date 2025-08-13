import { db } from './db.js';
export async function push(kind, severity, message, meta = null) {
    const [id] = await db('alerts').insert({ kind: String(kind), severity: Number(severity), message: String(message), meta: meta ? JSON.stringify(meta) : null }).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function list({ sinceId = null, limit = 100, includeAck = false } = {}) {
    let qb = db('alerts'); if (!includeAck) qb = qb.where({ ack: false });
    if (sinceId) qb = qb.andWhere('id', '>', Number(sinceId));
    return await qb.orderBy('id', 'asc').limit(Math.min(limit, 500));
}
export async function ack(id) { await db('alerts').where({ id: Number(id) }).update({ ack: true }); }