# es_extended Documentation

## Overview and Runtime Context
ES Extended is a legacy roleplay framework for FiveM that manages players, inventory, jobs, accounts and a minimal HUD. The resource ships both client and server Lua scripts, shared utility modules, an HTML based NUI, and interacts with a MySQL database via `mysql-async`. It exports a `getSharedObject` method so other resources can access the ESX API.

## File Inventory
- **Client**
  - `client/main.lua`
  - `client/functions.lua`
  - `client/common.lua`
  - `client/entityiter.lua`
  - `client/wrapper.lua`
  - `client/modules/death.lua`
  - `client/modules/scaleform.lua`
  - `client/modules/streaming.lua`
- **Server**
  - `server/main.lua`
  - `server/functions.lua`
  - `server/common.lua`
  - `server/commands.lua`
  - `server/classes/player.lua`
  - `server/paycheck.lua`
- **Shared**
  - `fxmanifest.lua`
  - `config.lua`
  - `config.weapons.lua`
  - `imports.lua`
  - `common/functions.lua`
  - `common/modules/math.lua`
  - `common/modules/table.lua`
  - `locale.lua`, `locale.js`, `locales/*.lua`
  - `es_extended.sql`
  - `README.md`, `LICENSE`, `version.json`
- **NUI**
  - `html/ui.html`
  - `html/js/app.js`
  - `html/js/wrapper.js`
  - `html/css/app.css`
  - `html/fonts/*`, `html/img/accounts/*`

## Client Files
### client/main.lua
Handles player life‑cycle, inventory pickups, HUD elements, and administrative helpers.
- On first spawn disables auto‑spawn and notifies the server with `esx:onPlayerJoined`.
- Responds to `esx:playerLoaded` by spawning the player, restoring loadout, initializing HUD accounts, and starting sync loops.
- Sync loops periodically send ammo counts (`esx:updateWeaponAmmo`) and player coordinates (`esx:updateCoords`) to the server.
- Registers events for logout, weight limits, death, job changes, teleport, vehicle spawn/delete and pickup creation/removal.
- Admin utilities: `esx:tpm`, `esx:noclip`, `esx:killPlayer`, and `esx:freezePlayer` are exposed as client events.

### client/functions.lua
Creates the ESX client object and utility methods.
- Manages HUD elements through `SendNUIMessage` actions such as `setHUDDisplay`, `insertHUDElement`, and `inventoryNotification`.
- Provides notification helpers and a generic `ESX.TriggerServerCallback` RPC using `esx:triggerServerCallback`/`esx:serverCallback` events.
- `ESX.SetPlayerData` broadcasts changes through `esx:setPlayerData` so imports.lua can mirror PlayerData.
- Registers network events to update inventory, weapons, accounts, job, and to display notifications from the server.

### client/common.lua
Registers `esx:getSharedObject` so other client resources can retrieve the ESX object.

### client/entityiter.lua
Utility iterator patterns for objects, peds, vehicles and pickups. Includes distance‑based filtering helper `EnumerateEntitiesWithinDistance`.

### client/wrapper.lua
NUI callback `__chunk` reassembles large JSON messages from the UI before firing a dynamic Lua event `<resource>:message:<type>` (Inferred Medium).

### client/modules/death.lua
Monitors the player ped each frame; when fatally injured it collects killer data and triggers `esx:onPlayerDeath` both locally and to the server. When revived the flag resets.

### client/modules/scaleform.lua
Helpers to display scaleform movies such as freemode messages, breaking news, or popups for timed durations.

### client/modules/streaming.lua
Wraps natives for streaming models, textures, particle assets, animation sets/dicts, and weapon assets. Each helper waits until the asset loads then invokes an optional callback.

## Server Files
### server/main.lua
Orchestrates player loading/saving and network events.
- Prepares SQL statements for creating and loading players. When a player connects it either creates a new record or loads existing data.
- Tracks players joining/leaving (`esx:onPlayerJoined`, `playerConnecting`, `playerDropped`) and triggers `esx:onPlayerLogout` on disconnect.
- Handles coordinate and ammo updates from clients (`esx:updateCoords`, `esx:updateWeaponAmmo`) and inventory transfers (`esx:giveInventoryItem`, `esx:removeInventoryItem`, `esx:onPickup`).
- Exposes callbacks `esx:getPlayerData`, `esx:getOtherPlayerData`, and `esx:getPlayerNames` for external resources.
- Saves all players before a txAdmin scheduled restart.

### server/functions.lua
Core server utilities and persistence helpers.
- `ESX.RegisterCommand` wires commands with ACE permissions and optional chat suggestions.
- Defines `ESX.RegisterServerCallback`, timeout helpers, and player saving routines (`ESX.SavePlayer`, `ESX.SavePlayers`).
- `ESX.CreatePickup` stores pickup metadata and broadcasts `esx:createPickup` to clients.
- Provides player lookup helpers (`GetExtendedPlayers`, `GetPlayerFromId`, etc.) and inventory/weapon handlers.

### server/common.lua
Initializes ESX tables and loads DB data on startup using `MySQL.Async.fetchAll` for items, jobs, and grades. Exposes `esx:getSharedObject` and routes RPC requests from `esx:triggerServerCallback`.

### server/commands.lua
Declares admin and user commands using `ESX.RegisterCommand`. Commands cover teleportation (`setcoords`, `tpm`, `goto`, `bring`), job/permission management (`setjob`, `setgroup`), economy tools (`setaccountmoney`, `giveaccountmoney`, `giveitem`, `giveweapon`), chat utilities (`clear`, `clearall`), player control (`kill`, `freeze`, `noclip`), and persistence (`save`, `saveall`).

### server/classes/player.lua
Factory for extended player objects with money, inventory, job, and weapon APIs.
- Methods trigger client sync events such as `esx:addInventoryItem`, `esx:setAccountMoney`, `esx:setJob`, and `esx:setWeaponAmmo`.
- Hooks `esx:onAddInventoryItem` and `esx:onRemoveInventoryItem` allow other resources to react to inventory changes (Inferred High).
- Manages permissions via ACE principals and exposes helpers for coords, group, accounts, weapons, and notifications.

### server/paycheck.lua
Background thread paying salaries at `Config.PaycheckInterval`. If `Config.EnableSocietyPayouts` is true it pulls funds from society accounts via `esx_society:getSociety` and `esx_addonaccount:getSharedAccount`; otherwise deposits directly into player bank accounts with notifications.

## Shared Files
### fxmanifest.lua
Resource manifest declaring scripts, assets, exports, and dependencies (`mysql-async`, `async`, `spawnmanager`). Exports `getSharedObject` on client and server.

### config.lua
Global configuration: locale, account labels, starting bank balance, HUD toggle, maximum inventory weight, paycheck interval, debug flag, multicharacter and identity options.

### config.weapons.lua
Comprehensive weapon catalogue defining labels, ammo hashes, available tints, and component hashes. Utilised by shared weapon lookup helpers.

### imports.lua
Utility for other resources. Retrieves the ESX object via `exports['es_extended']:getSharedObject()` and listens for `esx:setPlayerData` to keep `ESX.PlayerData` synchronized client‑side.

### common/functions.lua
Shared helpers for random strings, config access, weapon lookups, table dumping, and math utilities.

### common/modules/math.lua
Defines `ESX.Math.Round`, digit grouping, and string trimming helpers.

### common/modules/table.lua
Table utility collection: size, set conversion, find/filter/map/reverse/clone/concat/join/sort helpers.

### locale.lua / locale.js / locales/*.lua
Localization loaders for Lua and JS. `locale.lua` exposes `_` and `_U` for translated strings; each file in `locales/` populates translations for a locale. `locale.js` mirrors these functions in the NUI context.

### es_extended.sql
Database schema with tables for users, items, and job grades. The server uses `MySQL.Async` queries to populate ESX tables and save player state.

### README.md / LICENSE / version.json
General project information, license details, and version metadata.

## NUI Files
### html/ui.html
Base HTML page including HUD container, inventory notifications, and JS/CSS assets.

### html/js/app.js
NUI logic handling HUD element insertion, updates, deletions, and inventory notifications based on messages posted from Lua. Listens for message events and dispatches actions.

### html/js/wrapper.js
Provides `SendMessage(namespace, type, msg)` which chunks JSON payloads and posts them to the `__chunk` callback.

### html/css/app.css
Styles for HUD text, fonts, inventory notifications, and menu elements.

## Control Flow Overview
1. **Player join** – Client notifies the server (`esx:onPlayerJoined`); server loads or creates the player then emits `esx:playerLoaded`, leading the client to spawn, restore loadout, and set up HUD.
2. **Sync** – Client threads send ammo and position updates while the server pushes account, inventory, job and pickup changes back to clients.
3. **Inventory & pickups** – Server creates pickups via `ESX.CreatePickup` and clients manage nearby objects, collecting them with `esx:onPickup`.
4. **Paychecks** – `server/paycheck.lua` periodically credits salaries, optionally using society accounts.

## Security & Permissions
- Commands use ACE groups via `ESX.RegisterCommand`. Most administrative commands require the `admin` group.
- Server validates inventory transfers, weapon ownership, and weight limits before applying changes.
- Teleport, noclip, kill, and freeze features are only available through server‑side commands to prevent client abuse.

## Database Usage
- Startup: server/common.lua loads items and job data via `MySQL.Async.fetchAll`.
- Player lifecycle: server/main.lua uses prepared statements (`MySQL.Async.store`) to create and load users; server/functions.lua persists players with `MySQL.Async.execute`.
- Paychecks: optional society payouts interact with `esx_society` and `esx_addonaccount` shared accounts.

## Performance Notes
- Prepared statements reduce SQL overhead.
- Sync loops sleep when no action is required to minimise CPU usage.
- Entity iterators and proximity checks avoid iterating entire pools every frame.

## Cross‑Indexes
### Events
| Name | Side | Purpose |
| --- | --- | --- |
| esx:getSharedObject | client & server | Return ESX object to callbacks. |
| esx:setPlayerData | client | Inform listeners that a PlayerData field changed. |
| esx:onPlayerJoined | client→server | Signal server that the player spawned into the session. |
| esx:playerLoaded | server→client | Provide initial player data and trigger spawn sequence. |
| esx:onPlayerLogout | server→client | Reset HUD when logging out. |
| esx:setMaxWeight | server→client | Update inventory capacity. |
| esx:onPlayerSpawn | local | Update ped and death flags when respawning. |
| esx:onPlayerDeath | both | Broadcast death details to server and listeners. |
| esx:restoreLoadout | local | Re‑equip weapons after spawn or skin load. |
| esx:setAccountMoney | server→client | Replace a single account and update HUD. |
| esx:addInventoryItem / esx:removeInventoryItem | server→client | Sync inventory counts and show notifications. |
| esx:addWeapon / esx:removeWeapon | server→client | Grant or remove weapon on the ped. |
| esx:addWeaponComponent / esx:removeWeaponComponent | server→client | Modify weapon components. |
| esx:setWeaponAmmo | server→client | Set ammo count. |
| esx:setWeaponTint | server→client | Apply weapon tint. |
| esx:teleport | server→client | Move the player to specific coordinates. |
| esx:setJob | server→client | Update job and HUD label. |
| esx:spawnVehicle / esx:deleteVehicle | server→client | Spawn or remove vehicles for a player. |
| esx:createPickup / esx:removePickup | both | Manage world pickup objects. |
| esx:createMissingPickups | server→client | Re‑create pickups after reconnect. |
| esx:registerSuggestions | server→client | Populate chat suggestions for commands. |
| esx:updateWeaponAmmo | client→server | Persist weapon ammo when firing. |
| esx:updateCoords | client→server | Persist player position periodically. |
| esx:giveInventoryItem | client→server | Transfer items, accounts, weapons or ammo to another player. |
| esx:useItem | client→server | Use a registered item. |
| esx:onPickup | client→server | Notify server that a pickup was collected. |
| esx:serverCallback / esx:triggerServerCallback | bidirectional | RPC request/response mechanism. |
| esx:tpm | client | Teleport to map marker (admin). |
| esx:noclip | client | Toggle noclip movement (admin). |
| esx:killPlayer | client | Force player death (admin). |
| esx:freezePlayer | client | Freeze or unfreeze entity (admin). |

### ESX Callbacks
| Name | Description |
| --- | --- |
| esx:getPlayerData | Return current player's data table. |
| esx:getOtherPlayerData | Return data for a specified player ID. |
| esx:getPlayerNames | Resolve a table of player IDs to names. |

### Exports
| Name | Side | Usage |
| --- | --- | --- |
| getSharedObject | client & server | Gives external resources access to the ESX API. |

### Commands
| Command(s) | Permission | Purpose |
| --- | --- | --- |
| setcoords | admin | Teleport player to coordinates. |
| setjob | admin | Assign job and grade to a player. |
| car | admin | Spawn vehicle model. |
| cardel / dv | admin | Delete nearby vehicles. |
| setaccountmoney | admin | Set player's account balance. |
| giveaccountmoney | admin | Add money to account. |
| giveitem | admin | Give inventory item. |
| giveweapon | admin | Give weapon with ammo. |
| giveweaponcomponent | admin | Add weapon component. |
| clear / cls | user | Clear personal chat. |
| clearall / clsall | admin | Clear chat for all players. |
| clearinventory | admin | Remove all items from player. |
| clearloadout | admin | Remove all weapons from player. |
| setgroup | admin | Change player's permission group. |
| save | admin | Save a player's data. |
| saveall | admin | Save all players. |
| group | user/admin | Display the caller's group. |
| job | user/admin | Display the caller's job and grade. |
| info | user/admin | Print identifier and position info. |
| coords | admin | Print current coordinates. |
| tpm | admin | Teleport to waypoint. |
| goto | admin | Teleport to another player. |
| bring | admin | Teleport a player to you. |
| kill | admin | Kill a player. |
| freeze / unfreeze | admin | Freeze or unfreeze a player. |
| reviveall | admin | Trigger `esx_ambulancejob:revive` for all players. |
| noclip | admin | Toggle noclip for a player. |
| players | admin | List connected players. |
| showinv | client | Open default inventory UI. |

### NUI Channels
| Name | Direction | Purpose |
| --- | --- | --- |
| __chunk | UI→client | Transfer chunked JSON messages to Lua. |
| setHUDDisplay / insertHUDElement / updateHUDElement / deleteHUDElement / resetHUDElements / inventoryNotification | client→UI | HUD and notification updates via `SendNUIMessage`. |

## Configuration & Integration
- Include `shared_script '@es_extended/imports.lua'` in other resources to fetch the ESX object automatically.
- Optional resources such as `esx_society`, `esx_addonaccount`, `esx_ambulancejob`, and `skinchanger` integrate through the events referenced above.
- MySQL server must have the schema from `es_extended.sql` and support prepared statements.

## Gaps & Inferences
- NUI wrapper emits `<resource>:message:<type>` events but no listeners are included; presumed to be consumed by other scripts (Inferred Medium).
- Inventory hooks (`esx:onAddInventoryItem` / `esx:onRemoveInventoryItem`) are defined without local handlers, suggesting external resources listen for them (Inferred High).
- `esx:loadingScreenOff` is triggered client-side to close a loading screen, but no server counterpart is present (Inferred Low).

TODO: Additional external resources are required for society accounts, skinchanger, and inventory UI beyond the minimal default.
