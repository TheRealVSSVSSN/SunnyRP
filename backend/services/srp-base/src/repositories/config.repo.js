// src/repositories/config.repo.js
import { pool } from './db.js';

export async function getAllConfig() {
    const [rows] = await pool.query(`SELECT k, v FROM config_kv`);
    const out = {};
    for (const r of rows) {
        out[r.k] = r.v ? JSON.parse(r.v) : null;
    }
    return out;
}

export async function setConfig(key, value) {
    await pool.query(
        `INSERT INTO config_kv (k, v) VALUES (?, ?)
     ON DUPLICATE KEY UPDATE v = VALUES(v)`,
        [key, JSON.stringify(value)]
    );
}