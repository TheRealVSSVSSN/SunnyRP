// src/bootstrap/migrate.js
import { readdirSync, readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { pool } from '../repositories/db.js';

const __dirname = dirname(fileURLToPath(import.meta.url));

async function ensureMigrationsTable(conn) {
    await conn.query(`
    CREATE TABLE IF NOT EXISTS srp_migrations (
      name VARCHAR(255) PRIMARY KEY,
      applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}

async function appliedSet(conn) {
    const [rows] = await conn.query('SELECT name FROM srp_migrations');
    return new Set(rows.map(r => r.name));
}

async function applyMigration(conn, name, sql) {
    await conn.query(sql);
    await conn.query('INSERT INTO srp_migrations (name) VALUES (?)', [name]);
}

export async function runMigrations() {
    const migrationsDir = join(__dirname, '../../migrations');
    const files = readdirSync(migrationsDir)
        .filter(f => f.endsWith('.sql'))
        .sort();

    const conn = await pool.getConnection();
    try {
        await ensureMigrationsTable(conn);
        const done = await appliedSet(conn);

        for (const f of files) {
            if (done.has(f)) continue;
            const full = join(migrationsDir, f);
            const sql = readFileSync(full, 'utf8');
            console.log(`[migrate] applying ${f}`);
            await applyMigration(conn, f, sql);
        }
        console.log('[migrate] up to date');
    } finally {
        conn.release();
    }
}

// Allow `npm run migrate`
if (process.argv[1] && process.argv[1].endsWith('migrate.js')) {
    runMigrations().then(() => {
        console.log('[migrate] completed');
        process.exit(0);
    }).catch((err) => {
        console.error('[migrate] failed', err);
        process.exit(1);
    });
}