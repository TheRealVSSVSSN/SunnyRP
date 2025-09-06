const hits = new Map();
const WINDOW = 60_000;
const LIMIT = 100;

export async function rateLimit(req, res) {
  const ip = req.socket.remoteAddress || 'unknown';
  const now = Date.now();
  let record = hits.get(ip);
  if (!record || now > record.reset) {
    record = { count: 0, reset: now + WINDOW };
    hits.set(ip, record);
  }
  record.count++;
  if (record.count > LIMIT) {
    const err = new Error('rate_limit');
    err.status = 429;
    err.retryAfter = Math.ceil((record.reset - now) / 1000);
    throw err;
  }
}
