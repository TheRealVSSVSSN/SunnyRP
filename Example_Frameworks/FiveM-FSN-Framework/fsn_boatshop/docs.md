# fsn_boatshop Documentation

## Overview and Runtime Context
The **fsn_boatshop** resource provides purchasing and rental services for boats within the FSN framework. It draws showroom vessels at the Los Santos Marina, allows employees to configure stock, and interfaces with economy and garage systems for ownership and payments.

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
  - [Commands](#commands)
  - [Exports Used](#exports-used)
- [Configuration & Integration Points](#configuration--integration-points)
- [Gaps & Inferences](#gaps--inferences)

## Shared
### fxmanifest.lua
Declares this resource for *bodacious* FX versions and lists dependencies on FSN utilities and MySQL. It registers two client scripts and one server script for execution.

## Client Files
### cl_boatshop.lua
Handles in-world showroom behavior and purchase/rental flows.

- **BuyBoat(key)** spawns the selected vessel, builds a detailed vehicle state table, pays the combined price plus commission, and notifies the garage and banking systems.
- **RentBoat(key)** spawns a temporary rental vessel, deducts the rental fee, and tracks the plate to refund half the price on return.
- A background **Util.Tick** loop keeps showroom boats spawned, frozen, colored, and replaced if moved. It draws floating text with pricing and purchase prompts. Employee-only prompts allow editing or financing.
- **Net Event Handlers** update local boat data or forward employee commands to the server.
- A cleanup thread lets players return rentals for partial refunds.

### cl_menu.lua
Implements an in-game UI for employees to choose boats to showcase.

- Defines menu structure and boat catalogue.
- **OpenCreator** teleports the player to a staging area and presents category and model lists.
- **CloseCreator** returns the player to the marina. If a model was chosen, it triggers a server change for the specified showroom slot.
- Menu navigation functions render buttons and process selection, relying on **TriggerServerEvent('fsn_boatshop:floor:ChangeBoat')** when confirming a new model.

## Server Files
### sv_boatshop.lua
Maintains showroom state and employee commands.

- Initializes five marina slots and a catalogue of default boats.
- **fsn_boatshop:floor:Request** populates empty slots with random models and sends the full table to requesting clients.
- **chatMessage Handler** gates commands to employees via `fsn_jobs` and interprets:
  - `/comm <0-30>` – sets commission percentage for the nearby slot.
  - `/color1 <0-159>` and `/color2 <0-159>` – adjust primary or secondary colors.
  - `/testdrive [end]` – toggles a separate test drive flow for the player.
- Network events **fsn_boatshop:floor:color:One/Two**, **:commission**, and **:ChangeBoat** update slot properties and broadcast the changes back to all clients.

## Cross Indexes
### Events
| Event | Direction | Parameters | Notes |
|-------|-----------|------------|-------|
| `fsn_boatshop:floor:Request` | Client → Server | None | Request current showroom data. |
| `fsn_boatshop:floor:Update` | Server → Client | `spots` table | Full showroom state. |
| `fsn_boatshop:floor:Updateboat` | Server → Client | `index`, `spot` | Updated single slot. |
| `fsn_boatshop:floor:commission` | Bidirectional | `index`, `amount` (client→server); `amount` (server→client) | Set commission or prompt selection. |
| `fsn_boatshop:floor:color:One` | Bidirectional | `index`, `color` (client→server); `color` (server→client) | Adjust primary color. |
| `fsn_boatshop:floor:color:Two` | Bidirectional | `index`, `color` (client→server); `color` (server→client) | Adjust secondary color. |
| `fsn_boatshop:floor:ChangeBoat` | Client → Server | `index`, `model` | Replace showroom boat. |
| `fsn_boatshop:testdrive:start` | Server → Client | None | Inferred: begins temporary test drive. *(Low)* |
| `fsn_boatshop:testdrive:end` | Server → Client | None | Inferred: ends test drive. *(Low)* |
| `fsn_cargarage:buyVehicle` | Client → Server | `charId`, `name`, `model`, `plate`, `details`, `finance`, `type`, `slot` | External garage registration. *(High)* |
| `fsn_cargarage:makeMine` | Client → Server | `vehicle`, `model`, `plate` | External ownership tagging. *(High)* |
| `fsn_bank:change:walletMinus` | Client → Server | `amount` | Deducts funds. *(High)* |
| `fsn_bank:change:walletAdd` | Client → Server | `amount` | Refunds funds. *(High)* |

### Commands
| Command | Permission | Description |
|---------|------------|-------------|
| `/comm <0-30>` | Boat shop employee | Set commission percentage for nearby slot. |
| `/color1 <0-159>` | Boat shop employee | Set primary color for nearby slot. |
| `/color2 <0-159>` | Boat shop employee | Set secondary color for nearby slot. |
| `/testdrive [end]` | Boat shop employee | Start or end a test drive sequence. |

### Exports Used
| Export | Source | Purpose |
|--------|--------|---------|
| `fsn_main:fsn_CharID` | `fsn_main` | Retrieve player character ID. |
| `fsn_main:fsn_CanAfford` | `fsn_main` | Check player affordability. |
| `fsn_jobs:isWhitelistClockedIn` / `isPlayerClockedInWhitelist` | `fsn_jobs` | Restrict features to employees. |
| `mythic_notify:DoCustomHudText` / `mythic_notify:client:SendAlert` | `mythic_notify` | Display notifications. |

## Configuration & Integration Points
- Depends on FSN utilities and MySQL libraries through the manifest.
- Interacts with **fsn_bank** for monetary transactions and **fsn_cargarage** for vehicle ownership.
- Employee checks rely on **fsn_jobs**, specifically whitelist ID `4` for marina staff.
- Uses utility helpers such as `Util.DrawText3D`, `Util.Tick`, and vector math from shared FSN modules.

## Gaps & Inferences
- **Test Drive Flow**: Events `fsn_boatshop:testdrive:start` and `fsn_boatshop:testdrive:end` are triggered by the server but not handled in this resource. Their behavior is inferred to spawn and clean up a temporary boat. *(Inferred: Low)*
- **External Economy & Garage**: Functions like `fsn_cargarage:buyVehicle` and `fsn_bank:change:walletMinus` are assumed to handle persistence and money transfers based on naming and parameters. *(Inferred: High)*

DOCS COMPLETE
