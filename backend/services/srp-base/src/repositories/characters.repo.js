// src/repositories/characters.repo.js
import { pool } from './db.js';

// Normalize DB row -> Character object
function mapRow(r) {
    return {
        id: r.id,
        owner_hex: r.owner_hex,
        first_name: r.first_name,
        last_name: r.last_name,
        dob: r.dob ? r.dob.toISOString().slice(0, 10) : null,
        gender: r.gender,
        phone_number: r.phone_number,
        story: r.story,
        created_at: r.created_at && r.created_at.toISOString ? r.created_at.toISOString() : r.created_at
    };
}

export async function listByOwnerHex(owner_hex) {
    const [rows] = await pool.query(
        `SELECT id, owner_hex, first_name, last_name, dob, gender, phone_number, story, created_at
     FROM characters
     WHERE owner_hex = ?
     ORDER BY id ASC`,
        [owner_hex]
    );
    return rows.map(mapRow);
}

export async function getById(id) {
    const [rows] = await pool.query(
        `SELECT id, owner_hex, first_name, last_name, dob, gender, phone_number, story, created_at
     FROM characters
     WHERE id = ?
     LIMIT 1`,
        [id]
    );
    return rows[0] ? mapRow(rows[0]) : null;
}

function randomPhone() {
    // 3-3-4 pattern: XXX-XXX-XXXX
    const r3 = () => String(Math.floor(Math.random() * 900) + 100);
    const r4 = () => String(Math.floor(Math.random() * 9000) + 1000);
    return `${r3()}-${r3()}-${r4()}`;
}

async function phoneExists(conn, phone) {
    const [rows] = await conn.query('SELECT 1 FROM characters WHERE phone_number = ? LIMIT 1', [phone]);
    return rows.length > 0;
}

async function allocatePhone(conn, maxAttempts = 20) {
    for (let i = 0; i < maxAttempts; i++) {
        const p = randomPhone();
        // Locking by checking in the same connection/tx is sufficient with unique index too
        const exists = await phoneExists(conn, p);
        if (!exists) return p;
    }
    const err = new Error('phone_exhausted');
    err.code = 'PHONE_EXHAUSTED';
    throw err;
}

export async function createCharacterAtomic({ owner_hex, first_name, last_name, dob = null, gender = null, story = null }) {
    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        // Enforce unique name across server
        const [nameRows] = await conn.query(
            `SELECT 1 FROM characters WHERE first_name = ? AND last_name = ? LIMIT 1`,
            [first_name, last_name]
        );
        if (nameRows.length > 0) {
            const err = new Error('duplicate_name');
            err.code = 'DUPLICATE_NAME';
            throw err;
        }

        // Unique phone allocation
        const phone = await allocatePhone(conn);

        const [res] = await conn.query(
            `INSERT INTO characters (owner_hex, first_name, last_name, dob, gender, phone_number, story)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [owner_hex, first_name, last_name, dob, gender, phone, story]
        );

        const id = res.insertId;
        const created = await getById(id);
        await conn.commit();
        return created;
    } catch (e) {
        try { await conn.rollback(); } catch { }
        throw e;
    } finally {
        conn.release();
    }
}

export async function updateCharacter(id, patch) {
    const fields = [];
    const values = [];
    for (const [k, v] of Object.entries(patch)) {
        fields.push(`${k} = ?`);
        values.push(v);
    }
    if (fields.length === 0) return null;
    values.push(id);

    const [res] = await pool.query(
        `UPDATE characters SET ${fields.join(', ')} WHERE id = ?`,
        values
    );
    if (res.affectedRows === 0) return null;
    return getById(id);
}