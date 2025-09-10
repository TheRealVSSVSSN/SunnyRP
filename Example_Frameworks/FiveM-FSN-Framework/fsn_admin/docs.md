# fsn_admin Documentation

## Overview and Runtime Context
`fsn_admin` supplies moderation utilities for FSN-based FiveM servers. It grants privileged chat, teleportation, player management and punishment features while integrating with the FSN framework, MySQL and other FSN resources.

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
| docs.md | Docs | This documentation file. |

## Client Files
### client/client.lua
Role: Handles client reactions to server requests and admin utilities.

Responsibilities:
- Spawns vehicles on demand (`fsn_admin:spawnVehicle`). Vehicles are placed at the player location, registered with `fsn_cargarage`, and announced via `fsn_notify`.
- Collects the player’s current coordinates when requested (`fsn_admin:requestXYZ`) and forwards them to the server through `fsn_admin:sendXYZ`.
- Teleports the player when coordinates arrive from the server (`fsn_admin:recieveXYZ`).
- Toggles local freeze status (`fsn_admin:FreezeMe`) and emits chat notifications reflecting the state change.
- Relies on an external `SpawnVehicle` utility to instantiate vehicles (Inferred Low).

### client.lua (legacy)
Role: Earlier client implementation using basic `chatMessage` outputs; retains teleport and freeze handlers.

## Server Files
### server/server.lua
Role: Main authority for privilege checks, command registration, and moderation flows.

Responsibilities:
- **FSN Object Retrieval**: A thread repeatedly triggers `fsn:getFsnObject` until the shared API is acquired; lack of delay in the loop may consume CPU (Inferred High).
- **Permission Helpers**: `isModerator`/`isAdmin` validate players against `Config` lists. `fsn_GetModeratorId`/`fsn_GetAdminId` return player names for message templates.
- **Command Registration**:
  - `registerModeratorCommands` creates `/sc` for staff chat. Each moderator reconnect re-registers the command, possibly causing duplicates (Inferred Medium).
  - `registerAdminCommands` establishes `/sc`, `/adminmenu`, `/amenu`, `/freeze`, `/announce`, `/goto`, `/bring`, `/kick`, and `/ban`. Console access is allowed for `announce`, `kick`, and `ban`.
- **Suggestion Helpers**: `registerModeratorSuggestions` and `registerAdminSuggestions` add chat suggestions. Functions are duplicated later in file (Inferred Low).
- **Events**:
  - `fsn_admin:enableModeratorCommands` runs suggestions and command registration when a moderator joins.
  - `fsn_admin:enableAdminCommands` adds admin suggestions. Admin commands are pre-registered on resource start.
  - `fsn:playerReady` checks permissions after a player connects.
  - `onResourceStart` ensures admin commands exist even if no admin is online.
- **Teleportation**: `/goto` and `/bring` request coordinates via `fsn_admin:requestXYZ`, sending an extra unused target parameter (Inferred Medium). The server lacks a `fsn_admin:sendXYZ` handler, so returns are ignored (Inferred High).
- **Punishment**: `/kick` and `/ban` remove players. `ban` writes to `fsn_users`, but the query includes an extra comma before `WHERE` (Inferred High). Duration table assigns `4d` to `354600` seconds and `2m` to roughly six days (Inferred High).

### server.lua (legacy)
Role: Earlier monolithic script parsing chat commands. Implements handlers now absent from the current server logic.

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
| `fsn_admin:spawnVehicle` | Server → Client | `vehmodel` (string) | Creates a vehicle and notifies other resources; no server command triggers it (Inferred Low). |
| `fsn_admin:requestXYZ` | Server → Client | `sendto` (number) | Server also sends an extra target ID ignored by the client (Inferred Medium). |
| `fsn_admin:sendXYZ` | Client → Server (legacy) | `sendto` (number), `{x,y,z}` | No handler in current server code; legacy server forwards coordinates (Inferred High). |
| `fsn_admin:recieveXYZ` | Server → Client | `{x,y,z}` | Teleports player. |
| `fsn_admin:FreezeMe` | Server → Client | `adminName` (string) | Toggles freeze state. |
| `fsn_admin:enableAdminCommands` | Server event | player ID | Registers admin suggestions. |
| `fsn_admin:enableModeratorCommands` | Server event | player ID | Registers moderator suggestions and `/sc` command; duplicates are possible (Inferred Medium). |
| `fsn:playerReady` | Server event | none | Performs role check on join. |
| `onResourceStart` | Server event | `resourceName` | Pre-registers admin commands. |
| `chat:addMessage` | Server → Client | template, args | Sends staff chat and feedback messages. |
| `chat:addSuggestion` | Server → Client | command, help, args | Populates chat suggestions. |
| `fsn:getFsnObject` | Server event | callback | Retrieves shared FSN API; loop lacks wait (Inferred High). |
| `fsn_cargarage:makeMine` | Client event | vehicle, model, plate | Claims spawned vehicle. |
| `fsn_notify:displayNotification` | Client event | message, position, duration, type | Displays notifications. |
| `fsn_admin:spawnCar` | Net event (legacy) | `car` (model name) | Spawns vehicle using client natives in server script (Inferred High). |
| `fsn_admin:fix` | Net event (legacy) | none | Repairs vehicle; uses client natives in server script (Inferred High). |
| `fsn_admin:menu:toggle` | Server → Client → NUI | none | Opens admin menu (legacy). |
| `chatMessage` | Server event (legacy) | source, auth, msg | Parses chat-based commands. |

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
| `ban` | Admin or console | Ban target; durations: `1d`, `2d`, `3d`, `4d`, `5d`, `6d`, `1w`, `2w`, `3w`, `1m`, `2m`, `perm` (`4d` and `2m` miscalculated, Inferred High). |
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
| `server.lua` (`/admin ban`) | `UPDATE fsn_users SET banned = @unban, banned_r = @reason WHERE steamid = @steamid` | Legacy ban implementation | Times table contains typos for `4d` and `2m` (Inferred High). |

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
- **Missing `fsn_admin:sendXYZ` handler** – Needed for `goto` and `bring` to function (Inferred High).
- **`fsn_admin:requestXYZ` parameter mismatch** – Server sends an unused extra argument (Inferred Medium).
- **Duplicate suggestion helpers** – `registerModeratorSuggestions`/`registerAdminSuggestions` appear twice (Inferred Low).
- **Repeated `sc` registration** – `registerModeratorCommands` registers a global command each time it runs (Inferred Medium).
- **Ban durations mis-specified** – `4d` uses 354600 seconds and `2m` equals ~6 days (Inferred High).
- **Database query typo** – Extra comma before `WHERE` in `server/server.lua` `ban` query (Inferred High).
- **Busy wait for FSN object** – Thread loops without delay until FSN object is available (Inferred High).
- **Legacy server.lua mixes contexts** – Uses client natives in a server script (Inferred High).
- **Vehicle spawn trigger source** – Client listens for `fsn_admin:spawnVehicle` without a corresponding server command; likely from an external admin menu (Inferred Low).
- **`SpawnVehicle` utility missing** – Assumed provided by another resource (Inferred Low).

TODO:
- Determine origin of `fsn_admin:spawnVehicle` trigger and document its invocation once identified.

DOCS COMPLETE
