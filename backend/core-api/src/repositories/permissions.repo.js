import { db } from './db.js';

// minimal helper to expand user scopes from Phase B tables
export async function scopesForUser(userId) {
    // role_scopes via user_roles + overrides (grant/deny)
    const roleScopes = await db('user_roles as ur')
        .join('roles as r', 'ur.role_id', 'r.id')
        .join('role_scopes as rs', 'r.id', 'rs.role_id')
        .where('ur.user_id', userId)
        .select('rs.scope');

    const overrides = await db('overrides').where({ user_id: userId });
    const allow = new Set(roleScopes.map(r => r.scope));
    for (const o of overrides) {
        if (o.effect === 'allow') allow.add(o.scope);
        if (o.effect === 'deny') allow.delete(o.scope);
    }
    return Array.from(allow);
}