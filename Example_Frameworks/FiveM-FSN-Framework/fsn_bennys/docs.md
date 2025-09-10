# fsn_bennys Documentation

## Overview
Client-only vehicle customization garage for the FSN framework. It provides an in-world Benny's Motorworks that lets players preview and purchase cosmetic and performance upgrades via a menu-driven interface.

## Runtime Context
- Activated by proximity to predefined coordinates; no server-side scripts.
- Relies on utility scripts from `fsn_main` for drawing prompts and checking player funds.
- Uses `mythic_notify` exports to display HUD messages.
- The manifest declares MySQL compatibility but the resource itself does not perform database queries.

## Client Scripts
### menu.lua
*Role:* Reusable menu library that renders interactive lists and handles navigation.

- **Construction** – `Menu.new` builds a menu instance with initial title, header, position and color settings.
- **Display helpers** – internal drawing functions render text blocks and informational overlays each frame.
- **Visibility control** – `Open`, `ChangeMenu`, `Close` toggle menus and manage a stack of previous menus.
- **Button builders** – `addButton`, `addPurchase`, `addList`, `addCheckbox`, and `addSubMenu` create selectable entries with optional prices or nested menus.
- **Input configuration** – exposes `config.controls` so callers can remap navigation keys.
- **Exposure** – `SetMenu` returns the metatable so other scripts can instantiate menus.

*Performance:* `Open` spawns a loop that draws every frame; excessive menu use can affect client FPS.

### cl_config.lua
*Role:* Configuration tables defining garage location, pricing and menu appearance.

- **Coordinates** – `Config.XYZ` sets the world position where interaction is allowed.
- **Pricing** – `Config.prices` contains nested tables for window tints, resprays, mod categories, and other accessories. Each mod type can specify a `startprice` and `increaseby` increment or explicit listings with names and prices.
- **Model restriction** – `Config.ModelBlacklist` prevents listed vehicle models from using the garage.
- **Behaviour toggles** – `Config.lock` controls single-user access; `Config.oldenter` enables a legacy entry flow.
- **Menu layout** – `Config.menu` defines control bindings, theme, maximum buttons and dimensions.

### cl_bennys.lua
*Role:* Runtime client logic that manages player interaction with the garage.

- **State tracking** – `ingarage` flag prevents multiple entries. `BennysMenu:OnMenuClose` resets this state.
- **Selection handling** – `BennysMenu:onButtonSelected` checks affordability via `fsn_main:fsn_CanAfford` and reports status using `mythic_notify:DoHudText`.
- **Proximity loop** – a `Citizen.CreateThread` polls every frame; when within 10 units of `Config.XYZ`, it displays a prompt using `Util.DrawText` and opens the menu when Enter is pressed.
- **Menu population** – `EnterGarage` initializes menu settings, disables radar and player control, calculates repair cost, and creates category submenus by calling `AddMod` for each entry in the `categories` list.
- **Mod builder** – `AddMod` inspects available vehicle modifications, generates purchase options, and applies pricing rules from `Config.prices.mods`.

*Security:* Purchase validation occurs only client-side; another resource must deduct funds and apply upgrades.

*Performance:* The proximity thread and rendering loops run every frame; many nearby players could impact client performance.

## Server Scripts
None.

## Shared Files
None.

## Meta Files
### fxmanifest.lua
*Role:* Resource manifest.
- Declares external dependencies `@fsn_main` and `@mysql-async/lib/MySQL.lua` for compatibility with server utilities.
- Lists local client scripts `menu.lua`, `cl_config.lua`, and `cl_bennys.lua`.

### agents.md
Contributor instructions for maintaining this documentation.

## Cross-Index
| Type | Symbol | Notes |
|------|--------|-------|
| Events (Local) | `BennysMenu:OnMenuClose` | Resets garage state when menu closes |
|  | `BennysMenu:onButtonSelected` | Validates affordability and shows notifications |
| ESX Callbacks | – | None |
| Exports (used) | `fsn_main:fsn_CanAfford` | Checks player funds before purchase |
|  | `mythic_notify:DoHudText` | Displays HUD messages for success or failure |
| Commands | – | None |
| NUI Channels | – | None |
| DB Calls | – | None |

## Configuration & Integration Points
- Adjust coordinates and pricing via `cl_config.lua`.
- Menu appearance and controls derive from `Config.menu` settings.
- Relies on `fsn_main` utility functions and `mythic_notify` for user feedback.

## Gaps & Inferences
- `Util.DrawText` prompt function originates in `fsn_main` utilities. *Inferred (High).* 
- Purchase validation is not enforced server-side; an external resource likely applies charges and upgrades. *Inferred (Medium).* **TODO:** Identify server handler that finalizes transactions.
- `@mysql-async/lib/MySQL.lua` is referenced in the manifest despite no database calls. *Inferred (High).* Possibly a leftover dependency.
- A trailing `SetPlayerControl` call labelled as debug suggests it was used for testing and can be removed. *Inferred (Low).* 

DOCS COMPLETE
