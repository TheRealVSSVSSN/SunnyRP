# fsn_admin Documentation

## Overview and Runtime Context
`fsn_admin` supplies moderation utilities for FSN-based FiveM servers. It grants privileged chat, teleportation, player management, and punishment features while integrating with the FSN framework, MySQL, and other FSN resources.

## File Inventory
| Path | Type | Description |
|---|---|---|
| fxmanifest.lua | Shared | Manifest declaring scripts and dependencies. |
| config.lua | Shared | Steam identifier lists defining moderator and admin permissions. |
| client/client.lua | Client | Current client handlers for admin actions. |
| client.lua | Client (legacy) | Prior client implementation retained for reference. |
| server/server.lua | Server | Active server-side command and event definitions. |
| server.lua | Server (legacy) | Earlier monolithic script containing command parsing and mixed logic. |
| server_announce.lua | Server (legacy) | Commented example for timed restart broadcasts. |
| oldresource.lua | Shared (legacy) | Historical manifest referencing legacy scripts. |

## Client Files
### client/client.lua
Role: Handles client reactions to server requests and admin utilities.

Responsibilities:
- Spawns vehicles on demand (`fsn_admin:spawnVehicle`). Vehicles are placed at the player location, registered with `fsn_cargarage`, and announced via `fsn_notify`.
- Collects the player’s current coordinates when requested (`fsn_admin:requestXYZ`) and forwards them to the server through `fsn_admin:sendXYZ`.
- Teleports the player when coordinates arrive from the server (`fsn_admin:recieveXYZ`).
- Toggles local freeze status (`fsn_admin:FreezeMe`) and emits chat notifications reflecting the state change.
- Utilizes an external `SpawnVehicle` utility (origin not in this resource).

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
  - `registerModeratorCommands` re-registers `sc` each time it runs, which may conflict if multiple moderators connect (Inferred Medium).
- **Suggestion registration** via `registerModeratorSuggestions`/`registerAdminSuggestions` so privileged players see guidance in the chat UI. These functions are duplicated later in the file (Inferred Low).
- **Events**:
  - `fsn_admin:enableModeratorCommands` and `fsn_admin:enableAdminCommands` initialize suggestions and command sets when a player is recognized as privileged.
  - `fsn:playerReady` fires on join, checking roles and triggering the above events.
  - `onResourceStart` ensures admin commands exist even before any admin connects.
- **Teleportation**: `goto` and `bring` request coordinates from targets via `fsn_admin:requestXYZ` but pass an extra unused argument (Inferred Medium). The client responds with `fsn_admin:sendXYZ`, yet no handler exists here (Inferred High).
- **Database**: `ban` writes ban duration and reason to `fsn_users` using `MySQL.Async.execute`. The query includes an extra comma before `WHERE` (Inferred High).

### server.lua (legacy)
Role: Earlier monolithic script parsing `/admin` subcommands. Contains both server and client calls and implements handlers now absent from the current server logic.

Key features:
- Parses chat commands like `/ac`, `/am`, `/amenu`, `/admin freeze`, `/admin goto`, `/admin bring`, `/admin kick`, `/admin ban`, and `/admin announce`.
- Forwards coordinate data through `fsn_admin:sendXYZ` and teleports accordingly.
- Spawns or fixes vehicles (`fsn_admin:spawnCar`, `fsn_admin:fix`) using client natives within a server file (Inferred High).
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
| `fsn_admin:spawnVehicle` | Server → Client | `vehmodel` (string) | Creates a vehicle and notifies other resources. |
| `fsn_admin:requestXYZ` | Server → Client | `sendto` (number) | Server also sends an extra target ID ignored by the client (Inferred Medium). |
| `fsn_admin:sendXYZ` | Client → Server | `sendto` (number), `{x,y,z}` | No handler in current server code; legacy server forwards coordinates (Inferred High). |
| `fsn_admin:recieveXYZ` | Server → Client | `{x,y,z}` | Teleports player. |
| `fsn_admin:FreezeMe` | Server → Client | `adminName` (string) | Toggles freeze state. |
| `fsn_admin:enableAdminCommands` | Server event | player ID | Registers admin suggestions. |
| `fsn_admin:enableModeratorCommands` | Server event | player ID | Registers moderator suggestions and commands. |
| `fsn:playerReady` | Server event | none | Performs role check on join. |
| `onResourceStart` | Server event | `resourceName` | Pre-registers admin commands. |
| `chat:addMessage` | Server → Client | template, args | Sends staff chat and feedback messages. |
| `chat:addSuggestion` | Server → Client | command, help, args | Populates chat suggestions. |
| `fsn_admin:spawnCar` | Net event (legacy client) | `car` (model name) | Spawns vehicle locally; defined in legacy server.lua (Inferred High). |
| `fsn_admin:fix` | Net event (legacy client) | none | Repairs current vehicle; legacy only (Inferred High). |
| `fsn_admin:menu:toggle` | Client → NUI | none | Opens admin menu (legacy). |
| `chatMessage` | Server event (legacy) | source, auth, msg | Parses chat-based commands. |
| `fsn_cargarage:makeMine` | Client event | vehicle, model, plate | Claims spawned vehicle. |
| `fsn_notify:displayNotification` | Client event | message, position, duration, type | Displays notifications. |

### Commands
| Command | Permission | Function |
|---|---|---|
| `sc` | Moderator/Admin | Staff chat broadcast. |
| `adminmenu` / `amenu` | Admin | Placeholder messages for menu support. |
| `freeze` | Admin | Toggle target’s frozen state. |
| `announce` | Admin or console | Global announcement. |
| `goto` | Admin | Teleport to target (requires `fsn_admin:sendXYZ`). |
| `bring` | Admin | Bring target to admin (requires `fsn_admin:sendXYZ`). |
| `kick` | Admin or console | Remove target with reason. |
| `ban` | Admin or console | Ban target; durations: `1d`, `2d`, `3d`, `4d`, `5d`, `6d`, `1w`, `2w`, `3w`, `1m`, `2m`, `perm` (`2m` ≈ 6 days, Inferred Medium). |
| `/ac` | Admin (legacy) | Staff chat via old command. |
| `/am`, `/amenu` | Admin (legacy) | Toggle admin menu. |
| `/admin freeze` | Admin (legacy) | Toggle frozen state via chat command. |
| `/admin announce` | Admin (legacy) | Global announcement via chat command. |
| `/admin goto` | Admin (legacy) | Teleport to target (legacy). |
| `/admin bring` | Admin (legacy) | Bring target to admin (legacy). |
| `/admin kick` | Admin (legacy) | Kick target via chat command. |
| `/admin ban` | Admin (legacy) | Ban target via chat command. |
| `/mod` | Moderator (legacy) | Stub, not implemented. |

### Database Calls
| File & Location | Query | Purpose | Notes |
|---|---|---|---|
| `server/server.lua` (`ban`) | `UPDATE fsn_users SET banned = @unban, banned_r = @reason, WHERE steamid = @steamId` | Stores ban data | Extra comma before `WHERE` breaks query (Inferred High). |
| `server.lua` (`/admin ban`) | `UPDATE fsn_users SET banned = @unban, banned_r = @reason WHERE steamid = @steamid` | Legacy ban implementation | Uses MySQL Async. |

### NUI Channels
| Channel | Purpose |
|---|---|
| `fsn_admin:menu:toggle` | Opens admin menu UI (legacy). |

### Exports
None defined.

### ESX Callbacks
None; resource uses FSN framework.

## Configuration & Integration Points
- Depends on `fsn:getFsnObject` to acquire the shared FSN API (`FSN.GetPlayerFromId`).
- Uses `@mysql-async/lib/MySQL.lua` for asynchronous database access.
- Relies on `fsn_cargarage` and `fsn_notify` for vehicle ownership and notifications.
- Utilizes FiveM chat events for command suggestions and message display.

## Gaps & Inferences
- **Absent `fsn_admin:sendXYZ` handler** – Needed for `goto` and `bring` to function (Inferred High).
- **`fsn_admin:requestXYZ` parameter mismatch** – Server sends an unused extra argument (Inferred Medium).
- **Duplicate suggestion helpers** – `registerModeratorSuggestions`/`registerAdminSuggestions` appear twice (Inferred Low).
- **Repeated `sc` registration** – `registerModeratorCommands` registers a global command each time it runs (Inferred Medium).
- **Ban duration for `2m`** – Value `529486` seconds equates to ~6 days rather than two months (Inferred Medium).
- **Database query typo** – Extra comma before `WHERE` in `server/server.lua` `ban` query (Inferred High).
- **Legacy server.lua mixes contexts** – Uses client natives in a server script (Inferred High).
- **Vehicle spawn trigger source** – Client listens for `fsn_admin:spawnVehicle` without a corresponding server command; likely from an external admin menu (Inferred Low).
- **`SpawnVehicle` utility missing** – Assumed provided by another resource (Inferred Low).

DOCS COMPLETE
