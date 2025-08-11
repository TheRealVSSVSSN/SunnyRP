import { createBan } from '../repositories/bans.repo.js';
import { writeAudit, fetchAudit } from '../repositories/audit.repo.js';

export async function banUser({ userId, reason, minutes, actorId }) {
    const id = await createBan(userId, reason, minutes, actorId);
    await writeAudit({ actor_type: 'admin', actor_id: actorId || null, action: 'ban', user_id: userId, meta: { reason, minutes, ban_id: id } });
    return { ban_id: id };
}

export async function kickUser({ userId, reason, actorId }) {
    await writeAudit({ actor_type: 'admin', actor_id: actorId || null, action: 'kick', user_id: userId, meta: { reason } });
    return { ok: true };
}

export async function getAudit({ userId, limit }) {
    const rows = await fetchAudit({ userId, limit });
    return rows;
}