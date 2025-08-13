import { z } from 'zod';

const schema = z.object({
    NODE_ENV: z.string().default('development'),
    PORT: z.coerce.number().default(3301),
    API_TOKEN: z.string().min(8, 'API_TOKEN must be set'),
    ALLOWLIST_IPS: z.string().optional(),
    LOG_JSON: z.string().default('true'),
    LOG_LEVEL: z.string().default('info'),
    LOG_DIR: z.string().default('./logs'),
    REQUEST_RATE_WINDOW_MS: z.coerce.number().default(60000),
    REQUEST_RATE_MAX: z.coerce.number().default(600),
    METRICS_USERNAME: z.string().optional(),
    METRICS_PASSWORD: z.string().optional(),
    DB_HOST: z.string(),
    DB_PORT: z.coerce.number().default(3306),
    DB_USER: z.string(),
    DB_PASSWORD: z.string(),
    DB_NAME: z.string(),
    HMAC_SECRET: z.string().optional(),
    SRP_SALES_TAX_BASE: process.env.SRP_SALES_TAX_BASE || '0.0725',
    SRP_SALES_TAX_DIST: process.env.SRP_SALES_TAX_DIST || '0.0',
    SRP_CASDI_RATE: process.env.SRP_CASDI_RATE || '0.012',
    SRP_PAY_PERIOD: process.env.SRP_PAY_PERIOD || 'weekly',
});

export function loadEnv(raw = process.env) {
    const parsed = schema.safeParse(raw);
    if (!parsed.success) {
        console.error('Invalid environment:', parsed.error.flatten().fieldErrors);
        process.exit(1);
    }
    return parsed.data;
}