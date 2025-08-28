|  |  | Ban a player.  Body .  Persists to the bans table and returns ban status. |# SunnyRP Base API (srp-base) Documentation

This document provides a comprehensive overview of the `srp-base` microservice—the authoritative backend for the SunnyRP FiveM server.  It covers the service’s purpose, architecture, configuration, database schema, security model and endpoints, along with guidance for installation, deployment and integration with FiveM Lua resources.

## Purpose and Overview

The `srp-base` service owns **all persistence** for the SunnyRP platform: users, characters, bans, permissions, live configuration and asynchronous outbox events.  FiveM Lua resources consume its HTTP API rather than performing SQL queries directly.  This architecture enforces a clean separation of concerns: gameplay logic lives in Lua, while data storage and business rules live in Node.js【67730289104851†L0-L2】.  The service exposes a stable API consumed by `resources/[sunnyrp]/srp-base` and other domain‑specific resources (inventory, jobs, economy, vehicles, etc.).

Key design principles include:

* **Authoritative persistence:** All state is stored in MySQL; Lua never directly touches the database【67730289104851†L2-L10】.
* **Uniform response envelope:** Both successes and errors use a consistent JSON structure `{ ok, data | error, requestId, traceId }`【67730289104851†L8-L16】.
* **Security:** Every request requires an `X‑API‑Token` header, with optional HMAC replay protection via `X‑Ts`, `X‑Nonce` and `X‑Sig`【67730289104851†L103-L120】.
* **Resilience and observability:** The service provides health and readiness probes, Prometheus metrics, structured logging, rate limiting and idempotency on mutating endpoints【67730289104851†L12-L16】【67730289104851†L288-L292】.
* **Feature flags:** The `/v1/config/live` endpoint returns runtime feature toggles and world settings, allowing Lua to enable or disable modules dynamically【67730289104851†L128-L146】.
* **Outbox pattern:** Domain events can be enqueued for asynchronous processing and delivery to other services【67730289104851†L14-L16】【67730289104851†L294-L297】.

## Architecture

### Microservice Topology

SunnyRP adopts a **microservice per domain** approach: each high‑level FiveM resource (characters, inventory, economy, vehicles, jobs, permissions/admin, world, telemetry) has a paired Node.js service exposing its own API and database schema.  `srp-base` provides shared functionality (identity, permissions, bans, live configuration, outbox) and authentication for all other services.  Services communicate internally over HTTP with shared tokens/HMAC and propagate correlation IDs for tracing.

The directory structure in this repository reflects that design.  For `srp-base` the service code resides in `backend/services/srp-base` with the following layout【67730289104851†L20-L44】:

```
openapi/            # OpenAPI 3.0 specification (api.yaml)
src/
  app.js           # Express app wiring (middleware, routers)
  server.js        # HTTP bootstrap and metrics initialisation
  bootstrap/
    migrate.js     # Migration runner for database schema
  config/
    env.js         # Centralised env parsing/validation
  middleware/      # Authentication, rate limiting, idempotency, requestId
  repositories/    # DB access for users, characters, permissions, outbox
  routes/          # Express routers (health, config, identity, users, characters, permissions, outbox, admin)
  utils/           # Logger, HMAC helpers, response helpers
  migrations/      # SQL migrations (e.g. 001_init.sql)
postman/           # Postman collection (optional)
scripts/           # Smoke test script (optional)
```

Each domain service (e.g. `characters-api`, `inventory-api`) follows the same pattern, enabling consistent deployment and maintenance.

### Technology Stack

- **Node.js LTS (v18+)** and **Express** for HTTP routing.
- **MySQL 8+** with InnoDB and utf8mb4 character set for persistence【67730289104851†L152-L162】.
- **Prometheus** (via `prom-client`) for metrics (`/metrics` endpoint).
- **pino** for structured JSON logging.
- Optional **Redis** for distributed rate limiting and outbox deduplication.

### Response Envelope

All responses use a uniform envelope【67730289104851†L81-L94】:

```json
// Successful response
{
  "ok": true,
  "data": { /* payload */ },
  "requestId": "uuid",
  "traceId": "trace"
}

// Error response
{
  "ok": false,
  "error": { "code": "INVALID_INPUT", "message": "Bad body", "details": { "fieldErrors": [] } },
  "requestId": "uuid",
  "traceId": "trace"
}
```

Error codes include `INVALID_INPUT`, `UNAUTHENTICATED`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`, `FAILED_PRECONDITION`, `RATE_LIMITED`, `INTERNAL_ERROR` and `DEPENDENCY_DOWN`【67730289104851†L96-L100】.  Lua clients should propagate `error.code` and `error.message` safely to players while logging additional details server‑side.

## Installation and Setup

### Prerequisites

- **Node.js** LTS (≥18) and **npm**【67730289104851†L170-L174】.
- **MySQL 8+** server【67730289104851†L174-L176】.
- Optionally **Redis** for advanced rate limiting and outbox deduplication【67730289104851†L177-L178】.

### Environment Variables

The service reads configuration from environment variables or a `.env` file.  The most important settings are【67730289104851†L179-L205】:

| Variable | Required | Description |
|---------|----------|-------------|
| `PORT` | Yes | Port for the HTTP server (default: `3010`)【67730289104851†L179-L181】. |
| `API_TOKEN` | Yes | Shared secret token required on all requests via `X‑API‑Token`【67730289104851†L105-L106】. |
| `DB_HOST` | Yes | MySQL host【67730289104851†L185-L189】. |
| `DB_PORT` | Yes | MySQL port (default `3306`)【67730289104851†L185-L189】. |
| `DB_NAME` | Yes | MySQL database name【67730289104851†L185-L189】. |
| `DB_USER` | Yes | MySQL user【67730289104851†L185-L189】. |
| `DB_PASS` | Yes | MySQL password【67730289104851†L185-L189】. |
| `ENABLE_REPLAY_GUARD` | No | Set to `1` to enable HMAC replay protection【67730289104851†L191-L194】. |
| `REPLAY_TTL_SEC` | No | HMAC timestamp tolerance in seconds (default `90`)【67730289104851†L191-L194】. |
| `ENABLE_IP_ALLOWLIST` | No | Set to `1` to enforce an IP allowlist【67730289104851†L191-L195】. |
| `IP_ALLOWLIST` | No | Comma‑separated CIDRs allowed to call the API【67730289104851†L191-L195】. |
| `ENABLE_METRICS` | No | Set to `1` to enable Prometheus metrics【67730289104851†L197-L199】. |
| `FEATURE_USERS`, `FEATURE_CHARACTERS`, etc. | No | Toggle fallback feature flags (see feature flags section)【67730289104851†L200-L203】. |
| `REDIS_URL` | No | Redis connection string for rate limiting, idempotency and outbox【67730289104851†L204-L206】. |
| `ENABLE_OUTBOX_WORKER` | No | Set to `1` to run the outbox worker (requires PM2 or another process manager)【67730289104851†L222-L223】. |
| `OUTBOX_BATCH_SIZE`, `OUTBOX_INTERVAL_MS`, `OUTBOX_CLAIM_TIMEOUT_SEC`, `OUTBOX_DELIVERY_URL`, `OUTBOX_REDIS_CHANNEL_PREFIX` | No | Outbox worker tuning parameters【67730289104851†L294-L307】. |
| `ASSET_RETENTION_MS` | No | Milliseconds to retain assets before purge (default `2592000000`). |

### Setup Steps

1. **Install dependencies**:
   ```bash
   cd backend/services/srp-base
   npm ci
   ```
2. **Configure environment**: create a `.env` file with the variables listed above.  Use strong random values for `API_TOKEN` and (if enabling HMAC) `HMAC_SECRET`.
3. **Run migrations**:
   ```bash
   node src/bootstrap/migrate.js
   ```
   Alternatively, apply the SQL files in `src/migrations/` manually in ascending order.
4. **Start the service** in development:
   ```bash
   node src/server.js
   ```
   For production, use a process manager such as PM2 (`pm2 start pm2/ecosystem.config.js --only srp-base`)【67730289104851†L219-L221】.

### FiveM Integration

Lua resources communicate with `srp-base` via HTTP.  The following ConVars must be set in your FiveM `server.cfg`【67730289104851†L224-L231】:

```ini
set srp_api_base_url "http://127.0.0.1:3010"
set srp_api_token "<same token as API_TOKEN>"
set srp_api_timeout_ms "5000"
set srp_api_retries "1"

# Optional HMAC
set srp_api_hmac_enabled "0"
set srp_api_hmac_secret ""
set srp_api_hmac_style "newline"

# Live config sync
set srp_feature_config_sync_enabled "1"
set srp_config_poll_ms "10000"
```

The typical flow during player connect is to call `/v1/players/link` (see below) to validate identifiers, then ensure a user exists via `/v1/users/exists` and `/v1/users`【67730289104851†L244-L249】.  The permissions endpoint is polled to populate RBAC scopes【67730289104851†L252-L253】.  `srp-base` does not implement any UI; Lua resources are responsible for sending NUI events to the client.

## Security Model

### API Token

All incoming requests must supply the `X‑API‑Token` header equal to the `API_TOKEN` configured in the environment【67730289104851†L105-L106】.  Requests lacking the header or containing the wrong token are rejected with `401 UNAUTHENTICATED`.

### HMAC Replay Guard (Optional)

When `ENABLE_REPLAY_GUARD=1`, mutating routes (POST, PUT, PATCH, DELETE) require three additional headers: `X‑Ts` (unix seconds), `X‑Nonce` (UUID v4) and `X‑Sig` (HMAC‑SHA256 signature).  The signature is computed over the canonical string `ts\nnonce\nMETHOD\n/path\nrawBody` (default `newline` style) or `METHOD|/path|rawBody|ts|nonce` for `pipe` style【67730289104851†L109-L118】.  `srp-base` checks that the timestamp is within the configured TTL (default 90 s), verifies the HMAC using the `HMAC_SECRET`, and ensures the nonce has not been used before【67730289104851†L120-L121】.  Missing or invalid HMAC headers result in `401 UNAUTHENTICATED`.

### Rate Limiting and Idempotency

Sensitive routes (e.g. admin bans, user creation) are subject to rate limiting.  The in‑memory rate limiter enforces a maximum number of requests per IP per window; for distributed deployments, configure Redis to share limits across instances【67730289104851†L288-L292】.  Mutating endpoints accept an `X‑Idempotency‑Key` header; if a request is retried with the same key, the previously stored response is returned【67730289104851†L292-L292】.  This prevents duplicate side effects when clients retry after timeouts.

### Permissions and RBAC

Permissions (scopes) govern what actions a player may perform.  Use `/v1/permissions/:playerId` to list a player’s scopes, `/v1/permissions/grant` to add a scope, and `/v1/permissions/revoke` to remove a scope.  Modules should check the caller’s scopes before executing privileged actions.

## Database Schema

The initial migration (`001_init.sql`) creates four tables:

1. **users** — stores primary key `hex_id`, `name`, optional identifiers (steam_id, license, discord, community_id), rank and created_at【67730289104851†L164-L167】.
2. **permissions** — join table mapping a `player_id` (user hex) to a `scope` with `granted_at` timestamp.
3. **characters** — contains `id`, `owner_hex` (foreign key to users), `first_name`, `last_name`, optional `dob`, `gender`, `phone_number`, `story` and `created_at`.  Unique constraints ensure character names and phone numbers are unique【67730289104851†L158-L162】.
4. **outbox** — holds idempotent domain events: `id`, `topic`, `payload` JSON, `created_at`, `claimed_at`, `delivered_at` and `delivery_attempts`.  A worker process claims and delivers events.

Additional migrations may add soft deletion to users, new indexes or domain tables.  Align your schema with the SQL files in `src/migrations/`【67730289104851†L168-L168】.

## API Endpoints

Below is a summary of the core routes.  For full request/response schemas, consult the OpenAPI specification (`openapi/api.yaml`).

### Health & Operations

| Method | Path | Description | Response |
|-------|-----|-------------|---------|
| `GET` | `/v1/healthz` | Liveness probe; returns `{ ok: true, data: { status: 'ok' } }` | `200 OK`【67730289104851†L51-L55】 |
| `GET` | `/v1/ready` | Readiness probe; checks DB connectivity; returns `503` if dependencies are down【67730289104851†L52-L54】 | `200 OK`/`503` |
| `GET` | `/v1/debug/status` | Retrieve server diagnostics (uptime, memory, load averages). | `200 OK` |
| `GET` | `/metrics` | Prometheus metrics; enabled when `ENABLE_METRICS=1`【67730289104851†L51-L55】 | plaintext metrics |

### Configuration

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/config/live` | Returns current feature flags and world settings (e.g. time, weather)【67730289104851†L56-L58】. |
| `POST` | `/v1/config/live` | Update live config.  Body may include `features` (object mapping module names to booleans) and/or `settings` (object with `Time` and `Weather` subobjects).  Requires admin privileges. |

### Driving & Drift School

| Method | Path | Description |
|-------|-----|-------------|
| `POST` | `/v1/driving-tests` | Record a new driving test.  Requires `cid`, `icid`, `points` and `passed` in the request body.  Optionally includes `instructor` name and a JSON `results` payload.  Returns the persisted test with its new `id`. |
| `GET` | `/v1/driving-tests` | List recent driving tests for a player by passing `cid` as a query parameter; returns up to 5 tests in descending order. |
| `GET` | `/v1/driving-tests/{id}` | Retrieve a specific driving test by its numeric ID.  Returns the full test record or `404` if not found. |
| `POST` | `/v1/driftschool/pay` | Withdraw funds from a player's account to pay for drift school participation.  Requires `playerId` and positive `amount` in the body.  Returns the new account balance or an insufficient funds error. |

The default config shape looks like【67730289104851†L128-L146】:

```json
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
```

### Additional Domain Endpoints

In addition to the core identity, permissions, characters and admin APIs described above, `srp-base` includes a suite of domain‑specific endpoints.  These endpoints provide a **framework‑level foundation** for systems such as inventory, economy, vehicles, world and jobs.  They persist state but intentionally **omit gameplay logic**—Lua resources implement the gameplay rules.  Below is a summary of these endpoints.

#### Inventory (Persistent Player Items)

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/inventory/:playerId` | Retrieve a player’s inventory (array of `{ item, quantity }`). |
| `POST` | `/v1/inventory/:playerId/add` | Add an item to a player’s inventory (body: `{ item, quantity }`). |
| `POST` | `/v1/inventory/:playerId/remove` | Remove an item from a player’s inventory (body: `{ item, quantity }`). |

#### Economy (Accounts & Transactions)

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/characters/{characterId}/account` | Retrieve or create the character's bank account. |
| `POST` | `/v1/characters/{characterId}/account:deposit` | Deposit funds into the account. |
| `POST` | `/v1/characters/{characterId}/account:withdraw` | Withdraw funds from the account. |
| `GET` | `/v1/characters/{characterId}/transactions` | List recent transactions for the character. |
| `POST` | `/v1/transactions` | Transfer funds between characters. |
| `GET` | `/v1/transactions/{id}` | Retrieve a transaction by ID. |

#### Vehicles (Ownership & Registration)

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/vehicles/:playerId` | List vehicles owned by a player. |
| `POST` | `/v1/vehicles` | Register a new vehicle (body: `{ playerId, model, plate, properties? }`). Returns vehicle ID. |
| `POST` | `/v1/vehicles/:id/update` | Update an existing vehicle (body: partial). |
| `GET` | `/v1/vehicles/shop` | Placeholder endpoint to list vehicles available for purchase. Returns an empty array by default. |
| `GET` | `/v1/vehicles/{plate}/control` | Retrieve siren/powercall/indicator state for a vehicle. |
| `POST` | `/v1/vehicles/{plate}/control` | Update control state fields; broadcasts `vehicles.control.update`. |

#### World (Global State & Events)

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/world/state` | Fetch the most recent world state (time, weather, density). |
| `POST` | `/v1/world/state` | Set a new world state (body: `{ time, weather, density }`). |
| `GET` | `/v1/world/forecast` | Fetch the latest weather forecast schedule. |
| `POST` | `/v1/world/forecast` | Set a new forecast (body: `{ forecast: [{ weather, duration }] }`). |
| `GET` | `/v1/world/ipls` | List interior proxy states. |
| `POST` | `/v1/world/ipls` | Upsert interior proxy state. |
| `DELETE` | `/v1/world/ipls/{name}` | Remove interior proxy state. |
| `POST` | `/v1/world/events/death` | Record a death event (body: `{ playerId, killerId?, weapon?, coords?, meta? }`). |
| `POST` | `/v1/world/events/kill` | Record a kill event (same structure as death). |
| `POST` | `/v1/world/coords/save` | Save arbitrary labelled coordinates (body: `{ playerId, label, coords }`). |

#### Jobs (Definitions & Assignments)

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/jobs` | List all defined jobs. |
| `POST` | `/v1/jobs` | Create a new job (body: `{ name, label?, description? }`). |
| `GET` | `/v1/jobs/:id` | Retrieve a job by ID. |
| `POST` | `/v1/jobs/assign` | Assign a character to a job (body: `{ characterId, jobId, grade? }`) — broadcasts `jobs.assigned`. |
| `POST` | `/v1/jobs/duty` | Toggle a character’s duty status (body: `{ characterId, jobId, onDuty }`) — broadcasts `jobs.duty`. |
| `GET` | `/v1/jobs/:characterId/assignments` | List all job assignments for a character with duty status. |

#### Weapons & Ammo

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/players/{playerId}/ammo` | Retrieve a player’s ammunition counts as an object keyed by weapon type. |
| `PATCH` | `/v1/players/{playerId}/ammo` | Update the ammunition count for a specific weapon type (body: `{ weaponType, ammo }`). |

#### Phone (Tweets)

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/phone/tweets` | Retrieve up to the 50 most recent tweets. Returns `400 INVALID_INPUT` on malformed query. |
| `POST` | `/v1/phone/tweets` | Create a new tweet with a handle and message. Returns `400 INVALID_INPUT` on validation errors. |

These endpoints round out the foundation of `srp-base`.  Together with the previously documented identity, permissions, config and outbox APIs they provide a **complete backend** capable of supporting all future gameplay modules.  Lua resources can rely on these endpoints to persist and retrieve state while implementing their own behaviour.

### Identity & Permissions

| Method | Path | Description |
|-------|-----|-------------|
| `POST` | `/v1/players/link` | Link a connecting player’s identifiers (license, steam, discord).  Returns whether the player is banned/whitelisted, and their scopes【67730289104851†L59-L63】.  It also creates the user if they do not exist. |
| `GET` | `/v1/permissions/:playerId` | List RBAC scopes for the specified player【67730289104851†L60-L63】. |
| `POST` | `/v1/permissions/grant` | Grant a scope to a player; body `{ playerId, scope }`. |
| `POST` | `/v1/permissions/revoke` | Revoke a scope from a player; body `{ playerId, scope }`. |

### Users

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/users/exists?hex_id=…` | Return `{ exists: true/false }` if a user exists【67730289104851†L63-L67】. |
| `POST` | `/v1/users` | Create a user with `hex_id`, `name` and `identifiers` array; atomic【67730289104851†L64-L67】. |
| `GET` | `/v1/users/:hex_id` | Fetch user profile by hex ID【67730289104851†L64-L67】. |
### Characters

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/accounts/{accountId}/characters` | List characters owned by an account. |
| `POST` | `/v1/accounts/{accountId}/characters` | Create a character for an account. Body must include `first_name` and `last_name`; server enforces unique name and phone. |
| `POST` | `/v1/accounts/{accountId}/characters/{characterId}:select` | Select the active character for the account. Idempotent. |
| `DELETE` | `/v1/accounts/{accountId}/characters/{characterId}` | Delete a character and clear selection if active. |



### Outbox

| Method | Path | Description |
|-------|-----|-------------|
| `POST` | `/v1/outbox/enqueue` | Enqueue a domain event.  Body `{ topic, payload }`.  Idempotent; duplicate keys return previous response【67730289104851†L75-L76】.  Requires the outbox feature to be enabled in config. |

### Admin

| Method | Path | Description |
|-------|-----|-------------|
| `POST` | `/v1/admin/ban` | Ban a player.  Body `{ playerId, reason, until? }`.  Persists to the bans table and returns ban status. |
| `POST` | `/v1/admin/kick` | Kick a player (future extension). |
| `GET` | `/v1/admin/audit` | Fetch audit logs (future extension). |


### Broadcaster

| Method | Path | Description |
|-------|-----|-------------|
| `POST` | `/v1/broadcast/attempt` | Assign the `broadcaster` job if below the configured limit; returns `400 INVALID_INPUT`, `404 NOT_FOUND` or `409 LIMIT_REACHED` on error. |

## Feature Flags

Feature flags allow modules to be toggled on or off at runtime.  `srp-base` supports static fallbacks via environment variables (`FEATURE_USERS=1`, `FEATURE_CHARACTERS=1`, etc.) and dynamic toggles returned from `/v1/config/live`【67730289104851†L128-L141】.  Lua resources should respect these flags to avoid calling endpoints that are disabled.  Routers are internally guarded by a `featureGate()` middleware, preventing access when a feature is turned off.

## Outbox Pattern

The outbox mechanism decouples event publication from the request/response lifecycle.  When an action requires notifying another service (e.g. character creation), the route handler enqueues an event into the `outbox` table via `/v1/outbox/enqueue`.  A separate worker (enabled by setting `ENABLE_OUTBOX_WORKER=1` and configuring PM2) claims batches of unclaimed events, marks them as claimed, and delivers them to the configured `OUTBOX_DELIVERY_URL` and/or Redis channel【67730289104851†L294-L307】.  Delivery attempts increment `delivery_attempts` and, once successful, the event is marked as delivered.  Using the outbox pattern ensures events are not lost even if downstream services are temporarily unavailable.

## Logging and Metrics

All requests are logged using **pino**.  Logs include the `requestId`, `traceId`, HTTP method, path and latency.  Errors are sanitized to avoid leaking stack traces or sensitive information.  When `ENABLE_METRICS=1`, **prom-client** collects default metrics (process CPU/memory, HTTP request counters) and exposes them via `/metrics`【67730289104851†L310-L316】.

## Development and Contribution

* Keep the OpenAPI specification (`openapi/api.yaml`) in sync with routes and request/response shapes【67730289104851†L320-L323】.  Automated tools like [openapi-validator] can help enforce this.
* Provide a Postman collection (`postman/srp-base.postman.json`) for manual testing; update it whenever endpoints change【67730289104851†L320-L323】.
* Prefer atomic server‑side operations: for example, allocate phone numbers and ensure character name uniqueness within a single SQL transaction【67730289104851†L324-L326】.
* Use idempotency keys for all POST routes that create resources, and apply rate limits to admin and creation endpoints【67730289104851†L288-L292】.
* When implementing new modules, follow the same patterns: create a new service with its own migrations, env settings, middleware and routers; authenticate calls using `X‑API‑Token` and (optionally) HMAC; return the same response envelope; expose `/healthz`, `/ready` and `/metrics` endpoints; include OpenAPI and Postman docs.

## Troubleshooting

The following table summarises common issues and their likely causes【67730289104851†L328-L334】:

| Symptom | Likely cause | Fix |
|--------|--------------|-----|
| `401 UNAUTHENTICATED` | Missing/invalid `X‑API‑Token` | Ensure the `srp_api_token` ConVar in Lua matches `API_TOKEN` env【67730289104851†L330-L331】. |
| `429 RATE_LIMITED` | Hitting admin read/ban limits | Lower frequency of calls or increase window/limit in env【67730289104851†L331-L331】. |
| `FAILED_PRECONDITION` on character creation | User does not exist | Call `/v1/users/exists` and create the user before creating a character【67730289104851†L332-L333】. |
| HMAC signature mismatch | Canonical style/secret mismatch | Align `srp_api_hmac_style` and `HMAC_SECRET` between Lua and backend【67730289104851†L333-L333】. |
| Lua timeouts | API unreachable or wrong URL | Verify `srp_api_base_url`, firewall rules and service port【67730289104851†L334-L334】. |

---

By adhering to this documentation and the provided templates, you can build out a suite of microservices that support every future SunnyRP module (jobs, inventory, economy, vehicles, etc.) with a consistent, secure and maintainable foundation.  Contributions to this base service should strive for clarity, safety and extensibility.

## Additional Domain Services (Dispatch, Evidence, EMS, Keys, Loot)

To support all features present in the original server resources at the framework level without introducing gameplay logic, the SunnyRP repository includes several **additional microservices** under `backend/services`: `srp-dispatch`, `srp-evidence`, `srp-ems`, `srp-keys` and `srp-loot`.  Each service mirrors the patterns used in `srp-base`—Express routing, MySQL persistence, token/HMAC authentication, idempotency and rate limiting—and maintains its own database schema and migrations.  These services act as the scaffolding for high‑level gameplay modules that will be written in Lua later.

- **srp-dispatch** – Centralised storage and management of dispatch alerts (e.g. 911 calls, panic buttons).  It exposes:
  - `GET /v1/dispatch/alerts` – List recent dispatch alerts.
  - `POST /v1/dispatch/alerts` – Create a new alert with `code`, `title`, optional `description`, `sender` and `coords`.
  - `PATCH /v1/dispatch/alerts/:id/ack` – Mark an alert as acknowledged.
  - `GET /v1/dispatch/codes` – List dispatch codes (loaded from the `dispatch_codes` table).

- **srp-evidence** – Repository for evidence items such as shell casings, DNA swabs or fingerprints.  Endpoints include:
  - `GET /v1/evidence/items` – List evidence items.
  - `GET /v1/evidence/items/:id` – Fetch a specific item.
  - `POST /v1/evidence/items` – Create a new evidence item with `type`, `description` and optional `location`, `owner` and `metadata`.
  - `PATCH /v1/evidence/items/:id` – Update selected fields on an evidence item.
  - `DELETE /v1/evidence/items/:id` – Permanently remove an item.

- **srp-ems** – Tracks medical records such as patient treatments, surgeries or hospitalizations.  It provides:
  - `GET /v1/ems/records` – List recent EMS records.
  - `GET /v1/ems/records/:id` – Fetch a specific record.
  - `POST /v1/ems/records` – Create a record (fields: `patient_id`, `doctor_id`, `treatment`, optional `status`).
  - `PATCH /v1/ems/records/:id` – Update a record’s treatment or status.
  - `DELETE /v1/ems/records/:id` – Remove a record when permitted by policy.
  - `GET /v1/ems/shifts/active` – List active EMS shifts.
  - `POST /v1/ems/shifts` – Start a shift (`characterId`).
  - `POST /v1/ems/shifts/{id}/end` – End a shift.

- **srp-keys** – Assign and manage keys for players.  Keys may represent vehicle keys, property keys or any other access tokens.  Endpoints are:
  - `POST /v1/keys` – Assign a new key (requires `player_id`, `key_type` and `target_id`; optional `metadata`).
  - `DELETE /v1/keys/:id` – Revoke a key by its identifier.
  - `GET /v1/keys/:playerId` – List keys assigned to a specific player.

- **srp-loot** – Persist random loot items placed in the world.  Endpoints include:
  - `GET /v1/loot/items` – List loot items.
  - `GET /v1/loot/items/:id` – Fetch a specific loot item.
  - `POST /v1/loot/items` – Create a loot drop (requires `owner_id` and `item_type`; optional `value`, `coordinates`, `metadata`).
  - `PATCH /v1/loot/items/:id` – Update fields on a loot item.
  - `DELETE /v1/loot/items/:id` – Remove a loot item after it is collected or expired.
  - 
- **srp-doors** – Manages door definitions and locked state.
  - `GET /v1/doors` – List all doors.
  - `POST /v1/doors` – Create or update a door.
  - `PATCH /v1/doors/{doorId}/state` – Set locked state.
- **srp-diamond-blackjack** – Records casino blackjack hand history.
  - `GET /v1/diamond-blackjack/hands/:characterId` – List recent hands for a character.
  - `POST /v1/diamond-blackjack/hands` – Record a hand result with `characterId`, `tableId`, `bet`, `payout`, `dealerHand`, `playerHand` and optional `playedAt`.
- **srp-interact-sound** – Logs sound play events.
  - `GET /v1/interact-sound/plays/:characterId` – Retrieve recent sound plays for a character.
  - `POST /v1/interact-sound/plays` – Record a sound play with `characterId`, `sound`, `volume` and optional `playedAt`.
- **srp-wise-audio** – Stores custom audio tracks.
  - `GET /v1/wise-audio/tracks/{characterId}` – List tracks for a character.
  - `POST /v1/wise-audio/tracks` – Create a track with `characterId`, `label` and `url`.
- **srp-wise-imports** – Manages vehicle import orders.
  - `GET /v1/wise-imports/orders/{characterId}` – List import orders for a character.
  - `POST /v1/wise-imports/orders` – Create an order with `characterId` and `model`.
  - `POST /v1/wise-imports/orders/{id}/deliver` – Mark a ready order as delivered.
- **srp-import-pack** – Tracks vehicle import packages.
  - `GET /v1/import-pack/orders/character/{characterId}` – List import package orders for a character.
  - `GET /v1/import-pack/orders/{id}?characterId={characterId}` – Fetch a specific order.
  - `POST /v1/import-pack/orders` – Create a new import package order.
  - `POST /v1/import-pack/orders/{id}/deliver` – Mark an order as delivered.
  - `POST /v1/import-pack/orders/{id}/cancel` – Cancel a pending order.
  - `POST /v1/import-pack/orders` – Create an order with `characterId` and `package`.
  - `POST /v1/import-pack/orders/{id}/deliver` – Mark an order as delivered.
- **srp-wise-uc** – Manages undercover profiles.
  - `GET /v1/wise-uc/profiles/{characterId}` – Retrieve undercover profile for a character.
  - `POST /v1/wise-uc/profiles` – Create or update a profile with `characterId`, `alias` and optional `active`.
- **srp-wise-wheels** – Records wheel spin results.
  - `GET /v1/wise-wheels/spins/{characterId}` – List spins for a character.
  - `POST /v1/wise-wheels/spins` – Record a spin with `characterId` and `prize`.
  - Spins older than 30 days are purged hourly, emitting `wise-wheels.spin.expired`.
- **srp-assets** – Stores references to character-bound assets such as images or media.
  - `GET /v1/assets?ownerId={cid}` – List assets for a character.
  - `GET /v1/assets/{id}` – Retrieve an asset by id.
  - `POST /v1/assets` – Create an asset with `ownerId`, `url` and `type` (requires `Idempotency-Key`).
  - `DELETE /v1/assets/{id}` – Remove an asset record.
- **srp-clothes** – Stores character outfit data.
  - `GET /v1/clothes?characterId={cid}` – List outfits for a character.
  - `POST /v1/clothes` – Save an outfit (`characterId`, `slot`, `data`) (requires `Idempotency-Key`).
  - `DELETE /v1/clothes/{id}` – Remove an outfit.
- **srp-apartments** – Manages apartments and residents.
  - `GET /v1/apartments?characterId={cid}` – List apartments, optionally filtered by resident.
  - `POST /v1/apartments` – Create an apartment (`name`, optional `location`, optional `price`).
  - `POST /v1/apartments/{apartmentId}/residents` – Assign a character to an apartment.
  - `DELETE /v1/apartments/{apartmentId}/residents/{characterId}` – Remove a resident.
- **drz_interiors** – Stores interior layouts per apartment.
  - `GET /v1/apartments/{apartmentId}/interior?characterId={cid}` – Retrieve interior layout.
  - `POST /v1/apartments/{apartmentId}/interior` – Save interior layout (`characterId`, `template`) and broadcast `interiors.apartment.updated`.
- **srp-properties** – Unified housing (apartments, garages, hotel rooms).
  - `GET /v1/properties?type=&ownerCharacterId=` – List properties.
  - `POST /v1/properties` – Create a property.
  - `GET /v1/properties/{propertyId}` – Retrieve a property.
  - `PATCH /v1/properties/{propertyId}` – Update a property.
  - `DELETE /v1/properties/{propertyId}` – Delete a property.
- **srp-zones** – Stores polygonal zone definitions for world interactions.
  - `GET /v1/zones` – List active zones.
  - `POST /v1/zones` – Create a zone with `name`, `type`, `data` and optional `expiresAt`; pushes `zone.created`.
  - `DELETE /v1/zones/{id}` – Remove a zone and push `zone.deleted`.
- **srp-diamond-blackjack** – Records casino blackjack hand history.
  - `GET /v1/diamond-blackjack/hands/:characterId` – List recent hands for a character.
  - `POST /v1/diamond-blackjack/hands` – Record a hand result with `characterId`, `tableId`, `bet`, `payout`, `dealerHand`, `playerHand` and optional `playedAt`.
  - 
- **srp-interact-sound** – Logs sound play events.
  - `GET /v1/interact-sound/plays/:characterId` – Retrieve recent sound plays for a character.
  - `POST /v1/interact-sound/plays` – Record a sound play with `characterId`, `sound`, `volume` and optional `playedAt`.
### PolicePack Extensions

- `GET /v1/evidence/items/{id}/custody` – List custody chain entries for an evidence item.
- `POST /v1/evidence/items/{id}/custody` – Add a custody entry.
- `GET /v1/accounts/{accountId}/characters` – List characters for an account.
- `POST /v1/accounts/{accountId}/characters` – Create a character for an account.
- `POST /v1/accounts/{accountId}/characters/{characterId}:select` – Select the active character.
- `GET /v1/accounts/{accountId}/characters/selected` – Retrieve the active character for an account.
- `DELETE /v1/accounts/{accountId}/characters/{characterId}` – Remove a character and clear selection if active.

All routes require `X-API-Token` authentication. Idempotency keys are supported on POST requests and standard rate limits apply.
- **srp-base-events** – Records player lifecycle and combat events.
  - `GET /v1/base-events?limit={n}` – List recent events.
  - `POST /v1/base-events` – Log an event (`accountId`, `characterId`, `eventType`, optional `metadata`). Broadcasts `base-events.logged` over WebSocket.
- **srp-boatshop** – Lists and sells boats to characters.
  - `GET /v1/boatshop` – List boats available for purchase.
  - `POST /v1/boatshop/purchase` – Purchase a boat with `characterId`, `boatId`, `plate` and optional `properties`.
  - Scheduler broadcasts `boatshop.catalog` every 5 minutes; purchases emit `boatshop.purchase` over WebSocket and webhooks.
  - **srp-camera** – Stores character photos and broadcasts changes.
    - `GET /v1/camera/photos/{characterId}` – List photos for a character.
    - `POST /v1/camera/photos` – Save a photo with `characterId`, `imageUrl` and optional `description`; broadcasts `camera.photo.created` over WebSocket and webhooks.
    - `DELETE /v1/camera/photos/{id}` – Remove a photo record; broadcasts `camera.photo.deleted`.
    - Scheduler purges photos older than `CAMERA_RETENTION_MS` at `CAMERA_CLEANUP_INTERVAL_MS`.
  - **srp-hud** – Stores per-character HUD settings.
- `GET /v1/characters/{characterId}/hud` – Retrieve HUD preferences.
- `PUT /v1/characters/{characterId}/hud` – Update HUD preferences.
- `GET /v1/characters/{characterId}/vehicle-state` – Retrieve vehicle HUD state.
- `PUT /v1/characters/{characterId}/vehicle-state` – Update vehicle HUD state (broadcasts `hud.vehicleState`).
- **srp-carwash** – Records vehicle washes and dirt levels.
  - `POST /v1/carwash` – Record a car wash (`characterId`, `plate`, `location`, `cost`).
  - `GET /v1/carwash/history/{characterId}` – List recent washes for a character.
  - `GET /v1/vehicles/{plate}/dirt` – Fetch vehicle dirt level.
  - `PATCH /v1/vehicles/{plate}/dirt` – Update vehicle dirt level.
- **srp-chat** – Stores chat messages for moderation.
  - `GET /v1/chat/messages/{characterId}` – List recent chat messages for a character.
  - `POST /v1/chat/messages` – Record a chat message (`characterId`, `channel`, `message`).
- **srp-connectqueue** – Manages account queue priorities.
  - `GET /v1/connectqueue/priorities` – List queue priorities optionally filtered by `accountId`.
  - `POST /v1/connectqueue/priorities` – Upsert a priority with `accountId`, `priority`, optional `reason` and `expiresAt`.
  - `DELETE /v1/connectqueue/priorities/{accountId}` – Remove priority for an account.
  - Emits WebSocket/webhook events `priority.upserted`, `priority.removed` and `priority.expired`; `connectqueue-expiry` scheduler purges expired entries.
- **srp-hardcap** – Manages server connection limits and active sessions.
  - `GET /v1/hardcap/status` – Current max players, reserved slots and active count.
  - `POST /v1/hardcap/config` – Update max player and reserved slot settings (broadcasts `hardcap.config.updated`).
  - `POST /v1/hardcap/sessions` – Register an active session (broadcasts `hardcap.session.created`).
  - `DELETE /v1/hardcap/sessions/{id}` – End an active session (broadcasts `hardcap.session.ended`).
  - Scheduler `hardcap-session-expiry` ends stale sessions and emits `hardcap.session.expired`.
- **srp-cron** – Schedules timed server tasks.
  - `GET /v1/cron/jobs` – List registered cron jobs.
  - `POST /v1/cron/jobs` – Create or replace a cron job with `name`, `schedule`, optional `payload`, `accountId`, `characterId`, `priority` and `nextRun`.
  - Scheduler emits WebSocket event `cron.execute` and dispatches webhooks when jobs run.
- **srp-coordinates** – Stores character-specific saved coordinates.
  - `GET /v1/characters/{characterId}/coordinates` – List saved coordinates.
  - `POST /v1/characters/{characterId}/coordinates` – Save or update a coordinate (`name`, `x`, `y`, `z`, optional `heading`).
  - `DELETE /v1/characters/{characterId}/coordinates/{id}` – Remove a coordinate.
- **srp-emotes** – Stores per-character favorite emotes.
  - `GET /v1/characters/{characterId}/emotes` – List favorite emotes.
  - `POST /v1/characters/{characterId}/emotes` – Add a favorite emote (`emote`), pushing `emotes.favoriteAdded`.
  - `DELETE /v1/characters/{characterId}/emotes/{emote}` – Remove a favorite emote, pushing `emotes.favoriteRemoved`.
- **srp-furniture** – Stores custom furniture placements per character.
  - `GET /v1/characters/{characterId}/furniture` – List furniture items for a character.
  - `POST /v1/characters/{characterId}/furniture` – Place a furniture item with `item`, `x`, `y`, `z` and optional `heading`.
  - `DELETE /v1/characters/{characterId}/furniture/{id}` – Remove a furniture item.
  - Realtime events: `furniture.placed`, `furniture.removed` (WebSocket & webhook).
  - Daily purge of entries older than `FURNITURE_RETENTION_MS` via scheduler.
### Jobs

- `GET /v1/jobs` – list defined jobs
- `POST /v1/jobs` – create a job
- `GET /v1/jobs/{id}` – retrieve job details
- `POST /v1/jobs/assign` – assign a job to a character (`characterId`, `jobId`, optional `grade`)
- `POST /v1/jobs/duty` – set job duty status (`characterId`, `jobId`, `onDuty`)
- `GET /v1/jobs/{characterId}/assignments` – list assignments for a character
- WebSocket: `jobs.assigned`, `jobs.duty`, `jobs.roster`
- `POST /v1/broadcast/attempt` – attempt to become a broadcaster

### Taxi

- `GET /v1/taxi/requests` – list requests by status
- `POST /v1/taxi/requests` – create a taxi request
- `POST /v1/taxi/requests/{id}/accept` – accept a request
- `POST /v1/taxi/requests/{id}/complete` – complete a ride
- `GET /v1/characters/{characterId}/taxi/rides` – ride history
  - WebSocket: `taxi.request.created`, `taxi.request.accepted`, `taxi.request.completed`, `taxi.request.expired`

### Hospital

- `GET /v1/hospital/admissions/active` – list current admissions
- `POST /v1/hospital/admissions` – admit a character
- `POST /v1/hospital/admissions/{id}/discharge` – discharge an admission
- WebSocket `hospital` topic pushes `admission.created`, `admission.discharged`, and periodic `admissions.active`

### Garages

- `GET /v1/garages` – list all garages
- `POST /v1/garages` – create a garage
- `PUT /v1/garages/{id}` – update a garage
- `DELETE /v1/garages/{id}` – delete a garage
- `POST /v1/garages/{garageId}/store` – store a vehicle for a character
- `POST /v1/garages/{garageId}/retrieve` – retrieve a stored vehicle
- `GET /v1/characters/{characterId}/garages/{garageId}/vehicles` – list character vehicles in a garage
  - WebSocket: `garage.vehicleStored`, `garage.vehicleRetrieved` on topic `vehicles`

### Heli

- `POST /v1/heli/flights` – start a flight
- `POST /v1/heli/flights/{id}/end` – end a flight
- `GET /v1/characters/{characterId}/heli/flights` – list flights for a character
  - WebSocket: `heli.flightStarted`, `heli.flightEnded`, `heli.flightExpired` on topic `heli`
  - Scheduler `heli-expire-flights` ends flights older than `HELI_MAX_FLIGHT_HOURS`

### Peds

- `GET /v1/characters/{characterId}/ped` – Retrieve ped model, health and armor.
- `PUT /v1/characters/{characterId}/ped` – Upsert ped state (`model`, `health`, `armor`).
- WebSocket topic `peds` publishes `peds.pedUpdated` and periodic `peds.healthRegen` events.


### Jailbreak

- `POST /v1/jailbreaks` – start a jailbreak attempt (`characterId`, `prison`).
- `POST /v1/jailbreaks/{id}/complete` – complete an attempt with `success` flag.
- `GET /v1/jailbreaks/active` – list active attempts.
- Scheduler `jailbreak-expire` marks attempts older than `JAILBREAK_MAX_ACTIVE_MS` as failed and emits WebSocket `jailbreaks.expired` and webhook `jailbreak.expired`.

## Update – 2025-08-25 (k9)

Introduced K9 unit management for police characters.

### Endpoints

* `GET /v1/characters/{characterId}/k9s` – list K9 units for a character.
* `POST /v1/characters/{characterId}/k9s` – create a K9 unit (requires `X-Idempotency-Key`).
* `PATCH /v1/characters/{characterId}/k9s/{k9Id}/active` – update active state (requires `X-Idempotency-Key`).
* `DELETE /v1/characters/{characterId}/k9s/{k9Id}` – retire a K9 unit (requires `X-Idempotency-Key`).
* `GET /v1/k9s/active` – list all active K9 units.
* WebSocket `k9.created`, `k9.updated`, `k9.retired`, `k9.activeList` and matching webhooks.
* Scheduler `k9-active-broadcast` emits periodic `k9.activeList`.

All endpoints require standard authentication headers.

## Update – 2025-08-25 (climate-overrides)

Added world timecycle management endpoints.

- `GET /v1/world/timecycle` – retrieve current timecycle override.
- `POST /v1/world/timecycle` – set override with `preset` and optional `expiresAt`.
- `DELETE /v1/world/timecycle` – clear override.

## Update – 2025-08-25 (interactSound hooks)

- `POST /v1/interact-sound/plays` – record a sound play and push to clients via WebSocket and webhooks.
- `GET /v1/hooks/endpoints` – list registered webhook sinks (admin).
- `POST /v1/hooks/endpoints` – register a webhook sink (admin).
- `DELETE /v1/hooks/endpoints/{id}` – remove a webhook sink (admin).

## Update – 2025-08-25 (police dispatch)

Added dispatch alert APIs with WebSocket and webhook push.

### Endpoints

- `GET /v1/dispatch/alerts` – list recent dispatch alerts.
- `POST /v1/dispatch/alerts` – create a dispatch alert (requires `X-Idempotency-Key`).
- `PATCH /v1/dispatch/alerts/{id}/ack` – acknowledge an alert (requires `X-Idempotency-Key`).
- `GET /v1/dispatch/codes` – list configured dispatch codes.

All endpoints require standard authentication headers.

## Update – 2025-08-27 (police duty roster)

Added police roster endpoints with WebSocket and webhook push plus stale-duty cleanup.

### Endpoints

- `GET /v1/police/roster` – list police officers.
- `POST /v1/police/roster` – assign an officer (requires `X-Idempotency-Key`).
- `PUT /v1/police/roster/{id}` – update officer rank (requires `X-Idempotency-Key`).
- `POST /v1/police/roster/{characterId}:duty` – set duty status (requires `X-Idempotency-Key`).

## Update – 2025-08-27 (import-pack expiry)

Introduced import package expiry with real-time notifications.

### Endpoints

- `POST /v1/import-pack/orders` – create an import package order (requires `X-Idempotency-Key`).
- `POST /v1/import-pack/orders/{id}/deliver` – mark an order delivered (requires `X-Idempotency-Key`).
- `POST /v1/import-pack/orders/{id}/cancel` – cancel a pending order (requires `X-Idempotency-Key`).

WebSocket topic `import-pack` broadcasts `order.created`, `order.delivered`, `order.canceled` and `order.expired`.

Scheduler `import-pack-expiry` marks orders past `IMPORT_PACK_EXPIRY_MS` as expired and emits `order.expired`.

## Update – 2025-08-28 (weathersync)

Introduced weather.gov integration and proxy.

### Endpoints

- `GET /v1/weathersync/forecast`
- `POST /v1/weathersync/forecast` – requires `X-Idempotency-Key`
- `GET /v1/weathersync/weather.gov` – proxy to api.weather.gov

Scheduler `weathersync-forecast` pulls forecasts and broadcasts `world.forecast.updated`.

## Update – 2025-08-29 (recycling)

### Endpoints

- `GET /v1/recycling/deliveries/{characterId}`
- `POST /v1/recycling/deliveries` – requires `X-Idempotency-Key`

WebSocket topic `recycling` broadcasts `delivery.created`.

Scheduler `recycling-purge` removes records older than `RECYCLING_RETENTION_MS`.
