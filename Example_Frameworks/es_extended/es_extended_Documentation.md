# es_extended Documentation

## Overview
`es_extended` is the core of the ESX Legacy framework. It manages player data, inventory, jobs, accounts and exposes APIs used by other resources. Logic is split between client scripts, server scripts, shared utilities, a NUI interface, and locale files.

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
Introduction to ESX Legacy, its purpose, and references to companion resources such as `esx_identity`, `esx_society`, and `esx_billing`.

### LICENSE
GPL license granting rights to redistribute and modify the project.

### agents.md
Instructions for generating comprehensive documentation for the resource.

### fxmanifest.lua
Resource manifest defining shared, client, and server scripts; NUI files; exports for `getSharedObject`; and dependencies on `mysql-async`, `async`, and `spawnmanager`.

### config.lua
Global configuration:
- Locale selection and account labels.
- Gameplay toggles for HUD display, PvP, identity and multicharacter support.
- Inventory weight limit and paycheck interval.

### config.weapons.lua
Large table describing every weapon: label, components, available tints, and default tint names used by weapon APIs.

### es_extended.sql
Database schema creating `users`, `items`, `jobs`, and `job_grades` tables with default entries and field defaults.

### imports.lua
Exports the ESX shared object. On the client it listens for `esx:setPlayerData` to update cached player data when the event originates from this resource.

### locale.lua
Lua helpers `_` and `_U` resolve translated strings based on `Config.Locale`, returning placeholders when a key or locale is missing.

### locale.js
JavaScript translation utilities mirroring the Lua helpers. `_U` fetches and optionally formats strings from the loaded locale data and capitalizes the first letter.

### version.json
Metadata describing the legacy version and commit hash.

## Client Scripts
### client/common.lua
Shares the ESX object with other client resources through the `esx:getSharedObject` event and a `getSharedObject` function.

### client/entityiter.lua
Provides entity enumeration helpers. `EnumerateEntities` yields entities using native find functions, while `EnumerateEntitiesWithinDistance` filters entities within a specified range. Convenience wrappers enumerate objects, peds, vehicles, and pickups.

### client/functions.lua
Defines the global `ESX` client API:
- Data and timeout management (`SetTimeout`, `ClearTimeout`, `SetPlayerData`).
- Notification helpers (`ShowNotification`, `ShowAdvancedNotification`, `ShowHelpNotification`, `ShowFloatingHelpNotification`).
- RPC via `TriggerServerCallback` with response handling through `esx:serverCallback`.
- HUD management (`ESX.UI.HUD` functions to register, update, delete, and reset elements).
- Game utilities (`ESX.Game`): teleporting entities, spawning or deleting vehicles and objects, enumeration helpers, vehicle property getters/setters, and 3D text drawing.
- Event handlers for server callbacks and display events: `esx:serverCallback`, `esx:showNotification`, `esx:showAdvancedNotification`, and `esx:showHelpNotification`.

### client/main.lua
Player lifecycle controller:
- On join, disables auto-spawn and requests initialization from the server.
- Handles `esx:playerLoaded` to spawn the player, enable HUD elements, restore loadout, and start sync loops that periodically update coordinates and weapon ammo.
- Responds to events altering player state: logout (`esx:onPlayerLogout`), inventory (`esx:addInventoryItem`, `esx:removeInventoryItem`), accounts (`esx:setAccountMoney`), weapons (`esx:addWeapon`, `esx:setWeaponAmmo`, `esx:removeWeapon`, etc.), job changes (`esx:setJob`), teleports (`esx:teleport`), vehicle spawning/deletion, pickup creation, chat suggestions, and admin utilities (`esx:tpm`, `esx:noclip`, `esx:killPlayer`, `esx:freezePlayer`).

### client/wrapper.lua
Reassembles chunked NUI messages. When `__chunk` callbacks complete, it decodes the accumulated data and emits `<resource>:message:<type>` events.

### client/modules/death.lua
Monitors player death. When the player dies, gathers killer information and distance, then triggers `esx:onPlayerDeath` locally and on the server. Resets state on respawn.

### client/modules/scaleform.lua
Convenience wrappers for displaying scaleform movies: freemode messages, breaking news tickers, popup warnings, and traffic camera clips. A utility function requests and caches scaleform movies.

### client/modules/streaming.lua
Asset loading helpers ensuring models, textures, particle assets, animation sets/dicts, and weapon assets are requested and loaded before invoking callbacks.

## Server Scripts
### server/common.lua
Initializes the server-side ESX object. On database readiness it loads item and job data, prints status, and starts periodic player saving (`StartDBSync`) and paychecks (`StartPayCheck`). Provides events `esx:clientLog` for debug traces and `esx:triggerServerCallback` to dispatch registered server callbacks.

### server/functions.lua
Core server utilities:
- Debug tracing and timeout scheduling.
- `ESX.RegisterCommand` with argument validation, chat suggestions, and ACE permission setup.
- RPC registration (`RegisterServerCallback`) and invocation (`TriggerServerCallback`).
- Persistence helpers `SavePlayer` and `SavePlayers` using prepared statements.
- Player lookup (`GetPlayers`, `GetExtendedPlayers`, `GetPlayerFromId`, `GetPlayerFromIdentifier`, `GetIdentifier`).
- Item and weapon helpers (`RegisterUsableItem`, `UseItem`, `GetItemLabel`, `CreatePickup`).
- Employment check `DoesJobExist`.

### server/main.lua
Manages connection flow and gameplay events:
- Sets map/game type on startup and prepares SQL statements for player creation and loading.
- Handles player join via `esx:onPlayerJoined` or `playerConnecting`, creating or loading accounts (`createESXPlayer`, `loadESXPlayer`).
- Cleans up on `playerDropped` and `esx:playerLogout` while saving data.
- Updates server state on `esx:updateCoords` and `esx:updateWeaponAmmo`.
- Item interactions: `esx:giveInventoryItem`, `esx:removeInventoryItem`, `esx:useItem`, `esx:onPickup`.
- Provides callbacks `esx:getPlayerData`, `esx:getOtherPlayerData`, and `esx:getPlayerNames`.
- Saves all players shortly before a scheduled txAdmin restart.

### server/paycheck.lua
`StartPayCheck` credits salaries at `Config.PaycheckInterval`. It can deduct funds from society accounts when configured and sends HUD notifications to players.

### server/commands.lua
Registers administrative and utility commands through `ESX.RegisterCommand`, including:
- Teleport and job tools (`setcoords`, `setjob`, `car`, `cardel/dv`).
- Economy controls (`setaccountmoney`, `giveaccountmoney`, `giveitem`, `giveweapon`, `giveweaponcomponent`).
- Chat and data management (`clear`, `clearall`, `clearinventory`, `clearloadout`, `setgroup`, `save`, `saveall`).
- Player info utilities (`group`, `job`, `info`, `coords`, `tpm`, `goto`, `bring`, `kill`, `freeze`, `unfreeze`, `reviveall`, `noclip`, `players`).
Each command validates arguments and invokes the relevant player methods or events.

### server/classes/player.lua
Defines the extended player object instantiated for each connection. Major method groups:
- **Core**: `triggerEvent`, `setCoords`, `updateCoords`, `getCoords`, `kick`.
- **Accounts**: `setMoney`, `addMoney`, `removeMoney`, `setAccountMoney`, `addAccountMoney`, `removeAccountMoney`, `getAccounts`, `getAccount`; these fire events like `esx:setAccountMoney`.
- **Inventory**: `getInventory`, `getInventoryItem`, `addInventoryItem`, `removeInventoryItem`, `setInventoryItem`, weight checks (`getWeight`, `getMaxWeight`, `canCarryItem`, `canSwapItem`, `setMaxWeight`).
- **Jobs and groups**: `setJob`, `getJob`, `setGroup`, `getGroup` with ACE permission bindings.
- **Weapons**: `addWeapon`, `addWeaponComponent`, `addWeaponAmmo`, `updateWeaponAmmo`, `setWeaponTint`, `getWeaponTint`, `removeWeapon`, `removeWeaponComponent`, `removeWeaponAmmo`, `hasWeaponComponent`, `hasWeapon`, `getWeapon`.
- **Messaging**: `showNotification` and `showHelpNotification` to push client prompts.
Most mutators trigger matching client events so the HUD and inventory stay in sync.

## Shared Modules
### common/functions.lua
Utility functions shared across client and server:
- Random string generation (`GetRandomString`).
- Configuration and weapon accessors (`GetConfig`, `GetWeapon`, `GetWeaponFromHash`, `GetWeaponList`, `GetWeaponLabel`, `GetWeaponComponent`).
- Debug table dump (`DumpTable`) and rounding proxy (`Round`).

### common/modules/math.lua
Math helpers including `Round`, digit grouping (`GroupDigits`) that respects locale symbols, and whitespace trimming (`Trim`).

### common/modules/table.lua
Table helpers: size calculation, set conversion, search (`IndexOf`, `LastIndexOf`, `Find`, `FindIndex`), filter/map/clone utilities, concatenation (`Concat`), joining (`Join`), reversing (`Reverse`), deep cloning, and key-sorted iteration with `Sort`.

## UI and Assets
### html/ui.html
NUI entry point embedding HUD and inventory notification containers, loading styles and scripts.

### html/css/app.css
Defines fonts, layout, colors, and animations for HUD widgets and inventory notifications.

### html/js/app.js
Client-side HUD controller that registers, updates, and deletes elements, shows inventory notifications, and routes messages from Lua via the `onData` listener.

### html/js/wrapper.js
Breaks large JSON messages into fixed-size chunks and posts them back to Lua through `SendMessage`.

### html/js/mustache.min.js
Minified Mustache templating engine used to render HUD elements.

### html/fonts/pdown.ttf
### html/fonts/bankgothic.ttf
Custom fonts referenced by the UI stylesheet.

### html/img/accounts/bank.png
### html/img/accounts/black_money.png
### html/img/accounts/money.png
Icons displayed next to bank, illicit, and cash balances on the HUD.

## Locale Files
Each file registers translations for notifications, commands, weapons, and UI text in a specific language. Scripts select a locale via `Config.Locale`.

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
- `config.weapons.lua` defines extensive weapon and component data not individually described here; consult the file for the full list.
- External dependencies such as `esx_society`, `skinchanger`, and others provide events referenced in this resource but are documented elsewhere.
- `server/commands.lua` contains many administrative commands; while major categories are summarized, individual argument details may require reviewing the source.

## Conclusion
`es_extended` supplies the foundational systems for SunnyRP’s ESX-based gameplay. Server scripts manage persistence, commands, and player state; client scripts provide interaction and HUD logic; shared modules offer utilities; UI assets display information; and locale files enable multilingual support.
