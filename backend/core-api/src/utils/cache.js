import { getRedis } from '../bootstrap/redis.js';
import metrics from './metrics.js';

const mem = new Map(); // fallback
const ttlSec = Number(process.env.CACHE_TTL_SEC || 60);

export async function getJSON(key) {
    const r = getRedis();
    if (r) {
        const v = await r.get(key);
        if (v) { metrics.cacheHits.inc({ driver: 'redis' }); return JSON.parse(v); }
        metrics.cacheMisses.inc({ driver: 'redis' }); return null;
    }
    const it = mem.get(key);
    if (it && it.exp > Date.now()) { metrics.cacheHits.inc({ driver: 'memory' }); return it.val; }
    metrics.cacheMisses.inc({ driver: 'memory' }); return null;
}

export async function setJSON(key, val, ttl = ttlSec) {
    const r = getRedis();
    if (r) { await r.set(key, JSON.stringify(val), 'EX', Math.max(1, ttl)); return; }
    mem.set(key, { val, exp: Date.now() + ttl * 1000 });
}

export async function del(key) {
    const r = getRedis(); if (r) return r.del(key);
    mem.delete(key);
}

export const keys = {
    items: 'srp:cache:items',
    charInv: (charId) => `srp:cache:inv:${charId}`,
    perms: (userId) => `srp:cache:perms:${userId}`,
};