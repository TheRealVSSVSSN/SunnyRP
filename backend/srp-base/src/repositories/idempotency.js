import { query } from '../db/index.js';

export async function claimKey(key, ttlSec = 600) {
  const res = await query(
    'INSERT IGNORE INTO idempotency_keys (`key`, expires_at) VALUES (?, DATE_ADD(NOW(), INTERVAL ? SECOND))',
    [key, ttlSec]
  );
  return res.affectedRows > 0;
}

export async function purgeExpired() {
  await query('DELETE FROM idempotency_keys WHERE expires_at < NOW()');
}
