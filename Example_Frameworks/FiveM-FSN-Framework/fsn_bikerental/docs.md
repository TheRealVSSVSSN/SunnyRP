# fsn_bikerental Documentation

## Overview
fsn_bikerental provides client-side bicycle rental booths. Players approach defined locations, pay a fee, and receive a temporary bike. Interaction uses FiveM NUI for selection.

## File Inventory
| Path | Type | Role |
| ---- | ---- | ---- |
| fxmanifest.lua | Manifest | Declares dependencies, client script, and NUI assets. |
| client.lua | Client | Handles rental locations, UI toggling, vehicle spawn/return, and NUI callbacks. |
| html/index.html | NUI | Menu markup listing rentable bikes and posting selections. |
| html/script.js | NUI | Displays the UI when enabled and forwards Escape key presses. |
| html/style.css | NUI | Styles the menu and positions elements. |
| html/cursor.png | NUI Asset | Image shown as cursor during menu use. |

## Runtime Details

### fxmanifest.lua
- Targets GTA V with `bodacious` fx_version.
- Loads utility and settings scripts from `fsn_main` and includes `mysql-async` despite lacking server logic.
- Registers `client.lua` and sets the NUI entry page to `html/index.html` along with related assets.

### client.lua
- Registers `bikeRental:rented` decoration to mark rented vehicles.
- `bikeRentalCoords` lists booth locations and is used to create map blips on startup.
- Main loop checks player proximity:
  - Shows 3D text to rent, return, or indicate wrong vehicle.
  - Pressing **E** near a booth opens the NUI; pressing **E** while on a rented bike returns it.
- `spawnCar(model)` loads the given bike model, spawns it near the player, seats the rider, and tags the bike as rented.
- `deleteCar()` removes the current vehicle if it carries the rental decoration.
- `EnableGui(enable)` toggles NUI focus and sends a `enableui` message.
- `RegisterNUICallback('escape')` closes the menu and restores prompts.
- `RegisterNUICallback('rentBike')`:
  - Uses `fsn_main:fsn_GetWallet` export to check funds.
  - On success, triggers `fsn_bank:change:walletMinus`, notifies the player, spawns the bike, and hides the UI.
  - On failure, triggers `fsn_notify:displayNotification` with an error message.
- Secondary thread disables camera and melee controls while the menu is active and forwards a `click` NUI message when the melee key is released.

### html/index.html
- Imports jQuery and a small inline script `spawn_selected` to post selected model and price to `rentBike`.
- Presents buttons for six bike options with hard‑coded prices.

### html/script.js
- Listens for `enableui` messages to show or hide the page.
- On Escape key release, posts to the `escape` callback.

### html/style.css
- Hides the body by default and centers the dialog on screen.
- Provides basic button styling and hover effect.

## Cross‑Index

### Events & Messages
| Name | Type | Direction | Payload | Notes |
|------|------|-----------|---------|------|
| `fsn_notify:displayNotification` | Local event | Client → Client | `(message, position, duration, style)` | External notification system *(Inferred: High)* |
| `fsn_bank:change:walletMinus` | Local event | Client → Client | `(amount)` | Deducts cash from wallet *(Inferred: High)* |
| `enableui` | NUI message | Client → NUI | `{ enable: boolean }` | Shows or hides the menu |
| `click` | NUI message | Client → NUI | none | Simulates a mouse click while controls are disabled |

### Exports
| Name | Direction | Returns | Notes |
|------|-----------|---------|------|
| `fsn_main:fsn_GetWallet` | Import | number | Retrieves player's wallet balance |

### Commands
None.

### NUI Callbacks
| Name | Payload | Purpose |
|------|---------|---------|
| `escape` | none | Close menu and re-enable prompts |
| `rentBike` | `{ model: string, price: number }` | Validate funds, deduct cost, spawn bike |

### ESX Callbacks
None.

### Database
No direct database queries; `@mysql-async` is included but unused *(Inferred: Low)*.

## Security & Performance Notes
- All validation and vehicle spawning occur client-side, allowing potential fund spoofing or free vehicle spawning *(Inferred: Medium)*.
- Proximity loop runs every frame (`Citizen.Wait(0)`); limited booth count mitigates load.
- Decoration `bikeRental:rented` identifies rental bikes but is not enforced server-side.

## Configuration & Integration
- Depends on utilities and settings from `fsn_main`.
- Requires `fsn_bank` and `fsn_notify` resources to handle monetary changes and notifications.
- NUI assets must remain in `html/` with paths registered in the manifest.

## Gaps & Inferences
- `fsn_notify:displayNotification` and `fsn_bank:change:walletMinus` functionality inferred from naming and usage. *(Inferred: High)*
- Inclusion of MySQL library suggests planned server features yet absent. *(Inferred: Low)*
- Lack of server-side verification could permit exploits. *(Inferred: Medium)*
- `rentalMenuOpen` variable is unused; likely leftover. *(Inferred: Low)*

DOCS COMPLETE
