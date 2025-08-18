# SunnyRP — `srp-base` (Authoritative Backend, Node.js + MySQL)

`srp-base` is the **server‑authoritative** backend for the SunnyRP FiveM stack.  
All persistence (users, characters, permissions/RBAC, live config/feature flags, outbox events) is handled here; Lua never touches SQL directly. Other SunnyRP resources (inventory, jobs, economy, vehicles, world, telemetry, etc.) call this service over HTTP.

---

## Highlights
- **Authoritative persistence:** Node.js + MySQL for all game data — Lua is display/logic only.
- **Security:** Every request requires `X-API-Token`; optional HMAC replay guard (`X-Ts`, `X-Nonce`, `X-Sig`).
- **Consistency:** Uniform JSON envelopes for success & error; idempotency keys on mutating routes.
- **Resilience:** Rate limits, timeouts, health & readiness probes, Prometheus `/metrics`.
- **Config/Flags:** `/v1/config/live` broadcasts live world settings and feature flags.
- **Outbox pattern:** Async events fan‑out without blocking gameplay.
- **Docs:** OpenAPI 3 (`openapi/api.yaml`) and Postman collection slot (`postman/`).

---

## Repository Layout
```
openapi/            # OpenAPI 3.0 spec (api.yaml)
src/
  app.js           # Express app wiring
  server.js        # Bootstrap + metrics init
  bootstrap/
    migrate.js     # SQL migration runner
  config/
    env.js         # Env parsing/validation
  middleware/      # auth, hmac, idempotency, rate limit, requestId
  repositories/    # users, characters, permissions, outbox
  routes/          # health, config, users, characters, permissions, players, outbox, admin
  utils/           # logger, respond(), hmac helpers
  migrations/      # 001_init.sql (users, characters, permissions, outbox)
postman/           # Postman collection (optional)
scripts/           # smoke tests (optional)
```

---

## Prereqs
- Node.js LTS (≥ 18)
- MySQL 8+
- (Optional) Redis (distributed rate limits / idempotency / outbox)

---

## Environment (`.env`)
```
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

# Feature fallbacks (live config is authoritative)
FEATURE_USERS=1
FEATURE_CHARACTERS=1

# Optional (Redis / Outbox worker)
REDIS_URL=
ENABLE_OUTBOX_WORKER=0
OUTBOX_BATCH_SIZE=100
OUTBOX_INTERVAL_MS=500
OUTBOX_CLAIM_TIMEOUT_SEC=30
OUTBOX_DELIVERY_URL=
OUTBOX_REDIS_CHANNEL_PREFIX=
```

---

## Install & Run
```bash
# from backend/services/srp-base
npm ci

# migrate database
node src/bootstrap/migrate.js   # or run SQL in src/migrations/ manually

# dev run
node src/server.js

# production example (PM2)
pm2 start pm2/ecosystem.config.js --only srp-base
```
Liveness: `GET /v1/healthz`  
Readiness: `GET /v1/ready` (checks DB; returns 503 if down)  
Metrics: `GET /metrics` (when `ENABLE_METRICS=1`)

---

## Security Model
- **API Token** — All requests must include `X-API-Token: <API_TOKEN>`.
- **Optional HMAC Replay Guard** — For POST/PUT/PATCH/DELETE, send:
  - `X-Ts` (unix seconds), `X-Nonce` (uuid v4), `X-Sig` (HMAC‑SHA256 over canonical string).
  - Canonical styles supported: `newline` (`ts\\nnonce\\nMETHOD\\n/path\\nrawBody`) and `pipe` (`METHOD|/path|rawBody|ts|nonce`).
  - TTL window default: 90s; nonces are single‑use.
- **Rate Limiting** — Sensitive routes (e.g. admin ban) are limited; Redis recommended in multi‑instance.
- **Idempotency** — Mutating endpoints accept `X-Idempotency-Key` and return the original result on safe retries.

---

## Database Schema (001_init.sql)
- `users(hex_id PK, name, rank, steam_id, license, discord, community_id, created_at)`
- `permissions(id PK, player_id (hex), scope, granted_at)`
- `characters(id PK, owner_hex FK users, first_name, last_name, dob, gender, phone_number UNIQUE, story, created_at)`
- `outbox(id PK, topic, payload JSON, created_at, claimed_at, delivered_at, delivery_attempts)`

---

## API Overview (see OpenAPI for full details)
**Health & Ops**
- `GET /v1/healthz` — liveness
- `GET /v1/ready` — readiness (DB check)
- `GET /metrics` — Prometheus (if enabled)

**Config**
- `GET /v1/config/live` — feature flags + world settings (time/weather)
- `POST /v1/config/live` — update config (admin only)

**Identity & Permissions**
- `POST /v1/players/link` — validate identifiers; return ban/whitelist/scopes; create user on first seen
- `GET /v1/permissions/:playerId` — list scopes
- `POST /v1/permissions/grant` — grant scope
- `POST /v1/permissions/revoke` — revoke scope

**Users**
- `GET /v1/users/exists?hex_id=...` — does user exist
- `POST /v1/users` — create user `{ hex_id, name, identifiers[] }`
- `GET /v1/users/:hex_id` — fetch user

**Characters**
- `GET /v1/characters?owner_hex=...` — list owner’s chars
- `POST /v1/characters` — create character (unique name & phone enforced)
- `GET /v1/characters/:id` — get character
- `PATCH /v1/characters/:id` — update character (partial)

**Outbox**
- `POST /v1/outbox/enqueue` — enqueue `{ topic, payload }` (idempotent)

**Admin**
- `POST /v1/admin/ban` — ban a player `{ playerId, reason, until? }`

---

## FiveM Integration Quickstart
**server.cfg ConVars**
```
set srp_api_base_url "http://127.0.0.1:3010"
set srp_api_token "CHANGE-ME"
set srp_api_timeout_ms "5000"
set srp_api_retries "1"

# Optional HMAC
set srp_api_hmac_enabled "0"
set srp_api_hmac_secret ""
set srp_api_hmac_style "newline"

# Live config polling
set srp_feature_config_sync_enabled "1"
set srp_config_poll_ms "10000"
```

**Expected Lua flow on connect**
1) `POST /v1/players/link` (deferrals)  
2) `GET /v1/users/exists` → `POST /v1/users` if missing  
3) `GET /v1/permissions/:playerId` (cache briefly)  
4) Poll `GET /v1/config/live` and broadcast to clients

---

## Curl Smoke
```bash
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
```

---

## Development Notes
- Keep `openapi/api.yaml` in sync with the code.
- Prefer atomic server‑side ops (e.g. unique phone allocation in a single transaction).
- Preserve the uniform response envelope and error taxonomy.
- Add Postman collection updates alongside code changes.
- Use idempotency keys and rate limits for creation/admin routes.

---

## License
This service follows your repository’s root license.