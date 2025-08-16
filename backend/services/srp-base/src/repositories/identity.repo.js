// src/repositories/identity.repo.js
import { pool } from './db.js';

function parseIdentifier(idStr) {
    const idx = idStr.indexOf(':');
    if (idx === -1) return { type: 'license', value: idStr };
    return { type: idStr.slice(0, idx), value: idStr.slice(idx + 1) };
}

export async function findUserIdByAnyIdentifier(identifiers) {
    if (!identifiers.length) return null;
    const pairs = identifiers.map(parseIdentifier);

    const where = pairs.map(() => '(id_type = ? AND id_value = ?)').join(' OR ');
    const args = pairs.flatMap(p => [p.type, p.value]);

    const [rows] = await pool.query(
        `SELECT user_id FROM user_identifiers WHERE ${where} LIMIT 1`,
        args
    );
    return rows[0]?.user_id || null;
}

export async function resolveUserByIdentifier(identifier) {
    const { type, value } = parseIdentifier(identifier);
    const [rows] = await pool.query(
        `SELECT u.*
     FROM users u
     JOIN user_identifiers ui ON ui.user_id = u.id
     WHERE ui.id_type = ? AND ui.id_value = ?
     LIMIT 1`,
        [type, value]
    );
    return rows[0] || null;
}

export async function getUserWithIdentifiers(userId) {
    const [uRows] = await pool.query(`SELECT * FROM users WHERE id = ?`, [userId]);
    if (!uRows.length) return null;
    const user = uRows[0];
    const [iRows] = await pool.query(
        `SELECT id_type, id_value FROM user_identifiers WHERE user_id = ? ORDER BY id ASC`,
        [userId]
    );
    const identifiers = iRows.map(r => `${r.id_type}:${r.id_value}`);
    return { ...user, identifiers };
}

export async function searchUsersByIdentifierOrName(q, limit = 20) {
    const like = `${q}%`;
    const [rows] = await pool.query(
        `SELECT u.id,
            u.primary_identifier,
            u.display_name,
            GROUP_CONCAT(CONCAT(ui.id_type, ':', ui.id_value) ORDER BY ui.id SEPARATOR ',') AS identifiers
     FROM users u
     JOIN user_identifiers ui ON ui.user_id = u.id
     WHERE ui.id_value LIKE ? OR u.display_name LIKE ?
     GROUP BY u.id
     ORDER BY u.id DESC
     LIMIT ?`,
        [like, like, Math.min(Math.max(limit, 1), 100)]
    );

    return rows.map(r => ({
        id: r.id,
        primary_identifier: r.primary_identifier,
        display_name: r.display_name,
        identifiers: (r.identifiers || '').split(',').filter(Boolean)
    }));
}

export async function createUser(primaryIdentifier) {
    const [res] = await pool.query(
        `INSERT INTO users (primary_identifier) VALUES (?)`,
        [primaryIdentifier]
    );
    return res.insertId;
}

export async function addIdentifiers(userId, identifiers, ip) {
    const pairs = identifiers.map(parseIdentifier);
    const values = pairs.map(() => '(?,?,?)').join(',');
    const args = pairs.flatMap(p => [userId, p.type, p.value]);

    if (pairs.length) {
        await pool.query(
            `INSERT IGNORE INTO user_identifiers (user_id, id_type, id_value)
       VALUES ${values}`,
            args
        );
    }

    if (ip) {
        await pool.query(
            `INSERT IGNORE INTO user_identifiers (user_id, id_type, id_value)
       VALUES (?,?,?)`,
            [userId, 'ip', ip]
        );
    }
}

export async function touchUser(userId, ip) {
    await pool.query(
        `UPDATE users SET last_ip = ?, last_seen = CURRENT_TIMESTAMP WHERE id = ?`,
        [ip || null, userId]
    );
}

export async function getBanStatus(userId) {
    const [rows] = await pool.query(
        `SELECT reason FROM bans WHERE user_id = ? AND active = 1 ORDER BY id DESC LIMIT 1`,
        [userId]
    );
    if (!rows.length) return { banned: false, banReason: null };
    return { banned: true, banReason: rows[0].reason || null };
}

export async function getScopes(userId) {
    const [rows] = await pool.query(
        `SELECT DISTINCT rs.scope
     FROM user_roles ur
     JOIN role_scopes rs ON rs.role_id = ur.role_id
     WHERE ur.user_id = ?`,
        [userId]
    );
    return rows.map(r => r.scope);
}