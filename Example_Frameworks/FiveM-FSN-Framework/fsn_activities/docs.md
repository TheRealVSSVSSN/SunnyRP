# fsn_activities Documentation

## Overview and Runtime Context
`fsn_activities` bundles leisure mini-games for the FiveM server. At present only a client-side yoga routine is active; fishing and hunting are placeholders awaiting implementation. The resource uses shared utilities and interacts with the stress system and HUD notifications.

## File Inventory
| Path | Role | Classification |
|------|------|----------------|
| `fxmanifest.lua` | Declares resource metadata, dependencies, and script lists | shared |
| `yoga/client.lua` | Implements yoga gameplay and stress relief | client |
| `fishing/client.lua` | Placeholder for future fishing activity | client |
| `hunting/client.lua` | Placeholder for future hunting activity | client |

## Client Scripts

### yoga/client.lua
**Responsibilities**
- Map keys for starting (`E`) and cancelling (`DELETE`) yoga sessions.
- Define yoga locations and create a map blip to guide players.
- Monitor player proximity to offer start/cancel prompts.
- Run the yoga animation, trigger stress reduction, and handle early cancellation.

**Control Flow**
1. **Blip Setup** – On load, a thread iterates the `Blips` table and creates markers for each entry.
2. **Start Prompt Loop** – A continuously running thread checks if the player is within 10 units of the yoga area. Within 2 units, pressing `E` sets `doingYoga` and calls `DoYoga`.
3. **Cancel Loop** – A parallel thread shows a cancel prompt while `doingYoga`; pressing `DELETE` invokes `cancelledYoga`.
4. **PositionCheck** – Finds the nearest yoga spot by comparing distances to pre-set coordinates.
5. **DoYoga** – Displays a preparation message, plays the yoga scenario for 15 seconds, then raises `fsn_yoga:checkStress` and clears tasks.
6. **fsn_yoga:checkStress Handler** – Verifies the session and emits `fsn_needs:stress:remove` with `10` to reduce stress.

**Security & Performance Notes**
- Stress removal is client-side and lacks server verification; spoofed events could reduce stress illegitimately.
- Both proximity loops run every frame (`Citizen.Wait(0)`), which may impact low-end clients.

**Integration Points**
- Utility helpers (`Util.GetKeyNumber`, `Util.DrawText3D`, `Util.GetVecDist`) from `@fsn_main`.
- HUD messages via `exports['mythic_notify']:DoCustomHudText` *(Inferred: High).* 
- Stress system via `TriggerEvent('fsn_needs:stress:remove', amount)` *(Inferred: High).* 

### fishing/client.lua
Comment placeholder; no logic present. **TODO**: implement fishing mechanics and add to manifest.

### hunting/client.lua
Comment placeholder referencing possible migration from `fsn_jobs`. **TODO**: implement hunting logic and add to manifest.

## Shared Configuration

### fxmanifest.lua
**Responsibilities**
- Declares bodacious FX version, author, description, and version.
- Loads shared utility scripts from `@fsn_main` for client and server.
- Includes `@mysql-async/lib/MySQL.lua` despite no server logic *(Inferred: Low).* 
- Registers `yoga/client.lua` as the only client script; fishing and hunting are omitted.

## Cross-Indexes

### Events
| Name | Direction | Type | Arguments | Notes |
|------|-----------|------|-----------|-------|
| `fsn_yoga:checkStress` | emit & handle | client local | none | Fired after yoga to confirm session before removing stress. |
| `fsn_needs:stress:remove` | emit | client local | `amount:number` | Requests stress reduction of 10 *(Inferred: High).* |

### ESX Callbacks
None.

### Exports
| Name | Usage | Arguments | Notes |
|------|-------|-----------|-------|
| `mythic_notify:DoCustomHudText` | called | `type:string`, `message:string`, `duration:number` | Displays HUD notifications *(Inferred: High).* |

### Commands
None.

### NUI Channels
None.

### Database Calls
None; presence of MySQL library suggests future persistence *(Inferred: Low).* 

## Configuration & Integration Points
- Depends on `@fsn_main` utilities and settings for client and server code.
- Integrates with `mythic_notify` for player feedback and the `fsn_needs` system for stress management.
- Manifest’s MySQL inclusion indicates planned data storage.

## Gaps & Inferences
- `mythic_notify:DoCustomHudText` and `fsn_needs:stress:remove` signatures inferred from usage (*High confidence*).
- MySQL dependency points to anticipated server persistence (*Low confidence*).
- Fishing and hunting scripts remain empty; implementations are pending **TODO**.

## Conclusion
`fsn_activities` currently offers a yoga mini-game that reduces player stress after a timed exercise. Other activities are placeholders awaiting development. Server validation and database persistence are planned but not yet implemented.

DOCS COMPLETE
