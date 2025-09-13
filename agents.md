# Repository Guidelines

## Project Structure & Module Organization
- `backend/srp-base/` – Node.js service (HTTP + WebSocket) for accounts, characters, inventory, etc. Key folders: `src/middleware/`, `src/routes/`, `src/repositories/`, `src/realtime/`, `src/util/`.
- `resources/` – FiveM Lua resources. Each uses an `fxmanifest.lua` with `server/` and `shared/` code (e.g., `resources/srp-base`).
- `server.cfg` – FiveM configuration and ConVars consumed by Lua resources.
- `Example_Frameworks/` – Reference-only frameworks; not used by SunnyRP.

## Build, Test, and Development Commands
- Backend
  - `cd backend/srp-base && npm install` – install dependencies.
  - `npm start` – start the API (`node src/server.js`).
- FiveM server (example)
  - `/path/to/FXServer +exec server.cfg` – launch with this repo’s config.
  - Set API ConVars in `server.cfg` (e.g., `srp_api_url`, `srp_api_token`).

## Coding Style & Naming Conventions
- JavaScript (Node): CommonJS modules, 2-space indent, semicolons, single quotes; small, composable middleware and routers.
  - Filenames: `kebab-case` for routes/middleware (e.g., `base.routes.js`).
- Lua (FiveM): 2-space indent, lowercase `snake_case` filenames; avoid globals. Prefer the provided export pattern (`resources/srp-base/shared/srp.lua`: `SRP.Export("name", fn)`).
- JSON/YAML: compact, trailing commas avoided. Keep `fxmanifest.lua` ordered: `fx_version`, `lua54`, description, `shared_scripts`, `server_scripts`.

## Testing Guidelines
- Backend: unit tests for middleware, routes, and repositories are encouraged (framework of choice: Jest or tap). Add `npm test` and keep it fast; target 70%+ coverage for touched files.
- Lua: add minimal behavior tests where possible or create reproducible scenarios in a local server session; document steps in PRs.

## Commit & Pull Request Guidelines
- Commits: present tense, concise, and scoped. Prefer Conventional Commits: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`.
- PRs: include a clear summary, linked issue (if any), reproduction/validation steps, config changes (ConVars/env), and screenshots/logs for errors. Keep changes focused per PR.

## Security & Configuration Tips
- Never commit secrets. Provide `.env` locally; required vars include `SRP_HMAC_SECRET` and `JWT_SECRET` for `srp-base`.
- Validate all inbound RPC with HMAC (`X-SRP-Signature`) and keep tokens out of `server.cfg` history.
- Use rate limiting and idempotency middleware for mutating routes.

