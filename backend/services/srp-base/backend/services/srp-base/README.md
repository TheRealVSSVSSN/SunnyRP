# SRP Base (Node)

Server-authoritative base service for SunnyRP. FiveM server (Lua) calls these APIs only.

## Features

- HMAC-signed requests with optional Redis replay guard.
- Uniform response envelope.
- Health/Ready/Metrics endpoints.
- Identity link, permissions (grant/revoke), admin (ban/kick), audit log.
- Live config (`/v1/config/live`) with feature flags and caches.
- Idempotency keys for POST.
- Rate limits per route family.
- IP allowlist & reverse-proxy awareness.
- Outbox table + worker (HTTP and/or Redis delivery).

## Run

```bash
cd backend/services/srp-base
cp .env.example .env
# fill DB_* and API_TOKEN; set REDIS_URL if used.
npm i
npm run migrate
npm run dev