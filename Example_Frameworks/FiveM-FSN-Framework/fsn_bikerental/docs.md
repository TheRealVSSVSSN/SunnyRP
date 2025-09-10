# fsn_bikerental Documentation

## Overview
fsn_bikerental supplies map‑based bicycle rental booths on the client. Players walk to a kiosk, open a native UI to pick a bike, pay a fee, and spawn a temporary vehicle that is flagged for return. No server code ships with the resource; all logic is client‑side with a small NUI frontend.

## Table of Contents
- [File Inventory](#file-inventory)
- [Runtime Details](#runtime-details)
  - [fxmanifest.lua](#fxmanifestlua)
  - [client.lua](#clientlua)
  - [html/index.html](#htmlindexhtml)
  - [html/script.js](#htmlscriptjs)
  - [html/style.css](#htmlstylecss)
  - [html/cursor.png](#htmlcursorpng)
- [Cross-Index](#cross-index)
  - [Events](#events)
  - [NUI Messages](#nui-messages)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Callbacks](#nui-callbacks)
  - [ESX Callbacks](#esx-callbacks)
  - [Database](#database)
- [Security & Performance Notes](#security--performance-notes)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## File Inventory
| Path | Type | Role |
| ---- | ---- | ---- |
| fxmanifest.lua | Manifest | Declares dependencies, client script, and NUI assets. |
| client.lua | Client | Manages rental booths, prompts, vehicle spawn/return, NUI toggling, and callbacks. |
| html/index.html | NUI | Markup for the rental menu and form posting. |
| html/script.js | NUI | Handles UI visibility and Escape key. |
| html/style.css | NUI | Positions and styles the menu. |
| html/cursor.png | NUI Asset | Image used as cursor while the menu is active. |

## Runtime Details
### fxmanifest.lua
- Targets GTA V using the `bodacious` game build and loads both utility and settings scripts from `fsn_main` for client and server contexts【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L1-L16】
- Includes `@mysql-async/lib/MySQL.lua` even though the resource has no Lua server logic【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L12-L16】
- Registers the sole client script `client.lua` and points the UI page to `html/index.html` with its associated assets【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L19-L29】

### client.lua
- Declares state flags and registers a decoration `bikeRental:rented` used to mark spawned bikes【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L1-L6】
- `bikeRentalCoords` lists kiosk locations; startup thread adds map blips and continuously checks player proximity【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L8-L31】
- Depending on whether the player is on foot or riding a tagged bike, the loop displays 3D prompts using `Util.DrawText3D` and responds to **E** to open the menu or return the vehicle【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L31-L55】
- `spawnCar` loads the requested model, spawns it near the player, seats them, and tags it with the rental decoration【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L66-L81】
- `deleteCar` removes the current vehicle only if it carries the decoration, using a native delete call for cleanup【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L84-L95】
- `EnableGui` toggles NUI focus and sends an `enableui` message to show or hide the HTML page【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L100-L108】
- NUI callbacks:
  - `escape` closes the menu and re-enables prompts【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L110-L115】
  - `rentBike` validates funds via `fsn_main:fsn_GetWallet`, deducts cash, displays a notification, spawns the bike, and hides the UI【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L117-L131】
- A secondary thread disables camera and melee controls while the menu is active and forwards a `click` message when the melee key is released【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L133-L149】

### html/index.html
- Loads jQuery and defines a `spawn_selected` helper that posts the chosen model and price to the `rentBike` callback【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/index.html†L1-L30】
- Presents buttons for seven bike models with hard-coded prices; clicking sends the selection to the client script【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/index.html†L13-L19】

### html/script.js
- Listens for `enableui` messages to toggle page visibility【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/script.js†L1-L6】
- Posts to the `escape` callback when the Escape key is released【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/script.js†L8-L11】

### html/style.css
- Hides the body by default and positions the dialog and optional cursor image at fixed screen coordinates【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/style.css†L3-L21】
- Styles buttons with a white theme and blue hover state【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/style.css†L23-L38】

### html/cursor.png
- Static image used as a custom cursor when the menu is open.

## Cross-Index
### Events
| Name | Direction | Payload | Notes |
|------|-----------|---------|------|
| `fsn_notify:displayNotification` | Client → Client | `(message, position, duration, style)` | External notification system *(Inferred: High)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L55-L56】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L120-L120】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L129-L129】|
| `fsn_bank:change:walletMinus` | Client → Client | `(amount)` | Deducts funds from wallet *(Inferred: High)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L118-L119】|

### NUI Messages
| Name | Source → Target | Payload | Purpose |
|------|----------------|---------|---------|
| `enableui` | Client → NUI | `{ enable: boolean }` | Show or hide menu【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L100-L108】|
| `click` | Client → NUI | none | Simulate mouse click while controls disabled【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L133-L146】|

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
| `rentBike` | `{ model: string, price: number }` | Validate funds, deduct cost, spawn bike【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L117-L131】|

### ESX Callbacks
None.

### Database
No direct database queries; inclusion of `mysql-async` hints at planned server features *(Inferred: Low)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua†L12-L16】

## Security & Performance Notes
- All validation and vehicle spawning occur on the client, allowing potential currency spoofing or free bike spawning *(Inferred: Medium)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L117-L131】
- Proximity and control loops run every frame (`Citizen.Wait(0)`), though limited booth count keeps processing light【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L25-L26】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L133-L150】
- Decoration `bikeRental:rented` marks rentals but lacks server-side enforcement *(Inferred: Medium)*【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L6】【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L84-L91】

## Configuration & Integration
- Rental locations are hard-coded in `bikeRentalCoords` and can be expanded for additional kiosks【F:Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua†L8-L11】
- Depends on `fsn_main` for utilities and wallet access, `fsn_bank` for money changes, and `fsn_notify` for UI feedback.
- NUI assets must remain under `html/` with paths registered in the manifest.

## Gaps & Inferences
- `fsn_notify:displayNotification` and `fsn_bank:change:walletMinus` behavior inferred from naming and usage *(Inferred: High)*
- MySQL library inclusion suggests future server expansion but currently unused *(Inferred: Low)*
- Lack of server-side verification could permit exploiting the rental system *(Inferred: Medium)*

DOCS COMPLETE
