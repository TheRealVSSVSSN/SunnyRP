// src/repositories/audit.repo.js
import { pool } from './db.js';

export async function recordAudit(actorUserId, targetUserId, action, meta = null) {
    await pool.query(
        `INSERT INTO audit (actor_user_id, target_user_id, action, meta)
        VALUES (?, ?, ?, ?)`,
        [actorUserId || null, targetUserId || null, action, meta ? JSON.stringify(meta) : null]
    );
}

/**
 * Read audit with optional filters.
 * filters: { userId?: number, limit?: number, action?: string, after?: string(ISO), before?: string(ISO) }
 */
export async function readAudit({ userId = null, limit = 50, action = null, after = null, before = null }) {
    const args = [];
    const clauses = [];

    if (userId) {
        clauses.push('(actor_user_id = ? OR target_user_id = ?)');
        args.push(userId, userId);
    }
    if (action) {
        clauses.push('action = ?');
        args.push(action);
    }
    if (after) {
        clauses.push('created_at >= ?');
        args.push(after);
    }
    if (before) {
        clauses.push('created_at <= ?');
        args.push(before);
    }

    const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
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