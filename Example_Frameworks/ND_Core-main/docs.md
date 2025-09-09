# ND_Core Documentation

## Overview
ND_Core provides the core gameplay framework for SunnyRP. It handles player session management, character data, vehicle ownership and keys, integration with Discord and ox_lib, and optional compatibility layers for ESX/QB and legacy ND interfaces. Configuration relies on server convars and MySQL tables `nd_characters` and `nd_vehicles`.

## File Inventory
- [fxmanifest.lua](#fxmanifestlua)
- [init.lua](#initlua)
- [shared/functions.lua](#sharedfunctions)
- [client/main.lua](#clientmainlua)
- [client/events.lua](#clienteventslua)
- [client/functions.lua](#clientfunctionslua)
- [client/peds.lua](#clientpedslua)
- [client/death.lua](#clientdeathlua)
- [client/vehicle/main.lua](#clientvehiclemainlua)
- [client/vehicle/garages.lua](#clientvehiclegarageslua)
- [client/vehicle/data.lua](#clientvehicledata)
- [server/main.lua](#servermainlua)
- [server/player.lua](#serverplayerlua)
- [server/vehicle.lua](#servervehiclelua)
- [server/functions.lua](#serverfunctionslua)
- [server/commands.lua](#servercommandslua)
- [compatibility/esx](#compatibilityesx)
- [compatibility/qb](#compatibilityqb)
- [compatibility/backwards](#compatibilitybackwards)
- [database/sql](#databasesql)
- [locales](#locales)

## fxmanifest.lua
Declares resource metadata, dependencies (`ox_lib`, `oxmysql`), shared scripts, and lists client/server files. It exposes convars and disables legacy provides.

## init.lua
Creates a global `NDCore` object that proxies exports from this resource for convenient access.

## shared/functions.lua
Utility for detecting resource start/stop. `NDCore.isResourceStarted(name, cb)` checks current state and optionally tracks callbacks for state changes【F:Example_Frameworks/ND_Core-main/shared/functions.lua†L20-L29】.

## client/main.lua
Initialises client configuration from replicated convars, sets Discord rich presence, and augments pause menu information. On spawn or resource start it enables friendly fire for testing.【F:Example_Frameworks/ND_Core-main/client/main.lua†L4-L72】

## client/events.lua
Handles network updates:
- `ND:updateMoney` updates cached cash/bank values.【F:Example_Frameworks/ND_Core-main/client/events.lua†L1-L6】
- `ND:characterLoaded`, `ND:updateCharacter` track the active character.【F:Example_Frameworks/ND_Core-main/client/events.lua†L8-L16】
- `ND:updateLastLocation` stores last position; no server source found (Inference Low).【F:Example_Frameworks/ND_Core-main/client/events.lua†L18-L22】
- `ND:revivePlayer` resurrects the player and restores state.【F:Example_Frameworks/ND_Core-main/client/events.lua†L24-L54】
- `ND:characterUnloaded` signals character removal.
- `ND:clothingMenu` opens the `fivem-appearance` UI and sends chosen outfit to the server.【F:Example_Frameworks/ND_Core-main/client/events.lua†L56-L74】

## client/functions.lua
Exposes helper functions `getPlayer`, `getCharacters`, `getPlayersFromCoords`, `getConfig`, and `notify`, exporting each via `exports(name, func)` for other resources.【F:Example_Frameworks/ND_Core-main/client/functions.lua†L1-L44】

## client/peds.lua
Creates interactive NPCs with optional blips, clothing and ox_target options. Provides `NDCore.createAiPed` and `NDCore.removeAiPed`. Updates blips when character groups change and removes peds on resource stop. Command `getclothing` copies current ped outfit to clipboard.【F:Example_Frameworks/ND_Core-main/client/peds.lua†L208-L243】

## client/death.lua
Detects player death via `gameEventTriggered`, gathers killer and body damage data, then fires `ND:playerEliminated` to both client and server. Integrates with `ND_Ambulance` if present and disables spawnmanager auto-spawn after first spawn.

## client/vehicle/main.lua
Large module covering vehicle ownership mechanics, key fob effects, property synchronisation and keybinds. Registers events:
- `ND_Vehicles:blip` adds or removes a blip for personal vehicles.【F:Example_Frameworks/ND_Core-main/client/vehicle/main.lua†L252-L268】
- `ND_Vehicles:syncAlarm` triggers alarm sound/flash.【F:Example_Frameworks/ND_Core-main/client/vehicle/main.lua†L271-L278】
- `ND_VehicleSystem:setOwnedIfNot` marks vehicles as owned and locked.【F:Example_Frameworks/ND_Core-main/client/vehicle/main.lua†L279-L283】
- `ND_Vehicles:keyFob` plays remote lock animation.【F:Example_Frameworks/ND_Core-main/client/vehicle/main.lua†L332-L335】
Exports inventory item handlers `lockpick`, `hotwire`, and `keyControl` for ox_inventory integration.【F:Example_Frameworks/ND_Core-main/client/vehicle/main.lua†L630-L680】
Adds keybinds for cruise control and seat shuffle, and maintains vehicle property synchronisation through state bags.

## client/vehicle/garages.lua
Uses location data to spawn garage attendants via `NDCore.createAiPed`. Menu options allow parking and retrieving vehicles; selections call `ND_Vehicles:takeVehicle` on the server.【F:Example_Frameworks/ND_Core-main/client/vehicle/garages.lua†L120-L170】

## client/vehicle/data.lua
Defines garage and impound locations with ped coords and spawn points; consumed by `garages.lua`.

## server/main.lua
Initialises server configuration from convars, tracks player identifiers and Discord info, and auto-selects a character on first join. Loads database schema on MySQL ready. Responds to:
- `ND:playerEliminated` to flag characters as dead.【F:Example_Frameworks/ND_Core-main/server/main.lua†L175-L183】
- `ND:updateClothing` to persist outfit metadata.【F:Example_Frameworks/ND_Core-main/server/main.lua†L185-L190】

## server/player.lua
Core character abstraction providing money management, metadata storage, job/group assignment, and persistence to MySQL. Money operations trigger `ND:updateMoney` on the client and emit `ND:moneyChange` server events.【F:Example_Frameworks/ND_Core-main/server/player.lua†L34-L59】The `revive` method fires `ND:revivePlayer` to the client and clears death metadata.【F:Example_Frameworks/ND_Core-main/server/player.lua†L272-L279】Character loading/unloading fires `ND:characterUnloaded` and `ND:characterLoaded` events.

## server/vehicle.lua
Manages vehicle database records, key sharing, and spawn/despawn logic. Provides export `keys` to handle ox_inventory key items.【F:Example_Frameworks/ND_Core-main/server/vehicle.lua†L580-L595】Commands `getkeys` and `givekeys` create or transfer keys.【F:Example_Frameworks/ND_Core-main/server/vehicle.lua†L597-L635】Network events cover locking, alarms, hotwiring and storage retrieval.【F:Example_Frameworks/ND_Core-main/server/vehicle.lua†L638-L766】Database helpers expose `NDCore.getVehicleById`, `NDCore.spawnOwnedVehicle`, and callbacks for owned vehicle lists.

## server/functions.lua
Utility exports including `getPlayerIdentifierByType`, `getPlayers` filters, `loadSQL` file executor, Discord role lookup, and `enableMultiCharacter`. All NDCore functions are exported for other resources.【F:Example_Frameworks/ND_Core-main/server/functions.lua†L1-L114】

## server/commands.lua
Administrative commands registered via `lib.addCommand`:
- `setmoney`, `setjob`, `setgroup`, `skin`, `character`, `pay`, `unlock`, `revive`, `dv`, `goto`, `bring`, `freeze`, `unfreeze`, `vehicle`, `claim-veh`. Each is restricted to `group.admin` and uses NDCore.player helpers to apply effects.【F:Example_Frameworks/ND_Core-main/server/commands.lua†L17-L443】

## compatibility/esx
If `Config.compatibility` includes `"esx"`, provides an ESX-like API. Exports `es_extended`'s `getSharedObject`, wraps player data in ESX format, defines `NDCore.RegisterServerCallback`/`NDCore.GetPlayerData`, and maps numerous ESX utility stubs.【F:Example_Frameworks/ND_Core-main/compatibility/esx/client.lua†L27-L35】【F:Example_Frameworks/ND_Core-main/compatibility/esx/server.lua†L213-L214】

## compatibility/qb
Placeholder files that early-return unless `"qb"` is enabled; no functions defined.

## compatibility/backwards
Provides legacy ND_Functions API and events for older resources, including character management events (`ND:GetCharacters`, `ND:newCharacter`, etc.) and compatibility exports `GetCoreObject`.【F:Example_Frameworks/ND_Core-main/compatibility/backwards/server.lua†L228-L276】

## database/sql
- `characters.sql` defines `nd_characters` table storing personal data, groups, metadata and inventory.【F:Example_Frameworks/ND_Core-main/database/characters.sql†L1-L15】
- `vehicles.sql` defines `nd_vehicles` table with ownership, storage, impound and metadata fields linked to characters.【F:Example_Frameworks/ND_Core-main/database/vehicles.sql†L1-L12】

## locales
JSON locale files supply translations used by `lib.locale()`. They can be extended or replaced per language (ar, da, de, en, es, fi, fr, it, nl, no, ru, sv).

## Cross‑Indexes
### Events
| Name | Direction | Payload | Location |
|------|-----------|---------|----------|
| `ND:updateMoney` | Server→Client | `cash`, `bank` numbers | client/events.lua; server/player.lua |
| `ND:characterLoaded` | Server→Client | character object | client/events.lua |
| `ND:updateCharacter` | Server→Client | updated character or field | client/events.lua; server/player.lua |
| `ND:updateLastLocation` | Server→Client? | coords vector | client/events.lua (no server source) |
| `ND:revivePlayer` | Server→Client | none | client/events.lua; server/player.lua |
| `ND:characterUnloaded` | Server→Client | none | client/events.lua; server/player.lua |
| `ND:clothingMenu` | Server→Client | none | client/events.lua; server/commands.lua |
| `ND:playerEliminated` | Client→Server | death info table | client/death.lua; server/main.lua |
| `ND_Vehicles:blip` | Server↔Client | vehicle netId & status | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:syncAlarm` | Server↔Client | vehicle netId | client/vehicle/main.lua; server/vehicle.lua |
| `ND_VehicleSystem:setOwnedIfNot` | Server→Client | vehicle netId | client/vehicle/main.lua |
| `ND_Vehicles:keyFob` | Server→Client | vehicle netId | client/vehicle/main.lua |
| `ND_Vehicles:toggleVehicleLock` | Client→Server | vehicle netId | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:disableKey` | Client→Server | inventory slot | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:lockpick` | Client→Server | netId, success flag | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:hotwire` | Client→Server | netId | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:storeVehicle` | Client→Server | netId | client/vehicle/garages.lua; server/vehicle.lua |
| `ND_Vehicles:takeVehicle` | Client→Server | vehicle id, spawn list | client/vehicle/garages.lua; server/vehicle.lua |
| `ND:GetCharacters` etc. | Client↔Server | character data | compatibility/backwards |

### ESX Callbacks
Compatibility layer exposes `NDCore.RegisterServerCallback`/`lib.callback.register` and `NDCore.Progressbar`, `NDCore.SearchInventory`, among others, enabling ESX-style interactions.【F:Example_Frameworks/ND_Core-main/compatibility/esx/server.lua†L213-L214】【F:Example_Frameworks/ND_Core-main/compatibility/esx/client.lua†L37-L74】

### Exports
| Name | Side | Purpose |
|------|------|---------|
| NDCore functions (various) | Client & Server | General framework API (player data, config, utilities)【F:Example_Frameworks/ND_Core-main/client/functions.lua†L40-L44】【F:Example_Frameworks/ND_Core-main/server/functions.lua†L108-L114】 |
| `keys` | Server | ox_inventory handler for vehicle key items【F:Example_Frameworks/ND_Core-main/server/vehicle.lua†L580-L595】 |
| `lockpick`, `hotwire`, `keyControl` | Client | Inventory callbacks for vehicle actions【F:Example_Frameworks/ND_Core-main/client/vehicle/main.lua†L630-L680】 |
| `GetCoreObject` | Compatibility | Legacy access to NDCore object【F:Example_Frameworks/ND_Core-main/compatibility/backwards/server.lua†L1-L8】 |

### Commands
| Command | Side | Description |
|---------|------|-------------|
| `getclothing` | Client | Copies current ped clothing data【F:Example_Frameworks/ND_Core-main/client/peds.lua†L234-L243】 |
| `getkeys`, `givekeys` | Server | Generate or share vehicle keys【F:Example_Frameworks/ND_Core-main/server/vehicle.lua†L597-L635】 |
| Admin commands (`setmoney`, `setjob`, `setgroup`, `skin`, `character`, `pay`, `unlock`, `revive`, `dv`, `goto`, `bring`, `freeze`, `unfreeze`, `vehicle`, `claim-veh`) | Server | Staff utilities for economy, teleportation and vehicle management【F:Example_Frameworks/ND_Core-main/server/commands.lua†L17-L443】 |

## Configuration & Integration
- Convars (`core:*`) define server name, Discord settings, vehicle key behaviour, group definitions, plate patterns and compatibility flags on both client and server.【F:Example_Frameworks/ND_Core-main/client/main.lua†L4-L20】【F:Example_Frameworks/ND_Core-main/server/main.lua†L8-L32】
- Requires `ox_lib` and `oxmysql` and optionally integrates with `ox_inventory`, `ox_target`, `fivem-appearance`, and `ND_Ambulance`.

## Gaps & Inferences
- `ND:updateLastLocation` is defined client-side but no origin found; presumed server broadcast when character position updates (Inference Low).【F:Example_Frameworks/ND_Core-main/client/events.lua†L18-L22】

DOCS COMPLETE
