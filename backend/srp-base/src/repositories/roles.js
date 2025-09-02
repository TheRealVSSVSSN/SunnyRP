import { query } from '../db/index.js';

export async function createRole(name, description = null) {
  const result = await query('INSERT INTO roles (name, description) VALUES (?, ?)', [name, description]);
  return { id: result.insertId, name, description };
}

export async function addRolePermission(roleId, scope) {
  await query(
    'INSERT INTO role_permissions (role_id, scope) VALUES (?, ?) ON DUPLICATE KEY UPDATE scope = scope',
    [roleId, scope]
  );
}

export async function assignRole(accountId, roleId) {
  await query(
    'INSERT INTO account_roles (account_id, role_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE role_id = role_id',
    [accountId, roleId]
  );
}

export async function listRoles() {
  return query('SELECT id, name, description FROM roles', []);
}

export async function getAccountRoles(accountId) {
  return query(
    'SELECT r.id, r.name FROM roles r JOIN account_roles ar ON r.id = ar.role_id WHERE ar.account_id = ?',
    [accountId]
  );
}

export async function getAccountScopes(accountId) {
  const rows = await query(
    'SELECT rp.scope FROM role_permissions rp JOIN account_roles ar ON rp.role_id = ar.role_id WHERE ar.account_id = ?',
    [accountId]
  );
  return rows.map(r => r.scope);
}
