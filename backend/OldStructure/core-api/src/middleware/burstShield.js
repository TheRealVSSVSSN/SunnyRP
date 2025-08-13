import metrics from '../utils/metrics.js';
const WINDOW = Number(process.env.BURST_WINDOW_MS || 10000);
const MAX = Number(process.env.BURST_MAX_PER_WINDOW || 240);

const buckets = new Map(); // key -> { count, resetAt }

function allow(key) {
    const now = Date.now();
    let b = buckets.get(key);
    if (!b || now >= b.resetAt) {
        b = { count: 0, resetAt: now + WINDOW };
        buckets.set(key, b);
    }
    b.count++;
    if (b.count > MAX) return false;
    return true;
}

export default function burstShield(req, res, next) {
    const user = req.header('X-SRP-UserId') || '0';
    const char = req.header('X-SRP-CharId') || '0';
    const key = `${user}:${char}:${req.path}`;
    if (!allow(key)) {
        metrics.rateBlocked.inc();
        return res.status(429).json({ ok: false, error: 'RATE_LIMITED' });
    }
    next();
}