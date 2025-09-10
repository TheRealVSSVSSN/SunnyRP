# fsn_admin Documentation

## Overview and Runtime Context
`fsn_admin` supplies moderation utilities for FSN-based FiveM servers. It grants privileged chat, teleportation, player management, and punishment features while integrating with the FSN framework, MySQL, and other FSN resources.

## File Inventory
- **fxmanifest.lua** – Manifest specifying active scripts and dependencies.
- **config.lua** – Steam identifier lists defining moderator and admin permissions.
- **client/client.lua** – Current client handlers for admin actions.
- **client.lua** – Legacy client logic kept for reference.
- **server/server.lua** – Active server‑side command and event definitions.
- **server.lua** – Legacy combined script containing earlier implementations.
- **server_announce.lua** – Commented example for timed restart broadcasts.
- **oldresource.lua** – Historical manifest referencing legacy scripts.

## Client Files
### client/client.lua
Role: Handles client reactions to server requests and admin utilities.

Responsibilities:
- Spawns vehicles on demand (`fsn_admin:spawnVehicle`). Vehicles are placed at the player location, set to a custom plate, registered with `fsn_cargarage`, and announced via `fsn_notify`.
- Collects the player’s current coordinates when requested (`fsn_admin:requestXYZ`) and forwards them to the server through `fsn_admin:sendXYZ`.
- Teleports the player when coordinates arrive from the server (`fsn_admin:recieveXYZ`).
- Toggles local freeze status (`fsn_admin:FreezeMe`) and emits chat notifications reflecting the state change.

### client.lua (legacy)
Role: Prior client implementation; retains teleport and freeze handlers using basic `chatMessage` outputs. Not referenced by the manifest.

## Server Files
### server/server.lua
Role: Main authority for privilege checks, command registration, and moderation flows.

Responsibilities:
- Retrieves the shared FSN object on startup to access player lookups.
- Permission helpers `isModerator`/`isAdmin` and identifier fetchers `fsn_GetModeratorId`/`fsn_GetAdminId` validate players against `Config` lists.
- **Command registration** through `registerModeratorCommands` and `registerAdminCommands`:
  - Staff chat (`sc`) for moderators or admins.
  - Placeholders for menus (`adminmenu`, `amenu`).
  - Moderation actions (`freeze`, `announce`, `goto`, `bring`, `kick`, `ban`). Console invocations of `announce`, `kick`, and `ban` are supported.
- **Suggestion registration** via `registerModeratorSuggestions`/`registerAdminSuggestions` so privileged players see guidance in the chat UI.
- **Events**:
  - `fsn_admin:enableModeratorCommands` and `fsn_admin:enableAdminCommands` initialize suggestions and command sets when a player is recognized as privileged.
  - `fsn:playerReady` fires on join, checking roles and triggering the above events.
  - `onResourceStart` ensures admin commands exist even before any admin connects.
- **Database**: `ban` writes ban duration and reason to `fsn_users` using `MySQL.Async.execute`. The query includes an extra comma before `WHERE` (Inferred High).
- **Gaps**: no handler for the client‑sent `fsn_admin:sendXYZ`, causing `goto`/`bring` to miss coordinate forwarding (Inferred High).

### server.lua (legacy)
Role: Earlier monolithic script parsing `/admin` subcommands. Contains both server and client calls and implements handlers now absent from the current server logic.

Key features:
- Parses chat commands like `/admin freeze`, `/admin goto`, `/admin bring`, `/admin kick`, `/admin ban`.
- Forwards coordinate data through `fsn_admin:sendXYZ` and teleports accordingly.
- Spawns or fixes vehicles (`fsn_admin:spawnCar`, `fsn_admin:fix`).
- Uses MySQL to store bans.
- Triggers `fsn_admin:menu:toggle` to open an admin menu (NUI integration).

### server_announce.lua (legacy)
Role: Example timer that would broadcast restart warnings at preset times. Entire script is commented out.

## Shared Files
### config.lua
Defines `Config.Moderators` and `Config.Admins` arrays of Steam identifiers. Both lists currently contain the same ID for demonstration.

### fxmanifest.lua
Declares Cerulean framework metadata and loads `client/client.lua`, `config.lua`, and `server/server.lua`. Imports `@mysql-async/lib/MySQL.lua`; no exports are listed.

### oldresource.lua (legacy)
Historical manifest that loaded legacy scripts (`client.lua`, `server.lua`, `server_announce.lua`) and utility scripts from `fsn_main`.

## Cross-Indexes
### Events
| Event | Direction | Payload | Notes |
|---|---|---|---|
| `fsn_admin:spawnVehicle` | Server → Client | `vehmodel` (string) | Creates a vehicle and notifies other resources.
| `fsn_admin:requestXYZ` | Server → Client | `sendto` (number) | Client replies with coordinates via `fsn_admin:sendXYZ`.
| `fsn_admin:sendXYZ` | Client → Server | `sendto` (number), `{x,y,z}` | **Missing handler in new server code** (Inferred High).
| `fsn_admin:recieveXYZ` | Server → Client | `{x,y,z}` | Teleports player.
| `fsn_admin:FreezeMe` | Server → Client | `adminName` (string) | Toggles freeze state.
| `fsn_admin:enableAdminCommands` | Server → Client | player ID | Registers admin suggestions.
| `fsn_admin:enableModeratorCommands` | Server → Client | player ID | Registers moderator suggestions and commands.
| `fsn:playerReady` | Server event | none | Performs role check on join.
| `onResourceStart` | Server event | `resourceName` | Pre-registers admin commands.
| `fsn_cargarage:makeMine` | Client event | vehicle, model, plate | Claims spawned vehicle.
| `fsn_notify:displayNotification` | Client event | message, position, duration, type | Displays notifications.

### Commands
| Command | Permission | Function |
|---|---|---|
| `sc` | Moderator/Admin | Staff chat broadcast.
| `adminmenu` / `amenu` | Admin | Placeholder messages for menu support.
| `freeze` | Admin | Toggle target’s frozen state.
| `announce` | Admin or console | Global announcement.
| `goto` | Admin | Teleport to target (requires `fsn_admin:sendXYZ`).
| `bring` | Admin | Bring target to admin (requires `fsn_admin:sendXYZ`).
| `kick` | Admin or console | Remove target with reason.
| `ban` | Admin or console | Ban target; durations: `1d`, `2d`, `3d`, `4d`, `5d`, `6d`, `1w`, `2w`, `3w`, `1m`, `2m`, `perm` (`2m` value appears short, Inferred Medium).
| `/ac`, `/am`, `/amenu`, `/admin *` | Admin (legacy) | Chat-based commands in `server.lua`.
| `/mod` | Moderator (legacy) | Stub, not implemented.

### Database Calls
| File & Location | Query | Purpose |
|---|---|---|
| `server/server.lua` (`ban`) | `UPDATE fsn_users SET banned = @unban, banned_r = @reason, WHERE steamid = @steamId` | Stores ban data; extra comma before `WHERE` (Inferred High).
| `server.lua` (`/admin ban`) | `UPDATE fsn_users SET banned = @unban, banned_r = @reason WHERE steamid = @steamid` | Legacy ban implementation.

### Exports
None defined.

### ESX Callbacks
None; resource uses FSN framework.

### NUI Channels
`fsn_admin:menu:toggle` – Legacy trigger to open an admin menu; no listeners in current code.

## Configuration & Integration Points
- Depends on `fsn:getFsnObject` to acquire the shared FSN API (`FSN.GetPlayerFromId`).
- Uses `@mysql-async/lib/MySQL.lua` for asynchronous database access.
- Interacts with `fsn_cargarage` and `fsn_notify` for vehicle ownership and notifications.
- Relies on FiveM chat suggestions/messages for UI feedback.

## Gaps & Inferences
- **Absent `fsn_admin:sendXYZ` handler** – Needed for `goto` and `bring` to function (Inferred High).
- **Vehicle spawn trigger source** – Client listens for `fsn_admin:spawnVehicle` without a corresponding server command; likely from an external admin menu (Inferred Low).
- **Ban duration for `2m`** – Value `529486` seconds equates to ~6 days rather than two months (Inferred Medium).
- **Database query typo** – Extra comma before `WHERE` in `server/server.lua` `ban` query (Inferred High).

DOCS COMPLETE
