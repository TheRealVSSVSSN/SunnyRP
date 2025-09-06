import { randomUUID } from 'crypto';

export async function requestId(req, res) {
  const id = req.headers['x-request-id'] || randomUUID();
  req.id = id;
  res.setHeader('X-Request-Id', id);
}
