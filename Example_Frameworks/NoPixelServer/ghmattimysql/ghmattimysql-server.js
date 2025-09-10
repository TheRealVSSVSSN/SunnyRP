/**
 * Type: Node Module
 * Name: ghmattimysql-server.js
 * Use: Provides MySQL query helpers for FiveM via exports
 * Created: 2024-11-25
 * By: VSSVSSN
 */

const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

const resourceName = GetCurrentResourceName();
const configPath = path.join(GetResourcePath(resourceName), 'config.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST || config.host,
  user: process.env.MYSQL_USER || config.user,
  password: process.env.MYSQL_PASSWORD || config.password,
  database: process.env.MYSQL_DATABASE || config.database,
  port: Number(process.env.MYSQL_PORT || config.port || 3306),
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  namedPlaceholders: true,
});

function safeParams(params) {
  return Array.isArray(params) || (params && typeof params === 'object') ? params : [];
}

function respond(cb, data) {
  if (typeof cb === 'function') cb(data);
}

exports('execute', async (query, params, cb) => {
  try {
    const [rows] = await pool.execute(query, safeParams(params));
    respond(cb, rows);
  } catch (err) {
    console.error(`[ghmattimysql] execute error: ${err.message}`);
    respond(cb, []);
  }
});

exports('scalar', async (query, params, cb) => {
  try {
    const [rows] = await pool.execute(query, safeParams(params));
    const value = rows && rows[0] ? Object.values(rows[0])[0] : null;
    respond(cb, value);
  } catch (err) {
    console.error(`[ghmattimysql] scalar error: ${err.message}`);
    respond(cb, null);
  }
});

exports('transaction', async (queries, params, cb) => {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const results = [];
    for (let i = 0; i < queries.length; i++) {
      const q = queries[i];
      const p = params[i] || [];
      const [rows] = await conn.execute(q, safeParams(p));
      results.push(rows);
    }
    await conn.commit();
    respond(cb, results);
  } catch (err) {
    await conn.rollback();
    console.error(`[ghmattimysql] transaction error: ${err.message}`);
    respond(cb, []);
  } finally {
    conn.release();
  }
});

exports('store', async (query, cb) => {
  try {
    const [rows] = await pool.query(query);
    respond(cb, rows);
  } catch (err) {
    console.error(`[ghmattimysql] store error: ${err.message}`);
    respond(cb, []);
  }
});

// Minimal NUI handlers for compatibility
onNet('ghmattimysql:request-server-status', (src) => {
  emitNet('ghmattimysql:update-status', src, { connected: true });
});

onNet('ghmattimysql:request-data', (src) => {
  emitNet('ghmattimysql:update-resource-data', src, {});
  emitNet('ghmattimysql:update-time-data', src, {});
  emitNet('ghmattimysql:update-slow-queries', src, {});
});

onNet('ghmattimysql:request-table-schema', async (src, tableName) => {
  try {
    const [rows] = await pool.query(`DESCRIBE \`${tableName}\``);
    emitNet('ghmattimysql:get-table-schema', src, tableName, rows);
  } catch (err) {
    console.error(`[ghmattimysql] schema error: ${err.message}`);
    emitNet('ghmattimysql:get-table-schema', src, tableName, []);
  }
});

