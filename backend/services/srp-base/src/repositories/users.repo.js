// backend/services/srp-base/src/repositories/users.repo.js
import { pool } from './db.js';

function pickIdentifiers(identifiers = []) {
    const out = { license: null, steam: null, discord: null, fivem: null, xbl: null, live: null, ip: null };
    for (const it of identifiers) {
        if (!it || !it.type || !it.value) continue;
        const t = String(it.type);
        if (Object.prototype.hasOwnProperty.call(out, t)) out[t] = String(it.value);
    }
    return out;
}

export async function existsByHex(hex_id) {
    const [rows] = await pool.query('SELECT 1 FROM users WHERE hex_id = ? LIMIT 1', [hex_id]);
    return rows.length > 0;
}

export async function getByHex(hex_id) {
    const [rows] = await pool.query(
        'SELECT hex_id, name, rank, steam_id, license, discord, community_id, created_at FROM users WHERE hex_id = ? LIMIT 1',
        [hex_id],
    );
    return rows[0] || null;
}

/**
 * Idempotent create-or-get.
 * If the row exists, return it. Else insert, then return.
 * We only guarantee hex_id + name here to keep compatibility with your existing schema;
 * known identifiers are copied into known columns if present.
 */
export async function createOrGet({ hex_id, name, identifiers = [] }) {
    // Insert-or-update name (idempotent). This survives partial schema differences.
    await pool.query(
        'INSERT INTO users (hex_id, name) VALUES (?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name)',
        [hex_id, name],
    );

    // If you have columns for known identifiers, update them opportunistically.
    const ids = pickIdentifiers(identifiers);
    const updates = [];
    const params = [];
    if (ids.license != null) { updates.push('license = ?'); params.push(ids.license); }
    if (ids.steam != null) { updates.push('steam_id = ?'); params.push(ids.steam); }
    if (ids.discord != null) { updates.push('discord = ?'); params.push(ids.discord); }
    if (updates.length > 0) {
        params.push(hex_id);
        await pool.query(`UPDATE users SET ${updates.join(', ')} WHERE hex_id = ?`, params);
    }

    return getByHex(hex_id);
}