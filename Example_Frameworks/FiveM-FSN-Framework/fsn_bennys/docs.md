# fsn_bennys Documentation

## Overview
Benny's Motorworks customization interface for the FiveM FSN framework. The resource is entirely client-side and supplies a menu-driven garage that lets players preview and purchase vehicle upgrades.

## Table of Contents
- [Runtime Context](#runtime-context)
- [Client Scripts](#client-scripts)
  - [menu.lua](#menu.lua)
  - [cl_config.lua](#cl_configlua)
  - [cl_bennys.lua](#cl_bennyslua)
- [Server Scripts](#server-scripts)
- [Shared Files](#shared-files)
- [Meta Files](#meta-files)
  - [fxmanifest.lua](#fxmanifestlua)
  - [agents.md](#agentsmd)
- [Cross-Index](#cross-index)
- [Configuration & Integration Points](#configuration--integration-points)
- [Gaps & Inferences](#gaps--inferences)

## Runtime Context
- Runs on the client; no in-resource server scripts.
- Depends on `fsn_main` utilities for drawing prompts and checking player funds.
- Uses `mythic_notify` to display HUD messages.
- Declares MySQL and server-side utilities in the manifest but does not call them directly.

## Client Scripts
### menu.lua
**Role:** Client library for building interactive menus.

- `Menu.new` constructs menu instances with configurable position, size, colors, and control bindings.
- Rendering helpers draw text and informational overlays using GTA natives.
- Navigation helpers (`Open`, `ChangeMenu`, `Close`, `draw`) control visibility, selection, and input polling.
- Button builders (`addButton`, `addPurchase`, `addList`, `addCheckbox`, `addSubMenu`) create interactive entries with optional prices and callbacks.
- `SetMenu` exposes the menu metatable globally so other scripts can instantiate menus.

**Security & Performance:** The `draw` loop executes every frame while menus are open; excessive usage can impact client FPS.

### cl_config.lua
**Role:** Client configuration defining garage behavior and pricing.

- `Config.XYZ` specifies the world coordinates where interaction with the garage is allowed.
- `Config.prices` provides pricing tables for tints, resprays, neon kits, plates, wheel accessories, colors, and a `mods` table mapping modification IDs to costs and increments.
- `Config.ModelBlacklist` prevents specified vehicle models from being customized.
- `Config.lock` and `Config.oldenter` toggle access restrictions and legacy interaction style.
- `Config.menu` sets control bindings, layout, theme, button count, and menu size.

### cl_bennys.lua
**Role:** Client runtime logic handling player interaction with the garage.

- Initializes `BennysMenu` from `menu.lua` and defines high-level modification categories.
- A `Citizen.CreateThread` constantly monitors distance to `Config.XYZ`. When a player approaches and isn't already inside, `Util.DrawText` prompts them to press Enter.
- `EnterGarage` verifies the player is driving, disables radar and controls, sets up the menu, and populates it with repair and modification options via `AddMod`.
- `BennysMenu:onButtonSelected` checks affordability through `fsn_main:fsn_CanAfford` and displays results using `mythic_notify:DoHudText`.
- `AddMod` scans available vehicle mods and generates purchase buttons using `Config.prices.mods` for pricing.

**Security & Performance:** Affordability is verified only on the client; another resource must enforce payment and apply upgrades. The proximity thread uses a zero-delay loop that may affect performance when many players gather nearby.

## Server Scripts
None. The manifest lists server utilities from other resources, but this resource supplies no server-side logic.

## Shared Files
None.

## Meta Files
### fxmanifest.lua
**Role:** Resource manifest.

- Declares `@fsn_main` utilities and `@mysql-async/lib/MySQL.lua` for compatibility with server-side systems.
- Lists local client scripts (`menu.lua`, `cl_config.lua`, `cl_bennys.lua`) but no local server scripts.

### agents.md
Documentation instructions for contributors.

## Cross-Index
| Type | Symbol | Notes |
|------|--------|-------|
| Events (Net/Local) | – | None |
| ESX Callbacks | – | None |
| Exports (used) | `fsn_main:fsn_CanAfford` | Checks player funds |
|  | `mythic_notify:DoHudText` | Shows HUD notifications |
| Commands | – | None |
| NUI Channels | – | None |
| DB Calls | – | None |

## Configuration & Integration Points
- Coordinates and pricing are adjustable in `cl_config.lua`.
- Menu appearance and control bindings are driven by `Config.menu`.
- Monetary validation and HUD messages rely on external exports from `fsn_main` and `mythic_notify`.

## Gaps & Inferences
- `Util.DrawText` used for interaction prompts appears in `fsn_main` utilities. *Inferred (High).* 
- Purchases only check affordability on the client and do not deduct money or apply upgrades. Enforcement is presumed to occur in another resource. *Inferred (Medium).* **TODO:** Identify the server-side handler that finalizes transactions.
- `@mysql-async/lib/MySQL.lua` is declared despite no database usage. *Inferred (High).* Likely a leftover dependency.
- A trailing `SetPlayerControl(PlayerId(),true,256)` is marked as debug and may remain from testing. *Inferred (Low).* Removal is recommended for production.

DOCS COMPLETE

