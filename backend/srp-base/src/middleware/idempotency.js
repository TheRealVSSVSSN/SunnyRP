// Updated: 2024-11-28
const store = new Map();

/**
 * Handles Idempotency-Key for POST requests.
 */
export function idempotency(req, res, next) {
  const key = req.get('Idempotency-Key');
  if (!key) return next();
  if (store.has(key)) {
    const cached = store.get(key);
    res.set(cached.headers);
    res.status(cached.status).send(cached.body);
    return;
  }
  req.idempotencyKey = key;
  next();
}

export function saveIdempotency(req, res, body) {
  if (req.idempotencyKey) {
    store.set(req.idempotencyKey, {
      status: res.statusCode,
      body,
      headers: res.getHeaders(),
    });
  }
}
