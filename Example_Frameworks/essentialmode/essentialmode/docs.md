# essentialmode Documentation

## Overview
Essentialmode provides core player/session management and command framework for FiveM resources. It handles user accounts, permission levels, money tracking, and basic UI for displaying cash. The system relies on MySQL for persistence and exposes events for other resources to interact with player data and command registration.

## Table of Contents
- [Shared](#shared)
  - [__resource.lua](#__resourcelua)
  - [lib/MySQL.lua](#libmysqllua)
- [Server](#server)
  - [server/util.lua](#serverutillua)
  - [server/main.lua](#servermainlua)
  - [server/player/login.lua](#serverplayerloginlua)
  - [server/classes/player.lua](#serverclassesplayerlua)
  - [server/classes/groups.lua](#serverclassesgroupslua)
- [Client](#client)
  - [client/main.lua](#clientmainlua)
- [NUI](#nui)
  - [ui.html](#uihtml)
  - [pdown.ttf](#pdownttf)
- [Cross-Index](#cross-index)
  - [Events](#events)
  - [ESX Callbacks](#esx-callbacks)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Messages](#nui-messages)
  - [Database](#database)
- [Gaps & Inferences](#gaps--inferences)

## Shared
### __resource.lua
Manifest defining the resource. It declares the NUI page, includes the font, and registers server and client scripts. *Gap:* references `client/player.lua`, which is absent.

### lib/MySQL.lua
Lightweight wrapper around a .NET MySql.Data driver. Opens connections, executes parameterized queries, escapes input, and reads results by field type.

## Server
### server/util.lua
Utility helpers available server-side:
- `stringsplit`, `startswith`, `returnIndexesInTable` provide basic string and table operations.
- `debugMsg` prints tagged output when `settings.defaultSettings.debugInformation` is true and is exposed via event `es:debugMsg`.

### server/main.lua
Core server runtime:
- Initializes player registry (`Users`), command store, and default settings (ban text, PvP toggle, permission message, debug flag, starting cash, rank decorators).
- On `playerConnecting` runs `isIdentifierBanned`; kicks with configured message when banned.
- On `playerDropped` saves player money to the database.
- `es:firstJoinProper` loads or registers user data then fires `es:initialized`; optionally enables PvP and marks player for first spawn.
- Session setting events (`es:setSessionSetting`/`es:getSessionSetting`).
- `playerSpawn` detects first spawn and emits `es:firstSpawn`.
- `es:setDefaultSettings` merges new defaults into `settings.defaultSettings`.
- Chat command handler parses slash-prefixed input, resolves against registered commands, checks permissions and group inheritance, and triggers audit events (`es:adminCommandRan`, `es:userCommandRan`, `es:commandRan`, etc.). Permission denial attempts send a message to the player.
- Events allow other resources to register commands: `es:addCommand`, `es:addAdminCommand`, `es:addGroupCommand`. A built-in `info` command reports version and command count.
- `es:updatePositions` stores player coordinates in their session object.

### server/player/login.lua
Account and persistence logic:
- Loads MySQL wrapper and opens a connection using hard-coded credentials.
- `LoadUser` retrieves user row, instantiates a `Player` object, triggers `es:playerLoaded`, optionally sets a rank decorator and fires `es:newPlayerLoaded` for fresh accounts.
- `isIdentifierBanned` queries `bans` table to check active bans.
- `hasAccount` tests for an existing user record.
- `registerUser` inserts default record when necessary then loads the account.
- Data access events (`es:setPlayerData`, `es:setPlayerDataId`, `es:getPlayerFromId`, `es:getPlayerFromIdentifier`, `es:getAllPlayers`, `es:getPlayers`) provide CRUD helpers for other resources.
- Background `savePlayerMoney` timer persists all players’ money every 60 seconds.

### server/classes/player.lua
Represents a connected player:
- Constructor stores identifiers, permission level, money, group, coordinates, and session variables.
- `getPermissions`/`setPermissions` manage permission level and persist changes via `es:setPlayerData`.
- `setCoords` updates session position.
- `kick` disconnects a player.
- `setMoney`, `addMoney`, and `removeMoney` adjust balance and broadcast `es:addedMoney`, `es:removedMoney`, and `es:activateMoney` accordingly.
- `setSessionVar`/`getSessionVar` manage arbitrary session data.

### server/classes/groups.lua
Implements permission groups:
- `Group` metatable registers groups with optional inheritance and provides `canTarget` to test hierarchical authority.
- Default groups: `user`, `admin` (inherits user), `superadmin` (inherits admin).
- `es:addGroup` adds custom groups and adjusts inheritance; `es:getAllGroups` returns the group registry.

## Client
### client/main.lua
Client runtime:
- On session start triggers `es:firstJoinProper` to let the server initialize the user.
- Periodically sends `es:updatePositions` with current coordinates and refreshes the cash display when awaiting data.
- Maintains decorator values received via `es:setPlayerDecorator`; reapplies them on `playerSpawned`.
- Handles money events (`es:activateMoney`, `es:addedMoney`, `es:removedMoney`) by forwarding messages to the NUI.
- `es:setMoneyDisplay` adjusts UI opacity.
- `es:enablePvp` continuously enables friendly fire among connected players.

## NUI
### ui.html
HTML page rendered by the game UI:
- Loads jQuery and a custom `pcdown` font.
- Listens for messages from `SendNUIMessage` and updates the cash overlay: shows current balance, transient additions or subtractions, hides the startup window, and adjusts opacity.

### pdown.ttf
Font file referenced by `ui.html` for the money display.

## Cross-Index
### Events
| Event | Direction | Payload | Notes |
|-------|-----------|---------|-------|
| playerConnecting | CFX → server | name, setCallback | Checks ban status against DB |
| playerDropped | CFX → server | — | Saves money to DB |
| es:firstJoinProper | client → server | — | Registers or loads player; emits `es:initialized` |
| es:initialized | server → server | source | Signals user data ready |
| es:enablePvp | server → client | — | Enables friendly fire |
| es:setSessionSetting / es:getSessionSetting | server ↔ server | key[, value/callback] | Session-level config |
| playerSpawn | CFX → server | — | Triggers `es:firstSpawn` on first spawn |
| es:firstSpawn | server → server | source | Hook for spawn initialization |
| es:setDefaultSettings | server → server | table | Overrides default config |
| chatMessage | CFX → server | source, author, message | Slash commands parser |
| es:addCommand / es:addAdminCommand / es:addGroupCommand | server → server | command, callbacks | Registers commands |
| es:updatePositions | client → server | x, y, z | Stores session coords |
| es:debugMsg | server ↔ server | message | Prints tagged debug output |
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

### ESX Callbacks
None

### Exports
None

### Commands
| Command | Description |
|---------|-------------|
| info | Built-in command reporting Essentialmode version and loaded command count |
| (custom) | External resources register commands via `es:addCommand`, `es:addAdminCommand`, or `es:addGroupCommand` |

### NUI Messages
| Field | Purpose |
|-------|---------|
| setmoney | Replace displayed cash with provided amount |
| addcash | Show temporary green increment |
| removecash | Show temporary red decrement |
| setDisplay | Adjust UI opacity |
| removeStartWindow | Remove initial placeholder element (unused in core script) |

### Database
| Table | Fields Used | Purpose |
|-------|-------------|---------|
| users | identifier, permission_level, money, group | Stores player identity, permissions, and cash |
| bans | banned, expires, reason, timestamp | Tracks banned identifiers |

## Gaps & Inferences
- `__resource.lua` references `client/player.lua` which is missing. *(TODO)*
- `playerConnecting` checks `settings.defaultSettings.banreason` but default key is `banReason` — treated as `banReason`. *(Inferred High)*
- Chat permission failure sends `defaultSettings.permissionDenied`; likely meant `settings.defaultSettings.permissionDenied`. *(Inferred High)*
- In `LoadUser`, `if(true)` before setting decorators likely intended to check `settings.defaultSettings.enableRankDecorators`. *(Inferred High)*
- The second `if(true)` in `LoadUser` probably tests `new` to fire `es:newPlayerLoaded` only for fresh accounts. *(Inferred High)*
- `isLoggedIn` in `login.lua` indexes `Users` by player name and references `isLoggedIn` field that is never set; function appears unused. *(TODO)*
- Server Lua files contain typed variable declarations (e.g., `: double`) causing `luac` parse errors; scripts rely on custom runtime. *(Info)*

DOCS COMPLETE
