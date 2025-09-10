# fsn_bikerental Documentation

## Overview
fsn_bikerental provides rental kiosks that let players temporarily spawn bicycles at defined locations. The script shows markers, opens a web-based menu for selecting bikes, charges the player's wallet, and marks rented vehicles for later return.

## Table of Contents
- [fxmanifest.lua](#fxmanifestlua)
- [client.lua](#clientlua)
- [html/index.html](#htmlindexhtml)
- [html/script.js](#htmlscriptjs)
- [html/style.css](#htmlstylecss)
- [html/cursor.png](#htmlcursorpng)
- [Events](#events)
- [Exports](#exports)
- [ESX Callbacks](#esx-callbacks)
- [Commands](#commands)
- [NUI Callbacks](#nui-callbacks)
- [Gaps & Inferences](#gaps--inferences)

## fxmanifest.lua
**Role:** Resource manifest defining dependencies, client script, and NUI assets.

**Key Points:**
- Registers the resource for GTA V under fx_version *bodacious*.
- Loads utility and settings files from `@fsn_main` and includes `@mysql-async` for database access even though this resource has no server logic.
- Declares `client.lua` as the only in-resource script.
- Sets the NUI page to `html/index.html` and lists accompanying files.

## client.lua
**Role:** Client-side script controlling rental interaction and vehicle spawning.

**Responsibilities:**
- Defines rental locations and blips.
- Presents context-sensitive 3D prompts based on player position and rented vehicle status.
- Opens/closes the NUI menu and processes bike rentals and returns.
- Spawns and deletes rented bikes, tagging them with a `bikeRental:rented` decoration.
- Manages control disabling while the menu is open.

**Notable Functions:**
- `spawnCar(model)`: Loads the requested bike model, creates the vehicle near the player, seats the player, and decorates it as rented.
- `deleteCar()`: Removes the current vehicle if it carries the rental decoration.
- `EnableGui(enable)`: Toggles NUI focus and informs the UI via `SendNUIMessage`.

**Events & NUI:**
- Triggers `fsn_notify:displayNotification` to inform players of rental and return actions.
- Triggers `fsn_bank:change:walletMinus` to deduct rental fees from the wallet.
- Provides NUI callbacks:
  - `escape`: closes the menu and restores prompts.
  - `rentBike`: validates funds using the `fsn_main` wallet export, deducts money, spawns the bike, and closes the menu.
- Sends NUI messages `enableui` (show/hide UI) and `click` (mouse click relay when controls are disabled).

**Control Flow:**
1. On resource start, blips are created for each rental location.
2. A loop checks proximity to locations and displays either a rental prompt, a return prompt, or a not-rented message.
3. Pressing **E** near a stand opens the rental menu; pressing **E** on a rented bike stand returns it.
4. The GUI thread disables look and melee controls while the menu is active and relays clicks to the UI.

**Security & Permissions:**
- Wallet deduction and bike spawning occur entirely on the client. Without server verification, players could spoof funds or spawn bikes freely.
- Vehicle ownership is tracked via a local entity decoration; server-side checks are absent.

**Performance Considerations:**
- The proximity loop runs every frame (`Citizen.Wait(0)`), which may be CPU-intensive if many rental points are added. The current small set keeps the impact minimal.

## html/index.html
**Role:** NUI page presenting bike choices.

**Structure:**
- Includes jQuery and `nui/main.js`.
- Displays buttons for each bike model with associated prices.
- Defines `spawn_selected(model, price)` which posts the chosen bike model and price to the `rentBike` callback.

## html/script.js
**Role:** NUI script managing display state and Escape handling.

**Behavior:**
- Listens for `enableui` messages to show or hide the document body.
- Posts to the `escape` callback when the Escape key is released.

## html/style.css
**Role:** Styling for the rental menu.

**Details:**
- Centers the dialog on screen and hides the body by default.
- Styles buttons and hover state.

## html/cursor.png
**Role:** Image asset representing the cursor while the NUI is active.

## Events
| Name | Type | Source | Payload | Description |
|------|------|--------|---------|-------------|
| `fsn_notify:displayNotification` | Client event | Triggered in `client.lua` | message, position, duration, style | Shows feedback to the player. |
| `fsn_bank:change:walletMinus` | Client event | Triggered in `client.lua` | amount | Deducts money from the player's wallet (inferred). |
| `enableui` | NUI message | Sent via `SendNUIMessage` | `{ enable: boolean }` | Toggles the NUI display. |
| `click` | NUI message | Sent when melee key released | none | Notifies UI of a click while controls are disabled. |

## Exports
| Name | Direction | Description |
|------|-----------|-------------|
| `fsn_main:fsn_GetWallet` | Import | Returns the player's current wallet balance.

## ESX Callbacks
None.

## Commands
None.

## NUI Callbacks
| Name | Payload | Description |
|------|---------|-------------|
| `escape` | none | Closes the rental UI and re-enables prompts. |
| `rentBike` | `{ model: string, price: number }` | Attempts to rent the selected bike and deduct the cost. |

## Gaps & Inferences
- `fsn_bank:change:walletMinus` and `fsn_notify:displayNotification` are external events presumed to handle finances and notifications respectively. *(Inferred: High)*
- Rental fee validation occurs client-side; absence of server checks may allow exploits. *(Inferred: Medium)*
- `rentalMenuOpen` is declared but never used, suggesting leftover code. *(Inferred: Low)*

DOCS COMPLETE
