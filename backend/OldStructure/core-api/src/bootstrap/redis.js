import IORedis from 'ioredis';
import clc from 'cli-color';

let redis = null;
let isReady = false;

export function getRedis() {
    if (!process.env.REDIS_URL) return null;
    if (redis) return redis;
    redis = new IORedis(process.env.REDIS_URL, {
        lazyConnect: true,
        maxRetriesPerRequest: null,
        enableReadyCheck: true,
        retryStrategy: (times) => Math.min(times * 200, 5000),
    });
    redis.on('ready', () => { isReady = true; console.log(clc.green(`[redis] ready`)); });
    redis.on('error', (e) => { isReady = false; console.warn(clc.red(`[redis] ${e.message}`)); });
    redis.connect().catch(() => { /* handled by retryStrategy */ });
    return redis;
}
export function redisReady() { return !!(redis && isReady); }