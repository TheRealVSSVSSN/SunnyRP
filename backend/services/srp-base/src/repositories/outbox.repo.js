// src/repositories/outbox.repo.js
import crypto from 'crypto';
import { pool } from './db.js';
import { env } from '../config/env.js';

export async function enqueue(topic, payload) {
    const [res] = await pool.query(
        `INSERT INTO outbox (topic, payload, status) VALUES (?, ?, 'pending')`,
        [topic, JSON.stringify(payload || {})]
    );
    return res.insertId;
}

/**
 * Attempts to claim up to batchSize pending messages by setting a unique lock_token.
 * Returns claimed rows (id, topic, payload).
 */
export async function claimPendingBatch(batchSize) {
    const lockToken = crypto.randomUUID();

    const [ids] = await pool.query(
        `SELECT id FROM outbox
     WHERE status = 'pending'
       AND (locked_at IS NULL OR locked_at < (NOW() - INTERVAL ? SECOND))
     ORDER BY id ASC
     LIMIT ?`,
        [env.OUTBOX_CLAIM_TIMEOUT_SEC, batchSize]
    );

    const claimed = [];
    for (const row of ids) {
        const [res] = await pool.query(
            `UPDATE outbox
       SET lock_token = ?, locked_at = NOW()
       WHERE id = ?
         AND status = 'pending'
         AND (lock_token IS NULL OR locked_at < (NOW() - INTERVAL ? SECOND))`,
            [lockToken, row.id, env.OUTBOX_CLAIM_TIMEOUT_SEC]
        );
        if (res.affectedRows === 1) {
            claimed.push(row.id);
        }
    }

    if (claimed.length === 0) return [];

    const [rows] = await pool.query(
        `SELECT id, topic, payload
     FROM outbox
     WHERE lock_token = ?`,
        [lockToken]
    );

    return rows.map(r => ({
        id: r.id,
        topic: r.topic,
        payload: JSON.parse(r.payload)
    }));
}

export async function markDelivered(id) {
    await pool.query(
        `UPDATE outbox
     SET status = 'delivered', locked_at = NULL, lock_token = NULL
     WHERE id = ?`,
        [id]
    );
}

export async function markFailed(id, reason) {
    await pool.query(
        `UPDATE outbox
     SET status = 'failed', last_error = ?
     WHERE id = ?`,
        [reason?.toString().slice(0, 255) || null, id]
    );
}