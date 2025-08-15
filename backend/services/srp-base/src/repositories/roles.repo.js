// src/repositories/roles.repo.js
import { pool } from './db.js';

export async function getRoleIdByName(name) {
    const [rows] = await pool.query(`SELECT id FROM roles WHERE name = ?`, [name]);
    return rows[0]?.id || null;
}

export async function ensureRole(name) {
    let id = await getRoleIdByName(name);
    if (id) return id;
    const [res] = await pool.query(`INSERT INTO roles (name) VALUES (?)`, [name]);
    return res.insertId;
}

export async function grantRole(userId, roleName) {
    const roleId = await ensureRole(roleName);
    await pool.query(
        `INSERT IGNORE INTO user_roles (user_id, role_id) VALUES (?, ?)`,
        [userId, roleId]
    );
    return roleName;
}

export async function revokeRole(userId, roleName) {
    const roleId = await getRoleIdByName(roleName);
    if (!roleId) return 0;
    const [res] = await pool.query(
        `DELETE FROM user_roles WHERE user_id = ? AND role_id = ?`,
        [userId, roleId]
    );
    return res.affectedRows;
}