import mysql from 'mysql2/promise';
import { logger } from '../util/logger.js';

export const pool = mysql.createPool({
  host: process.env.DB_HOST || '127.0.0.1',
  port: Number(process.env.DB_PORT) || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'srp',
  waitForConnections: true,
  connectionLimit: 10
});

export async function query(sql, params) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

pool.on('connection', () => logger.debug('db connection acquired'));
