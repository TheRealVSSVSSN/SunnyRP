import Redlock from 'redlock';
import { getRedis } from '../bootstrap/redis.js';
import metrics from './metrics.js';

let redlock = null;
function getLock() {
    const r = getRedis();
    if (!r) return null;
    if (redlock) return redlock;
    redlock = new Redlock([r], { retryCount: 3, retryDelay: 150 });
    return redlock;
}

/** withLock('srp:lock:ledger:21', async()=>{ ... }) */
export async function withLock(key, ttlMs, fn) {
    const rl = getLock();
    if (!rl) {
        // Fallback: naive single-instance lock
        metrics.lockFallback.inc();
        return await fn();
    }
    const start = Date.now();
    const lock = await rl.acquire([key], Number(process.env.LOCK_TTL_MS || ttlMs)).catch(() => null);
    if (!lock) { metrics.lockFailed.inc({ type: 'acquire' }); throw new Error('LOCKED'); }
    metrics.lockAcquired.inc({ type: 'acquire' });
    try { return await fn(); }
    finally {
        await lock.release().catch(() => null);
        metrics.lockReleased.inc();
        metrics.lockHold.observe(Date.now() - start);
    }
}