import { getUserRoles, addUserRole, removeUserRole, getRoleScopes, listRoles } from '../repositories/roles.repo.js';
import { db } from '../repositories/db.js';

export async function getUserPermissions(userId) {
    const roles = await getUserRoles(userId);
    const roleScopes = await getRoleScopes(roles.map(r => r.id));
    const overrides = await db('overrides').where({ user_id: userId });
    const allow = overrides.filter(o => o.allow).map(o => o.scope);
    const deny = overrides.filter(o => !o.allow).map(o => o.scope);

    const scopes = Array.from(new Set(roleScopes.map(s => s.scope).concat(allow).filter(s => !deny.includes(s))));
    return {
        roles: roles.map(r => r.name),
        scopes,
        overrides: { allow, deny },
        catalog: await listRoles()
    };
}

export async function grantPermission({ userId, type, roleName, scope, allow = true }) {
    if (type === 'role') {
        const role = await addUserRole(userId, roleName);
        return { granted: `role:${role.name}` };
    }
    if (type === 'scope') {
        // upsert override
        const exists = await db('overrides').where({ user_id: userId, scope }).first();
        if (!exists) await db('overrides').insert({ user_id: userId, scope, allow });
        else await db('overrides').where({ id: exists.id }).update({ allow });
        return { granted: `scope:${scope}`, allow };
    }
    throw new Error('INVALID_TYPE');
}

export async function revokePermission({ userId, type, roleName, scope }) {
    if (type === 'role') {
        await removeUserRole(userId, roleName);
        return { revoked: `role:${roleName}` };
    }
    if (type === 'scope') {
        await db('overrides').where({ user_id: userId, scope }).delete();
        return { revoked: `scope:${scope}` };
    }
    throw new Error('INVALID_TYPE');
}