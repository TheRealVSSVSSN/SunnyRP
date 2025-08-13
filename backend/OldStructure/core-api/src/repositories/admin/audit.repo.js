import { db } from './db.js';

export async function writeAudit({ actor_type = 'system', actor_id = null, action, user_id = null, meta = null }) {
    await db('audit').insert({ actor_type, actor_id, action, user_id, meta: meta ? JSON.stringify(meta) : null });
}

export async function fetchAudit({ userId = null, limit = 50 }) {
    let q = db('audit').select('*').orderBy('id', 'desc').limit(limit);
    if (userId) q = q.where('user_id', userId);
    return q;
}