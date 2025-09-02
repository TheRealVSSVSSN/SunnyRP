import vm from 'vm';
import { pool } from '../db/index.js';

export async function logError({ service, level, message }) {
  const [result] = await pool.execute(
    'INSERT INTO error_logs (service, level, message, created_at) VALUES (?, ?, ?, NOW())',
    [service, level, message]
  );
  return { id: result.insertId, service, level, message, createdAt: new Date().toISOString() };
}

export async function getErrors(limit = 50) {
  const [rows] = await pool.execute(
    'SELECT id, service, level, message, created_at FROM error_logs ORDER BY id DESC LIMIT ?',
    [limit]
  );
  return rows.map(r => ({ id: r.id, service: r.service, level: r.level, message: r.message, createdAt: r.created_at }));
}

export async function purgeErrors(olderThanDays) {
  await pool.execute('DELETE FROM error_logs WHERE created_at < NOW() - INTERVAL ? DAY', [olderThanDays]);
}

export async function logRcon({ command, args }) {
  const [result] = await pool.execute(
    'INSERT INTO rcon_logs (command, args, created_at) VALUES (?, ?, NOW())',
    [command, args]
  );
  return { id: result.insertId };
}

export async function execCode(code) {
  let output = '';
  try {
    const script = new vm.Script(code);
    const result = script.runInNewContext({}, { timeout: 1000 });
    output = typeof result === 'string' ? result : JSON.stringify(result);
  } catch (err) {
    output = String(err);
  }
  const [res] = await pool.execute(
    'INSERT INTO exec_logs (code, output, created_at) VALUES (?, ?, NOW())',
    [code, output]
  );
  return { id: res.insertId, output };
}

export async function scheduleRestart(restartAt, reason) {
  await pool.execute(
    `INSERT INTO restart_schedule (id, restart_at, reason)
     VALUES (1, ?, ?)
     ON DUPLICATE KEY UPDATE restart_at = VALUES(restart_at), reason = VALUES(reason)`,
    [restartAt, reason]
  );
}

export async function getRestartSchedule() {
  const [rows] = await pool.execute(
    'SELECT restart_at AS restartAt, reason FROM restart_schedule WHERE id = 1'
  );
  return rows.length ? rows[0] : null;
}

export async function clearRestartSchedule() {
  await pool.execute('DELETE FROM restart_schedule WHERE id = 1');
}

export async function logDebug(message) {
  await pool.execute('INSERT INTO debug_logs (message, created_at) VALUES (?, NOW())', [message]);
}
