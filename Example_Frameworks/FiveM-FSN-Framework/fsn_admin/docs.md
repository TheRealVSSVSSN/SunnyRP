# fsn_admin Documentation

## Overview and Runtime Context
`fsn_admin` provides administrative and moderation utilities for servers built on the FSN framework. It hooks into the FiveM event system to deliver staff‑only commands (chat, teleportation, moderation actions and bans) and reacts to server events to support vehicle spawning and player management.

## File Inventory
- **fxmanifest.lua** – FiveM manifest defining scripts and metadata.
- **config.lua** – Steam identifier lists for moderators and admins.
- **client/client.lua** – Current client logic for handling admin actions.
- **client.lua** – Legacy client implementation kept for reference.
- **server/server.lua** – Current server logic with privilege checks, command registration and ban handling.
- **server.lua** – Legacy combined server/client script retaining older chat‑based command parsing.
- **server_announce.lua** – Commented‑out restart announcement logic.
- **oldresource.lua** – Historic manifest referencing legacy scripts.

## Client Files
### client/client.lua
Handles client‑side responses to server moderation events:
- **Vehicle spawning** via `fsn_admin:spawnVehicle`, creating a vehicle at the player location and marking it as owned.
- **Teleport coordination** through `fsn_admin:requestXYZ` (collects local coordinates and sends them to the server) and `fsn_admin:recieveXYZ` (moves the player to supplied coordinates).
- **Freeze toggle** through `fsn_admin:FreezeMe`, switching a local `frozen` flag and displaying chat notifications.

### client.lua (legacy)
An older client script duplicating the teleport and freeze handlers with basic `chatMessage` output. Not loaded by the current manifest.

## Server Files
### server/server.lua
Main server logic:
- Retrieves the global `FSN` object on startup.
- Privilege helpers `isModerator`/`isAdmin` and identifier fetchers `fsn_GetModeratorId`/`fsn_GetAdminId` validate players against `Config` lists.
- **Command registration**:
  - `sc` staff chat for moderators and admins.
  - `adminmenu`/`amenu` placeholders.
  - Moderation tools `freeze`, `announce`, `goto`, `bring`, `kick`, `ban`.
- **Suggestion registration** through `chat:addSuggestion` for all supported commands when a privileged player connects.
- **Events**:
  - `fsn_admin:enableAdminCommands` and `fsn_admin:enableModeratorCommands` trigger suggestion/command setup.
  - `fsn:playerReady` checks roles on join and fires the above events.
  - `onResourceStart` pre‑registers admin commands at resource start.
- **Database**: `ban` uses `MySQL.Async.execute` to record ban data in the `fsn_users` table. The query currently includes an extra comma before `WHERE` (Inferred High).
- **Gaps**: No handler for `fsn_admin:sendXYZ`, though commands `goto`/`bring` expect the client to relay coordinates (see `server.lua`).

### server.lua (legacy)
Earlier combined script parsing `chatMessage` for admin commands (`/admin freeze`, `/admin goto`, etc.), registering server events (`fsn_admin:sendXYZ`, `fsn_admin:spawnCar`, `fsn_admin:fix`) and interacting directly with clients. Contains both server and client‑side API calls and is superseded by `server/server.lua`.

### server_announce.lua (legacy)
Commented code intended to broadcast timed restart warnings. Currently inactive.

## Shared Files
### config.lua
Defines `Config.Moderators` and `Config.Admins` arrays of Steam identifiers used by `server/server.lua` privilege checks.

### fxmanifest.lua
Resource manifest specifying metadata and listing `client/client.lua`, `config.lua`, and `server/server.lua` as active scripts. No exports are defined.

### oldresource.lua (legacy)
Historic manifest that loaded the legacy client/server scripts and restart announcer.

## Cross‑Indexes
### Events
| Event | Direction | Payload | Notes |
|---|---|---|---|
| `fsn_admin:spawnVehicle` | Server → Client | `vehmodel` (string) | Spawns vehicle on client.
| `fsn_admin:requestXYZ` | Server ↔ Client | `sendto` (number); client replies with coords | Client collects position and returns via `fsn_admin:sendXYZ` (handler missing in new server code).
| `fsn_admin:recieveXYZ` | Server → Client | `{x,y,z}` table | Teleports player.
| `fsn_admin:FreezeMe` | Server → Client | `adminName` (string) | Toggles freeze state.
| `fsn_admin:enableAdminCommands` | Server → Client | player ID | Registers admin suggestions.
| `fsn_admin:enableModeratorCommands` | Server → Client | player ID | Registers moderator suggestions and commands.
| `fsn:playerReady` | Server event | none | Triggers privilege checks.
| `onResourceStart` | Server event | `resourceName` | Pre-registers admin commands.
| `fsn_admin:sendXYZ` | Client → Server | `sendto` (number), `{x,y,z}` table | **Legacy** handler in `server.lua`; absent from current server.
| `fsn_admin:spawnCar` | Client event in legacy file | `car` model | Legacy combined script.
| `fsn_admin:fix` | Client event in legacy file | none | Repairs current vehicle.

### Commands
| Command | Permission | Function |
|---|---|---|
| `sc` | Moderator/Admin | Staff chat.
| `adminmenu` / `amenu` | Admin | Placeholder menu message.
| `freeze` | Admin | Toggle target’s frozen state.
| `announce` | Admin or server console | Broadcasts message.
| `goto` | Admin | Teleports to target (requires `fsn_admin:sendXYZ`).
| `bring` | Admin | Brings target to admin (requires `fsn_admin:sendXYZ`).
| `kick` | Admin or console | Kicks target with reason.
| `ban` | Admin or console | Bans target for defined duration (updates database).
| `/admin …`, `/ac`, etc. | Admin (legacy) | Chat‑based commands in `server.lua`.

### Database Calls
| File & Location | Query | Purpose |
|---|---|---|
| `server/server.lua` (`ban`) | `UPDATE fsn_users SET banned = @unban, banned_r = @reason, WHERE steamid = @steamId` | Stores ban duration and reason. Extra comma before `WHERE` (Inferred High).
| `server.lua` (`/admin ban`) | `UPDATE fsn_users SET banned = @unban, banned_r = @reason WHERE steamid = @steamid` | Legacy ban implementation.

### Exports
None defined.

### ESX Callbacks
None; the resource relies on the FSN framework instead of ESX.

### NUI Channels
`fsn_admin:menu:toggle` is triggered by the legacy script to open an admin menu; no NUI callbacks are implemented.

## Configuration & Integration Points
- Uses `@mysql-async/lib/MySQL.lua` for database access.
- Relies on an external `fsn:getFsnObject` event to obtain the `FSN` API for player lookups (`FSN.GetPlayerFromId`).
- Depends on `fsn_cargarage` and `fsn_notify` resources for vehicle ownership and notifications.

## Gaps & Inferences
- **Missing `fsn_admin:sendXYZ` handler** – Commands `goto` and `bring` expect the server to forward player coordinates. Legacy `server.lua` implements this forwarding (`RegisterServerEvent('fsn_admin:sendXYZ')`), but `server/server.lua` omits it. *Inferred High: new server code likely needs equivalent handler.*
- **`fsn_admin:spawnVehicle` trigger** – The client listens for this event but no server command emits it in current code; assumed to be fired by an external admin menu. *Inferred Low.*
- **Database query typo** – Extra comma before `WHERE` in the `ban` query of `server/server.lua`. *Inferred High.*
- **Extra arguments in `fsn_admin:requestXYZ`** – Server passes unused parameters when requesting coordinates. *Inferred Medium.*
- **Legacy files** – `client.lua`, `server.lua`, `server_announce.lua`, and `oldresource.lua` remain for reference but are not referenced by `fxmanifest.lua`.

DOCS COMPLETE
