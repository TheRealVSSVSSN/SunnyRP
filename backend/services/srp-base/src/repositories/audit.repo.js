// src/repositories/audit.repo.js
import { pool } from './db.js';

export async function recordAudit(actorUserId, targetUserId, action, meta = null) {
    await pool.query(
        `INSERT INTO audit (actor_user_id, target_user_id, action, meta)
     VALUES (?, ?, ?, ?)`,
        [actorUserId || null, targetUserId || null, action, meta ? JSON.stringify(meta) : null]
    );
}

export async function readAudit({ userId = null, limit = 50 }) {
    const args = [];
    let where = '';
    if (userId) {
        where = 'WHERE actor_user_id = ? OR target_user_id = ?';
        args.push(userId, userId);
    }
    const [rows] = await pool.query(
        `SELECT id, actor_user_id, target_user_id, action, meta, created_at
     FROM audit ${where}
     ORDER BY id DESC
     LIMIT ?`,
        [...args, Math.min(Math.max(limit, 1), 200)]
    );
    return rows.map(r => ({
        id: r.id,
        actor_user_id: r.actor_user_id,
        target_user_id: r.target_user_id,
        action: r.action,
        meta: r.meta ? JSON.parse(r.meta) : null,
        created_at: r.created_at
    }));
}