# fsn_bankrobbery Documentation

## Overview
Bank and front‑desk robberies for the FSN framework. Clients crack keypads or hack computers to access vaults; the server tracks cooldowns and payouts. An unused script can spawn armored trucks for additional cash. No direct database queries are performed.

## File Inventory
| File | Side | Description |
| --- | --- | --- |
| `fxmanifest.lua` | Shared | Declares resource metadata and registers scripts. |
| `client.lua` | Client | Handles keypad cracking, vault looting and door state updates. |
| `cl_safeanim.lua` | Client | Self‑contained safe‑cracking minigame. |
| `cl_frontdesks.lua` | Client | Front‑desk hacking interface. |
| `trucks.lua` | Client | Armored truck robbery logic; not loaded by manifest (Inferred High). |
| `server.lua` | Server | Manages vault states, payouts and cooldowns. |
| `sv_frontdesks.lua` | Server | Front‑desk data store and hack processing. |

## Client

### client.lua
Main vault logic.

- Maintains a per‑bank table of door locations and vault data. Each frame it checks distance to doors and vaults, enforcing access rules and door headings.
- Listens for `fsn_bankrobbery:timer` to toggle robbery availability and for `fsn_bankrobbery:init/openDoor/closeDoor` to sync door states.
- On character load (`fsn_main:character`) requests initial state from the server.
- Keypad cracking: holding the crack key sends `fsn_police:dispatch` with player coordinates and triggers `fsn_bankrobbery:start`; successful attempts reveal a code stored on the client.
- Vault looting: requires `drill` and optionally `modified_drillbit`. Sends `fsn_bankrobbery:payout` with door id and a drill‑bit flag that the server ignores (Inferred High). Looting adds dirty money and stress, while failing may destroy the drill.
- Exiting range resets local access and notifies the server via `fsn_bankrobbery:vault:close`.
- Includes an inactive `fsn_bankrobbery:LostMC:spawn` event stub (Inferred Low).

### cl_safeanim.lua
Safe‑cracking minigame.

- `safecracking:start` displays HUD text and invokes `safecracking:loop`.
- The loop loads textures/audio, rotates a dial based on key presses and checks combination locks until all succeed, emitting `safe:success` when done. The parameter passed to `safecracking:loop` is unused (Inferred High).

### cl_frontdesks.lua
Front‑desk hacking.

- Requests desk definitions with `fsn_bankrobbery:desks:request` and receives updates via `fsn_bankrobbery:desks:receive`.
- `Util.Tick` continuously monitors proximity to doors and keyboards, displays prompts, and triggers `mhacking:start` when hacking begins.
- Results are reported through `fsn_bankrobbery:desks:endHack`; each attempt increases player stress via `fsn_needs:stress:add`.

### trucks.lua
Armored truck robbery logic (not loaded).

- Spawns patrolling `stockade` trucks with armed guards, adds blips, and creates cash pickups when doors open.
- On resource start, if the player has a `radio_receiver`, sends a `fsn_phone:recieveMessage` about potential trucks.
- Cash pickup grants dirty money and a notification.

## Server

### server.lua
Authoritative bank vault management.

- Maintains vault door states and dynamic payout pools. Bank deposits and withdrawals (`fsn_main:money:bank:Add/Minus`) adjust available loot.
- A second‑based timer enforces a 30‑minute global cooldown and broadcasts `fsn_bankrobbery:timer` to clients.
- Handles `fsn_bankrobbery:vault:open/close` requests, relaying door state changes to all clients.
- `fsn_bankrobbery:payout` deducts a random share of the bank’s pool, grants dirty money, notifies the player, and adds stress.

### sv_frontdesks.lua
Server side for front‑desk hacks.

- Stores door status and keyboard definitions with random payouts per location.
- Exposes `fsn_bankrobbery:desks:doorUnlock`, `:request`, `:startHack`, and `:endHack` to manage hacking lifecycle. A successful hack deposits funds via `fsn_bank:change:bankAdd`; failures either allow a retry or mark the keyboard as unusable.
- Every 15 minutes resets all desks and payouts.

## Configuration

### fxmanifest.lua

- Targets FiveM build `bodacious` and GTA V.
- Loads FSN utility and settings scripts plus MySQL async library (no queries here).
- Registers client scripts (`client.lua`, `cl_safeanim.lua`, `cl_frontdesks.lua`) and server scripts (`server.lua`, `sv_frontdesks.lua`).

## Cross‑Index

### Events
| Name | Side | Direction | Parameters | Description |
| --- | --- | --- | --- | --- |
| `fsn_bankrobbery:timer` | Client | Server → Client | `state` bool | Enables or disables robbery attempts. |
| `fsn_main:character` | Client | External → Client | none | Requests initial vault status. |
| `fsn_bankrobbery:init` | Both | Server ↔ Client | table door states | Syncs door status on join. |
| `fsn_bankrobbery:openDoor` | Client | Server → Client | `id` | Rotates vault door open. |
| `fsn_bankrobbery:closeDoor` | Client | Server → Client | `id` | Rotates vault door closed. |
| `fsn_bankrobbery:vault:open` | Server | Client → Server | `id` | Player requests door opening. |
| `fsn_bankrobbery:vault:close` | Server | Client → Server | `id` | Player leaves vault area. |
| `fsn_bankrobbery:start` | Server | Client → Server | none | Marks start of keypad cracking. |
| `fsn_bankrobbery:payout` | Server | Client → Server | `id`, `hasModifiedBit` (ignored) | Requests vault payout. |
| `fsn_bankrobbery:desks:request` | Server | Client → Server | none | Requests desk data. |
| `fsn_bankrobbery:desks:receive` | Client | Server → Client | desk table | Updates front‑desk state. |
| `fsn_bankrobbery:desks:startHack` | Server | Client → Server | `bank`, `keyboard` | Begin hacking a keyboard. |
| `fsn_bankrobbery:desks:endHack` | Server | Client → Server | `bank`, `keyboard`, `success` | Report hacking result. |
| `fsn_bankrobbery:desks:doorUnlock` | Server | Client → Server | `bank` | Unlocks a bank’s front door. |
| `fsn_main:money:bank:Add` | Server | External → Server | `player`, `amount` | Increases all bank payout pools. |
| `fsn_main:money:bank:Minus` | Server | External → Server | `player`, `amount` | Decreases payout pools. |
| `safecracking:start` | Client | External → Client | none | Starts safe minigame. |
| `safecracking:loop` | Client | External → Client | none | Runs safe‑cracking logic. |
| `safe:success` | External | Client → External | none | Signals successful safe crack. |
| `fsn_bankrobbery:LostMC:spawn` | Client | External → Client | none | Event handler stub. |
| `fsn_police:dispatch` | Server | Client → Server | `coords`, `code` | Alerts police to robbery (Inferred Med). |
| `fsn_needs:stress:add` | Both | Client ↔ Server | `amount` | Applies stress effects. |
| `fsn_notify:displayNotification` | Client | Both directions | message, position, time, type | Shows HUD messages. |
| `fsn_inventory:item:add` | Client | Server → Client | item, amount | Grants items (e.g. dirty money). |
| `fsn_inventory:item:take` | Client | Client → Client | item, amount | Removes items from player inventory. |
| `fsn_bank:change:bankAdd` | Client | Server → Client | amount | Deposits funds after hack. |
| `mythic_notify:client:SendAlert` | Client | Server → Client | `{type,text}` | Displays Mythic notifications. |
| `fsn_phone:recieveMessage` | Client | Client → Client | message table | Sends phone message about trucks. |
| `mhacking:show/start/hide` | Client | Client ↔ External | varies | Handles hacking UI lifecycle. |
| `DoLongHudText` | Client | External → Client | message, type | Displays safe‑cracking HUD text. |

### ESX Callbacks
None.

### Exports
| Export Used | Location | Purpose |
| --- | --- | --- |
| `fsn_inventory:fsn_HasItem` | `client.lua`, `trucks.lua` | Checks player inventory for required items. |
| `fsn_police:fsn_PDDuty` | `client.lua` | Allows police to bypass vault restrictions. |
| `fsn_police:fsn_getCopAmt` | `client.lua` | Ensures minimum police presence. |
| `fsn_entfinder:getPedNearCoords` | `client.lua` | Finds nearby ped for truck logic. |

### Commands
None.

## Configuration & Integration
- Relies on `fsn_main` for utilities, settings, and character events.
- Uses `fsn_inventory` for item checks and rewards, `fsn_police` for dispatch and police counts, `fsn_notify`/`mythic_notify` for HUD messaging, `fsn_needs` for stress, `mhacking` for the front‑desk minigame, `fsn_bank` for depositing hacked funds, and `fsn_phone` for truck alerts.
- Cooldown logic depends on a 30‑minute timer; front‑desk states reset every 15 minutes.
- Resource loads MySQL library but performs no SQL queries.

## Gaps & Inferences
- `fsn_bankrobbery:payout` ignores the client’s drill‑bit flag, implying all loot payouts are identical regardless of bit (Inferred High).
- `safecracking:loop` receives an argument that is unused (Inferred High).
- `fsn_bankrobbery:desks:doorUnlock` is registered server‑side but has no in‑resource caller (Inferred Med).
- `fsn_bankrobbery:LostMC:spawn` contains only commented code; purpose undetermined (Inferred Low).
- `trucks.lua` is not referenced by `fxmanifest.lua`, so the armored truck feature appears disabled (Inferred High).

DOCS COMPLETE

