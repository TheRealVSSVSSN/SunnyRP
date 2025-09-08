# es_extended Documentation

## Overview
ESX Legacy's `es_extended` resource forms the core framework for economy-based roleplay in SunnyRP. It provides player management, shared utilities, configurable weapons and accounts, and a basic UI. Scripts are divided into client, server, shared, and UI components.

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
