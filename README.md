# SunnyRP

SunnyRP is a custom FiveM roleplay platform built from scratch.  This repository contains the server configuration, example resources and the backend services that provide persistence and shared functionality.

## Repository Layout

```
.
├── backend/
│   └── srp-base/          # Node.js service powering accounts, characters and more
├── Example_Frameworks/    # References to third‑party frameworks (not used by SunnyRP)
├── server.cfg             # Sample FiveM configuration
└── README.md              # Project documentation
```

### backend/srp-base

`srp-base` is the authoritative backend for SunnyRP.  FiveM resources call its HTTP API instead of talking to MySQL directly.  Major components include:

| Area | Description |
| ---- | ----------- |
| **Authentication** | HMAC signed requests (`X-SRP-Signature`) and optional JWT bearer tokens with scopes. |
| **Accounts & Characters** | Manage player accounts, character creation, selection and deletion. |
| **Inventory** | CRUD operations for per‑character items with idempotency protection. |
| **Banking** | Character bank accounts, deposits, withdrawals and transaction history. |
| **Roles & Permissions** | Role definitions, scope assignments and account role grants. |
| **Scoreboard** | Track online players and broadcast updates through WebSockets. |
| **Webhooks** | Register external endpoints that receive server events. |
| **System** | Health, readiness and time endpoints. |
| **Metrics** | Prometheus metrics at `/metrics` plus per‑request logging. |

#### Service Structure

```
src/
├── app.js            # Express app wiring and middleware
├── server.js         # HTTP + WebSocket bootstrap and scheduler
├── bootstrap/        # Background task scheduler
├── middleware/       # Auth, rate limiting, request id, metrics, idempotency
├── repositories/     # Direct MySQL queries for each domain
├── routes/           # REST endpoints for auth, accounts, inventory, etc.
├── util/             # Logger, time helpers
├── websockets/       # Socket.IO gateway for realtime pushes
├── webhooks/         # Outgoing webhook dispatcher
└── migrations/       # SQL migration files
```

A full OpenAPI specification lives in `backend/srp-base/docs/openapi.yaml` for detailed request and response schemas.

#### Environment Variables

Configure the service with environment variables or a `.env` file.

| Variable | Purpose |
| -------- | ------- |
| `PORT` | HTTP listen port (default `3000`). |
| `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS` | MySQL connection settings. |
| `SRP_HMAC_SECRET` | Shared secret used to validate the `X-SRP-Signature` header. |
| `JWT_SECRET` | Secret for signing access tokens. |
| `TIME_BROADCAST_INTERVAL_MS` | Frequency for system time WebSocket broadcasts. |
| `SCOREBOARD_STALE_MS` | Age threshold for purging stale scoreboard entries. |

#### Running Locally

```sh
cd backend/srp-base
npm install
npm start
```

The server exposes HTTP routes on the configured port and a Socket.IO gateway at `/socket.io`.

### server.cfg

`server.cfg` demonstrates how SunnyRP resources are configured.  Key settings include:

* `srp_api_url` and `srp_api_token` – connection details for the `srp-base` API.
* Feature toggles such as `srp_features`, `srp_chat_enable`, `srp_hud_enabled`, and module‑specific rate limits.
* Extensive ConVars for chat, HUD, inventory, economy, vehicles, jobs, admin tools and more.

These ConVars are consumed by the Lua resources to enable or tune functionality.

### Example Frameworks

The `Example_Frameworks` folder holds copies of well known public frameworks for research purposes only.  SunnyRP does not rely on these frameworks.

## Development

1. Ensure Node.js ≥18 and MySQL are installed.
2. Create a database and apply migrations from `backend/srp-base/src/migrations`.
3. Configure environment variables as above.
4. Launch the backend with `npm start`.
5. Start the FiveM server using the provided `server.cfg`.

## License

This project is licensed under the MIT License – see [LICENSE](LICENSE) for details.

