// backend/services/srp-base/src/repositories/characters.repo.js
import { pool } from './db.js';

function randomPhone(prefix = '555') {
    // Generates prefix + 7 random digits -> 10 digits total (US style: 555XXXXXXX)
    const n = Math.floor(Math.random() * 10_000_000).toString().padStart(7, '0');
    return `${prefix}${n}`;
}

export async function listByOwner(owner_hex) {
    const [rows] = await pool.query(
        `SELECT id, owner_hex, first_name, last_name, dob, gender, phone_number, story, created_at
       FROM characters
      WHERE owner_hex = ?
      ORDER BY id ASC`,
        [owner_hex],
    );
    return rows;
}

export async function getByNamePair(first, last) {
    const [rows] = await pool.query(
        'SELECT id, owner_hex, first_name, last_name, dob, gender, phone_number, story, created_at FROM characters WHERE first_name = ? AND last_name = ? LIMIT 1',
        [first, last],
    );
    return rows[0] || null;
}

async function allocatePhone(conn, tries = 10, prefix = '555') {
    for (let i = 0; i < tries; i++) {
        const phone = randomPhone(prefix);
        const [rows] = await conn.query('SELECT 1 FROM characters WHERE phone_number = ? LIMIT 1', [phone]);
        if (!rows.length) return phone;
    }
    throw new Error('PHONE_ALLOCATION_FAILED');
}

/**
 * Idempotent create:
 * - Enforces unique (first_name, last_name) at DB-level (migration 010)
 * - Generates unique phone_number server-side
 * - If duplicate name, throws { code: 'DUPLICATE_NAME' }
 */
export async function createCharacter({ owner_hex, first_name, last_name, dob = null, gender = null, story = null }) {
    // Fast check on duplicate name
    const existing = await getByNamePair(first_name, last_name);
    if (existing) {
        const e = new Error('Duplicate character name');
        e.code = 'DUPLICATE_NAME';
        throw e;
    }

    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        // Guard again under txn
        const [chk] = await conn.query(
            'SELECT id FROM characters WHERE first_name = ? AND last_name = ? LIMIT 1',
            [first_name, last_name],
        );
        if (chk.length) {
            const e = new Error('Duplicate character name');
            e.code = 'DUPLICATE_NAME';
            throw e;
        }

        const phone = await allocatePhone(conn, 10, '555');

        const [ins] = await conn.query(
            `INSERT INTO characters
       (owner_hex, first_name, last_name, dob, gender, phone_number, story)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [owner_hex, first_name, last_name, dob, gender, phone, story],
        );

        const [rows] = await conn.query(
            'SELECT id, owner_hex, first_name, last_name, dob, gender, phone_number, story, created_at FROM characters WHERE id = ?',
            [ins.insertId],
        );

        await conn.commit();
        return rows[0];
    } catch (e) {
        await conn.rollback();
        if (e && e.code === 'ER_DUP_ENTRY') {
            const dup = new Error('Duplicate character name');
            dup.code = 'DUPLICATE_NAME';
            throw dup;
        }
        throw e;
    } finally {
        conn.release();
    }
}

export async function deleteCharacter(id) {
    const [pre] = await pool.query('SELECT 1 FROM characters WHERE id = ? LIMIT 1', [id]);
    if (!pre.length) return false;
    await pool.query('DELETE FROM characters WHERE id = ?', [id]);
    return true;
}