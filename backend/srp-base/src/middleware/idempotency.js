import { claimKey } from '../repositories/idempotency.js';

export async function idempotency(req, res, next) {
  if (req.method === 'GET') return next();
  const key = req.get('Idempotency-Key');
  if (!key) return res.status(400).json({ error: 'Missing Idempotency-Key' });
  try {
    const ok = await claimKey(key);
    if (!ok) return res.status(409).json({ error: 'Duplicate request' });
    next();
  } catch (err) {
    next(err);
  }
}