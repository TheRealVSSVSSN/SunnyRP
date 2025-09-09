# ND_Core Documentation

## Overview
ND_Core is the primary gameplay framework for SunnyRP. It manages player and vehicle state, permissions, and cross-resource integration. Runtime configuration is driven by server convars and data persisted in the MySQL tables `nd_characters` and `nd_vehicles`.

## Table of Contents
- [Client Files](#client-files)
  - [client/main.lua](#clientmainlua)
  - [client/events.lua](#clienteventslua)
  - [client/functions.lua](#clientfunctionslua)
  - [client/peds.lua](#clientpedslua)
  - [client/death.lua](#clientdeathlua)
  - [client/vehicle/main.lua](#clientvehiclemainlua)
  - [client/vehicle/garages.lua](#clientvehiclegarageslua)
  - [client/vehicle/data.lua](#clientvehicledata)
- [Server Files](#server-files)
  - [server/main.lua](#servermainlua)
  - [server/player.lua](#serverplayerlua)
  - [server/vehicle.lua](#servervehiclelua)
  - [server/functions.lua](#serverfunctionslua)
  - [server/commands.lua](#servercommandslua)
- [Shared Files](#shared-files)
  - [shared/functions.lua](#sharedfunctionslua)
  - [init.lua](#initlua)
- [Compatibility Files](#compatibility-files)
  - [compatibility/backwards/client.lua](#compatibilitybackwardsclientlua)
  - [compatibility/backwards/server.lua](#compatibilitybackwardsserverlua)
  - [compatibility/esx/client.lua](#compatibilityesxclientlua)
  - [compatibility/esx/server.lua](#compatibilityesxserverlua)
  - [compatibility/esx/locale.lua](#compatibilityesxlocalelua)
  - [compatibility/qb/client.lua](#compatibilityqbclientlua)
  - [compatibility/qb/server.lua](#compatibilityqbserverlua)
- [Database](#database)
  - [database/characters.sql](#databasecharacterssql)
  - [database/vehicles.sql](#databasevehiclessql)
- [Locales](#locales)
- [Other Files](#other-files)
  - [fxmanifest.lua](#fxmanifestlua)
  - [README.md](#readmemd)
  - [LICENSE](#license)
  - [.github/ISSUE_TEMPLATE/bug_report.md](#githubissuetemplatebug_reportmd)
  - [.github/ISSUE_TEMPLATE/feature_request.md](#githubissuetemplatefeature_requestmd)
  - [agents.md](#agentsmd)

## Client Files
### client/main.lua
Initialises client configuration from replicated convars, sets Discord rich presence, and updates the pause menu with player information. It enables friendly fire after spawn and on resource start to ease testing.

### client/events.lua
Registers client-side listeners for money, character state and clothing changes. Events update cached player data, revive the player, open the clothing menu and record last location (origin unresolved).

### client/functions.lua
Exposes helper functions `getPlayer`, `getCharacters`, `getPlayersFromCoords`, `getConfig`, and `notify`, exporting each for other resources to call【F:client/functions.lua†L1-L44】.

### client/peds.lua
Spawns interactive NPCs with optional blips and ox_target options. Provides `NDCore.createAiPed`/`NDCore.removeAiPed`, updates blips when character groups change and offers command `getclothing` that copies current ped attire to the clipboard【F:client/peds.lua†L208-L243】.

### client/death.lua
Monitors `gameEventTriggered` to detect player deaths. Compiles kill information and sends `ND:playerEliminated` to both client and server, optionally integrating ND_Ambulance for body damage data.

### client/vehicle/main.lua
Handles vehicle ownership, locking, alarms and key fob effects. Registers callbacks for vehicle properties and model labels【F:client/vehicle/main.lua†L376-L386】, listens for blip and alarm sync events, and exports inventory handlers `lockpick`, `hotwire` and `keyControl`【F:client/vehicle/main.lua†L630-L680】. Keybinds provide locking, cruise control and seat shuffling.

### client/vehicle/garages.lua
Uses location data to create garage attendants via `NDCore.createAiPed`. Menu selections trigger `ND_Vehicles:storeVehicle` and `ND_Vehicles:takeVehicle` on the server and fetch owned vehicles through a callback.

### client/vehicle/data.lua
Defines garage and impound locations with ped positions and vehicle spawn points consumed by `garages.lua`.

## Server Files
### server/main.lua
Loads server configuration from convars, tracks player identifiers and Discord details, and prepares MySQL schema on startup. Handles `playerJoining`, `playerConnecting`, `playerDropped`, and resource start/stop. Network events flag player elimination and update clothing metadata.

### server/player.lua
Implements the core character object with money management, metadata storage, job/group assignment and Discord info. Money operations trigger client updates and emit `ND:moneyChange`. The `revive` method sends `ND:revivePlayer` to the client and clears death metadata; loading/unloading characters emits corresponding events and `ND:groupRemoved` when groups are removed【F:server/player.lua†L34-L59】【F:server/player.lua†L292-L298】【F:server/player.lua†L396-L398】.

### server/vehicle.lua
Manages vehicle records, key sharing and spawn/despawn logic. Exports an inventory handler `keys` for ox_inventory【F:server/vehicle.lua†L580-L595】, registers callbacks for owned vehicle lists【F:server/vehicle.lua†L788-L792】 and processes events for locking, alarm sync, hotwiring and garage interactions. Commands `getkeys` and `givekeys` allow key generation and transfer【F:server/vehicle.lua†L598-L635】.

### server/functions.lua
General utilities for identifier lookup, player retrieval, configuration access, SQL file execution and Discord role queries. Every function in `NDCore` is exported for external resources【F:server/functions.lua†L1-L114】.

### server/commands.lua
Defines administrative commands via `lib.addCommand` for money, jobs, groups, clothing, character selection, teleportation, freezing and vehicle management. Command security relies on `group.admin` restrictions【F:server/commands.lua†L17-L443】. Events `ND:clothingMenu` and `ND:characterMenu` are sent to targets, but no handlers exist in this resource for the latter【F:server/commands.lua†L170-L191】.

## Shared Files
### shared/functions.lua
Provides `NDCore.isResourceStarted`, allowing scripts to detect start/stop of other resources and register callbacks.【F:shared/functions.lua†L12-L29】

### init.lua
Returns a proxy `NDCore` object that invokes exported server functions for external resources.【F:init.lua†L1-L12】

## Compatibility Files
### compatibility/backwards/client.lua
Enables legacy ND_Functions APIs and exports `GetCoreObject`. Listens for `ND:returnCharacters` and `ND:setCharacter` to maintain backwards compatibility【F:compatibility/backwards/client.lua†L8-L17】.

### compatibility/backwards/server.lua
Provides legacy exports and events (`ND:GetCharacters`, `ND:newCharacter`, `ND:editCharacter`, `ND:deleteCharacter`, `ND:setCharacterOnline`, `ND:updateClothes`) for older resources【F:compatibility/backwards/server.lua†L224-L276】. Also fires `ND:jobChanged` when jobs are updated【F:compatibility/backwards/server.lua†L191-L192】.

### compatibility/esx/client.lua
Implements an ESX-like client API, wrapping functions such as `GetPlayerData`, `Progressbar`, inventory checks and ESX streaming helpers. Updates ESX-style player data when characters load or change.

### compatibility/esx/server.lua
Adds ESX compatibility by mapping player methods, registering commands and exposing `NDCore.RegisterServerCallback` for ESX callbacks【F:compatibility/esx/server.lua†L213】. It also triggers `esx:playerLoaded`/`esx:playerDropped` events for other ESX resources【F:compatibility/esx/server.lua†L368-L372】.

### compatibility/esx/locale.lua
Provides translation helpers mirroring ESX's locale system.

### compatibility/qb/client.lua & compatibility/qb/server.lua
Placeholders that only activate if the `qb` compatibility flag is set; no functions are defined otherwise.

## Database
### database/characters.sql
Schema for `nd_characters` storing personal data, groups, metadata and inventory【F:database/characters.sql†L1-L15】.

### database/vehicles.sql
Schema for `nd_vehicles` linking owned vehicles to characters with storage, impound and metadata fields【F:database/vehicles.sql†L1-L14】.

## Locales
JSON locale files (ar, da, de, en, es, fi, fr, it, nl, no, ru, sv) supply translations consumed via `lib.locale()`.

## Other Files
### fxmanifest.lua
Declares resource metadata, dependencies (`ox_lib`, `oxmysql`), scripts for client/server/shared sides and configuration files【F:fxmanifest.lua†L1-L39】.

### README.md
Summarises dependencies and related add-on resources and links to external documentation.

### LICENSE
Distributed under the GNU GPLv3 license.

### .github/ISSUE_TEMPLATE/bug_report.md
GitHub issue template prompting for bug details and reproduction steps.

### .github/ISSUE_TEMPLATE/feature_request.md
Template for suggesting enhancements.

### agents.md
Contributor instructions describing documentation expectations for this resource.

## Cross-Indexes
### Events
| Name | Direction | Payload | Location |
|------|-----------|---------|----------|
| `ND:updateMoney` | Server→Client | `cash`, `bank` numbers | client/events.lua; server/player.lua |
| `ND:characterLoaded` | Server→Client | character object | client/events.lua; server/player.lua |
| `ND:updateCharacter` | Server→Client | character or field name | client/events.lua; server/player.lua |
| `ND:updateLastLocation` | Server→Client? | position vector | client/events.lua (no server source) |
| `ND:revivePlayer` | Server→Client | none | client/events.lua; server/player.lua |
| `ND:characterUnloaded` | Server→Client | none | client/events.lua; server/player.lua |
| `ND:clothingMenu` | Server→Client | none | client/events.lua; server/commands.lua |
| `ND:characterMenu` | Server→Client | none (no handler) | server/commands.lua |
| `ND:playerEliminated` | Client→Server | death info table | client/death.lua; server/main.lua |
| `ND:updateClothing` | Client→Server | appearance table | client/events.lua; server/main.lua |
| `ND:returnCharacters` | Server→Client | character list | compatibility/backwards/server.lua; compatibility/backwards/client.lua |
| `ND:setCharacter` | Server→Client | character object (no source) | compatibility/backwards/client.lua |
| `ND:GetCharacters` | Client→Server | none | compatibility/backwards/server.lua |
| `ND:newCharacter` | Client→Server | character data | compatibility/backwards/server.lua |
| `ND:editCharacter` | Client→Server | updated character data | compatibility/backwards/server.lua |
| `ND:deleteCharacter` | Client→Server | character id | compatibility/backwards/server.lua |
| `ND:setCharacterOnline` | Client→Server | character id | compatibility/backwards/server.lua |
| `ND:updateClothes` | Client→Server | clothing table | compatibility/backwards/server.lua |
| `ND:jobChanged` | Server→Client | new & old job info | compatibility/backwards/server.lua |
| `ND:moneyChange` | Server Event | src, account, amount, action | server/player.lua |
| `ND:groupRemoved` | Server Event | character, group | server/player.lua |
| `ND_Vehicles:blip` | Server↔Client | vehicle netId & status | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:syncAlarm` | Server↔Client | vehicle netId | client/vehicle/main.lua; server/vehicle.lua |
| `ND_VehicleSystem:setOwnedIfNot` | Server→Client | vehicle netId | client/vehicle/main.lua |
| `ND_Vehicles:keyFob` | Server→Client | vehicle netId | client/vehicle/main.lua |
| `ND_Vehicles:toggleVehicleLock` | Client→Server | netId | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:disableKey` | Client→Server | inventory slot | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:lockpick` | Client→Server | netId, success flag | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:hotwire` | Client→Server | netId | client/vehicle/main.lua; server/vehicle.lua |
| `ND_Vehicles:storeVehicle` | Client→Server | netId | client/vehicle/garages.lua; server/vehicle.lua |
| `ND_Vehicles:takeVehicle` | Client→Server | vehicle id, spawn options | client/vehicle/garages.lua; server/vehicle.lua |

### ESX Callbacks
| Name | Side | Parameters | Location |
|------|------|------------|----------|
| `ND_Vehicles:getProps` | Client | `netId` | client/vehicle/main.lua |
| `ND_Vehicles:getPropsFromCurrentVeh` | Client | none | client/vehicle/main.lua |
| `ND_Vehicles:getVehicleModelMakeLabel` | Client | `model` hash | client/vehicle/main.lua |
| `ND_Vehicles:getOwnedVehicles` | Server | `src` | server/vehicle.lua |

### Exports
| Name | Side | Purpose | Location |
|------|------|---------|----------|
| `getPlayer`, `getCharacters`, `getPlayersFromCoords`, `getConfig`, `notify` | Client | Framework utilities | client/functions.lua |
| `lockpick`, `hotwire`, `keyControl` | Client | ox_inventory item handlers | client/vehicle/main.lua |
| `keys` | Server | ox_inventory vehicle key handler | server/vehicle.lua |
| `GetCoreObject` | Client & Server | Legacy NDCore access | compatibility/backwards/client.lua; compatibility/backwards/server.lua |
| NDCore functions (various) | Client & Server | General framework API | client/functions.lua; server/functions.lua |

### Commands
| Command | Side | Description | Location |
|---------|------|-------------|----------|
| `getclothing` | Client | Copies current ped clothing to clipboard | client/peds.lua |
| `getkeys` | Server | Create key item for current vehicle | server/vehicle.lua |
| `givekeys` | Server | Share vehicle keys with another player | server/vehicle.lua |
| Admin commands (`setmoney`, `setjob`, `setgroup`, `skin`, `character`, `pay`, `unlock`, `revive`, `dv`, `goto`, `bring`, `freeze`, `unfreeze`, `vehicle`, `claim-veh`) | Server | Staff utilities for economy, teleportation and vehicle management | server/commands.lua |

## Configuration & Integration
- Convars prefixed `core:` control server name, Discord settings, key usage, groups, compatibility flags and plate patterns on both client and server.
- Depends on `ox_lib` and `oxmysql`; optionally integrates with `ox_inventory`, `ox_target`, `fivem-appearance`, and `ND_Ambulance`.
- Discord integration can enforce guild membership and populate rich presence.

## Gaps & Inferences
- `ND:updateLastLocation` is registered client-side but no server source found; presumed broadcast when character position updates (Inference Low)【F:client/events.lua†L18-L22】.
- `ND:characterMenu` is triggered by admin command but lacks a handler in this resource (Inference Low)【F:server/commands.lua†L170-L191】.

DOCS COMPLETE
