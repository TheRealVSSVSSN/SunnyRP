// src/middleware/authToken.js
import { fail } from '../utils/respond.js';

/**
 * Requires X-API-Token on every request (FiveM server -> API).
 */
export function authToken(secret) {
  return (req, res, next) => {
    const token = req.header('X-API-Token');
    if (!token || token !== secret) {
      return fail(req, res, 'UNAUTHENTICATED', 'Missing/invalid token');
    }
    next();
  };
}