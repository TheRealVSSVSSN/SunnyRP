# DiamondBlackjack Resource Documentation

## Title & Summary
DiamondBlackjack adds an interactive blackjack minigame for the casino interior. It spawns dealer NPCs, manages seating, handles bets, and synchronizes card dealing between clients and the server.

## File Inventory
- **fxmanifest.lua** – Resource metadata, script loading order, and audio/ped data.
- **cl_blackjack.lua** – Client logic for table detection, animations, bet menus, and card rendering.
- **sv_blackjack.lua** – Server game coordinator, seat tracking, bet validation, and hand resolution.
- **peds.meta** – Defines dealer ped metadata.
- **src/** – RageUI menu framework and UI components.
- **audio/** & **stream/** – Casino sound assets and models.

## Runtime & fxmanifest Overview
- Targets `cerulean` build with `lua54` runtime.
- Client scripts load RageUI utilities followed by `cl_blackjack.lua`.
- Server script: `sv_blackjack.lua`.
- Audio and ped metadata files are registered via `data_file` entries.

## Event Map
```
Client -> Server: Blackjack:requestBlackjackTableData (fetch table occupancy)
Server -> Client: Blackjack:sendBlackjackTableData (broadcast seat states)
Client -> Server: Blackjack:requestSitAtBlackjackTable(chairId)
Server -> Client: Blackjack:sitAtBlackjackTable(chairId)
Client -> Server: Blackjack:setBlackjackBet(gameId, amount, chairId)
Server -> Clients: Blackjack:beginBetsBlackjack / successBlackjackBet / syncChipsPropBlackjack
Client -> Server: Blackjack:hitBlackjack / Blackjack:standBlackjack (per card draw)
Server -> Clients: Blackjack:beginCardGiveOut / singleCard / standOrHit / endStandOrHitPhase
Server -> Clients: Blackjack:blackjackWin / blackjackLose / blackjackPush / chipsCleanup
```
Critical parameters: `chairId` (0‑127), `gameId` (random session id), bet amount (`<=5000`).

## Configuration
No convars or commands are defined; bet limits and table positions are hardcoded in `cfg.blackjackTables`.

## Systems/Features
- **Table Management** – Detects proximity to casino tables and spawns dealer NPCs.
- **Betting Flow** – Server validates chip removal, enforces $5000 cap, and tracks per-player hands.
- **Card Dealing** – Server generates random cards and streams animations; client draws card objects.
- **Dealer Logic** – Simulates dealer AI hitting until 17 and resolves payouts.

## Networking & OneSync Notes
- Uses server events with numerical validation to prevent seat spoofing.
- Game state is server‑authoritative; clients render based on broadcast events.
- Ensure OneSync is enabled so dealer peds and card objects stream correctly.

## Security & Anti-abuse Considerations
- Server checks bet amounts, available cash, and chairId ranges.
- Player cash is modified only server-side via `np-base` exports.
- Threads include waits to avoid CPU saturation.

## Troubleshooting & Profiling Hooks
- Server prints game IDs and uses `print` statements for debugging deals and responses.
- Use built-in FiveM profiler (`profiler`) when diagnosing performance issues.

## Changelog of Refactors
- Added Lua 5.4 runtime flag in `fxmanifest.lua`.
- Replaced deprecated `GetPlayerPed(-1)` calls with `PlayerPedId()`.
- Added chair and bet validation in server events; guarded hit/stand handlers.
- Documented chip transfer helpers with structured comments.

## References
- [FiveM Events](https://docs.fivem.net/docs/scripting-reference/events/)
- [PlayerPedId](https://docs.fivem.net/natives/?_0xD80958FC74E988A6)

RESOURCE-CONTINUE-HERE — 2025-09-12T22:43:32+00:00 — next: expand Systems/Features
