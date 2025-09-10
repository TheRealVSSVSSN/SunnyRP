# fsn_apartments Documentation

## Overview and Runtime Context
Provides instanced apartment interiors for characters. Each player receives a private room supporting cash deposits, wardrobe presets, weapon storage, and an item stash. Persistence lives in the `fsn_apartments` MySQL table, while the resource coordinates with banking, clothing, inventory and weapon systems. A browser-based NUI drives in-apartment actions, and exports allow other scripts to query storage proximity or instance state.

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
  - [ESX Callbacks](#esx-callbacks)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Channels](#nui-channels)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## Client
### client.lua
*Role:* Handles apartment interior entry, storage interactions and NUI communication.

- **State:** tracks current room number, wardrobe proximity (`inWardrobe`), storage proximity (`instorage` via `isNearStorage` export), and full apartment details loaded from server.
- **Events handled:**
  - `fsn_apartments:stash:add` / `stash:take` move wallet cash into or out of the apartment stash with limit checks【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L28-L63】
  - `fsn_apartments:sendApartment` delivers `{number, apptinfo}` and bootstraps decoded outfit, inventory and utility tables, creating default grids when missing【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L70-L137】
  - `fsn_apartments:outfit:add|use|remove|list` manage wardrobe presets when `inWardrobe` is true【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L139-L196】
  - `fsn_apartments:inv:update` replaces the cached inventory grid from another resource【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L290-L293】
  - `fsn_apartments:characterCreation` teleports new characters to a creator interior, opens clothing UI and on completion requests apartment creation【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L445-L476】
- **Functions:**
  - `EnterRoom(id)` warps the player into the interior and requests a fresh instance from the server【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L430-L440】
  - `EnterMyApartment()` convenience wrapper calling `EnterRoom` with `myRoomNumber`.
  - `ToggleActionMenu()` sets NUI focus and sends either `showmenu` (with JSON weapon list) or `hidemenu` messages to the browser【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L263-L285】
  - `isNearStorage()` export exposing `instorage` flag for other scripts【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L343-L346】
  - `saveApartment()` pushes current `apptdetails` to the server every ten minutes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L478-L487】
- **NUI callbacks:** `weaponInfo`, `weaponEquip`, `ButtonClick` (values `weapon-putaway`, `inventory`, `exit`), and `escape` for menu closure【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L295-L342】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L489-L491】
- **Control flow:** a tight loop draws markers for storage, cash, wardrobe and exit when inside an apartment; moving too far or interacting with the exit triggers instance leave and teleports the player outside.
- **Security notes:** server trusts entire `apptdetails` payload on save; stash/outfit commands are chat-based with no permission checks.
- **Performance considerations:** continuous polling occurs whenever `inappt` is true. Weapon and inventory actions debounce clicks to mitigate spam.

### cl_instancing.lua
*Role:* Hides non-instance players and suppresses traffic density while inside apartment instances.

- Maintains `instanced` status, roster (`myinstance`), and optional debug overlay.
- Each frame adjusts vehicle density and player visibility based on membership【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L14-L52】
- **Events handled:** join/update/leave/debug to manage instance membership or toggle diagnostics【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L55-L74】
- **Export:** `inInstance()` returns current instanced flag, backing the manifest export.

### gui/ui.html
*Role:* Static HTML structure for the action menu. Contains main menu buttons for weapons, inventory and other actions, and an exit button.

### gui/ui.js
*Role:* Browser script that manages menu navigation and forwards actions to Lua.

- Receives `showmenu`/`hidemenu` messages from Lua to display or hide the menu, carrying a JSON weapon list when shown【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L17-L31】
- Builds weapon submenus via `parseWeapons` and references an undefined `parseItems` for inventory rendering【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L55-L75】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L115-L120】
- Button clicks send `weaponInfo`, `weaponEquip`, `ButtonClick` or `inventoryTake` NUI callbacks to Lua【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L83-L104】
- ESC key posts `escape` to close the menu【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L135-L140】

### gui/ui.css
*Role:* Basic styling for the menu using Roboto font, with hover colours for buttons.

## Server
### server.lua
*Role:* Tracks apartment slots, persists state, and proxies chat commands to clients.

- **State:** `apartments` table records occupancy and instance IDs (index `6` missing in declaration)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L1-L52】
- **Events:**
  - `fsn_apartments:getApartment` looks up ownership by `char_id`, assigns a free slot and sends details, otherwise starts character creation【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L71-L86】
  - `fsn_apartments:createApartment` inserts a new row then responds with basic apartment data【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L97-L124】
  - `fsn_apartments:saveApartment` writes inventory, cash, outfits and utilities back to the database using prepared parameters【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L126-L137】
  - `playerDropped` frees the occupied slot when an owner disconnects【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L88-L95】
- **Commands:** parsed via `chatMessage` and routed to client events for stash and outfit operations【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L187】
- **Database:** relies on synchronous `MySQL.Sync.fetchAll`/`execute` calls against table `fsn_apartments` (`apt_id`, `apt_owner`, `apt_inventory`, `apt_cash`, `apt_outfits`, `apt_utils`)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L74-L76】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L130-L136】
- **Security:** no validation of client-supplied `apptdetails`; chat commands lack role checks.
- **Performance considerations:** synchronous MySQL calls block the server thread; large `apartments` table scanning occurs on each slot request.

### sv_instancing.lua
*Role:* Maintains server-side instance roster and relays membership updates to clients.

- Keeps list of instances `{id, players, created}`.
- **Events:**
  - `fsn_apartments:instance:new` ensures caller is not already in an instance, creates a new entry, and notifies the player【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L24-L40】
  - `fsn_apartments:instance:join` adds the player to an existing instance and broadcasts roster updates; warns on invalid IDs【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L42-L61】
  - `fsn_apartments:instance:leave` removes a player from whatever instance they occupy and notifies remaining members【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L9-L22】
- Utilises local `table.contains` helper to check membership【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L63-L70】

## Shared
### fxmanifest.lua
*Role:* Manifest declaring scripts, dependencies, NUI resources and exports.*

- Lists required client/server utils and MySQL library, then includes this resource’s client and server scripts【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/fxmanifest.lua†L8-L29】
- Defines NUI page and related files【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/fxmanifest.lua†L31-L37】
- Exposes `inInstance`, `isNearStorage`, and `EnterMyApartment` for external use【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/fxmanifest.lua†L40-L45】

## Cross References
### Events
| Event | Side | Description |
|-------|------|-------------|
| fsn_apartments:getApartment | Server | Retrieve apartment data for a character. |
| fsn_apartments:sendApartment | Client | Receive apartment number and content from server. |
| fsn_apartments:createApartment | Server | Create a new apartment row and send details. |
| fsn_apartments:saveApartment | Client→Server | Persist inventory, cash, outfits and utilities. |
| fsn_apartments:stash:add | Client | Deposit wallet cash into stash. |
| fsn_apartments:stash:take | Client | Withdraw stash cash to wallet. |
| fsn_apartments:outfit:add | Client | Save current clothing preset. |
| fsn_apartments:outfit:use | Client | Equip saved outfit. |
| fsn_apartments:outfit:remove | Client | Delete saved outfit. |
| fsn_apartments:outfit:list | Client | List saved outfit names. |
| fsn_apartments:inv:update | Client | Replace local inventory grid. |
| fsn_apartments:characterCreation | Client | Enter character creator interior. |
| fsn_apartments:instance:new | Server | Allocate a fresh instance for requester. |
| fsn_apartments:instance:join | Client & Server | Join an instance / confirm join. |
| fsn_apartments:instance:update | Client | Receive updated roster for current instance. |
| fsn_apartments:instance:leave | Client & Server | Leave instance / acknowledge exit. |
| fsn_apartments:instance:debug | Client | Toggle instance debug overlay. |

### ESX Callbacks
None.

### Exports
| Function | Description |
|----------|-------------|
| inInstance | Returns `true` if the player is inside an apartment instance. |
| isNearStorage | Indicates whether the player is inside the storage marker. |
| EnterMyApartment | Teleports the player into their assigned apartment. |

### Commands
| Command | Description |
|---------|-------------|
| /stash add {amount} | Transfer wallet cash into apartment stash (max 150k). |
| /stash take {amount} | Withdraw from stash to wallet. |
| /outfit add {name} | Save current outfit to given key. |
| /outfit use {name} | Equip named outfit. |
| /outfit remove {name} | Delete named outfit. |
| /outfit list | List all saved outfit keys. |

### NUI Channels
| Channel | Direction | Payload | Purpose |
|---------|-----------|---------|---------|
| showmenu | Lua→JS | `{ weapons: json }` | Display action menu with weapon list. |
| hidemenu | Lua→JS | none | Hide the action menu. |
| weaponInfo | JS→Lua | weapon object | Display weapon registration info in chat. |
| weaponEquip | JS→Lua | weapon object | Move stored weapon back to player. |
| ButtonClick | JS→Lua | string (`weapon-putaway`/`inventory`/`exit`) | Act on menu selection. |
| inventoryTake | JS→Lua | item identifier | Intended to remove item from stash (handler missing). |
| escape | JS→Lua | none | Close action menu on ESC key. |

## Configuration & Integration
- **Database:** depends on `mysql-async`; table `fsn_apartments` must include `apt_id`, `apt_owner`, `apt_inventory` (JSON), `apt_cash`, `apt_outfits` (JSON) and `apt_utils` (JSON).
- **Dependencies:** integrates with `fsn_main`, `fsn_bank`, `fsn_clothing`, `fsn_inventory`, `fsn_criminalmisc`, and `fsn_notify`.
- **Exports:** other resources can call `inInstance`, `isNearStorage`, and `EnterMyApartment` as declared in the manifest.

## Gaps & Inferences
- `inventoryTake` channel lacks a Lua `RegisterNUICallback`; presumed to remove items from storage (**Inferred – Low**, TODO implement).
- `parseItems` referenced in `ui.js` has no definition, likely intended to render the inventory submenu (**Inferred – Low**, TODO implement or remove).
- `instanceMe` placeholder in `cl_instancing.lua` prints a message but is unused (**Inferred – Low**, leftover from earlier system).
- Client decodes `apt_inventory` yet never uses it, favouring `apt_utils.inventory` (**Inferred – Medium**, legacy structure).
- `apartments` table omits slot index `6`; appears to be an oversight (**Inferred – Low**, verify slot list).
- Variables `building` and `init` are defined but never toggled, suggesting vestigial logic (**Inferred – Low**).
- Server trusts client-provided `apptdetails` when saving, enabling tampering (**Inferred – High**, validate server-side).
- Synchronous `MySQL.Sync` calls may block the server during database operations (**Inferred – Medium**, consider async queries).
- Chat commands execute without permission checks, allowing any player to manipulate stash/outfit data (**Inferred – Medium**, enforce roles).

DOCS COMPLETE
