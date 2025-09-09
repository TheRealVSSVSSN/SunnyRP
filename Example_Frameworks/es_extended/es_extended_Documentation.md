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
Exports the ESX shared object.
- **Event Handled**: `esx:setPlayerData` updates local `ESX.PlayerData` when the event originates from this resource, keeping cached player state in sync.

### locale.lua
Lua helpers `_` and `_U` resolve translated strings based on `Config.Locale`, returning placeholders when a key or locale is missing.

### locale.js
JavaScript translation utilities mirroring the Lua helpers. `_U` fetches and optionally formats strings from the loaded locale data and capitalizes the first letter.

### version.json
Metadata describing the legacy version and commit hash.

## Client Scripts
### client/common.lua
Shares the ESX object with other client resources.
- **Event Registered**: `esx:getSharedObject` returns the ESX table via callback.
- **Function**: `getSharedObject()` exposes the same table to Lua modules.

### client/entityiter.lua
Provides entity enumeration helpers.
- **Functions**:
  - `EnumerateEntities` – coroutine-based iterator using native find functions.
  - `EnumerateEntitiesWithinDistance` – filters entities within a distance of given coordinates or the player.
  - Convenience wrappers `EnumerateObjects`, `EnumeratePeds`, `EnumerateVehicles`, and `EnumeratePickups` call the generic iterator for each entity type.

### client/functions.lua
Defines the global `ESX` client API.
- **Utility Functions**: `SetTimeout`, `ClearTimeout`, and `SetPlayerData` manage timeouts and player data.
- **Notification Functions**: `ShowNotification`, `ShowAdvancedNotification`, `ShowHelpNotification`, and `ShowFloatingHelpNotification` display messages on screen.
- **RPC**: `TriggerServerCallback` sends a request to the server; `esx:serverCallback` resolves the response.
- **HUD API**: `ESX.UI.HUD` methods register, update, delete, and reset HUD elements.
- **Game Helpers**: `ESX.Game` teleports entities, spawns or deletes vehicles and objects, enumerates entities, handles vehicle properties, and draws 3D text.
- **Events Handled**:
  - `esx:serverCallback` – receives server RPC responses.
  - `esx:showNotification` – displays basic notifications.
  - `esx:showAdvancedNotification` – shows styled notifications with sender and subject.
  - `esx:showHelpNotification` – draws contextual help text.

### client/main.lua
Player lifecycle controller.
- Disables auto-spawn on start and requests initialization from the server.
- **Events Handled**:
  - `esx:playerLoaded` – spawns the player, enables HUD, restores loadout, and starts loops that sync coordinates and weapon ammo.
  - `esx:onPlayerLogout` – clears state and removes HUD elements.
  - `esx:setMaxWeight` – updates carrying capacity.
  - `esx:onPlayerSpawn` and `esx:onPlayerDeath` – maintain loadout flags.
  - `skinchanger:modelLoaded` and `esx:restoreLoadout` – reapply weapons after model changes.
  - `esx:setAccountMoney` – refreshes money displays.
  - `esx:addInventoryItem` / `esx:removeInventoryItem` – adjust inventory and optionally show notifications.
  - `esx:addWeapon`, `esx:addWeaponComponent`, `esx:setWeaponAmmo`, `esx:setWeaponTint`, `esx:removeWeapon`, `esx:removeWeaponComponent` – manage weapon data.
  - `esx:teleport` – moves the player to specified coordinates once the destination model loads.
  - `esx:setJob` – updates job information.
  - `esx:spawnVehicle` and `esx:deleteVehicle` – spawn or delete vehicles near the player.
  - `esx:createPickup`, `esx:createMissingPickups`, `esx:removePickup` – manage world pickups.
  - `esx:registerSuggestions` – registers chat command suggestions.
  - Administrative utilities: `esx:tpm`, `esx:noclip`, `esx:killPlayer`, `esx:freezePlayer`.
- **Functions**:
  - `StartServerSyncLoops` periodically triggers `esx:updateCoords` and `esx:updateWeaponAmmo` server events.
  - Registers `/showinv` command to display inventory through the UI menu.

### client/wrapper.lua
Reassembles chunked NUI messages.
- **NUI Callback**: `__chunk` collects chunks of JSON data; when the final chunk arrives, the message is decoded and `<resource>:message:<type>` events are emitted.

### client/modules/death.lua
Monitors player death with a constant loop.
- When the player dies, captures killer information and distance.
- **Events Triggered**: `esx:onPlayerDeath` is fired locally and sent to the server with context data.
- Resets the `isDead` flag when the player respawns.

### client/modules/scaleform.lua
Convenience wrappers for displaying scaleform movies.
- `ESX.Scaleform.ShowFreemodeMessage` – big freemode-style message.
- `ESX.Scaleform.ShowBreakingNews` – scrolling news ticker.
- `ESX.Scaleform.ShowPopupWarning` – warning overlay with title and text.
- `ESX.Scaleform.ShowTrafficMovie` – traffic camera clip.
- `ESX.Scaleform.Utils.RequestScaleformMovie` – loads and returns a scaleform movie handle.

### client/modules/streaming.lua
Asset loading helpers that request models, textures, particle assets, animation sets or dicts, and weapon assets before executing callbacks. Each `ESX.Streaming.*` function waits for the asset to load then runs the supplied callback.

## Server Scripts
### server/common.lua
Initializes the server-side ESX object. On database readiness it loads item and job data, prints status, and starts periodic player saving (`StartDBSync`) and paychecks (`StartPayCheck`).
- **Events**:
  - `esx:getSharedObject` – returns the shared ESX table.
  - `esx:clientLog` – prints debug traces when `Config.EnableDebug` is true.
  - `esx:triggerServerCallback` – routes callback requests and returns results to clients.

### server/functions.lua
Core server utilities.
- **Logging and Timeouts**: `ESX.Trace`, `ESX.SetTimeout`, and `ESX.ClearTimeout` provide debug output and timed callbacks.
- **Command Registration**: `ESX.RegisterCommand` validates arguments, adds ACE permissions, and registers chat suggestions.
- **RPC**: `ESX.RegisterServerCallback` and `ESX.TriggerServerCallback` implement request/response callbacks with clients.
- **Persistence**: `ESX.SavePlayer` and `ESX.SavePlayers` persist player data with prepared MySQL statements.
- **Player Lookup**: `ESX.GetPlayers`, `ESX.GetExtendedPlayers`, `ESX.GetPlayerFromId`, `ESX.GetPlayerFromIdentifier`, `ESX.GetIdentifier` query active players.
- **Inventory Helpers**: `ESX.RegisterUsableItem`, `ESX.UseItem`, `ESX.GetItemLabel`, and `ESX.CreatePickup` manage items and world drops.
- **Job Helper**: `ESX.DoesJobExist` verifies job and grade combinations.

### server/main.lua
Manages connection flow and gameplay events.
- Sets map and game type on startup and prepares SQL statements for player creation and loading.
- **Events Handled**:
  - `esx:onPlayerJoined` / `playerConnecting` – create or load player accounts (`createESXPlayer`, `loadESXPlayer`).
  - `chatMessage` – used to implement commands registered via `ESX.RegisterCommand`.
  - `playerDropped` and `esx:playerLogout` – save and cleanup player data.
  - `esx:updateCoords` and `esx:updateWeaponAmmo` – persist position and weapon ammo from clients.
  - `esx:giveInventoryItem`, `esx:removeInventoryItem`, `esx:useItem`, `esx:onPickup` – manage item interactions and pickups.
  - `txAdmin:events:scheduledRestart` – saves all players before scheduled restarts.
- **Callbacks Provided**: `esx:getPlayerData`, `esx:getOtherPlayerData`, and `esx:getPlayerNames` supply player information to clients.

### server/paycheck.lua
`StartPayCheck` credits salaries at `Config.PaycheckInterval`.
- For unemployed players, deposits salary into their bank account and notifies them via `esx:showAdvancedNotification`.
- When `Config.EnableSocietyPayouts` is true, interacts with `esx_society` and `esx_addonaccount` to pay salaries from society funds if available.
- Otherwise, pays generic job salaries directly to the player.

### server/commands.lua
Registers administrative and utility commands via `ESX.RegisterCommand`.
- **Teleport & Navigation**: `tpm`, `goto`, `bring`, `setcoords`.
- **Job and Group Management**: `setjob`, `setgroup`, `job`, `group`.
- **Vehicle Tools**: `car`, `cardel`/`dv` spawn or delete vehicles.
- **Economy & Inventory**: `setaccountmoney`, `giveaccountmoney`, `giveitem`, `giveweapon`, `giveweaponcomponent`, `clearinventory`, `clearloadout`.
- **Server and Player Utilities**: `clear`, `clearall`, `info`, `coords`, `players`, `save`, `saveall`, `kill`, `freeze`, `unfreeze`, `reviveall`, `noclip`.
Each command validates arguments and invokes relevant player methods or server events.

### server/classes/player.lua
Defines the extended player object instantiated for each connection. Major method groups:
- **Core**: `triggerEvent`, `setCoords`, `updateCoords`, `getCoords`, `kick`.
- **Accounts**: `setMoney`, `addMoney`, `removeMoney`, `setAccountMoney`, `addAccountMoney`, `removeAccountMoney`, `getAccounts`, `getAccount`; these fire events like `esx:setAccountMoney`.
- **Inventory**: `getInventory`, `getInventoryItem`, `addInventoryItem`, `removeInventoryItem`, `setInventoryItem`, weight checks (`getWeight`, `getMaxWeight`, `canCarryItem`, `canSwapItem`, `setMaxWeight`).
- **Jobs and groups**: `setJob`, `getJob`, `setGroup`, `getGroup` with ACE permission bindings.
- **Weapons**: `addWeapon`, `addWeaponComponent`, `addWeaponAmmo`, `updateWeaponAmmo`, `setWeaponTint`, `getWeaponTint`, `removeWeapon`, `removeWeaponComponent`, `removeWeaponAmmo`, `hasWeaponComponent`, `hasWeapon`, `getWeapon`.
- **Messaging**: `showNotification` and `showHelpNotification` to push client prompts.
Many mutators trigger matching client events (`esx:setAccountMoney`, `esx:addInventoryItem`, `esx:setJob`, `esx:addWeapon`, etc.) so the HUD and inventory stay in sync.

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
- Detailed parameter and return-value information for functions and callbacks is beyond the scope of this summary and should be reviewed in source when integrating new features.

## Conclusion
`es_extended` supplies the foundational systems for SunnyRP’s ESX-based gameplay. Server scripts manage persistence, commands, and player state; client scripts provide interaction and HUD logic; shared modules offer utilities; UI assets display information; and locale files enable multilingual support.
