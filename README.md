# SunnyRP — `srp-base` (Authoritative Backend)

`srp-base` is the **authoritative** Node.js service for SunnyRP. It owns **all persistence** and exposes a stable HTTP API consumed by the FiveM Lua resources (notably `resources/[sunnyrp]/sunnyrp-base`). Lua never touches the DB; it calls this service for user linking, permissions, config, users, and characters.

---

## Highlights

- **Authoritative persistence**: Users, characters, bans/permissions, config
- **Uniform envelope**  
  - Success → `{ ok: true, data, requestId, traceId }`  
  - Error → `{ ok: false, error:{ code, message, details? }, requestId, traceId }`
- **Security**: `X-API-Token` (required), optional HMAC replay guard (`X-Ts`, `X-Nonce`, `X-Sig`)
- **Resilience/ops**: Timeouts, metrics (`/metrics`), health (`/v1/healthz`), readiness (`/v1/ready`), structured logs
- **Feature flags** via `/v1/config/live`, pluggable with runtime `featureGate`
- **Idempotency & rate limits** on sensitive routes
- **Outbox** infrastructure included (routes + worker) for async delivery

---

## Repository Layout (service)
backend/services/srp-base/
├─ openapi/
│ └─ api.yaml
├─ pm2/
│ └─ ecosystem.config.js # (if present; add worker here when enabled)
├─ postman/
│ └─ srp-base.postman.json # collection (kept in sync with openapi)
├─ src/
│ ├─ app.js # Express app, middleware, router wiring
│ ├─ server.js # HTTP bootstrap
│ ├─ bootstrap/
│ │ └─ migrate.js # migration helper (if used)
│ ├─ config/
│ │ └─ env.js # env validation + defaults
│ ├─ middleware/ # auth, ids, replay guard, validation, etc.
│ ├─ repositories/ # db.js + domain repos (users, characters, ...)
│ ├─ routes/ # /v1/* routers (health, identity, config, ...)
│ ├─ services/ # features service, caches
│ ├─ utils/ # logger, respond, metrics, http client
│ ├─ workers/
│ │ └─ outbox.worker.js # optional worker
│ └─ migrations/ # 001..008_*.sql
└─ scripts/
└─ smoke.mjs # quick API smoke test


---

## API Overview

**Health & Ops**
- `GET /v1/healthz` — liveness
- `GET /v1/ready` — readiness (DB/Redis checks)
- `GET /metrics` — Prometheus metrics (if enabled)

**Config**
- `GET /v1/config/live` — live config + feature flags (consumed by Lua)

**Identity & Permissions**
- `POST /v1/players/link` — link FiveM identifiers; return ban/whitelist/scopes
- `GET /v1/permissions/:playerId` — RBAC scopes for actor

**Users**
- `GET /v1/users/exists?hex_id=...` — user existence
- `POST /v1/users` — create user (atomic)
- `GET /v1/users/:hex_id` — fetch user profile

**Characters**
- `GET /v1/characters?owner_hex=...` — list owner’s characters
- `POST /v1/characters` — create character (atomic: unique name + phone)
- `GET /v1/characters/:id` — get character
- `PATCH /v1/characters/:id` — update character (optional)

**Outbox**
- `POST /v1/outbox/enqueue` — enqueue async event (idempotent)

> See `openapi/api.yaml` for schemas (OpenAPI 3.0.3) and `postman/srp-base.postman.json`.

---

## Request/Response Envelope

**Success**
```json
{ "ok": true, "data": { /* payload */ }, "requestId": "uuid", "traceId": "trace" }

**Error**
```json
{
  "ok": false,
  "error": { "code": "INVALID_INPUT", "message": "Bad body", "details": { "fieldErrors": [] } },
  "requestId": "uuid",
  "traceId": "trace"
}

Error codes

INVALID_INPUT, UNAUTHENTICATED, FORBIDDEN, NOT_FOUND, CONFLICT,
FAILED_PRECONDITION, RATE_LIMITED, INTERNAL_ERROR, DEPENDENCY_DOWN

Security

Headers

X-API-Token — required on all requests (FiveM → API and inter-service)

Optional HMAC (if enabled in env/convars):

X-Ts — unix seconds

X-Nonce — UUID v4

X-Sig — signature of a canonical string over method/path/body/timestamp/nonce
Supported canonical styles:

newline: "ts\nnonce\nMETHOD\n/path\nrawBody" (default)

pipe: "METHOD|/path|rawBody|ts|nonce"

Window: configurable TTL (default ~90s) with nonce replay protection

CORS / IP allowlist

CORS enabled for FiveM host

Optional ENABLE_IP_ALLOWLIST with IP_ALLOWLIST CIDRs

Feature Flags

/v1/config/live returns:

{
  "features": {
    "identity": true,
    "admin": true,
    "permissions": true,
    "config": true,
    "outbox": true,
    "users": true,
    "characters": true
  },
  "settings": {
    "Time": { "hour": 12, "minute": 0, "freeze": false },
    "Weather": { "type": "EXTRASUNNY", "dynamic": false }
  }
}

Routers are guarded at runtime by featureGate('<name>').

Database

Engine: MySQL 8+ (InnoDB, utf8mb4)

Migrations (partial list)

001_init.sql … 007_users_softdelete.sql (existing)

008_characters.sql — creates characters:

Columns: id, owner_hex, first_name, last_name, dob, gender, phone_number, story, created_at

Indexes: uniq_character_name (first_name, last_name), uniq_phone (phone_number), idx_owner_hex (owner_hex)

Users (expected columns)

hex_id (PK unique), name, rank, steam_id, license, discord, community_id, created_at

If your existing schema differs, align repo SQL and repos accordingly.

Install & Run
Prereqs

Node.js LTS (≥18)

MySQL 8+

(Optional) Redis for some features / outbox

Env (.env)

PORT=3010
API_TOKEN=CHANGE-ME
TRUST_PROXY=1

DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=sunnyrp
DB_USER=sunnyrp
DB_PASS=sunnyrp-password

# Security
ENABLE_REPLAY_GUARD=0
REPLAY_TTL_SEC=90
ENABLE_IP_ALLOWLIST=0
IP_ALLOWLIST=127.0.0.1/32

# Metrics
ENABLE_METRICS=1

# Feature fallbacks (live config still authoritative)
FEATURE_USERS=1
FEATURE_CHARACTERS=1

# Optional
REDIS_URL=

Service

cd backend/services/srp-base
npm ci

# Migrations (choose one)
node src/bootstrap/migrate.js           # if script exists and is wired
# OR: apply SQL in src/migrations/ manually in order

# Run (dev)
node src/server.js

# PM2 (if you use it)
pm2 start pm2/ecosystem.config.js --only srp-base

Outbox worker: when enabled via env (ENABLE_OUTBOX_WORKER=1), wire workers/outbox.worker.js into PM2 as a separate process. Configure OUTBOX_* & REDIS_URL as needed.

Lua Integration (consumers)

ConVars (FiveM server.cfg)

set srp_api_base_url "http://127.0.0.1:3010"
set srp_api_token "CHANGE-ME"
set srp_api_timeout_ms "5000"
set srp_api_retries "1"

# Optional HMAC (default canonical style is 'newline')
set srp_api_hmac_enabled "0"
set srp_api_hmac_secret ""
set srp_api_hmac_style "newline"

# Live config poll
set srp_feature_config_sync_enabled "1"
set srp_config_poll_ms "10000"

Expected Lua flows (from sunnyrp-base)

On connect/deferral:

POST /v1/players/link to validate & fetch ban/whitelist/scopes

Ensure user exists via /v1/users/exists → POST /v1/users (if missing)

Permissions:

GET /v1/permissions/:playerId (short-lived cache in Lua)

Config:

Poll GET /v1/config/live and broadcast world time/weather

Characters:

List/create via /v1/characters endpoints. No Lua SQL

Curl Smoke

API="http://127.0.0.1:3010"
TOKEN="CHANGE-ME"
HEX="license:test$(date +%s)"

curl -sS -H "X-API-Token: $TOKEN" "$API/v1/healthz" | jq

curl -sS -H "X-API-Token: $TOKEN" "$API/v1/users/exists?hex_id=$HEX" | jq

curl -sS -H "X-API-Token: $TOKEN" -H "Content-Type: application/json" \
  -d "{\"hex_id\":\"$HEX\",\"name\":\"Test User\",\"identifiers\":[{\"type\":\"license\",\"value\":\"$HEX\"}]}" \
  "$API/v1/users" | jq

curl -sS -H "X-API-Token: $TOKEN" "$API/v1/users/$HEX" | jq

curl -sS -H "X-API-Token: $TOKEN" -H "Content-Type: application/json" \
  -d "{\"owner_hex\":\"$HEX\",\"first_name\":\"Jordan\",\"last_name\":\"Avery\"}" \
  "$API/v1/characters" | jq

curl -sS -H "X-API-Token: $TOKEN" "$API/v1/characters?owner_hex=$HEX" | jq

Or:

BASE_URL=$API API_TOKEN=$TOKEN node scripts/smoke.mjs

Rate Limiting & Idempotency

Rate limiting: applied to sensitive admin routes and reads (window, max via env; Redis-backed or in-memory fallback).

Idempotency: Idempotency-Key supported on mutating routes; Redis-backed or in-memory fallback to deduplicate.

Outbox (Optional)

POST /v1/outbox/enqueue with idempotency supports async fanout

Worker claims batches with DB locks and delivers via HTTP and/or Redis channel (configurable)

Env (when using outbox)

ENABLE_OUTBOX_WORKER=1
OUTBOX_BATCH_SIZE=100
OUTBOX_INTERVAL_MS=500
OUTBOX_CLAIM_TIMEOUT_SEC=30
OUTBOX_DELIVERY_URL=
OUTBOX_REDIS_CHANNEL_PREFIX=
REDIS_URL=

Logging & Metrics

Logs: pino (requestId, traceId), sanitized errors

Metrics: GET /metrics Prometheus exporter (disabled/enabled via env)

Health: GET /v1/healthz (fast), Readiness: GET /v1/ready (checks DB/Redis)

Development Notes

Keep OpenAPI (openapi/api.yaml) in sync with routes

Postman collection mirrors routes (postman/srp-base.postman.json)

Prefer atomic server-side operations (e.g., character name uniqueness + phone allocation)

Maintain the uniform envelope and error code taxonomy

Troubleshooting
Symptom	Likely cause	Fix
401 UNAUTHENTICATED	Missing/invalid X-API-Token	Set correct token in Lua convar & server env
429 RATE_LIMITED	Hitting admin read/ban limits	Lower frequency or raise window/limit in env
FAILED_PRECONDITION creating character	Owner user missing	Ensure user exists first
HMAC signature mismatch	Canonical style/secret mismatch	Set srp_api_hmac_style and secret to match backend
Lua timeouts	API unreachable or wrong URL	Check srp_api_base_url, firewall, service port
Changelog (this phase)

Added Users + Characters routes and repos

Added 008_characters.sql migration

Added /v1/healthz alias in health router

Wired routers via src/app.js with feature gates

Provided scripts/smoke.mjs for quick validation

Confirmed /v1/config/live consumption by Lua config bus

Consolidated Lua HTTP helper (HMAC-ready), users/characters wrappers, deferrals & permissions

License

This project inherits the repository’s root license (LICENSE).