# fsn_activities Documentation

## Overview and Runtime Context
`fsn_activities` bundles small leisure features for the FiveM server. Only the yoga mini-game is operational; fishing and hunting scripts exist as stubs. All logic in this resource executes on the client and relies on utilities provided by `fsn_main` and the `mythic_notify` notification system.

## File Inventory
| Path | Type |
|------|------|
| `fxmanifest.lua` | shared manifest |
| `yoga/client.lua` | client script |
| `fishing/client.lua` | client placeholder |
| `hunting/client.lua` | client placeholder |

## Client

### yoga/client.lua
*Role*: Implements the yoga activity that lowers player stress.

*Key Data*
- Binds start (`E`) and cancel (`DELETE`) keys using helper utilities.
- Defines three yoga spots near Del Perro, a blip configuration for "Yoga Bliss," and distance thresholds for prompts.

*Runtime Flow*
1. **Blip Creation** – On resource load, a thread iterates configured blips and places them on the map.
2. **Start Prompt** – A continuous thread checks the player's proximity to the yoga area. When within range, it displays 3D text inviting the player to press the start key; pressing begins `DoYoga`.
3. **Cancellation** – A parallel thread monitors for the cancel key while yoga is active and, if pressed, calls `cancelledYoga` to terminate the scenario early and notify the user.
4. **Yoga Sequence** – `DoYoga` shows a short preparation message, plays the built‑in yoga scenario for 15 seconds, then triggers `fsn_yoga:checkStress` before clearing the animation.
5. **Stress Adjustment** – The local event handler for `fsn_yoga:checkStress` checks the session state and emits `fsn_needs:stress:remove` with an amount of `10` to decrease stress.

*Security & Performance*
- Entirely client‑side; server does not verify participation or stress changes.
- Both monitoring threads run each frame (`Citizen.Wait(0)`), which may be tuned if performance becomes an issue.

*Integration Points*
- Uses `exports['mythic_notify']:DoCustomHudText` for HUD messages.
- Calls `fsn_needs:stress:remove` to interact with the needs system.
- Depends on utility functions (`Util.GetKeyNumber`, `Util.GetVecDist`, `Util.DrawText3D`) provided by `@fsn_main`.

### fishing/client.lua
*Role*: Placeholder file reserved for a future fishing activity.

*Status*: Contains only a TODO comment; no logic and not referenced in the manifest.

### hunting/client.lua
*Role*: Placeholder for a potential hunting feature, possibly migrated from another resource.

*Status*: Contains only a TODO comment; no logic and not referenced in the manifest.

## Shared Configuration

### fxmanifest.lua
*Role*: Declares resource metadata and script lists.

*Responsibilities*
- Specifies `bodacious` FX version, author, description, and version information.
- Loads client utilities and server utilities from `fsn_main`; server section also pulls `@mysql-async/lib/MySQL.lua` despite this resource having no server scripts.
- Registers `yoga/client.lua` as the sole client script; fishing and hunting scripts are omitted.

*Integration Points*
- Depends on `fsn_main` for both client and server helpers.
- Includes `mysql-async` for prospective database access though none is present in the current code.

## Cross-Indexes

### Events
| Name | Direction | Arguments | Notes |
|------|-----------|-----------|-------|
| `fsn_yoga:checkStress` | Handles | none | Local event fired after yoga finishes.
| `fsn_needs:stress:remove` | Emits | `amount:number` | Requests stress reduction from the needs system *(Inferred: High)*.

### Exports
| Name | Usage | Notes |
|------|-------|-------|
| `mythic_notify:DoCustomHudText` | Called | Displays custom HUD text *(Inferred: High)*.

### Commands
- None.

### ESX Callbacks
- None.

### NUI Channels
- None.

### Database Calls
- None, though `mysql-async` is loaded in the manifest.

## Configuration & Integration Points
- `@fsn_main/server_settings/sh_settings.lua` supplies shared configuration values.
- `@mysql-async/lib/MySQL.lua` is included for future server-side persistence.

## Gaps & Inferences
- Fishing and hunting modules are placeholders awaiting implementation. *TODO: add activities and register in manifest.*
- Inclusion of `mysql-async` without server logic suggests planned database interactions *(Inferred: Low).*
- `fsn_needs:stress:remove` and `mythic_notify:DoCustomHudText` behaviours are deduced from naming and context *(Inferred: High).*

## Conclusion
Currently the resource provides only client-side yoga functionality. It registers activity locations, manages player prompts, and reduces stress through the needs system. Additional recreational features are scaffolded but inactive.

DOCS COMPLETE
