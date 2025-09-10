# fsn_apartments Documentation

## Overview and Runtime Context
Provides apartment instances for players including cash storage, outfit management, weapon storage, and inventory access. Uses MySQL for persistence and integrates with other FSN resources for bank balances, clothing, inventory and weapons. Offers a NUI menu for weapons and storage and exports helper functions for other scripts.

## Table of Contents
- [Client](#client)
  - [client.lua](#clientlua)
  - [cl_instancing.lua](#cl_instancinglua)
  - [gui/ui.html](#guiuihtml)
  - [gui/ui.js](#guiuijs)
  - [gui/ui.css](#guiuicss)
- [Server](#server)
  - [server.lua](#serverlua)
  - [sv_instancing.lua](#sv_instancinglua)
- [Shared](#shared)
  - [fxmanifest.lua](#fxmanifestlua)
- [Cross References](#cross-references)
  - [Events](#events)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Callbacks](#nui-channels)
- [Gaps & Inferences](#gaps--inferences)

## Client
### client.lua
Role: Handles in-apartment logic, stash management, wardrobe features, action menu, and character creation workflow.
- Maintains apartment state (`myRoomNumber`, `apptdetails`) and enters/leaves rooms via `EnterRoom`.
- Events:
  - `fsn_apartments:stash:add` & `fsn_apartments:stash:take` adjust apartment cash after validating limits and wallet balance; syncs via `fsn_apartments:saveApartment`.
  - `fsn_apartments:sendApartment` receives apartment number and data from server, decodes outfits, inventory and utilities (payload: `{ number, apptinfo { apt_id, apt_inventory, apt_cash, apt_outfits, apt_utils } }`).
  - Wardrobe events (`outfit:add`, `outfit:use`, `outfit:remove`, `outfit:list`) manage saved outfits around the wardrobe marker.
  - `fsn_apartments:inv:update` refreshes stored inventory table.
  - `fsn_apartments:characterCreation` teleports new players into an interior, opens clothing menu and requests apartment creation.
- Functions:
  - `ToggleActionMenu` shows/hides NUI menu and populates weapon/inventory tables.
  - `isNearStorage` exported to check if player is within the storage marker.
  - `EnterMyApartment` exported helper to enter the current apartment.
  - `saveApartment` triggers server persistence periodically and on menu actions.
- Triggers external events for banking, notifications, clothing and weapon management.
- NUI callbacks: `weaponInfo`, `weaponEquip`, `ButtonClick` (handles `weapon-putaway`, `inventory`, `exit`), and `escape` to close menu.
- Control Flow: main loop draws markers for storage, cash, outfits and exit when inside apartment; handles entering/exiting and syncs instance state with server.
- Security/Permissions: server trusts client-sent `apptdetails` for `saveApartment`; stash commands rely on chat without role checks.
- Performance: loop runs every frame when player owns an apartment; instance management hides other players by toggling entity visibility.

### cl_instancing.lua
Role: Client-side instance system to isolate players inside apartments.
- Maintains `instanced` state and `myinstance` details; optionally displays debug info.
- On each frame, hides non-instance players and reduces vehicle density when instanced.
- Events handled:
  - `fsn_apartments:instance:join` sets `instanced` and stores instance info.
  - `fsn_apartments:instance:update` refreshes instance player list.
  - `fsn_apartments:instance:leave` clears state when leaving instance.
  - `fsn_apartments:instance:debug` toggles on-screen debug text.
- Exported function `inInstance` returns boolean for other scripts.

### gui/ui.html
Role: Defines NUI layout for the action menu listing weapons, inventory and other options. Loads jQuery, `ui.js` and `ui.css`.

### gui/ui.js
Role: Drives action menu behaviour inside the browser context.
- Listens for NUI messages `{showmenu, hidemenu}` to toggle visibility; parses weapon lists and inventory.
- Button clicks send NUI callbacks: `weaponInfo`, `weaponEquip`, `ButtonClick`, and `inventoryTake` (intended to remove items from inventory).
- ESC key posts to `escape` channel for closing.

### gui/ui.css
Role: Styling for NUI action menu (positions menu and button appearance).

## Server
### server.lua
Role: Manages apartment records, persistence and command handling.
- Tracks apartment occupancy in `apartments` table; `getAvailableAppt` assigns first free slot.
- Events:
  - `fsn_apartments:getApartment` looks up apartment by `char_id`; if none found triggers `characterCreation`.
  - `fsn_apartments:createApartment` inserts new DB entry then sends details to client.
  - `fsn_apartments:saveApartment` updates apartment inventory, cash, outfits and utilities (`MySQL.Sync.execute`).
- Chat command handler parses `/stash add|take {amt}` and `/outfit add|use|remove|list` to forward to client events.
- DB Usage: `MySQL.Sync.fetchAll` to retrieve apartments; `MySQL.Sync.execute` to insert/update records.
- Security: no permission checks on chat commands; relies on client validation for stash operations.

### sv_instancing.lua
Role: Server-side instance management for apartment interiors.
- `fsn_apartments:instance:new` creates a new instance with creator as first player.
- `fsn_apartments:instance:join` adds player to existing instance and broadcasts updated roster.
- `fsn_apartments:instance:leave` removes player and notifies others.
- Uses table helpers to prevent players joining multiple instances.

## Shared
### fxmanifest.lua
Role: Resource manifest.
- Declares dependencies (`fsn_main`, `mysql-async`) and specifies client/server scripts and NUI files.
- Exports `inInstance`, `isNearStorage`, `EnterMyApartment` for use by other resources.

## Cross References
### Events
| Event | Side | Description |
|-------|------|-------------|
| fsn_apartments:getApartment | Server | Fetch apartment info for character.
| fsn_apartments:sendApartment | Client | Receive apartment data from server.
| fsn_apartments:createApartment | Server | Persist new apartment and send details.
| fsn_apartments:saveApartment | Client→Server | Save apartment table.
| fsn_apartments:stash:add / stash:take | Client | Adjust stash cash.
| fsn_apartments:outfit:add/use/remove/list | Client | Manage saved outfits.
| fsn_apartments:inv:update | Client | Refresh inventory grid.
| fsn_apartments:characterCreation | Client | Start new-character flow.
| fsn_apartments:instance:new/join/leave/update/debug | Client & Server | Manage instancing.

### Exports
| Function | Description |
|----------|-------------|
| inInstance | Returns whether player is inside an instance.
| isNearStorage | Indicates proximity to apartment storage marker.
| EnterMyApartment | Teleports player to owned apartment.

### Commands
| Command | Description |
|---------|-------------|
| /stash add {amount} | Move wallet cash into apartment stash.
| /stash take {amount} | Withdraw cash from stash to wallet.
| /outfit add {name} | Save current outfit.
| /outfit use {name} | Equip saved outfit.
| /outfit remove {name} | Delete saved outfit.
| /outfit list | List saved outfit names.

### NUI Channels
| Channel | Payload | Purpose |
|---------|---------|---------|
| weaponInfo | weapon object | Display weapon registration info in chat.
| weaponEquip | weapon object | Move stored weapon back to player.
| ButtonClick | string (weapon-putaway/inventory/exit) | Handle menu button actions.
| escape | none | Close the action menu.
| inventoryTake | item identifier | Intended to remove item from inventory (callback missing – see Gaps).

## Gaps & Inferences
- **inventoryTake callback**: NUI posts `inventoryTake` but no Lua handler exists; inferred to remove items from storage (Inferred – Low, TODO to implement or confirm).
- **instanceMe function**: placeholder `instanceMe` in `cl_instancing.lua` prints a removed message and is unused (Inferred – Low).

DOCS COMPLETE
