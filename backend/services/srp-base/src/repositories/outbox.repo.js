// src/repositories/outbox.repo.js
import { pool } from './db.js';

export async function enqueue(topic, payload) {
    const [res] = await pool.query(
        `INSERT INTO outbox (topic, payload, status) VALUES (?, ?, 'pending')`,
        [topic, JSON.stringify(payload || {})]
    );
    return res.insertId;
}