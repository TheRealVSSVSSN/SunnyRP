# qb-core Documentation

## Overview
The `qb-core` resource provides the foundational framework for QBCore-based FiveM servers. It manages player data, jobs, gangs, inventory items, vehicles, commands and network events. Both client and server expose shared utilities and callbacks, while an NUI package supplies notification and draw-text interfaces.

## Table of Contents
- [fxmanifest.lua](#fxmanifestlua)
- [config.lua](#configlua)
- [client](#client)
  - [client/main.lua](#clientmainlua)
  - [client/functions.lua](#clientfunctionslua)
  - [client/loops.lua](#clientloopslua)
  - [client/events.lua](#clienteventslua)
  - [client/drawtext.lua](#clientdrawtextlua)
- [server](#server)
  - [server/main.lua](#servermainlua)
  - [server/functions.lua](#serverfunctionslua)
  - [server/player.lua](#serverplayerlua)
  - [server/events.lua](#servereventslua)
  - [server/commands.lua](#servercommandslua)
  - [server/exports.lua](#serverexportslua)
  - [server/debug.lua](#serverdebuglua)
- [shared](#shared)
  - [shared/main.lua](#sharedmainlua)
  - [shared/locale.lua](#sharedlocalelua)
  - [shared/items.lua](#shareditemslua)
  - [shared/jobs.lua](#sharedjobslua)
  - [shared/gangs.lua](#sharedgangslua)
  - [shared/vehicles.lua](#sharedvehicleslua)
  - [shared/weapons.lua](#sharedweaponslua)
  - [shared/locations.lua](#sharedlocationslua)
- [html](#html)
  - [html/index.html](#htmlindexhtml)
  - [html/js/app.js](#htmljsappjs)
  - [html/js/config.js](#htmljsconfigjs)
  - [html/js/drawtext.js](#htmljsdrawtextjs)
  - [html/css/style.css](#htmlcssstylecss)
  - [html/css/drawtext.css](#htmlcssdrawtextcss)
- [locale](#locale)
- [qbcore.sql](#qbcoresql)
- [.github](#github)
- [README.md](#readmemd)
- [LICENSE](#license)
- [agents.md](#agentsmd)
- [Cross-Indexes](#cross-indexes)
  - [Events](#events)
  - [Callbacks](#callbacks)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Channels](#nui-channels)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## fxmanifest.lua
**Role:** Resource manifest declaring runtime information and dependencies.
- Specifies Cerulean FX version and GTA V game target.
- Lists shared, client and server scripts and the HTML UI page.
- Declares `oxmysql` as dependency and includes its library.
- Registers NUI files for notifications and draw-text overlay.

## config.lua
**Role:** Shared configuration values.
- Defines maximum players, default spawn and update intervals for saving and status checks.
- `QBConfig.Money` sets starting balances, minus limits and paycheck timing, optionally pulling salary from `qb-management` society funds.
- `QBConfig.Player.PlayerDefaults` outlines default identity, job, gang, metadata and position for new characters, including functions to generate identifiers.
- `QBConfig.Server` controls whitelist, duplicate license checks, Discord invite, PVP and permission groups.
- `QBConfig.Commands.OOCColor` sets out-of-character chat colour.
- `QBConfig.Notify` describes NUI notification styling and variants (success, primary, warning, error, police, ambulance).

## client
### client/main.lua
**Role:** Initializes the client-side QBCore object and exposes shared data.
- Prepares empty tables for player data, callbacks and config references.
- `GetCoreObject` returns either the entire QBCore object or selected keys.
- Exports accessors for shared items, vehicles, weapons, jobs and gangs.

### client/functions.lua
**Role:** Utility library exported for other resources.
- Callback system: `CreateClientCallback` registers client callbacks and `TriggerCallback` talks to server callbacks.
- Player helpers: `GetPlayerData`, `GetCoords`, `HasItem`, `GetName`, `LookAtEntity`, `PlayAnim`, `IsWearingGloves`.
- NUI helpers: `Notify` pushes structured messages; `Progressbar` delegates to the external `progressbar` resource; `StartParticleAtCoord` / `StartParticleOnEntity` spawn particle effects.
- World helpers: street and zone lookups, cardinal directions, time and ground utilities.
- At load, every function in `QBCore.Functions` is exported for use via `exports['qb-core']:FunctionName`.

### client/loops.lua
**Role:** Background loops.
- Periodically triggers `QBCore:UpdatePlayer` to save player data based on `UpdateInterval`.
- Every `StatusInterval`, reduces health when hunger or thirst reach zero.

### client/events.lua
**Role:** Handles network events and commands.
- Login state: `QBCore:Client:OnPlayerLoaded` sets `isLoggedIn`, enables PVP if configured; `OnPlayerUnload` clears state.
- Server-controlled PVP toggle: `QBCore:Client:PvpHasToggled` applies friendly fire settings.
- Teleport commands: `QBCore:Command:TeleportToPlayer`, `TeleportToCoords`, and `GoToMarker` move the player or show errors via notifications.
- Vehicle control: `QBCore:Command:SpawnVehicle` spawns a vehicle and grants keys (inferred, medium — depends on `vehiclekeys:client:SetOwner`); `DeleteVehicle` removes the current or nearby vehicle.
- Baseevents relay: `QBCore:Client:VehicleInfo` receives vehicle seat events from the server.
- Data maintenance: `QBCore:Player:SetPlayerData` and `UpdatePlayerData` synchronize player data; `QBCore:Notify` displays NUI notifications.
- Deprecated handlers: `QBCore:Client:UseItem` logs potential exploitation (deprecated, do not use).
- Callback plumbing: `QBCore:Client:TriggerClientCallback` and `TriggerCallback` bridge client/server callback responses.
- Chat and shared state: `QBCore:Command:ShowMe3D` renders temporary 3D text; `OnSharedUpdate`, `OnSharedUpdateMultiple`, and `SharedUpdate` sync shared tables.
- NUI configuration: `RegisterNUICallback('getNotifyConfig')` returns notification styling to the UI.

### client/drawtext.lua
**Role:** NUI draw-text interface.
- Local helpers `drawText`, `changeText`, `hideText`, `keyPressed` send messages to the UI.
- Events `qb-core:client:DrawText`, `ChangeText`, `HideText`, `KeyPressed` wrap those helpers.
- Exports corresponding functions for other resources to invoke.

## server
### server/main.lua
**Role:** Server-side QBCore object setup and data exports.
- Similar to client/main.lua, exposes `GetCoreObject` and accessors for shared items, vehicles, weapons, jobs and gangs.

### server/functions.lua
**Role:** Core server utilities and callbacks (all exported).
- Player lookup functions: by source, citizen ID, license, phone number or account; utility `GetPlayers` returns active sources.
- Identifier helpers, bucket management, and offline player retrieval using MySQL queries.
- Callback system: `CreateCallback`, `TriggerClientCallback`, `TriggerCallback` allow asynchronous request/response between client and server.
- Job queries: `GetPlayersByJob` returns list and count for a job or job type, while `GetPlayersOnDuty` and `GetDutyCount` provide on-duty filtering.
- Money and item helpers, vehicle spawning (`SpawnVehicle`, `CreateAutomobile`), and webhook-friendly `Kick`.
- Hunger/thirst saving, job/gang setters, permission checks (`HasPermission`, `IsGod`, `IsOptin`).
- `HasItem` delegates to `qb-inventory` if present; `Notify` sends client notification events.
- Proximity helpers `GetClosestPlayer`, `GetClosestVehicle`, and `GetClosestPed` search nearby players, vehicles, and peds.
- `GetClosestPlayer` and `IsLicenseInUse` now rely on `QBCore.Functions.GetPlayers()` instead of the global `GetPlayers` for consistent player enumeration.
- `PrepForSQL` validates strings against patterns to deter SQL injection.

### server/player.lua
**Role:** Player lifecycle and persistence.
- `QBCore.Player.Login` loads player data from MySQL, decodes JSON fields and validates license; if not found, applies defaults.
- `GetOfflinePlayer`/`GetPlayerByLicense` fetch players from DB for offline operations.
- `CheckPlayerData` applies default fields and metadata and tracks buckets.
- Methods on the Player object handle setting job/gang, money transactions, metadata and item management, and call `Save` to write back using MySQL `INSERT ... ON DUPLICATE KEY UPDATE` queries.
- Emits lifecycle events (`QBCore:Server:PlayerLoaded`, `QBCore:Server:OnPlayerUnload`) and syncs job, gang and money changes via `QBCore:Client:OnJobUpdate`, `QBCore:Client:OnGangUpdate`, `QBCore:Client:OnMoneyChange` and corresponding server events.

### server/events.lua
**Role:** Network event handlers and connection management.
- Suppresses chat messages starting with `/` to route through command system.
- `playerDropped` saves character and logs departure, clearing bucket tracking.
- On resource stop, cleans up registered usable items and skips processing when none exist to prevent errors.
- `playerConnecting` defers connection while checking whitelist, duplicate licenses, database connectivity and bans (MySQL queries).
- `QBCore:Server:CloseServer` / `OpenServer` toggle join access and optionally kick players lacking permissions.
 - Callback relays: `TriggerClientCallback` and `TriggerCallback` implement the client/server callback protocol.
 - `QBCore:UpdatePlayer` reduces hunger/thirst, updates HUD (`hud:client:UpdateNeeds`) and saves data.
 - `QBCore:ToggleDuty` flips job duty status with notifications, firing `QBCore:Client:SetDuty` and server event `QBCore:Server:SetDuty`.
 - Baseevents use `RegisterNetEvent` and mirror vehicle seat changes to clients via `QBCore:Client:VehicleInfo`, issuing `QBCore:Client:AbortVehicleEntering` when entry is cancelled.
 - Deprecated item events (`Server:UseItem`, `RemoveItem`, `AddItem`) only log potential exploitation.
 - `QBCore:CallCommand` executes a command programmatically with permission checks.
 - Callbacks `QBCore:Server:SpawnVehicle` and `QBCore:Server:CreateVehicle` spawn vehicles server-side and return network IDs.

 ### server/commands.lua
**Role:** Command registration and built‑in administrative/user commands.
- `QBCore.Commands.Add` registers commands, sets ACE permissions and supports additional custom permissions per command.
- `Refresh` builds chat suggestions for the invoking player based on ACE privileges.
- Teleportation: `/tp` to players or coordinates, `/tpm` to map marker.
- Server configuration: `/togglepvp`, `/openserver`, `/closeserver`.
- Permission management: `/addpermission`, `/removepermission`.
- Vehicle & entity cleanup: `/car`, `/dv`, `/dvall`, `/dvp` (delete peds), `/dvo` (delete objects).
- Economy: `/givemoney`, `/setmoney` adjust balances.
- Job/gang info and assignment: `/job`, `/setjob`, `/gang`, `/setgang`.
- Chat: `/ooc` for proximity out‑of‑character messages with logging; `/me` displays temporary 3D emotes.

### server/exports.lua
**Role:** Runtime modification of QBCore internals (all functions exported).
- `SetMethod` and `SetField` allow other resources to override QBCore functions or fields, then trigger an update event.
- Job management: `AddJob`, `AddJobs`, `RemoveJob`, `UpdateJob` maintain `QBShared.Jobs` and broadcast changes to clients.
- Item management: `AddItem`, `UpdateItem`, `AddItems`, `RemoveItem` update `QBShared.Items` with client notifications.
- Gang management: `AddGang`, `AddGangs`, `RemoveGang`, `UpdateGang` operate similarly.
- `GetCoreVersion` reports the resource version.
- `ExploitBan` inserts a permanent ban into the database and disconnects the player.

### server/debug.lua
**Role:** Debug and logging utilities.
- `tPrint` recursively prints tables with colour coding.
- Event `QBCore:DebugSomething` (registered via `RegisterNetEvent`) receives data to print; `QBCore.Debug` triggers it with the invoking resource name.
- `ShowError` and `ShowSuccess` output coloured console messages.

## shared
### shared/main.lua
**Role:** Common helper functions and constants.
- Generates random strings or numbers, splits and trims text, capitalises strings and rounds numbers.
- Vehicle extra management (`ChangeVehicleExtra`, `SetDefaultVehicleExtras`).
- Detects if a value is a function (supporting cfx function references).
- Lists male and female clothing indexes considered "no gloves" for fingerprint logic.

### shared/locale.lua
**Role:** Locale management class.
- Provides `Locale` class with methods to extend, replace, clear and delete phrases.
- `t` performs keyed translation with optional substitution table, falling back to configured languages and optionally warning on missing keys.
- `has` checks phrase existence.

### shared/items.lua
**Role:** Item definitions.
- `QBShared.Items` maps item names to metadata including label, weight, type (e.g., weapon), ammo type, image and descriptions.
- Includes extensive weapon listings and can be extended via server exports.

### shared/jobs.lua
**Role:** Job catalogue.
- `QBShared.ForceJobDefaultDutyAtLogin` optionally forces duty state on login.
- `QBShared.Jobs` defines job labels, default duty state, off‑duty pay and grade structure with pay rates and boss flags.

### shared/gangs.lua
**Role:** Gang catalogue.
- `QBShared.Gangs` lists gang names, display labels and rank structures with boss designation.

### shared/vehicles.lua
**Role:** Vehicle definitions.
- Array of vehicle entries with model spawn name, display name, brand, price, category, type and shop availability. Categories align with GTA vehicle classes.

### shared/weapons.lua
**Role:** Weapon metadata.
- `QBShared.Weapons` maps weapon hashes to names, weapon type, ammo type and death reason strings used in logging.

### shared/locations.lua
**Role:** Named coordinate presets.
- `QBShared.Locations` maps human‑readable keys to vector4 coordinates for many GTA interiors, useful for teleport commands.

## html
### html/index.html
**Role:** NUI entry point.
- Loads Google fonts, Quasar and Vue libraries, style sheets and JavaScript modules for notifications and draw-text.
- Contains root div for Quasar app and a container for draw-text overlay.

### html/js/app.js
**Role:** Notification UI script.
- Exposes `fetchNui` helper to call Lua callbacks via HTTP POST.
- Listens for `message` events with action `notify` and displays them via Quasar's `notify` with styling based on `config.js` data.

### html/js/config.js
**Role:** Notification configuration loader.
- Fetches `getNotifyConfig` callback on load to populate `NOTIFY_CONFIG`; falls back to defaults if unavailable.
- `determineStyleFromVariant` resolves styling for a variant.

### html/js/drawtext.js
**Role:** Draw-text UI logic.
- Handles `message` events for `DRAW_TEXT`, `CHANGE_TEXT`, `HIDE_TEXT`, and `KEY_PRESSED` to animate on‑screen prompts.
- Provides helpers to add/remove CSS classes with basic sleep utility.

### html/css/style.css
**Role:** Base styling for notifications.
- Declares typography and colour CSS variables and classes used by Quasar notifications.

### html/css/drawtext.css
**Role:** Styling for draw-text overlay.
- Sets typography and colour variables and positions text on screen for left, top or right placement with transition effects.

## locale
**Role:** Translation phrases.
- Contains multiple language files (`ar.lua`, `de.lua`, `en.lua`, etc.) each defining `Translations` tables grouped by `error`, `success`, `info` and `command` keys for use with `Locale:t`.

## qbcore.sql
**Role:** Database schema.
- `players` table stores character metadata (citizen ID primary key, license, money, job, gang, position, metadata and inventory).
- `bans` table stores ban records by license/discord/IP with expiry.
- `player_contacts` table holds phone contacts per citizen ID.

## .github
**Role:** Repository meta‑configuration.
- `CODE_OF_CONDUCT.md` defines community rules.
- `ISSUE_TEMPLATE` directory supplies bug report and feature request templates and configuration.
- `auto_assign.yml` sets automatic reviewers/assignees.
- `contributing.md` outlines contribution guidelines.
- `pull_request_template.md` provides PR structure.
- Workflow files (`lint.yml`, `semantic-bump-version.yml`, `stale.yml`) run linting, version bumps and stale issue handling on GitHub Actions.

## README.md
Links to official QBCore documentation and states GPL license terms.

## LICENSE
GNU General Public License v3 text covering the framework.

## agents.md
Contains instructions for generating comprehensive documentation; not used at runtime.

## Cross-Indexes
### Events
| Event | File | Direction | Purpose |
|-------|------|-----------|---------|
| `QBCore:Client:OnPlayerLoaded` | client/events.lua | Net | Marks player logged in, enables PVP |
| `QBCore:Client:OnPlayerUnload` | client/events.lua | Net | Clears login state |
| `QBCore:Client:PvpHasToggled` | client/events.lua | Net | Applies server PVP setting |
| `QBCore:Command:TeleportToPlayer` | client/events.lua | Net | Teleport to another player's coordinates |
| `QBCore:Command:TeleportToCoords` | client/events.lua | Net | Teleport to explicit coordinates |
| `QBCore:Command:GoToMarker` | client/events.lua | Net | Teleport to map waypoint |
| `QBCore:Command:SpawnVehicle` | client/events.lua | Net | Spawn vehicle and grant keys (Inferred‑Medium) |
| `QBCore:Command:DeleteVehicle` | client/events.lua | Net | Remove current or nearby vehicle |
| `QBCore:Client:VehicleInfo` | client/events.lua | Net | Receives server vehicle seat info |
| `QBCore:Player:SetPlayerData` | client/events.lua | Net | Replace local player data |
| `QBCore:Player:UpdatePlayerData` | client/events.lua | Net | Request server save |
| `QBCore:Notify` | client/events.lua | Net | Display notification |
| `QBCore:Client:UseItem` | client/events.lua | Net | Deprecated item use event |
| `QBCore:Client:TriggerClientCallback` | client/events.lua | Net | Client callback response handler |
| `QBCore:Client:TriggerCallback` | client/events.lua | Net | Server callback result handler |
| `QBCore:Command:ShowMe3D` | client/events.lua | Net | Display 3D text over player |
| `QBCore:Client:OnSharedUpdate` | client/events.lua | Net | Update single shared entry |
| `QBCore:Client:OnSharedUpdateMultiple` | client/events.lua | Net | Update multiple shared entries |
| `QBCore:Client:SharedUpdate` | client/events.lua | Net | Replace entire shared table |
| `qb-core:client:DrawText` | client/drawtext.lua | Net | Show prompt text |
| `qb-core:client:ChangeText` | client/drawtext.lua | Net | Change prompt text |
| `qb-core:client:HideText` | client/drawtext.lua | Net | Hide prompt |
| `qb-core:client:KeyPressed` | client/drawtext.lua | Net | Flash prompt |
| `QBCore:Server:CloseServer` | server/events.lua | Net | Restrict joins and kick players |
| `QBCore:Server:OpenServer` | server/events.lua | Net | Allow joins |
| `QBCore:Server:TriggerClientCallback` | server/events.lua | Net | Relay client callback result |
| `QBCore:Server:TriggerCallback` | server/events.lua | Net | Invoke server callback |
| `QBCore:UpdatePlayer` | server/events.lua | Net | Reduce hunger/thirst and save |
| `QBCore:ToggleDuty` | server/events.lua | Net | Toggle job duty |
| `baseevents:enteringVehicle` | server/events.lua | Net | Forward entering vehicle info |
| `baseevents:enteredVehicle` | server/events.lua | Net | Forward vehicle entry info |
| `baseevents:enteringAborted` | server/events.lua | Net | Cancel vehicle entering |
| `baseevents:leftVehicle` | server/events.lua | Net | Forward vehicle exit info |
| `QBCore:Server:UseItem` | server/events.lua | Net | Deprecated item use logging |
| `QBCore:Server:RemoveItem` | server/events.lua | Net | Deprecated removal logging |
| `QBCore:Server:AddItem` | server/events.lua | Net | Deprecated addition logging |
| `QBCore:CallCommand` | server/events.lua | Net | Execute command programmatically |
| `QBCore:Client:SetDuty` | server/events.lua | Net | Update duty state on client (Inferred‑Low) |
| `QBCore:Client:AbortVehicleEntering` | server/events.lua | Net | Cancel vehicle entry prompt (Inferred‑Low) |
| `hud:client:UpdateNeeds` | server/events.lua | Net | Refresh hunger/thirst HUD |
| `QBCore:Server:SetDuty` | server/events.lua | Local | Notify server listeners of duty change |
| `QBCore:Server:PlayerDropped` | server/events.lua | Local | Fired when player disconnects |
| `QBCore:Server:PlayerLoaded` | server/player.lua | Local | Fired when player data is ready |
| `QBCore:Server:OnPlayerUnload` | server/player.lua | Local | Notify unload to other resources |
| `QBCore:Server:OnJobUpdate` | server/player.lua | Local | Job changed |
| `QBCore:Client:OnJobUpdate` | server/player.lua | Net | Sync job change to client |
| `QBCore:Server:OnGangUpdate` | server/player.lua | Local | Gang changed |
| `QBCore:Client:OnGangUpdate` | server/player.lua | Net | Sync gang change to client |
| `QBCore:Server:OnMoneyChange` | server/player.lua | Local | Money balance changed |
| `QBCore:Client:OnMoneyChange` | server/player.lua | Net | Update money UI |
| `hud:client:OnMoneyChange` | server/player.lua | Net | Update HUD balance |
| `qb-phone:client:RemoveBankMoney` | server/player.lua | Net | Remove bank money in phone UI |
| `QBCore:DebugSomething` | server/debug.lua | Net | Print structured debug info |

### Callbacks
| Name | Location | Description |
|------|----------|-------------|
| `QBCore:Server:SpawnVehicle` | server/events.lua | Spawns vehicle and returns net ID |
| `QBCore:Server:CreateVehicle` | server/events.lua | Long‑distance vehicle spawn |
| `QBCore.Functions.CreateCallback` | server/functions.lua | Registers server callbacks used with `TriggerCallback` |

### Exports
| Export | File |
|--------|------|
| `GetCoreObject`, `GetSharedItems`, `GetSharedVehicles`, `GetSharedWeapons`, `GetSharedJobs`, `GetSharedGangs` | client/main.lua & server/main.lua |
| All functions under `QBCore.Functions` | client/functions.lua & server/functions.lua |
| `DrawText`, `ChangeText`, `HideText`, `KeyPressed` | client/drawtext.lua |
| `SetMethod`, `SetField`, `AddJob`, `AddJobs`, `RemoveJob`, `UpdateJob`, `AddItem`, `UpdateItem`, `AddItems`, `RemoveItem`, `AddGang`, `AddGangs`, `RemoveGang`, `UpdateGang`, `GetCoreVersion`, `ExploitBan` | server/exports.lua |

### Commands
| Command | Purpose |
|---------|---------|
| `/tp` | Teleport to player, location key or coordinates |
| `/tpm` | Teleport to map marker |
| `/togglepvp` | Toggle global PVP |
| `/addpermission` | Grant player permission level |
| `/removepermission` | Revoke permission level |
| `/openserver` | Reopen server to public |
| `/closeserver` | Close server to non‑whitelisted |
| `/car` | Spawn vehicle by model |
| `/dv` | Delete current/nearest vehicle |
| `/dvall` | Delete all vehicles |
| `/dvp` | Delete all peds |
| `/dvo` | Delete all objects |
| `/givemoney` | Add money of a type to player |
| `/setmoney` | Set player money of a type |
| `/job` | Show own job info |
| `/setjob` | Assign job and grade |
| `/gang` | Show own gang info |
| `/setgang` | Assign gang and grade |
| `/ooc` | Proximity out‑of‑character chat |
| `/me` | Show 3D emote text |

### NUI Channels
| Channel | Type | Description |
|---------|------|-------------|
| `notify` | message event | Displays notification using Quasar |
| `DRAW_TEXT` / `CHANGE_TEXT` / `HIDE_TEXT` / `KEY_PRESSED` | message events | Control draw‑text overlay |
| `getNotifyConfig` | NUI callback | Returns notification configuration to UI |

## Configuration & Integration
- Uses `oxmysql` for database access and requires its library.
- Notifications rely on `progressbar`, `hud`, `qb-vehiclekeys` and `qb-inventory` when those resources are started.
- Paycheck from society accounts requires `qb-management`.
- Commands and events rely on ACE permissions defined in `server.cfg` as `qbcore.<group>`.

## Gaps & Inferences
- **SpawnVehicle keys grant (Inferred‑Medium):** `QBCore:Command:SpawnVehicle` triggers `vehiclekeys:client:SetOwner`; ownership behaviour assumes the `qb-vehiclekeys` resource supplies that event.
- **HUD needs update (Inferred‑Low):** `QBCore:UpdatePlayer` emits `hud:client:UpdateNeeds`; the exact HUD implementation is external.
- Deprecated item events (`QBCore:Client:UseItem`, `QBCore:Server:AddItem`, etc.) log usage but should be replaced with inventory functions for security.
- **Duty & vehicle abort events (Inferred‑Low):** `QBCore:Client:SetDuty` and `QBCore:Client:AbortVehicleEntering` are triggered but have no handlers in this resource, implying external consumers.
- **Job/Gang/Money sync (Inferred‑Medium):** `QBCore:Client:OnJobUpdate`, `QBCore:Client:OnGangUpdate` and `QBCore:Client:OnMoneyChange` are fired from the server yet lack local listeners, suggesting other resources update UI and state.

DOCS COMPLETE
