# fsn_apartments Documentation

## Overview and Runtime Context
Implements apartment interiors for players. Each character receives a room instance that supports cash storage, outfit management, weapon storage and an item stash. Data persists through the `fsn_apartments` MySQL table and the resource coordinates with other FSN systems for banking, clothing, inventory and weapon handling. A browser-based NUI provides in-apartment actions. Client exports allow other scripts to query storage proximity and instance status.

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
  - [NUI Channels](#nui-channels)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## Client
### client.lua
*Role:* Manages apartment interiors and player interaction within them.

- **State:** tracks room number, apartment details, and whether the player is inside an apartment or wardrobe. Inventory utilities are converted from JSON on arrival.
- **Events handled:**
  - `fsn_apartments:stash:add` / `stash:take`: moves wallet cash into or out of the apartment stash after validating amount and balance.
  - `fsn_apartments:sendApartment`: receives `{ number, apptinfo }`; decodes outfit, inventory and utility tables and initialises default storage slots when missing.
  - `fsn_apartments:outfit:add|use|remove|list`: saves, equips, deletes or lists clothing presets when near the wardrobe marker.
  - `fsn_apartments:inv:update`: replaces the cached inventory grid from another resource.
  - `fsn_apartments:characterCreation`: teleports new characters to a creator interior, opens clothing menu and on completion asks the server to create an apartment.
- **Functions:**
  - `EnterRoom(id)` and `EnterMyApartment()` move the player into the interior and request a new instance from the server.
  - `ToggleActionMenu()` opens the NUI, packing weapon and inventory data for display.
  - `isNearStorage()` exposes whether the player is within the storage marker (exported).
  - `saveApartment()` pushes the entire `apptdetails` table to the server for persistence and runs periodically every ten minutes.
- **Control flow:** a main loop draws markers for storage, cash, wardrobe and exit when inside. Leaving the exit returns the player outside and leaves the instance; venturing too far also forces exit.
- **External events:** uses `fsn_bank:change:walletAdd/Minus`, `fsn_clothing:menu`, `clothes:spawn`, `fsn_inventory:apt:recieve`, `fsn_notify:displayNotification`, and `fsn_criminalmisc` weapon helpers.
- **NUI callbacks:** `weaponInfo`, `weaponEquip`, `ButtonClick` (values `weapon-putaway`, `inventory`, `exit`), and `escape` for menu closure.
- **Security notes:** server trusts client-provided `apptdetails` during saves; stash/outfit commands rely on chat without permission checks.
- **Performance:** runs continuous loops when the player owns an apartment and hides other players when inside an instance.

### cl_instancing.lua
*Role:* Client-side instance isolation.*

- Maintains `instanced` flag and `myinstance` information.
- Each frame, hides non-members and reduces vehicle density when inside an instance. Optional debug text shows instance details.
- **Events handled:**
  - `fsn_apartments:instance:join`: marks the player as instanced and records roster.
  - `fsn_apartments:instance:update`: refreshes roster list.
  - `fsn_apartments:instance:leave`: clears state and restores visibility.
  - `fsn_apartments:instance:debug`: toggles debug overlay.
- **Exports:** `inInstance()` reports whether the player is currently instanced.

### gui/ui.html
*Role:* Defines the NUI structure containing a main menu, weapons submenu and placeholder for inventory/other actions. Loads jQuery, `ui.js` and styling.*

### gui/ui.js
*Role:* Browser script for the NUI action menu.*

- Listens for messages from Lua to show or hide the menu; `showmenu` additionally carries a JSON-encoded weapon list.
- Dynamically builds weapon submenus (`parseWeapons`) and is set up to parse inventory via an undefined `parseItems` function.
- Button interactions call back to Lua using `weaponInfo`, `weaponEquip`, `ButtonClick` or `inventoryTake` (when selecting an item), enabling weapon storage/equip actions.
- `document.onkeyup` posts to `escape` when the ESC key is pressed.

### gui/ui.css
*Role:* Provides positioning and styling for the action menu, using Roboto and simple button states.*

## Server
### server.lua
*Role:* Maintains apartment ownership and persistence while translating chat commands into client events.*

- **State:** `apartments` table tracks slots, occupants and instance IDs.
- **Events:**
  - `fsn_apartments:getApartment` (net): lookup by `char_id`; if found, assigns a free slot and sends details with `fsn_apartments:sendApartment`, otherwise triggers `fsn_apartments:characterCreation`.
  - `fsn_apartments:createApartment` (net): inserts a new row then responds with the apartment data.
  - `fsn_apartments:saveApartment` (net): updates inventory, cash, outfits and utilities in the database using prepared parameters.
  - `playerDropped` (local): releases occupancy when an owner disconnects.
- **Commands via `chatMessage`:**
  - `/stash add|take {amt}` → triggers corresponding stash events on the client.
  - `/outfit add|use|remove|list {name}` → forwards to outfit events on the client.
- **Database:** uses `MySQL.Sync.fetchAll` and `MySQL.Sync.execute` against table `fsn_apartments` (`apt_id`, `apt_owner`, `apt_inventory`, `apt_cash`, `apt_outfits`, `apt_utils`).
- **Security:** commands have no role checks; server persists whatever `apptdetails` client supplies.

### sv_instancing.lua
*Role:* Server-side instance manager for apartment interiors.*

- Maintains a list of active instances `{ id, players, created }`.
- **Events:**
  - `fsn_apartments:instance:new`: creates a new instance for the requester after ensuring they aren't already in one, then triggers `fsn_apartments:instance:join` back to that player.
  - `fsn_apartments:instance:join`: adds the caller to an existing instance and broadcasts `fsn_apartments:instance:update` to all members; notifies on invalid IDs.
  - `fsn_apartments:instance:leave`: removes the caller from any instance they are in and informs remaining players via `instance:update` and the leaver via `instance:leave`.
- Utilises a helper `table.contains` to search arrays and prevents multiple membership.

## Shared
### fxmanifest.lua
*Role:* Resource manifest defining scripts, dependencies and exports.*

- Requires `fsn_main` and `mysql-async` and lists client/server script files.
- Specifies NUI page and files (`gui/ui.*`).
- Declares exports `inInstance`, `isNearStorage`, and `EnterMyApartment` for other resources.

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
| Channel | Payload | Purpose |
|---------|---------|---------|
| weaponInfo | weapon object | Display weapon registration info in chat. |
| weaponEquip | weapon object | Move stored weapon back to player. |
| ButtonClick | string (weapon-putaway/inventory/exit) | Act on menu selection. |
| escape | none | Close action menu on ESC key. |
| inventoryTake | item identifier | Intended to remove item from stash (Lua handler missing). |

## Configuration & Integration
- **Database:** relies on `mysql-async`; the table `fsn_apartments` must exist with fields for inventory (JSON), cash, outfits (JSON) and utilities (JSON).
- **Dependencies:** many behaviours depend on external FSN resources: `fsn_main`, `fsn_bank`, `fsn_clothing`, `fsn_inventory`, `fsn_criminalmisc`, and `fsn_notify`.
- **Exports:** other resources can call `inInstance`, `isNearStorage`, and `EnterMyApartment` as declared in the manifest.

## Gaps & Inferences
- `inventoryTake` NUI channel has no corresponding Lua `RegisterNUICallback`; inferred to remove items from apartment storage (**Inferred – Low**, TODO confirm/implement).
- `parseItems` referenced in `ui.js` is missing; inferred to populate the inventory submenu (**Inferred – Low**, TODO implement or remove call).
- `instanceMe` function in `cl_instancing.lua` prints a placeholder message and is unused (**Inferred – Low**, leftover from earlier system).
- Client decodes `apt_inventory` but never uses it, favouring `apt_utils.inventory`; behaviour suggests legacy support (**Inferred – Medium**, confirm data model).
- Server accepts entire `apptdetails` table from client without verification, enabling potential tampering (**Inferred – High**, validate on server).

DOCS COMPLETE
