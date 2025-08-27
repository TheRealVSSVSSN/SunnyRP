const dotenv = require('dotenv');

// Load environment variables from a .env file if present.  This helper is
// intentionally lightweight – it does not perform any file existence checks
// because dotenv silently ignores missing files.
dotenv.config();

/**
 * Centralised configuration for the srp-base service.  All runtime
 * tunables are exposed here with sane defaults.  Service authors
 * should avoid pulling values directly from process.env outside of
 * this module.  Instead depend on the exported object so that
 * configuration is explicit and testable.
 */
const config = {
  /**
   * The port on which the HTTP server will listen.  Defaults to 3010.
   */
  port: parseInt(process.env.PORT || '3010', 10),

  /**
   * Static API token used to authenticate callers.  Every incoming
   * request must supply this token via the X‑API‑Token header.  Absence
   * or mismatch will result in an UNAUTHENTICATED error.  This token
   * should be long and random.  The default value is undefined and
   * service startup will fail if it is missing.
   */
  apiToken: process.env.API_TOKEN,

  /**
   * Replay guard/HMAC support.  When enabled the service expects
   * callers to supply a timestamp (X‑Ts), nonce (X‑Nonce) and
   * signature (X‑Sig) header for certain routes.  The signature is
   * verified using a shared secret.  Replay windows are enforced
   * based on the configured TTL (in seconds).  Disabled by default.
   */
  enableReplayGuard: process.env.ENABLE_REPLAY_GUARD === '1',
  replayTtl: parseInt(process.env.REPLAY_TTL_SEC || '90', 10),
  hmacSecret: process.env.HMAC_SECRET || '',
  hmacStyle: process.env.HMAC_STYLE || 'newline',

  /**
   * IP allowlist.  When enabled only the addresses in ipAllowlist will
   * be permitted to make requests.  Useful when exposing the API
   * behind a reverse proxy or for inter‑service calls.
   */
  enableIpAllowlist: process.env.ENABLE_IP_ALLOWLIST === '1',
  ipAllowlist: (process.env.IP_ALLOWLIST || '')
    .split(',')
    .map((cidr) => cidr.trim())
    .filter(Boolean),

  /**
   * Metrics exporter.  When enabled the service registers Prometheus
   * metrics and exposes them via GET /metrics.  Disabled by default.
   */
  enableMetrics: process.env.ENABLE_METRICS === '1',

  /** WebSocket heartbeat interval in milliseconds. */
  wsHeartbeatIntervalMs: parseInt(process.env.WS_HEARTBEAT_INTERVAL_MS || '30000', 10),

  /**
   * Webhook dispatch configuration.
   */
  webhook: {
    retryBaseMs: parseInt(process.env.WEBHOOK_RETRY_BASE_MS || '500', 10),
    maxRetries: parseInt(process.env.WEBHOOK_MAX_RETRIES || '5', 10),
    discord: {
      enabled: process.env.WEBHOOK_DISCORD_ENABLED === '1',
      url: process.env.WEBHOOK_DISCORD_URL || '',
      secret: process.env.WEBHOOK_DISCORD_SECRET || '',
    },
  },
  interactSound: { retentionMs: parseInt(process.env.INTERACT_SOUND_RETENTION_MS || '604800000', 10) },
  dispatch: { retentionMs: parseInt(process.env.DISPATCH_ALERT_RETENTION_MS || '86400000', 10) },
  baseEvents: { retentionMs: parseInt(process.env.BASE_EVENT_RETENTION_MS || '2592000000', 10) },
  assets: { retentionMs: parseInt(process.env.ASSET_RETENTION_MS || '2592000000', 10) },
  chat: { retentionMs: parseInt(process.env.CHAT_RETENTION_MS || '604800000', 10) },
  camera: {
    retentionMs: parseInt(process.env.CAMERA_RETENTION_MS || '2592000000', 10),
    cleanupIntervalMs: parseInt(process.env.CAMERA_CLEANUP_INTERVAL_MS || '3600000', 10),
  },
  invoiceRetentionMs: parseInt(process.env.INVOICE_RETENTION_MS || '2592000000', 10),
  emotes: { retentionMs: parseInt(process.env.EMOTE_RETENTION_MS || '15552000000', 10) },
  ems: {
    broadcastIntervalMs: parseInt(process.env.EMS_BROADCAST_INTERVAL_MS || '60000', 10),
    maxShiftDurationMs: parseInt(
      process.env.EMS_MAX_SHIFT_DURATION_MS || String(12 * 60 * 60 * 1000),
      10,
    ),
  },
  taxi: {
    requestTtlMs: parseInt(process.env.TAXI_REQUEST_TTL_MS || '300000', 10),
  },

  /**
   * Feature flags for core modules.  Lua consumers still drive
   * behaviour via /v1/config/live, but these flags provide a safe
   * fallback when live config is unavailable.  Each flag defaults
   * to true, meaning the corresponding module is enabled unless
   * explicitly disabled via the environment.
   */
  features: {
    identity: process.env.FEATURE_IDENTITY !== '0',
    admin: process.env.FEATURE_ADMIN !== '0',
    permissions: process.env.FEATURE_PERMISSIONS !== '0',
    config: process.env.FEATURE_CONFIG !== '0',
    outbox: process.env.FEATURE_OUTBOX !== '0',
    users: process.env.FEATURE_USERS !== '0',
    characters: process.env.FEATURE_CHARACTERS !== '0',
    inventory: process.env.FEATURE_INVENTORY !== '0',
    economy: process.env.FEATURE_ECONOMY !== '0',
    vehicles: process.env.FEATURE_VEHICLES !== '0',
    world: process.env.FEATURE_WORLD !== '0',
    jobs: process.env.FEATURE_JOBS !== '0',
  },

  /**
   * Database connection configuration.  See src/repositories/db.js for
   * connection details.  Defaults to connecting to a local MySQL
   * instance on port 3306.  Note: credentials should be changed in
   * production and never committed to version control.
   */
  db: {
    host: process.env.DB_HOST || '127.0.0.1',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    name: process.env.DB_NAME || 'sunnyrp',
    user: process.env.DB_USER || 'sunnyrp',
    pass: process.env.DB_PASS || 'sunnyrp-password',
  },

  /**
   * Outbox configuration.  When enabled the service spools domain
   * events into an outbox table to guarantee delivery to external
   * consumers.  A separate worker is responsible for claiming and
   * delivering events.  Disabled by default.
   */
  enableOutboxWorker: process.env.ENABLE_OUTBOX_WORKER === '1',
  outboxBatchSize: parseInt(process.env.OUTBOX_BATCH_SIZE || '100', 10),
  outboxIntervalMs: parseInt(process.env.OUTBOX_INTERVAL_MS || '500', 10),
  outboxClaimTimeoutSec: parseInt(process.env.OUTBOX_CLAIM_TIMEOUT_SEC || '30', 10),
  outboxDeliveryUrl: process.env.OUTBOX_DELIVERY_URL || '',
  outboxRedisChannelPrefix: process.env.OUTBOX_REDIS_CHANNEL_PREFIX || '',
  redisUrl: process.env.REDIS_URL || '',
};

// Validate required properties on startup.  Throwing here causes
// immediate failure, preventing the server from starting with an
// invalid configuration.
if (!config.apiToken) {
  throw new Error('API_TOKEN environment variable must be provided');
}

module.exports = config;