import { db } from './db.js';
export async function record(row) {
    // de-dupe by idempotency key
    if (row.idempotency_key) {
        const existing = await db('transactions').where({ idempotency_key: row.idempotency_key }).first();
        if (existing) return existing.id;
    }
    const [id] = await db('transactions').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function listForBusiness(business_id, limit = 100) {
    return await db('transactions').where({ business_id: Number(business_id) }).orderBy('id', 'desc').limit(Math.min(limit, 500));
}