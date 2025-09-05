# Framework Compliance

## SRP-BASE Compatibility
- Implements required `/v1/health`, `/v1/ready`, and `/v1/info` endpoints.
- Provides multi-character APIs under `/v1/accounts`.
- WebSocket handshake validates `sid`, `accountId`, and `characterId` and rejects unauthorized clients.
- Issues and refreshes JWT tokens with scoped access.
- Inventory and banking modules expose REST endpoints with scope enforcement.
- JWT auth middleware logs verification errors and differentiates missing, malformed, expired, and invalid tokens.
- Scheduler broadcasts system time to clients via WebSocket.
- Scheduler persists last run state in MySQL for idempotency.
- WebSocket gateway serves per-domain namespaces under `/ws/<domain>` with broadcast rate limiting.
- Scheduler administration endpoints expose task runs and manual triggers with scope enforcement.
- WebSocket events mirror to webhook dispatcher for external systems.
- Scoreboard module exposes REST endpoints and WebSocket updates for active players.
- Telemetry module logs service errors, RCON commands, debug messages, remote code execution results, and restart schedules with WebSocket broadcast and scheduled purge.
- Prometheus metrics exposed at `/metrics` for monitoring.
- Per-route HTTP metrics collected with Prometheus counters and histograms.
- Connection queue module manages login order with REST API, WebSocket events, and scheduled pruning.
- Voice module manages channel membership with REST endpoints, WebSocket events, and scheduled cleanup.
- Voice module now tracks broadcaster state with REST endpoints and WebSocket events.
- Voice module enforces broadcast participation limits and lists active broadcasters.
- Sessions module enforces account whitelist, login password, CID assignment, hospitalization, and configurable hardcap limits.
- Sessions module records spawns and exposes population counts.
- Jobs module assigns primary and secondary jobs with REST endpoints and real-time events.
- World module manages weather, zones, and barriers with REST control and WebSocket broadcast.
- World module persists character coordinates.
- World module tracks infinity entity coordinates with scheduled purge.
- UX module provides chat, voting, taskbar progress, and broadcast messaging.
- UX module now supports notifications, skill and threat meters, and task notifications.

## Outstanding Items
- None.