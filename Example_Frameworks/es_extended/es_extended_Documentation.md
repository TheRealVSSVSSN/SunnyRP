# es_extended Documentation

## Overview
ESX Legacy's `es_extended` resource provides the foundation for economy-based roleplay. It handles player data, inventory, jobs, accounts, and persistence while exposing utility APIs for other resources. Logic is split into client, server, shared modules, and a small NUI.

## Table of Contents
- [Top-level Files](#top-level-files)
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
- [Shared Utilities](#shared-utilities)
  - [common/functions.lua](#commonfunctionslua)
  - [common/modules/math.lua](#commonmodulesmathlua)
  - [common/modules/table.lua](#commonmodulestablelua)
- [UI and Assets](#ui-and-assets)
  - [html/ui.html](#htmluihtml)
  - [html/js/app.js](#htmljsappjs)
  - [html/js/wrapper.js](#htmljswrapperjs)
  - [html/js/mustache.min.js](#htmljsmustacheminjs)
  - [html/css/app.css](#htmlcssappcss)
  - [html/fonts/pdown.ttf](#htmlfontspdownttf)
  - [html/fonts/bankgothic.ttf](#htmlfontsbankgothictff)
  - [html/img/accounts/bank.png](#htmlimgaccountsbankpng)
  - [html/img/accounts/black_money.png](#htmlimgaccountsblack_moneypng)
  - [html/img/accounts/money.png](#htmlimgaccountsmoneypng)
- [Locales](#locales)
  - [locales/br.lua](#localesbrlua)
  - [locales/cs.lua](#localescslua)
  - [locales/de.lua](#localesdelua)
  - [locales/en.lua](#localesenlua)
  - [locales/es.lua](#localeseslua)
  - [locales/fi.lua](#localesfilua)
  - [locales/fr.lua](#localesfrlua)
  - [locales/pl.lua](#localespllua)
  - [locales/sc.lua](#localesclua)
  - [locales/sv.lua](#localesvlua)
  - [locales/tc.lua](#localestclua)

## Top-level Files
### README.md
Introduces the ESX framework, summarises features, optimisation notes, and references to complementary resources.

### LICENSE
Distributes the resource under the GNU General Public License v3.

### agents.md
Instructions for generating documentation for files inside this resource.

### fxmanifest.lua
Resource manifest declaring scripts, assets, exports, and dependencies. It registers `getSharedObject` as a shared and server export so other resources can obtain the ESX interface.

### config.lua
Defines global options:
- Account labels and starting balances.
- Toggles for society payouts, HUD display, inventory limits, paycheck frequency, debug mode, inventory UI, wanted level, and PVP.
- Support for multicharacter and identity modules.

### config.weapons.lua
Lists every weapon with label, ammo configuration, tint options, and component metadata used by weapon APIs.

### es_extended.sql
SQL schema creating `users`, `items`, `jobs`, and `job_grades` tables and seeding an unemployed job grade.

### imports.lua
Provides a one-line method for other resources to fetch ESX via `exports['es_extended']:getSharedObject()` and, on clients, listens for `esx:setPlayerData` to keep `ESX.PlayerData` up to date.

### locale.lua
Defines `_` and `_U` functions that return translated strings based on `Config.Locale`.

### locale.js
Browser-side translation helper mirroring Lua’s `_U` behaviour with formatting and capitalization utilities.

### version.json
Holds version metadata (current legacy tag, commit identifier, and changelog snippet).

## Client Scripts
### client/common.lua
- Event **`esx:getSharedObject`** returns the ESX object.
- Function **`getSharedObject()`** exposes the same reference for direct calls.

### client/entityiter.lua
- Implements a coroutine-based **`EnumerateEntities`** factory and helpers for objects, peds, vehicles, and pickups.
- **`EnumerateEntitiesWithinDistance`** filters entities by range for proximity searches.

### client/functions.lua
Provides the bulk of the client API:
- **State and timing**: `ESX.SetTimeout`/`ClearTimeout`, `IsPlayerLoaded`, `GetPlayerData`, `SetPlayerData` (fires `esx:setPlayerData`).
- **Notifications**: `ShowNotification`, `ShowAdvancedNotification`, `ShowHelpNotification`, `ShowFloatingHelpNotification`.
- **Server callbacks**: `TriggerServerCallback` invokes `esx:triggerServerCallback` and stores replies by request id.
- **HUD management**: `ESX.UI.HUD` functions to register, update, remove, and reset HUD elements.
- **Menu system**: `ESX.UI.Menu` registration plus open, update, close, and query helpers.
- **Inventory alerts**: `ESX.UI.ShowInventoryItemNotification` displays gain/loss messages.
- **Game helpers**: `ESX.Game` namespace supplies utilities for teleporting, spawning or deleting entities, enumerating world entities, range checks, vehicle property setters, and drawing 3D text.
- **Inventory UI**: `ESX.ShowInventory()` builds and displays an inventory menu using player data.

### client/main.lua
Handles player lifecycle and admin features:
- On start, disables auto-spawn and triggers **`esx:onPlayerJoined`**.
- Event **`esx:playerLoaded`** spawns the player, restores loadout, enables HUD, and starts sync loops.
- Tracks logout (**`esx:onPlayerLogout`**), weight updates (**`esx:setMaxWeight`**), spawn/death (**`esx:onPlayerSpawn`**, **`esx:onPlayerDeath`**), model loads (**`skinchanger:modelLoaded`**), and loadout restoration (**`esx:restoreLoadout`**).
- Inventory and weapon events: **`esx:setAccountMoney`**, **`esx:addInventoryItem`**, **`esx:removeInventoryItem`**, **`esx:addWeapon`**, **`esx:addWeaponComponent`**, **`esx:setWeaponAmmo`**, **`esx:setWeaponTint`**, **`esx:removeWeapon`**, **`esx:removeWeaponComponent`**.
- Utility events: **`esx:teleport`**, **`esx:setJob`**, **`esx:spawnVehicle`**, **`esx:createPickup`**, **`esx:createMissingPickups`**, **`esx:registerSuggestions`**, **`esx:removePickup`**, **`esx:deleteVehicle`**.
- `StartServerSyncLoops()` monitors ammo usage and reports it to the server via **`esx:updateWeaponAmmo`**.
- Hides the HUD while the pause menu is open.

### client/wrapper.lua
Reassembles chunked NUI messages:
- NUI callback **`__chunk`** concatenates message pieces and, when complete, emits `<resource>:message:<type>` events.

### client/modules/death.lua
- Thread monitors player fatal state and emits **`esx:onPlayerDeath`** locally and to the server with killer data when applicable.
- Functions **`PlayerKilledByPlayer`** and **`PlayerKilled`** collect context (positions, cause, distance) before firing events.

### client/modules/scaleform.lua
Wraps common scaleform movies:
- `ShowFreemodeMessage`, `ShowBreakingNews`, `ShowPopupWarning`, and `ShowTrafficMovie` display themed full-screen messages for a duration.
- `ESX.Scaleform.Utils.RequestScaleformMovie` loads a scaleform before use.

### client/modules/streaming.lua
Asset request helpers that load models, textures, particle FX, animation sets/dicts, and weapon assets before invoking an optional callback.

## Server Scripts
### server/common.lua
Initialises server-side ESX state:
- Event **`esx:getSharedObject`** exposes the ESX table.
- On database ready, loads items and jobs, prints status, starts periodic player saving (**`StartDBSync`**) and paychecks (**`StartPayCheck`**).
- Event **`esx:clientLog`** prints debug traces when enabled.
- Event **`esx:triggerServerCallback`** dispatches registered server callbacks and returns results to clients.

### server/functions.lua
Server utility layer:
- Logging via `ESX.Trace`.
- Timers with `ESX.SetTimeout`/`ClearTimeout`.
- Command registration through `ESX.RegisterCommand`, including argument validation and chat suggestions.
- Server callback registry (`RegisterServerCallback`, `TriggerServerCallback`).
- Persistence helpers `ESX.SavePlayer` and `ESX.SavePlayers` using prepared statements.
- Player lookup helpers (`GetPlayers`, `GetExtendedPlayers`, `GetPlayerFromId`, `GetPlayerFromIdentifier`, `GetIdentifier`).
- Item/weapon utilities (`RegisterUsableItem`, `UseItem`, `GetItemLabel`, `CreatePickup`).
- Employment check `DoesJobExist`.

### server/main.lua
Manages connection flow and gameplay events:
- Sets map/game type on startup and prepares SQL statements.
- Handles player join via **`esx:onPlayerJoined`** (multichar) or `playerConnecting`, creating or loading accounts (`createESXPlayer`, `loadESXPlayer`).
- Cleans up on **`playerDropped`** and **`esx:playerLogout`** while saving data.
- Updates server-side state on **`esx:updateCoords`** and **`esx:updateWeaponAmmo`**.
- Item interactions: **`esx:giveInventoryItem`**, **`esx:removeInventoryItem`**, **`esx:useItem`**, **`esx:onPickup`**.
- Server callbacks exposed: **`esx:getPlayerData`**, **`esx:getOtherPlayerData`**, **`esx:getPlayerNames`**.
- Saves all players 50 seconds before a scheduled txAdmin restart (**`txAdmin:events:scheduledRestart`**).

### server/paycheck.lua
Function **`StartPayCheck`** credits salaries at `Config.PaycheckInterval`, optionally deducting from society accounts and sending HUD notifications.

### server/commands.lua
Registers numerous administrative commands via `ESX.RegisterCommand`, including:
- Teleport and job tools (`setcoords`, `setjob`, `car`, `cardel/dv`).
- Economy controls (`setaccountmoney`, `giveaccountmoney`, `giveitem`, `giveweapon`, `giveweaponcomponent`).
- Chat and data management (`clear`, `clearall`, `clearinventory`, `clearloadout`, `setgroup`, `save`, `saveall`).
- Player info utilities (`group`, `job`, `info`, `coords`, `tpm`, `goto`, `bring`, `kill`, `freeze`, `unfreeze`, `reviveall`, `noclip`, `players`).
Each command validates arguments and triggers corresponding player methods or client events.

### server/classes/player.lua
Defines the extended player object created for each connection. Major methods include:
- **Core**: `triggerEvent`, `setCoords`, `updateCoords`, `getCoords`, `kick`.
- **Accounts**: `setMoney`, `addMoney`, `removeMoney`, `setAccountMoney`, `addAccountMoney`, `removeAccountMoney`, `getAccounts`, `getAccount`.
- **Inventory**: `getInventory`, `getInventoryItem`, `addInventoryItem`, `removeInventoryItem`, `setInventoryItem`, weight checks (`getWeight`, `getMaxWeight`, `canCarryItem`, `canSwapItem`, `setMaxWeight`).
- **Jobs and groups**: `setJob`, `getJob`, `setGroup`, `getGroup`.
- **Weapons**: `addWeapon`, `addWeaponComponent`, `addWeaponAmmo`, `updateWeaponAmmo`, `setWeaponTint`, `getWeaponTint`, `removeWeapon`, `removeWeaponComponent`, `removeWeaponAmmo`, `hasWeaponComponent`, `hasWeapon`, `getWeapon`.
- **Messaging**: `showNotification` and `showHelpNotification` to push client prompts.
Each mutator usually fires matching client events (e.g., `esx:setAccountMoney`).

## Shared Modules
### common/functions.lua
Utility functions shared across client and server:
- Random string generation (`GetRandomString`).
- Accessors for configuration and weapon metadata (`GetConfig`, `GetWeapon`, `GetWeaponFromHash`, `GetWeaponList`, `GetWeaponLabel`, `GetWeaponComponent`).
- Debug helper `DumpTable` and rounding proxy `Round`.

### common/modules/math.lua
Provides `ESX.Math.Round` for decimal rounding, `GroupDigits` for locale-aware number formatting, and `Trim` for stripping whitespace.

### common/modules/table.lua
Table helpers: size calculation, set conversion, search (`IndexOf`, `LastIndexOf`, `Find`, `FindIndex`), filter/map/clone utilities, concatenation, joining, reversing, and key-sorted iteration with `Sort`.

## UI and Assets
### html/ui.html
Entry page embedding the HUD container and loading styles/scripts.

### html/js/app.js
Controls the HUD: registers elements, processes NUI messages via `onData`, updates account/job displays, and shows inventory notifications.

### html/js/wrapper.js
Splits large payloads into fixed-size chunks and sends them to Lua through `SendMessage`.

### html/js/mustache.min.js
Minified Mustache templating engine used for dynamic HUD element rendering.

### html/css/app.css
Stylesheet defining layout, fonts, colors, and animations for HUD widgets and notifications.

### html/fonts/pdown.ttf
### html/fonts/bankgothic.ttf
Custom fonts referenced by the CSS for consistent UI typography.

### html/img/accounts/bank.png
### html/img/accounts/black_money.png
### html/img/accounts/money.png
Icons shown next to bank, illicit, and cash balances on the HUD.

## Locales
Each locale file lists translated strings for notifications, commands, and UI text in a specific language.

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

## Conclusion
`es_extended` forms the backbone of the ESX framework. Client scripts manage the player HUD, inventory, and interaction events; server scripts handle persistence, commands, and gameplay logic; shared modules offer reusable helpers; UI assets present information to players; and locale files enable multilingual support.
=======
  - [html/img/accounts/*](#htmlimgaccounts)
- [Locales](#locales)
  - [Locale Files](#locale-files)

## Top-level Files
### README.md
Explains the ESX framework, features, installation steps, and references to other official resources.

### LICENSE
Contains the GNU General Public License granting redistribution and modification rights.

### agents.md
Provides instructions for generating comprehensive documentation for this resource.

### fxmanifest.lua
Resource manifest listing shared, client, server scripts, UI files, exports, and dependencies. It sets version metadata and exposes `getSharedObject` for other resources.

### config.lua
Defines global settings such as enabled accounts, HUD options, inventory limits, paycheck intervals, and identity support.

### config.weapons.lua
Large configuration mapping each weapon to labels, ammunition types, tints, and component options used by weapon-related APIs.

### es_extended.sql
Database schema creating `users`, `items`, `jobs`, and `job_grades` tables with default entries for an unemployed job.

### imports.lua
Exports a shared ESX object and registers a client event to update cached player data when `esx:setPlayerData` is triggered.

### locale.lua
Implements Lua translation helpers `_` and `_U` for server and client scripts.

### locale.js
JavaScript translation helper mirroring the Lua locale system for NUI pages, providing `_U` with parameter substitution and capitalization.

### version.json
Metadata describing the current legacy version and commit identifier.

## Client Scripts
### client/common.lua
Shares the ESX object with other client resources via the `esx:getSharedObject` event and `getSharedObject()` function.

### client/entityiter.lua
Provides utilities to enumerate entities and nearby items, enabling distance-based searches for objects, peds, vehicles, or pickups.

### client/functions.lua
Extensive client API defining:
- Player data helpers and setters that fire `esx:setPlayerData` when values change.
- Notification utilities (`ShowNotification`, `ShowAdvancedNotification`, `ShowHelpNotification`, `ShowFloatingHelpNotification`).
- Server callback wrapper `TriggerServerCallback` and NUI HUD management functions.
- Inventory interactions, pickup handling, and timeout scheduling for asynchronous events.

### client/main.lua
Handles player lifecycle:
- On join, disables auto spawn and requests server initialization.
- Processes `esx:playerLoaded`, spawning the player, enabling HUD elements, and starting sync loops.
- Tracks spawn/death events to update cached player data and provides admin utilities like teleport, noclip, and kill/freeze actions.

### client/wrapper.lua
Receives chunked messages from NUI pages and reconstructs them, emitting events like `<resource>:message:<type>` when complete.

### client/modules/death.lua
Monitors the player’s death state; when the player dies it triggers `esx:onPlayerDeath` locally and on the server with information about the killer and cause.

### client/modules/scaleform.lua
Wraps common scaleform displays such as freemode messages, breaking news banners, warning popups, and traffic camera movies.

### client/modules/streaming.lua
Utility for requesting models, textures, particle assets, animation sets/dicts, and weapons, waiting until assets load before calling callbacks.

## Server Scripts
### server/common.lua
Initializes the ESX server object, loads items and jobs from MySQL on startup, syncs the database periodically, and registers the `esx:triggerServerCallback` event used by client callbacks.

### server/functions.lua
Core server API providing:
- Tracing and timeout helpers (`SetTimeout`).
- Command registration with argument validation and chat suggestions.
- Player saving routines and lookup helpers (`GetPlayerFromId`, `GetExtendedPlayers`).
- Item usage callbacks, pickup creation, and job existence checks.

### server/main.lua
Manages player sessions:
- During connection, validates identifiers and creates or loads player records.
- Processes events like `esx:onPlayerJoined`, `esx:onPickup`, and `esx:useItem`.
- Defines server callbacks (`esx:getPlayerData`, `esx:getOtherPlayerData`, `esx:getPlayerNames`) and handles scheduled restarts by saving players.

### server/paycheck.lua
Periodically credits players with salary or welfare payments, optionally drawing from society accounts when configured.

### server/commands.lua
Registers administrative and utility commands (`setcoords`, `setjob`, `car`, `cardel`, etc.), each validating arguments and invoking relevant player methods.

### server/classes/player.lua
Defines the extended player object with methods for managing money, accounts, inventory, weapons, coordinates, job, group, and custom variables. It handles weapon components, tinting, loadout synchronization, notifications, and ACE permission binding.

## Shared Utilities
### common/functions.lua
General helpers for random string generation, configuration access, weapon lookups, table dumping, and rounding.

### common/modules/math.lua
Math helpers including rounding, digit grouping, and string trimming used across client and server scripts.

### common/modules/table.lua
Table helpers offering size calculation, set creation, search, filter, map, reverse, clone, concatenation, join, and sorted iteration utilities.

## UI and Assets
### html/ui.html
NUI entry point loading the HUD and inventory notification containers along with styling and scripts.

### html/js/app.js
Client-side HUD controller that manages element registration, updates, inventory notifications, and message routing from Lua via `onData`.

### html/js/wrapper.js
Breaks large JSON messages into fixed-size chunks for transmission from JS to Lua using the `SendMessage` helper.

### html/js/mustache.min.js
Minified Mustache templating engine used to render HUD elements.

### html/css/app.css
Styles the HUD and menu interfaces, defining fonts, colors, positioning, and notification appearance.

### html/fonts/pdown.ttf
### html/fonts/bankgothic.ttf
Custom fonts referenced by the UI stylesheet.

### html/img/accounts/*
Icon images for bank, black money, and cash account displays in the HUD.

## Locales
### Locale Files
Collection of language files (`br.lua`, `cs.lua`, `de.lua`, `en.lua`, `es.lua`, `fi.lua`, `fr.lua`, `pl.lua`, `sc.lua`, `sv.lua`, `tc.lua`) defining translated strings used across notifications, commands, weapons, and HUD elements. Scripts select a locale via `Config.Locale`.

## Conclusion
`es_extended` supplies the foundational systems for SunnyRP’s ESX-based gameplay. Server scripts manage persistence, commands, and player state; client scripts provide user interaction, HUD, and asset loading; shared modules supply common utilities; configuration files define accounts and weapons; and locale and UI assets enable internationalized displays.