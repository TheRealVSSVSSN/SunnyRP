# fsn_bennys Documentation

## Overview
fsn_bennys implements a client-only Benny's workshop allowing players to preview and purchase vehicle modifications at a fixed garage location. It supplies a generic menu library and configuration data but leaves payment handling and persistence to external resources.

## Runtime Context
- Runs exclusively on the client; manifest preloads server utilities but no server script is present.
- Active when the player is within range of `Config.XYZ` and presses the Enter control.
- Relies on `fsn_main` for drawing utilities and the `fsn_CanAfford` export, and on `mythic_notify` for HUD messages.
- The manifest references MySQL but the scripts never issue database queries.

## File Inventory
- **Client:** [`menu.lua`](#menulua), [`cl_config.lua`](#cl_configlua), [`cl_bennys.lua`](#cl_bennyslua)
- **Meta:** [`fxmanifest.lua`](#fxmanifestlua), [`agents.md`](#agentsmd), [`docs.md`](#docsmd)
- No server or shared files.

## Client Files
### menu.lua
Role: Stand‑alone menu framework used to render options and handle input.

Responsibilities:
- `Menu.new` constructs menu objects with layout, control bindings, and default colours.
- `Menu:showNotification` displays temporary banner messages.
- Layout helpers `setMaxButtons` and `setColors` configure appearance.
- Navigation helpers `Open`, `ChangeMenu`, and `Close` control visibility and stack state.
- Button helpers `addButton`, `addPurchase`, `addList`, `addCheckbox`, `addSubMenu`, and `removeButton` build menu contents.
- `Menu:draw` processes per‑frame input, renders buttons, and fires optional callbacks: `OnMenuOpen`, `OnMenuChange`, `OnMenuClose`, `onSelectedIndexChanged`, `onCheckboxChange`, and `OnButtonListChange`.

Performance: `Menu:draw` executes every frame while a menu is visible; complex menus may impact client FPS.

### cl_config.lua
Role: Centralises garage coordinates, colour palettes, price tables, and menu settings.

Responsibilities:
- Defines colour lists (`colors`, `metalcolors`, `mattecolors`) used for respray options.
- `Config.XYZ` sets the entry point for the garage marker.
- `Config.prices` enumerates costs for tints, respray categories (chrome, classic, matte, metallic, metal), neon, plates, wheels, and individual modification categories. Each mod category can use incremental pricing or explicit price lists.
- `Config.ModelBlacklist` blocks specific vehicles from modification.
- `Config.lock` and `Config.oldenter` are defined but not referenced in the client script. *Inferred (Low).*
- `Config.menu` specifies control bindings, screen position, theme, maximum buttons, and dimensions.

### cl_bennys.lua
Role: Coordinates interaction flow and menu population for Benny's workshop.

Responsibilities:
- Maintains an `ingarage` flag to prevent concurrent use; `BennysMenu:OnMenuClose` resets it on exit.
- `BennysMenu:onButtonSelected` checks affordability using `fsn_main:fsn_CanAfford` and reports results via `mythic_notify:DoHudText`.
- A proximity thread displays an entry prompt with `Util.DrawText` and calls `EnterGarage` when the player presses Enter within range.
- `EnterGarage` freezes player control, computes repair cost, configures menu appearance, adds a repair option, builds category submenus through `AddMod`, and opens the menu.
- `AddMod` inspects available vehicle modifications, generates stock and upgrade entries, and applies pricing rules from `Config.prices.mods`.

Security/Permissions: Purchase checks occur purely on the client; another resource must deduct funds and apply chosen modifications. *Inferred (Medium).* 

Performance: The proximity loop and menu drawing run every frame; widespread use can lower FPS. A debug call `SetPlayerControl(PlayerId(),true,256)` at file end may unintentionally re‑enable control. *Inferred (Low).*

## Meta Files
### fxmanifest.lua
- Declares game version and description.
- Preloads utilities from `fsn_main` and `mysql-async`.
- Registers client scripts `menu.lua`, `cl_config.lua`, and `cl_bennys.lua`.
- Lists server utilities although no server scripts reside in this resource. *Inferred (High).* 

### agents.md
Contributor instructions for documenting this resource.

### docs.md
This documentation file.

## Cross-Index
| Type | Symbol | Notes |
|------|--------|-------|
| Events (Local) | `BennysMenu:OnMenuClose` | Clears garage state when menu closes |
|  | `BennysMenu:onButtonSelected` | Validates funds and shows HUD messages |
|  | `Menu:OnMenuOpen` | Optional callback before menu drawing starts |
|  | `Menu:OnMenuChange` | Fires when switching menus or submenus |
|  | `Menu:OnMenuClose` | Optional callback after menu closes |
|  | `Menu:onSelectedIndexChanged` | Invoked when highlighted option changes |
|  | `Menu:onCheckboxChange` | Triggered when a checkbox toggles |
|  | `Menu:OnButtonListChange` | Runs when cycling through list choices |
| ESX Callbacks | – | None |
| Exports (used) | `fsn_main:fsn_CanAfford` | Determines if player can afford an upgrade |
|  | `mythic_notify:DoHudText` | Displays success or error notifications |
| Exports (provided) | – | None |
| Commands | – | None |
| NUI Channels | – | None |
| DB Calls | – | None |

## Configuration & Integration Points
- Coordinates, prices, and menu appearance are adjustable through `cl_config.lua`.
- Relies on `fsn_main` for `Util.DrawText` and financial checks.
- Uses `mythic_notify` for on‑screen messages.
- The manifest suggests integration with a wider economy or modification system due to MySQL and server utility references.

## Gaps & Inferences
- `Util.DrawText` originates from `@fsn_main/cl_utils.lua`; not defined in this resource. *Inferred (High).* 
- No server component handles payment or applies selected mods. *TODO:* identify the server resource responsible. *Inferred (Medium).* 
- `fxmanifest.lua` includes server utilities and MySQL despite no server code, likely a framework convention. *Inferred (High).* 
- Debug call `SetPlayerControl(PlayerId(),true,256)` may re‑enable controls unexpectedly. *Inferred (Low).* 
- The `requires` field in `categories` is unused, indicating incomplete prerequisite logic. *Inferred (Low).* 
- `Config.lock` and `Config.oldenter` options are unused in current client logic. *Inferred (Low).* 

DOCS COMPLETE
