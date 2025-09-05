import jwt from 'jsonwebtoken';
import { logger } from '../util/logger.js';
import { getAccountScopes, getAccountRoles } from '../repositories/roles.js';

export async function authToken(req, res, next) {
  const header = req.get('Authorization');
  if (!header) return res.status(401).json({ error: 'Missing Authorization header' });
  const [scheme, token] = header.split(' ');
  if (scheme !== 'Bearer' || !token) {
    return res.status(401).json({ error: 'Malformed Authorization header' });
  }
  try {
    const secret = process.env.JWT_SECRET;
    const payload = jwt.verify(token, secret);
    const [dbScopes, dbRoles] = await Promise.all([
      getAccountScopes(payload.accountId),
      getAccountRoles(payload.accountId)
    ]);
    req.auth = {
      ...payload,
      scopes: Array.from(new Set([...(payload.scopes || []), ...dbScopes])),
      roles: dbRoles.map(r => r.name)
    };
    next();
  } catch (err) {
    logger.warn({ err }, 'token verification failed');
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({ error: 'Token expired' });
    }
    return res.status(401).json({ error: 'Invalid token' });
  }
}

export function requireScope(scope) {
  return (req, res, next) => {
    const scopes = req.auth?.scopes || [];
    if (!scopes.includes(scope)) return res.status(403).json({ error: 'Insufficient scope' });
    next();
  };
}
