# srp-base Service

Baseline microservice offering account management, authentication, webhook administration, and real-time infrastructure.
Renumbered inventory migration to 0005 to resolve duplicate numbering.
Adds periodic system time broadcast and `/v1/time` endpoint.
Introduced role-based authorization with database-backed scopes and configurable system time settings.
Scheduler persists task run times for resilience across restarts and mirrors WebSocket events to webhook endpoints for unified real-time delivery.
Exposed Prometheus metrics at `/metrics` for service monitoring.
Introduced scoreboard module tracking active players with WebSocket updates.
Instrumented per-route HTTP metrics using Prometheus middleware.
Introduced telemetry module logging service errors with WebSocket broadcast and scheduled purging.
Implemented connection queue module managing login order with REST API, WebSocket events, and scheduled cleanup.
Added scheduler administration endpoints for listing and manually triggering tasks.
Added voice channel management with REST endpoints, WebSocket events, and scheduled purging.
Implemented sessions module enforcing account whitelist, login password, CID assignment, hospitalization, and configurable hardcap limits.
Introduced jobs module managing primary and secondary assignments.
Added world module with weather synchronization, zone management, and barriers.
Introduced UX module providing chat, voting, taskbar progress, and broadcast notifications.
Extended telemetry with RCON logging, remote code execution, restart scheduling, and debug hooks.
Expanded automated test coverage with additional auth enforcement tests.
Added sessions module enforcing account whitelist and configurable hardcap limits.
Introduced jobs module managing primary and secondary assignments.
Added weather synchronization with REST control and real-time broadcast.
Expanded automated test coverage with readiness, info, and metrics endpoint tests.
Added scheduler persistence tests verifying task run time storage.
Reviewed NoPixel base resources and documented outstanding modules such as session lifecycle, world zones, and chat/vote UI.
Added coordinate saving, spawn logging, broadcaster role management, population metrics, and expanded notification endpoints.
Implemented infinity entity streaming with REST APIs and scheduled purge, and enforced broadcast participation limits.
Refactored WebSocket gateway with domain-specific namespaces, account/character validation, and broadcast rate limiting.