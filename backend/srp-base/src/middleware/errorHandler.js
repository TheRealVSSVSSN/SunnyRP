import { logger } from '../util/logger.js';

export function errorHandler(err, req, res, next) {
  logger.error({ err, reqId: req.id }, 'request error');
  const status = err.status || 500;
  res.status(status).json({ error: err.message || 'Internal error' });
}
