# SunnyRP — `srp-base` (Authoritative Backend)

`srp-base` is a fully self‑contained Node.js microservice that holds all
persistent data for the SunnyRP FiveM server.  It exposes a clean
HTTP API consumed by Lua resources.  This repository is intended as
a reference implementation and can be adapted to fit your own
workflow or extended with additional endpoints.

## Highlights

* **Authoritative persistence** – users, characters, permissions and
  outbox events live in MySQL.  Lua code never touches the DB.
* **Uniform envelope** – responses are wrapped in a `{ ok, data | error, requestId, traceId }` structure for easy client handling.
* **Security** – requests must supply an `X‑API‑Token`; optional
  HMAC replay guard using `X‑Ts`, `X‑Nonce` and `X‑Sig` headers to
  prevent tampering and replay attacks.
* **Resilience** – built‑in rate limiting and idempotency on write
  routes; health and readiness probes; optional Prometheus metrics.
* **Feature flags** – the `/v1/config/live` endpoint exposes runtime
  feature flags and world settings (e.g. time and weather) which Lua
  can poll and broadcast to clients.
* **Outbox** – domain events can be enqueued atomically and later
  delivered by a separate worker process to other services or
  message buses.

## Folder Layout

```
srp-base/
  package.json               # dependencies and scripts
  openapi/api.yaml          # OpenAPI 3.0 spec of all routes
  src/
    app.js                  # express app wiring
    server.js               # entry point
    bootstrap/migrate.js    # run SQL migrations
    config/env.js           # configuration loader
    middleware/             # auth, idempotency, requestId, rateLimit
    repositories/           # DB access for users, characters, permissions, outbox
                            # and domain models (inventory, economy, vehicles, world, jobs,
                            # gangs, garages, apartments, police, doors, error log,
                            # evidence, EMS, keys, loot, weapons, shops, blips, crime school)
    routes/                 # routers grouped by domain (identity, characters, inventory, economy, vehicles, world, jobs, etc.)
    utils/                  # logger, HMAC, response helpers
    migrations/             # SQL migrations (001_init.sql, 002_extended_services.sql,
                            # 003_additional_tables.sql, 004_add_doors_error_weapons_shops.sql,
                            # 005_add_gangs_garages_apartments_police.sql, 006_add_blips_crimeschool.sql)
```

## Usage

1. **Install dependencies**

   ```bash
   cd srp-base
   npm ci
   ```

2. **Configure the environment**

   Create a `.env` file at the root of `srp-base` with the following
   values (see [`src/config/env.js`](src/config/env.js) for full
   options):

   ```env
   PORT=3010
   API_TOKEN=super-secret-token

   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_NAME=sunnyrp
   DB_USER=sunnyrp
   DB_PASS=sunnyrp-password

   # Optional features
   ENABLE_REPLAY_GUARD=0
   ENABLE_METRICS=1
   ```

3. **Run migrations**

   ```bash
   node src/bootstrap/migrate.js
   ```

4. **Start the service**

   ```bash
   node src/server.js
   ```

The API will be available at `http://localhost:3010`.  Use the
`openapi/api.yaml` file as a reference for route paths and payloads.

## Contributing

This project is intended as a foundation.  Feel free to extend the
schema, add new routes, or improve the existing modules.  Pull
requests are welcome!