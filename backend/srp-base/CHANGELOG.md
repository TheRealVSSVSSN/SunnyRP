# Changelog

## 2025-08-30
- Add credential verification with JWT token issuance and refresh tokens stored in MySQL.

## 2025-08-30
- Initialize srp-base service baseline with accounts/characters APIs, WebSocket gateway, webhook dispatcher, and scheduler.

## 2025-08-30
- Persist idempotency keys in MySQL.
- Add JWT authentication with scope checks.
- Expose webhook endpoint management API and scheduler purge task.
- Improve JWT middleware logging and differentiate token error responses.

## 2025-08-30
- Renumber inventory migration to 0005 to resolve duplicate numbering.

## 2025-08-30
- Broadcast system time over WebSocket and expose `/v1/time` endpoint.

## 2025-08-31
- Reviewed outstanding tasks and cleaned up task lists.

## 2025-08-31
- Persisted roles and permission scopes with database-backed authorization.
- Added configurable timezone and broadcast interval for system time.

## 2025-09-01
- Persist scheduler task run times in MySQL for idempotent scheduling.

## 2025-09-01
- Mirror WebSocket events to webhook dispatcher for external sinks.

## 2025-09-01
- Expose Prometheus metrics at `/metrics` for monitoring.


## 2025-09-02
- Add scoreboard module with REST endpoints, WebSocket events, and stale player purge.

## 2025-09-03
- Instrument per-route HTTP metrics and remove residual task markers.

## 2025-09-03
- Add job metadata and sorting to scoreboard players.

## 2025-09-04
- Introduce telemetry error logging with REST endpoints, WebSocket events, and scheduled purging.

## 2025-09-05
- Implement connection queue module with REST API, WebSocket notifications, and scheduled cleanup.

## 2025-09-06
- Add scheduler administration endpoints for listing and manually triggering tasks.

## 2025-09-07
- Add voice channel management with REST endpoints, WebSocket events, and scheduled cleanup.

## 2025-09-08
- Add automated tests for readiness, info, and metrics endpoints.

## 2025-09-09
- Add scheduler persistence tests verifying repository run tracking.

## 2025-09-10
- Catalog NoPixel base resources and record outstanding gaps.

## 2025-09-11
- Add sessions whitelist and hardcap management with REST endpoints, WebSocket events, and database migrations.

## 2025-09-12
- Introduce jobs module with primary and secondary job support, REST endpoints, and WebSocket events.
- Add weather synchronization with persistent state, REST control, and real-time broadcast.

## 2025-09-13
- Implement session lifecycle with login password, CID assignment, and hospitalization flows.
- Add world zone and barrier management with REST endpoints and WebSocket events.
- Introduce UX module for chat, voting, taskbar progress, and broadcast messaging.
- Extend telemetry with RCON logging, remote code execution, restart scheduling, and debug hooks.
- Add sessions whitelist and hardcap management with REST endpoints, WebSocket events, and database migrations.

## 2025-09-14
- Add coordinate saving, spawn logging, population metrics, broadcaster state, and expanded notification endpoints.

## 2025-09-15
- Track infinity entity coordinates with REST endpoints and scheduled purge.
- Enforce broadcast participation limits and expose active broadcaster list.

## 2025-09-16
- Refactor WebSocket gateway with per-domain namespaces, account and character validation, and broadcast rate limiting.

## 2025-09-17
- Parallelize webhook dispatch, persist failed deliveries, and schedule retries with exponential backoff.

