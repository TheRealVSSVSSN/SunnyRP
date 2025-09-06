import crypto from 'crypto';

/**
 * Factory returning middleware validating X-SRP-Internal-Key header.
 */
export function hmacAuth(env) {
  const secret = env.SRP_INTERNAL_KEY || 'change_me';
  return function (req, res, next) {
    const key = req.get('X-SRP-Internal-Key') || '';
    const keyBuf = Buffer.from(key);
    const secretBuf = Buffer.from(secret);
    const valid =
      keyBuf.length === secretBuf.length && crypto.timingSafeEqual(keyBuf, secretBuf);
    if (!valid) {
      const err = new Error('unauthorized');
      err.status = 401;
      return next(err);
    }
    next();
  };
}
