# fsn_bennys Documentation

## Overview
This resource provides a client-side interface for modifying vehicles at Benny's Motorworks. It defines menu logic, configuration data for available upgrades, and runtime behavior for entering the garage. There is no server-side logic in this resource; monetary checks and notifications rely on external exports.

## Table of Contents
- [fxmanifest.lua](#fxmanifestlua)
- [menu.lua](#menulua)
- [cl_config.lua](#cl_configlua)
- [cl_bennys.lua](#cl_bennyslua)
- [agents.md](#agentsmd)
- [Cross-Index](#cross-index)
- [Gaps & Inferences](#gaps--inferences)

## fxmanifest.lua
**Role:** Manifest

- Declares the resource as `bodacious` for GTA V and provides a brief description.
- Loads shared utilities and server settings from the `fsn_main` resource for both client and server contexts.
- Includes `@mysql-async/lib/MySQL.lua` on the server side even though this resource has no server scripts of its own.
- Registers the client scripts `menu.lua`, `cl_config.lua`, and `cl_bennys.lua`.

## menu.lua
**Role:** Client (Menu Library)

Defines a customizable menu system used by the garage interface.

- `Menu.new` builds a menu instance with position, size, colors, control bindings, and button list.
- Display helpers (`drawMenuText`, `drawInfo`, `drawRightMenuText`) render text and buttons using GTA's drawing natives.
- Interaction methods:
  - `addButton`, `addPurchase`, `addList`, `addCheckbox` create different button types.
  - `addSubMenu` nests menus and tracks navigation history.
  - `Open`, `Close`, and `ChangeMenu` control visibility and navigation, optionally locking player controls.
  - `draw` runs every frame when visible to update selected items, react to input, and display contextual info.
- Utility functions (`showNotification`, `setMaxButtons`, `setColors`, etc.) adjust runtime behavior and styling.
- `SetMenu` returns the menu metatable for external scripts; `cl_bennys.lua` uses this to instantiate its UI.

## cl_config.lua
**Role:** Client (Configuration)

Holds configuration tables for Benny's operations.

- Extensive color lists (`colors`, `mattecolors`, `metalcolors`) define selectable paint options.
- `Config.XYZ` sets the world coordinates where players can access Benny's.
- `Config.prices` organizes pricing for upgrades:
  - Specific sections for window tint, respray categories, neon layout and color, plates, wheel accessories, wheel colors, multiple wheel types, trim colors, and more.
  - The `mods` table maps modification indices to pricing schemes. Each entry either specifies a starting price with an incremental increase per level or a list of predefined options with individual prices.
- `Config.ModelBlacklist` lists vehicle model names that cannot be modified.
- `Config.lock` toggles garage exclusivity when a player is inside.
- `Config.oldenter` enables an alternative method of entering the garage.
- `Config.menu` describes menu behavior: control bindings, position, theme, maximum buttons, and size.

## cl_bennys.lua
**Role:** Client (Garage Logic)

Implements the runtime behavior for entering and using Benny's Motorworks.

- Initializes a menu instance (`BennysMenu`) via the `menu.lua` library and defines high-level categories such as engine, lights, paint, livery, and bumpers.
- `BennysMenu:OnMenuClose` resets the `ingarage` flag when the UI closes.
- `BennysMenu:onButtonSelected` checks if the player can afford a selected option using the external export `fsn_main:fsn_CanAfford`. Results are displayed through `mythic_notify:DoHudText`.
- A perpetual thread monitors the player's distance to `Config.XYZ`. When close enough, it prompts the player (via `Util.DrawText`) to press Enter to enter the garage.
- `EnterGarage` validates that the player is driving, disables HUD and player control, and initializes the menu. It adds a repair option priced by current vehicle damage and generates submenus for each category using `AddMod`.
- `AddMod` inspects available vehicle modifications with GTA natives and populates the menu with purchasable options derived from `Config.prices.mods`.
- Ends with a debug call restoring player control when the script loads.

## agents.md
**Role:** Meta

Contains instructions for contributors on documenting this resource. It does not influence runtime behavior.

## Cross-Index
### Events
- None.

### ESX Callbacks
- None.

### Exports
- Defined: none.
- External usage:
  - `fsn_main:fsn_CanAfford` — checks player funds before purchase (client export).
  - `mythic_notify:DoHudText` — displays HUD messages.

### Commands
- None.

### NUI Channels
- None.

### DB Calls
- None.

## Gaps & Inferences
- **Util.DrawText** is presumed to render on-screen text based on its usage when prompting players to enter the garage. *Inferred (High).* No local definition exists; it likely comes from `fsn_main` utilities.
- Monetary transactions are verified only through the `fsn_main:fsn_CanAfford` export. There is no server-side confirmation in this resource; persistence and money deduction are assumed to be handled elsewhere. *Inferred (Medium).* **TODO:** confirm where final purchase enforcement occurs.
- `mythic_notify:DoHudText` is assumed to send success or error notifications to the player's HUD. *Inferred (High).* 

DOCS COMPLETE
