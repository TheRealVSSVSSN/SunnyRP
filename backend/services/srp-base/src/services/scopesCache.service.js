// src/services/scopesCache.service.js
import { env } from '../config/env.js';
import { getScopes } from '../repositories/identity.repo.js';

const store = new Map(); // userId -> { scopes: string[], expires: number }

export async function getUserScopesCached(userId) {
    const now = Date.now();
    const hit = store.get(String(userId));
    if (hit && hit.expires > now) {
        return hit.scopes;
    }
    const scopes = await getScopes(userId);
    store.set(String(userId), {
        scopes,
        expires: now + env.SCOPES_CACHE_TTL_SEC * 1000
    });
    return scopes;
}

export async function invalidateScopesCache(userId = null) {
    if (!userId) {
        store.clear();
        return;
    }
    store.delete(String(userId));
}