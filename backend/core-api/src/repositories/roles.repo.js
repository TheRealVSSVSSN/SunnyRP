import { db } from './db.js';

export async function getUserRoles(userId) {
    return db('user_roles')
        .select('roles.id', 'roles.name', 'roles.description')
        .join('roles', 'roles.id', 'user_roles.role_id')
        .where('user_roles.user_id', userId);
}

export async function getRoleScopes(roleIds) {
    if (!roleIds.length) return [];
    return db('role_scopes').whereIn('role_id', roleIds).select('scope');
}

export async function addUserRole(userId, roleName) {
    const role = await db('roles').where({ name: roleName }).first();
    if (!role) throw new Error('ROLE_NOT_FOUND');
    const exists = await db('user_roles').where({ user_id: userId, role_id: role.id }).first();
    if (!exists) await db('user_roles').insert({ user_id: userId, role_id: role.id });
    return role;
}

export async function removeUserRole(userId, roleName) {
    const role = await db('roles').where({ name: roleName }).first();
    if (!role) return;
    await db('user_roles').where({ user_id: userId, role_id: role.id }).delete();
}

export async function listRoles() {
    return db('roles').select('*');
}