# fsn_apartments Documentation

## Overview
The **fsn_apartments** resource provides basic apartment functionality for the FSN framework. It assigns players an apartment, manages personal storage and outfits, and handles instanced interiors so multiple players can use the same interior without seeing each other.

## Table of Contents
- [fxmanifest.lua](#fxmanifestlua)
- [Client Scripts](#client-scripts)
  - [client.lua](#clientlua)
  - [cl_instancing.lua](#cl_instancinglua)
- [Server Scripts](#server-scripts)
  - [server.lua](#serverlua)
  - [sv_instancing.lua](#sv_instancinglua)
- [NUI](#nui)
  - [gui/ui.html](#guiuihtml)
  - [gui/ui.js](#guiuijs)
  - [gui/ui.css](#guiuicss)
- [Cross-Indexes](#cross-indexes)
  - [Events](#events)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Channels](#nui-channels)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## fxmanifest.lua
Defines the resource metadata, client/server scripts, NUI page, and exports. It pulls utilities from `fsn_main` and MySQL support from `mysql-async`. The manifest exports three client-side helpers: `inInstance`, `isNearStorage`, and `EnterMyApartment`【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/fxmanifest.lua†L1-L45】.

## Client Scripts
### client.lua
Main client logic controlling apartment entry, storage, outfits, and NUI communication.
- Tracks the player’s assigned apartment and caches details sent from the server.
- Provides stash functionality (`fsn_apartments:stash:add` / `fsn_apartments:stash:take`) with cash limits and balance checks.
- Manages outfit storage through events (`fsn_apartments:outfit:add/use/remove/list`).
- Handles instance entry/exit by requesting new instances from the server.
- Exposes `EnterMyApartment` for other resources and `isNearStorage` to let scripts check proximity to the storage marker【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L66-L75】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L292-L345】.
- Registers NUI callbacks for weapon info, equipping, general button actions, and closing the UI. These callbacks manipulate the local apartment state and trigger saves to the server【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L295-L322】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L478-L491】.
- Periodically auto-saves apartment data every ten minutes via `fsn_apartments:saveApartment`【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L478-L486】.

### cl_instancing.lua
Optional instancing layer that hides players from each other when inside an apartment.
- Maintains instance membership state and optionally displays debug information.
- Events `fsn_apartments:instance:join/update/leave/debug` toggle membership and debug mode, while `inInstance` reports whether the local player is currently instanced【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L5-L75】.

## Server Scripts
### server.lua
Backend for apartment persistence and chat-driven commands.
- Assigns apartments and loads saved data when `fsn_apartments:getApartment` is triggered, creating a new record if needed【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L71-L86】.
- Inserts new apartments (`fsn_apartments:createApartment`) and updates existing ones (`fsn_apartments:saveApartment`) using synchronous MySQL queries【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L97-L136】.
- Cleans up occupancy when players disconnect via the `playerDropped` handler.
- Processes chat commands for stashing cash and managing outfits, dispatching corresponding client events【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L140-L188】.

### sv_instancing.lua
Server-side controller for instanced interiors.
- Tracks active instances and membership lists.
- Events `fsn_apartments:instance:new/join/leave` create or modify instances and notify all participants with updates【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L1-L61】.

## NUI
### gui/ui.html
Defines a simple action menu with buttons for weapon management, inventory access, and an exit control. The page loads jQuery and the accompanying script and stylesheet【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.html†L9-L40】.

### gui/ui.js
Implements the menu logic:
- Listens for messages from Lua to show or hide the menu and receives weapon data payloads.
- Dynamically builds weapon submenus and sends user actions back to Lua with `$.post` calls to named channels (e.g., `weaponInfo`, `ButtonClick`).
- Includes rate-limited handlers to prevent rapid repeated actions. A call to `parseItems` is present but undefined, implying incomplete inventory UI support【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L17-L119】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L126-L139】.

### gui/ui.css
Provides basic styling for the menu, positioning it near the center of the screen and giving buttons a white theme with blue hover state【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.css†L1-L25】.

## Cross-Indexes
### Events
| Event | Side | Purpose |
|---|---|---|
| fsn_apartments:stash:add / take | Client | Adjusts apartment cash balance. |
| fsn_apartments:sendApartment | Client | Receives apartment data from server. |
| fsn_apartments:outfit:add/use/remove/list | Client | Manage saved outfits. |
| fsn_apartments:inv:update | Client | Refreshes NUI inventory table. |
| fsn_apartments:characterCreation | Client | Opens clothing UI for new characters. |
| fsn_apartments:instance:join/update/leave/debug | Both | Manages instance membership. |
| fsn_apartments:getApartment | Server | Retrieves apartment info for a character. |
| fsn_apartments:createApartment | Server | Creates new apartment records. |
| fsn_apartments:saveApartment | Server | Persists apartment state. |
| fsn_apartments:instance:new/join/leave | Server | Creates or modifies instanced interiors. |

### Exports
| Name | Description |
|---|---|
| inInstance | Returns whether the player is currently in an instance. |
| isNearStorage | Indicates proximity to the apartment storage marker. |
| EnterMyApartment | Teleports the player into their assigned apartment. |

### Commands
| Command | Server Action |
|---|---|
| `/stash add {amount}` | Adds money to apartment stash after client-side validation. |
| `/stash take {amount}` | Withdraws money from the stash. |
| `/outfit add {name}` | Saves current outfit under the given name. |
| `/outfit use {name}` | Applies a saved outfit. |
| `/outfit remove {name}` | Deletes a saved outfit. |
| `/outfit list` | Lists saved outfits in chat. |

### NUI Channels
| Channel | Direction | Notes |
|---|---|---|
| weaponInfo | NUI → Client | Sends weapon metadata to chat. |
| weaponEquip | NUI → Client | Equips a stored weapon. |
| ButtonClick | NUI → Client | Handles menu buttons (store weapon, open inventory, exit). |
| escape | NUI → Client | Closes the menu on ESC key. |
| inventoryTake | NUI → Client | **Undefined callback** referenced in JS; no Lua handler found. |

## Configuration & Integration
- Relies on `fsn_main`, `fsn_clothing`, `fsn_inventory`, and `fsn_criminalmisc` for utilities and inventory or clothing functionality.
- Uses the `fsn_apartments` table with columns `apt_id`, `apt_owner`, `apt_inventory`, `apt_cash`, `apt_outfits`, and `apt_utils` for persistence.
- Instancing allows multiple players to share the same interior without interaction; external scripts can query `inInstance` to adjust behavior.

## Gaps & Inferences
- **parseItems function missing:** UI script calls `parseItems` but no definition exists. Inferred to be an inventory menu builder (Inference: High).
- **inventoryTake callback absent:** JavaScript posts to an `inventoryTake` NUI channel, but no corresponding `RegisterNUICallback` is present. Intended to remove items from storage (Inference: Medium).
- **instanceMe function stubbed:** Client instancing file contains a placeholder function that only logs a message, suggesting prior functionality was removed in favor of server-managed instancing (Inference: Low).

DOCS COMPLETE
