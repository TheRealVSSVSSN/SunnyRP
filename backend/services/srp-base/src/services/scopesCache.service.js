// src/services/scopesCache.service.js
import { env } from '../config/env.js';
import { getScopes } from '../repositories/identity.repo.js';
import { createClient } from 'redis';

const memory = new Map(); // userId -> { scopes: string[], expires: number }
let redis = null;

async function ensureRedis() {
    if (!env.SCOPES_CACHE_USE_REDIS || !env.REDIS_URL) return null;
    if (!redis) {
        redis = createClient({ url: env.REDIS_URL });
        await redis.connect();
    }
    return redis;
}

export async function getUserScopesCached(userId) {
    const now = Date.now();

    // Redis path
    const r = await ensureRedis();
    if (r) {
        const key = `scopes:${userId}`;
        const cached = await r.get(key);
        if (cached) {
            try {
                return JSON.parse(cached);
            } catch (_) { }
        }
        const scopes = await getScopes(userId);
        await r.setEx(key, env.SCOPES_CACHE_TTL_SEC, JSON.stringify(scopes));
        return scopes;
    }

    // In-memory fallback
    const hit = memory.get(String(userId));
    if (hit && hit.expires > now) {
        return hit.scopes;
    }
    const scopes = await getScopes(userId);
    memory.set(String(userId), {
        scopes,
        expires: now + env.SCOPES_CACHE_TTL_SEC * 1000
    });
    return scopes;
}

export async function invalidateScopesCache(userId = null) {
    const r = await ensureRedis();
    if (r) {
        if (userId) {
            await r.del(`scopes:${userId}`);
            return;
        }
        // clear all scopes:* keys
        for await (const key of r.scanIterator({ MATCH: 'scopes:*', COUNT: 100 })) {
            await r.del(key);
        }
        return;
    }

    // in-memory
    if (!userId) {
        memory.clear();
    } else {
        memory.delete(String(userId));
    }
}