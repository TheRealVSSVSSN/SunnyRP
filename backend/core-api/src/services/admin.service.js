import { createBan } from '../repositories/bans.repo.js';
import { writeAudit, fetchAudit } from '../repositories/audit.repo.js';
import * as Presence from '../repositories/adminPresence.repo.js';
import * as Actions from '../repositories/adminActions.repo.js';
import * as Perms from '../repositories/permissions.repo.js';

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

// map action -> required scope
const ACTION_SCOPES = {
  spectate: 'admin.spectate',
  noclip: 'admin.noclip',
  bring: 'admin.teleport',
  goto: 'admin.teleport',
  cleanup: 'admin.cleanup',
  kick: 'admin.kick',
  ban: 'admin.ban',
  unban: 'admin.ban',
  audit: 'admin.audit',
};

export async function heartbeat(body) {
  if (!body?.user_id || !body?.src) { const e=new Error('BAD_REQUEST'); e.statusCode=400; throw e; }
  await Presence.heartbeat(body);
  return { ok: true };
}

export async function getOnline() {
  const rows = await Presence.online(60);
  return rows.map(r => ({ ...r, position: r.position ? JSON.parse(r.position) : null }));
}

export async function preflight(action, body) {
  if (!action) { const e=new Error('BAD_ACTION'); e.statusCode=400; throw e; }
  const needed = ACTION_SCOPES[action];
  if (!needed) { const e=new Error('UNSUPPORTED'); e.statusCode=404; throw e; }
  if (!body?.actor_user_id) { const e=new Error('BAD_ACTOR'); e.statusCode=400; throw e; }
  const scopes = await Perms.scopesForUser(Number(body.actor_user_id));
  const allowed = scopes.includes(needed);
  const auditId = await Actions.createAttempt({
    actor_user_id: body.actor_user_id,
    actor_char_id: body.actor_char_id || null,
    action,
    target_src: body.target_src || null,
    target_user_id: body.target_user_id || null,
    target_char_id: body.target_char_id || null,
    params: body.params || {},
    status: allowed ? 'allowed' : 'denied',
    scope_used: needed,
  });
  return { ok: allowed, data: { audit_id: auditId, required_scope: needed } };
}

export async function complete(body) {
  if (!body?.audit_id) { const e=new Error('BAD_REQUEST'); e.statusCode=400; throw e; }
  await Actions.updateResult(body.audit_id, {
    status: body.status || 'success',
    result_code: body.result_code || null,
    result_message: body.result_message || null,
  });
  return { ok: true };
}

export async function auditList(q) {
  const rows = await Actions.list({ action: q.action, actor_user_id: q.actorUserId, target_user_id: q.targetUserId }, Math.min(Number(q.limit||200),500), Number(q.offset||0));
  return rows;
}
