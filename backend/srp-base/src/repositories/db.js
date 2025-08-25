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

function prepare(sql, params) {
  if (!params || Array.isArray(params)) {
    return { sql, values: params };
  }
  const values = [];
  const formatted = sql.replace(/@([a-zA-Z0-9_]+)/g, (match, key) => {
    if (!Object.prototype.hasOwnProperty.call(params, key)) {
      throw new Error(`Missing value for named parameter ${key}`);
    }
    values.push(params[key]);
    return '?';
  });
  return { sql: formatted, values };
}

async function query(sql, params) {
  const { sql: formatted, values } = prepare(sql, params);
  const [rows] = await pool.execute(formatted, values);
  return rows;
}

async function scalar(sql, params) {
  const rows = await query(sql, params);
  if (!rows.length) {
    return null;
  }
  const row = rows[0];
  const keys = Object.keys(row);
  return keys.length ? row[keys[0]] : null;
}

async function transaction(steps) {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    for (const step of steps) {
      const { sql: formatted, values } = prepare(step.sql, step.params);
      await connection.execute(formatted, values);
    }
    await connection.commit();
    return true;
  } catch (err) {
    await connection.rollback();
    logger.error({ err }, 'transaction rollback');
    return false;
  } finally {
    connection.release();
  }
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
  scalar,
  getConnection,
  transaction,
};