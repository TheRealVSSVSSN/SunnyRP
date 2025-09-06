export function errorHandler(err, req, res) {
  const status = err.status || 500;
  if (!res.headersSent) {
    const headers = { 'Content-Type': 'application/json' };
    if (err.retryAfter) headers['Retry-After'] = err.retryAfter;
    res.writeHead(status, headers);
  }
  res.end(JSON.stringify({ error: err.message || 'internal_error' }));
}
