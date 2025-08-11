# Sunny Roleplay (SRP) — Phase A

This repo is the foundation for **Sunny Roleplay** (SRP), a fully custom FiveM framework and Node.js microservices stack.  
**Phase A goal**: Run `backend/core-api`, boot `resources/sunnyrp/base`, expose health/metrics, read ConVars/feature flags, and prove server→backend communication.

## Monorepo Structure
- `backend/core-api`: Express REST service with health/ready/metrics, env schema validation, PM2, logs, MySQL + Knex migrations
- `resources/sunnyrp/base`: SRP base framework for FiveM (server-authoritative HTTP wrapper, identifiers, event bus, NUI bridge)
- `server.cfg`: FXServer config including SRP ConVars
- `.env.example`: Core API environment template

## Quick Start

### 1) Backend (Core API)
```bash
cd backend/core-api
cp ../../.env.example .env   # or set values manually
# Edit .env for DB credentials and API_TOKEN
npm i
npm run migrate:latest
npm run start  # or npm run pm2

Verify:

GET http://127.0.0.1:3301/health → 200

GET http://127.0.0.1:3301/ready with header X-API-Token: <API_TOKEN> → 200

GET http://127.0.0.1:3301/metrics with token → Prometheus text

2) FiveM Side
Place resources/sunnyrp/base into your server’s resources/ folder (this repo already has it).

Use the provided server.cfg or add:

setr srp_api_url "http://127.0.0.1:3301"
setr srp_api_token "changeme_please"
setr srp_features "players,characters,inventory"
setr srp_primary_identifier "license"
setr srp_required_identifiers "license,discord"
setr srp_http_timeout_ms "5000"
setr srp_http_retries "3"
ensure sunnyrp-base

Start FXServer. You should see SRP Base boot logs, and a successful /health probe.

Definition of Done (Phase A)
FXServer boots sunnyrp/base cleanly (no warnings).

SRP.Fetch reaches /health and logs success.

/metrics is visible; counters increase when calling endpoints.

ConVars & feature flags are available via SRP.Features.IsEnabled.

DB migrations run; /ready returns 200 only when DB reachable.

Security Model (Phase A)
Every backend call requires X-API-Token.

Optional IP allowlist can be enabled via ALLOWLIST_IPS.

Optional HMAC signing exists in the code; set HMAC_SECRET later (Phase B+).

Next Phases
Phase B: custom chat, spawn manager, map manager

Phase C: accounts + inventory, etc.


---

## Core‑API Documentation

### Endpoints
- `GET /health` (public)
  - Response: `{ ok:true, data:{ status:'ok', time, uptime, version } }`
- `GET /ready` (protected: `X-API-Token`)
  - Response 200: `{ ok:true, data:{ status:'ready', db:'ok' } }`
  - Response 503: `{ ok:false, error:{ code:'NOT_READY', message:'DB unreachable' } }`
- `GET /metrics` (protected: `X-API-Token`)
  - Prometheus exposition text

### Headers
- `X-API-Token: <token>`
- `X-Request-Id` (optional; generated if absent)

### Environment (.env)
- **API_TOKEN** (required) — secure shared token
- **ALLOWLIST_IPS** (comma-separated) — optional
- **DB_*** — configure MySQL
- **LOG_JSON**, **LOG_LEVEL**, **LOG_DIR**
- **REQUEST_RATE_WINDOW_MS**, **REQUEST_RATE_MAX**
- **HMAC_SECRET** (optional for request signing in later phases)

### Ops
- Run with PM2: `npm run pm2`
- Logs in `logs/` directory (rotating handled by PM2 + file system rotation policy)

---

## SRP Base Documentation

### Global Singleton
All functions live on `SRP`:

```lua
SRP.Fetch(opts)                 -- server HTTP wrapper with retries
SRP.On(event, callback)         -- internal event bus subscribe
SRP.Emit(event, payload)        -- internal emit
SRP.GetAllIdentifiers(src)      -- map of all identifiers (license/discord/steam/...)
SRP.GetPrimaryIdentifier(src)   -- primary id string, plus all map
SRP.Features.IsEnabled(name)    -- feature flags from ConVars
SRP.Info/Warn/Error(msg, data)  -- logging helpers

local res = SRP.Fetch({ path = '/health' })
if res and res.status == 200 then
  SRP.Info('Core API OK')
end

ConVars
srp_api_url, srp_api_token

srp_features (CSV)

srp_primary_identifier

srp_required_identifiers (CSV)

srp_http_timeout_ms, srp_http_retries

srp_log_level

NUI Bridge
SendNUIMessage({ type='hello', payload='...' })

RegisterNUICallback('name', function(data, cb) ... end)

Phase A includes a tiny NUI to test callbacks (toggle with F10).

Postman & OpenAPI
Import backend/core-api/postman/sunny-core-api.postman_collection.json

OpenAPI stub in backend/core-api/openapi/api.yaml (Phase A subset).
We will expand endpoint documentation per phase.

Migrations Tooling
Uses Knex with mysql2.

Commands:

npm run migrate:latest (apply all)

npm run migrate:rollback (rollback last batch)

Tables created in Phase A:

players, player_identifiers, characters, audit_log

What’s Proven in Phase A
FiveM → Node: SRP.Fetch reaches /health

DB health gating: /ready depends on MySQL connectivity

Metrics: Prometheus middleware exposes counters/histograms

Config: ConVars -> SRP.Config & feature flags

README — Phase B quick doc (append)
Phase B — Identity & Permissions
Goal: Create users on connect, link all identifiers, enforce bans, and cache roles/scopes for ACL decisions.

DB (new)
users, user_identifiers

roles, role_scopes, user_roles

overrides (allow/deny per user)

bans

audit

Run:

bash
Copy
Edit
cd backend/core-api
npm run migrate:latest
API
POST /players/link — upsert by identifiers, update last_seen_at & IP, return { user, roles, scopes, banned }

GET /players/:userId — user + identifiers

GET /permissions/:userId — effective { roles, scopes, overrides }

POST /permissions/grant — body { userId, type:'role'|'scope', roleName?, scope?, allow? }

DELETE /permissions/grant — revoke

POST /admin/ban — body { userId, reason, minutes|null, actorId? }

POST /admin/kick — records audit (FiveM actually kicks)

GET /admin/audit?userId=&limit=

FiveM flow
On playerConnecting (deferrals):

Collect all identifiers + IP

POST /players/link

If banned → reject with reason

GET /permissions/:userId → cache roles/scopes/overrides

Use SRP.ACL.HasScope(src, scope) or SRP.ACL.Enforce(src, scope) in any server event.

Definition of Done
Reconnecting user updates last_seen_at and last_ip (verify via /players/:id).

Banned user gets rejected in deferrals with reason/duration.

GET /permissions/:userId returns roles/scopes/overrides and are cached server-side.

Sample ACL (srp:sample:restricted) requires srp.sample.use and drops player if missing.