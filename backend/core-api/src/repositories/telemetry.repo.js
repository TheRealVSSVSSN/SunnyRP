import { db } from './db.js';
export async function insert(row) {
    const [id] = await db('telemetry_events').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function recent(type, limit = 200) {
    let qb = db('telemetry_events'); if (type) qb = qb.where({ type: String(type) });
    return await qb.orderBy('id', 'desc').limit(Math.min(limit, 1000));
}