// src/config/env.js
import { z } from 'zod';

const Schema = z.object({
    NODE_ENV: z.string().default('development'),
    PORT: z.coerce.number().default(3301),
    API_TOKEN: z.string().min(8),

    ENABLE_REPLAY_GUARD: z.coerce.boolean().default(true),
    REPLAY_ALLOWED_SKEW_SECONDS: z.coerce.number().default(90),
    REDIS_URL: z.string().optional(),

    ENABLE_METRICS: z.coerce.boolean().default(true),
    LOG_LEVEL: z.string().default('info'),

    // MySQL
    DB_HOST: z.string(),
    DB_PORT: z.coerce.number().default(3306),
    DB_USER: z.string(),
    DB_PASSWORD: z.string(),
    DB_NAME: z.string(),
    DB_CONN_LIMIT: z.coerce.number().default(10)
});

export const env = Object.freeze(Schema.parse(process.env));