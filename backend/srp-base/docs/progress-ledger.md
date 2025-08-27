# Progress Ledger – SRP‑Base Node Backend

| Index | Resource | Summary of Server Responsibilities | Decision | Notes |
|---|---|---|---|---|
| 1 | DiamondBlackjack | Casino blackjack tables; persist hand outcomes for analytics | Create | Added hand history API |
| 2 | InteractSound | Play sound effects for players; log sound playback events | Create | Added sound play API |
| 3 | LockDoors | Door state persistence and management | Extend | Added OpenAPI spec and documentation |
| 4 | PolicePack | Evidence custody chain and account character selection | Create | Added custody and selection APIs |
| 5 | PolyZone | Zone definitions and management | Create | Added zone storage API |
| 6 | Wise Audio | Custom audio track storage per character | Create | Added track storage API |
| 7 | Wise Imports | Vehicle import order tracking per character | Create | Added order storage API |
| 8 | Wise-UC | Undercover alias profiles per character | Create | Added profile API |
| 9 | WiseGuy-Vanilla | Baseline character management; remove legacy unscoped endpoints | Extend | Consolidated account-scoped APIs |
| 10 | WiseGuy-Wheels | Wheel spin logging per character | Create | Added spin history API |
| 11 | assets | Store and retrieve character-bound asset metadata | Create | Added asset APIs |
| 12 | assets_clothes | Save and manage character outfit data | Create | Added clothing outfit APIs |
| 13 | maps | World mapping assets; no server interaction | Skip | Asset-only |
| 14 | furnished-shells | Interior shell models; no persistence | Skip | Asset-only |
| 15 | hair-pack | Hair style models; no backend | Skip | Asset-only |
| 16 | mh65c | Helicopter model assets; no backend | Skip | Asset-only |
| 17 | motel | Motel interior assets; no backend | Skip | Asset-only |
| 18 | shoes-pack | Footwear model assets; no backend | Skip | Asset-only |
| 19 | yuzler | Clothing asset pack; no backend | Skip | Asset-only |
| 20 | apartments | Apartment definitions and resident assignments | Extend | Added character-scoped residency and GET filter |
| 21 | banking | Character bank accounts and transactions | Extend | Added account and transaction APIs |
| 22 | baseevents | Player lifecycle and combat events logging | Create | Added base event log API |
| 23 | boatshop | Boat catalog and purchases for characters | Create | Added listing and purchase endpoints |
| 24 | bob74_ipl | Loads interior proxy definitions; purely client-side mapping | Skip | Asset-only |
| 25 | camera | Capture and store character photos; provide gallery management | Create | Added photo storage API |
| 26 | carandplayerhud | Store per-character HUD preferences | Create | Added HUD preference API |
| 27 | carwash | Vehicle cleaning service; log washes and dirt levels | Create | Added carwash endpoints |
| 28 | chat | In-game chat message logging for moderation | Create | Added chat message API |
| 29 | connectqueue | Manage account queue priorities | Create | Added priority management APIs |
| 30 | Cron | Schedule timed server tasks with optional character scope | Create | Added cron job API |
| 31 | coordsaver | Save and recall world coordinates per character | Create | Added coordinate storage APIs |
| 32 | drz_interiors | Interior layout persistence per apartment | Create | Added interior storage API |
| 33 | emotes | Character favorite emote persistence | Create | Added emote favorite APIs |
| 34 | emspack | EMS medical records and duty shift tracking | Extend | Documented record APIs and added shift logs |
| 35 | es_taxi | Taxi job dispatch and ride logging | Create | Added taxi request API |
| 36 | furniture | Furniture placement persistence per character | Create | Added furniture APIs |
| 37 | gabz_mrpd | Mission Row PD mapping; no server logic | Skip | Asset-only |
| 38 | gabz_pillbox_hospital | Pillbox hospital admissions and bed tracking | Create | Added patient admission API |
| 39 | garages | Vehicle storage per character with garage definitions | Extend | Added character-scoped storage API |
| 40 | ghmattimysql | MySQL middleware offering execute, scalar and transaction utilities | Extend | Added named parameters, scalar and transaction helpers |
| 41 | hardcap | Enforce player slot limits and track active sessions | Create | Added config and session APIs |
| 42 | heli | Helicopter flight logging and tracking | Create | Added flight tracking API |
| 43 | import-Pack | Vehicle import package tracking per character | Create | Added import package API |
| 44 | import-Pack2 | Enhanced import package management with pricing and cancellation | Extend | Added order retrieval and cancel endpoints |
| 45 | isPed | Character ped model and state persistence | Create | Added ped state APIs |
| 46 | jailbreak | Track jailbreak attempts and outcomes | Create | Added attempt logging API |
| 47 | k9 | Police K9 unit assignments and status tracking | Create | Added K9 unit APIs |
| 47 | jobsystem | Manage job definitions, assignments and duty status | Create | Added character-scoped jobs API |
| 48 | srp-debug | Developer diagnostics endpoints | Create | Added server status API |
| 49 | srp-weathersync | Global weather synchronization with forecast scheduling | Extend | Added world state documentation and forecast API |
| 50 | DiamondCasino | Unified casino games (blackjack, slots, horse racing) | Create | Added casino game and bet APIs, removed legacy blackjack module |
| 51 | WebSocketGateway | Real-time push notifications | Create | Added WS gateway with heartbeat and auth |
| 52 | WebhookDispatcher | External webhook delivery | Create | Added HMAC-signed dispatcher |
| 53 | Scheduler | Server-side loop migration | Create | Added jittered task scheduler |
| 50 | climate-overrides | Timecycle overrides and weather preset controls | Extend | Added world timecycle API |
| 54 | InteractSound cluster | Sound play logging with WS/webhooks and retention scheduler | Extend | Broadcast plays and purge stale records |
| 55 | Police dispatch | Alert broadcasting and retention | Extend | WS/webhook push and hourly purge |
| 56 | PolyZone expiry & pushes | Zone expiration and real-time broadcasts | Extend | Added expiresAt field and scheduler |
| 57 | Wise cluster realtime | WebSocket/webhook pushes for Wise Audio/Imports/UC/Wheels | Extend | Broadcast create events |
| 58 | Wise Imports ready notifier | Promote pending import orders to ready via scheduler and delivery endpoint | Extend | Added ready scheduler and `/v1/wise-imports/orders/{id}/deliver` |
| 59 | WiseGuy-Wheels | Spin retention and expiry events | Extend | Purge spins older than 30 days; broadcast `wise-wheels.spin.expired` |
| 60 | assets realtime | Asset create/delete pushes and cleanup scheduler | Extend | Broadcast events and hourly purge |
| 61 | properties | Unified apartments, garages and rentals backend | Create | Added properties API and lease expiry scheduler |
| 62 | banking | Invoices and realtime events | Extend | Added invoice APIs, WS/webhook pushes and purge scheduler |
| 63 | baseevents | Base event logging with realtime and retention | Extend | Broadcast log events and purge stale records |
| 64 | boatshop realtime | Catalog broadcasts and purchase pushes | Extend | WebSocket/webhook events and scheduler |
| 65 | bob74_ipl | Interior proxy toggle persistence and broadcast | Create | Added IPL state API and scheduler |
| 66 | camera realtime | Photo create/delete push events and retention purge | Extend | Broadcast events and purge old photos |
| 67 | carandplayerhud | Vehicle and player HUD status sync | Extend | Added vehicle-state API with WebSocket broadcast and cleanup scheduler |
| 68 | carwash realtime | Vehicle dirt ticks and broadcasts | Extend | Mounted routes, added scheduler, WS & webhook pushes |
| 69 | chat realtime | In-game chat WS/webhook push and retention purge | Extend | Broadcast `chat.message` and purge old entries |
| 70 | connectqueue realtime | Queue priority pushes and expiry purge | Extend | Broadcast `priority.*` events and scheduler cleanup |
| 71 | coordsaver → coordinates | Rename with realtime events and retention | Extend | Broadcast saves/deletes, daily purge task |
| 72 | cron | Scheduled job execution pushes | Extend | Added cron executor with WebSocket/webhook dispatch |
| 73 | drz_interiors | Broadcast interior updates with per-character uniqueness | Extend | WebSocket/webhook events and unique index migration |
| 74 | emotes realtime | Favorite emote sync and retention | Extend | Added WS/webhook pushes and hourly purge |
| 75 | emspack realtime | EMS shift sync and record events over WS/webhooks | Extend | Broadcast events and scheduler end stale shifts |
| 76 | es_taxi realtime | Taxi dispatch pushes and expiry scheduler | Extend | Broadcast request events; cancel stale requests |
| 77 | furniture realtime | Furniture place/remove pushes and retention purge | Extend | Broadcast events and daily purge |
| 78 | gabz_mrpd | Mission Row PD duty roster with realtime pushes and stale-duty scheduler | Create | Added roster API, WS/webhook events and cleanup task |
| 79 | gabz_pillbox_hospital | Pillbox hospital admissions realtime and auto-discharge | Extend | Added WS/webhook pushes and scheduler |
| 80 | garages realtime | Vehicle store/retrieve pushes with retention purge | Extend | Added WS/webhook events and cleanup scheduler |
| 81 | hardcap realtime | Session WS/webhook pushes and stale session purge | Extend | Broadcast config/session events; cleanup job |
| 82 | heli realtime | Helicopter flight events with stale-flight auto end | Extend | Broadcast start/end/expired and scheduler `heli-expire-flights` |
| 83 | import-Pack expiry | Import package auto-expiry with WS/webhook notifications | Extend | Added expiresAt columns, expiry scheduler and broadcasts |
| 84 | isPed realtime | Ped state persistence with regen pushes | Extend | Added WS/webhook events and health regen scheduler |
