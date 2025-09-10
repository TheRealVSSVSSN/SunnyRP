# fsn_activities Documentation

## Overview
`fsn_activities` groups small recreational features for the FiveM server. At present it only enables a yoga mini-activity; fishing and hunting modules exist but contain no logic. The resource depends on utilities from `fsn_main` and `mythic_notify` for helper functions and user feedback.

## Table of Contents
- [fxmanifest.lua](#fxmanifestlua)
- [fishing/client.lua](#fishingclientlua)
- [hunting/client.lua](#huntingclientlua)
- [yoga/client.lua](#yogaclientlua)
- [Cross-Indexes](#cross-indexes)
- [Gaps & Inferences](#gaps--inferences)

## fxmanifest.lua
*Role*: Resource manifest.

*Responsibilities*
- Declares meta info (`bodacious` fx_version, author, description).
- Loads common utilities (`@fsn_main/cl_utils.lua`, `@fsn_main/server_settings/sh_settings.lua`) for clients and (`@fsn_main/sv_utils.lua`, `@fsn_main/server_settings/sh_settings.lua`, `@mysql-async/lib/MySQL.lua`) for servers.
- Registers `yoga/client.lua` as the only activity script. Fishing and hunting files are not referenced, implying they are inactive.

*Integration Points*
- Depends on `fsn_main` for shared utilities and server settings.
- Includes `mysql-async` but no server-side scripts in this resource use it.

## fishing/client.lua
*Role*: Placeholder for a future fishing activity.

*Status*: File only contains a TODO comment; no executable logic.

## hunting/client.lua
*Role*: Placeholder for a future hunting activity, potentially moved from `fsn_jobs`.

*Status*: File only contains a TODO comment; no executable logic.

## yoga/client.lua
*Role*: Client-side implementation of a yoga mini-game that provides stress relief.

*Core Flow*
1. **Initialisation**
   - Retrieves key codes for starting (`E`) and cancelling (`DELETE`) via `Util.GetKeyNumber`.
   - Defines yoga locations and map blip configuration.
   - Flags `doingYoga` to track session state.
2. **Blip Setup**
   - Creates a blip for "Yoga Bliss" during a thread on resource start.
3. **Starting Yoga**
   - Continuous thread checks player distance to predefined yoga spots.
   - When close, displays 3D text prompt (`Util.DrawText3D`); pressing the start key triggers `DoYoga`.
4. **Cancelling Yoga**
   - Parallel thread monitors for the cancel key. If pressed during a session, `cancelledYoga` aborts the animation and informs the player.
5. **Yoga Completion**
   - `DoYoga` shows a brief message, starts the yoga scenario for 15 seconds, then triggers the local event `fsn_yoga:checkStress`.
6. **Stress Reduction**
   - Event handler for `fsn_yoga:checkStress` fires `fsn_needs:stress:remove` with an amount of `10`, lowering the character's stress.

*Security & Performance Notes*
- All logic runs client-side with no server validation; users could potentially bypass checks by modifying the client.
- Threads run with `Citizen.Wait(0)` causing per-frame checks; could be tuned for efficiency.

*Integration Points*
- Utilises `mythic_notify:DoCustomHudText` to deliver HUD messages.
- Interacts with the `fsn_needs` system to adjust stress levels.

## Cross-Indexes

### Events
| Name | Direction | Arguments | Notes |
|------|-----------|-----------|-------|
| `fsn_yoga:checkStress` | Handles | none | Triggers stress relief after yoga; defined locally. |
| `fsn_needs:stress:remove` | Emits | amount:number | Instructs `fsn_needs` resource to reduce stress by the given amount. *(Inferred: High)* |

### Exports
| Name | Usage | Notes |
|------|-------|-------|
| `mythic_notify:DoCustomHudText` | Called | Displays informational messages on the HUD. *(Inferred: High)* |

### Commands
- None.

### ESX Callbacks
- None.

### NUI Channels
- None.

### Database Calls
- None within this resource despite `mysql-async` being included in the manifest.

## Gaps & Inferences
- `fsn_needs:stress:remove` is assumed to deduct the specified stress amount from the player's stats *(Inferred: High).* Evidence: event name and numeric argument.
- `mythic_notify:DoCustomHudText` presumed to show user notifications *(Inferred: High).* Evidence: naming convention and context.
- `fishing/client.lua` and `hunting/client.lua` contain no code; functionality is pending. *TODO: implement fishing and hunting activities.*
- `fxmanifest.lua` includes MySQL server dependency without corresponding server logic; future server-side features likely required.

## Conclusion
Currently `fsn_activities` provides only a yoga activity, relying solely on client-side logic to display prompts, play animations, and adjust stress levels. Additional activities (fishing, hunting) are scaffolds awaiting implementation, and server-side integration remains minimal.

DOCS COMPLETE
