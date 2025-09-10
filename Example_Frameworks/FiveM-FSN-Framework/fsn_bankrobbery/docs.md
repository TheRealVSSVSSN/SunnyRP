# fsn_bankrobbery Documentation

## Overview
Implements bank and front desk robberies for the FSN framework. Players crack keypad codes to open vault doors, loot payouts, and optionally rob armored trucks for drills or cash. Server logic enforces cooldowns and distributes rewards.

## Table of Contents
- [fxmanifest.lua](#fxmanifestlua)
- [client.lua](#clientlua)
- [cl_safeanim.lua](#cl_safeanimlua)
- [cl_frontdesks.lua](#cl_frontdeskslua)
- [server.lua](#serverlua)
- [sv_frontdesks.lua](#sv_frontdeskslua)
- [trucks.lua](#truckslua)

## fxmanifest.lua
Configuration manifest.
- Declares FiveM build *bodacious* and GTA V game target.
- Loads FSN utility and settings scripts for both client and server, plus MySQL async library (no direct queries inside this resource).
- Registers client scripts `client.lua`, `cl_safeanim.lua`, and `cl_frontdesks.lua` and server scripts `server.lua` and `sv_frontdesks.lua`.

## client.lua (Client)
Main client logic for bank vault interaction and auxiliary robbery mechanics.
- Tracks global `canrob` flag from the server via `fsn_bankrobbery:timer`.
- Registers `fsn_main:character` to request initial vault states from the server.
- Handles door state updates (`fsn_bankrobbery:init`, `:openDoor`, `:closeDoor`) and manipulates door entities accordingly.
- Keypad cracking: players either input randomised codes or hold a crack command that triggers `fsn_police:dispatch` and notifies the server with `fsn_bankrobbery:start`. Successful crack stores the code locally and allows vault access.
- Vault looting: requires a drill item and optionally a modified drill bit; sends `fsn_bankrobbery:payout` to the server. Extra drill‑bit parameter is ignored server‑side (Inferred High).
- Exits reset access, send `fsn_bankrobbery:vault:close` to server, and notify players.
- Contains a thread spawning a drill pickup from a stationary hardware truck using custom vehicle enumeration utilities.
- Defines `fsn_bankrobbery:LostMC:spawn` event whose body is entirely commented out.

## cl_safeanim.lua (Client)
Standalone safe‑cracking minigame.
- `safecracking:start` begins the sequence and announces progress to HUD.
- `safecracking:loop` handles user input, rotates a dial, and plays audio/animation until all locks align; emits `safe:success` on completion.

## cl_frontdesks.lua (Client)
Front‑desk computer hacking.
- On resource start requests desk data from the server (`fsn_bankrobbery:desks:request`).
- Receives desk structures via `fsn_bankrobbery:desks:receive` and uses `Util.Tick` to continuously process doors and keyboards.
- When a bank’s front door is unlocked, players can initiate a hacking minigame (`mhacking:start`) that notifies the server with `fsn_bankrobbery:desks:startHack` and reports results with `fsn_bankrobbery:desks:endHack`.

## server.lua (Server)
Authoritative vault state and payouts.
- Maintains per‑bank door status and dynamically growing cash pools tied to global banking activity (`fsn_main:money:bank:Add/Minus`).
- Periodically checks a 30‑minute cooldown before re‑enabling robberies and broadcasts `fsn_bankrobbery:timer` accordingly.
- Processes open/close requests for vault doors and relays events to clients.
- On `fsn_bankrobbery:payout`, deducts a random slice of the bank’s pool, grants dirty money, sends notifications, and applies stress.

## sv_frontdesks.lua (Server)
Server side for front‑desk robberies.
- Stores door and keyboard definitions for multiple bank branches and randomises individual payouts.
- Handles unlock requests and hacking lifecycle events (`fsn_bankrobbery:desks:startHack`, `:endHack`, and `:doorUnlock`). Successful hacks deposit funds via `fsn_bank:change:bankAdd`; failures may allow a retry with specialised equipment (Inferred High).
- Every 15 minutes resets desk states and payouts.

## trucks.lua (Client)
Armored truck robbery minigame. Not referenced by the manifest and appears unused (Inferred Low).
- Spawns roaming `stockade` trucks with armed guards and cash pickups.
- Collecting the security case grants dirty money and triggers notifications.

## Cross‑Index
### Events
| Name | Side | Direction | Parameters | Description |
| ---- | ---- | --------- | ---------- | ----------- |
| `fsn_bankrobbery:timer` | Client | Server → Client | `state` (bool) | Enables or disables robbery attempts. |
| `fsn_main:character` | Client | External → Client | none | Requests initial vault state. |
| `fsn_bankrobbery:init` | Client/Server | Server → Client | table of door statuses | Synchronises door status on join. |
| `fsn_bankrobbery:openDoor` | Client/Server | Server → Client | `id` | Rotates vault door open. |
| `fsn_bankrobbery:closeDoor` | Client/Server | Server → Client | `id` | Rotates vault door closed. |
| `fsn_bankrobbery:vault:open` | Server | Client → Server | `id` | Player requests to open door. |
| `fsn_bankrobbery:vault:close` | Server | Client → Server | `id` | Player requests to close door. |
| `fsn_bankrobbery:start` | Server | Client → Server | none | Marks start of a vault cracking attempt. |
| `fsn_bankrobbery:payout` | Server | Client → Server | `id`, `hasModifiedBit` (ignored) | Requests vault payout. |
| `fsn_bankrobbery:desks:request` | Server | Client → Server | none | Client asks for desk definitions. |
| `fsn_bankrobbery:desks:receive` | Client | Server → Client | desk table | Updates front‑desk state. |
| `fsn_bankrobbery:desks:startHack` | Server | Client → Server | `bank`, `keyboard` | Begin hacking a keyboard. |
| `fsn_bankrobbery:desks:endHack` | Server | Client → Server | `bank`, `keyboard`, `success` | Report hacking result. |
| `fsn_bankrobbery:desks:doorUnlock` | Server | Client → Server | `bank` | Unlocks a bank’s front door. |
| `safecracking:start` | Client | External → Client | none | Starts safe minigame. |
| `safecracking:loop` | Client | External → Client | none | Performs safe crack logic. |
| `safe:success` | Client | Client → External | none | Signals successful safe cracking. |
| `fsn_bankrobbery:LostMC:spawn` | Client | External → Client | none | Event handler stub with commented logic. |

### ESX Callbacks
None.

### Exports
No exports are provided. External exports invoked include `fsn_inventory:fsn_HasItem`, `fsn_inventory:item:add`, `fsn_inventory:item:take`, `fsn_police:fsn_getCopAmt`, `fsn_entfinder:getPedNearCoords` (all Inferred High from usage).

### Commands
None.

## Configuration & Integration
- Depends on `fsn_main` for utilities, settings, and player state.
- Requires `fsn_inventory` for item checks and rewards, `fsn_notify` for messaging, `fsn_police` for cop counts and dispatch, `mhacking` for desk hacking UI, and `fsn_bank` for depositing hacked funds.
- Cooldown logic expects the server’s uptime counter; robbery resets after 30 minutes.
- Vault loot requires a `drill` item and benefits from a `modified_drillbit` (ignores parameter server‑side; Inferred High).

## Gaps & Inferences
- `fsn_police:dispatch` likely alerts police to robbery coordinates (Inferred Med).
- `fsn_bank:change:bankAdd` presumably deposits hacked funds into the player’s account (Inferred Med).
- `fsn_bankrobbery:LostMC:spawn` is unused; purpose unclear (TODO: confirm or remove).
- `trucks.lua` not loaded by `fxmanifest`; probably legacy or optional (Inferred Low).

DOCS COMPLETE
