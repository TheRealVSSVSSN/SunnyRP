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
    // Simple gate: 'admin' or 'admin.*' style scopes supported
    return scopes.some(s => s === 'admin' || s.startsWith('admin.'));
}

export async function banUser(actorUserId, targetUserId, reason = null, active = true) {
    // close existing active bans
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
    // We only record audit here; actual kick can be handled by FiveM base via separate mechanism/outbox later.
    await recordAudit(actorUserId, targetUserId, 'admin.kick', { reason });
    return { userId: targetUserId, kicked: true, reason: reason || null };
}