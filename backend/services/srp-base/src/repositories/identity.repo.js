// src/repositories/identity.repo.js
import { pool } from './db.js';

function parseIdentifier(idStr) {
    // expects formats like "license:xyz", "steam:1100001...", "discord:1234"
    const idx = idStr.indexOf(':');
    if (idx === -1) return { type: 'license', value: idStr }; // fallback
    return { type: idStr.slice(0, idx), value: idStr.slice(idx + 1) };
}

export async function findUserIdByAnyIdentifier(identifiers) {
    if (!identifiers.length) return null;
    const pairs = identifiers.map(parseIdentifier);

    const where = pairs
        .map(() => '(id_type = ? AND id_value = ?)')
        .join(' OR ');
    const args = pairs.flatMap(p => [p.type, p.value]);

    const [rows] = await pool.query(
        `SELECT user_id FROM user_identifiers WHERE ${where} LIMIT 1`,
        args
    );
    return rows[0]?.user_id || null;
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