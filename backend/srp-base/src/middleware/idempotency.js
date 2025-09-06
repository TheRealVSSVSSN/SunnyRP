const store = new Map();

module.exports = function idempotency(req, res, next) {
  if (!['POST', 'DELETE'].includes(req.method)) return next();
  const key = req.headers['idempotency-key'];
  if (!key) return res.status(400).json({ error: 'missing_idempotency_key' });
  if (store.has(key)) {
    const cached = store.get(key);
    res.status(cached.status);
    for (const [h, v] of Object.entries(cached.headers)) res.setHeader(h, v);
    return res.json(cached.body);
  }
  res.locals.idempotencyKey = key;
  const original = res.json.bind(res);
  res.json = (body) => {
    store.set(key, { status: res.statusCode, body, headers: res.getHeaders() });
    return original(body);
  };
  next();
};
