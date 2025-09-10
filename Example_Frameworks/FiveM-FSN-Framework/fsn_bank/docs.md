# fsn_bank Documentation

## Overview and Runtime Context
The `fsn_bank` resource equips the FiveM-FSN framework with ATM and bank branch interactions. It presents map blips for branches, opens a browser-based ATM UI, and relays balance changes to the framework's core money system and database.

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
**Role:** Provides in‑world ATM interaction, maintains local wallet/bank balances, and relays transactions to other systems.

**Key Responsibilities:**
- Stores coordinates for all ATMs and bank branches; creates map blips for branch locations at startup.
- Runs a proximity loop that checks the player's distance every frame. When within one unit and **E** is pressed, requests balances via `fsn_bank:request:both`, plays the ATM animation, and shows the NUI with focus.
- Handles `fsn_bank:update:both` to set `moneys` and `banks` variables and forward them to the NUI.
- `fsn_closeATM` unfreezes the player, hides the interface, notifies the HUD through `fsn_main:displayBankandMoney`, and attempts to reset the `atmDisplay` flag; `atmDisplay = falses` leaves it true *(Inferred: High).* 
- NUI callbacks:
  - **depositMoney** – Ensures deposits occur at a bank and amount ≤ $500k, updates local balances, records a phone transaction, logs via `fsn_main:logging:addLog`, and emits `fsn_bank:change:bankandwallet`.
  - **withdrawMoney** – Validates amount ≤ $500k, adjusts balances, records a transaction, logs, and emits `fsn_bank:change:bankandwallet`.
  - **transferMoney** – Checks amount and recipient ID, ensures sufficient funds, and triggers server event `fsn_bank:transfer`.
  - **toggleGUI** – Closes the interface.

**Security/Permission Notes:**
- All amount checks run client side; the server trusts incoming data.

**Performance Considerations:**
- The proximity loop iterates every frame through the entire ATM list.
- Animation dictionaries are loaded without throttling.

## Server
### server.lua
**Role:** Persists balance changes and executes inter‑player transfers.

**Key Responsibilities:**
- `fsn_bank:database:update` receives `charid`, `wallet`, and `bank`, updating `fsn_characters` table columns individually when values are provided.
- `fsn_bank:transfer` verifies the recipient player is online, then triggers `fsn_bank:change:bankAdd` for the receiver and `fsn_bank:change:bankMinus` for the sender. If the recipient is missing, the source gets a notification.

**Security/Permission Notes:**
- Amounts and balance sufficiency are not validated server side.
- Transfers do not persist automatically; another system must call `fsn_bank:database:update`.

**DB Usage & Performance:**
- Uses blocking `MySQL.Sync.execute` calls which may stall the server thread.

## Shared / Config
### fxmanifest.lua
**Role:** Declares resource metadata and dependencies.

- Sets `bodacious` as `fx_version` for GTA V.
- Loads utilities from `@fsn_main` and includes `@mysql-async/lib/MySQL.lua` for database access.
- Registers `client.lua` and `server.lua` and exposes the NUI page and assets.

## NUI
### gui/index.html
Defines the ATM interface with screens for withdraw, deposit, transfer, a hidden group-account panel, and a placeholder loan agreement.

### gui/index.css
Styles layout, buttons, and fonts for the ATM interface.

### gui/index.js
**Role:** Browser-side controller handling user interaction.

- Listens for messages:
  - `displayATM` – Shows or hides the interface and notes if the player is at a bank branch.
  - `update` with `updateType` `wallet&bank` – Updates on-screen cash and bank values.
- Plays a button-click sound on main button interaction.
- Posts callbacks back to Lua:
  - `depositMoney`, `withdrawMoney`, `transferMoney`, `toggleGUI`.

### Assets
- `atm_logo.png` – Logo displayed on the ATM.
- `atm_button_sound.mp3` – Sound played when buttons are pressed.

## Cross‑Indexes
### Events
| Event | Direction | Payload | Description |
|-------|-----------|---------|-------------|
| `fsn_bank:change:bankandwallet` | Client local | wallet, bank | Broadcasts new balances for HUD/persistence *(Inferred: High – handled externally).* |
| `fsn_bank:request:both` | Client local | none | Requests current balances *(Inferred: Medium – handled externally).* |
| `fsn_bank:update:both` | Server → client | wallet, bank | Syncs balances and updates NUI. |
| `fsn_main:displayBankandMoney` | Client local | none | Restores HUD after closing ATM. |
| `fsn_notify:displayNotification` | Both | message, position, duration, type | Shows on-screen notifications. |
| `fsn_phones:SYS:addTransaction` | Client local | transaction table | Records activity in the phone app. |
| `fsn_main:logging:addLog` | Client → server | player ID, category, text | Stores money logs. |
| `fsn_bank:transfer` | Client → server | receive, amount | Moves funds to another player. |
| `fsn_bank:database:update` | Client → server | charid, wallet, bank | Persists balances to database. |
| `fsn_bank:change:bankAdd` | Server → client | amount | Adds to recipient bank during transfer *(Inferred: High – processed by core).* |
| `fsn_bank:change:bankMinus` | Server → client | amount | Deducts from sender bank during transfer *(Inferred: High – processed by core).* |

### Exports
| Export | Direction | Purpose |
|--------|-----------|---------|
| `fsn_main:fsn_CharID` | Used | Retrieves the character ID for logging. |

### Commands
*None defined in this resource.*

### NUI Callbacks
| Callback | Payload | Purpose |
|----------|---------|---------|
| `depositMoney` | deposit, atbank | Deposit cash to bank; requires bank location and amount ≤ $500k. |
| `withdrawMoney` | withdraw | Withdraw cash up to $500k. |
| `transferMoney` | transferAmount, transferTo | Transfer funds to another player ID, capped at $500k. |
| `toggleGUI` | none | Close the ATM interface. |

### NUI Messages
| Message | Payload | Description |
|---------|---------|-------------|
| `displayATM` | bank, enable | Toggles ATM UI and notes if at a bank branch. |
| `update` (`wallet&bank`) | wallet, bank | Refreshes displayed balances. |

## Configuration & Integration
- Depends on `@fsn_main` for utilities, settings, HUD updates, and character identification.
- Requires `mysql-async` for database operations.
- Uses FiveM NUI messaging to coordinate between Lua and the browser UI.

## Gaps & Inferences
- `fsn_bank:change:bankandwallet` is emitted but unhandled within this resource; the core money module likely listens *(Inferred: High).* 
- `fsn_bank:request:both` lacks a handler here; assumed to be processed by the core system *(Inferred: Medium).* 
- `fsn_bank:change:bankAdd` and `fsn_bank:change:bankMinus` have no handlers in this resource *(Inferred: High).* 
- `fsn_closeATM` assigns `atmDisplay = falses`, leaving the flag true and potentially blocking reopening *(Inferred: High – probable typo).* 
- Transfers rely on external listeners to persist updated balances via `fsn_bank:database:update` *(Inferred: Medium).* 

DOCS COMPLETE
