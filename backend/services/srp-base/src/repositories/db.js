// src/repositories/db.js
import mysql from 'mysql2/promise';
import { env } from '../config/env.js';

export const pool = mysql.createPool({
    host: env.DB_HOST,
    port: env.DB_PORT,
    user: env.DB_USER,
    password: env.DB_PASSWORD,
    database: env.DB_NAME,
    waitForConnections: true,
    connectionLimit: env.DB_CONN_LIMIT,
    supportBigNumbers: true,
    multipleStatements: true
});

export async function pingDB() {
    const conn = await pool.getConnection();
    try {
        await conn.ping();
    } finally {
        conn.release();
    }
}