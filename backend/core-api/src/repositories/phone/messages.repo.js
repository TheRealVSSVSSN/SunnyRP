import { db } from './db.js';

export async function create(row) {
    if (row.idempotency_key) {
        const ex = await db('messages').where({ idempotency_key: row.idempotency_key }).first();
        if (ex) return ex.id;
    }
    const [id] = await db('messages').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function inbox(number, sinceId = null, limit = 100) {
    let qb = db('messages').where({ to_number: String(number) }).orderBy('id', 'desc').limit(Math.min(limit, 500));
    if (sinceId) qb = qb.andWhere('id', '>', Number(sinceId));
    return await qb;
}
export async function thread(a, b, limit = 200) {
    return await db('messages')
        .where(function () {
            this.where({ from_number: String(a), to_number: String(b) }).orWhere({ from_number: String(b), to_number: String(a) })
        })
        .orderBy('id', 'asc').limit(Math.min(limit, 1000));
}
export async function markDelivered(ids) {
    if (!ids?.length) return;
    await db('messages').whereIn('id', ids).update({ status: 'delivered' });
}