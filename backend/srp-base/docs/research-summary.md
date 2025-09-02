# Research Summary

## Overview

Surveyed NoPixel base resources to inform SRP session lifecycle, world streaming, UX, and telemetry:
- `np-login` enforces server login password.
- `np-cid` assigns persistent character IDs.
- `np-hospitalization` manages hospital admissions and discharges.
- `np-infinity` streams player and entity coordinates for population control.
- `PolyZone` defines world zones for streaming.
- `np-barriers` provides barrier definitions tied to zones.
- `spawnmanager` handles spawn lifecycle events.
- `coordsaver` stores character positions.
- `np-broadcaster` assigns a broadcaster job with limited active slots.
- `np-taskbarskill`, `np-taskbarthreat`, `np-tasknotify`, and `pNotify` drive notifications and meters.
- `chat`, `np-votesystem`, and `np-taskbar` handle messaging, voting, and progress bars.
- `rconlog` records RCON commands.
- `runcode` executes arbitrary server code.
- `np-restart` schedules server restarts.
- `koil-debug` broadcasts debug information.

## Key Signals
- Database tables: `users_whitelist`, `session_password`, `character_cids`, `hospitalizations`, `world_zones`, `world_barriers`, `chat_messages`, `votes`, `character_coords`, `character_spawns`, `voice_broadcast`, `rcon_logs`, `exec_logs`, `restart_schedule`, `debug_logs`.
 - Events: login password verification, CID assignment, hospitalization triggers, spawn logging, coordinate saves, infinity entity updates, zone creation, barrier setup, broadcaster toggled, chat message broadcast, vote start and cast, taskbar and notification updates, RCON command logged, code executed, restart scheduled, debug log.
- Loops: restart scheduler polls for due restarts.

## SRP Module Mapping
- `np-login` ➜ session login password.
- `np-cid` ➜ CID assignment.
- `np-hospitalization` ➜ hospitalization flows.
- `np-infinity`/`PolyZone` ➜ world zones.
- `np-barriers` ➜ barriers.
- `chat` ➜ chat messages.
- `np-votesystem` ➜ voting.
- `np-taskbar` ➜ taskbar progress.
- `np-broadcaster` ➜ voice broadcast roles.
- `np-infinity` ➜ infinity entity streaming.
- `spawnmanager` ➜ spawn logging.
- `coordsaver` ➜ coordinate persistence.
- `np-taskbarskill` ➜ skill meter.
- `np-taskbarthreat` ➜ threat meter.
- `np-tasknotify` ➜ task notifications.
- `pNotify` ➜ generic notifications.
- `rconlog` ➜ RCON logging.
- `runcode` ➜ remote code execution.
- `np-restart` ➜ restart scheduling.
- `koil-debug` ➜ debug hooks.

## Risks / Blockers
- None identified beyond standard security considerations for remote code execution.

Surveyed NoPixel base resources to inform SRP sessions enforcement:
- `np-whitelist` loads `users_whitelist` and `jobs_whitelist` tables and hooks into connection queue events.
- `hardcap` monitors player counts via `playerConnecting` and enforces `sv_maxclients` limit.

## Key Signals
- Database access: `users_whitelist`, `jobs_whitelist`, `characters` tables.
- Events: `Queue.OnJoin`, `hardcap:playerActivated`, `playerConnecting`.
- Loops: whitelist refresh uses timers; hardcap client thread triggers server event once session starts.

## SRP Module Mapping
- `np-whitelist` ➜ sessions whitelist repository and routes.
- `hardcap` ➜ sessions hardcap configuration.

## Risks / Blockers
- Full session lifecycle (CID assignment, hospitalization) remains unimplemented pending further evidence.