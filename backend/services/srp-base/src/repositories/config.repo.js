// backend/services/srp-base/src/repositories/config.repo.js
import { pool } from './db.js';

/**
 * Returns latest config_live row, or null if empty
 * { id, value (JSON parsed), updated_at }
 */
export async function getLive() {
    const [rows] = await pool.query(
        'SELECT id, value, updated_at FROM config_live ORDER BY id DESC LIMIT 1',
    );
    if (!rows?.length) return null;

    // MySQL returns JSON columns as strings in some clients; ensure JS object
    let value = rows[0].value;
    if (typeof value === 'string') {
        try { value = JSON.parse(value); } catch { /* keep as-is */ }
    }

    return {
        id: rows[0].id,
        value,
        updated_at: rows[0].updated_at,
    };
}

/**
 * Upsert with optimistic concurrency (expectedUpdatedAt optional)
 * Returns the latest row after change.
 */
export async function upsertLive(nextValue, expectedUpdatedAt = null) {
    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        const [curRows] = await conn.query(
            'SELECT id, updated_at FROM config_live ORDER BY id DESC LIMIT 1 FOR UPDATE',
        );

        if (expectedUpdatedAt && curRows?.length) {
            const currentIso = new Date(curRows[0].updated_at).toISOString();
            const expectedIso = new Date(expectedUpdatedAt).toISOString();
            if (currentIso !== expectedIso) {
                const e = new Error('CONFIG_WRITE_CONFLICT');
                e.code = 'CONFIG_WRITE_CONFLICT';
                throw e;
            }
        }

        if (curRows?.length) {
            await conn.query(
                'UPDATE config_live SET value = ?, updated_at = NOW() WHERE id = ?',
                [JSON.stringify(nextValue), curRows[0].id],
            );
            const [after] = await conn.query(
                'SELECT id, value, updated_at FROM config_live WHERE id = ?',
                [curRows[0].id],
            );
            await conn.commit();
            const row = after[0];
            let value = row.value;
            if (typeof value === 'string') {
                try { value = JSON.parse(value); } catch { }
            }
            return { id: row.id, value, updated_at: row.updated_at };
        } else {
            const [ins] = await conn.query(
                'INSERT INTO config_live (value) VALUES (?)',
                [JSON.stringify(nextValue)],
            );
            const [after] = await conn.query(
                'SELECT id, value, updated_at FROM config_live WHERE id = ?',
                [ins.insertId],
            );
            await conn.commit();
            const row = after[0];
            let value = row.value;
            if (typeof value === 'string') {
                try { value = JSON.parse(value); } catch { }
            }
            return { id: row.id, value, updated_at: row.updated_at };
        }
    } catch (e) {
        await conn.rollback();
        throw e;
    } finally {
        conn.release();
    }
}