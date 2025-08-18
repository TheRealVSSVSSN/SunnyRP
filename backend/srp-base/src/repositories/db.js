const mysql = require('mysql2/promise');
const config = require('../config/env');
const logger = require('../utils/logger');

/**
 * Singleton MySQL connection pool.  Configured using the values from
 * config.db.  Connections are automatically created and reused
 * internally by mysql2.  The pool exposes a `query` method that
 * returns a promise resolving to [rows, fields].  Transactions can
 * be managed by acquiring a connection from the pool and invoking
 * beginTransaction/commit/rollback on it.
 */
const pool = mysql.createPool({
  host: config.db.host,
  port: config.db.port,
  user: config.db.user,
  password: config.db.pass,
  database: config.db.name,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  charset: 'utf8mb4',
});

pool.on('connection', () => {
  logger.debug('MySQL connection established');
});

pool.on('error', (err) => {
  logger.error({ err }, 'MySQL pool error');
});

async function query(sql, params) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

/**
 * Acquire a dedicated connection from the pool for a transaction.
 * Remember to call connection.release() when done.  Transactions must
 * be explicitly committed or rolled back.
 */
async function getConnection() {
  return pool.getConnection();
}

module.exports = {
  pool,
  query,
  getConnection,
};