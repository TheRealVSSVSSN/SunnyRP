Sunny Roleplay (SRP)
 Full Expanded Execution Plan — Server-Authoritative FiveM + Node.js
 Version 1.0 • Prepared for: Sunny Roleplay • Scope: Framework → Parity with top RP servers

Phase 1: Basic framework for major services.


0) Program Charter
 North Star Principles
 • Server-authoritative: FiveM server Lua exclusively performs HTTP to Node.js REST; client/NUI never writes
 state.
 • Strict multicharacter with hard character scoping for all systems (inventory, money, jobs, vehicles, phone,
 records).
 • Zero default FiveM resources: custom spawn manager, map manager, chat, HUD, voice abstraction later.
 • Feature flags for every module; enforcement in backend and Lua.
 • Modular microservices: begin with core-api, split by domain as we scale.
 • SRP namespace contract: SRP.FunctionName = function(params) and srp:* events across all resources.
 Monorepo Structure
 sunny-roleplay/
 server.cfg
 backend/
  core-api/
  mdt-api/ # later
  phone-api/ # later
  shared/ # later shared libs
 resources/
 sunnyrp/
 base/ # framework exports, HTTP, events, identifiers
 chat/ # custom chat
 spawn/ # multicharacter + spawn
 map/ # blips, zones, routing buckets
 hud/ # HUD
 inventory/
 economy/
 vehicles/
 jobs/
 admin/
 police/ # later
 ems/ # later
 properties/ # later
 businesses/ # later
 crime/ # later
 phone/ # later
 nui/ # shared NUI
 1) Global Permission & Role Model
 Role Levels & Scopes
 Role Level Range Purpose / Notes
 Owner 100 All scopes (*). Token/flags/backup governance.
 Admin 80–99 Ops, bans, spectate, cleanup, give/take, teleport.
 Moderator 50–79 Moderation, temp bans/kicks, revive/heal limited.
Developer
 Staff-Trainee
 Representative Scopes
 60–90
 30–49
 Resource control, profiling, debug. No punitive powers unless granted.
 Observation + limited moderation tools.
 • server.manage, server.profile, server.resources.start|stop|restart
 • players.kick, players.ban.temp|perm, players.freeze, players.spectate, players.teleport.self|to|bring
 • players.revive|heal|armor, inventory.give|take, money.give|take
 • vehicles.spawn|delete|impound, admin.noclip|invisible|cleanup.entities, admin.audit.read
 • dev.debug|entity.inspect|profiler, mdt.read|write, dispatch.read|write
 • admin.chat.staff
 DB Entities
 • roles(id, name, level)
 • role_scopes(role_id, scope)
 • user_roles(user_id, role_id)
 • overrides(user_id, scope, allow_boolean)
 API
 • GET /permissions/:userId → {scopes, roles}
 • POST /permissions/grant {userId, roleId|scope}
 • DELETE /permissions/grant {userId, roleId|scope}
 2) Security Model
 • Headers: X-API-Token (required), X-Idempotency-Key (writes), optional X-Nonce, X-Ts, X-Sig
 (HMAC-SHA256).
 • Rate limits per IP & token; higher budgets for staff routes; replay protection using (nonce, ts).
 • Optional IP allowlist; per-route feature flags & scopes; comprehensive audit trail on all writes.
 • Strict input validation (Zod/Joi), sanitized NUI callbacks, message nonces.
 3) Phased Execution Plan (A–S)
 Phases A–S deliver framework → parity features. Each phase includes Deliverables, Definition of Done, DB,
 API, Lua/NUI, and Tests.
 Phase A — Bootstrap & Core Framework
 Goal: Run core-api, SRP base, health/metrics, ConVars & feature flags.
 Deliverables:
 • backend/core-api with Express, Helmet, CORS, rate-limit, pino, request-id, error handler
 • .env schema validation; PM2 ecosystem; rotating logs
 • Health: /health, /ready, /metrics (Prometheus)
• Migrations tooling (e.g., knex/sequelize)
 • resources/sunnyrp/base: SRP singleton, HTTP wrapper with retries & headers, identifier util, event bus, NUI
 helpers
 Definition of Done:
 • FiveM boots base resource cleanly; SRP.Fetch reaches /health
 • Metrics visible; feature flags read from ConVars
 Phase B — Identity & Permissions
 Goal: Create users on connect, link identifiers, bans, roles/scopes, audit.
 DB:
 • users, user_identifiers, roles, role_scopes, user_roles, overrides, bans, audit
 API:
 • POST /players/link, GET /players/:userId
 • GET /permissions/:userId, POST/DELETE /permissions/grant
 • POST /admin/ban|kick, GET /admin/audit
 FiveM:
 • On playerConnecting, collect all IDs + IP, call /players/link, cache scopes; reject if banned.
 Definition of Done:
 • Reconnect updates last_seen_at/IP; sample ACL check enforced server-side.
 Phase C — Multicharacter & Spawn
 Goal: Unlimited characters per config, strict isolation, custom spawn manager.
 DB:
 • characters, character_state, accounts
 API:
 • GET /characters?userId=..., POST /characters, POST /characters/select, DELETE /characters/:id
 FiveM:
 • NUI Character Select; server spawns only after select returns canonical state; routing buckets optional.
 Lua Events:
 • srp:ui:open:charselect, srp:characters:create|select|delete, srp:spawn:choose|at:last|at:location
 Definition of Done:
 • Slot limit enforced by config; swap across chars shows no state bleed; respawn at chosen point.
 Tests:
 • Create 3 chars and swap repeatedly while changing inventory/money; verify isolation.
Phase D — Map Manager
 Goal: Zones/blips/buckets with telemetry.
 DB:
 • map_zones
 API:
 • POST /map/position (opt-in telemetry)
 FiveM:
 • Zone registration API, blip registry, SRP.Map.SetBucket
 Definition of Done:
 • Enter/Exit callbacks; position throttled & stored if enabled.
 Phase E — Custom Chat
 Goal: Local/me/do/ooc/staff channels with ACL and rate limits.
 DB:
 • chat_log
 API:
 • POST /chat/log, GET /chat/history?charId (optional)
 FiveM:
 • Command dispatcher, sanitizer, profanity filter toggle, staff channel gated
 Definition of Done:
 • Operates without default chat; audited messages.
 Phase F — HUD & Status
 Goal: Cash/bank, job/duty, hunger/thirst/stress, voice indicator (placeholder).
 FiveM:
 • NUI HUD; server pushes deltas; low frequency updates.
 Definition of Done:
 • Stable, low-GPU HUD with coalesced updates.
 Phase G — Inventory
 Goal: Item master + character inventory with idempotent writes.
 DB:
 • items, inventory
 API:
 • GET /items, GET /inventory/:charId, POST /inventory/:charId/add|remove
FiveM:
 • SRP.Inventory.RegisterUse, hotbar NUI, ground drops (server-owned with TTL)
 Definition of Done:
 • Add/remove idempotent; hotbar uses trigger server logic.
 Tests:
 • Burst add/remove with same idempotencyKey → single effect.
 Phase H — Economy
 Goal: Cash/bank ledgers, transfers, paychecks, taxes.
 DB:
 • ledger
 API:
 • POST /economy/transfer (idempotent)
 FiveM:
 • /pay, ATM UI; paycheck cron; HUD updates
 Definition of Done:
 • Ledger reconciles; double-spend safe; admin ledger view.
 Phase I — Vehicles
 Goal: Ownership, keys, garages, impound.
 DB:
 • vehicles, impounds
 API:
 • GET /vehicles?charId, POST /vehicles/register|store|retrieve, POST /vehicles/keys/grant|revoke
 FiveM:
 • Server-spawned; anti-dupe; keys share; fuel abstraction hook
 Definition of Done:
 • Retrieve/store cycles consistent; plates unique.
 Phase J — Jobs Framework
 Goal: Civilian & whitelist jobs with duty & pay.
 DB:
 • job_defs, job_grades, jobs
 API:
 • POST /jobs/set, POST /jobs/duty, GET /jobs/definitions
FiveM:
 • Job registry callbacks; access checks; salaries
 Definition of Done:
 • Duty toggling controls pay/access.
 Phase K — Admin Toolkit v1
 Goal: Admin NUI for ops: spectate, noclip, bring/goto, cleanup, bans, audit.
 API:
 • GET /admin/players, POST /admin/actions/*
 FiveM:
 • Scopes enforced on all actions; cool-downs; shadow spectate
 Definition of Done:
 • Every action audited; ACL respected.
 Phase L — LEO/EMS/DOJ Foundations
 Goal: MDT scaffolding, dispatch flow, basic cuff/escort & EMS revive.
 DB:
 • reports, citations, arrests, warrants, ems_calls, dispatch, evidence
 API:
 • CRUD for reports; POST /dispatch/call|attach|clear
 FiveM:
 • /911 & /311 → dispatch; job-gated MDT
 Definition of Done:
 • Create/view MDT entries; dispatch lifecycle works.
 Phase M — Properties & Housing
 Goal: Buy/rent/enter with stash linkage.
 DB:
 • properties, interiors
 API:
 • GET /properties?charId, POST /properties/*
 FiveM:
 • Instance routing; door locks; stash via inventory
 Definition of Done:
 • Single interior path validated end-to-end.
Phase N — Businesses & Shops
 Goal: Business accounting, stock, employee roles; shop purchases.
 DB:
 • businesses, transactions
 API:
 • POST /businesses/*, purchase routes
 FiveM:
 • Cash registers & boss menu; taxes to economy
 Definition of Done:
 • 24/7 shop functional with accounting.
 Phase O — Crime Systems
 Goal: Heat/cooldowns, loot tables, dirty money.
 DB:
 • heat, contraband_flags, heists
 API:
 • POST /crime/heat/add|decay, loot endpoints
 FiveM:
 • Lockpick abstraction; simple robbery loop
 Definition of Done:
 • Cooldowns enforced; heat increments audited.
 Phase P — Phone & Apps
 Goal: SMS, contacts, ads; modular NUI phone.
 DB:
 • phones, messages, contacts, ads
 API:
 • CRUD SMS/contacts/ads; phone numbers
 FiveM:
 • App loader; notifications
 Definition of Done:
 • Send/receive SMS and ads.
 Phase Q — Voice Abstraction
Goal: SRP.Voice interface; native Mumble default; pma adapter optional.
 Definition of Done:
 • Radio channels and PTT indicator integrated with HUD.
 Phase R — Telemetry & Anticheat
 Goal: Metrics, anomaly detectors, alerts, replay/rate protections.
 Definition of Done:
 • Prom/Grafana live; anomalies → audit + staff alert.
 Phase S — Scale & Reliability
 Goal: Redis caches/locks, transactional outbox, multi-instance strategy.
 Definition of Done:
 • Multi-instance smoke test without state loss.
 4) Core Data Model (Initial Tables)
 Table
 Columns (key fields)
 users
 id, primary_identifier, slots_default, created_at, last_seen_at, flags_json
 user_identifiers
 bans
 user_id, type, value, first_ip, last_ip, first_seen, last_seen
 id, user_id, reason, by_user, expires_at, created_at
 characters
 character_state
 id, user_id, first_name, last_name, dob, gender, created_at, deleted_at
 char_id, position_json, health, armor, hunger, thirst, stress, metadata_json
 accounts
 inventory
 char_id, cash, bank, dirty
 char_id, slot, item_id, count, meta_json
 items
 vehicles
 id, name, label, weight, stack, usable, meta_schema_json
 id, char_id, model, plate, garage, stored, props_json
 jobs
 permissions
 char_id, job, grade, on_duty, last_pay_at
 user_id, scope (or role mapping tables)
 audit
 chat_log
 id, actor_type, actor_id, action, target_type, target_id, payload_json, ts
 id, char_id, channel, message, ts
 map_zones
 id, name, type, data_json, flags_json
 5) REST Contracts (Starter Set – Samples)
 POST /players/link
 Request:
 {
 "identifiers":[{"type":"fivem","value":"xyz"}, {"type":"discord","value":"123"}],
 "ip":"203.0.113.5",
"primary":"fivem"
 }
 Response:
 {"userId":"u_123","slotsDefault":2,"roles":["moderator"],"scopes":["players.kick","admin.chat.s
 taff"]}
 GET /characters?userId=u_123
 Response:
 {"slotsAllowed":3,"characters":[{"id":"c_1","firstName":"Alex","lastName":"Ray","lastPos":{"x":
 0,"y":0,"z":72}}]}
 POST /characters/select
 Request:
 {"userId":"u_123","charId":"c_1"}
 Response:
 {
 "character":{"id":"c_1","state":{"pos":{"x":-1037.2,"y":-2735.1,"z":20.1}}},
 "inventory":[{"slot":1,"item":"phone","count":1}],
 "accounts":{"cash":500,"bank":2500},
 "job":{"job":"civ","grade":0},
 "vehiclesLite":[{"id":"v_7","model":"sultan","plate":"SRP123"}]
 }
 POST /inventory/:charId/add
 Request:
 {"item":"water","count":1,"meta":{"quality":100}}
 POST /economy/transfer
 Request:
 {"from":{"type":"cash","charId":"c_1"},"to":{"type":"cash","charId":"c_2"},"amount":250,"reason
 ":"trade","idempotencyKey":"abc-123"}
 6) Lua Contracts (Initial Surface)-- Server
 SRP.Fetch({ path='/health', method='GET' })
 SRP.GetIdentifiers(src)
 SRP.GetPrimaryId(src)
 SRP.Players.Link(src)
 SRP.Characters.List(src)
 SRP.Characters.Create(src, data)
 SRP.Characters.Select(src, charId)
 SRP.Inventory.Add(charId, 'water', 1)
 SRP.Economy.Transfer({ from={type='cash',charId=a}, to={type='cash',charId=b}, amount=100 })
 SRP.Map.SetBucket(src, 0)
 SRP.Perms.Has(userId, 'players.kick')-- Client
 SRP.UI.Open('charselect', payload)
 SRP.Notify('Welcome to Sunny Roleplay', 'info', 5000)-- Events-- srp:player:connecting, srp:player:joined, srp:player:dropped-- srp:characters:create|select|delete-- srp:spawn:choose|at:last|at:location-- srp:map:position:update
-- srp:hud:update
 7) NUI Views (First Pass)
 • Shell: shared NUI index with lightweight router; listens to postMessage events.
 • Character Select: grid with create/delete; slot gating; clean transitions.
 • HUD: cash/bank, job/duty, voice indicator, server time; performance-friendly.
 • Admin Menu: gated; players list, actions, audit view.
 • Chat: custom overlay with channels & timestamps; no default resource dependency.
 8) Data Governance & Identifier Policy
 • Capture all identifiers: license, license2, fivem, discord, steam, xbl, live, ip (and HWID if available).
 • Configurable primary identifier; enforce required identifier set on connect (e.g., require Discord).
 • Store first/last IP and timestamps; restrict display to Owner/Admin via scope.
 9) Testing Strategy
 • Unit tests: validators, services, repositories (backend).
 • Integration tests: endpoint coverage with test DB + idempotency checks.
 • Acceptance: scripted in-game flows per phase (spawn 10 fake players).
 • Negative tests: duplicate idempotency keys, race conditions on inventory/economy.
 10) Observability & Operations
 • Prometheus metrics (latency, error rate, QPS, mutation rates, entity counts, tick time).
 • Logs via pino (JSON + requestId); daily rotation; separate security log for sensitive actions.
 • Grafana dashboards; ELK/Loki optional; alarms on 5xx spikes, auth failures, dupes, ledger anomalies.
 11) Anti-Cheat Foundations
 • Server-side verification: inventory writes, money deltas, vehicle spawns, teleport deltas, speed thresholds.
 • Cooldowns & rate caps on sensitive actions; signed NUI callbacks; replay protection.
 • Shadow bans (optional) for investigations.
 12) Migration & Content Strategy
 • Idempotent, reversible migrations; seed items/jobs/garages/spawn points.
 • Schemas include future hooks: appearance_json, vehicle props for custom content.
 13) Microservice Decomposition Path
 • Start with core-api; split to identity/character/inventory/economy/vehicles/jobs/admin/map.
• Dedicated mdt-api and phone-api once feature complexity/traffic warrants.
 • backend/shared for logger, auth, validation, common DTOs.
 14) Staffing & Access Playbook
 • Owner: roles, tokens, feature flags, backups.
 • Admin: daily operations, bans, event cleanup.
 • Moderator: reports handling; limited tools; no financial powers.
 • Developer: deploy resources, profiling, dev flags; no punitive powers unless explicitly granted.
 • Change control: PRs + reviews required for backend and base resource.
 15) Deliverable Checklists — Example (Inventory)
 • DB: items, inventory; migrations + rollbacks.
 • Service rules: weight/stack/meta validation; server-only mutations.
 • Routes: list items, get inv, add/remove with idempotency.
 • Lua: SRP.Inventory.* server handlers; client hotbar; NUI wiring.
 • ACL: spawn restricted to scopes; no client trust.
 • Audit: add/remove recorded with actor/target metadata.
 • Tests: concurrency + idempotency; negative cases.
 • Docs: OpenAPI updated + Postman examples.
 16) Risk Register & Mitigations
 • State bleed between characters → enforce charId in every API + cache key; automated tests.
 • Dupes via retries → mandatory X-Idempotency-Key + DB uniqueness on (route,key).
 • Admin abuse → audit + scope ACL + cooldowns; optional two-person approval for mass actions.
 • Performance regressions → budgets + alerts in CI; profiling hooks.
 • API token leakage → rotation, per-env scoping, least privilege.
 17) Initial Timeline (Aggressive, Realistic)
 Week
 Phases / Focus
 1
 A–B: Bootstrap, Identity/Perms/Audit
 2
 3
 C–E: Multicharacter, Spawn, Map, Chat
 F–H: HUD, Inventory, Economy
 4
 5–6
 I–K: Vehicles, Jobs, Admin v1
 L–O: MDT/EMS, Properties, Businesses, Crime
 7
 8
 P–R: Phone, Voice, Telemetry/Anticheat
 S: Scale, hardening, docs, polish
18) Immediate Next Step (Implementation Package A–C)
 • backend/core-api scaffolding + migrations for users/identifiers/roles/perms/bans/audit.
 • resources/sunnyrp/base: SRP exports, HTTP wrapper, identifier capture, event bus, feature flags, NUI helpers.
 • resources/sunnyrp/spawn + chat + hud: skeletons wired to SRP API and backend.
Prepared by: SRP Engineering • All designs © Sunny Roleplay. This document outlines a modular, server-authoritative architecture
 intended to scale into a Top-class competitor while retaining customization and maintainability.