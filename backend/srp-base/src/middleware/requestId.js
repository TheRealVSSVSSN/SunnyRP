// Updated: 2024-11-28
import { randomUUID } from 'crypto';

/**
 * Express middleware that assigns a request identifier.
 */
export function requestId(req, res, next) {
  const id = req.get('X-Request-Id') || randomUUID();
  req.id = id;
  res.set('X-Request-Id', id);
  next();
}
