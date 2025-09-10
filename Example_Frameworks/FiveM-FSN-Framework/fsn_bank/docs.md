# fsn_bank Documentation

## Overview and Runtime Context
The `fsn_bank` resource provides ATM and bank branch interactions for the FiveM-FSN framework. It supplies map blips, opens a browser-based ATM interface, and coordinates balance changes with the framework's core money system and persistent database.

## Table of Contents
- [Client](#client)
  - [client.lua](#clientlua)
- [Server](#server)
  - [server.lua](#serverlua)
- [Shared / Config](#shared--config)
  - [fxmanifest.lua](#fxmanifestlua)
- [NUI](#nui)
  - [gui/index.html](#guiindexhtml)
  - [gui/index.css](#guiindexcss)
  - [gui/index.js](#guiindexjs)
  - [Assets](#assets)
- [Cross‑Indexes](#cross-indexes)
  - [Events](#events)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Callbacks](#nui-callbacks)
  - [NUI Messages](#nui-messages)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## Client
### client.lua
**Role:** Detects ATMs, presents the NUI interface, adjusts local balances, and relays transactions to other systems.

**Key Responsibilities:**
- Holds a large table of ATM/bank coordinates and creates map blips for branch locations on startup.
- Continuously checks the player's distance to each ATM. When within one unit and **E** is pressed, it requests current balances, plays an animation, and shows the NUI with focus.
- Maintains `moneys` and `banks` variables. Event `fsn_bank:update:both` updates these values and sends them to the NUI.
- `fsn_closeATM` releases focus, unfreezes the player, hides the interface, and resets HUD display; a typo leaves `atmDisplay` set (Inferred: High).
- NUI callbacks:
  - **depositMoney** – Validates bank-only deposits up to $500k, updates local balances, records a phone transaction, logs via `fsn_main:logging:addLog`, and fires `fsn_bank:change:bankandwallet` for persistence elsewhere.
  - **withdrawMoney** – Validates withdrawals up to $500k, adjusts balances, records a phone transaction, logs the action, and emits `fsn_bank:change:bankandwallet`.
  - **transferMoney** – Checks amount and recipient ID, then triggers server event `fsn_bank:transfer` if funds are sufficient.
  - **toggleGUI** – Closes the interface.

**Security/Permission Notes:**
- Amount validations and bank-only checks occur client side; the server trusts incoming data.

**Performance Considerations:**
- The proximity loop runs every frame against a large ATM list, which may impact client CPU usage.

## Server
### server.lua
**Role:** Persists balance changes and processes inter-player transfers.

**Key Responsibilities:**
- Event `fsn_bank:database:update` receives `charid`, `wallet`, and `bank`. It updates `fsn_characters` table columns individually when values are not `false` using synchronous MySQL queries.
- Event `fsn_bank:transfer` verifies the recipient player exists, then emits `fsn_bank:change:bankAdd` to the recipient and `fsn_bank:change:bankMinus` to the sender. If the target is offline, the source receives a notification.

**Security/Permission Notes:**
- No server-side validation of amounts or sufficient funds; relies on the client to send correct data.
- Transfers do not persist immediately; other listeners must invoke `fsn_bank:database:update`.

**DB Usage:**
- Uses `MySQL.Sync.execute` to update `char_bank` and `char_money` fields in `fsn_characters`.

## Shared / Config
### fxmanifest.lua
**Role:** Declares resource metadata and dependencies.

- Targets `bodacious` fx_version for GTA V.
- Loads utilities from `@fsn_main` and includes `@mysql-async/lib/MySQL.lua` for database access.
- Registers `client.lua` and `server.lua` and exposes NUI assets.

## NUI
### gui/index.html
Structures the ATM UI, including screens for withdraw, deposit, transfer, a hidden group-account panel, and a placeholder loan agreement.

### gui/index.css
Styles the ATM interface layout, buttons, and display elements.

### gui/index.js
**Role:** Handles browser-side logic and user actions.

- Listens for messages from Lua:
  - `displayATM` – Toggles visibility and notes if the player is at a bank branch.
  - `update` with `updateType` `wallet&bank` – Refreshes on-screen cash and bank values.
- Plays a button click sound when main buttons are pressed.
- Posts callbacks back to Lua:
  - `depositMoney`, `withdrawMoney`, `transferMoney`, `toggleGUI`.

### Assets
- `atm_logo.png` – Logo on ATM screen.
- `atm_button_sound.mp3` – Audio feedback for button presses.

## Cross‑Indexes
### Events
| Event | Direction | Payload | Description |
|-------|-----------|---------|-------------|
| `fsn_bank:change:bankandwallet` | Client local | `wallet`, `bank` | Broadcasts new balances for HUD/persistence *(Inferred: High – handled externally).* |
| `fsn_bank:request:both` | Client local | none | Requests current balances from core *(Inferred: Medium – handled externally).* |
| `fsn_bank:update:both` | Server → client | `wallet`, `bank` | Syncs balances and updates NUI. |
| `fsn_main:displayBankandMoney` | Client local | none | Restores HUD after closing ATM. |
| `fsn_notify:displayNotification` | Both | `message`, `position`, `duration`, `type` | Shows on-screen notifications. |
| `fsn_phones:SYS:addTransaction` | Client local | transaction table | Records activity in the phone app. |
| `fsn_main:logging:addLog` | Client → server | player ID, category, text | Stores money logs. |
| `fsn_bank:transfer` | Client → server | `receive`, `amount` | Moves funds to another player. |
| `fsn_bank:database:update` | Client → server | `charid`, `wallet`, `bank` | Persists balances to database. |
| `fsn_bank:change:bankAdd` / `fsn_bank:change:bankMinus` | Server → client | `amount` | Adjusts banks during transfers *(Inferred: High – processed by core).* |

### Exports
| Export | Direction | Purpose |
|--------|-----------|---------|
| `fsn_main:fsn_CharID` | Used | Retrieves the character ID for logging and transactions. |

### Commands
*None defined in this resource.*

### NUI Callbacks
| Callback | Payload | Purpose |
|----------|---------|---------|
| `depositMoney` | `deposit`, `atbank` | Deposit cash to bank; requires bank location and amount ≤ $500k. |
| `withdrawMoney` | `withdraw` | Withdraw cash up to $500k. |
| `transferMoney` | `transferAmount`, `transferTo` | Transfer funds to another player ID, capped at $500k. |
| `toggleGUI` | none | Close the ATM interface. |

### NUI Messages
| Message | Payload | Description |
|---------|---------|-------------|
| `displayATM` | `bank`, `enable` | Toggles ATM UI and notes if at a bank branch. |
| `update` (`wallet&bank`) | `wallet`, `bank` | Refreshes displayed balances. |

## Configuration & Integration
- Depends on `@fsn_main` for utilities, settings, HUD updates, and character identification.
- Requires `mysql-async` for database operations.
- Uses FiveM NUI messaging to coordinate between Lua and the browser UI.

## Gaps & Inferences
- Event `fsn_bank:change:bankandwallet` is emitted but not handled within this resource; the core money module likely listens *(Inferred: High).* 
- Event `fsn_bank:request:both` lacks a handler here; assumed to be processed by the core system *(Inferred: Medium).* 
- Server-triggered `fsn_bank:change:bankAdd` and `fsn_bank:change:bankMinus` have no handlers in this resource *(Inferred: High).* 
- `fsn_closeATM` assigns `atmDisplay = falses`, leaving the flag true and potentially blocking reopening *(Inferred: High – probable typo).* 
- Transfers rely on external listeners to persist updated balances via `fsn_bank:database:update` *(Inferred: Medium).* 

DOCS COMPLETE
