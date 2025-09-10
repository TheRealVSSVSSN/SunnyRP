# fsn_apartments Documentation

## Overview
The **fsn_apartments** resource grants characters a personal apartment with instanced interiors, storage for cash, weapons and outfits, and a simple menu for interacting with that storage. It relies on other FSN components for player data, clothing, inventory and notifications, and persists apartment state in a MySQL table.

## Runtime Context
- Depends on `fsn_main` utilities and settings for character identification and finances.
- Integrates with `fsn_clothing` for outfit snapshots, `fsn_inventory` for item metadata and `fsn_criminalmisc` for weapon information.
- Server uses `mysql-async` synchronously to load and save apartment records.
- NUI menu communicates with the client via custom channels served from `gui/ui.html`.

## File Inventory
| File | Role |
|---|---|
| `fxmanifest.lua` | Resource manifest listing scripts, UI files and exports. |
| `client.lua` | Client logic for apartment entry, storage, outfits and NUI. |
| `cl_instancing.lua` | Client helper for hiding other players while inside an instance. |
| `server.lua` | Server-side persistence, chat commands and stash management. |
| `sv_instancing.lua` | Server controller for instance creation and membership. |
| `gui/ui.html` | NUI page hosting the action menu. |
| `gui/ui.js` | Menu behaviour and NUI channel posts. |
| `gui/ui.css` | Styling for the action menu. |

## Client
### client.lua
Handles apartment state, menu toggling and communication with the server:
- **Cash Stash**: `fsn_apartments:stash:add` and `fsn_apartments:stash:take` adjust the apartment cash reserve. Both check the player is inside the apartment, enforce a per-transaction limit of 150k, and update the server after modifying the balance【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L28-L57】.
- **Receiving Apartment Data**: `fsn_apartments:sendApartment` accepts `{number, apptinfo}` and prepares local caches for outfits, inventory and utilities before notifying the player of their unit number【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L70-L133】.
- **Outfit Management**: Events `fsn_apartments:outfit:add/use/remove/list` operate only when near the wardrobe marker. They save the current outfit via the clothing export, apply stored outfits or enumerate/delete entries, notifying the player when actions succeed or fail【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L139-L196】.
- **Inventory Updates**: `fsn_apartments:inv:update` replaces the local inventory table when external resources send new data【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L290-L293】.
- **NUI Interaction**: `ToggleActionMenu` focuses the NUI, sends the stored weapon list and registers callbacks `weaponInfo`, `weaponEquip`, `ButtonClick` and `escape` to display weapon metadata, equip stored weapons, process menu actions, or close the menu【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L263-L341】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L295-L341】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L489-L490】.
- **Exports**: Provides `EnterMyApartment` to teleport the player into their assigned unit and `isNearStorage` to report proximity to the storage marker【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L66-L68】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L343-L346】.
- **Auto‑save**: A background thread triggers `fsn_apartments:saveApartment` every ten minutes to persist changes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L478-L486】.
- **Character Creation**: `fsn_apartments:characterCreation` moves the player to an interior, opens the clothing menu and on completion requests the server to create a new apartment record【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L445-L466】.

### cl_instancing.lua
Keeps apartment occupants isolated from other players:
- Maintains `instanced` flag and metadata for the current instance. When enabled, players outside the instance are hidden and collisions disabled to prevent interaction【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L5-L53】.
- Handles `fsn_apartments:instance:join/update/leave` to adjust local state and `fsn_apartments:instance:debug` to toggle an on‑screen overlay with instance information【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L55-L74】.
- Exports `inInstance` so other resources can query whether the player is instanced【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L11-L13】.

## Server
### server.lua
Manages apartment assignment and persistence:
- **Apartment Lookup**: `fsn_apartments:getApartment` retrieves the record for a character ID; if none exists the client is sent to character creation. Occupancy is tracked in memory to reuse apartments across sessions【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L71-L86】.
- **Creation**: `fsn_apartments:createApartment` inserts a new row into `fsn_apartments` then assigns the first available unit number and sends the details to the player【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L97-L123】.
- **Saving**: `fsn_apartments:saveApartment` updates inventory, cash, outfits and utility fields using a parameterised query. The call is synchronous, which may block the game thread on slow databases【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L126-L136】.
- **Disconnect Cleanup**: `playerDropped` frees the apartment slot when a player leaves the server【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L88-L94】.
- **Chat Commands**: A `chatMessage` handler interprets `/stash add|take {amount}` and `/outfit add|use|remove|list` and dispatches matching client events without additional permission checks【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L187】.

### sv_instancing.lua
Controls instanced interiors on the server:
- Stores a table of active instances and their member lists.
- `fsn_apartments:instance:new` creates a new instance for the caller after ensuring they are not already in one, then notifies the client to join【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L24-L40】.
- `fsn_apartments:instance:join` adds the caller to an existing instance and updates all occupants; invalid IDs send an error chat message【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L42-L60】.
- `fsn_apartments:instance:leave` removes the player from any instance and informs remaining members to refresh their state【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua†L5-L22】.

## NUI
### gui/ui.html
Loads jQuery, the menu script and stylesheet, presenting a hidden `<div>` that becomes visible when the menu is toggled【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.html†L10-L40】.

### gui/ui.js
Implements the action menu:
- Receives `showmenu` or `hidemenu` messages to display or hide the container and uses `parseWeapons` to populate a weapon submenu【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L17-L74】.
- Buttons post to Lua via `weaponInfo`, `weaponEquip`, `ButtonClick` or `inventoryTake`; submenu navigation invokes `parseWeapons` or an undefined `parseItems` when switching tabs【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L77-L120】.
- `sendData` sends JSON payloads to the resource’s registered NUI callbacks【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L126-L133】.

### gui/ui.css
Styles the menu with centred positioning and white buttons that turn blue on hover【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.css†L3-L25】.

## Cross-Indexes
### Events
| Event | Side | Payload | Purpose |
|---|---|---|---|
| `fsn_apartments:stash:add` | Client handler | `amt` number | Deposit cash into apartment stash. |
| `fsn_apartments:stash:take` | Client handler | `amt` number | Withdraw cash from stash. |
| `fsn_apartments:sendApartment` | Client handler | `{number, apptinfo}` table | Receive apartment metadata from server. |
| `fsn_apartments:outfit:add` | Client handler | `key` string | Save current outfit under name. |
| `fsn_apartments:outfit:use` | Client handler | `key` string | Apply a saved outfit. |
| `fsn_apartments:outfit:remove` | Client handler | `key` string | Delete a saved outfit. |
| `fsn_apartments:outfit:list` | Client handler | none | List saved outfit keys. |
| `fsn_apartments:inv:update` | Client handler | inventory table | Replace cached inventory. |
| `fsn_apartments:characterCreation` | Client handler | none | Begin new-character flow. |
| `fsn_apartments:instance:join` | Both | instance table / none | Join instance (server→client for join result, server handler expects instance ID). |
| `fsn_apartments:instance:new` | Server handler | none | Create a fresh instance for the caller. |
| `fsn_apartments:instance:update` | Client handler / Server trigger | instance table | Refresh instance membership. |
| `fsn_apartments:instance:leave` | Both | none | Exit instance. |
| `fsn_apartments:instance:debug` | Client handler | none | Toggle debug overlay. |
| `fsn_apartments:getApartment` | Server handler | `char_id` number | Fetch apartment record. |
| `fsn_apartments:createApartment` | Server handler | `char_id` number | Insert new apartment row. |
| `fsn_apartments:saveApartment` | Server handler | apartment object | Persist apartment state. |
| `playerDropped` | Server handler | `reason` string | Free occupied apartment when a player disconnects. |
| `chatMessage` | Server handler | `source`, `auth`, `msg` | Parse `/stash` and `/outfit` chat commands. |

### External Events Triggered
| Event | Side | Payload | Purpose |
|---|---|---|---|
| `fsn_bank:change:walletMinus` | Client trigger | `amt` number | Deduct money when depositing to the stash. |
| `fsn_bank:change:walletAdd` | Client trigger | `amt` number | Credit player wallet when withdrawing from stash. |
| `fsn_notify:displayNotification` | Client trigger | message parameters | Show success or error notifications. |
| `chatMessage` | Client trigger | `text` string | Display informational chat lines. |
| `clothes:spawn` | Client trigger | outfit table | Apply a saved outfit on the player. |
| `fsn_criminalmisc:weapons:add:tbl` | Client trigger | weapon data | Give weapon back to the player when equipped. |
| `fsn_criminalmisc:weapons:destroy` | Client trigger | none | Remove weapon entity after storing it. |
| `fsn_inventory:apt:recieve` | Client trigger | apartment ID, slot table | Open apartment inventory in shared inventory UI. |
| `fsn_clothing:menu` | Client trigger | none | Open clothing selection during character creation. |
| `fsn_spawnmanager:start` | Client trigger | boolean | Resume normal spawn flow after creation. |

### ESX Callbacks
None.

### Exports
| Name | Description |
|---|---|
| `inInstance` | Returns whether the player is currently instanced【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L11-L13】. |
| `isNearStorage` | Reports if the player is near the storage marker【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L343-L346】. |
| `EnterMyApartment` | Teleports the player into their assigned apartment【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L66-L68】. |

### Commands
| Command | Effect |
|---|---|
| `/stash add {amount}` | Adds money to stash after client-side validation【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L158】. |
| `/stash take {amount}` | Withdraws money from stash【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L152-L166】. |
| `/outfit add {name}` | Saves current outfit under the given name【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L170-L174】. |
| `/outfit use {name}` | Equips a stored outfit【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L176-L179】. |
| `/outfit remove {name}` | Deletes a stored outfit【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L181-L182】. |
| `/outfit list` | Lists saved outfits in chat【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L184-L185】. |

### NUI Channels
| Channel | Direction | Notes |
|---|---|---|
| `weaponInfo` | NUI → Client | Displays weapon owner data in chat【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L295-L299】. |
| `weaponEquip` | NUI → Client | Moves stored weapon to player inventory【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L301-L315】. |
| `ButtonClick` | NUI → Client | Handles menu actions such as storing weapons or opening inventory【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L316-L342】. |
| `inventoryTake` | NUI → Client | Posted by UI but lacks a Lua handler (see Gaps). |
| `escape` | NUI → Client | Closes the menu on ESC key【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua†L489-L490】. |

### Database
| Operation | Query | Purpose |
|---|---|---|
| SELECT | `SELECT * FROM fsn_apartments WHERE apt_owner = ?` | Retrieve apartment record for a character【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L71-L86】. |
| INSERT | `INSERT INTO fsn_apartments (...) VALUES (...)` | Create a new apartment entry【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L97-L103】. |
| UPDATE | `UPDATE fsn_apartments SET apt_inventory = @inv, apt_cash = @cash, apt_outfits = @outfits, apt_utils = @utils WHERE apt_id = @id` | Persist apartment state【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua†L126-L136】. |

## Configuration & Integration
- Requires the `fsn_apartments` MySQL table with `apt_id`, `apt_owner`, `apt_inventory`, `apt_cash`, `apt_outfits` and `apt_utils` columns.
- Depends on other FSN resources for clothing, inventory, banking, criminal miscellany and notifications.
- Instancing allows multiple players to share one interior; other scripts can query `inInstance` to adapt behaviour accordingly.

## Gaps & Inferences
- **Missing inventory UI**: JavaScript calls `parseItems` with inventory data, but the function is undefined. Inferred to be an item list renderer (Inference: High)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L115-L120】.
- **Unimplemented `inventoryTake` channel**: UI posts to `inventoryTake` yet no `RegisterNUICallback` exists, suggesting intended item removal from storage (Inference: Medium)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js†L98-L100】.
- **`instanceMe` stub**: Client-side instancing helper logs `thiswasremoved`; server instancing now handles isolation (Inference: Low)【F:Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua†L8-L10】.

DOCS COMPLETE
