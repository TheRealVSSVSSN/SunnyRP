# fsn_bikerental Documentation

## Overview and Runtime Context
The resource supplies bicycle rental kiosks around the map. It is entirely client-side with a small NUI menu; no local server scripts are present. Players approach a kiosk, pay for a bike, and receive a temporary vehicle flagged as rented.

## File Inventory
| Path | Side | Role |
|------|------|------|
| fxmanifest.lua | Manifest | Declares dependencies, client script, and NUI files. |
| client.lua | Client | Handles map blips, prompts, bike spawning/returning, and NUI callbacks. |
| html/index.html | NUI | Markup with buttons for bike selection and pricing. |
| html/script.js | NUI | Toggles menu visibility and posts Escape requests. |
| html/style.css | NUI | Layout and appearance for the rental menu. |
| html/cursor.png | NUI Asset | Cursor image displayed when GUI is active. |

## Client
### client.lua
- Maintains GUI state flags and registers the decoration `bikeRental:rented` used to tag spawned bikes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L1-L6】
- `bikeRentalCoords` defines kiosk locations; startup thread adds blips and continuously checks player proximity【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L8-L31】
- When near a kiosk, shows 3D prompts and reacts to **E** depending on whether the player is on foot or riding a tagged bike【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L31-L57】
- `spawnCar` loads the requested model, creates the vehicle, seats the player, and marks it rented【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L66-L81】
- `deleteCar` removes the vehicle if it carries the rental decoration, resetting prompts【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L84-L95】
- `EnableGui` toggles NUI focus and sends an `enableui` message to the HTML page【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L100-L108】
- NUI callbacks:
  - `escape` closes the menu and restores prompts【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L110-L115】
  - `rentBike` checks wallet funds via `fsn_main` export, subtracts cash, spawns the bike, and hides the UI【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L117-L131】
- A control-disabling thread runs while the UI is open and forwards a `click` message when a disabled melee key is released【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L133-L146】
- The variable `rentalMenuOpen` is defined but unused *(Inferred: Low)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L4-L4】

## Manifest
### fxmanifest.lua
- Targets the `bodacious` game build for GTA V【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L1-L2】
- Loads utility and settings scripts from `fsn_main` for both client and server contexts, and includes `@mysql-async` despite no server logic in this resource【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L8-L16】
- Registers `client.lua` as the lone client script and points `ui_page` to `html/index.html` with its asset list【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L19-L29】

## NUI
### html/index.html
- Loads jQuery libraries and defines `spawn_selected`, which posts the chosen bike model and cost to the `rentBike` callback【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/index.html†L1-L30】
- Presents seven bike options with fixed prices; clicking a button triggers the post and closes after client confirmation【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/index.html†L11-L19】

### html/script.js
- Listens for `enableui` messages to show or hide the page and submits an `escape` post when the Escape key is released【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/script.js†L1-L11】

### html/style.css
- Hides the body by default, positions the dialog, and styles buttons with a white theme and blue hover state【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/style.css†L3-L38】

### html/cursor.png
- Image asset used for a custom cursor when the menu is active.

## Cross-Indexes
### Events
| Name | Direction | Payload | Notes |
|------|-----------|---------|-------|
| `fsn_notify:displayNotification` | Client → Client | `(message, position, duration, style)` | Shows feedback to players *(Inferred: High)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L55-L55】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L120-L120】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L129-L129】|
| `fsn_bank:change:walletMinus` | Client → Client | `(amount)` | Deducts funds from wallet *(Inferred: High)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L118-L119】|

### NUI Messages
| Name | Source → Target | Payload | Purpose |
|------|----------------|---------|---------|
| `enableui` | Client → NUI | `{ enable: boolean }` | Display or hide menu【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L100-L108】|
| `click` | Client → NUI | none | Simulate mouse click with controls disabled【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L133-L146】|

### Exports
| Name | Direction | Returns | Notes |
|------|-----------|---------|------|
| `fsn_main:fsn_GetWallet` | Import | number | Retrieves player's wallet balance【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L117-L118】|

### Commands
None.

### NUI Callbacks
| Name | Payload | Purpose |
|------|---------|---------|
| `escape` | none | Close menu and re-enable prompts【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L110-L115】|
| `rentBike` | `{ model: string, price: number }` | Verify funds, deduct money, and spawn bike【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L117-L131】|

### Database
No direct queries; inclusion of `@mysql-async` in the manifest suggests planned server features *(Inferred: Low)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L12-L16】

## Configuration & Integration Points
- Kiosk coordinates and labels are hard-coded in `bikeRentalCoords`; adding entries introduces new rental locations【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L8-L11】
- Depends on external `fsn_main`, `fsn_bank`, and `fsn_notify` resources for utilities, wallet access, and notifications.
- NUI assets must remain under `html/` with paths registered in the manifest.

## Security & Performance Notes
- All validation occurs client-side, enabling potential currency spoofing or unauthorized bike spawns *(Inferred: Medium)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L117-L131】
- Proximity and control loops run each frame; limited kiosk count keeps overhead low【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L25-L26】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L133-L150】
- Decoration `bikeRental:rented` identifies rentals but lacks server enforcement *(Inferred: Medium)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L6】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L84-L91】

## Gaps & Inferences
- `fsn_notify:displayNotification` and `fsn_bank:change:walletMinus` behaviors inferred from usage; underlying implementations not present *(Inferred: High)*.
- `@mysql-async` inclusion suggests future server-side expansion, currently unused *(Inferred: Low)*.
- `rentalMenuOpen` appears vestigial *(Inferred: Low)*.
- No server-side checks to prevent exploiting the rental system *(Inferred: Medium)*.

DOCS COMPLETE
