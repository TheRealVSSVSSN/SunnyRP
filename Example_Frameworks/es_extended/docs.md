# es_extended Documentation

## Overview and Runtime Context
`es_extended` is the core framework that wires SunnyRP's examples to the ESX API. It manages player state, inventory, jobs and accounts, exposes a minimalist HUD through NUI, and persists data in MySQL via `mysql-async`. Both client and server scripts export a `getSharedObject` function so external resources can access the ESX object.

## File Inventory
| Path | Role |
| --- | --- |
| `client/main.lua` | Client |
| `client/functions.lua` | Client |
| `client/common.lua` | Client |
| `client/entityiter.lua` | Client |
| `client/wrapper.lua` | Client |
| `client/modules/death.lua` | Client |
| `client/modules/scaleform.lua` | Client |
| `client/modules/streaming.lua` | Client |
| `server/main.lua` | Server |
| `server/functions.lua` | Server |
| `server/common.lua` | Server |
| `server/commands.lua` | Server |
| `server/classes/player.lua` | Server |
| `server/paycheck.lua` | Server |
| `common/functions.lua` | Shared |
| `common/modules/math.lua` | Shared |
| `common/modules/table.lua` | Shared |
| `config.lua`, `config.weapons.lua` | Shared |
| `imports.lua` | Shared bridge |
| `locale.lua`, `locale.js`, `locales/*.lua` | Shared/NUI |
| `fxmanifest.lua` | Shared manifest |
| `es_extended.sql` | Database schema |
| `html/ui.html`, `html/js/*.js`, `html/css/app.css`, `html/img/*`, `html/fonts/*` | NUI |
| `README.md`, `LICENSE`, `version.json` | Documentation |

## Client Scripts
### client/main.lua
Controls the player life‑cycle. On first activation it disables auto spawn, informs the server via `esx:onPlayerJoined`, and waits for `esx:playerLoaded` to spawn and initialise HUD elements. It maintains two sync loops: one sends `esx:updateWeaponAmmo` when shots are fired, the other periodically transmits coordinates through `esx:updateCoords`. The script registers numerous events for inventory changes, weapon updates, teleporting, job changes and admin utilities (`esx:tpm`, `esx:noclip`, `esx:killPlayer`, `esx:freezePlayer`).

### client/functions.lua
Builds the ESX client API. It offers UI helpers (`ESX.UI.HUD`, `ESX.UI.Menu`), notification wrappers, and an RPC layer using `esx:triggerServerCallback`/`esx:serverCallback`. `ESX.SetPlayerData` raises `esx:setPlayerData` so other resources can mirror changes. Network events handle server notifications for inventory, accounts and weapons.

### client/common.lua
Registers the `esx:getSharedObject` event and provides `getSharedObject()` to other client scripts.

### client/entityiter.lua
Implements entity iterators for peds, vehicles, objects and pickups. Includes `EnumerateEntitiesWithinDistance` which filters pools by proximity for performance.

### client/wrapper.lua
Defines NUI callback `__chunk` that reassembles fragmented JSON messages from the UI and fires `<resource>:message:<type>` events for local listeners *(Inferred Medium)*.

### client/modules/death.lua
Monitors the player each frame. When a fatal injury occurs it gathers killer information and triggers `esx:onPlayerDeath` locally and on the server; the flag resets on revival.

### client/modules/scaleform.lua
Utility functions to display scaleform movies (freemode messages, breaking news, popups, traffic cams) for timed durations.

### client/modules/streaming.lua
Wraps natives that request models, textures, particle assets, animation sets/dictionaries and weapon assets. Each helper waits until the asset loads before invoking an optional callback to avoid race conditions.

## Server Scripts
### server/main.lua
Handles player creation, loading and persistence. On resource start it prepares SQL statements for new players and selects fields based on configuration. Events:
- `playerConnecting` validates identifiers and rejects duplicates.
- `esx:onPlayerJoined` loads or creates ESX player data.
- `chatMessage` and `playerDropped` manage cleanup; `esx:playerLogout` triggers final saves.
- Receives `esx:updateCoords`, `esx:updateWeaponAmmo`, `esx:giveInventoryItem`, `esx:removeInventoryItem`, `esx:useItem`, and `esx:onPickup` from clients and applies inventory or world changes.
- Exposes callbacks `esx:getPlayerData`, `esx:getOtherPlayerData`, and `esx:getPlayerNames`.
- Listens for `txAdmin:events:scheduledRestart` to save players 10 seconds before reboot.

### server/functions.lua
Provides utility APIs:
- `ESX.RegisterCommand` wraps `RegisterCommand`, validates arguments and broadcasts chat suggestions.
- `ESX.RegisterServerCallback` stores callback references for RPC.
- Persistence helpers `ESX.SavePlayer`/`ESX.SavePlayers` construct a bulk `UPDATE` query using `MySQL.Async.fetchAll`.
- `ESX.CreatePickup` generates unique IDs and broadcasts `esx:createPickup` to clients.
- Player lookup helpers (`GetPlayers`, `GetPlayerFromId`, `GetExtendedPlayers`) and weapon/item utilities.

### server/common.lua
Initialises shared tables and loads configuration from the database using `MySQL.Async.fetchAll`. Exposes `esx:getSharedObject` and routes `esx:triggerServerCallback` requests by executing the registered server callbacks.

### server/commands.lua
Declares admin and user commands via `ESX.RegisterCommand`. Commands cover teleportation (`setcoords`, `tpm`, `goto`, `bring`), job and permission management (`setjob`, `setgroup`), economy (`setaccountmoney`, `giveaccountmoney`, `giveitem`, `giveweapon`, `giveweaponcomponent`), chat utilities (`clear`, `clearall`), player control (`kill`, `freeze`, `noclip`), and persistence (`save`, `saveall`, `players`).

### server/classes/player.lua
Factory for extended player objects holding identifiers, job, accounts, inventory and loadout. Methods manipulate state and trigger client sync events such as `esx:addInventoryItem`, `esx:setAccountMoney`, `esx:setJob`, `esx:setWeaponAmmo`, and inventory hooks `esx:onAddInventoryItem`/`esx:onRemoveInventoryItem` *(Inferred High)*. Permissions are managed using ACE principals based on player license.

### server/paycheck.lua
Runs a repeating thread every `Config.PaycheckInterval` that credits salaries. If `Config.EnableSocietyPayouts` is true it pulls funds from society accounts via `esx_society`/`esx_addonaccount`; otherwise it deposits directly into player bank accounts with `esx:showAdvancedNotification` messages.

## Shared Modules
### common/functions.lua
Utility helpers for random string generation, access to config and weapon metadata, dumping tables and rounding.

### common/modules/math.lua
Provides `ESX.Math.Round`, digit grouping using locale settings, and string trimming.

### common/modules/table.lua
Additional table operations: size, set conversion, search, filter, map, reverse, clone, concatenation and ordered iteration.

### config.lua / config.weapons.lua
Defines runtime settings (locale, account labels, HUD, multicharacter, debug, inventory weight, paycheck interval). `config.weapons.lua` lists weapon definitions, tints and components used by inventory and weapon helpers.

### imports.lua
Allows other resources to include this file to obtain the ESX object via `exports['es_extended']:getSharedObject()`. On clients it mirrors `esx:setPlayerData` updates.

### locale.lua / locale.js / locales/*.lua
Server and NUI localisation helpers. `locale.lua` provides `_` and `_U` functions to fetch translations; `locale.js` offers similar behaviour for the UI. Locale files under `locales/` supply language dictionaries.

### fxmanifest.lua
Resource manifest listing shared scripts, client and server files, UI assets, exports (`getSharedObject`) and dependencies (`mysql-async`, `async`, `spawnmanager`).

### es_extended.sql
Database schema creating `users`, `items` and `job_grades` tables with required fields. Other resources are expected to populate additional job and item data.

## NUI
`html/ui.html` hosts the HUD with JQuery and Mustache templates. `html/js/app.js` maintains HUD elements and inventory notifications. `html/js/wrapper.js` chunks outbound messages for Lua consumption. `html/css/app.css` styles the HUD, while images and fonts supply account icons and text styling.

## Control Flow & Notes
- Player join → server `esx:onPlayerJoined` → player data loaded or created → `esx:playerLoaded` sent to client → client spawns player, restores loadout, starts sync loops.
- Inventory updates and weapon interactions trigger corresponding events to keep server and client states consistent. Pickup creation and collection is coordinated through `esx:createPickup`/`esx:onPickup`.
- Paychecks run independently on the server thread, rewarding active players.
- Commands use ACE permissions; most sensitive actions require the `admin` group.
- The server validates item ownership and weights before transfers, protecting against illegitimate inventory changes.
- Prepared SQL statements and timed loops reduce database and CPU overhead.

## Cross‑Indexes
### Events
| Event | Direction | Purpose |
| --- | --- | --- |
| playerConnecting | engine→server | Validate identifiers and prevent duplicates. |
| chatMessage | engine→server | Inspect messages for command errors. |
| playerDropped | engine→server | Persist data and clear ESX state. |
| esx:getSharedObject | both | Return shared ESX object. |
| esx:setPlayerData | client local | Notify listeners when a PlayerData field changes. |
| esx:onPlayerJoined | client→server | Inform server that the player activated. |
| esx:playerLoaded | server→client | Deliver initial player data and start client setup. |
| esx:playerLogout | server→client | Reset HUD and clean up on logout. |
| esx:setMaxWeight | server→client | Update inventory capacity. |
| esx:onPlayerSpawn | local | Update ped and death flags after respawn. *(Inferred Low)* |
| esx:onPlayerDeath | both | Broadcast death details to server and local listeners. |
| esx:restoreLoadout | local | Re‑equip weapons after spawn or skin load. |
| esx:setAccountMoney | server→client | Replace a single account balance and update HUD. |
| esx:addInventoryItem / esx:removeInventoryItem | server↔client | Sync inventory counts and notify UI. |
| esx:onAddInventoryItem / esx:onRemoveInventoryItem | server local | Hooks for external inventory logic *(Inferred High)*. |
| esx:addWeapon / esx:removeWeapon | server→client | Give or remove weapons. |
| esx:addWeaponComponent / esx:removeWeaponComponent | server→client | Modify weapon components. |
| esx:setWeaponAmmo / esx:updateWeaponAmmo | bidirectional | Persist weapon ammo to server. |
| esx:setWeaponTint | server→client | Apply weapon tint. |
| esx:teleport | server→client | Move the player to specified coordinates. |
| esx:setJob | server→client | Update job and HUD label. |
| esx:spawnVehicle / esx:deleteVehicle | server→client | Spawn or remove vehicles. |
| esx:createPickup / esx:removePickup / esx:createMissingPickups | bidirectional | Manage world pickups. |
| esx:registerSuggestions | server→client | Populate chat suggestions. |
| esx:updateCoords | client→server | Persist player position periodically. |
| esx:giveInventoryItem | client→server | Transfer items, accounts, weapons or ammo. |
| esx:useItem | client→server | Trigger registered item handler. |
| esx:onPickup | client→server | Notify server that a pickup was collected. |
| esx:serverCallback / esx:triggerServerCallback | bidirectional | RPC request/response layer. |
| esx:tpm | server→client | Teleport to waypoint (admin). |
| esx:noclip | server→client | Toggle noclip movement (admin). |
| esx:killPlayer | server→client | Force player death (admin). |
| esx:freezePlayer | server→client | Freeze or unfreeze a player (admin). |
| esx:clientLog | client→server | Debug logging when `Config.EnableDebug` is true. |
| txAdmin:events:scheduledRestart | external→server | Save all players before restart. |

### ESX Callbacks
| Name | Description |
| --- | --- |
| esx:getPlayerData | Return current player's data table. |
| esx:getOtherPlayerData | Return data for a specified player ID. |
| esx:getPlayerNames | Resolve a table of player IDs to names. |

### Exports
| Name | Side | Purpose |
| --- | --- | --- |
| getSharedObject | client & server | Give external resources access to the ESX object. |

### Commands
| Command(s) | Permission | Purpose |
| --- | --- | --- |
| setcoords | admin | Teleport player to coordinates. |
| setjob | admin | Assign job and grade. |
| car | admin | Spawn vehicle model. |
| cardel / dv | admin | Delete nearby vehicles. |
| setaccountmoney | admin | Set account balance. |
| giveaccountmoney | admin | Add money to account. |
| giveitem | admin | Give inventory item. |
| giveweapon | admin | Give weapon with ammo. |
| giveweaponcomponent | admin | Add weapon component. |
| clear / cls | user | Clear personal chat. |
| clearall / clsall | admin | Clear chat for all players. |
| clearinventory | admin | Remove all items from player. |
| clearloadout | admin | Remove player's weapons. |
| setgroup | admin | Change permission group. |
| save | admin | Save a player's data. |
| saveall | admin | Save all players. |
| group | user/admin | Display caller's group. |
| job | user/admin | Display caller's job and grade. |
| info | user/admin | Print identifier and group info. |
| coords | admin | Print current coordinates. |
| tpm | admin | Teleport to waypoint. |
| goto | admin | Teleport to another player. |
| bring | admin | Bring a player to you. |
| kill | admin | Kill a player. |
| freeze / unfreeze | admin | Freeze or unfreeze a player. |
| reviveall | admin | Trigger `esx_ambulancejob:revive` for all players. |
| noclip | admin | Toggle noclip on a player. |
| players | admin | List connected players. |
| showinv | client | Open default inventory UI. |

### NUI Channels
| Channel | Direction | Purpose |
| --- | --- | --- |
| `__chunk` | UI→client | Transfer chunked JSON messages to Lua. |
| `setHUDDisplay`, `insertHUDElement`, `updateHUDElement`, `deleteHUDElement`, `resetHUDElements`, `inventoryNotification` | client→UI | HUD and notification updates via `SendNUIMessage`. |

## Configuration & Integration
- `config.lua` toggles HUD, multicharacter support, debug logging, identity data, inventory limits and payday intervals.
- `config.weapons.lua` defines weapon metadata consumed by weapon helpers and player loadouts.
- External resources integrate through exported `getSharedObject` and events for society accounts (`esx_society`), shared accounts (`esx_addonaccount`), ambulance revives (`esx_ambulancejob`), and skin loading (`skinchanger`).
- Include `@es_extended/imports.lua` in other resources to auto‑fetch the ESX object and receive `esx:setPlayerData` updates.
- Database must be provisioned with `es_extended.sql` and a compatible `mysql-async` driver.

## Gaps & Inferences
- Client emits `<resource>:message:<type>` for NUI chunked messages without local listeners; assumed to be consumed by external modules *(Inferred Medium).* 
- `esx:onPlayerSpawn` is triggered by the client but no handler exists in this resource, implying another resource handles spawn logic *(Inferred Low).* 
- `esx:onPlayerDeath` server logic is absent; death events are expected to be consumed by external scripts *(Inferred Medium).* 
- Inventory hooks `esx:onAddInventoryItem`/`esx:onRemoveInventoryItem` are broadcast with no handlers here, suggesting they drive job or society features elsewhere *(Inferred High).* 
- `esx:loadingScreenOff` is a local event used to hide a loading screen; no accompanying server flow was found *(Inferred Low).* 

TODO: Implement listeners for death and spawn events or document required companion resources.

DOCS COMPLETE — gaps scanned, filled where possible.

