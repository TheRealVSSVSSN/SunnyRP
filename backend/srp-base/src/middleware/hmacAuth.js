import crypto from 'crypto';

export function hmacAuth(req, env) {
  const key = req.headers['x-srp-internal-key'] || '';
  const secret = env.SRP_INTERNAL_KEY || 'change_me';
  const keyBuf = Buffer.from(key);
  const secretBuf = Buffer.from(secret);
  const valid = keyBuf.length === secretBuf.length && crypto.timingSafeEqual(keyBuf, secretBuf);
  if (!valid) {
    const err = new Error('unauthorized');
    err.status = 401;
    throw err;
  }
}
