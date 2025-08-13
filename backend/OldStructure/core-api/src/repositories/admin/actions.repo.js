import { db } from './db.js';

export async function createAttempt(row) {
    const data = {
        actor_user_id: row.actor_user_id,
        actor_char_id: row.actor_char_id || null,
        action: row.action,
        target_src: row.target_src ? String(row.target_src) : null,
        target_user_id: row.target_user_id || null,
        target_char_id: row.target_char_id || null,
        params: row.params ? JSON.stringify(row.params) : null,
        status: row.status || 'attempt',
        scope_used: row.scope_used || null,
    };
    const [id] = await db('admin_actions').insert(data).returning('id');
    return typeof id === 'object' ? id.id : id;
}

export async function updateResult(id, patch) {
    const data = {
        status: patch.status || 'success',
        result_code: patch.result_code || null,
        result_message: patch.result_message || null,
        updated_at: db.fn.now(),
    };
    await db('admin_actions').where({ id }).update(data);
}

export async function list(filters = {}, limit = 200, offset = 0) {
    let q = db('admin_actions').orderBy('id', 'desc');
    if (filters.action) q = q.where({ action: filters.action });
    if (filters.actor_user_id) q = q.where({ actor_user_id: Number(filters.actor_user_id) });
    if (filters.target_user_id) q = q.where({ target_user_id: Number(filters.target_user_id) });
    return await q.limit(limit).offset(offset);
}