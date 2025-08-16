// src/utils/httpClient.js
import crypto from 'crypto';
import { env } from '../config/env.js';

/**
 * Minimal HTTP client using fetch with timeout + retries for idempotent calls.
 */
export async function httpPostJson(url, body, { timeoutMs = env.HTTP_TIMEOUT_MS, retries = env.HTTP_RETRY_COUNT } = {}) {
    let lastErr;
    for (let attempt = 0; attempt <= retries; attempt++) {
        const controller = new AbortController();
        const timer = setTimeout(() => controller.abort(), timeoutMs);
        try {
            const res = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Request-Id': crypto.randomUUID()
                },
                body: JSON.stringify(body || {}),
                signal: controller.signal
            });
            clearTimeout(timer);
            if (!res.ok) {
                lastErr = new Error(`HTTP ${res.status}`);
                continue;
            }
            return res;
        } catch (e) {
            clearTimeout(timer);
            lastErr = e;
        }
    }
    throw lastErr || new Error('httpPostJson failed');
}