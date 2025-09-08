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
- [Shared Modules](#shared-modules)
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
- Account labels and starting balances for `bank`, `black_money`, and `money`.
- Gameplay toggles: society payrolls, HUD display, max weight, paycheck interval, debug logging, default inventory menu, wanted level, and player-vs-player combat.
- Character flow flags for multicharacter selection and pre-load identity prompts.

### config.weapons.lua
Lists every weapon with label, ammo configuration, tint options, and component metadata used by weapon APIs.
Provides component hashes and default ammo types allowing `ESX.GetWeapon*` helpers to build loadouts and apply attachments.

### es_extended.sql
SQL schema creating:
- **`users`** — per-player row storing serialized accounts, inventory, job, loadout, and position.
- **`items`** — catalog of usable items with weight and rarity flags.
- **`job_grades`** — grade definitions with salary and gendered skin JSON.
- **`jobs`** — job names and labels.
Seeds an initial unemployed job grade and job entry.

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
- Function **`getSharedObject()`** exposes the same reference for direct calls, allowing scripts to obtain ESX without firing the event.

### client/entityiter.lua
- Implements a coroutine-based **`EnumerateEntities`** factory and helpers for objects, peds, vehicles, and pickups.
- **`EnumerateEntitiesWithinDistance`** filters entities by range for proximity searches.

### client/functions.lua
Provides the bulk of the client API:
- **State and timing**: `ESX.SetTimeout` / `ClearTimeout`, `IsPlayerLoaded`, `GetPlayerData`, and `SetPlayerData` (fires `esx:setPlayerData`).
- **Notifications**: `ShowNotification`, `ShowAdvancedNotification`, `ShowHelpNotification`, and `ShowFloatingHelpNotification` wrap GTA natives for on‑screen messages.
- **Server callbacks**: `TriggerServerCallback` sends RPC-style requests via `esx:triggerServerCallback` and matches responses by request identifier.
- **HUD management**: `ESX.UI.HUD` offers `RegisterElement`, `UpdateElement`, `RemoveElement`, and `Reset` helpers that send NUI messages to update the HUD.
- **Menu system**: `ESX.UI.Menu` registers menu types and supports open, update, close, and query operations for interactive menus.
- **Inventory alerts**: `ESX.UI.ShowInventoryItemNotification` displays gain/loss popups when inventory changes.
- **Game helpers**: `ESX.Game` includes entity enumeration, proximity checks (`GetClosestObject`, `GetClosestVehicle`, `GetClosestPed`), vehicle property getters/setters, teleportation, entity spawning/deletion, and 3D text drawing.
- **Inventory UI**: `ESX.ShowInventory()` builds and displays an inventory menu using player data for the default F2 interface.

### client/main.lua
Handles player lifecycle and admin features:
- Startup thread disables auto-spawn and triggers **`esx:onPlayerJoined`** when the network session becomes active.
- Event **`esx:playerLoaded`** spawns the player, loads skin, enables HUD elements, and starts periodic ammo sync via `StartServerSyncLoops`.
- Monitors logout (**`esx:onPlayerLogout`**), weight updates (**`esx:setMaxWeight`**), spawn/death (**`esx:onPlayerSpawn`**, **`esx:onPlayerDeath`**), skin changes (**`skinchanger:modelLoaded`**), and loadout restoration (**`esx:restoreLoadout`**).
- Inventory and weapon events: **`esx:setAccountMoney`**, **`esx:addInventoryItem`**, **`esx:removeInventoryItem`**, **`esx:addWeapon`**, **`esx:addWeaponComponent`**, **`esx:setWeaponAmmo`**, **`esx:setWeaponTint`**, **`esx:removeWeapon`**, and **`esx:removeWeaponComponent`** keep client state aligned with server decisions.
- Utility events: **`esx:teleport`**, **`esx:setJob`**, **`esx:spawnVehicle`**, **`esx:createPickup`**, **`esx:createMissingPickups`**, **`esx:registerSuggestions`**, **`esx:removePickup`**, and **`esx:deleteVehicle`** provide admin and gameplay tools.
- Hides the HUD while the pause menu is open to avoid overlap.

### client/wrapper.lua
Reassembles chunked NUI messages:
- NUI callback **`__chunk`** concatenates message pieces and, when complete, emits `<resource>:message:<type>` events.

### client/modules/death.lua
Thread monitors player fatal state and emits **`esx:onPlayerDeath`** locally and to the server with killer data when applicable.
Functions **`PlayerKilledByPlayer`** and **`PlayerKilled`** collect positions, cause of death, and distance before firing events for logging and revival scripts.

### client/modules/scaleform.lua
Wraps common scaleform movies:
- `ShowFreemodeMessage`, `ShowBreakingNews`, `ShowPopupWarning`, and `ShowTrafficMovie` display themed full-screen messages for a duration.
- `ESX.Scaleform.Utils.RequestScaleformMovie` loads a scaleform before use.

### client/modules/streaming.lua
Asset request helpers that load models, textures, particle FX, animation sets/dicts, and weapon assets before invoking an optional callback, ensuring resources are ready before use.

## Server Scripts
### server/common.lua
Initialises server-side ESX state:
- Event **`esx:getSharedObject`** exposes the ESX table to other resources.
- On database ready, loads items and jobs, prints status, starts periodic player saving (**`StartDBSync`**) and paychecks (**`StartPayCheck`**).
- Event **`esx:clientLog`** prints debug traces when enabled.
- Event **`esx:triggerServerCallback`** dispatches registered server callbacks and returns results to clients.

### server/functions.lua
Server utility layer:
- Logging via `ESX.Trace` with optional debug output.
- Timers with `ESX.SetTimeout` / `ClearTimeout` for scheduled actions.
- Command registration through `ESX.RegisterCommand`, including argument validation and chat suggestions.
- Server callback registry (`RegisterServerCallback`, `TriggerServerCallback`) powering RPC communication.
- Persistence helpers `ESX.SavePlayer` and `ESX.SavePlayers` using prepared statements.
- Player lookup helpers (`GetPlayers`, `GetExtendedPlayers`, `GetPlayerFromId`, `GetPlayerFromIdentifier`, `GetIdentifier`).
- Item and weapon utilities (`RegisterUsableItem`, `UseItem`, `GetItemLabel`, `CreatePickup`).
- Employment check `DoesJobExist` to validate job and grade combinations.

### server/main.lua
Manages connection flow and gameplay events:
- Sets map/game type on startup and prepares SQL statements.
- Handles player join via **`esx:onPlayerJoined`** (multichar) or `playerConnecting`, creating or loading accounts (`createESXPlayer`, `loadESXPlayer`).
- Cleans up on **`playerDropped`** and **`esx:playerLogout`** while saving data.
- Updates server-side state on **`esx:updateCoords`** and **`esx:updateWeaponAmmo`** to persist location and ammo.
- Item interactions: **`esx:giveInventoryItem`**, **`esx:removeInventoryItem`**, **`esx:useItem`**, and **`esx:onPickup`** manage inventory transactions and dropped items.
- Server callbacks exposed: **`esx:getPlayerData`**, **`esx:getOtherPlayerData`**, and **`esx:getPlayerNames`** provide player information to other resources.
- Saves all players 50 seconds before a scheduled txAdmin restart (**`txAdmin:events:scheduledRestart`**).

### server/paycheck.lua
Function **`StartPayCheck`** credits salaries at `Config.PaycheckInterval`, optionally deducting from society accounts and sending HUD notifications.

### server/commands.lua
Registers administrative and utility commands via `ESX.RegisterCommand`:
- `setcoords x y z` – teleport to coordinates.
- `setjob playerId job grade` – assign job grade.
- `car model` – spawn a vehicle; `cardel`/`dv` removes nearby vehicles.
- `setaccountmoney` / `giveaccountmoney` – set or add to an account balance.
- `giveitem item count` – grant inventory items.
- `giveweapon weapon ammo` and `giveweaponcomponent weapon component` – distribute weapons and attachments.
- `clear` / `clearall` – wipe chat locally or globally.
- `clearinventory` / `clearloadout` – remove all items or weapons.
- `setgroup` – change permission group.
- `save playerId` / `saveall` – persist player data.
- Informational tools: `group`, `job`, `info`, `coords`.
- Teleport helpers: `tpm`, `goto playerId`, `bring playerId`.
- Player control: `kill`, `freeze`, `unfreeze`, `reviveall`, `noclip`.
- `players` – list all connected players.
Each command validates arguments and triggers corresponding player methods or client events.

### server/classes/player.lua
Defines the extended player object created for each connection. Major methods include:
- **Core**: `triggerEvent`, `setCoords`, `updateCoords`, `getCoords`, and `kick` for movement and session control.
- **Accounts**: `setMoney`, `addMoney`, `removeMoney`, `setAccountMoney`, `addAccountMoney`, `removeAccountMoney`, `getAccounts`, `getAccount` for cash and account manipulation.
- **Inventory**: `getInventory`, `getInventoryItem`, `addInventoryItem`, `removeInventoryItem`, `setInventoryItem`, plus weight helpers (`getWeight`, `getMaxWeight`, `canCarryItem`, `canSwapItem`, `setMaxWeight`).
- **Jobs and groups**: `setJob`, `getJob`, `setGroup`, `getGroup` governing employment and permissions.
- **Weapons**: `addWeapon`, `addWeaponComponent`, `addWeaponAmmo`, `updateWeaponAmmo`, `setWeaponTint`, `getWeaponTint`, `removeWeapon`, `removeWeaponComponent`, `removeWeaponAmmo`, `hasWeaponComponent`, `hasWeapon`, `getWeapon` for full weapon lifecycle management.
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

## Documentation Gaps
- Parameter lists for events, callbacks, and commands are summarized but not exhaustively enumerated.
- Database column descriptions and data relationships are only covered at a high level.
- UI assets (HTML/CSS/JS) are described functionally but not at the markup/style level.
- External resources that interact with `es_extended` are outside the scope of this document.

## Conclusion
`es_extended` forms the backbone of the ESX framework. Client scripts manage the player HUD, inventory, and interaction events; server scripts handle persistence, commands, and gameplay logic; shared modules offer reusable helpers; UI assets present information to players; and locale files enable multilingual support.
