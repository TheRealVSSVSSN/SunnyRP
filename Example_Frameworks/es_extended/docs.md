# es_extended Documentation

## Overview and Runtime Context
ES Extended (ESX) is a foundational framework providing player persistence, inventory, jobs, commands, and a basic HUD for FiveM roleplay servers. It runs both client and server Lua scripts, communicates with a MySQL database, and serves an HTML-based NUI for HUD elements. Dependencies include `mysql-async`, `async`, and `spawnmanager` configured in the manifest.

## File Inventory
- **Client**
  - `client/main.lua`
  - `client/functions.lua`
  - `client/common.lua`
  - `client/entityiter.lua`
  - `client/wrapper.lua`
  - `client/modules/death.lua`
  - `client/modules/scaleform.lua`
  - `client/modules/streaming.lua`
- **Server**
  - `server/main.lua`
  - `server/functions.lua`
  - `server/common.lua`
  - `server/commands.lua`
  - `server/classes/player.lua`
  - `server/paycheck.lua`
- **Shared**
  - `fxmanifest.lua`
  - `config.lua`
  - `config.weapons.lua`
  - `imports.lua`
  - `common/functions.lua`
  - `common/modules/math.lua`
  - `common/modules/table.lua`
  - `locale.lua`, `locales/*.lua`, `locale.js`
  - `es_extended.sql`
  - `README.md`, `LICENSE`, `version.json`
- **NUI**
  - `html/ui.html`
  - `html/js/app.js`
  - `html/js/wrapper.js`
  - `html/css/app.css`
  - `html/fonts/*`, `html/img/accounts/*`

## Client Files
### client/main.lua
Handles player lifecycle, HUD setup, pickup management, and admin utilities. On initial activation it disables auto spawn, notifies the server that the player joined, and later spawns the player and restores their loadout. It registers numerous events to sync account balances, inventory changes, weapons, job updates, teleportation, and pickups. A `showinv` command opens the default inventory menu. Background threads sync weapon ammo and player coordinates with the server and manage pickup interactions and HUD visibility. Teleport-to-marker (`esx:tpm`), noclip (`esx:noclip`), kill, and freeze events provide administrative controls.

### client/functions.lua
Defines the core ESX client object. Provides utility functions for notifications, HUD management, inventory display, timeouts, and server callbacks. `ESX.TriggerServerCallback` wraps server RPCs, `ESX.SetPlayerData` emits `esx:setPlayerData` when fields change, and multiple `SendNUIMessage` calls update the HUD. It listens for server responses via `esx:serverCallback` and notification events.

### client/common.lua
Exposes the client-side `esx:getSharedObject` event so other resources can obtain the ESX object.

### client/entityiter.lua
Implements generic entity enumeration helpers and distance filtering used for proximity checks.

### client/wrapper.lua
Defines a `__chunk` NUI callback used to receive large messages from the UI. Each chunk triggers a local event named `resource:message:type` after reassembly (Inferred Medium).

### client/modules/death.lua
Monitors player death. When the player dies, it builds a payload containing killer info and coordinates and triggers local and server `esx:onPlayerDeath` events.

### client/modules/scaleform.lua
Utility helpers for rendering scaleform movies.

### client/modules/streaming.lua
Wraps model, animation, and weapon asset streaming requests.

## Server Files
### server/main.lua
Coordinates player loading, saving, and synchronization. Stores prepared SQL statements for creating and loading users, handles player connection flow, and listens for logout, coordinate updates, weapon ammo sync, inventory actions, and pickup collection. `esx:getPlayerData`, `esx:getOtherPlayerData`, and `esx:getPlayerNames` are exposed as callbacks. A handler for `txAdmin:events:scheduledRestart` saves players before restarts.

### server/functions.lua
Provides core server utilities such as `ESX.RegisterCommand`, server callback registration, timeout management, and player saving. When commands are registered, ACE permissions and chat suggestions are configured. `ESX.SavePlayer` and `ESX.SavePlayers` persist player data to the database. `ESX.CreatePickup` broadcasts item drops to clients.

### server/common.lua
Initializes shared tables, loads items and job data from the database on startup, and exposes the `esx:getSharedObject` event. It also routes client callback requests received via `esx:triggerServerCallback` to the proper server callback and relays responses.

### server/commands.lua
Registers administrative and utility commands using `ESX.RegisterCommand`. Examples include `setjob`, `car`, `giveitem`, inventory/weapon grants, teleportation, player management (bring/goto/freeze/kill), and information utilities. Permissions rely on ACE groups: most commands require `admin` while some like `clear` are available to regular users.

### server/classes/player.lua
Defines the extended player object with methods to manage money, inventory, job, loadout, and custom variables. Methods trigger client updates such as `esx:addInventoryItem`, `esx:removeInventoryItem`, and `esx:setJob`. Inventory additions and removals fire `esx:onAddInventoryItem` and `esx:onRemoveInventoryItem` events for hooks (Inferred High).

### server/paycheck.lua
Periodically pays players based on their job grade. If society payouts are enabled, funds are withdrawn from the job’s shared account; otherwise payments come directly from the bank. Notifications are sent via `esx:showAdvancedNotification` and integration events `esx_society:getSociety` and `esx_addonaccount:getSharedAccount` are used to access society data.

## Shared Files
### fxmanifest.lua
Declares the resource metadata, shared scripts, server scripts, client scripts, UI page, assets, exports, and dependencies. Both client and server export `getSharedObject` for other resources.

### config.lua
Defines runtime configuration such as locale, account labels, starting money, HUD, weight limit, paycheck interval, debug flag, multicharacter and identity options.

### config.weapons.lua
Lists default weapon tint labels and a comprehensive weapon configuration table detailing labels, ammo types, tints, and component hashes. Also used by shared weapon helper functions.

### imports.lua
Provides a convenience loader allowing other resources to include ESX and stay in sync with `ESX.PlayerData` by registering for `esx:setPlayerData` updates.

### common/functions.lua
Shared helpers for random string generation, configuration access, weapon lookups, and table dumping.

### common/modules/math.lua
Math utilities: rounding, digit grouping, and trimming.

### common/modules/table.lua
Table utilities: size, set conversion, search, filter, mapping, reversing, cloning, concatenation, join, and ordered iteration.

### locale.lua and locales/*.lua
Localization engine and language dictionaries. `_` translates messages while `_U` returns capitalized versions.

### locale.js
Browser-side localization helpers mirroring the Lua implementation for NUI.

### es_extended.sql
SQL schema for `users`, `items`, and `job_grades` tables used by the server to persist player data and define item and job metadata.

### README.md, LICENSE, version.json
Provide project overview, licensing, and version metadata.

## NUI Files
### html/ui.html
Root HTML document for the HUD. Includes CSS, Mustache templates, and JS assets.

### html/js/app.js
Implements HUD logic exposed via `window.onData`. Supports actions `setHUDDisplay`, `insertHUDElement`, `updateHUDElement`, `deleteHUDElement`, `resetHUDElements`, and `inventoryNotification`. Messages arrive from Lua through `SendNUIMessage`.

### html/js/wrapper.js
Adds a global `SendMessage` function that chunks large JSON payloads into `__chunk` posts back to the game, which the client reassembles and forwards as events (Inferred Medium).

### html/css/app.css, fonts, images
Style and assets for the HUD.

## Control Flow and Runtime Notes
1. **Player join** – `client/main.lua` disables auto-spawn and notifies the server. `server/main.lua` loads or creates the player, then emits `esx:playerLoaded`, leading the client to spawn, restore loadout, and initialize HUD.
2. **Synchronization** – Background threads in `client/main.lua` periodically send ammo counts and coordinates to the server (`esx:updateWeaponAmmo`, `esx:updateCoords`), while the server pushes inventory, account, and job changes back to clients.
3. **Inventory and pickups** – Pickups are created server-side via `ESX.CreatePickup`, synced to clients with `esx:createPickup`, and removed after collection with `esx:onPickup` and `esx:removePickup`.
4. **Paychecks** – `server/paycheck.lua` awards periodic salaries, optionally pulling from society accounts.

## Security and Permissions
- Commands use ACE-based permission checks via `ESX.RegisterCommand`. Administrative commands require the `admin` group; some informational commands accept both `user` and `admin` groups.
- Player data modifications are processed server-side to prevent client tampering. Inventory pickups verify capacity and weapon ownership before granting items.
- The noclip, kill, and teleport events rely on server-side commands to avoid unauthorized use.

## Database Usage
- Items, jobs, and job grades load once at startup from MySQL.
- Player records are created if absent and updated via prepared statements when saving.
- Periodic saving (`ESX.SavePlayers`) and txAdmin restart handling ensure persistence.

## Performance Considerations
- Long-running loops sleep when idle and use minimal polling intervals.
- MySQL prepared statements (`MySQL.Async.store`) reduce parsing overhead.
- HUD and pickup loops in the client back off when the player is idle to limit CPU usage.

## Cross-Index
### Events
| Name | Type | Payload |
|---|---|---|
| esx:playerLoaded | client | `xPlayer`, `isNew`, `skin`
| esx:onPlayerLogout | client | none
| esx:setMaxWeight | client | `newMaxWeight`
| esx:onPlayerSpawn | client/local | none
| esx:onPlayerDeath | both | `{victimCoords, killerCoords?, killedByPlayer, deathCause, distance?, killerServerId?, killerClientId?}`
| esx:restoreLoadout | client | none
| esx:setAccountMoney | client | `account`
| esx:addInventoryItem / esx:removeInventoryItem | client/server | `(item, count, showNotification)`
| esx:addWeapon / esx:removeWeapon | client/server | `weapon`, optional `ammo`
| esx:addWeaponComponent / esx:removeWeaponComponent | client/server | `weapon`, `component`
| esx:setWeaponAmmo | client | `weapon`, `ammo`
| esx:setWeaponTint | client | `weapon`, `tintIndex`
| esx:teleport | client | `coords`
| esx:setJob | both | `job`
| esx:spawnVehicle | client | `model`
| esx:createPickup / esx:removePickup | both | pickup metadata or `pickupId`
| esx:createMissingPickups | client | `missingPickups`
| esx:registerSuggestions | client | `registeredCommands`
| esx:deleteVehicle | client | `radius?`
| esx:updateWeaponAmmo | client→server | `weaponName`, `ammoCount`
| esx:updateCoords | client→server | `coords`
| esx:onPickup | client→server | `pickupId`
| esx:serverCallback | server→client | `requestId`, `...`
| esx:triggerServerCallback | client→server | `name`, `requestId`, `...`
| esx:tpm | client | none
| esx:noclip | client | `toggle`
| esx:killPlayer | client | none
| esx:freezePlayer | client | `freeze` or `unfreeze`
| esx:getSharedObject | both | callback

### ESX Callbacks
| Name | Description |
|---|---|
| esx:getPlayerData | Returns current player data to the caller.
| esx:getOtherPlayerData | Returns data for a specified player ID.
| esx:getPlayerNames | Retrieves names for a list of player IDs.

### Exports
| Name | Side | Purpose |
|---|---|---|
| getSharedObject | client & server | Returns the ESX shared object for external resources.

### Commands
| Command | Permissions | Purpose |
|---|---|---|
| setcoords | admin | Teleport to coordinates.
| setjob | admin | Assign job and grade.
| car | admin | Spawn vehicle by model.
| cardel/dv | admin | Remove nearby vehicle(s).
| setaccountmoney | admin | Set account balance.
| giveaccountmoney | admin | Add funds to account.
| giveitem | admin | Grant inventory item.
| giveweapon | admin | Grant weapon.
| giveweaponcomponent | admin | Add weapon component.
| clear/cls | user | Clear personal chat.
| clearall/clsall | admin | Clear server chat.
| clearinventory | admin | Remove all items from a player.
| clearloadout | admin | Remove all weapons.
| setgroup | admin | Change a player's permission group.
| save | admin | Save a specific player.
| saveall | admin | Save all players.
| group | user/admin | Show player's group.
| job | user/admin | Show player's job.
| info | user/admin | Display identifier and position info.
| coords | admin | Print coordinates.
| tpm | admin | Teleport to waypoint.
| goto | admin | Teleport to player.
| bring | admin | Summon a player.
| kill | admin | Kill a player.
| freeze | admin | Freeze a player.
| unfreeze | admin | Unfreeze a player.
| reviveall | admin | Trigger mass revive via `esx_ambulancejob:revive`.
| noclip | admin | Toggle noclip for a player.
| players | admin | List connected players.
| showinv | client | Open default inventory UI.

## Configuration & Integration
- Set locale and account labels in `config.lua`.
- Weapon definitions in `config.weapons.lua` feed shared weapon helpers.
- `fxmanifest.lua` declares dependencies (`mysql-async`, `async`, `spawnmanager`) and exports.
- `imports.lua` should be included by other resources via `shared_script '@es_extended/imports.lua'` to automatically access ESX.
- Integration events: `esx_society:getSociety`, `esx_addonaccount:getSharedAccount`, `esx_ambulancejob:revive`, and skinchanger events.

## Gaps & Inferences
- NUI wrapper chunks messages and fires `resource:message:type` events although the downstream handlers are not shown (Inferred Medium).
- Inventory and job change hooks (`esx:onAddInventoryItem`, `esx:onRemoveInventoryItem`, `esx:setJob`) originate in `server/classes/player.lua`; external consumers are not provided (Inferred High).
- `esx:loadingScreenOff` hides the HUD after spawn but no server counterpart is defined here (Inferred Low).

TODO: Additional external resources are required for society accounts, skinchanger, and inventory UI beyond the minimal default.

DOCS COMPLETE — gaps scanned, filled where possible.
