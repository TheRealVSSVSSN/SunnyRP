// Updated: 2024-11-28
/**
 * Express error handler emitting JSON responses.
 */
export function errorHandler(err, req, res, next) {
  const status = err.status || 500;
  const headers = { 'Content-Type': 'application/json' };
  if (err.retryAfter) headers['Retry-After'] = err.retryAfter;
  res.status(status).set(headers);
  res.json({ error: err.message || 'internal_error' });
}
