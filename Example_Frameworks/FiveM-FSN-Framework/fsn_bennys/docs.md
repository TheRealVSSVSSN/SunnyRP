# fsn_bennys Documentation

## Overview
Client-only resource that turns a specific location into a Benny's-style workshop where players can preview and buy vehicle upgrades through a custom menu system.

## Runtime Context
- Runs exclusively on the client; no internal server scripts.
- Activation occurs when a player approaches configured coordinates and presses Enter.
- Depends on `fsn_main` utility exports for drawing screen text and verifying player funds.
- Uses `mythic_notify` to show success or error HUD messages.
- Manifest lists MySQL support but the scripts themselves never query the database.

## Client Scripts
### menu.lua
*Role:* Generic menu framework bundled with the resource.

- **Instantiation** – `Menu.new` builds a menu object with default layout and control bindings.
- **Rendering helpers** – `drawMenuText`, `drawInfo`, and `drawRightMenuText` format text and panels each frame.
- **Lifecycle callbacks** – optional handlers `OnMenuOpen`, `OnMenuChange`, and `OnMenuClose` fire on open, submenu navigation, and closure respectively.
- **Interaction callbacks** – `onButtonSelected`, `onSelectedIndexChanged`, `onCheckboxChange`, and `OnButtonListChange` let consumers react to button presses, list cycling, and checkbox toggles.
- **Button builders** – `addButton`, `addPurchase`, `addList`, `addCheckbox`, and `addSubMenu` create selectable entries, prices, and nested menus.
- **Exposure** – `SetMenu` returns the `Menu` table so other scripts can create instances.

*Performance:* `Menu:Open` spawns a frame loop that draws until closed; excessive usage may reduce FPS.

### cl_config.lua
*Role:* Defines garage coordinates, pricing tables, and menu appearance.

- **Location** – `Config.XYZ` pinpoints the workshop entry in the world.
- **Price structure** – `Config.prices` contains nested tables for window tint, resprays, neon, plates, wheel styles, and mod categories; each entry lists fixed prices or a base price plus per-level increments.
- **Mod cost rules** – `Config.prices.mods` maps GTA mod IDs to `startprice` and `increaseby` values that `AddMod` uses when populating menus.
- **Restrictions** – `Config.ModelBlacklist` blocks specific vehicle models from accessing the garage.
- **Behaviour toggles** – `Config.lock` enables single-user access; `Config.oldenter` switches to a legacy interaction mode.
- **Menu options** – `Config.menu` exposes control bindings, theme, max button count, and menu dimensions.

### cl_bennys.lua
*Role:* Drives player interaction with the garage and leverages the menu library to display upgrade options.

- **Categories table** – a list of mod categories, some including a `requires` field meant to check for existing parts before showing options.
- **State handling** – `ingarage` prevents re-entry; `BennysMenu:OnMenuClose` resets it when the menu closes.
- **Affordability check** – `BennysMenu:onButtonSelected` calls `fsn_main:fsn_CanAfford` and reports via `mythic_notify:DoHudText`.
- **Proximity thread** – continuous loop uses `Util.DrawText` to prompt entry when within 10 units of `Config.XYZ`.
- **Garage entry** – `EnterGarage` disables player control and radar, computes repair cost, and builds category submenus by calling `AddMod` with pricing data from `Config.prices.mods`.
- **Mod builder** – `AddMod` inspects available vehicle modifications, inserts stock and upgrade buttons, and applies incremental pricing.

*Security:* All purchase validation is local; a separate server process must deduct funds and apply chosen mods.

*Performance:* The proximity loop and menu drawing run every frame; multiple nearby players may affect client performance.

## Server Scripts
None included. The manifest loads utility scripts from `fsn_main` and `mysql-async`, but this resource does not provide its own server code.

## Shared Files
None.

## Meta Files
### fxmanifest.lua
*Role:* Declares game version, external dependencies, and client script list.
- Loads client utilities and settings from `fsn_main` and registers `menu.lua`, `cl_config.lua`, and `cl_bennys.lua`.
- Includes server utilities and MySQL library references even though no server script is present.

### agents.md
Internal contributor guidelines.

## Cross-Index
| Type | Symbol | Notes |
|------|--------|-------|
| Events (Local) | `BennysMenu:OnMenuClose` | Clears garage flag when menu closes |
|  | `BennysMenu:onButtonSelected` | Runs affordability check and shows HUD messages |
|  | `Menu:OnMenuOpen` | Optional callback before a menu starts drawing |
|  | `Menu:OnMenuChange` | Fires when switching between menus or submenus |
|  | `Menu:OnMenuClose` | Optional callback after a menu closes |
|  | `Menu:onSelectedIndexChanged` | Invoked when highlighted option changes |
|  | `Menu:onCheckboxChange` | Triggered when a checkbox button toggles |
|  | `Menu:OnButtonListChange` | Runs when cycling through list options |
| ESX Callbacks | – | None |
| Exports (used) | `fsn_main:fsn_CanAfford` | Determines if player can afford an upgrade |
|  | `mythic_notify:DoHudText` | Displays success or error notifications |
| Commands | – | None |
| NUI Channels | – | None |
| DB Calls | – | None |

## Configuration & Integration Points
- Adjust coordinates, prices, and menu theme through `cl_config.lua` settings.
- Utilizes `fsn_main` utility functions such as `Util.DrawText` and the `fsn_CanAfford` export.
- `mythic_notify` handles user-facing HUD notifications.
- Manifest references MySQL and fsn_main server utilities, implying integration with a broader framework for economic and upgrade processing.

## Gaps & Inferences
- `Util.DrawText` originates from `@fsn_main/cl_utils.lua`; this dependency is assumed to exist. *Inferred (High).* 
- No server event deducts money or applies upgrades, indicating another resource finalizes transactions. *Inferred (Medium).* **TODO:** Identify the server-side handler responsible.
- `@mysql-async/lib/MySQL.lua` is declared in `fxmanifest.lua` despite no database usage in this resource. *Inferred (High).* Likely a residual dependency.
- `SetPlayerControl(PlayerId(),true,256)` at the file tail appears to be leftover debug code. *Inferred (Low).* 
- The `requires` field in the categories list is never checked, suggesting incomplete conditional logic. *Inferred (Low).* 

DOCS COMPLETE
