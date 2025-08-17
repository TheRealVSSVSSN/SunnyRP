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
  DB_CONN_LIMIT: z.coerce.number().default(10),

  // Rate limits
  RATE_LIMIT_WINDOW_SEC: z.coerce.number().default(60),
  RATE_LIMIT_MAX_BAN: z.coerce.number().default(10),
  RATE_LIMIT_MAX_PERMISSIONS: z.coerce.number().default(60),
  RATE_LIMIT_MAX_AUDIT_READ: z.coerce.number().default(120),
  RATE_LIMIT_MAX_ADMIN_READ: z.coerce.number().default(120),

  // IP allowlist
  ENABLE_IP_ALLOWLIST: z.coerce.boolean().default(false),
  ALLOWLIST_IPS: z.string().default('127.0.0.1,::1'),

  // Reverse proxy
  TRUST_PROXY: z.coerce.boolean().default(false),

  // Idempotency
  IDEMPOTENCY_TTL_SEC: z.coerce.number().default(600),

  // Live config
  ENABLE_CONFIG_WRITE: z.coerce.boolean().default(false),

  // Caches
  FEATURE_CACHE_TTL_SEC: z.coerce.number().default(10),
  SCOPES_CACHE_TTL_SEC: z.coerce.number().default(30),
  SCOPES_CACHE_USE_REDIS: z.coerce.boolean().default(true),

  // Outbox worker
  ENABLE_OUTBOX_WORKER: z.coerce.boolean().default(false),
  OUTBOX_BATCH_SIZE: z.coerce.number().default(50),
  OUTBOX_CLAIM_TIMEOUT_SEC: z.coerce.number().default(60),
  OUTBOX_INTERVAL_MS: z.coerce.number().default(1000),
  OUTBOX_DELIVERY_URL: z.string().optional(),
  OUTBOX_REDIS_CHANNEL_PREFIX: z.string().default('srp:outbox:'),

  // HTTP client
  HTTP_TIMEOUT_MS: z.coerce.number().default(3000),
  HTTP_RETRY_COUNT: z.coerce.number().default(2),

  // Service tokens (read-only)
  ENABLE_SERVICE_TOKENS: z.coerce.boolean().default(false),
  SERVICE_TOKENS: z.string().default(''),

  // NEW: Inter-service HMAC
  ENABLE_INTERNAL_HMAC: z.coerce.boolean().default(false),
  INTERNAL_HMAC_SECRET: z.string().default('change_me_internal_hmac'),
  INTERNAL_HMAC_TTL_SEC: z.coerce.number().default(90)
});

export const env = Object.freeze(Schema.parse(process.env));