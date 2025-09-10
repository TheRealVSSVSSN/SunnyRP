# fsn_bennys Documentation

## Overview
fsn_bennys provides a client-only vehicle modification garage. Players can approach a configured location and open a menu to preview upgrades and compute costs. Payment and persistence must be handled by other resources.

## Runtime Context
- Client side only; no internal server scripts.
- Activated when the player is near `Config.XYZ` and presses Enter.
- Depends on `fsn_main` for drawing utilities and a `fsn_CanAfford` export, and `mythic_notify` for HUD messages.
- Manifest declares server utilities and MySQL library but the scripts never issue DB calls.

## File Inventory
- **Client:** `menu.lua`, `cl_config.lua`, `cl_bennys.lua`
- **Meta:** `fxmanifest.lua`, `agents.md`, `docs.md`
- No server or shared scripts.

## Client Files
### menu.lua
Role: Generic menu framework used by the garage.

Responsibilities:
- Constructor `Menu.new` creates menu instances with default layout.
- `Menu:showNotification` displays timed messages.
- `Menu:setMaxButtons` and `Menu:setColors` adjust layout.
- `Menu:Open`, `Menu:ChangeMenu`, and `Menu:Close` control menu visibility and navigation.
- Button builders (`addButton`, `addPurchase`, `addList`, `addCheckbox`, `addSubMenu`, `removeButton`) populate menus.
- `Menu:draw` handles per-frame input, selection movement, and optional callbacks:
  - `OnMenuOpen`, `OnMenuChange`, `OnMenuClose`, `onSelectedIndexChanged`, `onCheckboxChange`, `OnButtonListChange`.

Performance: `Menu:draw` runs every frame while a menu is open; heavy menus may affect FPS.

### cl_config.lua
Role: Defines garage coordinates, price tables, and menu settings.

Responsibilities:
- Color palettes (`colors`, `metalcolors`, `mattecolors`) for respray options.
- `Config.XYZ` sets the entry coordinates.
- `Config.prices` covers window tint, respray categories (chrome, classic, matte, metallic, metal), neon, plates, wheels, and individual mod categories.
  - Each mod category either specifies a base price plus incremental cost or explicit button list with prices.
- `Config.ModelBlacklist` lists disallowed vehicles.
- `Config.lock` prevents multiple users; `Config.oldenter` toggles legacy entry.
- `Config.menu` sets control bindings, position/theme, max button count, and dimensions.

### cl_bennys.lua
Role: Orchestrates garage interaction and menu logic.

Responsibilities:
- `categories` table lists mod groups; some have a `requires` flag for prerequisite parts (unused).
- State variable `ingarage` blocks re-entry; `BennysMenu:OnMenuClose` resets it.
- `BennysMenu:onButtonSelected` checks affordability via `fsn_main:fsn_CanAfford` and reports with `mythic_notify:DoHudText`.
- Proximity thread prompts entry and calls `EnterGarage` when the player presses Enter near `Config.XYZ`.
- `EnterGarage` freezes controls, calculates repair price, configures menu appearance, adds a repair button, builds category submenus using `AddMod`, then opens the menu.
- `AddMod` inspects available vehicle modifications, adds stock and upgrade options, and computes incremental pricing from `Config.prices.mods`.

Security/Permissions: Purchase validation is purely client-side; another resource must deduct money and apply vehicle mods.

Performance: The proximity loop and menu drawing run every frame; multiple players may lower FPS. Debug line `SetPlayerControl(PlayerId(),true,256)` left enabled.

## Meta Files
### fxmanifest.lua
- Declares game version.
- Preloads utilities from `fsn_main` and `mysql-async`.
- Registers client scripts `menu.lua`, `cl_config.lua`, `cl_bennys.lua`.
- References server utilities although no server scripts are included.

### agents.md
Contributor guidelines for this resource.

### docs.md
This documentation.

## Cross-Index
| Type | Symbol | Notes |
|------|--------|-------|
| Events (Local) | `BennysMenu:OnMenuClose` | Clears garage state when menu closes |
|  | `BennysMenu:onButtonSelected` | Runs affordability check and shows HUD messages |
|  | `Menu:OnMenuOpen` | Optional callback before menu drawing starts |
|  | `Menu:OnMenuChange` | Fires when switching menus or submenus |
|  | `Menu:OnMenuClose` | Optional callback after menu closes |
|  | `Menu:onSelectedIndexChanged` | Invoked when highlighted option changes |
|  | `Menu:onCheckboxChange` | Triggered when a checkbox toggles |
|  | `Menu:OnButtonListChange` | Runs when cycling through list choices |
| ESX Callbacks | – | None |
| Exports (used) | `fsn_main:fsn_CanAfford` | Determines if player can afford an upgrade |
|  | `mythic_notify:DoHudText` | Displays success or error notifications |
| Commands | – | None |
| NUI Channels | – | None |
| DB Calls | – | None |

## Configuration & Integration Points
- Adjust coordinates, prices, and menu appearance through `cl_config.lua`.
- Relies on `fsn_main` for `Util.DrawText` and affordability checks.
- Uses `mythic_notify` for HUD notifications.
- Manifest includes MySQL and server utility references, implying integration with a broader economy/modification system.

## Gaps & Inferences
- `Util.DrawText` is provided by `@fsn_main/cl_utils.lua`; no direct reference within this resource. *Inferred (High).*
- No server-side handler deducts funds or applies chosen mods, suggesting responsibility lies elsewhere. *Inferred (Medium).* **TODO:** Identify the server resource managing purchases.
- `fxmanifest.lua` lists server utilities and MySQL despite absence of server code, likely a framework convention. *Inferred (High).*
- Debug call `SetPlayerControl(PlayerId(),true,256)` appears leftover and may re-enable controls unexpectedly. *Inferred (Low).*
- The `requires` field in the `categories` list is unused, implying incomplete prerequisite logic. *Inferred (Low).*

DOCS COMPLETE
