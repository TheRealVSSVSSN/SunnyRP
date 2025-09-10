# fsn_activities Documentation

## Overview and Runtime Context
`fsn_activities` bundles small client‑side leisure features for the FiveM server. At present only a yoga mini‑game is functional; fishing and hunting are placeholders awaiting future development. All logic executes on the client and relies on utilities provided by `fsn_main` along with notifications from `mythic_notify`.

## File Inventory
| Path | Role | Classification |
|------|------|----------------|
| `fxmanifest.lua` | Resource manifest and dependency declarations | shared |
| `yoga/client.lua` | Yoga activity implementation | client |
| `fishing/client.lua` | Placeholder for fishing activity | client |
| `hunting/client.lua` | Placeholder for hunting activity | client |

## Client

### yoga/client.lua
*Responsibilities*
- Maps three yoga spots near Del Perro and draws a "Yoga Bliss" blip at the area entrance.
- Binds start (`E`) and cancel (`DELETE`) controls using utility helpers.
- Hosts three perpetual threads: one to prompt starting yoga, one to handle cancellation, and one to spawn blips on load.
- Provides helper functions `PositionCheck`, `DoYoga`, and `cancelledYoga` to manage activity flow.

*Control Flow*
1. **Blip Setup** – When the resource starts, a thread iterates configured blips and places them on the map.
2. **Start Prompt** – Each frame the main loop checks distance to the yoga zone; within range it shows 3D text and starts `DoYoga` if the start key is pressed.
3. **Cancellation** – A parallel loop monitors the cancel key while `doingYoga` is true; pressing the key triggers `cancelledYoga`.
4. **Yoga Sequence** – `DoYoga` displays a preparation message, plays the built‑in yoga scenario for 15 seconds, emits `fsn_yoga:checkStress`, then clears the animation.
5. **Stress Handling** – The local handler for `fsn_yoga:checkStress` verifies the session and triggers `fsn_needs:stress:remove` with an amount of 10 to lower stress.

*Security & Performance Notes*
- Stress reduction is handled entirely client‑side; no server validation prevents spoofed events.
- Both main loops run every frame (`Citizen.Wait(0)`), which may be tuned if performance is a concern.

*Integration Points*
- Uses utility exports from `@fsn_main` such as `Util.GetKeyNumber`, `Util.GetVecDist`, and `Util.DrawText3D`.
- Invokes `exports['mythic_notify']:DoCustomHudText` for on‑screen messages *(Inferred: High)*.
- Emits `fsn_needs:stress:remove` to interact with the needs system *(Inferred: High)*.

### fishing/client.lua
*Status*: Contains only a TODO comment; no functional code and not referenced in the manifest.

### hunting/client.lua
*Status*: Contains only a TODO comment suggesting a possible move from `fsn_jobs`; no functional code and not referenced in the manifest.

## Shared Configuration

### fxmanifest.lua
*Responsibilities*
- Declares `bodacious` FX version, author, description, and version metadata.
- Loads shared utility scripts from `fsn_main` for both client and server.
- Includes `@mysql-async/lib/MySQL.lua` even though the resource currently has no server logic, implying planned database usage *(Inferred: Low).* 
- Registers `yoga/client.lua` as the sole client script; fishing and hunting scripts are omitted.

## Cross-Indexes

### Events
| Name | Direction | Arguments | Notes |
|------|-----------|-----------|-------|
| `fsn_yoga:checkStress` | handles (client) | none | Fired after yoga completes to adjust stress. |
| `fsn_needs:stress:remove` | emits (client) | `amount:number` | Requests stress reduction from needs system *(Inferred: High).* |

### ESX Callbacks
- None.

### Exports
| Name | Usage | Notes |
|------|-------|-------|
| `mythic_notify:DoCustomHudText` | called (client) | Displays custom HUD messages *(Inferred: High).* |

### Commands
- None.

### NUI Channels
- None.

### Database Calls
- None, though `mysql-async` is listed in the manifest *(Inferred: Low).* 

## Configuration & Integration Points
- Relies on `@fsn_main/server_settings/sh_settings.lua` for shared settings.
- Future server‑side features may use `@mysql-async/lib/MySQL.lua` for persistence *(Inferred: Low).* 

## Gaps & Inferences
- Fishing and hunting modules are empty stubs awaiting implementation. **TODO:** add activities and register them in the manifest when ready.
- Inclusion of `mysql-async` without server scripts suggests planned database features *(Inferred: Low).* 
- Stress removal and notification behaviours are deduced from naming conventions *(Inferred: High).* 

## Conclusion
The resource currently provides a single client‑side yoga mini‑game that reduces player stress. Additional activities are scaffolded but inactive. Future work may involve implementing fishing and hunting, adding server‑side verification, and utilising database support.

DOCS COMPLETE
