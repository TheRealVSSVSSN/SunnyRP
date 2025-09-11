# fsn_bennys Documentation

## Overview
fsn_bennys provides a client-side Benny's workshop where players inspect and buy vehicle upgrades at a fixed world location. It bundles a generic menu system and extensive price/configuration tables but leaves money handling and persistence to other resources.

## Runtime Context
- Loaded only on the client through the manifest; no server scripts are referenced.
- Activates when a player stands near the configured garage coordinates and presses the Enter key.
- Depends on `@fsn_main` for drawing helpers and the `fsn_CanAfford` export, and on `mythic_notify` for HUD messaging.

## File Inventory
- **Client:** [`menu.lua`](#menulua), [`cl_config.lua`](#cl_configlua), [`cl_bennys.lua`](#cl_bennyslua)
- **Meta:** [`fxmanifest.lua`](#fxmanifestlua), [`agents.md`](#agentsmd), [`docs.md`](#docsmd)
- No server, shared, or NUI assets.

## Client Files
### menu.lua
Role: Generic menu framework supporting buttons, submenus, lists, and checkboxes.

Responsibilities:
- `Menu.new` creates menu instances with positional and stylistic defaults.
- `Menu:showNotification` spawns a timed thread to display short messages.
- Appearance helpers `setMaxButtons` and `setColors` adjust layout and colors.
- Navigation methods `Open`, `ChangeMenu`, and `Close` manage visibility, menu stack, and player control.
- Content builders `addButton`, `addPurchase`, `addList`, `addCheckbox`, `addSubMenu`, and `removeButton` populate menus.
- `Menu:draw` runs every frame while visible, renders elements, and fires optional callbacks (`OnMenuOpen`, `OnMenuChange`, `OnMenuClose`, `onSelectedIndexChanged`, `onCheckboxChange`, `OnButtonListChange`).

Performance considerations: `Menu:draw` executes in a tight loop and can affect FPS if menus are heavy or numerous.

### cl_config.lua
Role: Houses garage coordinates, color palettes, pricing data, and menu theme settings.

Responsibilities:
- `Config.XYZ` defines the entry marker location for the workshop【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_config.lua†L72-L74】.
- `Config.prices` covers window tints, respray categories, neon layout and color, plates, multiple wheel classes, and a comprehensive `mods` table that sets incremental pricing or explicit price lists for each mod type【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_config.lua†L76-L110】.
- `Config.ModelBlacklist` prevents certain models (e.g., police vehicles) from being modified【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_config.lua†L693-L697】.
- `Config.menu` specifies control bindings, screen position, theme, button count, and dimensions for the UI【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_config.lua†L699-L718】.

### cl_bennys.lua
Role: Orchestrates player interaction with Benny's workshop and builds upgrade menus.

Responsibilities:
- Keeps an `ingarage` flag that resets when the menu closes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L17-L21】.
- `BennysMenu:onButtonSelected` checks affordability through `fsn_main:fsn_CanAfford` and displays success or error messages via `mythic_notify:DoHudText`【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L23-L31】.
- A proximity thread draws a prompt near the workshop and calls `EnterGarage` when Enter is pressed【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L33-L46】.
- `EnterGarage` freezes player control, computes repair cost, sets menu visuals, adds a repair option, invokes `AddMod` for each category, and opens the menu【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L90-L125】.
- `AddMod` inspects available vehicle mods, adds stock and upgrade entries, and applies pricing rules from `Config.prices.mods`【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L56-L88】.

Security/Permissions: All purchase validation occurs client-side; external server logic must enforce payment and apply selected mods. *Inferred (Medium).* 

Performance: The proximity loop now idles when the player is far from the garage, reducing unnecessary CPU usage.

## Meta Files
### fxmanifest.lua
- Declares game build, enables Lua 5.4, and loads shared settings【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/fxmanifest.lua†L1-L9】.
- Registers client scripts `menu.lua`, `cl_config.lua`, and `cl_bennys.lua`【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/fxmanifest.lua†L11-L15】.

### agents.md
Contributor instructions for documenting this resource.

### docs.md
This documentation file.

## Cross-Index
| Type | Symbol | Notes |
|------|--------|-------|
| Events (Local) | `BennysMenu:OnMenuClose` | Clears garage state when menu closes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L17-L21】 |
|  | `BennysMenu:onButtonSelected` | Validates funds and shows HUD messages【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L23-L31】 |
|  | `Menu:OnMenuOpen` | Fires before menu drawing begins【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/menu.lua†L141-L150】 |
|  | `Menu:OnMenuChange` | Invoked when switching menus【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/menu.lua†L188-L195】 |
|  | `Menu:OnMenuClose` | Runs after menu closes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/menu.lua†L200-L205】 |
|  | `Menu:onSelectedIndexChanged` | Triggered when the highlighted option changes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/menu.lua†L382-L385】 |
|  | `Menu:onCheckboxChange` | Fired when a checkbox toggles【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/menu.lua†L418-L423】 |
|  | `Menu:OnButtonListChange` | Called when list selections change【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/menu.lua†L438-L452】 |
| ESX Callbacks | – | None |
| Exports (used) | `fsn_main:fsn_CanAfford` | Determines if player can afford an upgrade【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L24-L28】 |
|  | `mythic_notify:DoHudText` | Displays HUD notifications【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua†L24-L28】 |
| Exports (provided) | – | None |
| Commands | – | None |
| NUI Channels | – | None |
| DB Calls | – | None |

## Configuration & Integration Points
- All coordinates, prices, and menu themes originate from `cl_config.lua`.
- Integrates with `fsn_main` for utility drawing and financial checks, and with `mythic_notify` for player feedback.
- Manifest loads only client utilities and shared settings; persistence and payments remain external.

## Gaps & Inferences
- `Util.DrawText` is supplied by `@fsn_main/cl_utils.lua` and not defined locally. *Inferred (High).* 
- No server component deducts money or applies modifications; another resource must handle these actions. *Inferred (Medium).* 
- The `requires` field in `categories` has no effect because prerequisite logic is absent. *Inferred (Low).*
- `mod_inc` in `EnterGarage` is defined but unused. *Inferred (Low).*

DOCS COMPLETE
