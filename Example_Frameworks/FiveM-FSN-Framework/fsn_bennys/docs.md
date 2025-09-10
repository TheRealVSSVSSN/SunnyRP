# fsn_bennys Documentation

## Overview
Benny's Motorworks customization interface for the FiveM FSN framework. The resource is entirely client-side and supplies a menu-driven garage that lets players preview and purchase vehicle upgrades.

## Runtime Context
- Runs on the client; no in-resource server scripts.
- Depends on `fsn_main` utilities for drawing prompts and checking player funds.
- Uses `mythic_notify` to display HUD messages.
- Declares MySQL and server-side utilities in the manifest but does not call them directly.

## Client Files
### fxmanifest.lua
**Role:** Manifest

Lists script files and external dependencies for both client and server runtime. Server script entries reference utilities and MySQL libraries from other resources but there are no local server scripts.

### menu.lua
**Role:** Client Library

Implements a reusable menu system used to present modification options.
- `Menu.new` builds a menu with configurable position, size, colors, and control bindings.
- Rendering helpers draw text and info boxes with GTA natives.
- Navigation functions (`Open`, `ChangeMenu`, `Close`, `draw`) manage menu visibility, selection state, and input handling.
- Button constructors (`addButton`, `addPurchase`, `addList`, `addCheckbox`, `addSubMenu`) generate interactive entries.
- `SetMenu` exposes the menu metatable so other scripts can instantiate menus.

**Security & Performance:** Menu drawing and input polling run every frame while the menu is open, which can consume CPU if misused.

### cl_config.lua
**Role:** Client Configuration

Provides data that defines garage behavior.
- `Config.XYZ` specifies garage coordinates where interaction is allowed.
- `Config.prices` contains pricing tables for window tint, resprays, neon options, plates, wheel accessories and colors, and a `mods` table mapping modification IDs to price schemes.
- `Config.ModelBlacklist` lists vehicle models that cannot be customized.
- `Config.lock` and `Config.oldenter` toggle garage access rules.
- `Config.menu` configures control bindings, position, theme, button count, and menu size.

### cl_bennys.lua
**Role:** Client Runtime Logic

Controls player interaction with the garage.
- Establishes a `BennysMenu` instance from `menu.lua` and defines high‑level categories.
- Thread monitors distance to `Config.XYZ`; when close and not already inside, it prompts via `Util.DrawText` and opens the menu on Enter.
- `EnterGarage` verifies the player is driving, disables HUD and controls, and populates the menu with repair and modification options using `AddMod`.
- `BennysMenu:onButtonSelected` uses `fsn_main:fsn_CanAfford` to verify funds and displays results with `mythic_notify:DoHudText`.
- `AddMod` scans available vehicle mods and builds purchase buttons based on `Config.prices.mods`.

**Security & Performance:** Affordability checks are client-side only; final purchase enforcement must occur in another resource. The proximity thread uses a zero‑delay loop which may impact performance when many players are near the garage.

## Meta Files
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
- Monetary validation and notifications rely on exports from external resources.

## Gaps & Inferences
- `Util.DrawText` prompts players near the garage; function comes from `fsn_main` utilities. *Inferred (High).* 
- Purchases only verify affordability on the client and do not deduct money or apply upgrades. Enforcement is presumed to occur elsewhere. *Inferred (Medium).* **TODO:** Identify server-side handler that finalizes transactions.
- `@mysql-async/lib/MySQL.lua` is declared in the manifest despite no database calls. *Inferred (High).* Possibly a leftover dependency.

DOCS COMPLETE
