# essentialmode Package Documentation

## Overview
This package bundles the core **essentialmode** framework and the accompanying **es_admin** addon. Essentialmode manages player accounts, permissions and money using a MySQL backend, while es_admin adds administrative chat commands for moderation and teleportation. Both components run within FiveM and communicate through events and NUI messages.

## Table of Contents
- [Shared](#shared)
  - [README.md](#readmemd)
  - [sql.sql](#sqlsql)
  - [essentialmode/agents.md](#essentialmodeagentsmd)
  - [essentialmode/docs.md](#essentialmodedocsmd)
  - [essentialmode/fxmanifest.lua](#essentialmodefxmanifestlua)
  - [[essential]/es_admin/agents.md](#essentiales_adminagentsmd)
  - [[essential]/es_admin/fxmanifest.lua](#essentiales_adminfxmanifestlua)
  - [[essential]/es_admin/positions.txt](#essentiales_adminpositionstxt)
- [Server](#server)
  - [essentialmode/server/util.lua](#essentialmodeserverutillua)
  - [essentialmode/server/main.lua](#essentialmodeservermainlua)
  - [essentialmode/server/player/login.lua](#essentialmodeserverplayerloginlua)
  - [essentialmode/server/classes/player.lua](#essentialmodeserverclassesplayerlua)
  - [essentialmode/server/classes/groups.lua](#essentialmodeserverclassesgroupslua)
  - [[essential]/es_admin/sv_admin.lua](#essentiales_adminsv_adminlua)
- [Client](#client)
  - [essentialmode/client/main.lua](#essentialmodeclientmainlua)
  - [[essential]/es_admin/cl_admin.lua](#essentiales_admincl_adminlua)
- [NUI](#nui)
  - [essentialmode/ui.html](#essentialmodeuihtml)
  - [essentialmode/pdown.ttf](#essentialmodepdownttf)
- [Cross-Index](#cross-index)
  - [Events](#events)
  - [ESX Callbacks](#esx-callbacks)
  - [Exports](#exports)
  - [Commands](#commands)
  - [RCON Commands](#rcon-commands)
  - [NUI Messages](#nui-messages)
  - [Database](#database)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## Shared
### README.md
Top-level guide describing Essentialmode’s purpose and installation steps. It explains that the framework simplifies resource creation and must be configured with database credentials before being added to the server’s autostart list.

### sql.sql
SQL schema creating the `gta5_gamemode_essential` database with `users` and `bans` tables. The schema defines identifiers, permission levels, groups, money balance, and ban metadata for persistence.

### essentialmode/agents.md
Contributor instructions for documenting the essentialmode resource. It carries no runtime logic.

### essentialmode/docs.md
Existing documentation detailing the essentialmode internals and event surface. The current document supersedes it by adding es_admin coverage.

### essentialmode/fxmanifest.lua
Modern manifest declaring NUI files, integrating `oxmysql`, and listing server/client scripts.

### [essential]/es_admin/agents.md
Documentation instructions specific to the es_admin addon.

### [essential]/es_admin/fxmanifest.lua
Manifest converted to `fxmanifest.lua` syntax, declares dependency on essentialmode, integrates `oxmysql`, and registers the addon scripts.

### [essential]/es_admin/positions.txt
Data file where the “pos” command appends coordinate tables for later reference.

## Server
### essentialmode/server/util.lua
Helper functions shared by server scripts:
- `stringsplit`, `startswith`, and `returnIndexesInTable` offer basic string and table helpers and are exported globally for reuse.
- `debugMsg` emits tagged debug output when debugging is enabled and is callable through the `es:debugMsg` event.

### essentialmode/server/main.lua
Primary server runtime responsible for:
- Initialising local registries for users, commands and configuration defaults.
- Checking bans during `playerConnecting` with deferrals and saving money asynchronously on `playerDropped`.
- Handling first join flow via `es:firstJoinProper`, enabling PvP when configured, and raising `es:firstSpawn` on first spawn.
- Managing session settings through `es:setSessionSetting` and `es:getSessionSetting`.
- Parsing chat messages that begin with `/` to resolve registered commands. It enforces permission levels or group membership, triggers audit hooks (`es:adminCommandRan`, `es:userCommandRan`, `es:commandRan`, `es:adminCommandFailed`, `es:invalidCommandHandler`, `es:chatMessage`), and denies access with a configured message when appropriate.
- Providing APIs for other resources to register commands (`es:addCommand`, `es:addAdminCommand`, `es:addGroupCommand`). A built‑in `info` command reports the essentialmode version and command count.
- Receiving periodic coordinate updates (`es:updatePositions`) to track player positions.

### essentialmode/server/player/login.lua
Database integration and account lifecycle:
- Uses asynchronous `MySQL` helpers to query the `users` table and construct `Player` objects.
- Fires `es:playerLoaded`, applies rank decorators when enabled, and marks brand new accounts via `es:newPlayerLoaded`.
- Provides functions to check bans (including expiry), test for existing accounts, register default records, and expose events like `es:setPlayerData`, `es:setPlayerDataId`, `es:getPlayerFromId`, `es:getPlayerFromIdentifier`, `es:getAllPlayers`, and `es:getPlayers`.
- Periodically persists all players’ money every minute.

### essentialmode/server/classes/player.lua
Defines the `Player` object representing a connected user:
- Stores identifiers, permission level, cash balance, group, last known coordinates and arbitrary session variables.
- Methods `getPermissions` and `setPermissions` read or modify permission level via `es:setPlayerData`; `kick` disconnects a player.
- Money helpers `setMoney`, `addMoney`, and `removeMoney` adjust balance and emit corresponding client events (`es:activateMoney`, `es:addedMoney`, `es:removedMoney`).
- `setCoords`, `setSessionVar`, and `getSessionVar` update position and custom session state.

### essentialmode/server/classes/groups.lua
Implements hierarchical permission groups:
- `Group` metatable registers groups with optional inheritance and provides `canTarget` to verify authority over another group.
- Default groups `user`, `admin`, and `superadmin` are defined with proper inheritance.
- Event `es:addGroup` allows runtime creation of custom groups; `es:getAllGroups` returns the registry.

### [essential]/es_admin/sv_admin.lua
Server‑side administrative addon:
- Registers custom groups `owner` and `mod` and provides chat commands for moderators and admins: vehicle spawning, reports, noclip, kick, timed bans (with database inserts), announcements, freezing, teleportation (`bring`/`goto`), slap, self‑kill, targeted kill, crash, and position capture.
- Persists bans using `oxmysql`.
- Each sensitive command verifies that the caller’s permission level or group outranks the target.
- Receives client positions via `es_admin:givePos` and appends them to `positions.txt`.
- Defines console (RCON) commands to adjust permissions, groups, money, and bans.
- Listens for `es:adminCommandRan` for potential logging but leaves the handler empty.

## Client
### essentialmode/client/main.lua
Client runtime coordinating with the server:
- On session start, triggers `es:firstJoinProper` to initialise the account.
- Every second sends `es:updatePositions` when the player's coordinates change and refreshes the NUI money display when awaiting data.
- Manages decorators set via `es:setPlayerDecorator`, registering keys only once and reapplying them on `playerSpawned`.
- Handles money events (`es:activateMoney`, `es:addedMoney`, `es:removedMoney`) and opacity changes (`es:setMoneyDisplay`) by relaying to the NUI while keeping a local cash tally.
- When `es:enablePvp` arrives, enables friendly fire for the local player.

### [essential]/es_admin/cl_admin.lua
Client counterpart for administrative commands:
- Spawns vehicles, toggles noclip, teleports players, applies slaps or kills on demand, and enforces freeze positions when told by the server.
- The `pos` command sends formatted coordinates back to the server for logging.
- Maintains loops to keep frozen players stationary and to move the player when noclip mode is active.

## NUI
### essentialmode/ui.html
Browser UI used to display the player’s cash:
- Listens for messages from scripts to update money, show temporary add/remove animations, hide the startup window, and adjust opacity.
- Uses a custom font (`pdown.ttf`) and minimal styling to render the overlay.

### essentialmode/pdown.ttf
Font file referenced by the NUI for rendering the money display.

## Cross-Index
### Events
| Event | Direction | Payload | Notes |
|-------|-----------|---------|-------|
| playerConnecting | CFX → server | name, setCallback | Checks ban status and cancels if banned |
| playerDropped | CFX → server | — | Persists cash balance |
| es:firstJoinProper | client → server | — | Loads or registers account, emits `es:initialized` |
| es:initialized | server → server | source | Signals user data ready |
| es:enablePvp | server → client | — | Enables friendly fire |
| es:setSessionSetting / es:getSessionSetting | server ↔ server | key[, value/callback] | Session configuration |
| playerSpawn | CFX → server | — | Triggers `es:firstSpawn` for first spawn |
| es:firstSpawn | server → server | source | Hook for spawn logic |
| es:setDefaultSettings | server → server | table | Overrides default config |
| chatMessage | CFX → server | source, author, message | Slash command parser |
| es:addCommand / es:addAdminCommand / es:addGroupCommand | server → server | command, callbacks | Registers commands |
| es:updatePositions | client → server | x, y, z | Stores session coordinates |
| es:debugMsg | server ↔ server | message | Tagged debug output |
| es:addGroup / es:getAllGroups | server ↔ server | group info | Manages permission groups |
| es:getPlayers | server → server | callback | Returns user map |
| es:setPlayerData / es:setPlayerDataId | server → server | id, key, value, cb | Updates DB fields |
| es:getPlayerFromId / es:getPlayerFromIdentifier / es:getAllPlayers | server → server | identifiers, cb | Fetches user records |
| es:playerLoaded | server → server | source, user | Announces account data ready |
| es:newPlayerLoaded | server → server | source, user | Fires for first-time users |
| es:adminCommandRan | server → server | source, command | Hook for admin command logging |
| es:userCommandRan | server → server | source, command | Hook for non-admin command logging |
| es:commandRan | server → server | source, command | Fired after any command executes |
| es:adminCommandFailed | server → server | source, command | Fired when permissions are insufficient |
| es:invalidCommandHandler | server → server | source, command | Triggered on unknown command |
| es:chatMessage | server → server | source, message, user | Forwarded non-command chat |
| es:setPlayerDecorator | server → client | key, value, doNow | Applies ped decorators |
| playerSpawned | CFX → client | — | Reapplies decorators |
| es:activateMoney | server → client | amount | Sets cash display |
| es:addedMoney / es:removedMoney | server → client | delta | Shows cash change |
| es:setMoneyDisplay | server → client | opacity | Sets UI opacity |
| es_admin:spawnVehicle | server → client | model | Spawns a vehicle for requester |
| es_admin:noclip | server → client | — | Toggles noclip mode |
| es_admin:freezePlayer | server → client | state | Freezes or unfreezes player |
| es_admin:teleportUser | server → client | targetId | Teleports player to another user |
| es_admin:slap | server → client | — | Applies force to player |
| es_admin:givePosition | server → client | — | Requests client coordinates |
| es_admin:givePos | client → server | coord string | Appends position to file |
| es_admin:kill | server → client | — | Sets player health to zero |
| es_admin:crash | server → client | — | Forces client into infinite loop |

### ESX Callbacks
None.

### Exports
None.

### Commands
| Command | Access | Description |
|---------|--------|-------------|
| info | all users | Shows Essentialmode version and command count |
| admin | all users | Prints caller’s permission level and group |
| car | all users | Spawns a vehicle model |
| report | all users | Sends a report message to online staff |
| noclip | admin group | Toggles noclip for the caller |
| kick | mod group | Kicks a player with optional reason |
| ban | admin group | Bans a player for a duration; writes to DB |
| announce | admin group | Broadcasts a server‑wide message |
| freeze | mod group | Freezes or unfreezes a target player |
| bring | mod group | Teleports target player to caller |
| slap | admin group | Launches target player with force |
| goto | mod group | Teleports caller to target player |
| die | all users | Kills the caller |
| slay | admin group | Kills target player |
| crash | superadmin group | Forces target client to crash |
| pos | owner group | Requests client coordinates and saves them |

### RCON Commands
| Command | Arguments | Description |
|---------|-----------|-------------|
| setadmin | playerId, level | Sets a player’s permission level |
| setgroup | playerId, group | Assigns a group to a player |
| setmoney | playerId, amount | Sets a player’s money |
| unban | identifier | Placeholder for unbanning (no effect) |
| ban | playerId | Marks player as banned in database |

### NUI Messages
| Field | Purpose |
|-------|---------|
| setmoney | Replace displayed cash with amount |
| addcash | Show temporary green increment |
| removecash | Show temporary red decrement |
| setDisplay | Adjust UI opacity |
| removeStartWindow | Remove initial placeholder element |

### Database
| Table | Fields Used | Purpose |
|-------|-------------|---------|
| users | identifier, permission_level, money, group | Stores player identity, permissions and cash |
| bans | banned, banner, reason, expires, timestamp | Tracks bans and their duration |

## Configuration & Integration
- Database credentials are provided via server convars (`essentialmode_db_host`, `essentialmode_db_name`, `essentialmode_db_user`, `essentialmode_db_password`).
- Include both `essentialmode` and `[essential]/es_admin` in the server’s resource start list so the admin commands are available.
- Other resources can register commands or groups by triggering the events exposed in `server/main.lua`.

## Gaps & Inferences
- Bundled MySQL libraries were removed in favour of `oxmysql`.
- `playerConnecting` now uses deferrals for ban checks.
- `stringsplit` util was rewritten to use Lua pattern matching.
- PVP enabling only adjusts the local player instead of looping through all players.
- RCON `unban` command remains unimplemented. **TODO**
- Event handler for `es:adminCommandRan` is empty, so admin command logging is not implemented. **TODO**
- Audit events `es:userCommandRan`, `es:commandRan`, `es:adminCommandFailed`, and `es:invalidCommandHandler` are emitted without default handlers. *(Info)*
- Event `es:chatMessage` has no handler in this resource; non-command chat relies on external listeners. **TODO**

DOCS COMPLETE
