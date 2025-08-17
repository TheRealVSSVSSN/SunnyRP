// src/repositories/users.repo.js
import { pool } from './db.js';

/**
 * Maps identifiers array -> users columns.
 * identifiers: [{type:'license'|'steam'|'discord'|'community', value:string}]
 */
function identifiersToColumns(identifiers = []) {
    const col = { steam_id: null, license: null, discord: null, community_id: null };
    for (const itm of identifiers) {
        const t = String(itm.type || '').toLowerCase();
        if (t === 'steam') col.steam_id = itm.value;
        else if (t === 'license') col.license = itm.value;
        else if (t === 'discord') col.discord = itm.value;
        else if (t === 'community' || t === 'community_id') col.community_id = itm.value;
    }
    return col;
}

export async function existsByHexId(hex_id) {
    const [rows] = await pool.query('SELECT 1 FROM users WHERE hex_id = ? LIMIT 1', [hex_id]);
    return rows.length > 0;
}

export async function getByHexId(hex_id) {
    const [rows] = await pool.query(
        `SELECT hex_id, steam_id, license, discord, community_id, name, rank, created_at
     FROM users
     WHERE hex_id = ?
     LIMIT 1`,
        [hex_id]
    );
    return rows[0] || null;
}

export async function createUser({ hex_id, name, rank = 'user', identifiers = [] }) {
    const cols = identifiersToColumns(identifiers);
    const [res] = await pool.query(
        `INSERT INTO users (hex_id, name, rank, steam_id, license, discord, community_id)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [hex_id, name, rank, cols.steam_id, cols.license, cols.discord, cols.community_id]
    );
    if (!res.insertId && res.affectedRows !== 1) {
        throw new Error('insert_failed');
    }
    return getByHexId(hex_id);
}