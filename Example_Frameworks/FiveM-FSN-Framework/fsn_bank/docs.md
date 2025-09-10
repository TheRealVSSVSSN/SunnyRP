# fsn_bank Documentation

## Overview and Runtime Context
The `fsn_bank` resource supplies ATM and basic banking functionality for the FiveM-FSN framework. It exposes client-side interactions for withdrawing, depositing and transferring funds, serves a simple NUI interface, and persists account balances to the MySQL-backed character table. The resource integrates heavily with the `fsn_main` core for character identification, money HUD updates and logging.

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
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## Client
### client.lua
**Role:** Handles ATM detection, GUI control, client-side balance changes and communication with other resources.

**Key Responsibilities:**
- Defines a static list of ATM and bank coordinates and creates map blips for bank locations.
- Watches player proximity; when the player presses **E** near an ATM/bank, requests current balances and opens the NUI ATM interface.
- Receives `fsn_bank:update:both` to sync wallet and bank amounts and forwards them to NUI.
- Implements NUI callbacks for depositing, withdrawing and transferring funds with validation (numeric checks, maximum $500,000 per operation, and deposit only allowed at bank locations).
- Updates local wallet/bank values after successful transactions and emits `fsn_bank:change:bankandwallet` so the `fsn_main` money system can persist and broadcast the change.
- Triggers external logging (`fsn_main:logging:addLog`) and phone transaction recording (`fsn_phones:SYS:addTransaction`).
- Closes the interface with `fsn_main:displayBankandMoney` to restore the HUD.

**Notable Events & Flow:**
1. **Player presses E at ATM** → `fsn_bank:request:both` (local event) → handled by `fsn_main` to return balances.
2. **Server/other resource sends** `fsn_bank:update:both` → client updates money and bank variables → NUI updated via `SendNUIMessage`.
3. **Deposit/Withdraw** NUI callbacks validate input → adjust local balances → fire `fsn_bank:change:bankandwallet` → server logging and notifications.
4. **Transfer** NUI callback triggers server event `fsn_bank:transfer` with target player ID and amount; server distributes funds.

**Security/Permission Notes:**
- Deposit/withdraw/transfer amounts limited to $500,000 per call.
- Deposits require the client to be at a bank location (`atbank` flag).
- Numeric validation guards against non-number input and negative values.
- No direct server validation on deposit/withdraw; persistence relies on `fsn_bank:change:bankandwallet` being handled by the core.

**Performance Considerations:**
- ATM proximity check runs every frame (`Wait(0)`); the ATM list is large and unoptimized, which may incur CPU load on the client.
- Animations and NUI focus are handled after verifying player is within 1 unit of an ATM.

## Server
### server.lua
**Role:** Provides server-side balance persistence and transfer handling.

**Key Responsibilities:**
- Event `fsn_bank:database:update` accepts `charid`, `wallet`, and `bank` values and writes them to `fsn_characters` table. Passing `false` for a field skips its update.
- Event `fsn_bank:transfer` deducts `amount` from the source player and adds it to `receive` by dispatching `fsn_bank:change:bankMinus` and `fsn_bank:change:bankAdd` to the respective clients.
- Notifies the source player if the target `receive` ID does not correspond to a connected player.

**Security/Permission Notes:**
- Server does not double-check amounts beyond trusting client input; assumes calling client has already validated numbers and balances.
- Transfer event relies on client-side funds; database update is not triggered here, so persistence depends on clients or other resources invoking `fsn_bank:database:update` appropriately.

**DB Usage:**
- Uses `MySQL.Sync.execute` for synchronous updates to `char_money` and `char_bank` columns.

## Shared / Config
### fxmanifest.lua
**Role:** Declares resource metadata and dependencies.

- Targets `bodacious` fx_version and the `gta5` game.
- Loads utility scripts and settings from `@fsn_main` and integrates with `mysql-async` for database access.
- Registers client/server scripts and exposes the NUI page `gui/index.html` with associated assets.

## NUI
### gui/index.html
HTML layout for the ATM interface and a placeholder loan agreement section. Contains button slots around a central screen that swaps between menu, withdraw, deposit, transfer, and group-account views.

### gui/index.css
Styling for all NUI screens. Defines the ATM layout, colors, typography, and responsive states for the main menu, transaction forms, and balance area.

### gui/index.js
**Role:** Browser-side logic for the ATM interface.

- Listens for NUI messages:
  - `displayATM` toggles visibility and sets `amiatbank` flag.
  - `update` (type `wallet&bank`) refreshes displayed balances.
- Handles button clicks and plays a sound effect for ATM buttons.
- Posts callbacks (`depositMoney`, `withdrawMoney`, `transferMoney`, `toggleGUI`) back to the resource with user-entered amounts.

### Assets
- `atm_logo.png` – logo displayed in the ATM UI.
- `atm_button_sound.mp3` – click sound triggered on button press.

## Cross‑Indexes
### Events
| Event | Type | Payload | Description |
|-------|------|---------|-------------|
| `fsn_bank:change:bankandwallet` | Client net event | `wallet`, `bank` | Updates local balances and HUD. Triggered after deposit/withdraw and by external resources. |
| `fsn_bank:request:both` | Client local event | none | Requests current wallet and bank; handled externally by `fsn_main`. |
| `fsn_bank:update:both` | Client net event | `wallet`, `bank` | Sent by `fsn_main` to sync balances and update NUI. |
| `fsn_main:displayBankandMoney` | Client local event | none | Restores HUD after closing ATM. |
| `fsn_notify:displayNotification` | Client net/local | message, position, duration, type | Displays UI notifications. |
| `fsn_phones:SYS:addTransaction` | Client local | transaction table | Records transaction in phone app. |
| `fsn_main:logging:addLog` | Server net event | player ID, category, text | Logs money events on the server. |
| `fsn_bank:transfer` | Server net event | `receive`, `amount` | Moves funds between players. |
| `fsn_bank:database:update` | Server net event | `charid`, `wallet`, `bank` | Persists wallet/bank to database. |
| `fsn_bank:change:bankAdd` / `fsn_bank:change:bankMinus` | Server → client events | `amount` | Adjusts bank balances of target/source during transfers. *(Inferred: handled by core money system.)* |

### Exports
| Export | Direction | Usage |
|--------|-----------|-------|
| `fsn_main:fsn_CharID` | Used | Retrieves the character ID of the current player for logging. |

### Commands
*None defined in this resource.*

### NUI Callbacks
| Callback | Payload | Purpose |
|----------|---------|---------|
| `depositMoney` | `deposit`, `atbank` | Deposit cash to bank; requires being at bank and amount ≤ $500k. |
| `withdrawMoney` | `withdraw` | Withdraw cash from bank up to $500k. |
| `transferMoney` | `transferAmount`, `transferTo` | Transfer funds to another player ID. |
| `toggleGUI` | none | Close ATM interface. |

## Configuration & Integration
- Depends on `@fsn_main` utilities and settings for character management and HUD updates.
- Requires `mysql-async` for synchronous SQL updates to the `fsn_characters` table.
- Uses FiveM’s NUI system to render `gui/index.html` and communicate via `SendNUIMessage`/`RegisterNUICallback`.
- Expects additional resources to handle `fsn_bank:request:both`, `fsn_bank:change:bankAdd`, and `fsn_bank:change:bankMinus` events for complete money synchronization.

## Gaps & Inferences
- `fsn_bank:request:both` is registered but lacks a local handler; cross-reference shows it is processed in the `fsn_main` money module *(Inferred: Medium).* 
- Server triggers `fsn_bank:change:bankAdd`/`bankMinus` but no handlers exist here; these are likely consumed by the core money system *(Inferred: High).* 
- Deposits and withdrawals do not directly notify the server’s database updater; persistence relies on external listeners to `fsn_bank:change:bankandwallet` *(Inferred: Medium).* 
- Typo `atmDisplay = falses` in the close helper leaves `atmDisplay` true, which could reopen warnings *(Inferred: Low; potential bug).* 

DOCS COMPLETE
