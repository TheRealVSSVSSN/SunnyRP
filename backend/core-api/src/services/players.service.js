import { createUser, findUserByAnyIdentifier, upsertIdentifiers, touchUser, getUserWithIdentifiers } from '../repositories/users.repo.js';
import { getUserRoles, getRoleScopes } from '../repositories/roles.repo.js';
import { activeBan } from '../repositories/bans.repo.js';

export async function linkPlayer({ identifiers, primary, ip }) {
    // Normalize input
    const idmap = Object.fromEntries(Object.entries(identifiers || {}).filter(([_, v]) => v));
    if (ip) idmap.ip = ip;

    let user = await findUserByAnyIdentifier(idmap);
    if (!user) {
        const primaryVal = idmap[primary] || Object.values(idmap)[0];
        const userId = await createUser(primaryVal, ip || null);
        await upsertIdentifiers(userId, idmap);
        user = (await getUserWithIdentifiers(userId)).user;
    } else {
        await upsertIdentifiers(user.id, idmap);
    }

    await touchUser(user.id, ip || null);
    const roles = await getUserRoles(user.id);
    const roleIds = roles.map(r => r.id);
    const rScopes = await getRoleScopes(roleIds);
    const scopes = Array.from(new Set(rScopes.map(s => s.scope)));

    const ban = await activeBan(user.id);
    return {
        user,
        roles: roles.map(r => r.name),
        scopes,
        banned: ban ? { reason: ban.reason, expires_at: ban.expires_at } : null
    };
}

export async function getPlayer(userId) {
    const data = await getUserWithIdentifiers(userId);
    return data;
}