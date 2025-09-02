import { createHash, timingSafeEqual } from 'crypto';
import { query } from '../db/index.js';

export async function verifyCredentials(username, password) {
  const rows = await query('SELECT id, password_hash FROM accounts WHERE username = ?', [username]);
  if (!rows[0]) return null;
  const hash = createHash('sha256').update(password).digest('hex');
  const dbHash = rows[0].password_hash;
  const match = timingSafeEqual(Buffer.from(hash), Buffer.from(dbHash));
  return match ? rows[0].id : null;
}

export async function insertRefreshToken(accountId, token, expiresAt) {
  await query(
    'INSERT INTO auth_tokens (account_id, token, expires_at) VALUES (?, ?, ?)',
    [accountId, token, expiresAt]
  );
}

export async function rotateRefreshToken(oldToken, newToken, expiresAt) {
  const rows = await query(
    'SELECT account_id FROM auth_tokens WHERE token = ? AND expires_at > NOW()',
    [oldToken]
  );
  if (!rows[0]) return null;
  await query(
    'UPDATE auth_tokens SET token = ?, expires_at = ? WHERE token = ?',
    [newToken, expiresAt, oldToken]
  );
  return rows[0].account_id;
}
