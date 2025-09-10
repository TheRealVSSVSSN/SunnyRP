# fsn_boatshop Documentation

## Overview and Runtime Context
The **fsn_boatshop** resource manages boat sales and rentals at the Los Santos Marina. It spawns showroom vessels, lets authorised staff configure stock, and coordinates with bank and garage systems to transfer money and ownership.

## Table of Contents
- [Shared](#shared)
  - [fxmanifest.lua](#fxmanifestlua)
- [Client Files](#client-files)
  - [cl_boatshop.lua](#cl_boatshoplua)
  - [cl_menu.lua](#cl_menulua)
- [Server Files](#server-files)
  - [sv_boatshop.lua](#sv_boatshoplua)
- [Cross Indexes](#cross-indexes)
  - [Events](#events)
  - [ESX Callbacks](#esx-callbacks)
  - [Exports Used](#exports-used)
  - [Commands](#commands)
  - [NUI Channels](#nui-channels)
  - [Database Calls](#database-calls)
- [Configuration & Integration Points](#configuration--integration-points)
- [Gaps & Inferences](#gaps--inferences)

## Shared
### fxmanifest.lua
Declares the resource for the **bodacious** FX server build and loads utility scripts from **fsn_main** plus the MySQL library. It registers two client scripts (`cl_boatshop.lua`, `cl_menu.lua`) and one server script (`sv_boatshop.lua`).

## Client Files
### cl_boatshop.lua
Controls the in‑world showroom and player interactions.

- **BuyBoat(key)** creates a copy of the selected showroom vessel, builds a default damage and customization profile, charges the player and registers the craft with the garage system before tagging it as owned.
- **RentBoat(key)** spawns a temporary rental boat, charges the rental fee and records the plate to enable later refunds.
- A continuous **Util.Tick** loop keeps each showroom slot populated, resets displaced boats, draws 3D text with pricing and prompts, and restricts purchase or staff options based on job status.
- Network handlers update local slot data and relay staff commands for commission or colour changes back to the server.
- A return thread watches for rented boats arriving at the dock and deletes them while refunding half the price.

### cl_menu.lua
Implements a staging‑area UI for employees to swap showroom models.

- Holds a static boat catalogue identical to the server list.
- **OpenCreator(changingBoat)** moves the player to an isolated area, freezes them and opens the menu for the specified showroom slot.
- **CloseCreator()** returns the player to the marina. If a model was selected, it sends `fsn_boatshop:floor:ChangeBoat` with the chosen model.
- Menu drawing helpers render titles, options and prices; navigation keys move a cursor through up to ten visible buttons.
- `DoesPlayerHaveVehicle` is stubbed with a TODO for ownership checks.

## Server Files
### sv_boatshop.lua
Maintains showroom state and exposes employee commands.

- Defines five showroom slots and a master boat catalogue.
- On `fsn_boatshop:floor:Request`, assigns default boats to empty slots and broadcasts the current table back to the requesting client.
- The **WorksAtStore** helper uses `fsn_jobs:isPlayerClockedInWhitelist` to restrict actions to job whitelist ID `4`.
- A `chatMessage` hook parses employee commands:
  - `/comm <0-30>` sets commission percentage and prompts the client for a value.
  - `/color1 <0-159>` and `/color2 <0-159>` update primary or secondary colours.
  - `/testdrive [end]` toggles a separate test-drive flow for the player.
- Event handlers for `fsn_boatshop:floor:color:One`, `:color:Two`, `:commission` and `:ChangeBoat` mutate slot data, flag it as needing refresh, and broadcast updates to all clients.

## Cross Indexes
### Events
| Event | Direction | Parameters | Notes |
|-------|-----------|------------|-------|
| `fsn_boatshop:floor:Request` | Client → Server | none | Request current showroom data. |
| `fsn_boatshop:floor:Update` | Server → Client | `spots` table | Full showroom state. |
| `fsn_boatshop:floor:Updateboat` | Server → Client | `index`, `spot` | Updated single slot. |
| `fsn_boatshop:floor:commission` | Bidirectional | C→S: `index`, `amount`; S→C: `amount` | Set commission or prompt value. |
| `fsn_boatshop:floor:color:One` | Bidirectional | C→S: `index`, `color`; S→C: `color` | Adjust primary colour. |
| `fsn_boatshop:floor:color:Two` | Bidirectional | C→S: `index`, `color`; S→C: `color` | Adjust secondary colour. |
| `fsn_boatshop:floor:ChangeBoat` | Client → Server | `index`, `model` | Replace showroom boat. |
| `fsn_boatshop:testdrive:start` | Server → Client | none | Inferred: initiates temporary test drive. *(Low)* |
| `fsn_boatshop:testdrive:end` | Server → Client | none | Inferred: ends test drive. *(Low)* |
| `chatMessage` | System → Server | `source`, `author`, `text` | Intercepts chat to parse commands. |
| `fsn_cargarage:buyVehicle` | Client → Server | `charId`, `name`, `model`, `plate`, `details`, `finance`, `type`, `slot` | External garage registration. *(High)* |
| `fsn_cargarage:makeMine` | Client → Client | `vehicle`, `model`, `plate` | External ownership tagging. *(High)* |
| `fsn_bank:change:walletMinus` | Client → Client | `amount` | Deducts funds. *(High)* |
| `fsn_bank:change:walletAdd` | Client → Client | `amount` | Refunds funds. *(High)* |
| `mythic_notify:client:SendAlert` | Server → Client | `type`, `text` | Display notification messages. |

### ESX Callbacks
None.

### Exports Used
| Export | Source | Purpose |
|--------|--------|---------|
| `fsn_main:fsn_CharID` | `fsn_main` | Retrieve player character ID. |
| `fsn_main:fsn_CanAfford` | `fsn_main` | Check player affordability before purchase or rental. |
| `fsn_jobs:isPlayerClockedInWhitelist` | `fsn_jobs` | Verify server-side employee status. |
| `fsn_jobs:isWhitelistClockedIn` | `fsn_jobs` | Verify client-side employee status for prompts. |
| `mythic_notify:DoCustomHudText` | `mythic_notify` | Display HUD notifications to the player. |

### Commands
| Command | Permission | Description |
|---------|------------|-------------|
| `/comm <0-30>` | Boat shop employee | Set commission percentage for nearest slot. |
| `/color1 <0-159>` | Boat shop employee | Set primary colour for nearest slot. |
| `/color2 <0-159>` | Boat shop employee | Set secondary colour for nearest slot. |
| `/testdrive [end]` | Boat shop employee | Start or end a test-drive sequence. |

### NUI Channels
None.

### Database Calls
None.

## Configuration & Integration Points
- Depends on **fsn_main**, **fsn_jobs**, **fsn_bank**, **fsn_cargarage** and **mythic_notify** through the manifest.
- MySQL library is loaded but unused; persistence is deferred to external garage systems.
- Employee checks rely on whitelist ID `4` from **fsn_jobs**.
- Utility helpers such as `Util.DrawText3D`, `Util.Tick` and vector math come from shared FSN modules.

## Gaps & Inferences
- **Test Drive Flow**: `fsn_boatshop:testdrive:start` and `:end` lack handlers in this resource; presumed to spawn and clean up a temporary boat elsewhere. *(Inferred: Low)*
- **External Economy & Garage**: `fsn_cargarage:buyVehicle`, `fsn_cargarage:makeMine`, `fsn_bank:change:walletMinus` and `fsn_bank:change:walletAdd` are assumed to manage ownership and money transfer. *(Inferred: High)*
- **Color Update Bug**: `fsn_boatshop:floor:color:Two` on the server writes the primary colour index instead of the secondary one, so secondary colour changes may not apply. *(Inferred: Low)*
- **Ownership Check**: `DoesPlayerHaveVehicle` in `cl_menu.lua` contains a TODO for verifying if the player already owns the selected boat.

DOCS COMPLETE
