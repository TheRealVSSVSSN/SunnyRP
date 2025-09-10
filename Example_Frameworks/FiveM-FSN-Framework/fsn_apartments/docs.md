# fsn_apartments Documentation

## Overview
The **fsn_apartments** resource gives each character a private apartment interior with instanced separation, cash and weapon storage, outfit snapshots and a basic NUI action menu. It persists apartment state in MySQL and coordinates with other FSN resources for banking, clothing, inventory and weapon handling.

## Runtime Context
- Depends on `fsn_main` for utilities, character IDs and wallet operations.
- Requires `mysql-async` for synchronous database access.
- Integrates with `fsn_clothing`, `fsn_inventory`, `fsn_criminalmisc`, `fsn_notify` and other FSN utilities for outfits, item details, weapon metadata and notifications.
- NUI menu served from `gui/ui.html` communicates with Lua scripts via custom callbacks.

## File Inventory
| File | Type | Role |
|------|------|-----|
| `fxmanifest.lua` | Shared | Declares scripts, dependencies, exports and NUI assets. |
| `client.lua` | Client | Apartment interaction, storage menu and event handling. |
| `cl_instancing.lua` | Client | Hides non‑members while inside an apartment instance. |
| `server.lua` | Server | Database persistence, apartment assignment and chat commands. |
| `sv_instancing.lua` | Server | Tracks instance membership and broadcasts updates. |
| `gui/ui.html` | NUI | Hosts the action menu and loads jQuery, JS and CSS. |
| `gui/ui.js` | NUI | Menu behaviour, weapon list rendering and NUI callbacks. |
| `gui/ui.css` | NUI | Styling for the menu elements. |
| `agents.md` | Docs | Instructions for generating documentation. |
| `docs.md` | Docs | This documentation file. |

## Shared
### fxmanifest.lua
Defines the resource for FiveM, importing core utilities, MySQL library and listing client/server scripts. It registers the NUI page and exports `inInstance`, `isNearStorage` and `EnterMyApartment` for other resources【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/fxmanifest.lua†L1-L45】.

## Client
### client.lua
Responsible for most gameplay features:
- **Stash Cash**: Events `fsn_apartments:stash:add` and `fsn_apartments:stash:take` adjust the apartment cash balance if the player is inside and within the $150k limit, triggering wallet updates and server saves【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L28-L57】.
- **Receive Apartment Data**: `fsn_apartments:sendApartment` stores the apartment number, decodes JSON fields for outfits, inventory and utilities, initializes defaults and informs the player of their unit【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L70-L133】.
- **Outfit Management**: Events `fsn_apartments:outfit:add/use/remove/list` operate near the wardrobe marker to save, apply or delete outfits using exports from the clothing system【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L139-L196】.
- **Action Menu**: `ToggleActionMenu` focuses the NUI, sends the weapon list and registers callbacks `weaponInfo`, `weaponEquip`, `ButtonClick` and `escape` to display metadata, equip weapons, process menu actions or close the menu【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L263-L341】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L295-L342】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L489-L490】.
- **Inventory Updates**: `fsn_apartments:inv:update` refreshes the cached inventory table when other resources send data【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L290-L293】.
- **Exports**: Provides `EnterMyApartment` to teleport the player into their unit and `isNearStorage` to report proximity to the storage marker【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L66-L68】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L343-L346】.
- **Character Creation**: `fsn_apartments:characterCreation` moves the player into a creation interior, opens the clothing menu and requests the server to create a new apartment on completion【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L445-L466】.
- **Auto‑Save**: A background thread calls `fsn_apartments:saveApartment` every ten minutes to persist state【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L478-L486】.

### cl_instancing.lua
Maintains client‑side instancing:
- Tracks whether the player is instanced and which players share that instance. Non‑members are hidden and collision disabled; normal visibility resumes when leaving【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L5-L53】.
- Handles `fsn_apartments:instance:join/update/leave` to adjust local membership and `fsn_apartments:instance:debug` to toggle on‑screen debug information【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L55-L74】.
- Exports `inInstance` so other resources can check instancing status【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L11-L13】.

## Server
### server.lua
Provides persistence and chat command handling:
- **Apartment Lookup**: `fsn_apartments:getApartment` searches the `fsn_apartments` table for the character ID and either sends existing data or initiates character creation. An in‑memory table tracks which unit numbers are occupied【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L71-L86】.
- **Creation**: `fsn_apartments:createApartment` inserts a new row then assigns the first free unit to the caller, returning the details to the client【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L97-L123】.
- **Saving**: `fsn_apartments:saveApartment` updates inventory, cash, outfits and utilities using a parameterised synchronous query; delays in the database thread will block gameplay【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L126-L136】.
- **Disconnect Cleanup**: `playerDropped` frees the apartment slot when a player leaves the server【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L88-L94】.
- **Chat Commands**: A `chatMessage` handler parses `/stash add|take` and `/outfit add|use|remove|list` then dispatches the matching client events without additional server‑side validation【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L187】.

### sv_instancing.lua
Implements instance management on the server:
- Keeps a table of active instances and their member lists.
- `fsn_apartments:instance:new` creates a fresh instance for the caller if they are not already in one, then tells the client to join【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L24-L40】.
- `fsn_apartments:instance:join` adds the caller to an existing instance and broadcasts updated membership to all occupants; invalid IDs prompt an error chat message【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L42-L60】.
- `fsn_apartments:instance:leave` removes the player from their instance and notifies remaining members to refresh【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L5-L22】.

## NUI
### gui/ui.html
Loads jQuery, the menu script and stylesheet, then displays a hidden container with buttons for weapons, inventory and other actions【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.html†L10-L40】.

### gui/ui.js
Controls the menu interface:
- Listens for `showmenu`/`hidemenu` messages to toggle visibility and uses `parseWeapons` to populate a submenu with stored weapons【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L17-L74】.
- Button clicks post to Lua via `weaponInfo`, `weaponEquip`, `ButtonClick` or `inventoryTake`; submenu navigation invokes `parseWeapons` or a missing `parseItems` function when switching tabs【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L77-L120】.
- `sendData` wraps the NUI → Lua post interface【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L126-L133】.

### gui/ui.css
Applies centered positioning and simple white buttons that turn blue on hover【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.css†L3-L25】.

## Documentation
### agents.md
Resource‑specific documentation instructions; no runtime effect.

### docs.md
This file.

## Cross-Indexes
### Events
| Event | Side | Payload | Purpose |
|---|---|---|---|
| `fsn_apartments:stash:add` | Client handler | `amt` number | Deposit cash into stash. |
| `fsn_apartments:stash:take` | Client handler | `amt` number | Withdraw cash from stash. |
| `fsn_apartments:sendApartment` | Client handler | `{number, apptinfo}` table | Receive apartment metadata. |
| `fsn_apartments:outfit:add` | Client handler | `key` string | Save current outfit. |
| `fsn_apartments:outfit:use` | Client handler | `key` string | Equip a stored outfit. |
| `fsn_apartments:outfit:remove` | Client handler | `key` string | Delete a stored outfit. |
| `fsn_apartments:outfit:list` | Client handler | none | List saved outfit names. |
| `fsn_apartments:inv:update` | Client handler | inventory table | Replace cached inventory. |
| `fsn_apartments:characterCreation` | Client handler | none | Start new-character flow. |
| `fsn_apartments:instance:join` | Client & Server | instance table / instance ID | Join instance or confirm membership. |
| `fsn_apartments:instance:new` | Server handler | none | Create a new instance for caller. |
| `fsn_apartments:instance:update` | Client handler / Server trigger | instance table | Refresh instance membership. |
| `fsn_apartments:instance:leave` | Client & Server | none | Exit instance. |
| `fsn_apartments:instance:debug` | Client handler | none | Toggle debug overlay. |
| `fsn_apartments:getApartment` | Server handler | `char_id` number | Fetch apartment record. |
| `fsn_apartments:createApartment` | Server handler | `char_id` number | Insert new apartment row. |
| `fsn_apartments:saveApartment` | Server handler | apartment object | Persist apartment state. |
| `playerDropped` | Server handler | `reason` string | Release occupied unit on disconnect. |
| `chatMessage` | Server handler | `source`, `auth`, `msg` | Parse `/stash` and `/outfit` commands. |

### External Events Triggered
| Event | Side | Payload | Purpose |
|---|---|---|---|
| `fsn_bank:change:walletMinus` | Client trigger | `amt` | Deduct wallet when depositing. |
| `fsn_bank:change:walletAdd` | Client trigger | `amt` | Credit wallet when withdrawing. |
| `fsn_notify:displayNotification` | Client trigger | message params | Show success or error messages. |
| `chatMessage` | Client trigger | `text` | Display informational chat lines. |
| `clothes:spawn` | Client trigger | outfit table | Apply a saved outfit. |
| `fsn_criminalmisc:weapons:add:tbl` | Client trigger | weapon data | Return stored weapon to player. |
| `fsn_criminalmisc:weapons:destroy` | Client trigger | none | Remove weapon entity after storing. |
| `fsn_inventory:apt:recieve` | Client trigger | apartment ID, slot table | Open apartment inventory UI. |
| `fsn_clothing:menu` | Client trigger | none | Open clothing menu during creation. |
| `fsn_spawnmanager:start` | Client trigger | boolean | Resume normal spawn after creation. |

### ESX Callbacks
None.

### Exports
| Name | Description |
|---|---|
| `inInstance` | Returns whether the player is currently instanced【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L11-L13】. |
| `isNearStorage` | Reports if the player is near the storage marker【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L343-L346】. |
| `EnterMyApartment` | Teleports the player into their assigned unit【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L66-L68】. |

### Commands
| Command | Effect |
|---|---|
| `/stash add {amount}` | Adds money to stash after client-side checks【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L158】. |
| `/stash take {amount}` | Withdraws money from stash【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L166】. |
| `/outfit add {name}` | Saves current outfit under a name【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L170-L174】. |
| `/outfit use {name}` | Equips a stored outfit【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L176-L179】. |
| `/outfit remove {name}` | Deletes a stored outfit【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L181-L182】. |
| `/outfit list` | Lists saved outfits in chat【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L184-L185】. |

### NUI Channels
| Channel | Direction | Notes |
|---|---|---|
| `weaponInfo` | NUI → Client | Displays weapon owner info in chat【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L295-L299】. |
| `weaponEquip` | NUI → Client | Moves stored weapon to player inventory【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L301-L315】. |
| `ButtonClick` | NUI → Client | Handles menu actions like storing weapons or opening inventory【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L316-L342】. |
| `inventoryTake` | NUI → Client | Posted by UI but lacks a matching Lua handler (see Gaps). |
| `escape` | NUI → Client | Closes the menu when ESC is pressed【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L489-L490】. |

### Database
| Operation | Query | Purpose |
|---|---|---|
| SELECT | `SELECT * FROM fsn_apartments WHERE apt_owner = ?` | Retrieve apartment record for a character【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L71-L86】. |
| INSERT | `INSERT INTO fsn_apartments (...) VALUES (...)` | Create a new apartment entry【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L97-L103】. |
| UPDATE | `UPDATE fsn_apartments SET apt_inventory = @inv, apt_cash = @cash, apt_outfits = @outfits, apt_utils = @utils WHERE apt_id = @id` | Persist apartment state【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L126-L136】. |

## Configuration & Integration
- Requires a `fsn_apartments` MySQL table with columns `apt_id`, `apt_owner`, `apt_inventory`, `apt_cash`, `apt_outfits` and `apt_utils`.
- Relies on other FSN resources for clothing, inventory, banking, notifications and weapon metadata.
- Instancing lets multiple players share one interior; other scripts can query `inInstance` to adjust behaviour.

## Gaps & Inferences
- **Missing `parseItems` function**: UI references `parseItems` when opening the inventory tab; inferred to render inventory contents (Inference: High)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L115-L120】.
- **Unimplemented `inventoryTake` channel**: UI posts to `inventoryTake` yet no `RegisterNUICallback` exists, suggesting intended item removal from storage (Inference: Medium)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L98-L100】.
- **`instanceMe` stub**: Client instancing helper logs `thiswasremoved`; server instancing now handles isolation (Inference: Low)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L8-L10】.
- **Server trusts client data**: `/stash` and `/outfit` commands forward directly to clients, and `saveApartment` accepts full apartment objects without ownership checks; malicious clients could tamper with cash or inventory (Inference: Medium)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L126-L136】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L187】.

DOCS COMPLETE
