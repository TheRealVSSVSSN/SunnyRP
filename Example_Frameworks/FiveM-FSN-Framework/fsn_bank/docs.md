# fsn_bank Documentation

## Overview and Runtime Context
The `fsn_bank` resource implements ATM and banking interactions for the FiveM-FSN framework. It supplies map blips for bank branches, opens a browser-based ATM interface, and coordinates balance changes with the framework’s core money system and persistent database.

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
- [Cross‑Indexes](#crossindexes)
  - [Events](#events)
  - [Exports](#exports)
  - [Commands](#commands)
  - [NUI Callbacks](#nui-callbacks)
  - [NUI Messages](#nui-messages)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## Client
### client.lua
**Role:** Drives ATM detection, NUI display, client-side balance adjustments, and event relays to other resources.

**Key Responsibilities:**
- Stores a large static table of ATM and bank coordinates and creates map blips for bank locations on startup.
- Continuously checks player proximity to any ATM; when within one unit and the player presses **E**, it requests current balances and opens the ATM interface with an animation and NUI focus.
- Handles `fsn_bank:update:both` to refresh local wallet and bank values and forward them to the NUI (`SendNUIMessage` with type `update`).
- Provides `fsn_closeATM` helper to release focus, unfreeze the player, and hide the interface (typo `atmDisplay = falses` leaves the display flag set).
- Implements NUI callbacks:
  - **depositMoney** – Validates bank-only deposits up to $500k, updates local balances, records a phone transaction, logs via `fsn_main:logging:addLog`, and fires `fsn_bank:change:bankandwallet` so the core can persist the change.
  - **withdrawMoney** – Validates withdrawals up to $500k, adjusts balances, logs the action, and fires `fsn_bank:change:bankandwallet`.
  - **transferMoney** – Validates amounts up to $500k and triggers server event `fsn_bank:transfer` to move funds to another player ID.
  - **toggleGUI** – Closes the interface.

**Security/Permission Notes:**
- All monetary actions rely on client-side checks; server trusts the incoming amounts.
- Deposits require the `bank` flag from the ATM record; withdrawals and transfers only check for positive numeric input.

**Performance Considerations:**
- The proximity loop runs every frame over a large ATM list, which may impact client CPU.

## Server
### server.lua
**Role:** Persists balances and handles inter-player transfers.

**Key Responsibilities:**
- Event `fsn_bank:database:update` receives `charid`, `wallet`, and `bank` values. It individually updates the `fsn_characters` table columns when their value is not `false` using synchronous MySQL queries.
- Event `fsn_bank:transfer` verifies the target player exists, then emits `fsn_bank:change:bankAdd` to the recipient and `fsn_bank:change:bankMinus` to the sender. If the recipient is offline, the sender receives a notification.

**Security/Permission Notes:**
- No server-side validation of amounts or sufficient funds; relies on the client to send correct data.
- Transfer does not persist to the database directly; persistence depends on subsequent `fsn_bank:database:update` calls.

**DB Usage:**
- Uses `MySQL.Sync.execute` to update `char_bank` and `char_money` fields in `fsn_characters`.

## Shared / Config
### fxmanifest.lua
**Role:** Declares resource metadata and dependencies.

- Targets `bodacious` fx_version for `gta5`.
- Loads utility scripts from `@fsn_main` and includes `@mysql-async/lib/MySQL.lua` for database access.
- Registers `client.lua` and `server.lua`, and exposes the NUI page `gui/index.html` with its assets.

## NUI
### gui/index.html
Provides the ATM interface layout along with a placeholder loan agreement section. It defines menu screens for withdraw, deposit, transfer, and a hidden group-account feature.

### gui/index.css
Styles the ATM interface, positioning buttons, screens, and balance display elements.

### gui/index.js
**Role:** Handles browser-side logic and user input.

- Listens for messages from Lua:
  - `displayATM` – Shows or hides the interface and sets a flag indicating a bank location.
  - `update` with `updateType` `wallet&bank` – Refreshes the on-screen cash and balance.
- Plays a button click sound when any main button is pressed.
- Posts callbacks back to the resource:
  - `depositMoney`, `withdrawMoney`, `transferMoney`, `toggleGUI` – forward form data for the corresponding actions.

### Assets
- `atm_logo.png` – Displayed on the ATM screen.
- `atm_button_sound.mp3` – Audio feedback for button presses.

## Cross‑Indexes
### Events
| Event | Side | Payload | Description |
|-------|------|---------|-------------|
| `fsn_bank:change:bankandwallet` | Client net/local | `wallet`, `bank` | Updates local balances and relays to HUD.
| `fsn_bank:request:both` | Client local | none | Requests current wallet and bank from the core.
| `fsn_bank:update:both` | Client net | `wallet`, `bank` | Sent by core to sync balances and update NUI.
| `fsn_main:displayBankandMoney` | Client local | none | Restores HUD after closing ATM.
| `fsn_notify:displayNotification` | Client/Server | `message`, `position`, `duration`, `type` | Displays notifications.
| `fsn_phones:SYS:addTransaction` | Client local | transaction table | Records the action in the phone app.
| `fsn_main:logging:addLog` | Server net | player ID, category, text | Logs money events.
| `fsn_bank:transfer` | Server net | `receive`, `amount` | Transfers funds between players.
| `fsn_bank:database:update` | Server net | `charid`, `wallet`, `bank` | Persists balances to database.
| `fsn_bank:change:bankAdd` / `fsn_bank:change:bankMinus` | Server → client | `amount` | Adjusts recipient and sender banks during transfers. *(Inferred: handled by core money system.)*

### Exports
| Export | Direction | Usage |
|--------|-----------|-------|
| `fsn_main:fsn_CharID` | Used | Retrieves the current character ID for logging and transactions.

### Commands
*None defined in this resource.*

### NUI Callbacks
| Callback | Payload | Purpose |
|----------|---------|---------|
| `depositMoney` | `deposit`, `atbank` | Deposit cash to bank; requires bank location and amount ≤ $500k.
| `withdrawMoney` | `withdraw` | Withdraw cash up to $500k.
| `transferMoney` | `transferAmount`, `transferTo` | Transfer funds to another player ID, capped at $500k.
| `toggleGUI` | none | Close the ATM interface.

### NUI Messages
| Message | Payload | Description |
|---------|---------|-------------|
| `displayATM` | `bank`, `enable` | Toggles the NUI ATM and notes if the player is at a bank.
| `update` (`wallet&bank`) | `wallet`, `bank` | Refreshes displayed balances.

## Configuration & Integration
- Depends on `@fsn_main` for utilities, settings, HUD updates, and character identification.
- Requires `mysql-async` for database operations.
- Uses FiveM NUI messaging (`SendNUIMessage`/`RegisterNUICallback`) to coordinate between Lua and the browser UI.

## Gaps & Inferences
- `fsn_bank:request:both` is declared but handled externally by the core money module *(Inferred: Medium).* 
- Server-triggered `fsn_bank:change:bankAdd` and `fsn_bank:change:bankMinus` lack handlers here; assumed to be processed by the core system *(Inferred: High).* 
- `fsn_closeATM` sets `atmDisplay` to `falses`, leaving the flag true and potentially preventing reopening *(Inferred: High – likely typo).* 
- Transfers do not trigger a database update; persistence depends on other listeners invoking `fsn_bank:database:update` *(Inferred: Medium).* 

DOCS COMPLETE
