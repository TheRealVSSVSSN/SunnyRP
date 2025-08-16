// src/repositories/admin.repo.js
import { pool } from './db.js';
import {
    findUserIdByAnyIdentifier,
    createUser,
    addIdentifiers,
    touchUser,
    getScopes
} from './identity.repo.js';
import { recordAudit } from './audit.repo.js';

function parseIdentifier(idStr) {
    const idx = idStr.indexOf(':');
    if (idx === -1) return { type: 'license', value: idStr };
    return { type: idStr.slice(0, idx), value: idStr.slice(idx + 1) };
}

export async function ensureUserByIdentifiers(primary, identifiers, ip) {
    let userId = await findUserIdByAnyIdentifier(identifiers);
    if (!userId) {
        userId = await createUser(primary || 'license');
    }
    await addIdentifiers(userId, identifiers, ip);
    await touchUser(userId, ip);
    return userId;
}

export async function isAdmin(userId) {
    const scopes = await getScopes(userId);
    return scopes.some(s => s === 'admin' || s.startsWith('admin.'));
}

export async function banUser(actorUserId, targetUserId, reason = null, active = true) {
    await pool.query(`UPDATE bans SET active = 0 WHERE user_id = ? AND active = 1`, [targetUserId]);
    if (active) {
        await pool.query(
            `INSERT INTO bans (user_id, reason, active) VALUES (?, ?, 1)`,
            [targetUserId, reason || null]
        );
    }
    await recordAudit(actorUserId, targetUserId, 'admin.ban', { reason, active });
    return { userId: targetUserId, banned: !!active, reason: reason || null };
}

export async function kickUser(actorUserId, targetUserId, reason = null) {
    await recordAudit(actorUserId, targetUserId, 'admin.kick', { reason });
    return { userId: targetUserId, kicked: true, reason: reason || null };
}

export async function listBans({ userId = null, active = null, limit = 50 }) {
    const args = [];
    const clauses = [];
    if (userId != null) {
        clauses.push('b.user_id = ?');
        args.push(userId);
    }
    if (active != null) {
        clauses.push('b.active = ?');
        args.push(active ? 1 : 0);
    }
    const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
    const [rows] = await pool.query(
        `SELECT b.id, b.user_id, b.reason, b.active, b.created_at
     FROM bans b
     ${where}
     ORDER BY b.id DESC
     LIMIT ?`,
        [...args, Math.min(Math.max(limit, 1), 200)]
    );
    return rows;
}

export async function unbanUser(actorUserId, targetUserId) {
    const [res] = await pool.query(
        `UPDATE bans SET active = 0 WHERE user_id = ? AND active = 1`,
        [targetUserId]
    );
    const changed = res.affectedRows || 0;
    await recordAudit(actorUserId, targetUserId, 'admin.unban', { deactivated: changed });
    return { userId: targetUserId, unbanned: changed > 0, deactivated: changed };
}

/**
 * Soft delete user (mark deleted_at). No cascades; identifiers remain for history.
 */
export async function softDeleteUser(actorUserId, targetUserId, reason = null) {
    const [res] = await pool.query(
        `UPDATE users SET deleted_at = CURRENT_TIMESTAMP WHERE id = ? AND deleted_at IS NULL`,
        [targetUserId]
    );
    const changed = res.affectedRows || 0;
    await recordAudit(actorUserId, targetUserId, 'admin.users.soft_delete', { reason, changed });
    return { userId: targetUserId, deleted: changed > 0 };
}

/**
 * Restore a soft-deleted user.
 */
export async function restoreUser(actorUserId, targetUserId) {
    const [res] = await pool.query(
        `UPDATE users SET deleted_at = NULL WHERE id = ? AND deleted_at IS NOT NULL`,
        [targetUserId]
    );
    const changed = res.affectedRows || 0;
    await recordAudit(actorUserId, targetUserId, 'admin.users.restore', { changed });
    return { userId: targetUserId, restored: changed > 0 };
}

/**
 * Merge "fromUserId" into "intoUserId".
 * Moves identifiers (deduped), roles (deduped), and re-assigns bans, then clears fromUser's identifiers/roles.
 */
export async function mergeUsers(actorUserId, fromUserId, intoUserId) {
    if (fromUserId === intoUserId) {
        throw new Error('Cannot merge a user into itself');
    }

    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        // identifiers
        const [idents] = await conn.query(
            `SELECT id_type, id_value FROM user_identifiers WHERE user_id = ?`,
            [fromUserId]
        );
        for (const row of idents) {
            await conn.query(
                `INSERT IGNORE INTO user_identifiers (user_id, id_type, id_value) VALUES (?,?,?)`,
                [intoUserId, row.id_type, row.id_value]
            );
        }
        await conn.query(`DELETE FROM user_identifiers WHERE user_id = ?`, [fromUserId]);

        // roles
        const [roles] = await conn.query(
            `SELECT role_id FROM user_roles WHERE user_id = ?`,
            [fromUserId]
        );
        for (const r of roles) {
            await conn.query(
                `INSERT IGNORE INTO user_roles (user_id, role_id) VALUES (?, ?)`,
                [intoUserId, r.role_id]
            );
        }
        await conn.query(`DELETE FROM user_roles WHERE user_id = ?`, [fromUserId]);

        // bans -> reassign to intoUser
        await conn.query(`UPDATE bans SET user_id = ? WHERE user_id = ?`, [intoUserId, fromUserId]);

        // audits -> retarget target_user_id
        await conn.query(`UPDATE audit SET target_user_id = ? WHERE target_user_id = ?`, [intoUserId, fromUserId]);

        await conn.commit();

        await recordAudit(actorUserId, intoUserId, 'admin.users.merge', {
            fromUserId,
            intoUserId
        });

        return { fromUserId, intoUserId, merged: true };
    } catch (e) {
        await conn.rollback();
        throw e;
    } finally {
        conn.release();
    }
}