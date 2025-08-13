import { loadEnv } from './env.js';
const env = loadEnv();

export const config = {
    env: env.NODE_ENV,
    port: env.PORT,
    apiToken: env.API_TOKEN,
    allowlist: (env.ALLOWLIST_IPS || '').split(',').map(s => s.trim()).filter(Boolean),
    log: {
        json: env.LOG_JSON === 'true',
        level: env.LOG_LEVEL,
        dir: env.LOG_DIR
    },
    rate: {
        windowMs: env.REQUEST_RATE_WINDOW_MS,
        max: env.REQUEST_RATE_MAX
    },
    metricsAuth: {
        user: env.METRICS_USERNAME || null,
        pass: env.METRICS_PASSWORD || null
    },
    db: {
        host: env.DB_HOST,
        port: env.DB_PORT,
        user: env.DB_USER,
        password: env.DB_PASSWORD,
        name: env.DB_NAME
    },
    hmac: {
        secret: env.HMAC_SECRET || null
    }
};