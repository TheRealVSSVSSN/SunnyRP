# fsn_activities Documentation

## Overview and Runtime Context
`fsn_activities` hosts leisure mini‑games for the FiveM server. At present only a client‑side yoga routine is implemented; fishing and hunting files are stubs. The resource relies on shared utilities from `@fsn_main` and displays notifications via `mythic_notify`.

## File Inventory
| Path | Role | Classification |
|------|------|----------------|
| `fxmanifest.lua` | Resource manifest declaring dependencies and scripts | shared |
| `yoga/client.lua` | Yoga mini‑game | client |
| `fishing/client.lua` | Placeholder for future fishing activity | client |
| `hunting/client.lua` | Placeholder for future hunting activity | client |

## Client Scripts

### yoga/client.lua
**Responsibilities**
- Reads key codes for start (`E`) and cancel (`DELETE`) actions and tracks session state via `doingYoga`.
- Declares three yoga spots near Del Perro along with a central location for range checks.
- Maps a “Yoga Bliss” blip on resource start.
- Polls player proximity to prompt starting or cancelling yoga.
- Provides helpers `DoYoga`, `PositionCheck`, and `cancelledYoga` plus a local `fsn_yoga:checkStress` event.

**Control Flow**
1. **Blip Setup** – A thread iterates `Blips` and places each marker when the resource loads.【F:yoga/client.lua†L16-L45】
2. **Start Prompt** – A loop monitors distance to the yoga area; within range it draws 3D text and calls `DoYoga` when `E` is pressed.【F:yoga/client.lua†L47-L69】
3. **Cancellation** – A parallel loop listens for the cancel key while `doingYoga`; pressing it invokes `cancelledYoga` and stops the animation.【F:yoga/client.lua†L71-L95】
4. **PositionCheck** – Finds the nearest yoga spot by computing distances to `yogaSpots` and returning the smallest value.【F:yoga/client.lua†L106-L121】
5. **Yoga Sequence** – `DoYoga` displays a prep message, plays the yoga scenario for 15 seconds, triggers `fsn_yoga:checkStress`, then clears tasks.【F:yoga/client.lua†L123-L135】
6. **Stress Handling** – The handler for `fsn_yoga:checkStress` validates `doingYoga` and fires `fsn_needs:stress:remove` with `10` to reduce stress.【F:yoga/client.lua†L137-L144】

**Security & Performance Notes**
- Stress reduction is client‑side only; spoofed events could remove stress without validation.
- Two frame‑based loops (`Citizen.Wait(0)`) continuously poll proximity and cancellation, which may impact performance on low‑end clients.

**Integration Points**
- Uses `@fsn_main` helpers for key mapping, distance checks, and 3D text drawing.
- Calls `exports['mythic_notify']:DoCustomHudText(type, message, duration)` for notifications *(Inferred: High).*【F:yoga/client.lua†L97-L103】【F:yoga/client.lua†L123-L129】
- Triggers `fsn_needs:stress:remove(amount)` to adjust player stress *(Inferred: High).*【F:yoga/client.lua†L137-L144】

### fishing/client.lua
Contains only a placeholder comment; no logic and not referenced by the manifest.【F:fishing/client.lua†L1-L1】

### hunting/client.lua
Contains only a placeholder comment noting a potential move from `fsn_jobs`; not referenced by the manifest.【F:hunting/client.lua†L1-L1】

## Shared Configuration

### fxmanifest.lua
**Responsibilities**
- Declares the `bodacious` FX version, metadata, and dependency blocks.
- Loads shared utility scripts from `@fsn_main` on both client and server sides.
- Includes `@mysql-async/lib/MySQL.lua` despite no server logic, suggesting future database use *(Inferred: Low).*【F:fxmanifest.lua†L13-L17】
- Registers `yoga/client.lua` as the only client script; fishing and hunting scripts are absent.【F:fxmanifest.lua†L20-L25】

## Cross-Indexes

### Events
| Name | Direction | Type | Arguments | Notes |
|------|-----------|------|-----------|-------|
| `fsn_yoga:checkStress` | emits & handles (client) | local | none | Fired after yoga to verify session before adjusting stress. |
| `fsn_needs:stress:remove` | emits (client) | local | `amount:number` | Requests stress reduction of 10 from needs system *(Inferred: High).* |

### ESX Callbacks
- None.

### Exports
| Name | Usage | Arguments | Notes |
|------|-------|-----------|-------|
| `mythic_notify:DoCustomHudText` | called (client) | `type:string`, `message:string`, `duration:number` | Displays HUD notifications *(Inferred: High).*【F:yoga/client.lua†L97-L103】【F:yoga/client.lua†L123-L129】|

### Commands
- None.

### NUI Channels
- None.

### Database Calls
- None, though `mysql-async` is loaded in the manifest *(Inferred: Low).*【F:fxmanifest.lua†L13-L17】

## Configuration & Integration Points
- Depends on `@fsn_main/cl_utils.lua`, `@fsn_main/sv_utils.lua`, and shared settings from `@fsn_main/server_settings/sh_settings.lua` via the manifest.
- Integrates with `mythic_notify` for user feedback and with the `fsn_needs` system for stress management.

## Gaps & Inferences
- `mythic_notify:DoCustomHudText` argument structure inferred from local calls *(Inferred: High).*【F:yoga/client.lua†L97-L103】
- `fsn_needs:stress:remove` expects an `amount` parameter; value `10` is used during yoga *(Inferred: High).*【F:yoga/client.lua†L137-L144】
- Inclusion of `@mysql-async/lib/MySQL.lua` implies planned persistence despite missing server scripts *(Inferred: Low).*【F:fxmanifest.lua†L13-L17】
- Fishing and hunting scripts are stubs requiring implementation and manifest registration. **TODO.**【F:fishing/client.lua†L1-L1】【F:hunting/client.lua†L1-L1】

## Conclusion
The resource currently offers a single client‑side yoga mini‑game that reduces player stress after a timed animation. Other activities are scaffolds awaiting development. Future work should add server‑side validation, implement remaining activities, and leverage the declared database dependency.

DOCS COMPLETE

