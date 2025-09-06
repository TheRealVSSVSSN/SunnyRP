const store = new Map();

export function idempotency(req, res) {
  const key = req.headers['idempotency-key'];
  if (!key) return true;
  if (store.has(key)) {
    const cached = store.get(key);
    res.writeHead(cached.status, { 'Content-Type': 'application/json' });
    res.end(cached.body);
    return false;
  }
  req.idempotencyKey = key;
  return true;
}

export function saveIdempotency(req, res, body) {
  if (req.idempotencyKey) {
    store.set(req.idempotencyKey, { status: res.statusCode, body });
  }
}
