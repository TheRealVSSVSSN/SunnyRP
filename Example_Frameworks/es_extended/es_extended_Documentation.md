# es_extended Documentation

## Overview
`es_extended` provides the core systems of the ESX Legacy framework for SunnyRP. It manages player data, inventories, jobs, accounts, and exposes APIs consumed by other resources. Logic is divided into client scripts, server scripts, shared utilities, UI assets, and locale files.

## Table of Contents
- [Top-Level Files](#top-level-files)
  - [README.md](#readmemd)
  - [LICENSE](#license)
  - [agents.md](#agentsmd)
  - [fxmanifest.lua](#fxmanifestlua)
  - [config.lua](#configlua)
  - [config.weapons.lua](#configweaponslua)
  - [es_extended.sql](#es_extendedsql)
  - [imports.lua](#importslua)
  - [locale.lua](#localelua)
  - [locale.js](#localejs)
  - [version.json](#versionjson)
- [Client Scripts](#client-scripts)
  - [client/common.lua](#clientcommonlua)
  - [client/entityiter.lua](#cliententityiterlua)
  - [client/functions.lua](#clientfunctionslua)
  - [client/main.lua](#clientmainlua)
  - [client/wrapper.lua](#clientwrapperlua)
  - [client/modules/death.lua](#clientmodulesdeathlua)
  - [client/modules/scaleform.lua](#clientmodulesscaleformlua)
  - [client/modules/streaming.lua](#clientmodulesstreaminglua)
- [Server Scripts](#server-scripts)
  - [server/common.lua](#servercommonlua)
  - [server/functions.lua](#serverfunctionslua)
  - [server/main.lua](#servermainlua)
  - [server/paycheck.lua](#serverpaychecklua)
  - [server/commands.lua](#servercommandslua)
  - [server/classes/player.lua](#serverclassesplayerlua)
- [Shared Modules](#shared-modules)
  - [common/functions.lua](#commonfunctionslua)
  - [common/modules/math.lua](#commonmodulesmathlua)
  - [common/modules/table.lua](#commonmodulestablelua)
- [UI and Assets](#ui-and-assets)
  - [html/ui.html](#htmluihtml)
  - [html/css/app.css](#htmlcssappcss)
  - [html/js/app.js](#htmljsappjs)
  - [html/js/wrapper.js](#htmljswrapperjs)
  - [html/js/mustache.min.js](#htmljsmustacheminjs)
  - [html/fonts/pdown.ttf](#htmlfontspdownttf)
  - [html/fonts/bankgothic.ttf](#htmlfontsbankgothicttf)
  - [html/img/accounts/bank.png](#htmlimgaccountsbankpng)
  - [html/img/accounts/black_money.png](#htmlimgaccountsblack_moneypng)
  - [html/img/accounts/money.png](#htmlimgaccountsmoneypng)
- [Locale Files](#locale-files)
  - [locales/br.lua](#localesbrlua)
  - [locales/cs.lua](#localescslua)
  - [locales/de.lua](#localesdelua)
  - [locales/en.lua](#localesenlua)
  - [locales/es.lua](#localeseslua)
  - [locales/fi.lua](#localesfilua)
  - [locales/fr.lua](#localesfrlua)
  - [locales/pl.lua](#localespllua)
  - [locales/sc.lua](#localessclua)
  - [locales/sv.lua](#localeslvlua)
  - [locales/tc.lua](#localestclua)
- [Documentation Gaps](#documentation-gaps)
- [Conclusion](#conclusion)

## Top-Level Files
### README.md
Introduces ESX Legacy and references related resources such as identity or society modules.

### LICENSE
GPL license granting rights to redistribute and modify the resource.

### agents.md
Instructions directing contributors to generate comprehensive documentation for this resource.

### fxmanifest.lua
Resource manifest declaring:
- Shared scripts (locale handlers, configuration files).
- Server scripts including database loader, player class, command handlers, and shared modules.
- Client scripts like HUD/UI managers, NUI wrapper, and streaming utilities.
- UI files and exported `getSharedObject` function for both client and server.
- Dependencies on `mysql-async`, `async`, and `spawnmanager`.

### config.lua
Central configuration toggles:
- Locale selection and account labels.
- Initial bankroll per account.
- Feature switches (society payouts, HUD, default inventory, wanted level, PVP).
- Gameplay limits such as inventory weight and paycheck interval.
- Multicharacter and identity flags that alter player loading logic.

### config.weapons.lua
Large table of weapon definitions. Each entry lists label, available components, supported tint options, and default tint names. Used by weapon handling APIs and UI labels.

### es_extended.sql
Database schema establishing persistent storage:
- `users` table for player state, accounts, job, inventory, loadout, and coordinates.
- `items` table describing weight and rarity of inventory items.
- `job_grades` and `jobs` tables with default unemployed entries.

### imports.lua
Exports the ESX shared object for other resources. On the client it listens for `esx:setPlayerData` events and updates cached fields when they originate from this resource.

### locale.lua
Provides translation helpers `_` and `_U` to resolve locale strings based on `Config.Locale` and capitalize them when needed.

### locale.js
Browser-side translation utilities mirroring the Lua helpers. It exposes `_U` to fetch or format strings inside NUI pages and includes string formatting and capitalization helpers.

### version.json
Metadata identifying the legacy version and commit hash.

## Client Scripts
### client/common.lua
- Registers the `esx:getSharedObject` event to supply the global `ESX` table to other client resources.
- Exposes `getSharedObject()` as an export for direct access.

### client/entityiter.lua
- Implements coroutine-based enumerators for objects, peds, vehicles, and pickups via native find functions.
- `EnumerateEntitiesWithinDistance` filters entities near a position; used by higher-level helpers in `ESX.Game`.

### client/functions.lua
Defines the bulk of the client API and event handlers:
- **Timeouts**: `ESX.SetTimeout` and `ESX.ClearTimeout` manage delayed callbacks using the game timer.
- **Data Access**: `IsPlayerLoaded`, `GetPlayerData`, and `SetPlayerData` emit `esx:setPlayerData` when fields change.
- **Notifications**: functions to show standard, advanced, help, and floating help notifications.
- **Server Callbacks**: `TriggerServerCallback` sends `esx:triggerServerCallback` and awaits `esx:serverCallback` responses.
- **HUD Management**: `ESX.UI.HUD` functions register, remove, reset, and update HUD elements through NUI messages.
- **Menu System**: `ESX.UI.Menu` registers menu types and provides open, close, update, and query helpers for interactive menus.
- **Game Utilities** (`ESX.Game`): teleport entities, spawn or delete objects/vehicles, enumerate nearby entities, draw 3D text, and derive vehicle properties (mods, colors, extras, etc.).
- **Player Interactions**: opens the inventory interface, manages weapon tint/components, and draws notifications when items are added or removed.
- **Event Handlers**: reacts to `esx:serverCallback`, `esx:setAccountMoney`, `esx:addInventoryItem`, `esx:removeInventoryItem`, `esx:useItem`, `esx:onPickup`, `esx:onPlayerDeath`, and scheduled restart events to keep the client state synchronized.

### client/main.lua
Manages player lifecycle on the client:
- On startup disables auto-spawn and requests the server to run `esx:onPlayerJoined`.
- Handles `esx:playerLoaded` to spawn the player, load skin, enable PVP, initialize HUD, and start periodic sync loops.
- Responds to logout and death events to update internal state and HUD.
- Exposes player data to other scripts and synchronizes weapons, accounts, and inventory through events like `esx:setAccountMoney`, `esx:addInventoryItem`, `esx:removeInventoryItem`, `esx:restoreLoadout`, and `esx:setMaxWeight`.

### client/wrapper.lua
Receives chunked NUI messages via `__chunk`, reconstructs the original JSON payload, and triggers resource-specific events named `resource:message:type` once the final chunk arrives.

### client/modules/death.lua
Continuously monitors the player ped for fatal injuries. When death occurs:
- Determines killer information and distance if killed by another player.
- Triggers local and server events `esx:onPlayerDeath` with contextual data.

### client/modules/scaleform.lua
Utility for displaying Rockstar scaleform movies:
- `ShowFreemodeMessage`, `ShowBreakingNews`, `ShowPopupWarning`, and `ShowTrafficMovie` request the appropriate movie and draw it for the specified duration.

### client/modules/streaming.lua
Provides helpers to load assets on demand:
- `RequestModel`, `RequestStreamedTextureDict`, `RequestNamedPtfxAsset`, `RequestAnimSet`, `RequestAnimDict`, and `RequestWeaponAsset` wrap native requests and invoke an optional callback once the asset is loaded.

## Server Scripts
### server/common.lua
Initializes the server-side `ESX` object:
- Populates item and job definitions from the database when MySQL is ready.
- Starts periodic database synchronization and paychecks (`StartDBSync`, `StartPayCheck`).
- Registers `esx:getSharedObject`, `esx:clientLog`, and `esx:triggerServerCallback` events so other resources can access ESX, log debug messages, or request callbacks.

### server/functions.lua
Server utilities and persistence:
- Logging via `ESX.Trace` and timeout helpers `SetTimeout`/`ClearTimeout`.
- `ESX.RegisterCommand` creates administrative and gameplay commands with ACE-based permissions and optional chat suggestions.
- Callback framework: `RegisterServerCallback` and `TriggerServerCallback` allow RPC-style server/client communication.
- Persistence routines: `SavePlayer` and `SavePlayers` serialize player accounts, job, inventory, loadout, and coordinates to the database.
- Player management helpers (`GetPlayers`, `GetExtendedPlayers`, `GetPlayerFromId`, `GetIdentifier`, etc.).
- Item interfaces: registering usable items, creating world pickups, verifying jobs, and retrieving item labels.

### server/main.lua
Core player connect/disconnect flow:
- Prepares SQL statements for inserting or loading users and sets map metadata on resource start.
- Handles `playerConnecting` to guard against duplicate identifiers.
- Functions `onPlayerJoined`, `createESXPlayer`, and `loadESXPlayer` insert new records or retrieve existing data, assemble accounts/inventory/loadout, and instantiate `ExtendedPlayer` objects.
- Emits `esx:playerLoaded` to both server and client, registers command suggestions, and logs connections.
- On `playerDropped` or `esx:playerLogout`, triggers `esx:playerDropped`, saves character data, and cleans up cached players.
- Sync events: `esx:updateCoords` and `esx:updateWeaponAmmo` update stored data; `esx:giveInventoryItem`, `esx:useItem`, and `esx:onPickup` handle item transfer and pickups between players.
- Server callbacks `esx:getPlayerData`, `esx:getOtherPlayerData`, and `esx:getPlayerNames` expose player information to clients.
- Responds to `txAdmin` restart warnings by saving all players 10 seconds before restart.

### server/paycheck.lua
`StartPayCheck` thread runs at `Config.PaycheckInterval` to credit salaries:
- Deposits payment into player bank accounts.
- Optionally deducts funds from society accounts when `Config.EnableSocietyPayouts` is enabled.
- Sends HUD notifications using the bank icon.

### server/commands.lua
Registers administrative and utility commands via `ESX.RegisterCommand`. Categories include:
- **Teleport/Job Tools:** `setcoords`, `setjob`, `car`, `cardel`/`dv`, `tpm`, `goto`, `bring`.
- **Economy Controls:** `setaccountmoney`, `giveaccountmoney`, `giveitem`, `giveweapon`, `giveweaponcomponent`.
- **Player Management:** `clear`, `clearall`, `clearinventory`, `clearloadout`, `setgroup`, `save`, `saveall`, `kill`, `freeze`, `unfreeze`, `reviveall`, `noclip`.
- **Information:** `group`, `job`, `info`, `coords`, `players`.
Each command validates inputs, checks permissions, and triggers the appropriate player methods or notifications.

### server/classes/player.lua
Defines the `ExtendedPlayer` class representing connected players. Major method groups include:
- **Core:** event triggering, coordinate management, kicking, and ACE group synchronization.
- **Accounts:** balance getters/setters for cash and custom accounts; fires `esx:setAccountMoney` when balances change.
- **Inventory:** item getters/setters, add/remove operations, weight calculations, and capacity checks.
- **Jobs & Groups:** assigns jobs or groups and binds ACE permissions accordingly.
- **Weapons:** add/remove weapons, ammo, components, and tint management with server-to-client sync (`esx:setWeaponTint`, `esx:updateWeaponAmmo`).
- **Messaging:** `showNotification` and `showHelpNotification` send HUD prompts to the client.

## Shared Modules
### common/functions.lua
Cross-environment utilities:
- Random string generation.
- Accessors for configuration and weapon metadata (`GetConfig`, `GetWeapon`, `GetWeaponLabel`, `GetWeaponComponent`, etc.).
- Debug table dumping and rounding helpers.

### common/modules/math.lua
Math helpers such as rounding, digit grouping respecting locale separators, and string trimming.

### common/modules/table.lua
Table utilities used across client and server: size calculation, set conversion, search helpers (`IndexOf`, `Find`), mapping/filtering, cloning, concatenation, joining, reversing, deep copying, and key-sorted iteration.

## UI and Assets
### html/ui.html
NUI entry point that loads CSS and JavaScript, defines HUD containers, and hosts inventory notifications.

### html/css/app.css
Stylesheet controlling fonts, layout, colors, and animations for HUD elements and notifications.

### html/js/app.js
Browser-side controller:
- Registers, updates, and removes HUD elements via messages from Lua.
- Displays inventory notifications and processes incoming NUI messages in `onData`.

### html/js/wrapper.js
Splits large JSON messages into fixed-size chunks and posts them to Lua via `SendMessage`, enabling transmission of large payloads.

### html/js/mustache.min.js
Minified Mustache templating library used to render HUD templates.

### html/fonts/pdown.ttf
### html/fonts/bankgothic.ttf
Custom fonts referenced by the stylesheet.

### html/img/accounts/bank.png
### html/img/accounts/black_money.png
### html/img/accounts/money.png
Account icons displayed next to bank, illicit, and cash balances on the HUD.

## Locale Files
Each file registers translations for notifications, commands, weapons, and UI text in the respective language. Scripts select one via `Config.Locale`.

### locales/br.lua
Brazilian Portuguese translations.

### locales/cs.lua
Czech translations.

### locales/de.lua
German translations.

### locales/en.lua
English translations.

### locales/es.lua
Spanish translations.

### locales/fi.lua
Finnish translations.

### locales/fr.lua
French translations.

### locales/pl.lua
Polish translations.

### locales/sc.lua
Simplified Chinese translations.

### locales/sv.lua
Swedish translations.

### locales/tc.lua
Traditional Chinese translations.

## Documentation Gaps
- `config.weapons.lua` contains an extensive list of weapons and components; individual weapon attributes are not detailed here.
- `client/functions.lua` and `server/functions.lua` expose numerous utility methods and events; only major categories are summarized.
- `server/commands.lua` lists many commands; argument specifics and edge-case behaviors require reading the source.
- External dependencies such as `esx_society` and `skinchanger` provide events referenced in this resource but are documented elsewhere.

## Conclusion
`es_extended` supplies the foundational systems for SunnyRP's ESX-based gameplay. Server scripts manage persistence, commands, and player state; client scripts handle interface and gameplay logic; shared modules offer utilities; UI assets display information; and locale files enable multilingual support.
