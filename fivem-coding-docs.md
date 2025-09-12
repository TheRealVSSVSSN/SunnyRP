# FiveM Coding Docs — Server & Resource Development

## Table of Contents
1. [Overview](#overview)
2. [Environment Setup (FXServer, server.cfg, txAdmin)](#environment-setup-fxserver-servercfg-txadmin)
3. [Resource Anatomy & `fxmanifest.lua`](#resource-anatomy--fxmanifestlua)
4. [Runtimes: Lua, JavaScript, C#](#runtimes-lua-javascript-c)
5. [Events: Listening, Triggering, Net Events](#events-listening-triggering-net-events)
6. [ConVars & Commands](#convars--commands)
7. [Networking & Sync: OneSync + State Bags](#networking--sync-onesync--state-bags)
8. [Access Control (ACL), Principals, Permissions](#access-control-acl-principals-permissions)
9. [Debugging & Profiling](#debugging--profiling)
10. [Security & Best Practices Checklist](#security--best-practices-checklist)
11. [Appendices](#appendices)
    - [Minimal Templates (Lua/JS)](#minimal-templates-luajs)
    - [server.cfg Template](#servercfg-template)
12. [References](#references)
13. [Natives Index (Client / Server, by Category)](#natives-index-client--server-by-category)
    - [Taxonomy & Scope Notes](#taxonomy--scope-notes)
    - [Client Natives by Category](#client-natives-by-category)
    - [Server Natives by Category](#server-natives-by-category)

---

## Overview
A FiveM server is built from individual **resources** that contain scripts, configuration, and optional streamed assets. Each resource is independently startable via a manifest (`fxmanifest.lua`) and communicates using **events** and replicated **state**. Server behavior is extended with **ConVars/commands**, **ACL** for permissions, and **OneSync** for large-scale entity synchronization. [`Docs: Intro to resources`](https://docs.fivem.net/docs/scripting-manual/introduction/introduction-to-resources/)

---

## Environment Setup (FXServer, `server.cfg`, txAdmin)
### Vanilla FXServer
1. Download the latest artifact for your OS.
2. Extract binaries to a `server` folder.
3. Clone `cfx-server-data` to a separate `server-data` folder.
4. Create `server.cfg` in `server-data` and add your license key.
5. Start the server:
   - **Windows**: `FXServer.exe +exec server.cfg`
   - **Linux**: `bash ~/FXServer/server/run.sh +exec server.cfg`

### txAdmin Quick Setup
1. Run `FXServer.exe` and open the browser setup page.
2. Link your Cfx.re account and create an admin password.
3. Select the “CFX Default FiveM” recipe and enter your license key.
4. Deploy the recipe and click **Save & Run Server**.

#### txAdmin Features
- Web dashboard for live console, resource control, and player list.
- Schedule restarts and backups.
- Built‑in diagnostics for resource crashes and performance.

### Minimal `server.cfg`
```cfg
# Identity
sv_hostname "Sunny RP Dev"
sv_licenseKey "CHANGE_ME"

# Networking
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"
sv_maxclients 48

# Resources
ensure chat
ensure my_resource
```
[`Docs: Vanilla setup`](https://docs.fivem.net/docs/server-manual/setting-up-a-server-vanilla/) · [`Docs: txAdmin setup`](https://docs.fivem.net/docs/server-manual/setting-up-a-server-txadmin/)

---

## Resource Anatomy & `fxmanifest.lua`
Resources live under `resources/` and must include a manifest. Typical fields:
- `fx_version`, `game`
- `name`, `author`, `description`, `version`
- `client_scripts`, `server_scripts`, `shared_scripts`
- `files`, `ui_page`, `dependencies`

### Example: Lua Resource
```lua
-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

name 'my_lua'
author 'VSSVSSN'
version '1.0.0'

client_scripts { 'client/main.lua' }
server_scripts { 'server/main.lua' }
shared_scripts { 'shared/config.lua' }
```

### Example: JavaScript Resource
```lua
-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

name 'my_js'
author 'VSSVSSN'
version '1.0.0'

client_scripts { 'client/main.js' }
server_scripts { 'server/main.js' }
```
[`Docs: Resource manifest`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/) · [`Docs: Intro to resources`](https://docs.fivem.net/docs/scripting-manual/introduction/introduction-to-resources/)

---

## Runtimes: Lua, JavaScript, C#
FiveM ships multiple scripting runtimes.

### Lua
```lua
-- client/main.lua
--[[
    -- Type: Function
    -- Name: showCoords
    -- Use: Prints player coordinates to chat
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('whereami', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerEvent('chat:addMessage', {
        args = { '[POS]', ('x=%.2f y=%.2f z=%.2f'):format(coords.x, coords.y, coords.z) }
    })
end, false)
```

### JavaScript
```javascript
// client/main.js
RegisterCommand('whereami', () => {
  const ped = PlayerPedId();
  const [x, y, z] = GetEntityCoords(ped);
  emit('chat:addMessage', { args: ['[POS]', `x=${x.toFixed(2)} y=${y.toFixed(2)} z=${z.toFixed(2)}`] });
}, false);
```

### C#
```csharp
// Client/Main.cs
using CitizenFX.Core;
using static CitizenFX.Core.Native.API;

public class Example : BaseScript
{
    public Example()
    {
        TriggerEvent("chat:addMessage", new { args = new[] { "[INIT]", "C# loaded" } });
    }
}
```
[`Docs: Lua runtime`](https://docs.fivem.net/docs/scripting-manual/runtimes/lua/) · [`Docs: JavaScript runtime`](https://docs.fivem.net/docs/scripting-manual/runtimes/javascript/) · [`Docs: C# runtime`](https://docs.fivem.net/docs/scripting-manual/runtimes/csharp/)

---

## Events: Listening, Triggering, Net Events
Events connect scripts locally and over the network.

### Listening
```lua
-- server/main.lua
RegisterNetEvent('hello')
AddEventHandler('hello', function(msg)
    print(('Player %s says %s'):format(source, msg))
end)
```
```javascript
// server/main.js
onNet('hello', (msg) => {
  console.log(`Player ${global.source} says ${msg}`);
});
```

### Triggering
```lua
-- client/main.lua
TriggerServerEvent('hello', 'hi server')
```
```javascript
// server/main.js
on('playerJoining', (name) => {
  emitNet('hello', source, `welcome ${name}`);
});
```

### Client ↔ Server Flow
```
client TriggerServerEvent ───▶ server AddEventHandler
server TriggerClientEvent ───▶ client AddEventHandler
```
- `source` (Lua) or `global.source` (JS) identifies the caller on the server.
- In C#, use a parameter marked `[FromSource]` to capture the caller.
- Use `CancelEvent()` to stop default handling.
- Validate all parameters before use.

### Validation & Cancellation
```lua
-- server/main.lua
RegisterNetEvent('buyItem')
AddEventHandler('buyItem', function(price)
    if price > 1000 then
        CancelEvent() -- reject exploit attempt
        return
    end
    -- process purchase
end)
```
```javascript
// server/main.js
onNet('buyItem', (price) => {
  if (price > 1000) {
    CancelEvent(); // reject exploit attempt
    return;
  }
  // process purchase
});
```
[`Docs: Listening for events`](https://docs.fivem.net/docs/scripting-manual/working-with-events/listening-for-events/) · [`Docs: Triggering events`](https://docs.fivem.net/docs/scripting-manual/working-with-events/triggering-events/) · [`Docs: Event cancellation`](https://docs.fivem.net/docs/scripting-manual/working-with-events/event-cancelation/)

---

## ConVars & Commands
ConVars are server configuration variables accessible at runtime.

### Setting & Getting
```lua
-- server/main.lua
SetConvar('voiceEnabled', 'true')      -- set a ConVar
local enabled = GetConvar('voiceEnabled', 'false') -- read with fallback
```
```javascript
// server/main.js
setConvar('voiceEnabled', 'true'); // set a ConVar
const enabled = GetConvar('voiceEnabled', 'false'); // read with fallback
```

### Server Replicated
```lua
SetConvarReplicated('weather', 'RAIN')
local w = GetConvar('weather', 'CLEAR') -- works on client & server
```
```javascript
// server/main.js
SetConvarReplicated('weather', 'RAIN');
const w = GetConvar('weather', 'CLEAR'); // works on client & server
```

### Registering Commands
```lua
-- server/main.lua
-- Restricted command guarded by ACL
RegisterCommand('announce', function(src, args)
    if #args == 0 then return end
    TriggerClientEvent('chat:addMessage', -1, { args = { '[ANN]', table.concat(args, ' ') } })
end, true) -- true => requires command.announce permission
```
```javascript
// server/main.js
// Restricted command guarded by ACL
RegisterCommand('announce', (src, args) => {
  if (!args.length) return;
  emitNet('chat:addMessage', -1, { args: ['[ANN]', args.join(' ')] });
}, true); // true => requires command.announce permission
```
[`Docs: ConVars`](https://docs.fivem.net/docs/scripting-reference/convars/) · [`Docs: Server commands`](https://docs.fivem.net/docs/server-manual/server-commands/)

---

## Networking & Sync: OneSync + State Bags
OneSync increases player slots and provides server‑authoritative entity state. Use **state bags** to store replicated key/value pairs.

### State Bag Basics
```lua
-- server/main.lua
local veh = GetVehiclePedIsIn(GetPlayerPed(source), false)
Entity(veh).state:set('owner', source, true) -- replicate to clients
```
```javascript
// client/main.js
const veh = GetVehiclePedIsIn(PlayerPedId(), false);
console.log(Entity(veh).state.owner); // read replicated value
```

### Change Handlers
```lua
-- any side
AddStateBagChangeHandler('owner', nil, function(bagName, key, value)
    print(('Entity %s new owner %s'):format(bagName, value))
end)
```
```javascript
// any side
AddStateBagChangeHandler('owner', null, (bagName, key, value) => {
  console.log(`Entity ${bagName} new owner ${value}`);
});
```
- Use replicated flags (`true` parameter) to sync from clients to server when needed.
[`Docs: OneSync`](https://docs.fivem.net/docs/scripting-reference/onesync/) · [`Docs: State bags`](https://docs.fivem.net/docs/scripting-manual/networking/state-bags/)

---

## Access Control (ACL), Principals, Permissions
ACL secures commands and resources.

```cfg
# server.cfg
add_ace group.admin command allow
add_ace group.admin command.quit deny
add_principal identifier.fivem:123456 group.admin
```
- `add_ace principal object allow|deny`
- `add_principal child parent`
- `remove_ace`, `remove_principal`, `test_ace` for checks (`test_ace group.admin vehicle.spawn`)

### Checking Permissions in Scripts
```lua
-- server/main.lua
RegisterCommand('car', function(src)
    if not IsPlayerAceAllowed(src, 'vehicle.spawn') then
        TriggerClientEvent('chat:addMessage', src, { args = { '[ERROR]', 'No permission' } })
        return
    end
    -- spawn vehicle here
end)
```
```javascript
// server/main.js
RegisterCommand('car', (src) => {
  if (!IsPlayerAceAllowed(src, 'vehicle.spawn')) {
    emitNet('chat:addMessage', src, { args: ['[ERROR]', 'No permission'] });
    return;
  }
  // spawn vehicle here
});
```
[`Docs: Server commands (ACL section)`](https://docs.fivem.net/docs/server-manual/server-commands/)

---

## Debugging & Profiling
- **Client console (F8)** for runtime logs and errors.
- **Server console** prints resource output.
- `resmon 1` displays per-resource CPU and memory usage.
- **Profiler** (`profiler record <ms>` then `profiler view`) highlights performance hotspots.
- txAdmin's web console streams logs and runs commands remotely.
[`Docs: Using the profiler`](https://docs.fivem.net/docs/scripting-manual/debugging/using-profiler/)

---

## Security & Best Practices Checklist
- Re‑validate all client input on the server; never trust the client.
- Rate‑limit expensive events; cancel invalid calls with `CancelEvent()`.
- Prefer state bags over ad‑hoc globals for synced data.
- Keep resources non-blocking (`Citizen.Wait`/`setTimeout`) to avoid hitching.
- Guard commands/resources with ACL principals.
- Track changes in version control and document resources.
[`Docs: Best practices`](https://docs.fivem.net/docs/scripting-manual/introduction/best-practices/)

---

## Appendices
### Minimal Templates (Lua/JS)
```lua
-- client/main.lua
RegisterCommand('ping', function()
    TriggerEvent('chat:addMessage', { args = {'[PONG]', 'pong!'} })
end)

-- server/main.lua
RegisterCommand('announce', function(src, args)
    if #args == 0 then return end
    TriggerClientEvent('chat:addMessage', -1, { args = { '[ANN]', table.concat(args, ' ') } })
end, true)
```
```javascript
// client/main.js
RegisterCommand('ping', () => {
  emit('chat:addMessage', { args: ['[PONG]', 'pong!'] });
});

// server/main.js
RegisterCommand('announce', (src, args) => {
  if (!args.length) return;
  emitNet('chat:addMessage', -1, { args: ['[ANN]', args.join(' ')] });
}, true);
```

### `server.cfg` Template
```cfg
sv_hostname "Sunny RP Dev"
sv_licenseKey "CHANGE_ME"
sv_maxclients 48
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

add_ace group.admin command allow
add_principal identifier.fivem:123456 group.admin

ensure chat
ensure my_resource
```

---

## References
- https://docs.fivem.net/docs/scripting-manual/introduction/introduction-to-resources/
- https://docs.fivem.net/docs/server-manual/setting-up-a-server-vanilla/
- https://docs.fivem.net/docs/server-manual/setting-up-a-server-txadmin/
- https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/
- https://docs.fivem.net/docs/scripting-manual/runtimes/lua/
- https://docs.fivem.net/docs/scripting-manual/runtimes/javascript/
- https://docs.fivem.net/docs/scripting-manual/runtimes/csharp/
- https://docs.fivem.net/docs/scripting-manual/working-with-events/listening-for-events/
- https://docs.fivem.net/docs/scripting-manual/working-with-events/triggering-events/
- https://docs.fivem.net/docs/scripting-manual/working-with-events/event-cancelation/
- https://docs.fivem.net/docs/scripting-reference/convars/
- https://docs.fivem.net/docs/server-manual/server-commands/
- https://docs.fivem.net/docs/scripting-reference/onesync/
- https://docs.fivem.net/docs/scripting-manual/networking/state-bags/
- https://docs.fivem.net/docs/scripting-manual/debugging/using-profiler/
- https://docs.fivem.net/docs/scripting-manual/introduction/best-practices/

---

## Natives Index (Client / Server, by Category)

### 13.0 Processing Ledger
| Category | Total | Done | Remaining | Last Updated |
|----------|------:|-----:|----------:|--------------|
| Overall | 6442 | 508 | 5934 | 2025-09-12T04:23 |
| Player | 248 | 248 | 0 | 2025-09-11T06:38 |
| Recording | 17 | 17 | 0 | 2025-09-11T06:52 |
| Replay | 6 | 6 | 0 | 2025-09-11T07:37 |
| ACL | 10 | 10 | 0 | 2025-09-11T08:12 |
| CFX | 50 | 50 | 0 | 2025-09-11T09:55 |
| Vehicle | 751 | 177 | 574 | 2025-09-12T04:23 |

### Taxonomy & Scope Notes
- **Client-only** natives run in game clients and cannot be executed on the server.
- **Server-only** natives run in FXServer and manage resources or network state.
- **Shared** natives work in both realms.
- OneSync dictates entity ownership; some natives require the entity owner to call them for replication.

#### References
- https://docs.fivem.net/natives/

### Client Natives by Category

#### Player

##### ArePlayerFlashingStarsAboutToDrop (0xAFAF86043E5874E9 / 0xE13A71C7)
- **Scope**: Client
- **Signature**: `BOOL ARE_PLAYER_FLASHING_STARS_ABOUT_TO_DROP(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` status.
- **OneSync / Networking**: Local check; servers should not rely on it.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: stars_drop
        -- Use: Prints if wanted stars are about to drop
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('stars_drop', function()
        print(ArePlayerFlashingStarsAboutToDrop(PlayerId()))
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: stars_drop */
    RegisterCommand('stars_drop', () => {
      console.log(ArePlayerFlashingStarsAboutToDrop(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - No official description.
- **Reference**: https://docs.fivem.net/natives/?n=ARE_PLAYER_FLASHING_STARS_ABOUT_TO_DROP
  - TODO(next-run): verify semantics.

##### ArePlayerStarsGreyedOut (0x0A6EB355EE14A2DB / 0x5E72AB72)
- **Scope**: Client
- **Signature**: `BOOL ARE_PLAYER_STARS_GREYED_OUT(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` status.
- **OneSync / Networking**: Local query only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: stars_grey
        -- Use: Prints if wanted stars are greyed out
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('stars_grey', function()
        print(ArePlayerStarsGreyedOut(PlayerId()))
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: stars_grey */
    RegisterCommand('stars_grey', () => {
      console.log(ArePlayerStarsGreyedOut(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Function behavior undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=ARE_PLAYER_STARS_GREYED_OUT
  - TODO(next-run): verify semantics.

##### AssistedMovementCloseRoute (0xAEBF081FFC0A0E5E / 0xF23277F3)
- **Scope**: Client
- **Signature**: `void ASSISTED_MOVEMENT_CLOSE_ROUTE()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Local; affects only current script.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: assist_close
        -- Use: Calls AssistedMovementCloseRoute
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('assist_close', function()
        AssistedMovementCloseRoute()
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: assist_close */
    RegisterCommand('assist_close', () => {
      AssistedMovementCloseRoute();
    });
    ```
- **Caveats / Limitations**:
  - No official explanation.
- **Reference**: https://docs.fivem.net/natives/?n=ASSISTED_MOVEMENT_CLOSE_ROUTE
  - TODO(next-run): verify semantics.

##### AssistedMovementFlushRoute (0x8621390F0CDCFE1F / 0xD04568B9)
- **Scope**: Client
- **Signature**: `void ASSISTED_MOVEMENT_FLUSH_ROUTE()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Local to calling client.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: assist_flush
        -- Use: Calls AssistedMovementFlushRoute
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('assist_flush', function()
        AssistedMovementFlushRoute()
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: assist_flush */
    RegisterCommand('assist_flush', () => {
      AssistedMovementFlushRoute();
    });
    ```
- **Caveats / Limitations**:
  - No documented behavior.
- **Reference**: https://docs.fivem.net/natives/?n=ASSISTED_MOVEMENT_FLUSH_ROUTE
  - TODO(next-run): verify semantics.

##### CanPedHearPlayer (0xF297383AA91DCA29 / 0x1C70B2EB)
- **Scope**: Client
- **Signature**: `BOOL CAN_PED_HEAR_PLAYER(Player player, Ped ped)`
- **Purpose**: Checks if a ped can hear the specified player.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `ped` (`Ped`): Ped to test.
  - **Returns**: `bool` heard state.
- **OneSync / Networking**: Requires the ped to exist on the client.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: can_hear
        -- Use: Tests if the player's ped can hear them
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('can_hear', function()
        local ped = PlayerPedId()
        print(CanPedHearPlayer(PlayerId(), ped))
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: can_hear */
    RegisterCommand('can_hear', () => {
      const ped = PlayerPedId();
      console.log(CanPedHearPlayer(PlayerId(), ped));
    });
    ```
- **Caveats / Limitations**:
  - Documentation sparse.
- **Reference**: https://docs.fivem.net/natives/?n=CAN_PED_HEAR_PLAYER

##### CanPlayerStartMission (0xDE7465A27D403C06 / 0x39E3CB3F)
- **Scope**: Client
- **Signature**: `BOOL CAN_PLAYER_START_MISSION(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `bool` result.
- **OneSync / Networking**: Local check; mission logic should be validated server-side.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: can_mission
        -- Use: Prints if the player can start a mission
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('can_mission', function()
        print(CanPlayerStartMission(PlayerId()))
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: can_mission */
    RegisterCommand('can_mission', () => {
      console.log(CanPlayerStartMission(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Function semantics unclear.
- **Reference**: https://docs.fivem.net/natives/?n=CAN_PLAYER_START_MISSION
  - TODO(next-run): verify behavior.

##### ChangePlayerPed (0x048189FAC643DEEE / 0xBE515485)
- **Scope**: Client
- **Signature**: `void CHANGE_PLAYER_PED(Player player, Ped ped, BOOL b2, BOOL resetDamage)`
- **Purpose**: Changes the player to a specified ped.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `ped` (`Ped`): Ped to assign.
  - `b2` (`bool`): Unknown.
  - `resetDamage` (`bool`): Reset health damage.
  - **Returns**: None.
- **OneSync / Networking**: Changing ped requires entity ownership to replicate.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: change_ped
        -- Use: Reassigns current ped to the player
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('change_ped', function()
        local ped = PlayerPedId()
        ChangePlayerPed(PlayerId(), ped, false, false)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: change_ped */
    RegisterCommand('change_ped', () => {
      const ped = PlayerPedId();
      ChangePlayerPed(PlayerId(), ped, false, false);
    });
    ```
- **Caveats / Limitations**:
  - Parameters `b2` and `resetDamage` are not documented.
- **Reference**: https://docs.fivem.net/natives/?n=CHANGE_PLAYER_PED
  - TODO(next-run): verify parameter meanings.

##### ClearPlayerHasDamagedAtLeastOneNonAnimalPed (0x4AACB96203D11A31 / 0x7E3BFBC5)
- **Scope**: Client
- **Signature**: `void CLEAR_PLAYER_HAS_DAMAGED_AT_LEAST_ONE_NON_ANIMAL_PED(Player player)`
- **Purpose**: Resets the internal flag tracking non-animal ped damage.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: None.
- **OneSync / Networking**: Local flag only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: clear_nonanimal
        -- Use: Clears damage flag on non-animal peds
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_nonanimal', function()
        ClearPlayerHasDamagedAtLeastOneNonAnimalPed(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_nonanimal */
    RegisterCommand('clear_nonanimal', () => {
      ClearPlayerHasDamagedAtLeastOneNonAnimalPed(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Purpose inferred from name.
- **Reference**: https://docs.fivem.net/natives/?n=CLEAR_PLAYER_HAS_DAMAGED_AT_LEAST_ONE_NON_ANIMAL_PED
  - TODO(next-run): confirm exact behavior.

##### ClearPlayerHasDamagedAtLeastOnePed (0xF0B67A4DE6AB5F98 / 0x1D31CBBD)
- **Scope**: Client
- **Signature**: `void CLEAR_PLAYER_HAS_DAMAGED_AT_LEAST_ONE_PED(Player player)`
- **Purpose**: Resets the flag tracking if the player damaged any ped.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: None.
- **OneSync / Networking**: Local flag only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: clear_damage
        -- Use: Clears damage flag on any ped
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_damage', function()
        ClearPlayerHasDamagedAtLeastOnePed(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_damage */
    RegisterCommand('clear_damage', () => {
      ClearPlayerHasDamagedAtLeastOnePed(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Behaviour inferred; official docs unclear.
- **Reference**: https://docs.fivem.net/natives/?n=CLEAR_PLAYER_HAS_DAMAGED_AT_LEAST_ONE_PED
  - TODO(next-run): verify semantics.

##### ClearPlayerParachuteModelOverride (0x8753997EB5F6EE3F / 0x6FF034BB)
- **Scope**: Client
- **Signature**: `void CLEAR_PLAYER_PARACHUTE_MODEL_OVERRIDE(Player player)`
- **Purpose**: Removes any set parachute model override.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: None.
- **OneSync / Networking**: Visual change local to client.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: clear_para_model
        -- Use: Resets parachute model
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_para_model', function()
        ClearPlayerParachuteModelOverride(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_para_model */
    RegisterCommand('clear_para_model', () => {
      ClearPlayerParachuteModelOverride(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Only resets model for local client.
- **Reference**: https://docs.fivem.net/natives/?n=CLEAR_PLAYER_PARACHUTE_MODEL_OVERRIDE

##### ClearPlayerParachutePackModelOverride (0x10C54E4389C12B42 / 0xBB62AAC5)
- **Scope**: Client
- **Signature**: `void CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(Player player)`
- **Purpose**: Clears any custom parachute pack model.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: None.
- **OneSync / Networking**: Local-only visual change.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: clear_para_pack
        -- Use: Resets parachute pack model
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_para_pack', function()
        ClearPlayerParachutePackModelOverride(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_para_pack */
    RegisterCommand('clear_para_pack', () => {
      ClearPlayerParachutePackModelOverride(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - No network replication.
- **Reference**: https://docs.fivem.net/natives/?n=CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE

##### ClearPlayerParachuteVariationOverride (0x0F4CC924CF8C7B21 / 0xFD60F5AB)
- **Scope**: Client
- **Signature**: `void CLEAR_PLAYER_PARACHUTE_VARIATION_OVERRIDE(Player player)`
- **Purpose**: Removes parachute visual variation override.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: None.
- **OneSync / Networking**: Local visual change.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: clear_para_var
        -- Use: Clears parachute variation override
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_para_var', function()
        ClearPlayerParachuteVariationOverride(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_para_var */
    RegisterCommand('clear_para_var', () => {
      ClearPlayerParachuteVariationOverride(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Visual only.
- **Reference**: https://docs.fivem.net/natives/?n=CLEAR_PLAYER_PARACHUTE_VARIATION_OVERRIDE

##### ClearPlayerReserveParachuteModelOverride (0x290D248E25815AE8)
- **Scope**: Client
- **Signature**: `void _CLEAR_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(Player player)`
- **Purpose**: Clears reserve parachute model override.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: None.
- **OneSync / Networking**: Local effect only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: clear_para_reserve
        -- Use: Clears reserve parachute model
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_para_reserve', function()
        ClearPlayerReserveParachuteModelOverride(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_para_reserve */
    RegisterCommand('clear_para_reserve', () => {
      ClearPlayerReserveParachuteModelOverride(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Underscore denotes native naming; availability may vary by build.
- **Reference**: https://docs.fivem.net/natives/?n=_CLEAR_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE

##### ClearPlayerWantedLevel (0xB302540597885499 / 0x54EA5BCC)
- **Scope**: Client
- **Signature**: `void CLEAR_PLAYER_WANTED_LEVEL(Player player)`
- **Purpose**: Resets the player's wanted level to zero.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
- **OneSync / Networking**: Only affects local wanted status; server should enforce desired state.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: clear_wanted
        -- Use: Clears player's wanted level
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_wanted', function()
        ClearPlayerWantedLevel(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_wanted */
    RegisterCommand('clear_wanted', () => {
      ClearPlayerWantedLevel(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Check current wanted level before clearing for efficiency.
- **Reference**: https://docs.fivem.net/natives/?n=CLEAR_PLAYER_WANTED_LEVEL

##### DisablePlayerFiring (0x5E6CC07646BBEAB8 / 0x30CB28CB)
- **Scope**: Client
- **Signature**: `void DISABLE_PLAYER_FIRING(Player player, BOOL toggle)`
- **Purpose**: Temporarily prevents the player from performing combat actions.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `toggle` (`bool`): Unused; call every frame to disable firing.
  - **Returns**: None.
- **OneSync / Networking**: Local only; must be called every frame to maintain effect.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: nofire
        -- Use: Disables firing for five seconds
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nofire', function()
        CreateThread(function()
            local start = GetGameTimer()
            while GetGameTimer() - start < 5000 do
                DisablePlayerFiring(PlayerId(), true)
                Wait(0)
            end
        end)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: nofire */
    RegisterCommand('nofire', () => {
      const start = GetGameTimer();
      const tick = setTick(() => {
        DisablePlayerFiring(PlayerId(), true);
        if (GetGameTimer() - start > 5000) clearTick(tick);
      });
    });
    ```
- **Caveats / Limitations**:
  - Effect lasts only one frame unless repeatedly invoked.
- **Reference**: https://docs.fivem.net/natives/?n=DISABLE_PLAYER_FIRING

##### DisablePlayerVehicleRewards (0xC142BE3BB9CE125F / 0x8C6E611D)
- **Scope**: Client
- **Signature**: `void DISABLE_PLAYER_VEHICLE_REWARDS(Player player)`
- **Purpose**: Blocks vehicle entry rewards for the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: None.
- **OneSync / Networking**: Call every frame for persistent effect; local only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: no_rewards
        -- Use: Disables vehicle rewards for five seconds
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('no_rewards', function()
        CreateThread(function()
            local start = GetGameTimer()
            while GetGameTimer() - start < 5000 do
                DisablePlayerVehicleRewards(PlayerId())
                Wait(0)
            end
        end)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: no_rewards */
    RegisterCommand('no_rewards', () => {
      const start = GetGameTimer();
      const tick = setTick(() => {
        DisablePlayerVehicleRewards(PlayerId());
        if (GetGameTimer() - start > 5000) clearTick(tick);
      });
    });
    ```
- **Caveats / Limitations**:
  - Only affects current frame when called.
- **Reference**: https://docs.fivem.net/natives/?n=DISABLE_PLAYER_VEHICLE_REWARDS

##### DisplaySystemSigninUi (0x94DD7888C10A979E / 0x4264CED2)
- **Scope**: Client
- **Signature**: `void DISPLAY_SYSTEM_SIGNIN_UI(BOOL unk)`
- **Purpose**: Shows the system sign-in interface.
- **Parameters / Returns**:
  - `unk` (`bool`): Purpose unknown.
  - **Returns**: None.
- **OneSync / Networking**: UI is local; has no network effect.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: signin_ui
        -- Use: Displays the system sign-in dialog
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('signin_ui', function()
        DisplaySystemSigninUi(true)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: signin_ui */
    RegisterCommand('signin_ui', () => {
      DisplaySystemSigninUi(true);
    });
    ```
- **Caveats / Limitations**:
  - Boolean parameter meaning not documented.
- **Reference**: https://docs.fivem.net/natives/?n=DISPLAY_SYSTEM_SIGNIN_UI

##### EnableSpecialAbility (0x181EC197DAEFE121 / 0xC86C1B4E)
- **Scope**: Client
- **Signature**: `void ENABLE_SPECIAL_ABILITY(Player player, BOOL toggle)`
- **Purpose**: Toggles the player's special ability availability.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `toggle` (`bool`): Enable (`true`) or disable (`false`).
  - **Returns**: None.
- **OneSync / Networking**: Only affects the local player's ability state.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: special_on
        -- Use: Enables special ability
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_on', function()
        EnableSpecialAbility(PlayerId(), true)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: special_on */
    RegisterCommand('special_on', () => {
      EnableSpecialAbility(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Additional parameters may exist in future builds.
- **Reference**: https://docs.fivem.net/natives/?n=ENABLE_SPECIAL_ABILITY

##### ExtendWorldBoundaryForPlayer (0x5006D96C995A5827 / 0x64DDB07D)
- **Scope**: Client
- **Signature**: `void EXTEND_WORLD_BOUNDARY_FOR_PLAYER(float x, float y, float z)`
- **Purpose**: Extends the playable world limits to specified coordinates.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Boundary coordinates.
  - **Returns**: None.
- **OneSync / Networking**: Local change; ensure server validates world boundary.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: world_extend
        -- Use: Extends world boundary to large coordinates
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('world_extend', function()
        ExtendWorldBoundaryForPlayer(10000.0, 10000.0, 1000.0)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: world_extend */
    RegisterCommand('world_extend', () => {
      ExtendWorldBoundaryForPlayer(10000.0, 10000.0, 1000.0);
    });
    ```
- **Caveats / Limitations**:
  - Used rarely; misuse may cause unexpected game behavior.
- **Reference**: https://docs.fivem.net/natives/?n=EXTEND_WORLD_BOUNDARY_FOR_PLAYER

##### ForceCleanup (0xBC8983F38F78ED51 / 0xFDAAEA2B)
- **Scope**: Client
- **Signature**: `void FORCE_CLEANUP(int cleanupFlags)`
- **Purpose**: Forces script cleanup using flag bits.
- **Parameters / Returns**:
  - `cleanupFlags` (`int`): Bitmask indicating what to clean.
  - **Returns**: None.
- **OneSync / Networking**: Local; misuse can terminate scripts unexpectedly.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: force_clean
        -- Use: Triggers FORCE_CLEANUP with flag 1
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('force_clean', function()
        ForceCleanup(1)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: force_clean */
    RegisterCommand('force_clean', () => {
      ForceCleanup(1);
    });
    ```
- **Caveats / Limitations**:
  - Flags must be chosen carefully to avoid crashing scripts.
- **Reference**: https://docs.fivem.net/natives/?n=FORCE_CLEANUP

##### ForceCleanupForAllThreadsWithThisName (0x4C68DDDDF0097317 / 0x04256C73)
- **Scope**: Client
- **Signature**: `void FORCE_CLEANUP_FOR_ALL_THREADS_WITH_THIS_NAME(char* name, int cleanupFlags)`
- **Purpose**: Applies cleanup flags to all scripts with a given name.
- **Parameters / Returns**:
  - `name` (`string`): Thread name.
  - `cleanupFlags` (`int`): Cleanup bitmask.
  - **Returns**: None.
- **OneSync / Networking**: Local to client.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: force_clean_name
        -- Use: Forces cleanup for threads named 'example'
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('force_clean_name', function()
        ForceCleanupForAllThreadsWithThisName('example', 1)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: force_clean_name */
    RegisterCommand('force_clean_name', () => {
      ForceCleanupForAllThreadsWithThisName('example', 1);
    });
    ```
- **Caveats / Limitations**:
  - Ensure thread name matches exactly.
- **Reference**: https://docs.fivem.net/natives/?n=FORCE_CLEANUP_FOR_ALL_THREADS_WITH_THIS_NAME

##### ForceCleanupForThreadWithThisId (0xF745B37630DF176B / 0x882D3EB3)
- **Scope**: Client
- **Signature**: `void FORCE_CLEANUP_FOR_THREAD_WITH_THIS_ID(int id, int cleanupFlags)`
- **Purpose**: Forces cleanup for a specific script thread.
- **Parameters / Returns**:
  - `id` (`int`): Thread ID.
  - `cleanupFlags` (`int`): Cleanup bitmask.
  - **Returns**: None.
- **OneSync / Networking**: Local effect only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: force_clean_id
        -- Use: Forces cleanup for a thread ID
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('force_clean_id', function(_, args)
        local id = tonumber(args[1])
        if id then ForceCleanupForThreadWithThisId(id, 1) end
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: force_clean_id */
    RegisterCommand('force_clean_id', (_, args) => {
      const id = parseInt(args[0], 10);
      if (!isNaN(id)) ForceCleanupForThreadWithThisId(id, 1);
    });
    ```
- **Caveats / Limitations**:
  - Use carefully to avoid terminating critical threads.
- **Reference**: https://docs.fivem.net/natives/?n=FORCE_CLEANUP_FOR_THREAD_WITH_THIS_ID

##### GetAchievementProgress (0x1C186837D0619335)
- **Scope**: Client
- **Signature**: `int _GET_ACHIEVEMENT_PROGRESS(int achievement)`
- **Purpose**: Retrieves progress toward a given achievement.
- **Parameters / Returns**:
  - `achievement` (`int`): Achievement ID.
  - **Returns**: `int` progress value.
- **OneSync / Networking**: Local; relies on platform APIs.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: ach_prog
        -- Use: Prints progress for an achievement
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('ach_prog', function(_, args)
        local id = tonumber(args[1]) or 0
        print(GetAchievementProgress(id))
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: ach_prog */
    RegisterCommand('ach_prog', (_, args) => {
      const id = parseInt(args[0], 10) || 0;
      console.log(GetAchievementProgress(id));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 on retail versions.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_ACHIEVEMENT_PROGRESS

##### GetAreCameraControlsDisabled (0x7C814D2FB49F40C0 / 0x4C456AF2)
- **Scope**: Client
- **Signature**: `BOOL GET_ARE_CAMERA_CONTROLS_DISABLED()`
- **Purpose**: Checks if the main player's camera controls are disabled.
- **Parameters / Returns**:
  - **Returns**: `bool` indicating camera control state.
- **OneSync / Networking**: Client-side only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: cam_disabled
        -- Use: Reports if camera controls are disabled
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('cam_disabled', function()
        print(GetAreCameraControlsDisabled())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: cam_disabled */
    RegisterCommand('cam_disabled', () => {
      console.log(GetAreCameraControlsDisabled());
    });
    ```
- **Caveats / Limitations**:
  - Returns true if no main player info exists.
- **Reference**: https://docs.fivem.net/natives/?n=GET_ARE_CAMERA_CONTROLS_DISABLED

##### GetCauseOfMostRecentForceCleanup (0x9A41CF4674A12272 / 0x39AA9FC8)

##### GetEntityPlayerIsFreeAimingAt (0x2975C866E6713290 / 0x8866D9D0)
- **Scope**: Client
- **Signature**: `BOOL GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(Player player, Entity* entity)`
- **Purpose**: Checks if the player is aiming freely at an entity and returns that entity.
- **Parameters / Returns**:
  - `player` (Player): Player index.
  - `entity` (Entity*): Output handle for targeted entity.
  - `**Returns**` (bool): success flag
- **OneSync / Networking**: Local query; server should validate aim targets when needed.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: aim_ent
    -- Use: Prints entity ID the player is aiming at
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('aim_ent', function()
    local ent=0
    if GetEntityPlayerIsFreeAimingAt(PlayerId(), ent) then
        print(('Entity: %s'):format(ent))
    else
        print('No entity in sight')
    end
end)

    ```
  - JavaScript:
    ```javascript

/* Command: aim_ent */
RegisterCommand('aim_ent', () => {
  const ent = Citizen.pointerValueInt();
  if (GetEntityPlayerIsFreeAimingAt(PlayerId(), ent)) {
    console.log(`Entity: ${Citizen.pointerGetValue(ent)}`);
  } else {
    console.log('No entity in sight');
  }
});

    ```
- **Caveats / Limitations**:
  - Requires a valid weapon and aim mode.
- **Reference**: https://docs.fivem.net/natives/?n=GetEntityPlayerIsFreeAimingAt


##### GetIsPlayerDrivingOnHighway (0x5FC472C501CCADB3 / 0x46E7E31D)
- **Scope**: Client
- **Signature**: `BOOL GET_IS_PLAYER_DRIVING_ON_HIGHWAY(Player playerId)`
- **Purpose**: Determines if the player is currently driving on a highway.
- **Parameters / Returns**:
  - `playerId` (Player): Local player index.
  - `**Returns**` (bool): whether on highway
- **OneSync / Networking**: Local check; server cannot rely on this for enforcement.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: on_highway
    -- Use: Reports if player drives on a highway
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('on_highway', function()
    print(GetIsPlayerDrivingOnHighway(PlayerId()))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: on_highway */
RegisterCommand('on_highway', () => {
  console.log(GetIsPlayerDrivingOnHighway(PlayerId()));
});

    ```
- **Caveats / Limitations**:
  - Detection relies on map data and may be imperfect.
- **Reference**: https://docs.fivem.net/natives/?n=GetIsPlayerDrivingOnHighway


##### GetMaxWantedLevel (0x462E0DB9B137DC5F / 0x457F1E44)
- **Scope**: Client
- **Signature**: `int GET_MAX_WANTED_LEVEL()`
- **Purpose**: Returns the global maximum wanted level allowed.
- **Parameters / Returns**:
  - `**Returns**` (int): max level (0–5)
- **OneSync / Networking**: Local; server sets rules separately.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: max_wanted
    -- Use: Prints game maximum wanted level
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('max_wanted', function()
    print(('Max wanted: %d'):format(GetMaxWantedLevel()))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: max_wanted */
RegisterCommand('max_wanted', () => {
  console.log(`Max wanted: ${GetMaxWantedLevel()}`);
});

    ```
- **Caveats / Limitations**:
  - Does not alter current player state.
- **Reference**: https://docs.fivem.net/natives/?n=GetMaxWantedLevel


##### GetNumberOfPlayers (0x407C7F91DDB46C16 / 0x4C1B8867)
- **Scope**: Shared
- **Signature**: `int GET_NUMBER_OF_PLAYERS()`
- **Purpose**: Provides the count of players in the current session.
- **Parameters / Returns**:
  - `**Returns**` (int): player count
- **OneSync / Networking**: Server authoritative for connected clients.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: count_players
    -- Use: Prints player count
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('count_players', function()
    print(('Players: %d'):format(GetNumberOfPlayers()))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: count_players */
RegisterCommand('count_players', () => {
  console.log(`Players: ${GetNumberOfPlayers()}`);
});

    ```
- **Caveats / Limitations**:
  - On non-networked sessions, always returns 1.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumberOfPlayers


##### GetNumberOfPlayersInTeam (0x1FC200409F10E6F1)
- **Scope**: Client
- **Signature**: `int _GET_NUMBER_OF_PLAYERS_IN_TEAM(int team)`
- **Purpose**: Counts players assigned to a specific team.
- **Parameters / Returns**:
  - `team` (int): Team index.
  - `**Returns**` (int): number of players
- **OneSync / Networking**: Team tracking depends on game mode; not synced by default.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: team_count
    -- Use: Prints number of players in team 0
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('team_count', function()
    print(GetNumberOfPlayersInTeam(0))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: team_count */
RegisterCommand('team_count', () => {
  console.log(GetNumberOfPlayersInTeam(0));
});

    ```
- **Caveats / Limitations**:
  - Team assignments require custom scripts.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumberOfPlayersInTeam


##### GetPlayerCurrentStealthNoise (0x2F395D61F3A1F877 / 0xC3B02362)
- **Scope**: Client
- **Signature**: `float GET_PLAYER_CURRENT_STEALTH_NOISE(Player player)`
- **Purpose**: Retrieves the player's current noise level for stealth mechanics.
- **Parameters / Returns**:
  - `player` (Player): Player index.
  - `**Returns**` (float): noise value
- **OneSync / Networking**: Local use; does not replicate.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: stealth_noise
    -- Use: Prints current stealth noise
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('stealth_noise', function()
    print(GetPlayerCurrentStealthNoise(PlayerId()))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: stealth_noise */
RegisterCommand('stealth_noise', () => {
  console.log(GetPlayerCurrentStealthNoise(PlayerId()));
});

    ```
- **Caveats / Limitations**:
  - Values are undefined when not sneaking.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerCurrentStealthNoise


##### GetPlayerFakeWantedLevel (0x56105E599CAB0EFA / 0x0098D244)
- **Scope**: Client
- **Signature**: `int GET_PLAYER_FAKE_WANTED_LEVEL(Player player)`
- **Purpose**: Returns a scripted wanted level unrelated to actual police response.
- **Parameters / Returns**:
  - `player` (Player): Player index.
  - `**Returns**` (int): fake wanted level
- **OneSync / Networking**: Cosmetic; does not trigger network wanted status.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: fake_wanted
    -- Use: Prints player's fake wanted level
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('fake_wanted', function()
    print(GetPlayerFakeWantedLevel(PlayerId()))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: fake_wanted */
RegisterCommand('fake_wanted', () => {
  console.log(GetPlayerFakeWantedLevel(PlayerId()));
});

    ```
- **Caveats / Limitations**:
  - Only used by specific missions.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerFakeWantedLevel

- **Scope**: Client
- **Signature**: `int GET_CAUSE_OF_MOST_RECENT_FORCE_CLEANUP()`
- **Purpose**: Retrieves the cause code for the latest `ForceCleanup`.
- **Parameters / Returns**:
  - **Returns**: `int` cleanup cause.
- **OneSync / Networking**: Local query.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: last_cleanup
        -- Use: Prints cause of the most recent ForceCleanup
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('last_cleanup', function()
        print(GetCauseOfMostRecentForceCleanup())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: last_cleanup */
    RegisterCommand('last_cleanup', () => {
      console.log(GetCauseOfMostRecentForceCleanup());
    });
    ```
- **Caveats / Limitations**:
  - Specific cause codes are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=GET_CAUSE_OF_MOST_RECENT_FORCE_CLEANUP
  - TODO(next-run): catalog possible return values.
##### GetPlayerFromServerId (hash unknown)
- **Scope**: Shared
- **Signature**: `Player GetPlayerFromServerId(int serverId)`
- **Purpose**: Convert a server ID to a player index on the client.
- **Parameters / Returns**:
  - `serverId` (`int`): Server ID assigned by the server.
  - **Returns**: `Player` index or `-1` if not found.
- **OneSync / Networking**: Works for any connected player; no entity ownership.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: findById
        -- Use: Prints player's name via server ID
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('getname', function(src, args)
        local sid = tonumber(args[1])
        if not sid then return end
        local pid = GetPlayerFromServerId(sid) -- map server ID to client index
        if pid ~= -1 then
            print(('Player name: %s'):format(GetPlayerName(pid)))
        end
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('getname', (_, args) => {
      const sid = parseInt(args[0], 10);
      if (isNaN(sid)) return;
      const pid = GetPlayerFromServerId(sid); // map server ID to client index
      if (pid !== -1) {
        console.log(`Player name: ${GetPlayerName(pid)}`);
      }
    });
    ```

- **Caveats / Limitations**:
  - Returns -1 if the ID is not active.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerFromServerId
  - TODO(next-run): verify signature and hash against official docs.

##### GetPlayerGroup (0x0D127585F77030AF)
- **Scope**: Shared
- **Signature**: `int GetPlayerGroup(Player player)`
- **Purpose**: Get the group ID the player belongs to.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `int` group identifier.
- **OneSync / Networking**: Group membership is local; no replication.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: showGroup
        -- Use: Logs player's group ID
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('mygroup', function()
        local id = PlayerId()
        local grp = GetPlayerGroup(id) -- query group ID
        print(('Group for %s: %d'):format(GetPlayerName(id), grp))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('mygroup', () => {
      const id = PlayerId();
      const grp = GetPlayerGroup(id); // query group ID
      console.log(`Group for ${GetPlayerName(id)}: ${grp}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 if not in a group.
- **Reference**: https://docs.fivem.net/natives/?_0x0D127585F77030AF

##### GetPlayerHasReserveParachute (0x5DDFE2FF727F3CA3)
- **Scope**: Shared
- **Signature**: `bool GetPlayerHasReserveParachute(Player player)`
- **Purpose**: Check if the player carries a reserve parachute.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `bool` reserve state.
- **OneSync / Networking**: State is synced; ownership not required.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: hasReserve
        -- Use: Prints whether player has a reserve parachute
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('checkreserve', function()
        local id = PlayerId()
        local has = GetPlayerHasReserveParachute(id)
        print(('Reserve chute: %s'):format(has and 'yes' or 'no'))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('checkreserve', () => {
      const id = PlayerId();
      const has = GetPlayerHasReserveParachute(id);
      console.log(`Reserve chute: ${has ? 'yes' : 'no'}`);
    });
    ```

- **Caveats / Limitations**:
  - Only reflects current equipment state.
- **Reference**: https://docs.fivem.net/natives/?_0x5DDFE2FF727F3CA3

##### GetPlayerHealthRechargeLimit (0x8BC515BAE4AAF8FF)
- **Scope**: Shared
- **Signature**: `float GetPlayerHealthRechargeLimit(Player player)`
- **Purpose**: Retrieve the auto-recharge limit of the player's health.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `float` health threshold.
- **OneSync / Networking**: Value is local; server may override.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: healthLimit
        -- Use: Displays health recharge limit
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('healthlim', function()
        local id = PlayerId()
        local limit = GetPlayerHealthRechargeLimit(id)
        print(('Recharge limit: %.1f'):format(limit))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('healthlim', () => {
      const id = PlayerId();
      const limit = GetPlayerHealthRechargeLimit(id);
      console.log(`Recharge limit: ${limit}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0.0 if health regen is disabled.
- **Reference**: https://docs.fivem.net/natives/?_0x8BC515BAE4AAF8FF

##### GetPlayerIndex (0xA5EDC40EF369B48D)
- **Scope**: Shared
- **Signature**: `Player GetPlayerIndex()`
- **Purpose**: Get the local player's index.
- **Parameters / Returns**:
  - **Returns**: `Player` index of the caller.
- **OneSync / Networking**: Only valid on the local client.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: myIndex
        -- Use: Prints local player index
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('myindex', function()
        print(('Index: %d'):format(GetPlayerIndex()))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('myindex', () => {
      console.log(`Index: ${GetPlayerIndex()}`);
    });
    ```

- **Caveats / Limitations**:
  - Equivalent to `PlayerId()`; not meaningful server-side.
- **Reference**: https://docs.fivem.net/natives/?_0xA5EDC40EF369B48D

##### GetPlayerInvincible (0xB721981B2B939E07)
- **Scope**: Shared
- **Signature**: `bool GetPlayerInvincible(Player player)`
- **Purpose**: Determine if invincibility is enabled for the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `bool` indicating invincibility.
- **OneSync / Networking**: Server should validate critical logic.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: checkGod
        -- Use: Logs whether player is invincible
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('amigod', function()
        local id = PlayerId()
        print(('Invincible: %s'):format(GetPlayerInvincible(id) and 'yes' or 'no'))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('amigod', () => {
      const id = PlayerId();
      console.log(`Invincible: ${GetPlayerInvincible(id) ? 'yes' : 'no'}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns true only if set via `SetPlayerInvincible`.
- **Reference**: https://docs.fivem.net/natives/?_0xB721981B2B939E07

##### GetPlayerMaxArmour (0x92659B4CE1863CB3)
- **Scope**: Shared
- **Signature**: `int GetPlayerMaxArmour(Player player)`
- **Purpose**: Retrieve the maximum armour value for a player.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `int` armour capacity.
- **OneSync / Networking**: Local stat; may be capped by gameplay.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: maxArmour
        -- Use: Prints player's armour capacity
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('maxarmour', function()
        local id = PlayerId()
        print(('Max armour: %d'):format(GetPlayerMaxArmour(id)))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('maxarmour', () => {
      const id = PlayerId();
      console.log(`Max armour: ${GetPlayerMaxArmour(id)}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 if the player index is invalid.
- **Reference**: https://docs.fivem.net/natives/?_0x92659B4CE1863CB3

##### GetPlayerName (0x6D0DE6A7B5DA71F8)
- **Scope**: Shared
- **Signature**: `char* GetPlayerName(Player player)`
- **Purpose**: Get the display name of a player.
- **Parameters / Returns**:
  - `player` (`Player`): slot or server ID of the player.
  - **Returns**: `string` player name.
- **OneSync / Networking**: Names are synced by the game; no additional replication required.
- **Examples**:
  - Lua:

    ```lua
    -- Get and print the name of the current player
    local id = PlayerId()
    print(('You are %s'):format(GetPlayerName(id)))
    ```

  - JavaScript:

    ```javascript
    // Print the local player's name
    const id = PlayerId();
    console.log(`You are ${GetPlayerName(id)}`);
    ```

- **Caveats / Limitations**:
  - Returns an empty string if the player does not exist.
- **Reference**: https://docs.fivem.net/natives/?_0x6D0DE6A7B5DA71F8
  - TODO(next-run): verify signature and hash against official docs.

##### GetPlayerParachuteModelOverride (0xC219887CA3E65C41)
- **Scope**: Shared
- **Signature**: `Hash GetPlayerParachuteModelOverride(Player player)`
- **Purpose**: Get the model hash set to override the player's parachute.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `Hash` model identifier.
- **OneSync / Networking**: Model override is synced; ensure model is streamed.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: chuteModel
        -- Use: Prints parachute model override hash
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('chutemodel', function()
        local id = PlayerId()
        print(('Model override: %s'):format(GetPlayerParachuteModelOverride(id)))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('chutemodel', () => {
      const id = PlayerId();
      console.log(`Model override: ${GetPlayerParachuteModelOverride(id)}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 if no override is set.
- **Reference**: https://docs.fivem.net/natives/?_0xC219887CA3E65C41

##### GetPlayerParachutePackTintIndex (0x6E9C742F340CE5A2)
- **Scope**: Shared
- **Signature**: `void GetPlayerParachutePackTintIndex(Player player, int* tintIndex)`
- **Purpose**: Retrieve the tint index for the player's parachute pack.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `tintIndex` (`int*`): Output tint index.
- **OneSync / Networking**: Tint is synced with OneSync.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: packTint
        -- Use: Prints parachute pack tint index
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('packtint', function()
        local id = PlayerId()
        local tint = 0
        GetPlayerParachutePackTintIndex(id, tint) -- fetch tint index
        print(('Pack tint: %d'):format(tint))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('packtint', () => {
      const id = PlayerId();
      const tintIndex = new Int32Array(1);
      GetPlayerParachutePackTintIndex(id, tintIndex);
      console.log(`Pack tint: ${tintIndex[0]}`);
    });
    ```

- **Caveats / Limitations**:
  - Requires array/reference to capture output.
- **Reference**: https://docs.fivem.net/natives/?_0x6E9C742F340CE5A2

##### GetPlayerParachuteSmokeTrailColor (0xEF56DBABD3CD4887)
- **Scope**: Shared
- **Signature**: `void GetPlayerParachuteSmokeTrailColor(Player player, int* r, int* g, int* b)`
- **Purpose**: Get the RGB color for the player's parachute smoke trail.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `r` (`int*`): Red component.
  - `g` (`int*`): Green component.
  - `b` (`int*`): Blue component.
- **OneSync / Networking**: Color is synced with other clients.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: smokeColor
        -- Use: Logs parachute smoke trail color
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('smokecolor', function()
        local id = PlayerId()
        local r, g, b = 0, 0, 0
        GetPlayerParachuteSmokeTrailColor(id, r, g, b)
        print(('Smoke color: %d %d %d'):format(r, g, b))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('smokecolor', () => {
      const id = PlayerId();
      const rgb = new Int32Array(3);
      GetPlayerParachuteSmokeTrailColor(id, rgb, rgb.subarray(1), rgb.subarray(2));
      console.log(`Smoke color: ${rgb[0]} ${rgb[1]} ${rgb[2]}`);
    });
    ```

- **Caveats / Limitations**:
  - Requires three mutable references/arrays.
- **Reference**: https://docs.fivem.net/natives/?_0xEF56DBABD3CD4887

##### GetPlayerParachuteTintIndex (hash unknown)
- **Scope**: Shared
- **Signature**: `void GetPlayerParachuteTintIndex(Player player, int* tintIndex)`
- **Purpose**: Retrieve the tint index applied to the player's parachute canopy.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `tintIndex` (`int*`): Output tint slot.
- **OneSync / Networking**: Tint is synced to other players when deployed.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: chuteTint
        -- Use: Prints parachute canopy tint index
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('chutetint', function()
        local id = PlayerId()
        local tint = 0
        GetPlayerParachuteTintIndex(id, tint)
        print(('Chute tint: %d'):format(tint))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('chutetint', () => {
      const id = PlayerId();
      const tint = new Int32Array(1);
      GetPlayerParachuteTintIndex(id, tint);
      console.log(`Chute tint: ${tint[0]}`);
    });
    ```

- **Caveats / Limitations**:
  - Requires a mutable reference/array for output.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerParachuteTintIndex

##### GetPlayerPed (0x43A66C31C68491C0)

##### GetPlayerPedScriptIndex (0x50FAC3A3E030A6E1 / 0x6AC64990)
- **Scope**: Client
- **Signature**: `Ped GET_PLAYER_PED_SCRIPT_INDEX(Player player)`
- **Purpose**: Retrieves the pedestrian handle using the script index of a player.
- **Parameters / Returns**:
  - `player` (Player): Player index.
  - `**Returns**` (Ped): ped handle
- **OneSync / Networking**: Requires entity ownership for remote players.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: ped_script
    -- Use: Prints ped handle via script index
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('ped_script', function()
    print(GetPlayerPedScriptIndex(PlayerId()))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: ped_script */
RegisterCommand('ped_script', () => {
  console.log(GetPlayerPedScriptIndex(PlayerId()));
});

    ```
- **Caveats / Limitations**:
  - Same result as `GetPlayerPed` for local player.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerPedScriptIndex


##### GetPlayerReserveParachuteModelOverride (0x37FAAA68DCA9D08D)
- **Scope**: Client
- **Signature**: `Hash _GET_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(Player player)`
- **Purpose**: Returns the override model hash for the player's reserve parachute.
- **Parameters / Returns**:
  - `player` (Player): Player index.
  - `**Returns**` (Hash): model identifier
- **OneSync / Networking**: Local visual change only.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: reserve_model
    -- Use: Prints reserve parachute model override
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('reserve_model', function()
    print(GetPlayerReserveParachuteModelOverride(PlayerId()))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: reserve_model */
RegisterCommand('reserve_model', () => {
  console.log(GetPlayerReserveParachuteModelOverride(PlayerId()));
});

    ```
- **Caveats / Limitations**:
  - Only returns a value if previously set.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerReserveParachuteModelOverride


##### GetPlayerReserveParachuteTintIndex (0xD5A016BC3C09CF40 / 0x77B8EF01)
- **Scope**: Client
- **Signature**: `void GET_PLAYER_RESERVE_PARACHUTE_TINT_INDEX(Player player, int* index)`
- **Purpose**: Obtains the tint index for the player's reserve parachute.
- **Parameters / Returns**:
  - `player` (Player): Player index.
  - `index` (int*): Output tint index.
- **OneSync / Networking**: Visual only; not networked.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: reserve_tint
    -- Use: Prints reserve parachute tint
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('reserve_tint', function()
    local tint = GetPlayerReserveParachuteTintIndex(PlayerId())
    print(('Tint: %d'):format(tint))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: reserve_tint */
RegisterCommand('reserve_tint', () => {
  const tint = GetPlayerReserveParachuteTintIndex(PlayerId());
  console.log(`Tint: ${tint}`);
});

    ```
- **Caveats / Limitations**:
  - Returns -1 if no tint set.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerReserveParachuteTintIndex


##### GetPlayerRgbColour (0xE902EF951DCE178F / 0x6EF43BBB)
- **Scope**: Shared
- **Signature**: `void GET_PLAYER_RGB_COLOUR(Player player, int* r, int* g, int* b)`
- **Purpose**: Retrieves the scoreboard color for a player.
- **Parameters / Returns**:
  - `player` (Player): Player index.
  - `r` (int*): Output red component.
  - `g` (int*): Output green component.
  - `b` (int*): Output blue component.
- **OneSync / Networking**: Color is synced from server to clients.
- **Examples**:
  - Lua:
    ```lua

--[[
    -- Type: Command
    -- Name: rgb
    -- Use: Prints player scoreboard color
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterCommand('rgb', function()
    local r,g,b = GetPlayerRgbColour(PlayerId())
    print(('Color: %d %d %d'):format(r,g,b))
end)

    ```
  - JavaScript:
    ```javascript

/* Command: rgb */
RegisterCommand('rgb', () => {
  const color = GetPlayerRgbColour(PlayerId());
  console.log(`Color: ${color[0]} ${color[1]} ${color[2]}`);
});

    ```
- **Caveats / Limitations**:
  - Only meaningful in network sessions with teams.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerRgbColour

- **Scope**: Shared
- **Signature**: `Ped GetPlayerPed(Player player)`
- **Purpose**: Obtain the ped handle controlled by a given player.
- **Parameters / Returns**:
  - `player` (`Player`): slot or server ID of the player.
  - **Returns**: `Ped` handle for that player.
- **OneSync / Networking**: Entity ownership is required for actions on the ped to replicate.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: listName
        -- Use: Prints the player's name and ped entity
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local id = PlayerId()                     -- local player's slot
    local ped = GetPlayerPed(id)               -- obtain ped handle
    print(('Player %s ped %s'):format(GetPlayerName(id), ped))
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    const id = PlayerId();                    // local player's slot
    const ped = GetPlayerPed(id);             // obtain ped handle
    console.log(`Player ${GetPlayerName(id)} ped ${ped}`);
    ```

- **Caveats / Limitations**:
  - Returns 0 if the player does not exist.
- **Reference**: https://docs.fivem.net/natives/?_0x43A66C31C68491C0
  - TODO(next-run): verify signature and hash against official docs.

##### GetPlayerPing (0x6E31E993)
- **Scope**: Shared
- **Signature**: `int GetPlayerPing(Player player)`
- **Purpose**: Retrieve the measured network latency for a given player in milliseconds.
- **Parameters / Returns**:
  - `player` (`Player`): slot or server ID of the player.
  - **Returns**: `int` latency in milliseconds.
- **OneSync / Networking**: Ping is tracked server‑side and does not rely on entity ownership.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Function
        -- Name: checkPing
        -- Use: Prints a player's current ping to console
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('ping', function(src)
        local ping = GetPlayerPing(src) -- query server latency
        print(('Player %s ping %dms'):format(src, ping))
    end)
    ```

  - JavaScript:

    ```javascript
    // server/main.js
    // Prints a player's ping when they use /ping
    RegisterCommand('ping', (src) => {
      const ping = GetPlayerPing(src); // query server latency
      console.log(`Player ${src} ping ${ping}ms`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 if the player does not exist or ping is unavailable.
- **Reference**: https://docs.fivem.net/natives/?_0x6E31E993
  - TODO(next-run): verify signature and hash against official docs.

##### GetPlayerServerId (hash unknown)
- **Scope**: Shared
- **Signature**: `int GetPlayerServerId(Player player)`
- **Purpose**: Retrieve the server ID associated with a given player slot.
- **Parameters / Returns**:
  - `player` (`Player`): slot or client index.
  - **Returns**: `int` server ID for network events.
- **OneSync / Networking**: Server IDs are required when sending events or referencing players across network boundaries; no entity ownership needed.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: myid
        -- Use: Prints the caller's server ID
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('myid', function()
        local id = GetPlayerServerId(PlayerId()) -- convert client slot to server ID
        print(('Your server ID is %d'):format(id))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('myid', () => {
      const id = GetPlayerServerId(PlayerId()); // convert client slot to server ID
      console.log(`Your server ID is ${id}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 if the player does not exist.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerServerId
  - TODO(next-run): verify signature and hash against official docs.
##### GetPlayerShortName (hash unknown)
- **Scope**: Shared
- **Signature**: `char* GetPlayerShortName(Player player)`
- **Purpose**: Get a truncated version of the player's name.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `string` short name.
- **OneSync / Networking**: Name data is global; no extra replication.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: shortname
        -- Use: Prints a shortened player name
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('shortname', function()
        local id = PlayerId()
        print(('Short: %s'):format(GetPlayerShortName(id)))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('shortname', () => {
      const id = PlayerId();
      console.log(`Short: ${GetPlayerShortName(id)}`);
    });
    ```

- **Caveats / Limitations**:
  - Length is limited by engine rules.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerShortName

##### GetPlayerSprintStaminaRemaining (hash unknown)
- **Scope**: Shared
- **Signature**: `float GetPlayerSprintStaminaRemaining(Player player)`
- **Purpose**: Returns remaining stamina for sprinting.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `float` stamina fraction.
- **OneSync / Networking**: Stamina is local; server should verify important logic.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: stam
        -- Use: Prints sprint stamina remaining
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('stam', function()
        print(('Stamina: %.2f'):format(GetPlayerSprintStaminaRemaining(PlayerId())))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('stam', () => {
      console.log(`Stamina: ${GetPlayerSprintStaminaRemaining(PlayerId()).toFixed(2)}`);
    });
    ```

- **Caveats / Limitations**:
  - Values range 0.0–1.0.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerSprintStaminaRemaining

##### GetPlayerSprintTimeRemaining (hash unknown)
- **Scope**: Shared
- **Signature**: `float GetPlayerSprintTimeRemaining(Player player)`
- **Purpose**: Time left before the player becomes exhausted while sprinting.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `float` seconds remaining.
- **OneSync / Networking**: Local stat; server should validate.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: sprinttime
        -- Use: Prints sprint time remaining
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('sprinttime', function()
        print(('Time: %.2f'):format(GetPlayerSprintTimeRemaining(PlayerId())))
    end)
    ```

  - JavaScript:

    ```javascript
    // client/main.js
    RegisterCommand('sprinttime', () => {
      console.log(`Time: ${GetPlayerSprintTimeRemaining(PlayerId()).toFixed(2)}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 when stamina is depleted.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerSprintTimeRemaining

##### GetPlayerStealthNoise (hash unknown)
- **Scope**: Shared
- **Signature**: `float GetPlayerStealthNoise(Player player)`
- **Purpose**: Retrieve the noise level produced by the player in stealth mode.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `float` noise value.
- **OneSync / Networking**: Local; replicate gameplay consequences server-side.
- **Examples**:
  - Lua:

    ```lua
    RegisterCommand('stealth', function()
        print(('Noise: %.2f'):format(GetPlayerStealthNoise(PlayerId())))
    end)
    ```

  - JavaScript:

    ```javascript
    RegisterCommand('stealth', () => {
      console.log(`Noise: ${GetPlayerStealthNoise(PlayerId()).toFixed(2)}`);
    });
    ```

- **Caveats / Limitations**:
  - Value meaning is undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerStealthNoise
  - TODO(next-run): verify semantics.

##### GetPlayerSwitchState (hash unknown)
- **Scope**: Shared
- **Signature**: `int GetPlayerSwitchState()`
- **Purpose**: Report the current character switch state.
- **Parameters / Returns**:
  - **Returns**: `int` state enum.
- **OneSync / Networking**: Not replicated; affects only local client.
- **Examples**:
  - Lua:

    ```lua
    RegisterCommand('switchstate', function()
        print(('Switch state: %d'):format(GetPlayerSwitchState()))
    end)
    ```

  - JavaScript:

    ```javascript
    RegisterCommand('switchstate', () => {
      console.log(`Switch state: ${GetPlayerSwitchState()}`);
    });
    ```

- **Caveats / Limitations**:
  - Only meaningful in single-player style transitions.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerSwitchState

##### GetPlayerTargetEntity (hash unknown)
- **Scope**: Shared
- **Signature**: `bool GetPlayerTargetEntity(Player player, Entity* entity)`
- **Purpose**: Check which entity the player is aiming at.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `entity` (`Entity*`): Output targeted entity.
  - **Returns**: `bool` success flag.
- **OneSync / Networking**: Targeting may not replicate; server should validate.
- **Examples**:
  - Lua:

    ```lua
    RegisterCommand('target', function()
        local ent = 0
        if GetPlayerTargetEntity(PlayerId(), ent) then
            print(('Target: %s'):format(ent))
        end
    end)
    ```

  - JavaScript:

    ```javascript
    RegisterCommand('target', () => {
      const entBuf = new Int32Array(1);
      if (GetPlayerTargetEntity(PlayerId(), entBuf)) {
        console.log(`Target: ${entBuf[0]}`);
      }
    });
    ```

- **Caveats / Limitations**:
  - Requires mutable reference to receive entity.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerTargetEntity

##### GetPlayerTeam (hash unknown)
- **Scope**: Shared
- **Signature**: `int GetPlayerTeam(Player player)`
- **Purpose**: Get the team index the player belongs to.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `int` team identifier.
- **OneSync / Networking**: Team assignment is global; server authoritative.
- **Examples**:
  - Lua:

    ```lua
    RegisterCommand('team', function()
        print(('Team: %d'):format(GetPlayerTeam(PlayerId())))
    end)
    ```

  - JavaScript:

    ```javascript
    RegisterCommand('team', () => {
      console.log(`Team: ${GetPlayerTeam(PlayerId())}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 if no team is set.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerTeam

##### GetPlayerUnderwaterTimeRemaining (hash unknown)
- **Scope**: Shared
- **Signature**: `float GetPlayerUnderwaterTimeRemaining(Player player)`
- **Purpose**: Time left before drowning while underwater.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `float` seconds remaining.
- **OneSync / Networking**: Local; server should enforce consequences.
- **Examples**:
  - Lua:

    ```lua
    RegisterCommand('water', function()
        print(('Air: %.2f'):format(GetPlayerUnderwaterTimeRemaining(PlayerId())))
    end)
    ```

  - JavaScript:

    ```javascript
    RegisterCommand('water', () => {
      console.log(`Air: ${GetPlayerUnderwaterTimeRemaining(PlayerId()).toFixed(2)}`);
    });
    ```

- **Caveats / Limitations**:
  - Returns 0 when breath is exhausted.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerUnderwaterTimeRemaining

##### GetPlayerWantedCentrePosition (hash unknown)
- **Scope**: Shared
- **Signature**: `void GetPlayerWantedCentrePosition(Player player, float* x, float* y, float* z)`
- **Purpose**: Obtain the coordinates of the wanted level focus point.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - `x`,`y`,`z` (`float*`): Output coordinates.
- **OneSync / Networking**: Position is server-authoritative in OneSync.
- **Examples**:
  - Lua:

    ```lua
    RegisterCommand('wantedpos', function()
        local x,y,z = 0.0,0.0,0.0
        GetPlayerWantedCentrePosition(PlayerId(), x, y, z)
        print(('Wanted centre: %.2f %.2f %.2f'):format(x, y, z))
    end)
    ```

  - JavaScript:

    ```javascript
    RegisterCommand('wantedpos', () => {
      const buf = new Float32Array(3);
      GetPlayerWantedCentrePosition(PlayerId(), buf, buf.subarray(1), buf.subarray(2));
      console.log(`Wanted centre: ${buf[0].toFixed(2)} ${buf[1].toFixed(2)} ${buf[2].toFixed(2)}`);
    });
    ```

- **Caveats / Limitations**:
  - Requires mutable float references.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerWantedCentrePosition

##### GetPlayerWantedLevel (hash unknown)
- **Scope**: Shared
- **Signature**: `int GetPlayerWantedLevel(Player player)`
- **Purpose**: Retrieve the current wanted level for the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
  - **Returns**: `int` wanted level (0–5).
- **OneSync / Networking**: Wanted level syncs across clients; server should manage authority.
- **Examples**:
  - Lua:

    ```lua
    RegisterCommand('wanted', function()
        print(('Wanted level: %d'):format(GetPlayerWantedLevel(PlayerId())))
    end)
    ```

  - JavaScript:

    ```javascript
    RegisterCommand('wanted', () => {
      console.log(`Wanted level: ${GetPlayerWantedLevel(PlayerId())}`);
    });
    ```

- **Caveats / Limitations**:
  - Maximum value is 5.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayerWantedLevel

##### GetPlayersLastVehicle (0xB6997A7EB3F5C8C0 0xE2757AC1)
- **Scope**: Client
- **Signature**: `Vehicle GetPlayersLastVehicle()`
- **Purpose**: Retrieve the last vehicle the player used.
- **Parameters / Returns**:
  - **Returns**: `Vehicle` handle or `0` if destroyed.
- **OneSync / Networking**: Local lookup; verify entity exists before use.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lastveh
        -- Use: Prints last vehicle model
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('lastveh', function()
        local veh = GetPlayersLastVehicle()
        if veh ~= 0 then
            print(('Last vehicle: %s'):format(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lastveh */
    RegisterCommand('lastveh', () => {
      const veh = GetPlayersLastVehicle();
      if (veh !== 0) {
        console.log(`Last vehicle: ${GetDisplayNameFromVehicleModel(GetEntityModel(veh))}`);
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns `0` if last vehicle was destroyed; use `GetVehiclePedIsIn` otherwise.
- **Reference**: https://docs.fivem.net/natives/?n=GetPlayersLastVehicle

##### GetTimeSinceLastArrest (0x5063F92F07C2A316 0x62824EF4)
- **Scope**: Client
- **Signature**: `int GetTimeSinceLastArrest()`
- **Purpose**: Milliseconds elapsed since the player was arrested.
- **Parameters / Returns**:
  - **Returns**: `int` milliseconds or `-1` if never arrested.
- **OneSync / Networking**: Local state; server should track penalties separately.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sincearrest
        -- Use: Prints ms since arrest
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('sincearrest', function()
        print(('Since arrest: %d ms'):format(GetTimeSinceLastArrest()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sincearrest */
    RegisterCommand('sincearrest', () => {
      console.log(`Since arrest: ${GetTimeSinceLastArrest()} ms`);
    });
    ```
- **Caveats / Limitations**:
  - Returns `-1` if the player has never been arrested.
- **Reference**: https://docs.fivem.net/natives/?n=GetTimeSinceLastArrest

##### GetTimeSinceLastDeath (0xC7034807558DDFCA 0x24BC5AC0)
- **Scope**: Client
- **Signature**: `int GetTimeSinceLastDeath()`
- **Purpose**: Milliseconds elapsed since the player last died.
- **Parameters / Returns**:
  - **Returns**: `int` milliseconds or `-1` if never died.
- **OneSync / Networking**: Local measurement; server must enforce respawn rules.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sincedeath
        -- Use: Prints ms since death
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('sincedeath', function()
        print(('Since death: %d ms'):format(GetTimeSinceLastDeath()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sincedeath */
    RegisterCommand('sincedeath', () => {
      console.log(`Since death: ${GetTimeSinceLastDeath()} ms`);
    });
    ```
- **Caveats / Limitations**:
  - Returns `-1` if the player has not died this session.
- **Reference**: https://docs.fivem.net/natives/?n=GetTimeSinceLastDeath

##### GetTimeSincePlayerDroveAgainstTraffic (0xDB89591E290D9182 0x9F27D00E)
- **Scope**: Client
- **Signature**: `int GetTimeSincePlayerDroveAgainstTraffic(Player player)`
- **Purpose**: Milliseconds since the specified player drove against traffic.
- **Parameters / Returns**:
  - `player` (`Player`): Target player index.
  - **Returns**: `int` milliseconds or `-1` if never.
- **OneSync / Networking**: Local check; server should validate traffic offenses.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: trafsince
        -- Use: Shows ms since wrong-way driving
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('trafsince', function()
        print(('Since wrong way: %d ms'):format(GetTimeSincePlayerDroveAgainstTraffic(PlayerId())))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: trafsince */
    RegisterCommand('trafsince', () => {
      console.log(`Since wrong way: ${GetTimeSincePlayerDroveAgainstTraffic(PlayerId())} ms`);
    });
    ```
- **Caveats / Limitations**:
  - Returns `-1` if no instance recorded.
- **Reference**: https://docs.fivem.net/natives/?n=GetTimeSincePlayerDroveAgainstTraffic

##### GetTimeSincePlayerDroveOnPavement (0xD559D2BE9E37853B 0x8836E732)
- **Scope**: Client
- **Signature**: `int GetTimeSincePlayerDroveOnPavement(Player player)`
- **Purpose**: Milliseconds since the player last drove on the sidewalk.
- **Parameters / Returns**:
  - `player` (`Player`): Target player index.
  - **Returns**: `int` milliseconds or `-1` if never.
- **OneSync / Networking**: Local check; server may enforce penalties.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: pavedsince
        -- Use: Shows ms since driving on pavement
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('pavedsince', function()
        print(('Since pavement: %d ms'):format(GetTimeSincePlayerDroveOnPavement(PlayerId())))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: pavedsince */
    RegisterCommand('pavedsince', () => {
      console.log(`Since pavement: ${GetTimeSincePlayerDroveOnPavement(PlayerId())} ms`);
    });
    ```
- **Caveats / Limitations**:
  - Returns `-1` if no event logged.
- **Reference**: https://docs.fivem.net/natives/?n=GetTimeSincePlayerDroveOnPavement

##### GetTimeSincePlayerHitPed (0xE36A25322DC35F42 0xB6209195)
- **Scope**: Client
- **Signature**: `int GetTimeSincePlayerHitPed(Player player)`
- **Purpose**: Milliseconds since the player collided with a pedestrian.
- **Parameters / Returns**:
  - `player` (`Player`): Target player index.
  - **Returns**: `int` milliseconds or `-1` if never.
- **OneSync / Networking**: Local metric; servers should validate damage.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hitpedsince
        -- Use: Shows ms since hitting a ped
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('hitpedsince', function()
        print(('Since hit ped: %d ms'):format(GetTimeSincePlayerHitPed(PlayerId())))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hitpedsince */
    RegisterCommand('hitpedsince', () => {
      console.log(`Since hit ped: ${GetTimeSincePlayerHitPed(PlayerId())} ms`);
    });
    ```
- **Caveats / Limitations**:
  - Returns `-1` if no collision recorded.
- **Reference**: https://docs.fivem.net/natives/?n=GetTimeSincePlayerHitPed

##### GetTimeSincePlayerHitVehicle (0x5D35ECF3A81A0EE0 0x6E9B8B9E)
- **Scope**: Client
- **Signature**: `int GetTimeSincePlayerHitVehicle(Player player)`
- **Purpose**: Milliseconds since the player collided with a vehicle.
- **Parameters / Returns**:
  - `player` (`Player`): Target player index.
  - **Returns**: `int` milliseconds or `-1` if never.
- **OneSync / Networking**: Local metric; servers should track damage separately.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hitvehsince
        -- Use: Shows ms since hitting a vehicle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('hitvehsince', function()
        print(('Since hit vehicle: %d ms'):format(GetTimeSincePlayerHitVehicle(PlayerId())))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hitvehsince */
    RegisterCommand('hitvehsince', () => {
      console.log(`Since hit vehicle: ${GetTimeSincePlayerHitVehicle(PlayerId())} ms`);
    });
    ```
- **Caveats / Limitations**:
  - Returns `-1` if no collision recorded.
- **Reference**: https://docs.fivem.net/natives/?n=GetTimeSincePlayerHitVehicle

##### GetWantedLevelParoleDuration (0xA72200F51875FEA4)
- **Scope**: Client
- **Signature**: `int GetWantedLevelParoleDuration()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: `int` value, meaning unknown.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: parole
        -- Use: Prints parole duration value
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('parole', function()
        print(('_GET_WANTED_LEVEL_PAROLE_DURATION: %d'):format(GetWantedLevelParoleDuration()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: parole */
    RegisterCommand('parole', () => {
      console.log(`_GET_WANTED_LEVEL_PAROLE_DURATION: ${GetWantedLevelParoleDuration()}`);
    });
    ```
- **Caveats / Limitations**:
  - Documentation lacks details.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_WANTED_LEVEL_PAROLE_DURATION

##### GetWantedLevelRadius (0x085DEB493BE80812 0x1CF7D7DA)
- **Scope**: Client
- **Signature**: `float GetWantedLevelRadius(Player player)`
- **Purpose**: Legacy native from GTA IV; returns no useful data.
- **Parameters / Returns**:
  - `player` (`Player`): Target player index.
  - **Returns**: `float` radius; typically `0.0`.
- **OneSync / Networking**: No replicated effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wlradius
        -- Use: Prints wanted level radius
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wlradius', function()
        print(('Wanted radius: %.2f'):format(GetWantedLevelRadius(PlayerId())))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wlradius */
    RegisterCommand('wlradius', () => {
      console.log(`Wanted radius: ${GetWantedLevelRadius(PlayerId()).toFixed(2)}`);
    });
    ```
- **Caveats / Limitations**:
  - Does nothing in GTA V.
- **Reference**: https://docs.fivem.net/natives/?n=GetWantedLevelRadius

##### GetWantedLevelThreshold (0xFDD179EAF45B556C 0xD9783F6B)
- **Scope**: Client
- **Signature**: `int GetWantedLevelThreshold(int wantedLevel)`
- **Purpose**: Returns score threshold for a wanted level.
- **Parameters / Returns**:
  - `wantedLevel` (`int`): Level 1–5.
  - **Returns**: `int` score threshold (undocumented units).
- **OneSync / Networking**: Local only; server should manage wanted logic.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wlthreshold
        -- Use: Shows threshold for wanted level
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wlthreshold', function(src, args)
        local lvl = tonumber(args[1]) or 1
        print(('Threshold: %d'):format(GetWantedLevelThreshold(lvl)))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wlthreshold */
    RegisterCommand('wlthreshold', (_, args) => {
      const lvl = parseInt(args[0] ?? '1', 10);
      console.log(`Threshold: ${GetWantedLevelThreshold(lvl)}`);
    });
    ```
- **Caveats / Limitations**:
  - Units are undocumented.
  - TODO(next-run): verify scaling.
- **Reference**: https://docs.fivem.net/natives/?n=GetWantedLevelThreshold

##### GiveAchievementToPlayer (0xBEC7076D64130195 0x822BC992)
- **Scope**: Client
- **Signature**: `BOOL GiveAchievementToPlayer(int achievement)`
- **Purpose**: Award a GTA achievement to the local player.
- **Parameters / Returns**:
  - `achievement` (`int`): Achievement ID (0–60).
  - **Returns**: `bool` success status.
- **OneSync / Networking**: Local only; no server-side tracking.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: achieve
        -- Use: Triggers an achievement
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('achieve', function(_, args)
        local id = tonumber(args[1]) or 0
        GiveAchievementToPlayer(id)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: achieve */
    RegisterCommand('achieve', (_, args) => {
      const id = parseInt(args[0] ?? '0', 10);
      GiveAchievementToPlayer(id);
    });
    ```
- **Caveats / Limitations**:
  - Achievement IDs above documented range may have no effect.
- **Reference**: https://docs.fivem.net/natives/?n=GiveAchievementToPlayer

##### GivePlayerRagdollControl (0x3C49C870E66F0A28 0xC7B4D7AC)
- **Scope**: Client
- **Signature**: `void GivePlayerRagdollControl(Player player, BOOL toggle)`
- **Purpose**: Allow or revoke ragdoll control for a player.
- **Parameters / Returns**:
  - `player` (`Player`): Target player index.
  - `toggle` (`bool`): `true` to allow control.
- **OneSync / Networking**: Applies locally; server should enforce gameplay rules.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: ragdollctrl
        -- Use: Toggles ragdoll control
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('ragdollctrl', function(_, args)
        local enable = args[1] == '1'
        GivePlayerRagdollControl(PlayerId(), enable)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: ragdollctrl */
    RegisterCommand('ragdollctrl', (_, args) => {
      const enable = args[0] === '1';
      GivePlayerRagdollControl(PlayerId(), enable);
    });
    ```
- **Caveats / Limitations**:
  - Only affects local player's ped.
- **Reference**: https://docs.fivem.net/natives/?n=GivePlayerRagdollControl

##### HasAchievementBeenPassed (0x867365E111A3B6EB 0x136A5BE9)
- **Scope**: Client
- **Signature**: `BOOL HasAchievementBeenPassed(int achievement)`
- **Purpose**: Check if an achievement has been unlocked.
- **Parameters / Returns**:
  - `achievement` (`int`): Achievement ID.
  - **Returns**: `bool` true if unlocked.
- **OneSync / Networking**: Local check.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hasach
        -- Use: Tests achievement status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('hasach', function(_, args)
        local id = tonumber(args[1]) or 0
        print(('Unlocked: %s'):format(tostring(HasAchievementBeenPassed(id))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hasach */
    RegisterCommand('hasach', (_, args) => {
      const id = parseInt(args[0] ?? '0', 10);
      console.log(`Unlocked: ${HasAchievementBeenPassed(id)}`);
    });
    ```
- **Caveats / Limitations**:
  - Uses same ID range as `GiveAchievementToPlayer`.
- **Reference**: https://docs.fivem.net/natives/?n=HasAchievementBeenPassed

##### HasForceCleanupOccurred (0xC968670BFACE42D9 0x4B37333C)
- **Scope**: Client
- **Signature**: `BOOL HasForceCleanupOccurred(int cleanupFlags)`
- **Purpose**: Detect if a force cleanup has been triggered.
- **Parameters / Returns**:
  - `cleanupFlags` (`int`): Bitmask of cleanup causes.
  - **Returns**: `bool` true if the event occurred.
- **OneSync / Networking**: Local script housekeeping.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: fcleanup
        -- Use: Checks force cleanup flag
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('fcleanup', function(_, args)
        local flag = tonumber(args[1]) or 0
        print(('Cleanup: %s'):format(tostring(HasForceCleanupOccurred(flag))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: fcleanup */
    RegisterCommand('fcleanup', (_, args) => {
      const flag = parseInt(args[0] ?? '0', 10);
      console.log(`Cleanup: ${HasForceCleanupOccurred(flag)}`);
    });
    ```
- **Caveats / Limitations**:
  - Flags vary by script; consult R* script references.
- **Reference**: https://docs.fivem.net/natives/?n=HasForceCleanupOccurred

##### HasPlayerBeenShotByCop (0xBC0753C9CA14B506 0x9DF75B2A)
- **Scope**: Client
- **Signature**: `BOOL HasPlayerBeenShotByCop(Player player, int ms, BOOL p2)`
- **Purpose**: Check if a cop shot the player within a time window.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `ms` (`int`): Time window in milliseconds.
  - `p2` (`bool`): Usually `false`.
  - **Returns**: `bool` true if shot by police.
- **OneSync / Networking**: Local detection; servers should verify damage source.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: copshot
        -- Use: Checks if police shot you recently
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('copshot', function()
        print(('_HAS_PLAYER_BEEN_SHOT_BY_COP: %s'):format(tostring(HasPlayerBeenShotByCop(PlayerId(), 5000, false))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: copshot */
    RegisterCommand('copshot', () => {
      console.log(`_HAS_PLAYER_BEEN_SHOT_BY_COP: ${HasPlayerBeenShotByCop(PlayerId(), 5000, false)}`);
    });
    ```
- **Caveats / Limitations**:
  - `p2` parameter remains undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=_HAS_PLAYER_BEEN_SHOT_BY_COP

##### HasPlayerBeenSpottedInStolenVehicle (0xD705740BB0A1CF4C 0x4A01B76A)
- **Scope**: Client
- **Signature**: `BOOL HasPlayerBeenSpottedInStolenVehicle(Player player)`
- **Purpose**: Determine if police witnessed the player in a stolen vehicle.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if spotted.
- **OneSync / Networking**: Local check; server should enforce consequences.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: stolen
        -- Use: Prints stolen-vehicle detection
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('stolen', function()
        print(('Spotted: %s'):format(tostring(HasPlayerBeenSpottedInStolenVehicle(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stolen */
    RegisterCommand('stolen', () => {
      console.log(`Spotted: ${HasPlayerBeenSpottedInStolenVehicle(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Depends on police perception system.
- **Reference**: https://docs.fivem.net/natives/?n=HasPlayerBeenSpottedInStolenVehicle

##### HasPlayerDamagedAtLeastOneNonAnimalPed (0xE4B90F367BD81752 0xA3707DFC)
- **Scope**: Client
- **Signature**: `BOOL HasPlayerDamagedAtLeastOneNonAnimalPed(Player player)`
- **Purpose**: Check if the player has hurt any human ped.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if damage occurred.
- **OneSync / Networking**: Local metric; servers handle crime tracking.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nonanimal
        -- Use: Checks human ped damage
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nonanimal', function()
        print(('Damaged human: %s'):format(tostring(HasPlayerDamagedAtLeastOneNonAnimalPed(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nonanimal */
    RegisterCommand('nonanimal', () => {
      console.log(`Damaged human: ${HasPlayerDamagedAtLeastOneNonAnimalPed(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Animals do not trigger this flag.
- **Reference**: https://docs.fivem.net/natives/?n=HasPlayerDamagedAtLeastOneNonAnimalPed

##### HasPlayerDamagedAtLeastOnePed (0x20CE80B0C2BF4ACC 0x14F52453)
- **Scope**: Client
- **Signature**: `BOOL HasPlayerDamagedAtLeastOnePed(Player player)`
- **Purpose**: Check if the player has damaged any pedestrian.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if damage occurred.
- **OneSync / Networking**: Local metric; servers handle penalty.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: pedhit
        -- Use: Checks ped damage
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('pedhit', function()
        print(('Damaged ped: %s'):format(tostring(HasPlayerDamagedAtLeastOnePed(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: pedhit */
    RegisterCommand('pedhit', () => {
      console.log(`Damaged ped: ${HasPlayerDamagedAtLeastOnePed(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Includes animals unless filtered separately.
- **Reference**: https://docs.fivem.net/natives/?n=HasPlayerDamagedAtLeastOnePed

##### HasPlayerLeftTheWorld (0xD55DDFB47991A294 0xFEA40B6C)
- **Scope**: Client
- **Signature**: `BOOL HasPlayerLeftTheWorld(Player player)`
- **Purpose**: Determine if the player moved beyond world bounds.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if outside bounds.
- **OneSync / Networking**: Local; server should validate coordinates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: outworld
        -- Use: Checks if player left world
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('outworld', function()
        print(('Left world: %s'):format(tostring(HasPlayerLeftTheWorld(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: outworld */
    RegisterCommand('outworld', () => {
      console.log(`Left world: ${HasPlayerLeftTheWorld(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Triggered in rare edge cases.
- **Reference**: https://docs.fivem.net/natives/?n=HasPlayerLeftTheWorld

##### IntToParticipantindex (0x9EC6603812C24710 0x98F3B274)
- **Scope**: Client
- **Signature**: `int IntToParticipantindex(int value)`
- **Purpose**: Convert an integer to a network participant index.
- **Parameters / Returns**:
  - `value` (`int`): Input integer.
  - **Returns**: Same value.
- **OneSync / Networking**: Utility for network participant IDs.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: topart
        -- Use: Casts value to participant index
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('topart', function(_, args)
        local v = tonumber(args[1]) or 0
        print(('Participant: %d'):format(IntToParticipantindex(v)))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: topart */
    RegisterCommand('topart', (_, args) => {
      const v = parseInt(args[0] ?? '0', 10);
      console.log(`Participant: ${IntToParticipantindex(v)}`);
    });
    ```
- **Caveats / Limitations**:
  - Performs no validation; returns input unchanged.
- **Reference**: https://docs.fivem.net/natives/?n=IntToParticipantindex

##### IntToPlayerindex (0x41BD2A6B006AF756 0x98DD98F1)
- **Scope**: Client
- **Signature**: `Player IntToPlayerindex(int value)`
- **Purpose**: Cast an integer to a Player handle.
- **Parameters / Returns**:
  - `value` (`int`): Input integer.
  - **Returns**: `Player` handle equal to the input.
- **OneSync / Networking**: Utility; does not validate existence.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: toplayer
        -- Use: Casts value to player handle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('toplayer', function(_, args)
        local v = tonumber(args[1]) or 0
        print(('Player handle: %d'):format(IntToPlayerindex(v)))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: toplayer */
    RegisterCommand('toplayer', (_, args) => {
      const v = parseInt(args[0] ?? '0', 10);
      console.log(`Player handle: ${IntToPlayerindex(v)}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not check if the player exists.
- **Reference**: https://docs.fivem.net/natives/?n=IntToPlayerindex

##### IsPlayerBattleAware (0x38D28DA81E4E9BF9 0x013B4F72)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerBattleAware(Player player)`
- **Purpose**: Determine if the player is in combat awareness.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if battle-aware.
- **OneSync / Networking**: Local check.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: battleaware
        -- Use: Prints battle awareness status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('battleaware', function()
        print(('Battle aware: %s'):format(tostring(IsPlayerBattleAware(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: battleaware */
    RegisterCommand('battleaware', () => {
      console.log(`Battle aware: ${IsPlayerBattleAware(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Underlying metric is unspecified.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerBattleAware

##### IsPlayerBeingArrested (0x388A47C51ABDAC8E 0x7F6A60D3)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerBeingArrested(Player player, BOOL atArresting)`
- **Purpose**: Check if the player is currently being arrested.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `atArresting` (`bool`): Include pre-busted state when `true`.
  - **Returns**: `bool` true if arrest sequence is active.
- **OneSync / Networking**: Local check; server must enforce jail logic.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: arresting
        -- Use: Checks if being arrested
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('arresting', function()
        print(('Being arrested: %s'):format(tostring(IsPlayerBeingArrested(PlayerId(), true))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: arresting */
    RegisterCommand('arresting', () => {
      console.log(`Being arrested: ${IsPlayerBeingArrested(PlayerId(), true)}`);
    });
    ```
- **Caveats / Limitations**:
  - `atArresting` changes when the flag becomes true.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerBeingArrested

##### IsPlayerBluetoothEnable (0x65FAEE425DE637B0 0xEA01BD4A)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerBluetoothEnable(Player player)`
- **Purpose**: Check if the player's Bluetooth feature is enabled.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if enabled.
- **OneSync / Networking**: Local-only; used for Rockstar features.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: btcheck
        -- Use: Prints Bluetooth status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('btcheck', function()
        print(('Bluetooth: %s'):format(tostring(IsPlayerBluetoothEnable(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: btcheck */
    RegisterCommand('btcheck', () => {
      console.log(`Bluetooth: ${IsPlayerBluetoothEnable(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Mainly used on consoles; often returns false on PC.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerBluetoothEnable

##### IsPlayerClimbing (0x95E8F73DC65EFB9C 0x4A9E9AE0)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerClimbing(Player player)`
- **Purpose**: Determine if the player is climbing.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true while climbing.
- **OneSync / Networking**: Local movement state; not network authoritative.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: climbing
        -- Use: Prints climb status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('climbing', function()
        print(('Climbing: %s'):format(tostring(IsPlayerClimbing(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: climbing */
    RegisterCommand('climbing', () => {
      console.log(`Climbing: ${IsPlayerClimbing(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Only checks local ped state.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerClimbing

##### IsPlayerControlOn (0x49C32D60007AFA47 0x618857F2)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerControlOn(Player player)`
- **Purpose**: Check if the player currently has input control enabled.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true when control is active.
- **OneSync / Networking**: Local check; server cannot rely on it for authority.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: ctrlon
        -- Use: Prints control state
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('ctrlon', function()
        print(('Control on: %s'):format(tostring(IsPlayerControlOn(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: ctrlon */
    RegisterCommand('ctrlon', () => {
      console.log(`Control on: ${IsPlayerControlOn(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not toggle control; use `SetPlayerControl` to change state.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerControlOn

##### IsPlayerDead (0x424D4687FA1E5652 0x140CA5A8)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerDead(Player player)`
- **Purpose**: Determine if the player's ped is dead.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if the player has died.
- **OneSync / Networking**: Local check; server should validate death before consequences.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: isdead
        -- Use: Prints death status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('isdead', function()
        print(('Dead: %s'):format(tostring(IsPlayerDead(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: isdead */
    RegisterCommand('isdead', () => {
      console.log(`Dead: ${IsPlayerDead(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not account for incapacitation without death.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerDead

##### IsPlayerDrivingDangerously (0xF10B44FD479D69F3 0x1E359CC8)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerDrivingDangerously(Player player, int type)`
- **Purpose**: Check if the player is driving recklessly; `type` meaning is undocumented.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `type` (`int`): Mode flag (semantics unknown).
  - **Returns**: `bool` true when flagged as dangerous.
- **OneSync / Networking**: Local heuristic; not authoritative.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: drivedanger
        -- Use: Tests dangerous driving state
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('drivedanger', function()
        print(('Dangerous: %s'):format(tostring(IsPlayerDrivingDangerously(PlayerId(), 0))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: drivedanger */
    RegisterCommand('drivedanger', () => {
      console.log(`Dangerous: ${IsPlayerDrivingDangerously(PlayerId(), 0)}`);
    });
    ```
- **Caveats / Limitations**:
  - `type` parameter lacks official description.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerDrivingDangerously

##### IsPlayerFreeAiming (0x2E397FD2ECD37C87 0x1DEC67B7)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerFreeAiming(Player player)`
- **Purpose**: Determine if the player is aiming without a target lock.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true while freely aiming.
- **OneSync / Networking**: Aiming state is client-side; servers should verify actions.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: freeaim
        -- Use: Prints free-aim status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('freeaim', function()
        print(('Free aiming: %s'):format(tostring(IsPlayerFreeAiming(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: freeaim */
    RegisterCommand('freeaim', () => {
      console.log(`Free aiming: ${IsPlayerFreeAiming(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not reveal aim target.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerFreeAiming

##### IsPlayerFreeAimingAtEntity (0x3C06B5C839B38F7B 0x7D80EEAA)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerFreeAimingAtEntity(Player player, Entity entity)`
- **Purpose**: Check if the player is free-aiming specifically at an entity.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `entity` (`Entity`): Entity being evaluated.
  - **Returns**: `bool` true when the entity is targeted.
- **OneSync / Networking**: Entity must exist locally; server should validate hits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: aimat
        -- Use: Tests aim at current target
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('aimat', function()
        local target = PlayerPedId()
        print(('Aiming at self: %s'):format(tostring(IsPlayerFreeAimingAtEntity(PlayerId(), target))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: aimat */
    RegisterCommand('aimat', () => {
      const target = PlayerPedId();
      console.log(`Aiming at self: ${IsPlayerFreeAimingAtEntity(PlayerId(), target)}`);
    });
    ```
- **Caveats / Limitations**:
  - Only checks a single entity at a time.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerFreeAimingAtEntity

##### IsPlayerFreeForAmbientTask (0xDCCFD3F106C36AB4 0x85C7E232)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerFreeForAmbientTask(Player player)`
- **Purpose**: Determine if the player is free for ambient AI tasks.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true when free for ambient tasks.
- **OneSync / Networking**: Local behavior; server-side scripts should not rely on it.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: ambient
        -- Use: Checks ambient task availability
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('ambient', function()
        print(('Free for ambient: %s'):format(tostring(IsPlayerFreeForAmbientTask(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: ambient */
    RegisterCommand('ambient', () => {
      console.log(`Free for ambient: ${IsPlayerFreeForAmbientTask(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Internal logic not documented.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerFreeForAmbientTask

##### IsPlayerLoggingInNp (0x74556E1420867ECA 0x8F72FAD0)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerLoggingInNp()`
- **Purpose**: Check if the player is logging into NP (unused feature).
- **Parameters / Returns**:
  - **Returns**: `bool` always false per docs.
- **OneSync / Networking**: Local stub; no network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: loginchk
        -- Use: Prints NP login status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('loginchk', function()
        print(('Logging in NP: %s'):format(tostring(IsPlayerLoggingInNp())))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: loginchk */
    RegisterCommand('loginchk', () => {
      console.log(`Logging in NP: ${IsPlayerLoggingInNp()}`);
    });
    ```
- **Caveats / Limitations**:
  - Hard-coded to return false.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerLoggingInNp

##### IsPlayerOnline (0xF25D331DC2627BBC 0x9FAB6729)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerOnline()`
- **Purpose**: Determine if the game session is connected to online services.
- **Parameters / Returns**:
  - **Returns**: `bool` true when network services are signed in.
- **OneSync / Networking**: Local; relates to Rockstar online state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: online
        -- Use: Prints online state
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('online', function()
        print(('Online: %s'):format(tostring(IsPlayerOnline())))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: online */
    RegisterCommand('online', () => {
      console.log(`Online: ${IsPlayerOnline()}`);
    });
    ```
- **Caveats / Limitations**:
  - Alias of `NetworkIsSignedOnline`.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerOnline

##### IsPlayerPlaying (0x5E9564D8246B909A 0xE15D777F)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerPlaying(Player player)`
- **Purpose**: Check if the player has a valid, alive ped.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true if playing.
- **OneSync / Networking**: Ped existence must be confirmed by server for authoritative logic.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playing
        -- Use: Prints playing status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('playing', function()
        print(('Is playing: %s'):format(tostring(IsPlayerPlaying(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playing */
    RegisterCommand('playing', () => {
      console.log(`Is playing: ${IsPlayerPlaying(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not confirm active participation in gameplay.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerPlaying

##### IsPlayerPressingHorn (0xFA1E2BF8B10598F9 0xED1D1662)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerPressingHorn(Player player)`
- **Purpose**: Determine if the player is holding the vehicle horn.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true while horn is pressed.
- **OneSync / Networking**: Horn state not network authoritative; sync separately if needed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: horn
        -- Use: Prints horn state
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('horn', function()
        print(('Pressing horn: %s'):format(tostring(IsPlayerPressingHorn(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: horn */
    RegisterCommand('horn', () => {
      console.log(`Pressing horn: ${IsPlayerPressingHorn(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Only valid when the player is in a vehicle.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerPressingHorn

##### IsPlayerReadyForCutscene (0x908CBECC2CAA3690 0xBB77E9CD)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerReadyForCutscene(Player player)`
- **Purpose**: Check if the player is ready to start a cutscene.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` readiness flag.
- **OneSync / Networking**: Local state; synchronize cutscene triggers via events.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cutscene
        -- Use: Prints cutscene readiness
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('cutscene', function()
        print(('Ready for cutscene: %s'):format(tostring(IsPlayerReadyForCutscene(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cutscene */
    RegisterCommand('cutscene', () => {
      console.log(`Ready for cutscene: ${IsPlayerReadyForCutscene(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not initiate cutscene.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerReadyForCutscene

##### IsPlayerRidingTrain (0x4EC12697209F2196 0x9765E71D)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerRidingTrain(Player player)`
- **Purpose**: Check if the player is currently on a train.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true when riding a train.
- **OneSync / Networking**: Train state must be replicated via entity ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: train
        -- Use: Prints train riding status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('train', function()
        print(('On train: %s'):format(tostring(IsPlayerRidingTrain(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: train */
    RegisterCommand('train', () => {
      console.log(`On train: ${IsPlayerRidingTrain(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Only detects actual train entities.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerRidingTrain

##### IsPlayerScriptControlOn (0x8A876A65283DD7D7 0x61B00A84)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerScriptControlOn(Player player)`
- **Purpose**: Determine if the script currently controls the player.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` control flag.
- **OneSync / Networking**: Local check; does not grant control rights.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: scriptctrl
        -- Use: Prints script control status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('scriptctrl', function()
        print(('Script control: %s'):format(tostring(IsPlayerScriptControlOn(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: scriptctrl */
    RegisterCommand('scriptctrl', () => {
      console.log(`Script control: ${IsPlayerScriptControlOn(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not change control state.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerScriptControlOn

##### IsPlayerTargettingAnything (0x78CFE51896B6B8A4 0x456DB50D)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerTargettingAnything(Player player)`
- **Purpose**: Check if the player is targeting any entity.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` true when any target is locked.
- **OneSync / Networking**: Targeting is client-side; server should validate hits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: targeting
        -- Use: Prints targeting state
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('targeting', function()
        print(('Targeting anything: %s'):format(tostring(IsPlayerTargettingAnything(PlayerId()))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: targeting */
    RegisterCommand('targeting', () => {
      console.log(`Targeting anything: ${IsPlayerTargettingAnything(PlayerId())}`);
    });
    ```
- **Caveats / Limitations**:
  - Does not return which entity is targeted.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerTargettingAnything

##### IsPlayerTargettingEntity (0x7912F7FC4F6264B6 0xF3240B77)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerTargettingEntity(Player player, Entity entity)`
- **Purpose**: Check if the player is targeting a specific entity.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `entity` (`Entity`): Entity to test.
  - **Returns**: `bool` true if the entity is targeted.
- **OneSync / Networking**: Entity must exist locally; server should confirm targeting events.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: targetent
        -- Use: Tests targeting of own ped
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('targetent', function()
        local ent = PlayerPedId()
        print(('Targeting self: %s'):format(tostring(IsPlayerTargettingEntity(PlayerId(), ent))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: targetent */
    RegisterCommand('targetent', () => {
      const ent = PlayerPedId();
      console.log(`Targeting self: ${IsPlayerTargettingEntity(PlayerId(), ent)}`);
    });
    ```
- **Caveats / Limitations**:
  - Requires entity handle; does not return the target.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerTargettingEntity
##### IsPlayerTeleportActive (0x02B15662D7F8886F 0x3A11D118)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerTeleportActive()`
- **Purpose**: Determine if a teleport started with `StartPlayerTeleport` is in progress.
- **Parameters / Returns**:
  - **Returns**: `bool` `true` while teleport is active.
- **OneSync / Networking**: Local check; server should manage remote teleports.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: waittp
        -- Use: Waits for any active teleport to finish
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('waittp', function()
        while IsPlayerTeleportActive() do
            Wait(0)
        end
        print('Teleport complete')
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: waittp */
    RegisterCommand('waittp', () => {
      const tick = setTick(() => {
        if (!IsPlayerTeleportActive()) {
          console.log('Teleport complete');
          clearTick(tick);
        }
      });
    });
    ```
- **Caveats / Limitations**:
  - Only reflects local teleport state.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerTeleportActive

##### IsPlayerWantedLevelGreater (0x238DB2A2C23EE9EF 0x589A2661)
- **Scope**: Client
- **Signature**: `BOOL IsPlayerWantedLevelGreater(Player player, int wantedLevel)`
- **Purpose**: Check if a player's wanted level exceeds a threshold.
- **Parameters / Returns**:
  - `player` (`Player`): Player handle.
  - `wantedLevel` (`int`): Level to compare.
  - **Returns**: `bool` `true` if current level is above the threshold.
- **OneSync / Networking**: Call on the player owner for accurate results.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wantedgt
        -- Use: Tests if wanted level is greater than argument
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wantedgt', function(_, args)
        local lvl = tonumber(args[1]) or 0
        print(IsPlayerWantedLevelGreater(PlayerId(), lvl))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wantedgt */
    RegisterCommand('wantedgt', (_, args) => {
      const lvl = parseInt(args[0] ?? '0', 10);
      console.log(IsPlayerWantedLevelGreater(PlayerId(), lvl));
    });
    ```
- **Caveats / Limitations**:
  - Client view only; server should enforce wanted levels.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerWantedLevelGreater

##### IsSpecialAbilityActive (0x3E5F7FC85D854E15 0x1B17E334)
- **Scope**: Client
- **Signature**: `BOOL IsSpecialAbilityActive(Player player)`
- **Purpose**: Check if the player's special ability is currently active.
- **Parameters / Returns**:
  - `player` (`Player`): Player handle.
  - **Returns**: `bool` `true` when ability is active.
- **OneSync / Networking**: Ability state is local; sync to others via events if needed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: abilityactive
        -- Use: Prints special ability state
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('abilityactive', function()
        print(IsSpecialAbilityActive(PlayerId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: abilityactive */
    RegisterCommand('abilityactive', () => {
      console.log(IsSpecialAbilityActive(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Some builds mention an unused parameter.
- **Reference**: https://docs.fivem.net/natives/?n=IsSpecialAbilityActive

##### IsSpecialAbilityEnabled (0xB1D200FE26AEF3CB 0xC01238CC)
- **Scope**: Client
- **Signature**: `BOOL IsSpecialAbilityEnabled(Player player)`
- **Purpose**: Determine if the special ability is enabled for the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player handle.
  - **Returns**: `bool` flag.
- **OneSync / Networking**: State is local; server can enforce via abilities.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: abilityenabled
        -- Use: Shows if special ability is enabled
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('abilityenabled', function()
        print(IsSpecialAbilityEnabled(PlayerId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: abilityenabled */
    RegisterCommand('abilityenabled', () => {
      console.log(IsSpecialAbilityEnabled(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Documentation notes an extra, undefined parameter.
- **Reference**: https://docs.fivem.net/natives/?n=IsSpecialAbilityEnabled

##### IsSpecialAbilityMeterFull (0x05A1FE504B7F2587 0x2E19D7F6)
- **Scope**: Client
- **Signature**: `BOOL IsSpecialAbilityMeterFull(Player player)`
- **Purpose**: Check if the player's special ability meter is full.
- **Parameters / Returns**:
  - `player` (`Player`): Player handle.
  - **Returns**: `bool` `true` if meter is full.
- **OneSync / Networking**: Meter value is local; replicate via events if required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: abilityfull
        -- Use: Prints if special ability meter is full
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('abilityfull', function()
        print(IsSpecialAbilityMeterFull(PlayerId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: abilityfull */
    RegisterCommand('abilityfull', () => {
      console.log(IsSpecialAbilityMeterFull(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Documentation notes an extra, undefined parameter.
- **Reference**: https://docs.fivem.net/natives/?n=IsSpecialAbilityMeterFull

##### IsSpecialAbilityUnlocked (0xC6017F6A6CDFA694 0xC9C75E82)
- **Scope**: Client
- **Signature**: `BOOL IsSpecialAbilityUnlocked(Hash playerModel)`
- **Purpose**: Check if the special ability is unlocked for a player model.
- **Parameters / Returns**:
  - `playerModel` (`Hash`): Model hash to test.
  - **Returns**: `bool` unlock state.
- **OneSync / Networking**: Use model hash consistent with server setup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: abilityunlocked
        -- Use: Tests ability unlock for current ped
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('abilityunlocked', function()
        local model = GetEntityModel(PlayerPedId())
        print(IsSpecialAbilityUnlocked(model))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: abilityunlocked */
    RegisterCommand('abilityunlocked', () => {
      const model = GetEntityModel(PlayerPedId());
      console.log(IsSpecialAbilityUnlocked(model));
    });
    ```
- **Caveats / Limitations**:
  - Only checks unlock status; does not activate ability.
- **Reference**: https://docs.fivem.net/natives/?n=IsSpecialAbilityUnlocked

##### IsSystemUiBeingDisplayed (0x5D511E3867C87139 0xE495B6DA)
- **Scope**: Client
- **Signature**: `BOOL IsSystemUiBeingDisplayed()`
- **Purpose**: Detect if system UI (e.g., Rockstar overlays) is visible.
- **Parameters / Returns**:
  - **Returns**: `bool` `true` when UI overlays block gameplay.
- **OneSync / Networking**: Local only; useful for pausing gameplay logic.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sysui
        -- Use: Prints system UI visibility
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('sysui', function()
        print(IsSystemUiBeingDisplayed())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sysui */
    RegisterCommand('sysui', () => {
      console.log(IsSystemUiBeingDisplayed());
    });
    ```
- **Caveats / Limitations**:
  - Does not specify which overlay is shown.
- **Reference**: https://docs.fivem.net/natives/?n=IsSystemUiBeingDisplayed

##### _0x0032A6DBA562C518 (0x0032A6DBA562C518 0x47CAB814)
- **Scope**: Client
- **Signature**: `void _0x0032A6DBA562C518()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native0032
        -- Use: Calls the undocumented native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native0032', function()
        _0x0032A6DBA562C518()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native0032 */
    RegisterCommand('native0032', () => {
      global._0x0032A6DBA562C518();
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x0032A6DBA562C518

##### _0x237440E46D918649 (0x237440E46D918649)
- **Scope**: Client
- **Signature**: `void _0x237440E46D918649(Any p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native2374
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native2374', function()
        _0x237440E46D918649(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native2374 */
    RegisterCommand('native2374', () => {
      global._0x237440E46D918649(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x237440E46D918649

##### _0x2382AB11450AE7BA (0x2382AB11450AE7BA)
- **Scope**: Client
- **Signature**: `void _0x2382AB11450AE7BA(Any p0, Any p1)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
  - `p1` (`any`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native2382
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native2382', function()
        _0x2382AB11450AE7BA(0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native2382 */
    RegisterCommand('native2382', () => {
      global._0x2382AB11450AE7BA(0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x2382AB11450AE7BA

##### _0x2F41A3BAE005E5FA (0x2F41A3BAE005E5FA)
- **Scope**: Client
- **Signature**: `void _0x2F41A3BAE005E5FA(Any p0, Any p1)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
  - `p1` (`any`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native2f41
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native2f41', function()
        _0x2F41A3BAE005E5FA(0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native2f41 */
    RegisterCommand('native2f41', () => {
      _0x2F41A3BAE005E5FA(0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x2F41A3BAE005E5FA

##### _0x2F7CEB6520288061 (0x2F7CEB6520288061 0x2849D4B2)
- **Scope**: Client
- **Signature**: `void _0x2F7CEB6520288061(BOOL p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`bool`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native2f7c
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native2f7c', function()
        _0x2F7CEB6520288061(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native2f7c */
    RegisterCommand('native2f7c', () => {
      _0x2F7CEB6520288061(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x2F7CEB6520288061

##### _0x31E90B8873A4CD3B (0x31E90B8873A4CD3B)
- **Scope**: Client
- **Signature**: `void _0x31E90B8873A4CD3B(Player player, float p1)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
  - `p1` (`float`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native31e9
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native31e9', function()
        _0x31E90B8873A4CD3B(0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native31e9 */
    RegisterCommand('native31e9', () => {
      _0x31E90B8873A4CD3B(0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x31E90B8873A4CD3B

##### _0x36F1B38855F2A8DF (0x36F1B38855F2A8DF 0x3A7E5FB6)
- **Scope**: Client
- **Signature**: `void _0x36F1B38855F2A8DF(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native36f1
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native36f1', function()
        _0x36F1B38855F2A8DF(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native36f1 */
    RegisterCommand('native36f1', () => {
      _0x36F1B38855F2A8DF(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x36F1B38855F2A8DF

##### _0x4669B3ED80F24B4E (0x4669B3ED80F24B4E 0xB9FB142F)
- **Scope**: Client
- **Signature**: `void _0x4669B3ED80F24B4E(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native4669
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native4669', function()
        _0x4669B3ED80F24B4E(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native4669 */
    RegisterCommand('native4669', () => {
      _0x4669B3ED80F24B4E(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x4669B3ED80F24B4E

##### _0x5501B7A5CDB79D37 (0x5501B7A5CDB79D37)
- **Scope**: Client
- **Signature**: `void _0x5501B7A5CDB79D37(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native5501
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native5501', function()
        _0x5501B7A5CDB79D37(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native5501 */
    RegisterCommand('native5501', () => {
      _0x5501B7A5CDB79D37(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x5501B7A5CDB79D37

##### _0x55FCC0C390620314 (0x55FCC0C390620314)
- **Scope**: Client
- **Signature**: `void _0x55FCC0C390620314(Player player1, Player player2, BOOL toggle)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player1` (`player`): Unknown.
  - `player2` (`player`): Unknown.
  - `toggle` (`bool`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native55fc
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native55fc', function()
        _0x55FCC0C390620314(0, 0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native55fc */
    RegisterCommand('native55fc', () => {
      _0x55FCC0C390620314(0, 0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x55FCC0C390620314

##### _0x690A61A6D13583F6 (0x690A61A6D13583F6 0x1D371529)
- **Scope**: Client
- **Signature**: `BOOL _0x690A61A6D13583F6(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
  - **Returns**: `bool` result.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native690a
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native690a', function()
        local result = _0x690A61A6D13583F6(0)
                print(result)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native690a */
    RegisterCommand('native690a', () => {
      const result = _0x690A61A6D13583F6(0);
            console.log(result);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x690A61A6D13583F6

##### _0x6E4361FF3E8CD7CA (0x6E4361FF3E8CD7CA)
- **Scope**: Client
- **Signature**: `Any _0x6E4361FF3E8CD7CA(Any p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
  - **Returns**: `any` result.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native6e43
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native6e43', function()
        local result = _0x6E4361FF3E8CD7CA(0)
                print(result)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native6e43 */
    RegisterCommand('native6e43', () => {
      const result = _0x6E4361FF3E8CD7CA(0);
            console.log(result);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x6E4361FF3E8CD7CA

##### _0x70A382ADEC069DD3 (0x70A382ADEC069DD3)
- **Scope**: Client
- **Signature**: `void _0x70A382ADEC069DD3(float coordX, float coordY, float coordZ)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `coordX` (`float`): Unknown.
  - `coordY` (`float`): Unknown.
  - `coordZ` (`float`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native70a3
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native70a3', function()
        _0x70A382ADEC069DD3(0, 0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native70a3 */
    RegisterCommand('native70a3', () => {
      _0x70A382ADEC069DD3(0, 0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x70A382ADEC069DD3

##### _0x7148E0F43D11F0D9 (0x7148E0F43D11F0D9)
- **Scope**: Client
- **Signature**: `void _0x7148E0F43D11F0D9()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native7148
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native7148', function()
        _0x7148E0F43D11F0D9()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native7148 */
    RegisterCommand('native7148', () => {
      _0x7148E0F43D11F0D9();
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x7148E0F43D11F0D9

##### _0x7BAE68775557AE0B (0x7BAE68775557AE0B)
- **Scope**: Client
- **Signature**: `void _0x7BAE68775557AE0B(Any p0, Any p1, Any p2, Any p3, Any p4, Any p5)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
  - `p1` (`any`): Unknown.
  - `p2` (`any`): Unknown.
  - `p3` (`any`): Unknown.
  - `p4` (`any`): Unknown.
  - `p5` (`any`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native7bae
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native7bae', function()
        _0x7BAE68775557AE0B(0, 0, 0, 0, 0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native7bae */
    RegisterCommand('native7bae', () => {
      _0x7BAE68775557AE0B(0, 0, 0, 0, 0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x7BAE68775557AE0B

##### _0x7E07C78925D5FD96 (0x7E07C78925D5FD96)
- **Scope**: Client
- **Signature**: `Any _0x7E07C78925D5FD96(Any p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
  - **Returns**: `any` result.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native7e07
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native7e07', function()
        local result = _0x7E07C78925D5FD96(0)
                print(result)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native7e07 */
    RegisterCommand('native7e07', () => {
      const result = _0x7E07C78925D5FD96(0);
            console.log(result);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x7E07C78925D5FD96

##### _0x823EC8E82BA45986 (0x823EC8E82BA45986)
- **Scope**: Client
- **Signature**: `void _0x823EC8E82BA45986(Any p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native823e
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native823e', function()
        _0x823EC8E82BA45986(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native823e */
    RegisterCommand('native823e', () => {
      _0x823EC8E82BA45986(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x823EC8E82BA45986

##### _0x8D768602ADEF2245 (0x8D768602ADEF2245)
- **Scope**: Client
- **Signature**: `void _0x8D768602ADEF2245(Player player, float p1)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
  - `p1` (`float`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native8d76
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native8d76', function()
        _0x8D768602ADEF2245(0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native8d76 */
    RegisterCommand('native8d76', () => {
      _0x8D768602ADEF2245(0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x8D768602ADEF2245

##### _0x9097EB6D4BB9A12A (0x9097EB6D4BB9A12A)
- **Scope**: Client
- **Signature**: `void _0x9097EB6D4BB9A12A(Player player, Entity entity)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
  - `entity` (`entity`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native9097
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native9097', function()
        _0x9097EB6D4BB9A12A(0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native9097 */
    RegisterCommand('native9097', () => {
      _0x9097EB6D4BB9A12A(0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x9097EB6D4BB9A12A

##### _0x9EDD76E87D5D51BA (0x9EDD76E87D5D51BA 0xE30A64DC)
- **Scope**: Client
- **Signature**: `void _0x9EDD76E87D5D51BA(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native9edd
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native9edd', function()
        _0x9EDD76E87D5D51BA(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native9edd */
    RegisterCommand('native9edd', () => {
      _0x9EDD76E87D5D51BA(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x9EDD76E87D5D51BA

##### _0x9F260BFB59ADBCA3 (0x9F260BFB59ADBCA3)
- **Scope**: Client
- **Signature**: `void _0x9F260BFB59ADBCA3(Player player, Entity entity)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
  - `entity` (`entity`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: native9f26
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('native9f26', function()
        _0x9F260BFB59ADBCA3(0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: native9f26 */
    RegisterCommand('native9f26', () => {
      _0x9F260BFB59ADBCA3(0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0x9F260BFB59ADBCA3

##### _0xAD73CE5A09E42D12 (0xAD73CE5A09E42D12 0x85725848)
- **Scope**: Client
- **Signature**: `void _0xAD73CE5A09E42D12(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativead73
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativead73', function()
        _0xAD73CE5A09E42D12(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativead73 */
    RegisterCommand('nativead73', () => {
      _0xAD73CE5A09E42D12(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xAD73CE5A09E42D12

##### _0xB45EFF719D8427A6 (0xB45EFF719D8427A6 0xBF6993C7)
- **Scope**: Client
- **Signature**: `void _0xB45EFF719D8427A6(float p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`float`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeb45e
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeb45e', function()
        _0xB45EFF719D8427A6(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeb45e */
    RegisterCommand('nativeb45e', () => {
      _0xB45EFF719D8427A6(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xB45EFF719D8427A6

##### _0xB885852C39CC265D (0xB885852C39CC265D 0x47D6004E)
- **Scope**: Client
- **Signature**: `void _0xB885852C39CC265D()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeb885
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeb885', function()
        _0xB885852C39CC265D()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeb885 */
    RegisterCommand('nativeb885', () => {
      _0xB885852C39CC265D();
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xB885852C39CC265D

##### _0xB9CF1F793A9F1BF1 (0xB9CF1F793A9F1BF1)
- **Scope**: Client
- **Signature**: `BOOL _0xB9CF1F793A9F1BF1()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: `bool` result.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeb9cf
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeb9cf', function()
        local result = _0xB9CF1F793A9F1BF1()
                print(result)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeb9cf */
    RegisterCommand('nativeb9cf', () => {
      const result = _0xB9CF1F793A9F1BF1();
            console.log(result);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xB9CF1F793A9F1BF1

##### _0xBC9490CA15AEA8FB (0xBC9490CA15AEA8FB 0x6B34A160)
- **Scope**: Client
- **Signature**: `void _0xBC9490CA15AEA8FB(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativebc94
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativebc94', function()
        _0xBC9490CA15AEA8FB(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativebc94 */
    RegisterCommand('nativebc94', () => {
      _0xBC9490CA15AEA8FB(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xBC9490CA15AEA8FB

##### _0xC3376F42B1FACCC6 (0xC3376F42B1FACCC6 0x02DF7AF4)
- **Scope**: Client
- **Signature**: `void _0xC3376F42B1FACCC6(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativec337
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativec337', function()
        _0xC3376F42B1FACCC6(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativec337 */
    RegisterCommand('nativec337', () => {
      _0xC3376F42B1FACCC6(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xC3376F42B1FACCC6

##### _0xCAC57395B151135F (0xCAC57395B151135F 0x00563E0D)
- **Scope**: Client
- **Signature**: `void _0xCAC57395B151135F(Player player, BOOL p1)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`player`): Unknown.
  - `p1` (`bool`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativecac5
        -- Use: Demonstrates calling the native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativecac5', function()
        _0xCAC57395B151135F(0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativecac5 */
    RegisterCommand('nativecac5', () => {
      _0xCAC57395B151135F(0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xCAC57395B151135F


##### _0xCB645E85E97EA48B (0xCB645E85E97EA48B)
- **Scope**: Client
- **Signature**: `BOOL _0xCB645E85E97EA48B()`
- **Purpose**: Returns profile setting 243.
- **Parameters / Returns**:
  - **Returns**: `bool` profile flag 243.
- **OneSync / Networking**: Local only; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: prof243
        -- Use: Prints profile setting 243 flag
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('prof243', function()
        print(_0xCB645E85E97EA48B())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: prof243 */
    RegisterCommand('prof243', () => {
      console.log(global._0xCB645E85E97EA48B());
    });
    ```
- **Caveats / Limitations**:
  - Internal profile flag; not documented.
- **Reference**: https://docs.fivem.net/natives/?n=_0xCB645E85E97EA48B

##### _0xD821056B9ACF8052 (0xD821056B9ACF8052)
- **Scope**: Client
- **Signature**: `void _0xD821056B9ACF8052(Player player, Any p1)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`any`): Unknown.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeD821
        -- Use: Calls the undocumented native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeD821', function()
        _0xD821056B9ACF8052(PlayerId(), 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeD821 */
    RegisterCommand('nativeD821', () => {
      global._0xD821056B9ACF8052(PlayerId(), 0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xD821056B9ACF8052

##### _0xDCC07526B8EC45AF (0xDCC07526B8EC45AF)
- **Scope**: Client
- **Signature**: `BOOL _0xDCC07526B8EC45AF(Player player)`
- **Purpose**: Always returns false.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: `bool` always `false`.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeDCC0
        -- Use: Tests always-false native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeDCC0', function()
        print(_0xDCC07526B8EC45AF(PlayerId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeDCC0 */
    RegisterCommand('nativeDCC0', () => {
      console.log(_0xDCC07526B8EC45AF(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Returns false regardless of inputs.
- **Reference**: https://docs.fivem.net/natives/?n=_0xDCC07526B8EC45AF

##### _0xDD2620B7B9D16FF1 (0xDD2620B7B9D16FF1)
- **Scope**: Client
- **Signature**: `BOOL _0xDD2620B7B9D16FF1(Player player, float p1)`
- **Purpose**: Undocumented; seen in `agency_heist3a` with p1 around 0.4–0.7.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`float`): Unknown.
  - **Returns**: `bool` result of native.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeDD26
        -- Use: Calls the undocumented native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeDD26', function()
        print(_0xDD2620B7B9D16FF1(PlayerId(), 0.5))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeDD26 */
    RegisterCommand('nativeDD26', () => {
      console.log(_0xDD2620B7B9D16FF1(PlayerId(), 0.5));
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xDD2620B7B9D16FF1

##### _0xDE45D1A1EF45EE61 (0xDE45D1A1EF45EE61)
- **Scope**: Client
- **Signature**: `void _0xDE45D1A1EF45EE61(Player player, BOOL toggle)`
- **Purpose**: Undocumented; alias `SET_HUD_ANIM_STOP_LEVEL` suggests HUD animation control.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Unknown effect.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeDE45
        -- Use: Calls the undocumented native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeDE45', function()
        _0xDE45D1A1EF45EE61(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeDE45 */
    RegisterCommand('nativeDE45', () => {
      _0xDE45D1A1EF45EE61(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xDE45D1A1EF45EE61

##### _0xFAC75988A7D078D3 (0xFAC75988A7D078D3)
- **Scope**: Client
- **Signature**: `void _0xFAC75988A7D078D3(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeFAC7
        -- Use: Calls the undocumented native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeFAC7', function()
        _0xFAC75988A7D078D3(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeFAC7 */
    RegisterCommand('nativeFAC7', () => {
      _0xFAC75988A7D078D3(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xFAC75988A7D078D3

##### _0xFFEE8FA29AB9A18E (0xFFEE8FA29AB9A18E)
- **Scope**: Client
- **Signature**: `void _0xFFEE8FA29AB9A18E(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
- **OneSync / Networking**: Unknown replication behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nativeFFEE
        -- Use: Calls the undocumented native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nativeFFEE', function()
        _0xFFEE8FA29AB9A18E(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nativeFFEE */
    RegisterCommand('nativeFFEE', () => {
      _0xFFEE8FA29AB9A18E(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - NativeDB notes an additional undocumented parameter.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=_0xFFEE8FA29AB9A18E

##### NetworkPlayerIdToInt (hash unknown)
- **Scope**: Client
- **Signature**: `int NETWORK_PLAYER_ID_TO_INT()`
- **Purpose**: Alias of `PLAYER_ID`, returns the local player's network index.
- **Parameters / Returns**:
  - **Returns**: `int` player index.
- **OneSync / Networking**: Local only; use `source` on server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nidtoint
        -- Use: Prints player index
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nidtoint', function()
        print(NetworkPlayerIdToInt())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nidtoint */
    RegisterCommand('nidtoint', () => {
      console.log(NetworkPlayerIdToInt());
    });
    ```
- **Caveats / Limitations**:
  - Equivalent to `PlayerId()`.
- **Reference**: https://docs.fivem.net/natives/?n=NetworkPlayerIdToInt

##### PlayerAttachVirtualBound (0xED51733DC73AED51)
- **Scope**: Client
- **Signature**: `void PLAYER_ATTACH_VIRTUAL_BOUND(float p0, float p1, float p2, float p3, float p4, float p5, float p6, float p7)`
- **Purpose**: Attach a virtual boundary to the player; used in `ob_sofa_michael`.
- **Parameters / Returns**:
  - `p0`–`p7` (`float`): Boundary parameters, semantics unknown.
- **OneSync / Networking**: Local visualization; not synced.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: attachvbound
        -- Use: Attaches a virtual bound with default values
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('attachvbound', function()
        PlayerAttachVirtualBound(0.0,0.0,0.0,0.0,0.0,0.5,1.0,0.7)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: attachvbound */
    RegisterCommand('attachvbound', () => {
      PlayerAttachVirtualBound(0.0,0.0,0.0,0.0,0.0,0.5,1.0,0.7);
    });
    ```
- **Caveats / Limitations**:
  - Parameters are poorly documented.
- **Reference**: https://docs.fivem.net/natives/?n=PlayerAttachVirtualBound

##### PlayerDetachVirtualBound (0x1DD5897E2FA6E7C9)
- **Scope**: Client
- **Signature**: `void PLAYER_DETACH_VIRTUAL_BOUND()`
- **Purpose**: Remove a virtual boundary previously attached to the player.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Local visualization; not synced.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: detachvbound
        -- Use: Detaches virtual bound
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('detachvbound', function()
        PlayerDetachVirtualBound()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: detachvbound */
    RegisterCommand('detachvbound', () => {
      PlayerDetachVirtualBound();
    });
    ```
- **Caveats / Limitations**:
  - Used with `PlayerAttachVirtualBound`.
- **Reference**: https://docs.fivem.net/natives/?n=PlayerDetachVirtualBound

##### PlayerId (0x4F8644AF03D0E0D6)
- **Scope**: Client
- **Signature**: `Player PLAYER_ID()`
- **Purpose**: Get the local player's index.
- **Parameters / Returns**:
  - **Returns**: `Player` index of local player.
- **OneSync / Networking**: Local only; server scripts should use the `source` parameter.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: pid
        -- Use: Prints local player index
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('pid', function()
        print(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: pid */
    RegisterCommand('pid', () => {
      console.log(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Not available on server.
- **Reference**: https://docs.fivem.net/natives/?n=PlayerId

##### PlayerPedId (0xD80958FC74E988A6)
- **Scope**: Client
- **Signature**: `Ped PLAYER_PED_ID()`
- **Purpose**: Get the entity handle of the local player's ped.
- **Parameters / Returns**:
  - **Returns**: `Ped` handle for local player.
- **OneSync / Networking**: Local entity handle; use `GetPlayerPed` for other players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: ppid
        -- Use: Prints local ped handle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('ppid', function()
        print(PlayerPedId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: ppid */
    RegisterCommand('ppid', () => {
      console.log(PlayerPedId());
    });
    ```
- **Caveats / Limitations**:
  - Handle changes if model changes.
- **Reference**: https://docs.fivem.net/natives/?n=PlayerPedId

##### RemovePlayerHelmet (0xF3AC26D3CC576528)
- **Scope**: Client
- **Signature**: `void REMOVE_PLAYER_HELMET(Player player, BOOL p2)`
- **Purpose**: Force a player to remove their helmet.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p2` (`bool`): Unknown toggle.
- **OneSync / Networking**: Affects local player model; ownership required for remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: removehelm
        -- Use: Removes player's helmet
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('removehelm', function()
        RemovePlayerHelmet(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: removehelm */
    RegisterCommand('removehelm', () => {
      RemovePlayerHelmet(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Second parameter usage unknown.
- **Reference**: https://docs.fivem.net/natives/?n=RemovePlayerHelmet

##### ReportCrime (0xE9B09589827545E7)
- **Scope**: Client
- **Signature**: `void REPORT_CRIME(Player player, int crimeType, int wantedLvlThresh)`
- **Purpose**: Report a crime for a player, potentially increasing wanted level.
- **Parameters / Returns**:
  - `player` (`Player`): Player to report.
  - `crimeType` (`int`): Crime ID.
  - `wantedLvlThresh` (`int`): Wanted level threshold.
- **OneSync / Networking**: Server-side authority should validate usage.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reportcrime
        -- Use: Reports a sample crime
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reportcrime', function()
        ReportCrime(PlayerId(), 7, GetWantedLevelThreshold(1))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reportcrime */
    RegisterCommand('reportcrime', () => {
      ReportCrime(PlayerId(), 7, GetWantedLevelThreshold(1));
    });
    ```
- **Caveats / Limitations**:
  - Crime and threshold IDs must match game logic.
- **Reference**: https://docs.fivem.net/natives/?n=ReportCrime

##### ReportPoliceSpottedPlayer (0xDC64D2C53493ED12)
- **Scope**: Client
- **Signature**: `void REPORT_POLICE_SPOTTED_PLAYER(Player player)`
- **Purpose**: Inform the game that police have spotted the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player spotted.
- **OneSync / Networking**: Server validation recommended before flagging.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: policespot
        -- Use: Flags player as spotted by police
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('policespot', function()
        ReportPoliceSpottedPlayer(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: policespot */
    RegisterCommand('policespot', () => {
      ReportPoliceSpottedPlayer(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Undocumented crime escalation behavior.
- **Reference**: https://docs.fivem.net/natives/?n=ReportPoliceSpottedPlayer

##### ResetPlayerArrestState (0x2D03E13C460760D6)
- **Scope**: Client
- **Signature**: `void RESET_PLAYER_ARREST_STATE(Player player);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reset_arrest
        -- Use: Calls ResetPlayerArrestState
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reset_arrest', function()
        ResetPlayerArrestState(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reset_arrest */
    RegisterCommand('reset_arrest', () => {
      ResetPlayerArrestState(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=ResetPlayerArrestState

##### ResetPlayerInputGait (0x19531C47A2ABD691)
- **Scope**: Client
- **Signature**: `void RESET_PLAYER_INPUT_GAIT(Player player);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reset_input_
        -- Use: Calls ResetPlayerInputGait
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reset_input_', function()
        ResetPlayerInputGait(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reset_input_ */
    RegisterCommand('reset_input_', () => {
      ResetPlayerInputGait(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=ResetPlayerInputGait

##### ResetPlayerStamina (0xA6F312FCCE9C1DFE)
- **Scope**: Client
- **Signature**: `void RESET_PLAYER_STAMINA(Player player);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reset_stamin
        -- Use: Calls ResetPlayerStamina
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reset_stamin', function()
        ResetPlayerStamina(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reset_stamin */
    RegisterCommand('reset_stamin', () => {
      ResetPlayerStamina(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=ResetPlayerStamina

##### ResetWantedLevelDifficulty (0xB9D0DD990DC141DD)
- **Scope**: Client
- **Signature**: `void RESET_WANTED_LEVEL_DIFFICULTY(Player player);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reset_wanted
        -- Use: Calls ResetWantedLevelDifficulty
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reset_wanted', function()
        ResetWantedLevelDifficulty(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reset_wanted */
    RegisterCommand('reset_wanted', () => {
      ResetWantedLevelDifficulty(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=ResetWantedLevelDifficulty

##### ResetWorldBoundaryForPlayer (0xDA1DF03D5A315F4E)
- **Scope**: Client
- **Signature**: `void RESET_WORLD_BOUNDARY_FOR_PLAYER();`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - None.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reset_world_
        -- Use: Calls ResetWorldBoundaryForPlayer
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reset_world_', function()
        ResetWorldBoundaryForPlayer()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reset_world_ */
    RegisterCommand('reset_world_', () => {
      ResetWorldBoundaryForPlayer();
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=ResetWorldBoundaryForPlayer

##### RestorePlayerStamina (0xA352C1B864CAFD33)
- **Scope**: Client
- **Signature**: `void RESTORE_PLAYER_STAMINA(Player player, float percentage);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `percentage` (`float`): Stamina percentage.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: restore_stam
        -- Use: Calls RestorePlayerStamina
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('restore_stam', function()
        RestorePlayerStamina(PlayerId(),0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: restore_stam */
    RegisterCommand('restore_stam', () => {
      RestorePlayerStamina(PlayerId(),0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=RestorePlayerStamina

##### SetAchievementProgress (0xC2AFFFDABBDC2C5C)
- **Scope**: Client
- **Signature**: `BOOL _SET_ACHIEVEMENT_PROGRESS(int achievement, int progress);`
- **Purpose**: For Steam. Does nothing and always returns false in the retail version of the game.
- **Parameters / Returns**:
  - `achievement` (`int`): Achievement ID.
  - `progress` (`int`): Progress value.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_achievem
        -- Use: Calls SetAchievementProgress
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_achievem', function()
        SetAchievementProgress(0,0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_achievem */
    RegisterCommand('set_achievem', () => {
      SetAchievementProgress(0,0);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetAchievementProgress

##### SetAirDragMultiplierForPlayersVehicle (0xCA7DC8329F0A1E9E)
- **Scope**: Client
- **Signature**: `void SET_AIR_DRAG_MULTIPLIER_FOR_PLAYERS_VEHICLE(Player player, float multiplier);`
- **Purpose**: ``` This can be between 1.0f - 14.9f You can change the max in IDA from 15.0. I say 15.0 as the function blrs if what you input is greater than or equal to 15.0 hence why it's 14.9 max default. On PC the multiplier can be between 0.0f and 50.0f (inclusive). ```
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `multiplier` (`float`): Drag multiplier.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_air_drag
        -- Use: Calls SetAirDragMultiplierForPlayersVehicle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_air_drag', function()
        SetAirDragMultiplierForPlayersVehicle(PlayerId(),0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_air_drag */
    RegisterCommand('set_air_drag', () => {
      SetAirDragMultiplierForPlayersVehicle(PlayerId(),0);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetAirDragMultiplierForPlayersVehicle

##### SetAllRandomPedsFlee (0x056E0FE8534C2949)
- **Scope**: Client
- **Signature**: `void SET_ALL_RANDOM_PEDS_FLEE(Player player, BOOL toggle);`
- **Purpose**: Sets whether all random peds will run away from the player if they are agitated (threatened) (bool=true), or if they will stand their ground (bool=false).
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_all_rand
        -- Use: Calls SetAllRandomPedsFlee
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_all_rand', function()
        SetAllRandomPedsFlee(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_all_rand */
    RegisterCommand('set_all_rand', () => {
      SetAllRandomPedsFlee(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetAllRandomPedsFlee

##### SetAllRandomPedsFleeThisFrame (0x471D2FF42A94B4F2)
- **Scope**: Client
- **Signature**: `void SET_ALL_RANDOM_PEDS_FLEE_THIS_FRAME(Player player);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_all_rand
        -- Use: Calls SetAllRandomPedsFleeThisFrame
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_all_rand', function()
        SetAllRandomPedsFleeThisFrame(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_all_rand */
    RegisterCommand('set_all_rand', () => {
      SetAllRandomPedsFleeThisFrame(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetAllRandomPedsFleeThisFrame

##### SetAutoGiveParachuteWhenEnterPlane (0x9F343285A00B4BB6)
- **Scope**: Client
- **Signature**: `void SET_AUTO_GIVE_PARACHUTE_WHEN_ENTER_PLANE(Player player, BOOL toggle);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_auto_giv
        -- Use: Calls SetAutoGiveParachuteWhenEnterPlane
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_auto_giv', function()
        SetAutoGiveParachuteWhenEnterPlane(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_auto_giv */
    RegisterCommand('set_auto_giv', () => {
      SetAutoGiveParachuteWhenEnterPlane(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetAutoGiveParachuteWhenEnterPlane

##### SetAutoGiveScubaGearWhenExitVehicle (0xD2B315B6689D537D)
- **Scope**: Client
- **Signature**: `void SET_AUTO_GIVE_SCUBA_GEAR_WHEN_EXIT_VEHICLE(Player player, BOOL toggle);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_auto_giv
        -- Use: Calls SetAutoGiveScubaGearWhenExitVehicle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_auto_giv', function()
        SetAutoGiveScubaGearWhenExitVehicle(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_auto_giv */
    RegisterCommand('set_auto_giv', () => {
      SetAutoGiveScubaGearWhenExitVehicle(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetAutoGiveScubaGearWhenExitVehicle

##### SetDisableAmbientMeleeMove (0x2E8AABFA40A84F8C)
- **Scope**: Client
- **Signature**: `void SET_DISABLE_AMBIENT_MELEE_MOVE(Player player, BOOL toggle);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_disable_
        -- Use: Calls SetDisableAmbientMeleeMove
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_disable_', function()
        SetDisableAmbientMeleeMove(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_disable_ */
    RegisterCommand('set_disable_', () => {
      SetDisableAmbientMeleeMove(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetDisableAmbientMeleeMove

##### SetDispatchCopsForPlayer (0xDB172424876553F4)
- **Scope**: Client
- **Signature**: `void SET_DISPATCH_COPS_FOR_PLAYER(Player player, BOOL toggle);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_dispatch
        -- Use: Calls SetDispatchCopsForPlayer
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_dispatch', function()
        SetDispatchCopsForPlayer(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_dispatch */
    RegisterCommand('set_dispatch', () => {
      SetDispatchCopsForPlayer(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetDispatchCopsForPlayer

##### SetEveryoneIgnorePlayer (0x8EEDA153AD141BA4)
- **Scope**: Client
- **Signature**: `void SET_EVERYONE_IGNORE_PLAYER(Player player, BOOL toggle);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_everyone
        -- Use: Calls SetEveryoneIgnorePlayer
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_everyone', function()
        SetEveryoneIgnorePlayer(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_everyone */
    RegisterCommand('set_everyone', () => {
      SetEveryoneIgnorePlayer(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetEveryoneIgnorePlayer

##### SetIgnoreLowPriorityShockingEvents (0x596976B02B6B5700)
- **Scope**: Client
- **Signature**: `void SET_IGNORE_LOW_PRIORITY_SHOCKING_EVENTS(Player player, BOOL toggle);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_ignore_l
        -- Use: Calls SetIgnoreLowPriorityShockingEvents
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_ignore_l', function()
        SetIgnoreLowPriorityShockingEvents(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_ignore_l */
    RegisterCommand('set_ignore_l', () => {
      SetIgnoreLowPriorityShockingEvents(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetIgnoreLowPriorityShockingEvents

##### SetMaxWantedLevel (0xAA5F02DB48D704B9)
- **Scope**: Client
- **Signature**: `void SET_MAX_WANTED_LEVEL(int maxWantedLevel);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `maxWantedLevel` (`int`): Maximum wanted level.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_max_want
        -- Use: Calls SetMaxWantedLevel
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_max_want', function()
        SetMaxWantedLevel(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_max_want */
    RegisterCommand('set_max_want', () => {
      SetMaxWantedLevel(0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetMaxWantedLevel

##### SetPlayerBluetoothState (0x5DC40A8869C22141)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_BLUETOOTH_STATE( Player player, BOOL state);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `state` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_bluetoot
        -- Use: Calls SetPlayerBluetoothState
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_bluetoot', function()
        SetPlayerBluetoothState(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_bluetoot */
    RegisterCommand('set_bluetoot', () => {
      SetPlayerBluetoothState(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerBluetoothState

##### SetPlayerCanBeHassledByGangs (0xD5E460AD7020A246)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CAN_BE_HASSLED_BY_GANGS(Player player, BOOL toggle);`
- **Purpose**: ``` Sets whether this player can be hassled by gangs. ```
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_can_be_h
        -- Use: Calls SetPlayerCanBeHassledByGangs
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_can_be_h', function()
        SetPlayerCanBeHassledByGangs(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_can_be_h */
    RegisterCommand('set_can_be_h', () => {
      SetPlayerCanBeHassledByGangs(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerCanBeHassledByGangs

##### SetPlayerCanDoDriveBy (0x6E8834B52EC20C77)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CAN_DO_DRIVE_BY(Player player, BOOL toggle);`
- **Purpose**: Sets whether the player is able to do drive-bys in vehicle (shooting & aiming in vehicles), this also includes middle finger taunts. This is a toggle, it does not have to be ran every frame.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_can_do_d
        -- Use: Calls SetPlayerCanDoDriveBy
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_can_do_d', function()
        SetPlayerCanDoDriveBy(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_can_do_d */
    RegisterCommand('set_can_do_d', () => {
      SetPlayerCanDoDriveBy(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerCanDoDriveBy

##### SetPlayerCanLeaveParachuteSmokeTrail (0xF401B182DBA8AF53)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CAN_LEAVE_PARACHUTE_SMOKE_TRAIL(Player player, BOOL enabled);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `enabled` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_can_leav
        -- Use: Calls SetPlayerCanLeaveParachuteSmokeTrail
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_can_leav', function()
        SetPlayerCanLeaveParachuteSmokeTrail(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_can_leav */
    RegisterCommand('set_can_leav', () => {
      SetPlayerCanLeaveParachuteSmokeTrail(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerCanLeaveParachuteSmokeTrail

##### SetPlayerCanUseCover (0xD465A8599DFF6814)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CAN_USE_COVER(Player player, BOOL toggle);`
- **Purpose**: ``` Sets whether this player can take cover. ```
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_can_use_
        -- Use: Calls SetPlayerCanUseCover
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_can_use_', function()
        SetPlayerCanUseCover(PlayerId(),true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_can_use_ */
    RegisterCommand('set_can_use_', () => {
      SetPlayerCanUseCover(PlayerId(),true);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerCanUseCover

##### SetPlayerClothLockCounter (0x14D913B777DFF5DA)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CLOTH_LOCK_COUNTER(int value);`
- **Purpose**: ``` 6 matches across 4 scripts. 5 occurrences were 240. The other was 255. ```
- **Parameters / Returns**:
  - `value` (`int`): Counter value.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_cloth_lo
        -- Use: Calls SetPlayerClothLockCounter
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_cloth_lo', function()
        SetPlayerClothLockCounter(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_cloth_lo */
    RegisterCommand('set_cloth_lo', () => {
      SetPlayerClothLockCounter(0);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerClothLockCounter

##### SetPlayerClothPackageIndex (0x9F7BBA2EA6372500)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CLOTH_PACKAGE_INDEX(int index);`
- **Purpose**: ``` Every occurrence was either 0 or 2. ```
- **Parameters / Returns**:
  - `index` (`int`): Package index.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_cloth_pa
        -- Use: Calls SetPlayerClothPackageIndex
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_cloth_pa', function()
        SetPlayerClothPackageIndex(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_cloth_pa */
    RegisterCommand('set_cloth_pa', () => {
      SetPlayerClothPackageIndex(0);
    });
    ```
- **Caveats / Limitations**:
  - No additional notes.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerClothPackageIndex

##### SetPlayerClothPinFrames (0x749FADDF97DFE930)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CLOTH_PIN_FRAMES(Player player, int p1);`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`int`): Unknown.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize when affecting remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_cloth_pi
        -- Use: Calls SetPlayerClothPinFrames
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_cloth_pi', function()
        SetPlayerClothPinFrames(PlayerId(),0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_cloth_pi */
    RegisterCommand('set_cloth_pi', () => {
      SetPlayerClothPinFrames(PlayerId(),0);
    });
    ```
- **Caveats / Limitations**:
  - Not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerClothPinFrames


##### SetPlayerControl (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_CONTROL(Player player, BOOL hasControl, int flags)`
- **Purpose**: Enable or disable input for a player with optional flag effects.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `hasControl` (`bool`): True grants control; false freezes the player.
  - `flags` (`int`): Optional behavior bits.
- **OneSync / Networking**: Only affects entities owned by the caller; remote players require server-side authority.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: freeze
        -- Use: Disables local player control
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('freeze', function()
        SetPlayerControl(PlayerId(), false, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: freeze */
    RegisterCommand('freeze', () => {
      SetPlayerControl(PlayerId(), false, 0);
    });
    ```
- **Caveats / Limitations**:
  - Flags influence leaving vehicles and other behaviors.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerControl

##### SetPlayerFallDistance (0xEFD79FA81DFBA9CB)
- **Scope**: Client
- **Signature**: `void _SET_PLAYER_FALL_DISTANCE(Player player, float distance)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `distance` (`float`): Unknown threshold.
- **OneSync / Networking**: Local effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: set_fall_distance
        -- Use: Calls SetPlayerFallDistance
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('set_fall_distance', function()
        SetPlayerFallDistance(PlayerId(), 10.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: set_fall_distance */
    RegisterCommand('set_fall_distance', () => {
      SetPlayerFallDistance(PlayerId(), 10.0);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerFallDistance

##### SetPlayerForceSkipAimIntro (0x7651BC64AE59E128 / 0x374F42F0)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_FORCE_SKIP_AIM_INTRO(Player player, BOOL toggle)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable to skip aim intro.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: skip_aim_intro
        -- Use: Calls SetPlayerForceSkipAimIntro
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('skip_aim_intro', function()
        SetPlayerForceSkipAimIntro(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: skip_aim_intro */
    RegisterCommand('skip_aim_intro', () => {
      SetPlayerForceSkipAimIntro(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerForceSkipAimIntro

##### SetPlayerForcedAim (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_FORCED_AIM(Player player, BOOL toggle)`
- **Purpose**: Force the player into aiming mode.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `toggle` (`bool`): Enable or disable forced aim.
- **OneSync / Networking**: Local effect; use client events for remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: forceaim
        -- Use: Forces player to aim
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('forceaim', function()
        SetPlayerForcedAim(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: forceaim */
    RegisterCommand('forceaim', () => {
      SetPlayerForcedAim(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Player remains aimed until toggled off.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerForcedAim

##### SetPlayerForcedZoom (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_FORCED_ZOOM(Player player, BOOL toggle)`
- **Purpose**: Force the player's view to zoom in.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `toggle` (`bool`): Enable or disable forced zoom.
- **OneSync / Networking**: Local effect; use client events for remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: forcezoom
        -- Use: Forces zoomed view
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('forcezoom', function()
        SetPlayerForcedZoom(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: forcezoom */
    RegisterCommand('forcezoom', () => {
      SetPlayerForcedZoom(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Stay zoomed until disabled.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerForcedZoom

##### SetPlayerHasReserveParachute (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_HAS_RESERVE_PARACHUTE(Player player)`
- **Purpose**: Give the player a reserve parachute pack.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
- **OneSync / Networking**: Only affects the caller's player; server should validate before granting.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reservepara
        -- Use: Grants reserve parachute
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reservepara', function()
        SetPlayerHasReserveParachute(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reservepara */
    RegisterCommand('reservepara', () => {
      SetPlayerHasReserveParachute(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Parachute availability still depends on main pack.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerHasReserveParachute

##### SetPlayerHealthRechargeLimit (0xC388A0F065F5BC34)
- **Scope**: Client
- **Signature**: `void _SET_PLAYER_HEALTH_RECHARGE_LIMIT(Player player, float limit)`
- **Purpose**: Sets the fraction of max health that can auto-regenerate.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `limit` (`float`): 0.0–1.0, default 0.5.
- **OneSync / Networking**: Local effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hp_limit
        -- Use: Calls SetPlayerHealthRechargeLimit
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('hp_limit', function()
        SetPlayerHealthRechargeLimit(PlayerId(), 0.3)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hp_limit */
    RegisterCommand('hp_limit', () => {
      SetPlayerHealthRechargeLimit(PlayerId(), 0.3);
    });
    ```
- **Caveats / Limitations**:
  - Values outside 0.0–1.0 are clamped.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerHealthRechargeLimit

##### SetPlayerHealthRechargeMultiplier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(Player player, float regenRate)`
- **Purpose**: Adjust the rate at which the player's health regenerates.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `regenRate` (`float`): Multiplier where `1.0` is normal and `0.0` disables regen.
- **OneSync / Networking**: Local change; server should validate for remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: regen
        -- Use: Disables health regeneration
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('regen', function()
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: regen */
    RegisterCommand('regen', () => {
      SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0);
    });
    ```
- **Caveats / Limitations**:
  - Does not affect damage taken.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerHealthRechargeMultiplier
 
##### SetPlayerHomingRocketDisabled (0xEE4EBDD2593BA844)
- **Scope**: Client
- **Signature**: `void _SET_PLAYER_HOMING_ROCKET_DISABLED(Player player, BOOL disabled)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `disabled` (`bool`): Toggle homing lock.
- **OneSync / Networking**: Local effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: disable_homing
        -- Use: Calls SetPlayerHomingRocketDisabled
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('disable_homing', function()
        SetPlayerHomingRocketDisabled(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: disable_homing */
    RegisterCommand('disable_homing', () => {
      SetPlayerHomingRocketDisabled(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerHomingRocketDisabled

##### SetPlayerInvincible (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_INVINCIBLE(Player player, BOOL toggle)`
- **Purpose**: Toggle invincibility for the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `toggle` (`bool`): True enables god mode.
- **OneSync / Networking**: Only affects local player; remote players require server checks.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: god
        -- Use: Makes player invincible
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('god', function()
        SetPlayerInvincible(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: god */
    RegisterCommand('god', () => {
      SetPlayerInvincible(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Does not protect against all scripted events.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerInvincible

##### SetPlayerInvincibleKeepRagdollEnabled (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_INVINCIBLE_KEEP_RAGDOLL_ENABLED(Player player, BOOL toggle)`
- **Purpose**: Make player invincible but still able to ragdoll.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `toggle` (`bool`): True enables invincibility while allowing ragdoll.
- **OneSync / Networking**: Local effect; remote players must be handled by server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: godrag
        -- Use: Invincible but can ragdoll
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('godrag', function()
        SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: godrag */
    RegisterCommand('godrag', () => {
      SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Disable with same call using `false`.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerInvincibleKeepRagdollEnabled

##### SetPlayerLeavePedBehind (0xFF300C7649724A0B / 0xAD8383FA)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_LEAVE_PED_BEHIND(Player player, BOOL toggle)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable leaving ped behind when entering vehicles.
- **OneSync / Networking**: Local effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: leave_ped
        -- Use: Calls SetPlayerLeavePedBehind
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('leave_ped', function()
        SetPlayerLeavePedBehind(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: leave_ped */
    RegisterCommand('leave_ped', () => {
      SetPlayerLeavePedBehind(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerLeavePedBehind

##### SetPlayerLockon (0x5C8B2F450EE4328E / 0x0B270E0F)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_LOCKON(Player player, BOOL toggle)`
- **Purpose**: Toggle aim lock-on for the player.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): False prevents lock-on.
- **OneSync / Networking**: Local preference.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lockon_toggle
        -- Use: Calls SetPlayerLockon
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('lockon_toggle', function()
        SetPlayerLockon(PlayerId(), false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lockon_toggle */
    RegisterCommand('lockon_toggle', () => {
      SetPlayerLockon(PlayerId(), false);
    });
    ```
- **Caveats / Limitations**:
  - Affects only local targeting behavior.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerLockon

##### SetPlayerLockonRangeOverride (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_LOCKON_RANGE_OVERRIDE(Player player, float range)`
- **Purpose**: Override auto-aim lock-on distance.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `range` (`float`): Lock-on range in meters.
- **OneSync / Networking**: Local change; server should validate.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lockon
        -- Use: Reduces lock-on distance
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('lockon', function()
        SetPlayerLockonRangeOverride(PlayerId(), 5.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lockon */
    RegisterCommand('lockon', () => {
      SetPlayerLockonRangeOverride(PlayerId(), 5.0);
    });
    ```
- **Caveats / Limitations**:
  - Only affects targeting; does not remove lock-on.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerLockonRangeOverride

##### SetPlayerMayNotEnterAnyVehicle (0x1DE37BBF9E9CC14A / 0xAF7AFCC4)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_MAY_NOT_ENTER_ANY_VEHICLE(Player player)`
- **Purpose**: Prevent the player from entering any vehicle.
- **Parameters / Returns**:
  - `player` (`Player`): Player index.
- **OneSync / Networking**: Must be invoked each frame.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_ban
        -- Use: Calls SetPlayerMayNotEnterAnyVehicle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_ban', function()
        SetPlayerMayNotEnterAnyVehicle(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_ban */
    RegisterCommand('veh_ban', () => {
      SetPlayerMayNotEnterAnyVehicle(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Needs to run continuously to remain effective.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerMayNotEnterAnyVehicle

##### SetPlayerMayOnlyEnterThisVehicle (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_MAY_ONLY_ENTER_THIS_VEHICLE(Player player, Vehicle vehicle)`
- **Purpose**: Restrict the player to entering a specific vehicle.
- **Parameters / Returns**:
  - `player` (`Player`): Player to restrict.
  - `vehicle` (`Vehicle`): Allowed vehicle.
- **OneSync / Networking**: Requires entity ownership; server should manage when enforcing on others.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehlock
        -- Use: Allows entry only to current vehicle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehlock', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        SetPlayerMayOnlyEnterThisVehicle(PlayerId(), veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehlock */
    RegisterCommand('vehlock', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      SetPlayerMayOnlyEnterThisVehicle(PlayerId(), veh);
    });
    ```
- **Caveats / Limitations**:
  - Player may still exit the allowed vehicle normally.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerMayOnlyEnterThisVehicle

##### SetPlayerMaxArmour (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_MAX_ARMOUR(Player player, int value)`
- **Purpose**: Define the player's maximum armor value.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `value` (`int`): Maximum armor amount.
- **OneSync / Networking**: Local only; server must replicate when affecting others.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: maxarmour
        -- Use: Sets max armour to 100
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('maxarmour', function()
        SetPlayerMaxArmour(PlayerId(), 100)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: maxarmour */
    RegisterCommand('maxarmour', () => {
      SetPlayerMaxArmour(PlayerId(), 100);
    });
    ```
- **Caveats / Limitations**:
  - Does not apply to current armour if higher than maximum.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerMaxArmour

##### SetPlayerMeleeWeaponDamageModifier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_MELEE_WEAPON_DAMAGE_MODIFIER(Player player, float modifier)`
- **Purpose**: Adjust the damage dealt by a player's melee attacks.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `modifier` (`float`): Multiplier applied to melee damage.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; server should authorize to prevent exploits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: melee_dmg
        -- Use: Calls SetPlayerMeleeWeaponDamageModifier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('melee_dmg', function()
        SetPlayerMeleeWeaponDamageModifier(PlayerId(), 2.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: melee_dmg */
    RegisterCommand('melee_dmg', () => {
      SetPlayerMeleeWeaponDamageModifier(PlayerId(), 2.0);
    });
    ```
- **Caveats / Limitations**:
  - Values above `1.0` amplify damage.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerMeleeWeaponDamageModifier

##### SetPlayerMeleeWeaponDefenseModifier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_MELEE_WEAPON_DEFENSE_MODIFIER(Player player, float modifier)`
- **Purpose**: Modify how much melee damage the player receives.
- **Parameters / Returns**:
  - `player` (`Player`): Player to adjust.
  - `modifier` (`float`): Multiplier applied when receiving melee damage.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; validate on server for fairness.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: melee_def
        -- Use: Calls SetPlayerMeleeWeaponDefenseModifier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('melee_def', function()
        SetPlayerMeleeWeaponDefenseModifier(PlayerId(), 0.5)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: melee_def */
    RegisterCommand('melee_def', () => {
      SetPlayerMeleeWeaponDefenseModifier(PlayerId(), 0.5);
    });
    ```
- **Caveats / Limitations**:
  - Values below `1.0` reduce incoming damage.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerMeleeWeaponDefenseModifier

##### SetPlayerModel (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_MODEL(Player player, Hash model)`
- **Purpose**: Change the player's ped model.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `model` (`Hash`): Model hash to apply.
  - **Returns**: None.
- **OneSync / Networking**: Changing model locally; server-side validation recommended.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: copmodel
        -- Use: Switches to cop model
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('copmodel', function()
        local model = GetHashKey('s_m_y_cop_01')
        SetPlayerModel(PlayerId(), model)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: copmodel */
    RegisterCommand('copmodel', () => {
      const model = GetHashKey('s_m_y_cop_01');
      SetPlayerModel(PlayerId(), model);
    });
    ```
- **Caveats / Limitations**:
  - Model must be streamed before use.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerModel

##### SetPlayerNoCollisionBetweenPlayers (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_NO_COLLISION_BETWEEN_PLAYERS(Player player, BOOL toggle)`
- **Purpose**: Enable or disable collisions between the player and others.
- **Parameters / Returns**:
  - `player` (`Player`): Player to apply to.
  - `toggle` (`bool`): True to disable collision.
  - **Returns**: None.
- **OneSync / Networking**: Local ped physics; ensure both sides agree for consistency.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nocollide
        -- Use: Calls SetPlayerNoCollisionBetweenPlayers
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('nocollide', function()
        SetPlayerNoCollisionBetweenPlayers(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nocollide */
    RegisterCommand('nocollide', () => {
      SetPlayerNoCollisionBetweenPlayers(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - May not affect vehicles.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerNoCollisionBetweenPlayers

##### SetPlayerNoiseMultiplier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_NOISE_MULTIPLIER(Player player, float multiplier)`
- **Purpose**: Scale the amount of noise the player makes.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `multiplier` (`float`): Noise scale factor.
  - **Returns**: None.
- **OneSync / Networking**: Local stealth mechanics; server should coordinate for gameplay.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: silent
        -- Use: Calls SetPlayerNoiseMultiplier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('silent', function()
        SetPlayerNoiseMultiplier(PlayerId(), 0.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: silent */
    RegisterCommand('silent', () => {
      SetPlayerNoiseMultiplier(PlayerId(), 0.0);
    });
    ```
- **Caveats / Limitations**:
  - Zero may still generate minimal noise.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerNoiseMultiplier

##### SetPlayerParachuteModelOverride (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(Player player, Hash model)`
- **Purpose**: Override the parachute model used by the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player to adjust.
  - `model` (`Hash`): Parachute model hash.
  - **Returns**: None.
- **OneSync / Networking**: Local visual change; ensure synchronization for others if needed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: chute_model
        -- Use: Calls SetPlayerParachuteModelOverride
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('chute_model', function()
        local model = GetHashKey('p_parachute1_sp_s')
        SetPlayerParachuteModelOverride(PlayerId(), model)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: chute_model */
    RegisterCommand('chute_model', () => {
      const model = GetHashKey('p_parachute1_sp_s');
      SetPlayerParachuteModelOverride(PlayerId(), model);
    });
    ```
- **Caveats / Limitations**:
  - Model must exist and be streamed.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerParachuteModelOverride

##### SetPlayerParachutePackModelOverride (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(Player player, Hash model)`
- **Purpose**: Change the parachute pack model worn by the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `model` (`Hash`): Pack model hash.
  - **Returns**: None.
- **OneSync / Networking**: Local visual; replicate via server if required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: pack_model
        -- Use: Calls SetPlayerParachutePackModelOverride
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('pack_model', function()
        local model = GetHashKey('p_parachute_s')
        SetPlayerParachutePackModelOverride(PlayerId(), model)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: pack_model */
    RegisterCommand('pack_model', () => {
      const model = GetHashKey('p_parachute_s');
      SetPlayerParachutePackModelOverride(PlayerId(), model);
    });
    ```
- **Caveats / Limitations**:
  - Model must be loaded.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerParachutePackModelOverride

##### SetPlayerParachutePackTintIndex (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_PARACHUTE_PACK_TINT_INDEX(Player player, int index)`
- **Purpose**: Change the tint of the player's parachute pack.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `index` (`int`): Tint index.
  - **Returns**: None.
- **OneSync / Networking**: Cosmetic; replicate for other players if necessary.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: pack_tint
        -- Use: Calls SetPlayerParachutePackTintIndex
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('pack_tint', function()
        SetPlayerParachutePackTintIndex(PlayerId(), 2)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: pack_tint */
    RegisterCommand('pack_tint', () => {
      SetPlayerParachutePackTintIndex(PlayerId(), 2);
    });
    ```
- **Caveats / Limitations**:
  - Tint indices outside available range may fallback.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerParachutePackTintIndex

##### SetPlayerParachutePropTintIndex (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_PARACHUTE_PROP_TINT_INDEX(Player player, int index)`
- **Purpose**: Set the tint index for the parachute prop model.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `index` (`int`): Tint index for prop.
- **OneSync / Networking**: Visual change; synchronize if needed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: prop_tint
        -- Use: Calls SetPlayerParachutePropTintIndex
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('prop_tint', function()
        SetPlayerParachutePropTintIndex(PlayerId(), 1)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: prop_tint */
    RegisterCommand('prop_tint', () => {
      SetPlayerParachutePropTintIndex(PlayerId(), 1);
    });
    ```
- **Caveats / Limitations**:
  - Requires parachute equipped.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerParachutePropTintIndex

##### SetPlayerParachuteSmokeTrailColor (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_PARACHUTE_SMOKE_TRAIL_COLOR(Player player, int r, int g, int b)`
- **Purpose**: Change the smoke color emitted from the player's parachute.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `r` (`int`): Red component (0-255).
  - `g` (`int`): Green component (0-255).
  - `b` (`int`): Blue component (0-255).
  - **Returns**: None.
- **OneSync / Networking**: Visual only; server should validate for remote visibility.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: chute_smoke
        -- Use: Calls SetPlayerParachuteSmokeTrailColor
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('chute_smoke', function()
        SetPlayerParachuteSmokeTrailColor(PlayerId(), 255, 0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: chute_smoke */
    RegisterCommand('chute_smoke', () => {
      SetPlayerParachuteSmokeTrailColor(PlayerId(), 255, 0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Requires smoke trail enabled.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerParachuteSmokeTrailColor
 
##### SetPlayerParachuteTintIndex (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_PARACHUTE_TINT_INDEX(Player player, int index)`
- **Purpose**: Change the primary parachute's color.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `index` (`int`): Tint index.
  - **Returns**: None.
- **OneSync / Networking**: Cosmetic; replicate to others when necessary.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: para_tint
        -- Use: Calls SetPlayerParachuteTintIndex
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('para_tint', function()
        SetPlayerParachuteTintIndex(PlayerId(), 3)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: para_tint */
    RegisterCommand('para_tint', () => {
      SetPlayerParachuteTintIndex(PlayerId(), 3);
    });
    ```
- **Caveats / Limitations**:
  - Tint index must exist.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerParachuteTintIndex

##### SetPlayerParachuteVariationOverride (0xD9284A8C0D48352C / 0x9254249D)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_PARACHUTE_VARIATION_OVERRIDE(Player player, int p1, Any p2, Any p3, BOOL p4)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`int`): Usually 5.
  - `p2` (`Any`): Unknown.
  - `p3` (`Any`): Unknown.
  - `p4` (`bool`): Usually false.
- **OneSync / Networking**: Local cosmetic.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: chute_var
        -- Use: Calls SetPlayerParachuteVariationOverride
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('chute_var', function()
        SetPlayerParachuteVariationOverride(PlayerId(),5,0,0,false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: chute_var */
    RegisterCommand('chute_var', () => {
      SetPlayerParachuteVariationOverride(PlayerId(),5,0,0,false);
    });
    ```
- **Caveats / Limitations**:
  - Parameters unverified.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerParachuteVariationOverride

##### SetPlayerReserveParachuteModelOverride (0x0764486AEDE748DB)
- **Scope**: Client
- **Signature**: `void _SET_PLAYER_RESERVE_PARACHUTE_MODEL_OVERRIDE(Player player, Hash model)`
- **Purpose**: Assign a custom model to the reserve parachute.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `model` (`Hash`): Model hash.
- **OneSync / Networking**: Visual only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: res_model
        -- Use: Calls SetPlayerReserveParachuteModelOverride
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('res_model', function()
        SetPlayerReserveParachuteModelOverride(PlayerId(), `p_parachute_s`)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: res_model */
    RegisterCommand('res_model', () => {
      SetPlayerReserveParachuteModelOverride(PlayerId(), GetHashKey('p_parachute_s'));
    });
    ```
- **Caveats / Limitations**:
  - Model must be loaded.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerReserveParachuteModelOverride

##### SetPlayerReserveParachutePackTintIndex (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_RESERVE_PARACHUTE_PACK_TINT_INDEX(Player player, int index)`
- **Purpose**: Set tint for the reserve parachute pack.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `index` (`int`): Tint index for reserve pack.
  - **Returns**: None.
- **OneSync / Networking**: Visual change; replicate if reserve pack is visible.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: res_pack_t
        -- Use: Calls SetPlayerReserveParachutePackTintIndex
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('res_pack_t', function()
        SetPlayerReserveParachutePackTintIndex(PlayerId(), 1)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: res_pack_t */
    RegisterCommand('res_pack_t', () => {
      SetPlayerReserveParachutePackTintIndex(PlayerId(), 1);
    });
    ```
- **Caveats / Limitations**:
  - Requires reserve pack.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerReserveParachutePackTintIndex

##### SetPlayerReserveParachuteTintIndex (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_RESERVE_PARACHUTE_TINT_INDEX(Player player, int index)`
- **Purpose**: Change reserve parachute tint.
- **Parameters / Returns**:
  - `player` (`Player`): Player to modify.
  - `index` (`int`): Tint index.
  - **Returns**: None.
- **OneSync / Networking**: Cosmetic; replicate if needed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: res_tint
        -- Use: Calls SetPlayerReserveParachuteTintIndex
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('res_tint', function()
        SetPlayerReserveParachuteTintIndex(PlayerId(), 2)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: res_tint */
    RegisterCommand('res_tint', () => {
      SetPlayerReserveParachuteTintIndex(PlayerId(), 2);
    });
    ```
- **Caveats / Limitations**:
  - Requires reserve parachute equipped.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerReserveParachuteTintIndex

##### SetPlayerResetEvadeFlagRaised (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_RESET_EVADE_FLAG_RAISED(Player player)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Likely local; verify before using.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reset_evade
        -- Use: Calls SetPlayerResetEvadeFlagRaised
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reset_evade', function()
        SetPlayerResetEvadeFlagRaised(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reset_evade */
    RegisterCommand('reset_evade', () => {
      SetPlayerResetEvadeFlagRaised(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerResetEvadeFlagRaised

##### SetPlayerResetFlagPreferRearSeats (0x11D5F725F0E780E0 / 0x725C6174)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_RESET_FLAG_PREFER_REAR_SEATS(Player player, int flags)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `flags` (`int`): Seat selection flag.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rear_seat
        -- Use: Calls SetPlayerResetFlagPreferRearSeats
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rear_seat', function()
        SetPlayerResetFlagPreferRearSeats(PlayerId(), 6)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rear_seat */
    RegisterCommand('rear_seat', () => {
      SetPlayerResetFlagPreferRearSeats(PlayerId(), 6);
    });
    ```
- **Caveats / Limitations**:
  - Flags 0–6 observed; semantics unclear.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerResetFlagPreferRearSeats

##### SetPlayerSimulateAiming (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_SIMULATE_AIMING(Player player, BOOL toggle)`
- **Purpose**: Simulates the player aiming without input.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: Local effect; remote players won't see unless synced by server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sim_aim
        -- Use: Calls SetPlayerSimulateAiming
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('sim_aim', function()
        SetPlayerSimulateAiming(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sim_aim */
    RegisterCommand('sim_aim', () => {
      SetPlayerSimulateAiming(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Can desync if server expects real input.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerSimulateAiming

##### SetPlayerSneakingNoiseMultiplier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_SNEAKING_NOISE_MULTIPLIER(Player player, float multiplier)`
- **Purpose**: Adjust how noisy the player is while sneaking.
- **Parameters / Returns**:
  - `player` (`Player`): Player to adjust.
  - `multiplier` (`float`): Noise multiplier.
  - **Returns**: None.
- **OneSync / Networking**: Local; not replicated automatically.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sneak_noise
        -- Use: Calls SetPlayerSneakingNoiseMultiplier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('sneak_noise', function()
        SetPlayerSneakingNoiseMultiplier(PlayerId(), 0.5)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sneak_noise */
    RegisterCommand('sneak_noise', () => {
      SetPlayerSneakingNoiseMultiplier(PlayerId(), 0.5);
    });
    ```
- **Caveats / Limitations**:
  - Multiplier < 1 reduces noise; > 1 increases.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerSneakingNoiseMultiplier

##### SetPlayerSprint (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_SPRINT(Player player, BOOL toggle)`
- **Purpose**: Enable or disable sprinting for the player.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `toggle` (`bool`): Allow sprinting.
  - **Returns**: None.
- **OneSync / Networking**: Local; server should validate to prevent speed hacks.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sprint_toggle
        -- Use: Calls SetPlayerSprint
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('sprint_toggle', function()
        SetPlayerSprint(PlayerId(), false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sprint_toggle */
    RegisterCommand('sprint_toggle', () => {
      SetPlayerSprint(PlayerId(), false);
    });
    ```
- **Caveats / Limitations**:
  - Does not affect stamina.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerSprint

##### SetPlayerStealthMovement (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_STEALTH_MOVEMENT(Player player, BOOL toggle, BOOL p2)`
- **Purpose**: Toggle stealth movement mode.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `toggle` (`bool`): Enable or disable stealth.
  - `p2` (`bool`): Unknown.
  - **Returns**: None.
- **OneSync / Networking**: Local; server should approve for gameplay impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: stealth
        -- Use: Calls SetPlayerStealthMovement
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('stealth', function()
        SetPlayerStealthMovement(PlayerId(), true, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stealth */
    RegisterCommand('stealth', () => {
      SetPlayerStealthMovement(PlayerId(), true, false);
    });
    ```
- **Caveats / Limitations**:
  - Behavior varies by animation set.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerStealthMovement

##### SetPlayerStealthPerceptionModifier (0x4E9021C1FCDD507A / 0x3D26105F)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_STEALTH_PERCEPTION_MODIFIER(Player player, float value)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `value` (`float`): Modifier value.
- **OneSync / Networking**: Local.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: stealth_perc
        -- Use: Calls SetPlayerStealthPerceptionModifier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('stealth_perc', function()
        SetPlayerStealthPerceptionModifier(PlayerId(), 0.5)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stealth_perc */
    RegisterCommand('stealth_perc', () => {
      SetPlayerStealthPerceptionModifier(PlayerId(), 0.5);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerStealthPerceptionModifier

##### SetPlayerTargetLevel (0x5702B917B99DB1CD / 0x772DA539)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_TARGET_LEVEL(int targetLevel)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `targetLevel` (`int`): Desired level.
- **OneSync / Networking**: Local.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: target_level
        -- Use: Calls SetPlayerTargetLevel
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('target_level', function()
        SetPlayerTargetLevel(2)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: target_level */
    RegisterCommand('target_level', () => {
      SetPlayerTargetLevel(2);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerTargetLevel

##### SetPlayerTargetingMode (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_TARGETING_MODE(int mode)`
- **Purpose**: Set the player's aiming/targeting style.
- **Parameters / Returns**:
  - `mode` (`int`): Targeting mode.
  - **Returns**: None.
- **OneSync / Networking**: Local preference; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: target_mode
        -- Use: Calls SetPlayerTargetingMode
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('target_mode', function()
        SetPlayerTargetingMode(3)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: target_mode */
    RegisterCommand('target_mode', () => {
      SetPlayerTargetingMode(3);
    });
    ```
- **Caveats / Limitations**:
  - Mode values depend on game settings.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerTargetingMode

##### SetPlayerTeam (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_TEAM(Player player, int team)`
- **Purpose**: Assign the player to a team.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `team` (`int`): Team index.
  - **Returns**: None.
- **OneSync / Networking**: Requires server authority to avoid desync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: join_team
        -- Use: Calls SetPlayerTeam
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('join_team', function()
        SetPlayerTeam(PlayerId(), 2)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: join_team */
    RegisterCommand('join_team', () => {
      SetPlayerTeam(PlayerId(), 2);
    });
    ```
- **Caveats / Limitations**:
  - Team logic must be implemented server-side.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerTeam

##### SetPlayerUnderwaterTimeRemaining (0xA0D3E4F7AAFB7E78)
- **Scope**: Client
- **Signature**: `Any _SET_PLAYER_UNDERWATER_TIME_REMAINING(Player player, float percentage)`
- **Purpose**: Locks remaining underwater breathing time.
- **Parameters / Returns**:
  - `player` (`Player`): Player id.
  - `percentage` (`float`): 0.0–100.0 percentage of bar.
- **OneSync / Networking**: Local; not replicated.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: water_time
        -- Use: Calls SetPlayerUnderwaterTimeRemaining
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('water_time', function()
        SetPlayerUnderwaterTimeRemaining(PlayerId(), 50.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: water_time */
    RegisterCommand('water_time', () => {
      SetPlayerUnderwaterTimeRemaining(PlayerId(), 50.0);
    });
    ```
- **Caveats / Limitations**:
  - Overrides natural underwater timer; conflicts with `SET_PED_MAX_TIME_UNDERWATER`.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerUnderwaterTimeRemaining

##### SetPlayerVehicleDamageModifier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_VEHICLE_DAMAGE_MODIFIER(Player player, float modifier)`
- **Purpose**: Modify damage dealt by the player's vehicle.
- **Parameters / Returns**:
  - `player` (`Player`): Player controlling the vehicle.
  - `modifier` (`float`): Damage multiplier.
  - **Returns**: None.
- **OneSync / Networking**: Server should validate modifier to prevent exploits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_dmg
        -- Use: Calls SetPlayerVehicleDamageModifier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_dmg', function()
        SetPlayerVehicleDamageModifier(PlayerId(), 2.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_dmg */
    RegisterCommand('veh_dmg', () => {
      SetPlayerVehicleDamageModifier(PlayerId(), 2.0);
    });
    ```
- **Caveats / Limitations**:
  - Values above 1 increase damage.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerVehicleDamageModifier

##### SetPlayerVehicleDefenseModifier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_VEHICLE_DEFENSE_MODIFIER(Player player, float modifier)`
- **Purpose**: Adjusts the damage resistance of the player's current vehicle.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `modifier` (`float`): Defense multiplier, minimum 0.1.
- **OneSync / Networking**: Local effect; server should validate values for remote players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_def
        -- Use: Calls SetPlayerVehicleDefenseModifier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_def', function()
        SetPlayerVehicleDefenseModifier(PlayerId(), 2.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_def */
    RegisterCommand('veh_def', () => {
      SetPlayerVehicleDefenseModifier(PlayerId(), 2.0);
    });
    ```
- **Caveats / Limitations**:
  - Values below 0.1 are ignored.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerVehicleDefenseModifier

##### SetPlayerWantedCentrePosition (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_WANTED_CENTRE_POSITION(Player player, Vector3 position, BOOL p2, BOOL p3)`
- **Purpose**: Sets the center position used for police search behavior.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `position` (`Vector3`): World coordinates.
  - `p2` (`bool`): Unknown flag.
  - `p3` (`bool`): Unknown flag.
- **OneSync / Networking**: Local change; server should manage wanted logic for all players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wanted_pos
        -- Use: Calls SetPlayerWantedCentrePosition
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wanted_pos', function()
        local pos = GetEntityCoords(PlayerPedId())
        SetPlayerWantedCentrePosition(PlayerId(), pos, false, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wanted_pos */
    RegisterCommand('wanted_pos', () => {
      const pos = GetEntityCoords(PlayerPedId());
      SetPlayerWantedCentrePosition(PlayerId(), pos, false, false);
    });
    ```
- **Caveats / Limitations**:
  - Flags `p2` and `p3` remain undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerWantedCentrePosition

##### SetPlayerWantedLevel (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_WANTED_LEVEL(Player player, int wantedLevel, BOOL delayedResponse)`
- **Purpose**: Sets the player's wanted level.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `wantedLevel` (`int`): Level 0-5.
  - `delayedResponse` (`bool`): Toggle slower police response.
- **OneSync / Networking**: Inform the server so other clients receive consistent wanted state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wanted_lvl
        -- Use: Calls SetPlayerWantedLevel
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wanted_lvl', function()
        SetPlayerWantedLevel(PlayerId(), 5, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wanted_lvl */
    RegisterCommand('wanted_lvl', () => {
      SetPlayerWantedLevel(PlayerId(), 5, false);
    });
    ```
- **Caveats / Limitations**:
  - Wanted level over 5 is ignored.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerWantedLevel

##### SetPlayerWantedLevelNoDrop (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_WANTED_LEVEL_NO_DROP(Player player, int wantedLevel, BOOL delayedResponse)`
- **Purpose**: Sets wanted level without allowing it to decrease naturally.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `wantedLevel` (`int`): Level 0-5.
  - `delayedResponse` (`bool`): Toggle slower police response.
- **OneSync / Networking**: Sync via server to avoid mismatch.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wanted_nodrop
        -- Use: Calls SetPlayerWantedLevelNoDrop
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wanted_nodrop', function()
        SetPlayerWantedLevelNoDrop(PlayerId(), 5, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wanted_nodrop */
    RegisterCommand('wanted_nodrop', () => {
      SetPlayerWantedLevelNoDrop(PlayerId(), 5, false);
    });
    ```
- **Caveats / Limitations**:
  - Wanted level remains until explicitly cleared.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerWantedLevelNoDrop

##### SetPlayerWantedLevelNow (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_WANTED_LEVEL_NOW(Player player, BOOL p1)`
- **Purpose**: Forces pending wanted level changes to apply immediately.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`bool`): Unknown, usually false.
- **OneSync / Networking**: Ensure server knows final level after forcing.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wanted_now
        -- Use: Calls SetPlayerWantedLevelNow
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wanted_now', function()
        SetPlayerWantedLevel(PlayerId(), 5, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wanted_now */
    RegisterCommand('wanted_now', () => {
      SetPlayerWantedLevel(PlayerId(), 5, false);
      SetPlayerWantedLevelNow(PlayerId(), false);
    });
    ```
- **Caveats / Limitations**:
  - Second parameter purpose undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerWantedLevelNow

##### SetPlayerWeaponDamageModifier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_WEAPON_DAMAGE_MODIFIER(Player player, float modifier)`
- **Purpose**: Scales weapon damage dealt by the player.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `modifier` (`float`): Damage multiplier, min 0.1.
- **OneSync / Networking**: Local only; server should verify to prevent exploits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wep_dmg
        -- Use: Calls SetPlayerWeaponDamageModifier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wep_dmg', function()
        SetPlayerWeaponDamageModifier(PlayerId(), 2.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wep_dmg */
    RegisterCommand('wep_dmg', () => {
      SetPlayerWeaponDamageModifier(PlayerId(), 2.0);
    });
    ```
- **Caveats / Limitations**:
  - Values below 0.1 are ignored.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerWeaponDamageModifier

##### SetPlayerWeaponDefenseModifier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_PLAYER_WEAPON_DEFENSE_MODIFIER(Player player, float modifier)`
- **Purpose**: Alters how much damage the player receives from weapons.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `modifier` (`float`): Defense multiplier.
- **OneSync / Networking**: Local effect; server validation recommended.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wep_def
        -- Use: Calls SetPlayerWeaponDefenseModifier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wep_def', function()
        SetPlayerWeaponDefenseModifier(PlayerId(), 2.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wep_def */
    RegisterCommand('wep_def', () => {
      SetPlayerWeaponDefenseModifier(PlayerId(), 2.0);
    });
    ```
- **Caveats / Limitations**:
  - Extreme values may produce unexpected results.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerWeaponDefenseModifier

##### SetPlayerWeaponDefenseModifier_2 (hash unknown)
- **Scope**: Client
- **Signature**: `void _SET_PLAYER_WEAPON_DEFENSE_MODIFIER_2(Player player, float modifier)`
- **Purpose**: Secondary variant for weapon defense scaling.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `modifier` (`float`): Defense multiplier.
- **OneSync / Networking**: Local; use cautiously as semantics are unclear.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wep_def2
        -- Use: Calls SetPlayerWeaponDefenseModifier_2
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wep_def2', function()
        SetPlayerWeaponDefenseModifier_2(PlayerId(), 2.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wep_def2 */
    RegisterCommand('wep_def2', () => {
      SetPlayerWeaponDefenseModifier_2(PlayerId(), 2.0);
    });
    ```
- **Caveats / Limitations**:
  - Specific effects are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerWeaponDefenseModifier_2

##### SetPoliceIgnorePlayer (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_POLICE_IGNORE_PLAYER(Player player, BOOL toggle)`
- **Purpose**: Toggles whether police react to the player.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `toggle` (`bool`): True to ignore.
- **OneSync / Networking**: Local effect; server should manage global wanted system.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: police_ignore
        -- Use: Calls SetPoliceIgnorePlayer
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('police_ignore', function()
        SetPoliceIgnorePlayer(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: police_ignore */
    RegisterCommand('police_ignore', () => {
      SetPoliceIgnorePlayer(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Does not clear existing wanted level.
- **Reference**: https://docs.fivem.net/natives/?n=SetPoliceIgnorePlayer

##### SetPoliceRadarBlips (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_POLICE_RADAR_BLIPS(BOOL toggle)`
- **Purpose**: Shows or hides police blips on the radar.
- **Parameters / Returns**:
  - `toggle` (`bool`): True to enable blips.
- **OneSync / Networking**: Affects only local HUD.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: police_blips
        -- Use: Calls SetPoliceRadarBlips
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('police_blips', function()
        SetPoliceRadarBlips(true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: police_blips */
    RegisterCommand('police_blips', () => {
      SetPoliceRadarBlips(true);
    });
    ```
- **Caveats / Limitations**:
  - Only affects map display.
- **Reference**: https://docs.fivem.net/natives/?n=SetPoliceRadarBlips

##### SetRunSprintMultiplierForPlayer (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_RUN_SPRINT_MULTIPLIER_FOR_PLAYER(Player player, float multiplier)`
- **Purpose**: Scales running speed.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `multiplier` (`float`): Speed multiplier up to 1.49.
- **OneSync / Networking**: Local change; servers may enforce limits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: runspeed
        -- Use: Calls SetRunSprintMultiplierForPlayer
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('runspeed', function()
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: runspeed */
    RegisterCommand('runspeed', () => {
      SetRunSprintMultiplierForPlayer(PlayerId(), 1.2);
    });
    ```
- **Caveats / Limitations**:
  - Values above 1.49 are ignored; cannot slow below default.
- **Reference**: https://docs.fivem.net/natives/?n=SetRunSprintMultiplierForPlayer

##### SetSpecialAbility (hash unknown)
- **Scope**: Client
- **Signature**: `void _SET_SPECIAL_ABILITY(Player player, int p1)`
- **Purpose**: Configures player-specific special ability state.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`int`): Unknown value.
- **OneSync / Networking**: Client-side; use carefully with custom ability systems.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_set
        -- Use: Calls SetSpecialAbility
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_set', function()
        SetSpecialAbility(PlayerId(), 1)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_set */
    RegisterCommand('special_set', () => {
      SetSpecialAbility(PlayerId(), 1);
    });
    ```
- **Caveats / Limitations**:
  - Parameters are not fully documented.
- **Reference**: https://docs.fivem.net/natives/?n=SetSpecialAbility

##### SetSpecialAbilityMultiplier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_SPECIAL_ABILITY_MULTIPLIER(float multiplier)`
- **Purpose**: Sets global multiplier for special ability usage.
- **Parameters / Returns**:
  - `multiplier` (`float`): Scaling factor.
- **OneSync / Networking**: Local effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_mult
        -- Use: Calls SetSpecialAbilityMultiplier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_mult', function()
        SetSpecialAbilityMultiplier(2.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_mult */
    RegisterCommand('special_mult', () => {
      SetSpecialAbilityMultiplier(2.0);
    });
    ```
- **Caveats / Limitations**:
  - Affects all specials globally for the player.
- **Reference**: https://docs.fivem.net/natives/?n=SetSpecialAbilityMultiplier

##### SetSwimMultiplierForPlayer (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_SWIM_MULTIPLIER_FOR_PLAYER(Player player, float multiplier)`
- **Purpose**: Adjusts swimming speed.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `multiplier` (`float`): Speed multiplier up to 1.49.
- **OneSync / Networking**: Local effect; server may enforce limits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: swimspeed
        -- Use: Calls SetSwimMultiplierForPlayer
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('swimspeed', function()
        SetSwimMultiplierForPlayer(PlayerId(), 1.2)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: swimspeed */
    RegisterCommand('swimspeed', () => {
      SetSwimMultiplierForPlayer(PlayerId(), 1.2);
    });
    ```
- **Caveats / Limitations**:
  - Values above 1.49 are ignored.
- **Reference**: https://docs.fivem.net/natives/?n=SetSwimMultiplierForPlayer

##### SetWantedLevelDifficulty (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_WANTED_LEVEL_DIFFICULTY(Player player, float difficulty)`
- **Purpose**: Modifies AI difficulty for pursuing police.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `difficulty` (`float`): Value up to 1.0.
- **OneSync / Networking**: Local tuning; sync wanted behavior via server events.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wanted_difficulty
        -- Use: Calls SetWantedLevelDifficulty
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wanted_difficulty', function()
        SetWantedLevelDifficulty(PlayerId(), 0.5)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wanted_difficulty */
    RegisterCommand('wanted_difficulty', () => {
      SetWantedLevelDifficulty(PlayerId(), 0.5);
    });
    ```
- **Caveats / Limitations**:
  - Higher values increase police aggression.
- **Reference**: https://docs.fivem.net/natives/?n=SetWantedLevelDifficulty

##### SetWantedLevelHiddenEvasionTime (hash unknown)
- **Scope**: Client
- **Signature**: `void _SET_WANTED_LEVEL_HIDDEN_EVASION_TIME(Player player, int wantedLevel, int lossTime)`
- **Purpose**: Sets extra time required to lose a hidden wanted level.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `wantedLevel` (`int`): Level to adjust.
  - `lossTime` (`int`): Time in seconds.
- **OneSync / Networking**: Local; introduced in game build v2060.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wanted_evasion
        -- Use: Calls SetWantedLevelHiddenEvasionTime
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wanted_evasion', function()
        SetWantedLevelHiddenEvasionTime(PlayerId(), 2, 30)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wanted_evasion */
    RegisterCommand('wanted_evasion', () => {
      SetWantedLevelHiddenEvasionTime(PlayerId(), 2, 30);
    });
    ```
- **Caveats / Limitations**:
  - Only effective on supported game builds.
- **Reference**: https://docs.fivem.net/natives/?n=SetWantedLevelHiddenEvasionTime

##### SetWantedLevelMultiplier (hash unknown)
- **Scope**: Client
- **Signature**: `void SET_WANTED_LEVEL_MULTIPLIER(float multiplier)`
- **Purpose**: Globally scales the rate at which wanted level increases.
- **Parameters / Returns**:
  - `multiplier` (`float`): Scaling factor.
- **OneSync / Networking**: Local; consider syncing with server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wanted_mult
        -- Use: Calls SetWantedLevelMultiplier
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('wanted_mult', function()
        SetWantedLevelMultiplier(0.5)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wanted_mult */
    RegisterCommand('wanted_mult', () => {
      SetWantedLevelMultiplier(0.5);
    });
    ```
- **Caveats / Limitations**:
  - Affects all wanted level changes for the player.
- **Reference**: https://docs.fivem.net/natives/?n=SetWantedLevelMultiplier

##### SimulatePlayerInputGait (hash unknown)
- **Scope**: Client
- **Signature**: `void SIMULATE_PLAYER_INPUT_GAIT(Player player, float amount, int gaitType, float rotationSpeed, BOOL p4, BOOL p5)`
- **Purpose**: Simulates player movement input, forcing walking without actual controls.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `amount` (`float`): Analog amount (0-1).
  - `gaitType` (`int`): Duration/behavior code, -1 for continuous.
  - `rotationSpeed` (`float`): Rotation speed while moving.
  - `p4` (`bool`): Always true.
  - `p5` (`bool`): Always false.
- **OneSync / Networking**: Local movement; server must manage final position.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: gait
        -- Use: Calls SimulatePlayerInputGait
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('gait', function()
        SimulatePlayerInputGait(PlayerId(), 1.0, -1, 0.0, true, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: gait */
    RegisterCommand('gait', () => {
      SimulatePlayerInputGait(PlayerId(), 1.0, -1, 0.0, true, false);
    });
    ```
- **Caveats / Limitations**:
  - Must be called each frame to maintain movement.
- **Reference**: https://docs.fivem.net/natives/?n=SimulatePlayerInputGait

##### SpecialAbilityActivate (hash unknown)
- **Scope**: Client
- **Signature**: `void _SPECIAL_ABILITY_ACTIVATE(Player player)`
- **Purpose**: Activates the player's special ability.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
- **OneSync / Networking**: Local effect; ensure server agrees with ability activation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_activate
        -- Use: Calls SpecialAbilityActivate
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_activate', function()
        SpecialAbilityActivate(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_activate */
    RegisterCommand('special_activate', () => {
      SpecialAbilityActivate(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Ability must be charged before activation.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityActivate

##### SpecialAbilityChargeAbsolute (hash unknown)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_CHARGE_ABSOLUTE(Player player, int p1, BOOL p2)`
- **Purpose**: Adds a fixed amount of charge to the special ability.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`int`): Amount of charge.
  - `p2` (`bool`): Typically true.
- **OneSync / Networking**: Local; keep ability state synced with server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_charge_abs
        -- Use: Calls SpecialAbilityChargeAbsolute
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_charge_abs', function()
        SpecialAbilityChargeAbsolute(PlayerId(), 10, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_charge_abs */
    RegisterCommand('special_charge_abs', () => {
      SpecialAbilityChargeAbsolute(PlayerId(), 10, true);
    });
    ```
- **Caveats / Limitations**:
  - Accepts only certain charge values (5–30).
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityChargeAbsolute

##### SpecialAbilityChargeContinuous (hash unknown)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_CHARGE_CONTINUOUS(Player player, Ped p2)`
- **Purpose**: Continuously charges ability based on a second entity.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p2` (`Ped`): Source ped; often `PlayerPedId()`.
- **OneSync / Networking**: Local; parameters are partly undocumented.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_charge_cont
        -- Use: Calls SpecialAbilityChargeContinuous
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_charge_cont', function()
        SpecialAbilityChargeContinuous(PlayerId(), PlayerPedId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_charge_cont */
    RegisterCommand('special_charge_cont', () => {
      SpecialAbilityChargeContinuous(PlayerId(), PlayerPedId());
    });
    ```
- **Caveats / Limitations**:
  - Parameters beyond the ped are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityChargeContinuous

##### SpecialAbilityChargeLarge (hash unknown)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_CHARGE_LARGE(Player player, BOOL p1, BOOL p2)`
- **Purpose**: Adds a large chunk to the special ability meter.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`bool`): Typically true.
  - `p2` (`bool`): Unknown.
- **OneSync / Networking**: Local; state should sync with server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_charge_large
        -- Use: Calls SpecialAbilityChargeLarge
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_charge_large', function()
        SpecialAbilityChargeLarge(PlayerId(), true, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_charge_large */
    RegisterCommand('special_charge_large', () => {
      SpecialAbilityChargeLarge(PlayerId(), true, true);
    });
    ```
- **Caveats / Limitations**:
  - Exact charge amount is unspecified.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityChargeLarge

##### SpecialAbilityChargeMedium (hash unknown)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_CHARGE_MEDIUM(Player player, BOOL p1, BOOL p2)`
- **Purpose**: Adds a medium amount of special ability charge.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`bool`): Typically true.
  - `p2` (`bool`): Unknown.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_charge_med
        -- Use: Calls SpecialAbilityChargeMedium
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_charge_med', function()
        SpecialAbilityChargeMedium(PlayerId(), true, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_charge_med */
    RegisterCommand('special_charge_med', () => {
      SpecialAbilityChargeMedium(PlayerId(), true, true);
    });
    ```
- **Caveats / Limitations**:
  - Charging amounts are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityChargeMedium

##### SpecialAbilityChargeNormalized (hash unknown)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_CHARGE_NORMALIZED(Player player, float normalizedValue, BOOL p2)`
- **Purpose**: Sets special ability charge using a normalized value.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `normalizedValue` (`float`): Charge 0.0–1.0.
  - `p2` (`bool`): Typically true.
- **OneSync / Networking**: Local; ensure server tracks final value.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_charge_norm
        -- Use: Calls SpecialAbilityChargeNormalized
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_charge_norm', function()
        SpecialAbilityChargeNormalized(PlayerId(), 1.0, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_charge_norm */
    RegisterCommand('special_charge_norm', () => {
      SpecialAbilityChargeNormalized(PlayerId(), 1.0, true);
    });
    ```
- **Caveats / Limitations**:
  - Values outside 0.0–1.0 are clamped.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityChargeNormalized

##### SpecialAbilityChargeOnMissionFailed (hash unknown)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_CHARGE_ON_MISSION_FAILED(Player player)`
- **Purpose**: Restores special ability when a mission fails.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
- **OneSync / Networking**: Local; sync ability state with server if used.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_charge_fail
        -- Use: Calls SpecialAbilityChargeOnMissionFailed
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_charge_fail', function()
        SpecialAbilityChargeOnMissionFailed(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_charge_fail */
    RegisterCommand('special_charge_fail', () => {
      SpecialAbilityChargeOnMissionFailed(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Amount of restored charge is unspecified.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityChargeOnMissionFailed


##### SpecialAbilityChargeSmall (0x2E7B9B683481687D / 0x6F463F56)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_CHARGE_SMALL(Player player, BOOL p1, BOOL p2)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`bool`): Unknown; observed as true.
  - `p2` (`bool`): Unknown; observed as true.
  - **Returns**: None.
- **OneSync / Networking**: Local ability state; replicate to server if gameplay impacts others.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_charge_small
        -- Use: Calls SpecialAbilityChargeSmall
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_charge_small', function()
        SpecialAbilityChargeSmall(PlayerId(), true, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_charge_small */
    RegisterCommand('special_charge_small', () => {
      SpecialAbilityChargeSmall(PlayerId(), true, true);
    });
    ```
- **Caveats / Limitations**:
  - Parameters `p1` and `p2` are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityChargeSmall

##### SpecialAbilityDeactivate (0xD6A953C6D1492057 / 0x80C2AB09)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_DEACTIVATE(Player player)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local ability state; server should validate.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_deactivate
        -- Use: Calls SpecialAbilityDeactivate
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_deactivate', function()
        SpecialAbilityDeactivate(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_deactivate */
    RegisterCommand('special_deactivate', () => {
      SpecialAbilityDeactivate(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Parameters beyond `player` are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityDeactivate

##### SpecialAbilityDeactivateFast (0x9CB5CE07A3968D5A / 0x0751908A)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_DEACTIVATE_FAST(Player player)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local ability state; server should validate.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_deactivate_fast
        -- Use: Calls SpecialAbilityDeactivateFast
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_deactivate_fast', function()
        SpecialAbilityDeactivateFast(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_deactivate_fast */
    RegisterCommand('special_deactivate_fast', () => {
      SpecialAbilityDeactivateFast(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - No return; purpose unclear.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityDeactivateFast

##### SpecialAbilityDeplete (0x17F7471EACA78290)
- **Scope**: Client
- **Signature**: `void _SPECIAL_ABILITY_DEPLETE(Any p0)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `p0` (`any`): Unknown.
  - **Returns**: None.
- **OneSync / Networking**: Local.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_deplete
        -- Use: Calls _SPECIAL_ABILITY_DEPLETE
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_deplete', function()
        _SPECIAL_ABILITY_DEPLETE(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_deplete */
    RegisterCommand('special_deplete', () => {
      _SPECIAL_ABILITY_DEPLETE(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - Native is undocumented; behavior unknown.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityDeplete

##### SpecialAbilityDepleteMeter (0x1D506DBBBC51E64B / 0x9F80F6DF)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_DEPLETE_METER(Player player, BOOL p1)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`bool`): Unknown; usually true.
  - **Returns**: None.
- **OneSync / Networking**: Local ability meter.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_deplete_meter
        -- Use: Calls SpecialAbilityDepleteMeter
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_deplete_meter', function()
        SpecialAbilityDepleteMeter(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_deplete_meter */
    RegisterCommand('special_deplete_meter', () => {
      SpecialAbilityDepleteMeter(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Parameter `p1` is undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityDepleteMeter

##### SpecialAbilityFillMeter (0x3DACA8DDC6FD4980 / 0xB71589DA)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_FILL_METER(Player player, BOOL p1)`
- **Purpose**: Recharges the player's special ability meter.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `p1` (`bool`): Unknown; typically true.
  - **Returns**: None.
- **OneSync / Networking**: Local ability meter.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_fill_meter
        -- Use: Calls SpecialAbilityFillMeter
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_fill_meter', function()
        SpecialAbilityFillMeter(PlayerId(), true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_fill_meter */
    RegisterCommand('special_fill_meter', () => {
      SpecialAbilityFillMeter(PlayerId(), true);
    });
    ```
- **Caveats / Limitations**:
  - Also known as `_RECHARGE_SPECIAL_ABILITY`.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityFillMeter

##### SpecialAbilityLock (0x6A09D0D590A47D13 / 0x1B7BB388)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_LOCK(Hash playerModel)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `playerModel` (`Hash`): Model to lock ability for.
  - **Returns**: None.
- **OneSync / Networking**: Local effect based on ped model.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_lock
        -- Use: Calls SpecialAbilityLock
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_lock', function()
        SpecialAbilityLock(GetEntityModel(PlayerPedId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_lock */
    RegisterCommand('special_lock', () => {
      SpecialAbilityLock(GetEntityModel(PlayerPedId()));
    });
    ```
- **Caveats / Limitations**:
  - Purpose unknown; may depend on model.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityLock

##### SpecialAbilityReset (0x375F0E738F861A94 / 0xA7D8BCD3)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_RESET(Player player)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - **Returns**: None.
- **OneSync / Networking**: Local ability state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_reset
        -- Use: Calls SpecialAbilityReset
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_reset', function()
        SpecialAbilityReset(PlayerId())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_reset */
    RegisterCommand('special_reset', () => {
      SpecialAbilityReset(PlayerId());
    });
    ```
- **Caveats / Limitations**:
  - No return; use with caution.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityReset

##### SpecialAbilityUnlock (0xF145F3BE2EFA9A3B / 0x1FDB2919)
- **Scope**: Client
- **Signature**: `void SPECIAL_ABILITY_UNLOCK(Hash playerModel)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `playerModel` (`Hash`): Model to unlock ability for.
  - **Returns**: None.
- **OneSync / Networking**: Local effect based on model.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: special_unlock
        -- Use: Calls SpecialAbilityUnlock
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('special_unlock', function()
        SpecialAbilityUnlock(GetEntityModel(PlayerPedId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: special_unlock */
    RegisterCommand('special_unlock', () => {
      SpecialAbilityUnlock(GetEntityModel(PlayerPedId()));
    });
    ```
- **Caveats / Limitations**:
  - Purpose unknown.
- **Reference**: https://docs.fivem.net/natives/?n=SpecialAbilityUnlock

##### StartFiringAmnesty (0xBF9BD71691857E48 / 0x5F8A22A6)
- **Scope**: Client
- **Signature**: `void START_FIRING_AMNESTY(int duration)`
- **Purpose**: Temporarily prevents wanted level for firing weapons.
- **Parameters / Returns**:
  - `duration` (`int`): Duration in milliseconds.
  - **Returns**: None.
- **OneSync / Networking**: Local; server should monitor for abuse.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: firing_amnesty
        -- Use: Calls StartFiringAmnesty
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('firing_amnesty', function()
        StartFiringAmnesty(10000) -- 10 seconds
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: firing_amnesty */
    RegisterCommand('firing_amnesty', () => {
      StartFiringAmnesty(10000); // 10 seconds
    });
    ```
- **Caveats / Limitations**:
  - Only suppresses crime for a limited time.
- **Reference**: https://docs.fivem.net/natives/?n=StartFiringAmnesty

##### StartPlayerTeleport (0xAD15F075A4DA0FDE / 0xC552E06C)
- **Scope**: Client
- **Signature**: `void START_PLAYER_TELEPORT(Player player, float x, float y, float z, float heading, BOOL teleportWithVehicle, BOOL findCollisionLand, BOOL p7)`
- **Purpose**: Begins an asynchronous player teleport.
- **Parameters / Returns**:
  - `player` (`Player`): Player to teleport.
  - `x`, `y`, `z` (`float`): Destination coordinates.
  - `heading` (`float`): Heading at destination.
  - `teleportWithVehicle` (`bool`): Include vehicle.
  - `findCollisionLand` (`bool`): Auto-detect ground Z.
  - `p7` (`bool`): Unknown.
  - **Returns**: None.
- **OneSync / Networking**: Server should validate destination and handle entity ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tp_start
        -- Use: Teleports the player asynchronously
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('tp_start', function()
        StartPlayerTeleport(PlayerId(), 200.0, 200.0, 30.0, 0.0, false, true, true)
        while IsPlayerTeleportActive() do
            Wait(0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tp_start */
    RegisterCommand('tp_start', () => {
      StartPlayerTeleport(PlayerId(), 200.0, 200.0, 30.0, 0.0, false, true, true);
      const interval = setInterval(() => {
        if (!IsPlayerTeleportActive()) clearInterval(interval);
      }, 0);
    });
    ```
- **Caveats / Limitations**:
  - `findCollisionLand` only works for players on foot.
- **Reference**: https://docs.fivem.net/natives/?n=StartPlayerTeleport

##### StopPlayerTeleport (0xC449EDED9D73009C / 0x86AB8DBB)
- **Scope**: Client
- **Signature**: `void STOP_PLAYER_TELEPORT()`
- **Purpose**: Cancels an active teleport started with `StartPlayerTeleport`.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Local; server should track teleport completion.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tp_stop
        -- Use: Cancels player teleport
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('tp_stop', function()
        StopPlayerTeleport()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tp_stop */
    RegisterCommand('tp_stop', () => {
      StopPlayerTeleport();
    });
    ```
- **Caveats / Limitations**:
  - Only effective while a teleport is active.
- **Reference**: https://docs.fivem.net/natives/?n=StopPlayerTeleport

##### SuppressCrimeThisFrame (0x9A987297ED8BD838 / 0x59B5C2A2)
- **Scope**: Client
- **Signature**: `void SUPPRESS_CRIME_THIS_FRAME(Player player, int crimeType)`
- **Purpose**: Suppresses detection of a specific crime for the current frame.
- **Parameters / Returns**:
  - `player` (`Player`): Player to affect.
  - `crimeType` (`int`): Crime type ID (see `REPORT_CRIME`).
  - **Returns**: None.
- **OneSync / Networking**: Must be called every frame to maintain suppression.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: suppress_crime
        -- Use: Calls SuppressCrimeThisFrame for weapon firing
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('suppress_crime', function()
        SuppressCrimeThisFrame(PlayerId(), 6) -- 6: firing weapon
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: suppress_crime */
    RegisterCommand('suppress_crime', () => {
      SuppressCrimeThisFrame(PlayerId(), 6); // 6: firing weapon
    });
    ```
- **Caveats / Limitations**:
  - Must run in a loop for sustained effect.
- **Reference**: https://docs.fivem.net/natives/?n=SuppressCrimeThisFrame

##### UpdatePlayerTeleport (0xE23D5873C2394C61 / _HAS_PLAYER_TELEPORT_FINISHED)
- **Scope**: Client
- **Signature**: `BOOL _UPDATE_PLAYER_TELEPORT(Player player)`
- **Purpose**: Checks if an asynchronous teleport has completed.
- **Parameters / Returns**:
  - `player` (`Player`): Player to query.
  - **Returns**: `bool` indicating completion.
- **OneSync / Networking**: Local; server may poll to synchronize state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tp_status
        -- Use: Reports if teleport finished
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('tp_status', function()
        print(_UPDATE_PLAYER_TELEPORT(PlayerId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tp_status */
    RegisterCommand('tp_status', () => {
      console.log(_UPDATE_PLAYER_TELEPORT(PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Returns `false` while teleport in progress.
- **Reference**: https://docs.fivem.net/natives/?n=UpdatePlayerTeleport
 
#### Recording

##### DisableRockstarEditorCameraChanges (0xAF66DCEE6609B148)
- **Scope**: Client
- **Signature**: `void _DISABLE_ROCKSTAR_EDITOR_CAMERA_CHANGES()`
- **Purpose**: Disables camera switching in Rockstar Editor.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: ed_dis_cam
        -- Use: Disables editor camera changes
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('ed_dis_cam', function()
        DisableRockstarEditorCameraChanges()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: ed_dis_cam */
    RegisterCommand('ed_dis_cam', () => {
      DisableRockstarEditorCameraChanges();
    });
    ```
- **Caveats / Limitations**:
  - Only applies while using Rockstar Editor.
- **Reference**: https://docs.fivem.net/natives/?n=DisableRockstarEditorCameraChanges

##### IsRecording (0x1897CA71995A90B4)
- **Scope**: Client
- **Signature**: `BOOL _IS_RECORDING()`
- **Purpose**: Returns whether recording or action replay is active.
- **Parameters / Returns**:
  - **Returns**: `bool` status.
- **OneSync / Networking**: Local check only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_status
        -- Use: Prints recording status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_status', function()
        print(IsRecording())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_status */
    RegisterCommand('rec_status', () => {
      console.log(IsRecording());
    });
    ```
- **Caveats / Limitations**:
  - Returns true for action replay as well.
- **Reference**: https://docs.fivem.net/natives/?n=IsRecording

##### _0x13B350B8AD0EEE10 (0x13B350B8AD0EEE10)
- **Scope**: Client
- **Signature**: `void _0x13B350B8AD0EEE10()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func1
        -- Use: Calls 0x13B350B8AD0EEE10
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func1', function()
        N_0x13B350B8AD0EEE10()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func1 */
    RegisterCommand('rec_func1', () => {
      global.N_0x13B350B8AD0EEE10();
    });
    ```
- **Caveats / Limitations**:
  - Behavior unknown.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?_0x13B350B8AD0EEE10

##### _0x208784099002BC30 (0x208784099002BC30)
- **Scope**: Client
- **Signature**: `void _0x208784099002BC30(char* missionNameLabel, Any p1)`
- **Purpose**: Deprecated/unused; exact behavior unknown.
- **Parameters / Returns**:
  - `missionNameLabel` (`string`): Mission label.
  - `p1` (`any`): Unknown; typically 0.
- **OneSync / Networking**: None.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func2
        -- Use: Calls 0x208784099002BC30
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func2', function()
        N_0x208784099002BC30('mission_label', 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func2 */
    RegisterCommand('rec_func2', () => {
      global.N_0x208784099002BC30('mission_label', 0);
    });
    ```
- **Caveats / Limitations**:
  - Documented as null operation.
  - TODO(next-run): verify usage.
- **Reference**: https://docs.fivem.net/natives/?_0x208784099002BC30

##### _0x293220DA1B46CEBC (0x293220DA1B46CEBC)
- **Scope**: Client
- **Signature**: `void _0x293220DA1B46CEBC(float p0, float p1, int p2)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`float`): Unknown.
  - `p1` (`float`): Unknown.
  - `p2` (`int`): Unknown.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func3
        -- Use: Calls 0x293220DA1B46CEBC
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func3', function()
        N_0x293220DA1B46CEBC(0.0, 0.0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func3 */
    RegisterCommand('rec_func3', () => {
      global.N_0x293220DA1B46CEBC(0.0, 0.0, 0);
    });
    ```
- **Caveats / Limitations**:
  - No documented behavior.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?_0x293220DA1B46CEBC

##### _0x33D47E85B476ABCD (0x33D47E85B476ABCD)
- **Scope**: Client
- **Signature**: `BOOL _0x33D47E85B476ABCD(BOOL p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`bool`): Unknown.
  - **Returns**: `bool` result.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func4
        -- Use: Calls 0x33D47E85B476ABCD
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func4', function()
        print(N_0x33D47E85B476ABCD(true))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func4 */
    RegisterCommand('rec_func4', () => {
      console.log(global.N_0x33D47E85B476ABCD(true));
    });
    ```
- **Caveats / Limitations**:
  - No official description.
  - TODO(next-run): determine purpose.
- **Reference**: https://docs.fivem.net/natives/?_0x33D47E85B476ABCD

##### _0x4282E08174868BE3 (0x4282E08174868BE3)
- **Scope**: Client
- **Signature**: `Any _0x4282E08174868BE3()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: Unknown value.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func5
        -- Use: Calls 0x4282E08174868BE3
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func5', function()
        print(N_0x4282E08174868BE3())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func5 */
    RegisterCommand('rec_func5', () => {
      console.log(global.N_0x4282E08174868BE3());
    });
    ```
- **Caveats / Limitations**:
  - Unknown effect.
  - TODO(next-run): document return value.
- **Reference**: https://docs.fivem.net/natives/?_0x4282E08174868BE3

##### _0x48621C9FCA3EBD28 (0x48621C9FCA3EBD28)
- **Scope**: Client
- **Signature**: `void _0x48621C9FCA3EBD28(int p0)`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - `p0` (`int`): Unknown.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func6
        -- Use: Calls 0x48621C9FCA3EBD28
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func6', function()
        N_0x48621C9FCA3EBD28(0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func6 */
    RegisterCommand('rec_func6', () => {
      global.N_0x48621C9FCA3EBD28(0);
    });
    ```
- **Caveats / Limitations**:
  - No documented behavior.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?_0x48621C9FCA3EBD28

##### _0x66972397E0757E7A (0x66972397E0757E7A)
- **Scope**: Client
- **Signature**: `void _0x66972397E0757E7A(Any p0, Any p1, Any p2)`
- **Purpose**: Does nothing; documented as a null subroutine.
- **Parameters / Returns**:
  - `p0` (`any`): Unused.
  - `p1` (`any`): Unused.
  - `p2` (`any`): Unused.
- **OneSync / Networking**: None.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func7
        -- Use: Calls 0x66972397E0757E7A
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func7', function()
        N_0x66972397E0757E7A(0, 0, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func7 */
    RegisterCommand('rec_func7', () => {
      global.N_0x66972397E0757E7A(0, 0, 0);
    });
    ```
- **Caveats / Limitations**:
  - No effect on gameplay.
- **Reference**: https://docs.fivem.net/natives/?_0x66972397E0757E7A

##### _0x81CBAE94390F9F89 (0x81CBAE94390F9F89)
- **Scope**: Client
- **Signature**: `void _0x81CBAE94390F9F89()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func8
        -- Use: Calls 0x81CBAE94390F9F89
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func8', function()
        N_0x81CBAE94390F9F89()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func8 */
    RegisterCommand('rec_func8', () => {
      global.N_0x81CBAE94390F9F89();
    });
    ```
- **Caveats / Limitations**:
  - Behavior not documented.
  - TODO(next-run): verify effect.
- **Reference**: https://docs.fivem.net/natives/?_0x81CBAE94390F9F89

##### _0xDF4B952F7D381B95 (0xDF4B952F7D381B95)
- **Scope**: Client
- **Signature**: `Any _0xDF4B952F7D381B95()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: Unknown value.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func9
        -- Use: Calls 0xDF4B952F7D381B95
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func9', function()
        print(N_0xDF4B952F7D381B95())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func9 */
    RegisterCommand('rec_func9', () => {
      console.log(global.N_0xDF4B952F7D381B95());
    });
    ```
- **Caveats / Limitations**:
  - Return meaning unknown.
  - TODO(next-run): document behavior.
- **Reference**: https://docs.fivem.net/natives/?_0xDF4B952F7D381B95

##### _0xF854439EFBB3B583 (0xF854439EFBB3B583)
- **Scope**: Client
- **Signature**: `void _0xF854439EFBB3B583()`
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Unknown.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_func10
        -- Use: Calls 0xF854439EFBB3B583
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_func10', function()
        N_0xF854439EFBB3B583()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_func10 */
    RegisterCommand('rec_func10', () => {
      global.N_0xF854439EFBB3B583();
    });
    ```
- **Caveats / Limitations**:
  - No documentation available.
  - TODO(next-run): verify purpose.
- **Reference**: https://docs.fivem.net/natives/?_0xF854439EFBB3B583

##### SaveRecordingClip (0x644546EC5287471B)
- **Scope**: Client
- **Signature**: `BOOL _SAVE_RECORDING_CLIP()`
- **Purpose**: Saves the current action replay clip.
- **Parameters / Returns**:
  - **Returns**: `bool` success.
- **OneSync / Networking**: Local file operation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_save
        -- Use: Saves action replay clip
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_save', function()
        print(SaveRecordingClip())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_save */
    RegisterCommand('rec_save', () => {
      console.log(SaveRecordingClip());
    });
    ```
- **Caveats / Limitations**:
  - Fails if no clip recorded.
- **Reference**: https://docs.fivem.net/natives/?n=SaveRecordingClip

##### StartRecording (0xC3AC2FFF9612AC81)
- **Scope**: Client
- **Signature**: `void _START_RECORDING(int mode)`
- **Purpose**: Begins recording or enables action replay.
- **Parameters / Returns**:
  - `mode` (`int`): 0 = action replay, 1 = full recording.
- **OneSync / Networking**: Local; ensure disk has space.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_start
        -- Use: Starts replay recording
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_start', function()
        StartRecording(1)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_start */
    RegisterCommand('rec_start', () => {
      StartRecording(1);
    });
    ```
- **Caveats / Limitations**:
  - Does nothing if already recording.
- **Reference**: https://docs.fivem.net/natives/?n=StartRecording

##### StopRecordingAndDiscardClip (0x88BB3507ED41A240)
- **Scope**: Client
- **Signature**: `void _STOP_RECORDING_AND_DISCARD_CLIP()`
- **Purpose**: Stops recording and deletes the clip.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Local; cannot be undone.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_discard
        -- Use: Discards current recording
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_discard', function()
        StopRecordingAndDiscardClip()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_discard */
    RegisterCommand('rec_discard', () => {
      StopRecordingAndDiscardClip();
    });
    ```
- **Caveats / Limitations**:
  - Clip is permanently lost.
- **Reference**: https://docs.fivem.net/natives/?n=StopRecordingAndDiscardClip

##### StopRecordingAndSaveClip (0x071A5197D6AFC8B3)
- **Scope**: Client
- **Signature**: `void _STOP_RECORDING_AND_SAVE_CLIP()`
- **Purpose**: Stops recording and saves the clip to disk.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Local operation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_stop_save
        -- Use: Stops and saves recording
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_stop_save', function()
        StopRecordingAndSaveClip()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_stop_save */
    RegisterCommand('rec_stop_save', () => {
      StopRecordingAndSaveClip();
    });
    ```
- **Caveats / Limitations**:
  - Only works if recording active.
- **Reference**: https://docs.fivem.net/natives/?n=StopRecordingAndSaveClip

##### StopRecordingThisFrame (0xEB2D525B57F42B40)
- **Scope**: Client
- **Signature**: `void _STOP_RECORDING_THIS_FRAME()`
- **Purpose**: Temporarily disables recording for the current frame.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_stop_frame
        -- Use: Stops recording for one frame
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_stop_frame', function()
        StopRecordingThisFrame()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_stop_frame */
    RegisterCommand('rec_stop_frame', () => {
      StopRecordingThisFrame();
    });
    ```
- **Caveats / Limitations**:
  - Effect lasts one frame only.
- **Reference**: https://docs.fivem.net/natives/?n=StopRecordingThisFrame

#### Replay

##### ActivateRockstarEditor (0x49DA8145672B2725)
- **Scope**: Client
- **Signature**: `void _ACTIVATE_ROCKSTAR_EDITOR()`
- **Purpose**: Activates the Rockstar Editor mode.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Local operation; no server sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: editor_start
        -- Use: Opens Rockstar Editor
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('editor_start', function()
        ActivateRockstarEditor()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: editor_start */
    RegisterCommand('editor_start', () => {
      ActivateRockstarEditor();
    });
    ```
- **Caveats / Limitations**:
  - Screen fades out; call `DoScreenFadeIn` after leaving.
- **Reference**: https://docs.fivem.net/natives/?n=ActivateRockstarEditor

##### IsInteriorRenderingDisabled (0x95AB8B5C992C7B58)
- **Scope**: Client
- **Signature**: `BOOL _IS_INTERIOR_RENDERING_DISABLED()`
- **Purpose**: Reports whether interior rendering is disabled.
- **Parameters / Returns**:
  - **Returns**: `bool` status.
- **OneSync / Networking**: Local check; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: interior_disabled
        -- Use: Prints interior rendering status
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('interior_disabled', function()
        print(IsInteriorRenderingDisabled())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: interior_disabled */
    RegisterCommand('interior_disabled', () => {
      console.log(IsInteriorRenderingDisabled());
    });
    ```
- **Caveats / Limitations**:
  - When true, normal interiors are invisible.
- **Reference**: https://docs.fivem.net/natives/?n=IsInteriorRenderingDisabled

##### _0x5AD3932DAEB1E5D3
- **Scope**: Client
- **Signature**: `void _0x5AD3932DAEB1E5D3()`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Local effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: replay_disable_render
        -- Use: Calls 0x5AD3932DAEB1E5D3
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('replay_disable_render', function()
        _0x5AD3932DAEB1E5D3()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: replay_disable_render */
    RegisterCommand('replay_disable_render', () => {
      _0x5AD3932DAEB1E5D3();
    });
    ```
- **Caveats / Limitations**:
  - Native disables certain rendering; details unknown.
  - TODO(next-run): verify semantics
- **Reference**: https://docs.fivem.net/natives/?n=0x5AD3932DAEB1E5D3

##### _0x7E2BD3EF6C205F09
- **Scope**: Client
- **Signature**: `void _0x7E2BD3EF6C205F09(char* p0, BOOL p1)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `p0` (`string`): Unknown filter name.
  - `p1` (`bool`): Unknown flag.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: replay_filter
        -- Use: Calls 0x7E2BD3EF6C205F09
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('replay_filter', function()
        _0x7E2BD3EF6C205F09("No_Filter", true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: replay_filter */
    RegisterCommand('replay_filter', () => {
      _0x7E2BD3EF6C205F09("No_Filter", true);
    });
    ```
- **Caveats / Limitations**:
  - Known to do nothing; may be internal stub.
- **Reference**: https://docs.fivem.net/natives/?n=0x7E2BD3EF6C205F09

##### _0xE058175F8EAFE79A
- **Scope**: Client
- **Signature**: `void _0xE058175F8EAFE79A(BOOL p0)`
- **Purpose**: Undocumented/unclear on official docs
- **Parameters / Returns**:
  - `p0` (`bool`): Unknown.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: replay_toggle
        -- Use: Calls 0xE058175F8EAFE79A
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('replay_toggle', function()
        _0xE058175F8EAFE79A(true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: replay_toggle */
    RegisterCommand('replay_toggle', () => {
      _0xE058175F8EAFE79A(true);
    });
    ```
- **Caveats / Limitations**:
  - Effect unknown.
  - TODO(next-run): verify semantics
- **Reference**: https://docs.fivem.net/natives/?n=0xE058175F8EAFE79A

##### ResetEditorValues (0x3353D13F09307691)
- **Scope**: Client
- **Signature**: `void _RESET_EDITOR_VALUES()`
- **Purpose**: Clears internal Rockstar Editor state.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Local.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: editor_reset
        -- Use: Resets Rockstar Editor values
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('editor_reset', function()
        ResetEditorValues()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: editor_reset */
    RegisterCommand('editor_reset', () => {
      ResetEditorValues();
    });
    ```
- **Caveats / Limitations**:
  - Affects local recording flags.
- **Reference**: https://docs.fivem.net/natives/?n=ResetEditorValues


#### Vehicle

##### AddVehiclePhoneExplosiveDevice
- **Scope**: Shared
- **Signature**: `void ADD_VEHICLE_PHONE_EXPLOSIVE_DEVICE(Vehicle vehicle)`
- **Purpose**: Attaches a phone-triggered bomb to the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle handle.
- **OneSync / Networking**: Requires vehicle ownership on server for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: add_bomb; Use: Adds phone bomb; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('add_bomb', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        AddVehiclePhoneExplosiveDevice(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: add_bomb */
    RegisterCommand('add_bomb', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      AddVehiclePhoneExplosiveDevice(veh);
    });
    ```
- **Caveats / Limitations**:
  - Bomb detonation must be handled separately.
- **Reference**: https://docs.fivem.net/natives/?n=AddVehiclePhoneExplosiveDevice

##### AddVehicleStuckCheckWithWarp
- **Scope**: Shared
- **Signature**: `void ADD_VEHICLE_STUCK_CHECK_WITH_WARP(Vehicle vehicle, float p1, int p2, bool p3, bool p4, bool p5, bool p6)`
- **Purpose**: Detects if a vehicle is stuck and optionally warps it to free position.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to monitor.
  - `p1` (`float`): Radius to check.
  - `p2` (`int`): Milliseconds before considered stuck.
  - `p3`-`p6` (`bool`): Undocumented flags.
- **OneSync / Networking**: Server calls require entity ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: stuck; Use: adds stuck monitor; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('stuck', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        AddVehicleStuckCheckWithWarp(veh, 1.0, 1000, true, false, false, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stuck */
    RegisterCommand('stuck', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      AddVehicleStuckCheckWithWarp(veh, 1.0, 1000, true, false, false, false);
    });
    ```
- **Caveats / Limitations**:
  - Flag meanings undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=AddVehicleStuckCheckWithWarp

##### AddVehicleUpsidedownCheck
- **Scope**: Shared
- **Signature**: `void ADD_VEHICLE_UPSIDEDOWN_CHECK(Vehicle vehicle)`
- **Purpose**: Enables internal check for vehicle flipped upside down.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to monitor.
- **OneSync / Networking**: Ownership required server-side.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: flip_check; Use: monitors flip; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('flip_check', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        AddVehicleUpsidedownCheck(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: flip_check */
    RegisterCommand('flip_check', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      AddVehicleUpsidedownCheck(veh);
    });
    ```
- **Caveats / Limitations**:
  - Requires periodic polling with `IsVehicleUpsidedown`.
- **Reference**: https://docs.fivem.net/natives/?n=AddVehicleUpsidedownCheck

##### AreAllVehicleWindowsIntact
- **Scope**: Shared
- **Signature**: `bool ARE_ALL_VEHICLE_WINDOWS_INTACT(Vehicle vehicle)`
- **Purpose**: Checks if every window is unbroken.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` intact status.
- **OneSync / Networking**: Accurate only for entities within visibility.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: win_intact; Use: prints window status; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('win_intact', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(AreAllVehicleWindowsIntact(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: win_intact */
    RegisterCommand('win_intact', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(AreAllVehicleWindowsIntact(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns false for missing vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=AreAllVehicleWindowsIntact

##### AreAnyVehicleSeatsFree
- **Scope**: Shared
- **Signature**: `bool ARE_ANY_VEHICLE_SEATS_FREE(Vehicle vehicle)`
- **Purpose**: Tests if at least one seat is unoccupied.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - **Returns**: `bool` seat availability.
- **OneSync / Networking**: Requires local ped data for remote vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: seat_free; Use: checks seat availability; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('seat_free', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), true)
        print(AreAnyVehicleSeatsFree(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: seat_free */
    RegisterCommand('seat_free', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), true);
      console.log(AreAnyVehicleSeatsFree(veh));
    });
    ```
- **Caveats / Limitations**:
  - Does not account for NPC reservation.
- **Reference**: https://docs.fivem.net/natives/?n=AreAnyVehicleSeatsFree

##### AreVehicleWheelsLinked
- **Scope**: Shared
- **Signature**: `bool ARE_VEHICLE_WHEELS_LINKED(Vehicle vehicle)`
- **Purpose**: Determines if front and rear wheels steer together.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` linkage state.
- **OneSync / Networking**: Local mechanical info; server queries may be outdated.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: wheels_linked; Use: prints linkage; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('wheels_linked', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(AreVehicleWheelsLinked(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wheels_linked */
    RegisterCommand('wheels_linked', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(AreVehicleWheelsLinked(veh));
    });
    ```
- **Caveats / Limitations**:
  - Rarely used outside specialized vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=AreVehicleWheelsLinked

##### AttachVehicleToCargobob
- **Scope**: Shared
- **Signature**: `void ATTACH_VEHICLE_TO_CARGOBOB(Vehicle vehicle, Vehicle cargobob, int p2, float x, float y, float z)`
- **Purpose**: Hooks a vehicle to a cargobob helicopter.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to attach.
  - `cargobob` (`Vehicle`): Cargobob entity.
  - `p2` (`int`): Hook index.
  - `x`, `y`, `z` (`float`): Offset.
- **OneSync / Networking**: Server calls require control of both entities.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: hook_cb; Use: attach to cargobob; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('hook_cb', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local cb = GetVehiclePedIsIn(PlayerPedId(), true)
        AttachVehicleToCargobob(veh, cb, 0, 0.0, 0.0, 0.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hook_cb */
    RegisterCommand('hook_cb', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const cb = GetVehiclePedIsIn(PlayerPedId(), true);
      AttachVehicleToCargobob(veh, cb, 0, 0.0, 0.0, 0.0);
    });
    ```
- **Caveats / Limitations**:
  - Requires correct hook index or will fail silently.
- **Reference**: https://docs.fivem.net/natives/?n=AttachVehicleToCargobob

##### AttachVehicleToTowTruck
- **Scope**: Shared
- **Signature**: `void ATTACH_VEHICLE_TO_TOW_TRUCK(Vehicle towTruck, Vehicle vehicle, int rear, float x, float y, float z)`
- **Purpose**: Connects a vehicle to a tow truck.
- **Parameters / Returns**:
  - `towTruck` (`Vehicle`): Tow truck entity.
  - `vehicle` (`Vehicle`): Vehicle being towed.
  - `rear` (`int`): 0 front, 1 rear.
  - `x`, `y`, `z` (`float`): Offset.
- **OneSync / Networking**: Both entities must be controlled by the caller.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: tow; Use: attach vehicle to tow truck; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('tow', function()
        local tow = GetVehiclePedIsIn(PlayerPedId(), false)
        local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
        AttachVehicleToTowTruck(tow, veh, 1, 0.0, 0.0, 0.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tow */
    RegisterCommand('tow', () => {
      const tow = GetVehiclePedIsIn(PlayerPedId(), false);
      const veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70);
      AttachVehicleToTowTruck(tow, veh, 1, 0.0, 0.0, 0.0);
    });
    ```
- **Caveats / Limitations**:
  - Offsets must align or vehicle will clip.
- **Reference**: https://docs.fivem.net/natives/?n=AttachVehicleToTowTruck

##### AttachVehicleToTrailer
- **Scope**: Shared
- **Signature**: `void ATTACH_VEHICLE_TO_TRAILER(Vehicle vehicle, Vehicle trailer, float radius)`
- **Purpose**: Couples a vehicle with a trailer.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Towing vehicle.
  - `trailer` (`Vehicle`): Trailer entity.
  - `radius` (`float`): Coupling range.
- **OneSync / Networking**: Caller must control both entities.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: trailer; Use: attach trailer; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('trailer', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local trailer = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
        AttachVehicleToTrailer(veh, trailer, 10.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: trailer */
    RegisterCommand('trailer', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const trailer = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70);
      AttachVehicleToTrailer(veh, trailer, 10.0);
    });
    ```
- **Caveats / Limitations**:
  - Use `DetachVehicleFromTrailer` to separate.
- **Reference**: https://docs.fivem.net/natives/?n=AttachVehicleToTrailer

##### BreakOffVehicleWheel
- **Scope**: Shared
- **Signature**: `void BREAK_OFF_VEHICLE_WHEEL(Vehicle vehicle, bool p1, bool p2, bool p3, bool p4)`
- **Purpose**: Detaches a wheel from the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `p1`-`p4` (`bool`): Flags controlling physics and deletion.
- **OneSync / Networking**: Ownership required to replicate wheel removal.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: break_wheel; Use: pops a wheel; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('break_wheel', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        BreakOffVehicleWheel(veh, false, true, true, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: break_wheel */
    RegisterCommand('break_wheel', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      BreakOffVehicleWheel(veh, false, true, true, false);
    });
    ```
- **Caveats / Limitations**:
  - Flags are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=BreakOffVehicleWheel

##### BreakOffVehicleWindow
- **Scope**: Shared
- **Signature**: `void BREAK_OFF_VEHICLE_WINDOW(Vehicle vehicle, int windowIndex)`
- **Purpose**: Detaches a specified window from the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `windowIndex` (`int`): Window ID (0 front left, 1 front right, etc.).
- **OneSync / Networking**: Requires entity control to replicate removal.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: pop_window; Use: removes front left window; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('pop_window', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        BreakOffVehicleWindow(veh, 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: pop_window */
    RegisterCommand('pop_window', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      BreakOffVehicleWindow(veh, 0);
    });
    ```
- **Caveats / Limitations**:
  - Window indices vary by vehicle model.
- **Reference**: https://docs.fivem.net/natives/?n=BreakOffVehicleWindow

##### BringVehicleToHalt
- **Scope**: Shared
- **Signature**: `void BRING_VEHICLE_TO_HALT(Vehicle vehicle, float distance, int duration, bool brake)`
- **Purpose**: Gradually slows a vehicle to a stop within a set distance and time.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to stop.
  - `distance` (`float`): Approximate stopping distance in meters.
  - `duration` (`int`): Time in milliseconds to reach halt.
  - `brake` (`bool`): Apply handbrake when finished.
- **OneSync / Networking**: Entity owner must call for networked vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: halt; Use: stops current vehicle; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('halt', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        BringVehicleToHalt(veh, 5.0, 3000, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: halt */
    RegisterCommand('halt', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      BringVehicleToHalt(veh, 5.0, 3000, true);
    });
    ```
- **Caveats / Limitations**:
  - Vehicle may overshoot if moving too fast.
- **Reference**: https://docs.fivem.net/natives/?n=BringVehicleToHalt

##### CanAnchorBoatHere
- **Scope**: Client
- **Signature**: `bool CAN_ANCHOR_BOAT_HERE(Vehicle boat)`
- **Purpose**: Tests if water depth and conditions allow anchoring at current location.
- **Parameters / Returns**:
  - `boat` (`Vehicle`): Boat to test.
  - **Returns**: `bool` indicating anchoring validity.
- **OneSync / Networking**: Local environmental check.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: can_anchor; Use: prints if boat can anchor; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('can_anchor', function()
        local boat = GetVehiclePedIsIn(PlayerPedId(), false)
        print(CanAnchorBoatHere(boat))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_anchor */
    RegisterCommand('can_anchor', () => {
      const boat = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(CanAnchorBoatHere(boat));
    });
    ```
- **Caveats / Limitations**:
  - Only applies to watercraft.
- **Reference**: https://docs.fivem.net/natives/?n=CanAnchorBoatHere

##### CanBoatBeAnchored
- **Scope**: Client
- **Signature**: `bool CAN_BOAT_BE_ANCHORED(Vehicle boat)`
- **Purpose**: Checks if the boat model supports anchoring.
- **Parameters / Returns**:
  - `boat` (`Vehicle`): Boat handle.
  - **Returns**: `bool` support status.
- **OneSync / Networking**: Local model query.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: can_anchor_model; Use: prints model anchoring capability; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('can_anchor_model', function()
        local boat = GetVehiclePedIsIn(PlayerPedId(), false)
        print(CanBoatBeAnchored(boat))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_anchor_model */
    RegisterCommand('can_anchor_model', () => {
      const boat = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(CanBoatBeAnchored(boat));
    });
    ```
- **Caveats / Limitations**:
  - Returns false for non-boat vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=CanBoatBeAnchored

##### CanBoatBeAnchoredHere
- **Scope**: Client
- **Signature**: `bool CAN_BOAT_BE_ANCHORED_HERE(Vehicle boat)`
- **Purpose**: Determines if the boat can anchor at its current position considering depth and model.
- **Parameters / Returns**:
  - `boat` (`Vehicle`): Boat handle.
  - **Returns**: `bool` indicating feasibility.
- **OneSync / Networking**: Local-only evaluation.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: anchor_here; Use: prints full anchoring check; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('anchor_here', function()
        local boat = GetVehiclePedIsIn(PlayerPedId(), false)
        print(CanBoatBeAnchoredHere(boat))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: anchor_here */
    RegisterCommand('anchor_here', () => {
      const boat = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(CanBoatBeAnchoredHere(boat));
    });
    ```
- **Caveats / Limitations**:
  - Returns false in shallow or obstructed waters.
- **Reference**: https://docs.fivem.net/natives/?n=CanBoatBeAnchoredHere

##### CanShuffleSeat
- **Scope**: Client
- **Signature**: `bool CAN_SHUFFLE_SEAT(Vehicle vehicle, int seatIndex)`
- **Purpose**: Indicates if the local ped can move into the specified seat.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to test.
  - `seatIndex` (`int`): Target seat.
  - **Returns**: `bool` ability result.
- **OneSync / Networking**: Seat changes replicate if entity is networked and caller is owner.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: can_shuffle; Use: prints if seat swap possible; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('can_shuffle', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local seat = tonumber(args[1] or -1)
        print(CanShuffleSeat(veh, seat))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_shuffle */
    RegisterCommand('can_shuffle', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const seat = Number(args[0] || -1);
      console.log(CanShuffleSeat(veh, seat));
    });
    ```
- **Caveats / Limitations**:
  - Does not account for NPC occupants.
- **Reference**: https://docs.fivem.net/natives/?n=CanShuffleSeat

##### CanVehicleParachuteBeActivated
- **Scope**: Client
- **Signature**: `bool CAN_VEHICLE_PARACHUTE_BE_ACTIVATED(Vehicle vehicle)`
- **Purpose**: Checks if the vehicle's parachute system is ready to deploy.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` activation availability.
- **OneSync / Networking**: Local state check; parachute deployment must be replicated by owner.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: can_para; Use: prints if parachute usable; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('can_para', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(CanVehicleParachuteBeActivated(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_para */
    RegisterCommand('can_para', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(CanVehicleParachuteBeActivated(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for vehicles with parachute mods.
- **Reference**: https://docs.fivem.net/natives/?n=CanVehicleParachuteBeActivated

##### ClearVehicleCustomPrimaryColour
- **Scope**: Shared
- **Signature**: `void CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR(Vehicle vehicle)`
- **Purpose**: Removes any custom primary paint, reverting to default.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
- **OneSync / Networking**: Requires entity control for networked vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: clear_color1; Use: clears primary color; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('clear_color1', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ClearVehicleCustomPrimaryColour(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clear_color1 */
    RegisterCommand('clear_color1', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ClearVehicleCustomPrimaryColour(veh);
    });
    ```
- **Caveats / Limitations**:
  - Does not refresh vehicle appearance until resynced.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleCustomPrimaryColour

##### ClearVehicleCustomSecondaryColour
- **Scope**: Shared
- **Signature**: `void CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR(Vehicle vehicle)`
- **Purpose**: Resets custom secondary paint to factory default.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
- **OneSync / Networking**: Caller must own the entity for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: clear_color2; Use: clears secondary color; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('clear_color2', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ClearVehicleCustomSecondaryColour(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clear_color2 */
    RegisterCommand('clear_color2', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ClearVehicleCustomSecondaryColour(veh);
    });
    ```
- **Caveats / Limitations**:
  - Visual update may require entity resync.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleCustomSecondaryColour

##### ClearVehicleDamage
- **Scope**: Shared
- **Signature**: `void CLEAR_VEHICLE_DAMAGE(Vehicle vehicle)`
- **Purpose**: Resets cosmetic damage on the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to repair visually.
- **OneSync / Networking**: Ownership needed for global effect.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: clear_damage; Use: clears visual damage; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('clear_damage', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ClearVehicleDamage(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clear_damage */
    RegisterCommand('clear_damage', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ClearVehicleDamage(veh);
    });
    ```
- **Caveats / Limitations**:
  - Does not fix mechanical damage; use `SetVehicleFixed` for full repair.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleDamage

##### ClearVehicleDecorations
- **Scope**: Shared
- **Signature(s)**: _Unavailable on current docs_
- **Purpose**: Presumed to remove applied vehicle decorations or decals.
- **Parameters / Returns**:
  - **Unknown** — official documentation missing.
- **OneSync / Networking**: Likely requires entity ownership for global effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Placeholder
        -- Name: clear_decor
        -- Use: calls undocumented native
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    ClearVehicleDecorations()
    ```
  - JavaScript:
    ```javascript
    /* Placeholder: clear_decor */
    ClearVehicleDecorations();
    ```
- **Caveats / Limitations**:
  - Not listed in public natives repository; behavior unverified.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleDecorations
  - TODO(next-run): verify semantics.

##### ClearVehicleGeneratorAreaOfInterest
- **Scope**: Shared
- **Signature(s)**: `void CLEAR_VEHICLE_GENERATOR_AREA_OF_INTEREST()`
- **Purpose**: Resumes normal vehicle generator spawning.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: Affects global cargen focus; no ownership needed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reset_cargen
        -- Use: clears vehicle generator focus
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('reset_cargen', function()
        ClearVehicleGeneratorAreaOfInterest()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reset_cargen */
    RegisterCommand('reset_cargen', () => {
      ClearVehicleGeneratorAreaOfInterest();
    });
    ```
- **Caveats / Limitations**:
  - Requires a previously set area via `SetVehicleGeneratorAreaOfInterest`.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleGeneratorAreaOfInterest

##### ClearVehiclePhoneExplosiveDevice
- **Scope**: Shared
- **Signature(s)**: `void _CLEAR_VEHICLE_PHONE_EXPLOSIVE_DEVICE()`
- **Purpose**: Undocumented native; believed to remove a phone explosive from a vehicle.
- **Parameters / Returns**:
  - None.
- **OneSync / Networking**: If it acts on a vehicle, caller should own the entity.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Placeholder
        -- Name: clear_bomb
        -- Use: removes phone explosive
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    _ClearVehiclePhoneExplosiveDevice()
    ```
  - JavaScript:
    ```javascript
    /* Placeholder: clear_bomb */
    _ClearVehiclePhoneExplosiveDevice();
    ```
- **Caveats / Limitations**:
  - Lacks official description.
- **Reference**: https://docs.fivem.net/natives/?n=_CLEAR_VEHICLE_PHONE_EXPLOSIVE_DEVICE
  - TODO(next-run): verify semantics.

##### ClearVehicleRouteHistory
- **Scope**: Shared
- **Signature(s)**: `void CLEAR_VEHICLE_ROUTE_HISTORY(Vehicle vehicle)`
- **Purpose**: Undocumented; likely resets internal route tracking for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
- **OneSync / Networking**: Requires entity control on server for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: clear_route
        -- Use: clears vehicle route history
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('clear_route', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ClearVehicleRouteHistory(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clear_route */
    RegisterCommand('clear_route', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ClearVehicleRouteHistory(veh);
    });
    ```
- **Caveats / Limitations**:
  - Behavior not documented.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleRouteHistory
  - TODO(next-run): verify semantics.

##### CloseBombBayDoors
- **Scope**: Shared
- **Signature(s)**: `void CLOSE_BOMB_BAY_DOORS(Vehicle vehicle)`
- **Purpose**: Closes an aircraft's bomb bay doors.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft with bomb bay.
- **OneSync / Networking**: Caller must own the aircraft for network sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: close_bay
        -- Use: closes bomb bay doors
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('close_bay', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        CloseBombBayDoors(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: close_bay */
    RegisterCommand('close_bay', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      CloseBombBayDoors(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only affects aircraft equipped with bomb bays.
- **Reference**: https://docs.fivem.net/natives/?n=CloseBombBayDoors

##### ControlLandingGear
- **Scope**: Shared
- **Signature(s)**: `void CONTROL_LANDING_GEAR(Vehicle vehicle, int state)`
- **Purpose**: Sets landing gear state for aircraft with retractable gear.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft handle.
  - `state` (`int`): 0 deployed, 1 closing, 2 opening, 3 retracted.
- **OneSync / Networking**: Requires entity control for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: gear
        -- Use: toggles landing gear
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('gear', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ControlLandingGear(veh, tonumber(args[1]) or 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: gear */
    RegisterCommand('gear', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ControlLandingGear(veh, Number(args[0]) || 0);
    });
    ```
- **Caveats / Limitations**:
  - Invalid states are ignored.
- **Reference**: https://docs.fivem.net/natives/?n=ControlLandingGear

##### CopyVehicleDamages
- **Scope**: Shared
- **Signature(s)**: `void COPY_VEHICLE_DAMAGES(Vehicle sourceVehicle, Vehicle targetVehicle)`
- **Purpose**: Mirrors cosmetic damage from one vehicle to another.
- **Parameters / Returns**:
  - `sourceVehicle` (`Vehicle`): Vehicle to copy damage from.
  - `targetVehicle` (`Vehicle`): Vehicle to apply damage to.
- **OneSync / Networking**: Both vehicles must be networked and owned by caller on server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: copy_dmg
        -- Use: copies damage from the player's vehicle to a nearby one
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('copy_dmg', function()
        local src = GetVehiclePedIsIn(PlayerPedId(), false)
        local tgt = GetClosestVehicle(0.0, 0.0, 0.0, 5.0, 0, 70)
        CopyVehicleDamages(src, tgt)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: copy_dmg */
    RegisterCommand('copy_dmg', () => {
      const src = GetVehiclePedIsIn(PlayerPedId(), false);
      const tgt = GetClosestVehicle(0.0, 0.0, 0.0, 5.0, 0, 70);
      CopyVehicleDamages(src, tgt);
    });
    ```
- **Caveats / Limitations**:
  - Mechanical condition is not transferred.
- **Reference**: https://docs.fivem.net/natives/?n=CopyVehicleDamages

##### CreateMissionTrain
- **Scope**: Shared
- **Signature(s)**: `Vehicle CREATE_MISSION_TRAIN(int variation, float x, float y, float z, bool direction, bool isNetwork, bool netMissionEntity)`
- **Purpose**: Spawns a mission-controlled train at given coordinates.
- **Parameters / Returns**:
  - `variation` (`int`): Train layout index.
  - `x`, `y`, `z` (`float`): Spawn coordinates.
  - `direction` (`bool`): Travel direction.
  - `isNetwork` (`bool`): Create as networked entity.
  - `netMissionEntity` (`bool`): Pin to script host.
  - **Returns**: `Vehicle` handle or `0` on failure.
- **OneSync / Networking**: Network flags must be true for cross-client visibility.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: createtrain
        -- Use: spawns freight train variation
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('createtrain', function(_, args)
        local pos = GetEntityCoords(PlayerPedId())
        CreateMissionTrain(tonumber(args[1]) or 17, pos.x, pos.y, pos.z, true, true, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: createtrain */
    RegisterCommand('createtrain', (_src, args) => {
      const pos = GetEntityCoords(PlayerPedId());
      CreateMissionTrain(Number(args[0]) || 17, pos[0], pos[1], pos[2], true, true, true);
    });
    ```
- **Caveats / Limitations**:
  - Train models must be requested beforehand.
- **Reference**: https://docs.fivem.net/natives/?n=CreateMissionTrain

##### CreatePickUpRopeForCargobob
- **Scope**: Shared
- **Signature(s)**: `void CREATE_PICK_UP_ROPE_FOR_CARGOBOB(Vehicle cargobob, int state)`
- **Purpose**: Deploys a hook or magnet from a Cargobob helicopter.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Cargobob handle.
  - `state` (`int`): 0 hook, 1 magnet.
- **OneSync / Networking**: Ownership required to sync rope state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: drop_hook
        -- Use: deploys cargobob hook
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('drop_hook', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        CreatePickUpRopeForCargobob(veh, tonumber(args[1]) or 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: drop_hook */
    RegisterCommand('drop_hook', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      CreatePickUpRopeForCargobob(veh, Number(args[0]) || 0);
    });
    ```
- **Caveats / Limitations**:
  - Only works on Cargobob helicopters.
- **Reference**: https://docs.fivem.net/natives/?n=CreatePickUpRopeForCargobob

##### CreateScriptVehicleGenerator
- **Scope**: Shared
- **Signature(s)**: `int CREATE_SCRIPT_VEHICLE_GENERATOR(float x, float y, float z, float heading, float p4, float p5, Hash modelHash, int p7, int p8, int p9, int p10, bool p11, bool p12, bool p13, bool p14, bool p15, int p16)`
- **Purpose**: Defines a vehicle spawn point managed by script.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Generator position.
  - `heading` (`float`): Spawn heading.
  - `p4`, `p5` (`float`): Unknown, commonly 5.0 and 3.0.
  - `modelHash` (`Hash`): Vehicle model.
  - `p7`–`p10` (`int`): Unknown, typically -1.
  - `p11` (`bool`): Unknown, usually true.
  - `p12`–`p13` (`bool`): Unknown flags, usually false.
  - `p14` (`bool`): Unknown flag.
  - `p15` (`bool`): Unknown, usually true.
  - `p16` (`int`): Unknown, typically -1.
  - **Returns**: `int` generator ID.
- **OneSync / Networking**: Created vehicles need standard entity ownership for sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: make_gen
        -- Use: creates an adder generator at player position
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('make_gen', function()
        local p = GetEntityCoords(PlayerPedId())
        CreateScriptVehicleGenerator(p.x, p.y, p.z, 0.0, 5.0, 3.0, GetHashKey('adder'), -1, -1, -1, -1, true, false, false, false, true, -1)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: make_gen */
    RegisterCommand('make_gen', () => {
      const p = GetEntityCoords(PlayerPedId());
      CreateScriptVehicleGenerator(p[0], p[1], p[2], 0.0, 5.0, 3.0, GetHashKey('adder'), -1, -1, -1, -1, true, false, false, false, true, -1);
    });
    ```
- **Caveats / Limitations**:
  - Many parameters are undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=CreateScriptVehicleGenerator

### Server Natives by Category
#### ACL

##### AddAce
- **Scope**: Server
- **Signature**: `bool ADD_ACE(string principal, string object, bool allow)`
- **Purpose**: Grants or denies a permission for a principal at runtime.
- **Parameters / Returns**:
  - `principal` (`string`): Principal or group receiving the access control entry.
  - `object` (`string`): Permission or object name (e.g., `command.car`).
  - `allow` (`bool`): `true` to allow, `false` to deny.
  - **Returns**: `bool` indicating success.
- **OneSync / Networking**: Server-side ACL only; not replicated to clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: grant_car_command
        -- Use: Allows group.admin to use /car
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    AddEventHandler('onResourceStart', function(res)
        if res == GetCurrentResourceName() then
            AddAce('group.admin', 'command.car', true)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: grant_car_command */
    on('onResourceStart', (res) => {
      if (res === GetCurrentResourceName()) {
        AddAce('group.admin', 'command.car', true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Entries are not persisted; define them in `server.cfg` for permanence.
- **Reference**: https://docs.fivem.net/natives/?n=AddAce

##### AddAceResource
- **Scope**: Server
- **Signature**: `bool ADD_ACE_RESOURCE(string resource, string object, bool allow)`
- **Purpose**: Grants or denies a permission to a resource's principal.
- **Parameters / Returns**:
  - `resource` (`string`): Resource name whose principal is modified.
  - `object` (`string`): Permission or object name.
  - `allow` (`bool`): `true` to allow, `false` to deny.
  - **Returns**: `bool` indicating success.
- **OneSync / Networking**: Server-only ACL modification.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: allow_resource_start
        -- Use: Allows this resource to use start command
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    AddEventHandler('onResourceStart', function(res)
        if res == GetCurrentResourceName() then
            AddAceResource(res, 'command.start', true)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: allow_resource_start */
    on('onResourceStart', (res) => {
      if (res === GetCurrentResourceName()) {
        AddAceResource(res, 'command.start', true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Changes are runtime-only and reset on restart.
- **Reference**: https://docs.fivem.net/natives/?n=AddAceResource

##### AddPrincipal
- **Scope**: Server
- **Signature**: `bool ADD_PRINCIPAL(string child, string parent)`
- **Purpose**: Makes one principal inherit another's permissions.
- **Parameters / Returns**:
  - `child` (`string`): Principal being added (e.g., `identifier.steam:...`).
  - `parent` (`string`): Principal or group to inherit from.
  - **Returns**: `bool` success flag.
- **OneSync / Networking**: No direct networking; affects server ACL graph.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: add_admin
        -- Use: Adds invoking player to group.admin
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('add_admin', function(source)
        local id = GetPlayerIdentifier(source, 0)
        AddPrincipal('identifier.' .. id, 'group.admin')
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: add_admin */
    RegisterCommand('add_admin', (src) => {
      const id = GetPlayerIdentifier(src, 0);
      AddPrincipal('identifier.' + id, 'group.admin');
    });
    ```
- **Caveats / Limitations**:
  - Use cautious validation; identifiers can be spoofed if not verified.
- **Reference**: https://docs.fivem.net/natives/?n=AddPrincipal

##### AddPrincipalResource
- **Scope**: Server
- **Signature**: `bool ADD_PRINCIPAL_RESOURCE(string resource, string parent)`
- **Purpose**: Adds a resource's principal as a child of another principal or group.
- **Parameters / Returns**:
  - `resource` (`string`): Resource name.
  - `parent` (`string`): Principal or group to inherit from.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Server-only ACL graph update.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: resource_inherit_admin
        -- Use: Makes this resource inherit group.admin permissions
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    AddEventHandler('onResourceStart', function(res)
        if res == GetCurrentResourceName() then
            AddPrincipalResource(res, 'group.admin')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: resource_inherit_admin */
    on('onResourceStart', (res) => {
      if (res === GetCurrentResourceName()) {
        AddPrincipalResource(res, 'group.admin');
      }
    });
    ```
- **Caveats / Limitations**:
  - Reset on restart; persist in `server.cfg` as needed.
- **Reference**: https://docs.fivem.net/natives/?n=AddPrincipalResource

##### RemoveAce
- **Scope**: Server
- **Signature**: `bool REMOVE_ACE(string principal, string object)`
- **Purpose**: Deletes an ACE from a principal.
- **Parameters / Returns**:
  - `principal` (`string`): Principal or group.
  - `object` (`string`): Permission to remove.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Server-side only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: revoke_car_command
        -- Use: Removes /car permission from group.admin
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RemoveAce('group.admin', 'command.car')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: revoke_car_command */
    RemoveAce('group.admin', 'command.car');
    ```
- **Caveats / Limitations**:
  - Only affects runtime ACL; restart reverts.
- **Reference**: https://docs.fivem.net/natives/?n=RemoveAce

##### RemoveAceResource
- **Scope**: Server
- **Signature**: `bool REMOVE_ACE_RESOURCE(string resource, string object)`
- **Purpose**: Deletes an ACE from a resource's principal.
- **Parameters / Returns**:
  - `resource` (`string`): Resource name.
  - `object` (`string`): Permission to remove.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Server-only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: revoke_resource_start
        -- Use: Removes start command from this resource
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RemoveAceResource(GetCurrentResourceName(), 'command.start')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: revoke_resource_start */
    RemoveAceResource(GetCurrentResourceName(), 'command.start');
    ```
- **Caveats / Limitations**:
  - Runtime-only; restart restores permissions.
- **Reference**: https://docs.fivem.net/natives/?n=RemoveAceResource

##### RemovePrincipal
- **Scope**: Server
- **Signature**: `bool REMOVE_PRINCIPAL(string child, string parent)`
- **Purpose**: Revokes inheritance of permissions between principals.
- **Parameters / Returns**:
  - `child` (`string`): Principal losing permissions.
  - `parent` (`string`): Principal or group to detach from.
  - **Returns**: `bool` success.
- **OneSync / Networking**: ACL modification only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: remove_admin
        -- Use: Removes invoking player from group.admin
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('remove_admin', function(source)
        local id = GetPlayerIdentifier(source, 0)
        RemovePrincipal('identifier.' .. id, 'group.admin')
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: remove_admin */
    RegisterCommand('remove_admin', (src) => {
      const id = GetPlayerIdentifier(src, 0);
      RemovePrincipal('identifier.' + id, 'group.admin');
    });
    ```
- **Caveats / Limitations**:
  - Only affects current runtime.
- **Reference**: https://docs.fivem.net/natives/?n=RemovePrincipal

##### RemovePrincipalResource
- **Scope**: Server
- **Signature**: `bool REMOVE_PRINCIPAL_RESOURCE(string resource, string parent)`
- **Purpose**: Detaches a resource's principal from another principal or group.
- **Parameters / Returns**:
  - `resource` (`string`): Resource name.
  - `parent` (`string`): Principal or group to detach from.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Server-only ACL adjustment.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: resource_remove_admin
        -- Use: Removes admin inheritance from this resource
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RemovePrincipalResource(GetCurrentResourceName(), 'group.admin')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: resource_remove_admin */
    RemovePrincipalResource(GetCurrentResourceName(), 'group.admin');
    ```
- **Caveats / Limitations**:
  - Non-persistent across restarts.
- **Reference**: https://docs.fivem.net/natives/?n=RemovePrincipalResource

##### IsPlayerAceAllowed
- **Scope**: Server
- **Signature**: `bool IS_PLAYER_ACE_ALLOWED(Player player, string object)`
- **Purpose**: Tests whether a player has a specific permission.
- **Parameters / Returns**:
  - `player` (`Player`): Player ID or `source`.
  - `object` (`string`): Permission to test.
  - **Returns**: `bool` allowed.
- **OneSync / Networking**: Query only; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: can_kick
        -- Use: Reports if invoking player may use /kick
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('can_kick', function(src)
        local msg
        if IsPlayerAceAllowed(src, 'command.kick') then
            msg = 'You can kick players.'
        else
            msg = 'Permission denied.'
        end
        TriggerClientEvent('chat:addMessage', src, { args = { 'System', msg } })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_kick */
    RegisterCommand('can_kick', (src) => {
      const msg = IsPlayerAceAllowed(src, 'command.kick')
        ? 'You can kick players.'
        : 'Permission denied.';
      emitNet('chat:addMessage', src, { args: ['System', msg] });
    });
    ```
- **Caveats / Limitations**:
  - Checks only current runtime ACL state.
- **Reference**: https://docs.fivem.net/natives/?n=IsPlayerAceAllowed

##### IsPrincipalAceAllowed
- **Scope**: Server
- **Signature**: `bool IS_PRINCIPAL_ACE_ALLOWED(string principal, string object)`
- **Purpose**: Tests if a principal or group has a given permission.
- **Parameters / Returns**:
  - `principal` (`string`): Principal or group name.
  - `object` (`string`): Permission to test.
  - **Returns**: `bool` allowed.
- **OneSync / Networking**: Server query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: check_admin_car
        -- Use: Checks if group.admin has /car permission
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local allowed = IsPrincipalAceAllowed('group.admin', 'command.car')
    print('admin can /car:', allowed)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: check_admin_car */
    const allowed = IsPrincipalAceAllowed('group.admin', 'command.car');
    console.log('admin can /car:', allowed);
    ```
- **Caveats / Limitations**:
  - Returns `false` if either principal or ACE is undefined.
- **Reference**: https://docs.fivem.net/natives/?n=IsPrincipalAceAllowed

#### CFX

##### AddStateBagChangeHandler
- **Scope**: Shared
- **Signature(s)**: `int ADD_STATE_BAG_CHANGE_HANDLER(string bagName, string keyFilter, function handler)`
- **Purpose**: Registers a callback that fires whenever a matching state bag key changes.
- **Parameters / Returns**:
  - `bagName` (`string`): Bag name or prefix to match.
  - `keyFilter` (`string`): Key to filter, or `nil` to watch all keys.
  - `handler` (`function`): Callback `(bagName, key, value, reserved, replicated)`.
  - **Returns**: `int` handler ID used with `RemoveStateBagChangeHandler`.
- **OneSync / Networking**: Callback runs on the realm where the change occurs; for entities, ownership dictates who can set values.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Shared Init
        -- Name: watch_lock
        -- Use: Prints when a vehicle lock state bag changes
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local handlerId = AddStateBagChangeHandler('entity:', 'locked', function(bagName, key, value, _reserved, replicated)
        print(('Bag %s key %s -> %s (replicated: %s)'):format(bagName, key, tostring(value), tostring(replicated)))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Shared Init: watch_lock */
    const handlerId = AddStateBagChangeHandler('entity:', 'locked', (bagName, key, value, _reserved, replicated) => {
      console.log(`Bag ${bagName} key ${key} -> ${value} (replicated: ${replicated})`);
    });
    ```
- **Caveats / Limitations**:
  - Remember to remove handlers to prevent leaks.
- **Reference**: https://docs.fivem.net/natives/?n=ADD_STATE_BAG_CHANGE_HANDLER

##### ExecuteCommand
- **Scope**: Server
- **Signature(s)**: `bool EXECUTE_COMMAND(string commandString)`
- **Purpose**: Executes a server console command programmatically.
- **Parameters / Returns**:
  - `commandString` (`string`): Full command line to run.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Commands run on server; effects depend on command.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: restart_weather
        -- Use: Restarts weather script via console command
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('restart_weather', function()
        ExecuteCommand('restart weather')
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: restart_weather */
    RegisterCommand('restart_weather', () => {
      ExecuteCommand('restart weather');
    });
    ```
- **Caveats / Limitations**:
  - Only runs commands available to the server console.
- **Reference**: https://docs.fivem.net/natives/?n=EXECUTE_COMMAND

##### GetCurrentResourceName
- **Scope**: Shared
- **Signature(s)**: `string GET_CURRENT_RESOURCE_NAME()`
- **Purpose**: Returns the name of the currently executing resource.
- **Parameters / Returns**:
  - **Returns**: `string` resource name.
- **OneSync / Networking**: None.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Shared Init
        -- Name: print_res
        -- Use: Prints current resource name on start
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    AddEventHandler('onResourceStart', function(res)
        if res == GetCurrentResourceName() then
            print('Started resource:', res)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Shared Init: print_res */
    on('onResourceStart', (res) => {
      if (res === GetCurrentResourceName()) {
        console.log('Started resource:', res);
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns empty string if called outside a resource context.
- **Reference**: https://docs.fivem.net/natives/?n=GET_CURRENT_RESOURCE_NAME

##### GetNumPlayerIdentifiers
- **Scope**: Server
- **Signature(s)**: `int GET_NUM_PLAYER_IDENTIFIERS(Player player)`
- **Purpose**: Returns how many identifiers the player has (license, steam, etc.).
- **Parameters / Returns**:
  - `player` (`Player`): Player ID.
  - **Returns**: `int` count.
- **OneSync / Networking**: Server query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: id_count
        -- Use: Prints number of identifiers for invoking player
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('id_count', function(src)
        print('Identifiers:', GetNumPlayerIdentifiers(src))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: id_count */
    RegisterCommand('id_count', (src) => {
      console.log('Identifiers:', GetNumPlayerIdentifiers(src));
    });
    ```
- **Caveats / Limitations**:
  - Identifiers depend on user platform and may be missing.
- **Reference**: https://docs.fivem.net/natives/?n=GET_NUM_PLAYER_IDENTIFIERS

##### GetPlayerEndpoint
- **Scope**: Server
- **Signature(s)**: `string GET_PLAYER_ENDPOINT(Player player)`
- **Purpose**: Retrieves the IP endpoint of a player.
- **Parameters / Returns**:
  - `player` (`Player`): Player ID.
  - **Returns**: `string` IP and port.
- **OneSync / Networking**: Server-only; do not expose to clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: show_ip
        -- Use: Logs player endpoint
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('show_ip', function(src)
        print('Endpoint:', GetPlayerEndpoint(src))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: show_ip */
    RegisterCommand('show_ip', (src) => {
      console.log('Endpoint:', GetPlayerEndpoint(src));
    });
    ```
- **Caveats / Limitations**:
  - May return empty string for proxied or disconnected players.
- **Reference**: https://docs.fivem.net/natives/?n=GET_PLAYER_ENDPOINT

##### GetPlayerIdentifier
- **Scope**: Server
- **Signature(s)**: `string GET_PLAYER_IDENTIFIER(Player player, int index)`
- **Purpose**: Returns a specific identifier for a player by index.
- **Parameters / Returns**:
  - `player` (`Player`): Player ID.
  - `index` (`int`): Identifier slot (0..GetNumPlayerIdentifiers-1).
  - **Returns**: `string` identifier or `nil` if out of range.
- **OneSync / Networking**: Server query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: first_id
        -- Use: Prints first identifier of invoking player
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('first_id', function(src)
        print('First identifier:', GetPlayerIdentifier(src, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: first_id */
    RegisterCommand('first_id', (src) => {
      console.log('First identifier:', GetPlayerIdentifier(src, 0));
    });
    ```
- **Caveats / Limitations**:
  - Identifier order is not guaranteed.
- **Reference**: https://docs.fivem.net/natives/?n=GET_PLAYER_IDENTIFIER

##### GetPlayerName
- **Scope**: Server
- **Signature(s)**: `string GET_PLAYER_NAME(Player player)`
- **Purpose**: Returns the player’s display name.
- **Parameters / Returns**:
  - `player` (`Player`): Player ID.
  - **Returns**: `string` name.
- **OneSync / Networking**: Server query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: whoami
        -- Use: Replies with your player name
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('whoami', function(src)
        TriggerClientEvent('chat:addMessage', src, { args = { 'System', GetPlayerName(src) } })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: whoami */
    RegisterCommand('whoami', (src) => {
      emitNet('chat:addMessage', src, { args: ['System', GetPlayerName(src)] });
    });
    ```
- **Caveats / Limitations**:
  - Name can be changed by user; do not rely for identity.
- **Reference**: https://docs.fivem.net/natives/?n=GET_PLAYER_NAME

##### GetPlayerPing
- **Scope**: Server
- **Signature(s)**: `int GET_PLAYER_PING(Player player)`
- **Purpose**: Returns the network latency in milliseconds for a player.
- **Parameters / Returns**:
  - `player` (`Player`): Player ID.
  - **Returns**: `int` ping.
- **OneSync / Networking**: Server query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: my_ping
        -- Use: Prints your current ping
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('my_ping', function(src)
        print('Ping:', GetPlayerPing(src))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: my_ping */
    RegisterCommand('my_ping', (src) => {
      console.log('Ping:', GetPlayerPing(src));
    });
    ```
- **Caveats / Limitations**:
  - Values can fluctuate rapidly; avoid spamming queries.
- **Reference**: https://docs.fivem.net/natives/?n=GET_PLAYER_PING

##### GetPlayers
- **Scope**: Server
- **Signature(s)**: `table GET_PLAYERS()`
- **Purpose**: Returns an array of active player IDs.
- **Parameters / Returns**:
  - **Returns**: `table` of player sources.
- **OneSync / Networking**: Server query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: list_players
        -- Use: Prints all connected player IDs
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('list_players', function()
        for _, id in ipairs(GetPlayers()) do
            print('Player ID:', id)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: list_players */
    RegisterCommand('list_players', () => {
      for (const id of GetPlayers()) {
        console.log('Player ID:', id);
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns empty table if no players are connected.
- **Reference**: https://docs.fivem.net/natives/?n=GET_PLAYERS

##### GetResourceKvpInt
- **Scope**: Server
- **Signature(s)**: `int GET_RESOURCE_KVP_INT(string key)`
- **Purpose**: Reads an integer value from the resource key-value store.
- **Parameters / Returns**:
  - `key` (`string`): Key name.
  - **Returns**: `int` stored value or `0` if missing.
- **OneSync / Networking**: Server-only storage; not replicated.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: load_counter
        -- Use: Loads a startup counter from KVP and prints it
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local count = GetResourceKvpInt('startup_counter')
    print('Startup count:', count)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: load_counter */
    const count = GetResourceKvpInt('startup_counter');
    console.log('Startup count:', count);
    ```
- **Caveats / Limitations**:
  - Returns 0 when key is absent or non-integer.
- **Reference**: https://docs.fivem.net/natives/?n=GET_RESOURCE_KVP_INT
##### GetResourceKvpString
- **Scope**: Server
- **Signature(s)**: `string GET_RESOURCE_KVP_STRING(string key)`
- **Purpose**: Reads a string value from the resource key-value store.
- **Parameters / Returns**:
  - `key` (`string`): Key name.
  - **Returns**: `string` stored value or empty string.
- **OneSync / Networking**: Server-only storage; not replicated.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: load_name
        -- Use: Loads a server name from KVP and prints it
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local name = GetResourceKvpString('server_name')
    print('Server name:', name)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: load_name */
    const name = GetResourceKvpString('server_name');
    console.log('Server name:', name);
    ```
- **Caveats / Limitations**:
  - Returns empty string if the key is absent.
- **Reference**: https://docs.fivem.net/natives/?n=GET_RESOURCE_KVP_STRING

##### GetResourceMetadata
- **Scope**: Shared
- **Signature(s)**: `string GET_RESOURCE_METADATA(string resourceName, string metadataKey, int index)`
- **Purpose**: Retrieves a metadata value from a resource's fxmanifest.
- **Parameters / Returns**:
  - `resourceName` (`string`): Target resource.
  - `metadataKey` (`string`): Manifest field name.
  - `index` (`int`): Zero-based index for multiple values.
  - **Returns**: `string` value or `nil` if missing.
- **OneSync / Networking**: None; local lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Shared Init
        -- Name: print_version
        -- Use: Prints version metadata from this resource
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local ver = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    print('Resource version:', ver)
    ```
  - JavaScript:
    ```javascript
    /* Shared Init: print_version */
    const ver = GetResourceMetadata(GetCurrentResourceName(), 'version', 0);
    console.log('Resource version:', ver);
    ```
- **Caveats / Limitations**:
  - Indexes start at 0; out-of-range returns `null`.
- **Reference**: https://docs.fivem.net/natives/?n=GET_RESOURCE_METADATA

##### GetResourcePath
- **Scope**: Server
- **Signature(s)**: `string GET_RESOURCE_PATH(string resourceName)`
- **Purpose**: Returns the filesystem path for a resource.
- **Parameters / Returns**:
  - `resourceName` (`string`): Resource to query.
  - **Returns**: `string` absolute path.
- **OneSync / Networking**: Server-only; exposes server file paths.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: print_path
        -- Use: Displays path to a resource
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    print('Path:', GetResourcePath('chat'))
    ```
  - JavaScript:
    ```javascript
    /* Server Init: print_path */
    console.log('Path:', GetResourcePath('chat'));
    ```
- **Caveats / Limitations**:
  - Avoid exposing paths to untrusted clients.
- **Reference**: https://docs.fivem.net/natives/?n=GET_RESOURCE_PATH

##### GetResourceState
- **Scope**: Server
- **Signature(s)**: `string GET_RESOURCE_STATE(string resourceName)`
- **Purpose**: Reports the current state of a resource (e.g., started, stopped).
- **Parameters / Returns**:
  - `resourceName` (`string`): Resource to query.
  - **Returns**: `string` state name.
- **OneSync / Networking**: Server query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: res_state
        -- Use: Prints state of a resource
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('res_state', function(_, args)
        print(GetResourceState(args[1] or 'chat'))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: res_state */
    RegisterCommand('res_state', (_src, args) => {
      console.log(GetResourceState(args[0] || 'chat'));
    });
    ```
- **Caveats / Limitations**:
  - Returns `missing` for unknown resources.
- **Reference**: https://docs.fivem.net/natives/?n=GET_RESOURCE_STATE

##### GetResourceTime
- **Scope**: Shared
- **Signature(s)**: `int GET_RESOURCE_TIME()`
- **Purpose**: Returns milliseconds since the current resource started.
- **Parameters / Returns**:
  - **Returns**: `int` elapsed ms.
- **OneSync / Networking**: None; local timer.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: uptime
        -- Use: Prints resource uptime
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('uptime', function()
        print('Uptime ms:', GetResourceTime())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: uptime */
    RegisterCommand('uptime', () => {
      console.log('Uptime ms:', GetResourceTime());
    });
    ```
- **Caveats / Limitations**:
  - Resets when resource restarts.
- **Reference**: https://docs.fivem.net/natives/?n=GET_RESOURCE_TIME

##### HasStateBagValue
- **Scope**: Shared
- **Signature(s)**: `bool HAS_STATE_BAG_VALUE(string bagName, string key)`
- **Purpose**: Checks if a state bag contains a specific key.
- **Parameters / Returns**:
  - `bagName` (`string`): Bag identifier or prefix.
  - `key` (`string`): Key to check.
  - **Returns**: `bool` presence.
- **OneSync / Networking**: Respects entity ownership for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Shared Function
        -- Name: has_locked
        -- Use: Tests if a vehicle has a 'locked' state bag key
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local vehicleBag = ('entity:%s'):format(veh)
    if HasStateBagValue(vehicleBag, 'locked') then
        print('Vehicle lock state exists')
    end
    ```
  - JavaScript:
    ```javascript
    /* Shared Function: has_locked */
    const vehicleBag = `entity:${veh}`;
    if (HasStateBagValue(vehicleBag, 'locked')) {
      console.log('Vehicle lock state exists');
    }
    ```
- **Caveats / Limitations**:
  - Only checks existence, not value.
- **Reference**: https://docs.fivem.net/natives/?n=HAS_STATE_BAG_VALUE

##### IsAceAllowed
- **Scope**: Server
- **Signature(s)**: `bool IS_ACE_ALLOWED(string object, string permission)`
- **Purpose**: Tests if a principal has a given permission.
- **Parameters / Returns**:
  - `object` (`string`): Principal name (e.g., `identifier.fivem:123`).
  - `permission` (`string`): ACE to test.
  - **Returns**: `bool` result.
- **OneSync / Networking**: Server-only ACL check.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: can_kick
        -- Use: Prints if a principal can use kick command
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('can_kick', function(src)
        print(IsAceAllowed(('player.%s'):format(src), 'command.kick'))
    end, true)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_kick */
    RegisterCommand('can_kick', (src) => {
      console.log(IsAceAllowed(`player.${src}`, 'command.kick'));
    }, true);
    ```
- **Caveats / Limitations**:
  - Requires ACL to be configured.
- **Reference**: https://docs.fivem.net/natives/?n=IS_ACE_ALLOWED

##### IsDuplicityVersion
- **Scope**: Shared
- **Signature(s)**: `bool IS_DUPLICITY_VERSION()`
- **Purpose**: Indicates if code is running on the server.
- **Parameters / Returns**:
  - **Returns**: `bool` true on server, false on client.
- **OneSync / Networking**: None.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Shared Function
        -- Name: check_realm
        -- Use: Prints realm information
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    if IsDuplicityVersion() then
        print('Running on server')
    else
        print('Running on client')
    end
    ```
  - JavaScript:
    ```javascript
    /* Shared Function: check_realm */
    if (IsDuplicityVersion()) {
      console.log('Running on server');
    } else {
      console.log('Running on client');
    }
    ```
- **Caveats / Limitations**:
  - Useful for shared scripts to branch logic.
- **Reference**: https://docs.fivem.net/natives/?n=IS_DUPLICITY_VERSION

##### IsPlayerAceAllowed
- **Scope**: Server
- **Signature(s)**: `bool IS_PLAYER_ACE_ALLOWED(Player player, string permission)`
- **Purpose**: Checks if a player has a specific permission via ACL.
- **Parameters / Returns**:
  - `player` (`Player`): Player ID.
  - `permission` (`string`): ACE to test.
  - **Returns**: `bool` result.
- **OneSync / Networking**: Server ACL query.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: is_admin
        -- Use: Tells player if they have admin permission
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('is_admin', function(src)
        local allowed = IsPlayerAceAllowed(src, 'admin')
        TriggerClientEvent('chat:addMessage', src, { args = { 'System', tostring(allowed) } })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: is_admin */
    RegisterCommand('is_admin', (src) => {
      const allowed = IsPlayerAceAllowed(src, 'admin');
      emitNet('chat:addMessage', src, { args: ['System', String(allowed)] });
    });
    ```
- **Caveats / Limitations**:
  - Permission checks are case-sensitive.
- **Reference**: https://docs.fivem.net/natives/?n=IS_PLAYER_ACE_ALLOWED

##### IsPrincipalAceAllowed
- **Scope**: Server
- **Signature(s)**: `bool IS_PRINCIPAL_ACE_ALLOWED(string principal, string permission)`
- **Purpose**: Tests if a principal has an ACE without resolving player ID.
- **Parameters / Returns**:
  - `principal` (`string`): Principal name (e.g., `group.admin`).
  - `permission` (`string`): ACE to test.
  - **Returns**: `bool` result.
- **OneSync / Networking**: Server ACL query.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: check_group
        -- Use: Logs if admin group has restart permission
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    print('Admin can restart?', IsPrincipalAceAllowed('group.admin', 'command.restart'))
    ```
  - JavaScript:
    ```javascript
    /* Server Init: check_group */
    console.log('Admin can restart?', IsPrincipalAceAllowed('group.admin', 'command.restart'));
    ```
- **Caveats / Limitations**:
  - Principals must be defined in ACL.
- **Reference**: https://docs.fivem.net/natives/?n=IS_PRINCIPAL_ACE_ALLOWED

##### LoadResourceFile
- **Scope**: Server
- **Signature(s)**: `string LOAD_RESOURCE_FILE(string resourceName, string fileName)`
- **Purpose**: Reads the contents of a file within a resource at runtime.
- **Parameters / Returns**:
  - `resourceName` (`string`): Resource to read from.
  - `fileName` (`string`): Relative path inside the resource.
  - **Returns**: `string` file data or `nil` if not found.
- **OneSync / Networking**: Server-side only; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: show_manifest
        -- Use: Prints fxmanifest of another resource
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local manifest = LoadResourceFile('chat', 'fxmanifest.lua')
    print(manifest)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: show_manifest */
    const manifest = LoadResourceFile('chat', 'fxmanifest.lua');
    console.log(manifest);
    ```
- **Caveats / Limitations**:
  - Cannot read files outside the resource or stream data larger than memory.
- **Reference**: https://docs.fivem.net/natives/?n=LoadResourceFile

##### PerformHttpRequest
- **Scope**: Server
- **Signature(s)**: `void PERFORM_HTTP_REQUEST(string url, function cb, string method = 'GET', string data = '', table headers = {})`
- **Purpose**: Sends an asynchronous HTTP request and invokes a callback with the result.
- **Parameters / Returns**:
  - `url` (`string`): Target URL.
  - `cb` (`function`): Callback `(statusCode, body, headers)`.
  - `method` (`string`, default `"GET"`): HTTP method.
  - `data` (`string`, default `""`): Request body.
  - `headers` (`table`, default `{}`): Additional HTTP headers.
- **OneSync / Networking**: Runs on server thread; avoid long callbacks to prevent blocking.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: fetch_status
        -- Use: Requests example.com and logs status code
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    PerformHttpRequest('https://example.com', function(status, body, headers)
        print('Status:', status)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: fetch_status */
    PerformHttpRequest('https://example.com', (status, body, headers) => {
      console.log('Status:', status);
    });
    ```
- **Caveats / Limitations**:
  - Callback runs in the scheduler; heavy processing can stall other tasks.
- **Reference**: https://docs.fivem.net/natives/?n=PerformHttpRequest

##### RegisterCommand
- **Scope**: Server
- **Signature(s)**: `void REGISTER_COMMAND(string commandName, function handler, bool restricted)`
- **Purpose**: Registers a console/chat command and associates it with a handler function.
- **Parameters / Returns**:
  - `commandName` (`string`): Command name without prefix.
  - `handler` (`function`): `(source, args, rawCommand)` callback.
  - `restricted` (`bool`): If `true`, ACL permission `command.<name>` is required.
- **OneSync / Networking**: Handler runs on server; use ACL to gate sensitive actions.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: announce
        -- Use: Broadcasts a message to all players
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('announce', function(source, args)
        TriggerClientEvent('chat:addMessage', -1, { args = { 'Server', table.concat(args, ' ') } })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: announce */
    RegisterCommand('announce', (src, args) => {
      emitNet('chat:addMessage', -1, { args: ['Server', args.join(' ')] });
    });
    ```
- **Caveats / Limitations**:
  - Without `restricted` true, any player may execute the command.
- **Reference**: https://docs.fivem.net/natives/?n=RegisterCommand

##### RegisterNetEvent
- **Scope**: Shared
- **Signature(s)**: `void REGISTER_NET_EVENT(string eventName)`
- **Purpose**: Declares a network event so other resources or clients can trigger it.
- **Parameters / Returns**:
  - `eventName` (`string`): Event identifier.
- **OneSync / Networking**: Allows cross-resource and client↔server communication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Event
        -- Name: log_chat
        -- Use: Receives chatLog events from clients
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterNetEvent('chatLog')
    AddEventHandler('chatLog', function(msg)
        print(('Player %s says: %s'):format(source, msg))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Server Event: log_chat */
    RegisterNetEvent('chatLog');
    onNet('chatLog', (msg) => {
      console.log(`Player ${source} says: ${msg}`);
    });
    ```
- **Caveats / Limitations**:
  - Events from clients need validation to prevent abuse.
- **Reference**: https://docs.fivem.net/natives/?n=RegisterNetEvent

##### RegisterServerEvent
- **Scope**: Server
- **Signature(s)**: `void REGISTER_SERVER_EVENT(string eventName)`
- **Purpose**: Alias of `RegisterNetEvent` for server-side clarity.
- **Parameters / Returns**:
  - `eventName` (`string`): Event identifier.
- **OneSync / Networking**: Same behavior as `RegisterNetEvent`.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Event
        -- Name: log_score
        -- Use: Logs client-reported score updates
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterServerEvent('scoreUpdate')
    AddEventHandler('scoreUpdate', function(score)
        print(('Score from %s: %s'):format(source, score))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Server Event: log_score */
    RegisterServerEvent('scoreUpdate');
    onNet('scoreUpdate', (score) => {
      console.log(`Score from ${source}: ${score}`);
    });
    ```
- **Caveats / Limitations**:
  - Still requires `RegisterNetEvent` for client-side listening.
- **Reference**: https://docs.fivem.net/natives/?n=RegisterServerEvent

##### RemoveStateBagChangeHandler
- **Scope**: Shared
- **Signature(s)**: `void REMOVE_STATE_BAG_CHANGE_HANDLER(int handlerId)`
- **Purpose**: Unregisters a previously added state bag change handler.
- **Parameters / Returns**:
  - `handlerId` (`int`): ID returned by `AddStateBagChangeHandler`.
- **OneSync / Networking**: Ensures no further callbacks for that handler.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Shared Cleanup
        -- Name: stop_watch
        -- Use: Removes state bag handler when no longer needed
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local id = AddStateBagChangeHandler('entity:', 'locked', function() end)
    RemoveStateBagChangeHandler(id)
    ```
  - JavaScript:
    ```javascript
    /* Shared Cleanup: stop_watch */
    const id = AddStateBagChangeHandler('entity:', 'locked', () => {});
    RemoveStateBagChangeHandler(id);
    ```
- **Caveats / Limitations**:
  - Calling with an invalid ID has no effect.
- **Reference**: https://docs.fivem.net/natives/?n=RemoveStateBagChangeHandler

##### SaveResourceFile
- **Scope**: Server
- **Signature(s)**: `bool SAVE_RESOURCE_FILE(string resourceName, string fileName, string data, int dataLength)`
- **Purpose**: Writes data to a file inside a resource on disk.
- **Parameters / Returns**:
  - `resourceName` (`string`): Target resource.
  - `fileName` (`string`): Relative path to write.
  - `data` (`string`): Content to save.
  - `dataLength` (`int`): Length of `data` in bytes.
  - **Returns**: `bool` success flag.
- **OneSync / Networking**: Server-side persistence; clients do not see files until next resource load.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: save_counter
        -- Use: Stores a startup counter in a file
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local count = 1
    SaveResourceFile(GetCurrentResourceName(), 'counter.txt', tostring(count), #tostring(count))
    ```
  - JavaScript:
    ```javascript
    /* Server Init: save_counter */
    const count = 1;
    SaveResourceFile(GetCurrentResourceName(), 'counter.txt', String(count), String(count).length);
    ```
- **Caveats / Limitations**:
  - Files cannot be written outside the resource directory.
- **Reference**: https://docs.fivem.net/natives/?n=SaveResourceFile

##### SetConvar
- **Scope**: Server
- **Signature(s)**: `void SET_CONVAR(string varName, string value)`
- **Purpose**: Sets a runtime console variable only accessible on the server.
- **Parameters / Returns**:
  - `varName` (`string`): ConVar name.
  - `value` (`string`): New value.
- **OneSync / Networking**: Not replicated to clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: set_password
        -- Use: Updates rcon password at runtime
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    SetConvar('rcon_password', 'changeme')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: set_password */
    SetConvar('rcon_password', 'changeme');
    ```
- **Caveats / Limitations**:
  - Value resets on server restart.
- **Reference**: https://docs.fivem.net/natives/?n=SetConvar

##### SetConvarReplicated
- **Scope**: Server
- **Signature(s)**: `void SET_CONVAR_REPLICATED(string varName, string value)`
- **Purpose**: Sets a ConVar whose value is replicated to clients.
- **Parameters / Returns**:
  - `varName` (`string`): ConVar name.
  - `value` (`string`): New value.
- **OneSync / Networking**: Replicated to all clients; changes after join will update automatically.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: set_hostname
        -- Use: Sets public server name
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    SetConvarReplicated('sv_hostname', 'SunnyRP Test Server')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: set_hostname */
    SetConvarReplicated('sv_hostname', 'SunnyRP Test Server');
    ```
- **Caveats / Limitations**:
  - Large values may exceed network limits.
- **Reference**: https://docs.fivem.net/natives/?n=SetConvarReplicated

##### SetConvarServerInfo
- **Scope**: Server
- **Signature(s)**: `void SET_CONVAR_SERVER_INFO(string varName, string value)`
- **Purpose**: Sets a replicated ConVar marked as public server info for server lists.
- **Parameters / Returns**:
  - `varName` (`string`): ConVar name.
  - `value` (`string`): Value broadcast to clients and server listings.
- **OneSync / Networking**: Replicated to clients and shown in server info queries.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: set_mapname
        -- Use: Announces current map in server info
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    SetConvarServerInfo('mapname', 'Los Santos')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: set_mapname */
    SetConvarServerInfo('mapname', 'Los Santos');
    ```
- **Caveats / Limitations**:
  - Intended for short metadata strings only.
- **Reference**: https://docs.fivem.net/natives/?n=SetConvarServerInfo
##### SetGameType
- **Scope**: Server
- **Signature(s)**: `void SET_GAME_TYPE(string gametype)`
- **Purpose**: Sets a custom game type string shown in server listings.
- **Parameters / Returns**:
  - `gametype` (`string`): Label displayed to clients and in server browsers.
  - **Returns**: None.
- **OneSync / Networking**: Broadcast to all clients and used for external server queries.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: set_gametype
        -- Use: Sets the server game type
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    SetGameType('SunnyRP')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: set_gametype */
    SetGameType('SunnyRP');
    ```
- **Caveats / Limitations**:
  - Purely informational; does not enforce any mode.
- **Reference**: https://docs.fivem.net/natives/?n=SetGameType

##### SetHttpHandler
- **Scope**: Server
- **Signature(s)**: `void SET_HTTP_HANDLER(function handler)`
- **Purpose**: Registers a callback to respond to HTTP requests hitting the FXServer port.
- **Parameters / Returns**:
  - `handler` (`function`): Receives `(req, res)` objects and writes responses.
  - **Returns**: None.
- **OneSync / Networking**: Runs on server side only; unrelated to game networking.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Server Init
        -- Name: simple_http
        -- Use: Responds with plain text
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    SetHttpHandler(function(req, res)
        if req.path == '/' then
            res.send('ok')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: simple_http */
    SetHttpHandler((req, res) => {
      if (req.path === '/') {
        res.send('ok');
      }
    });
    ```
- **Caveats / Limitations**:
  - Handler replaces any previous handler.
- **Reference**: https://docs.fivem.net/natives/?n=SetHttpHandler

##### SetInterval
- **Scope**: Server
- **Signature(s)**: `int SET_INTERVAL(function callback, int interval)`
- **Purpose**: Schedules a function to run repeatedly at the given interval.
- **Parameters / Returns**:
  - `callback` (`function`): Function executed every cycle.
  - `interval` (`number`): Delay in milliseconds.
  - **Returns**: `number` timer identifier.
- **OneSync / Networking**: Local to server runtime.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Timer
        -- Name: heartbeat
        -- Use: Prints a log every second
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    local t = SetInterval(function()
        print('heartbeat')
    end, 1000)
    ```
  - JavaScript:
    ```javascript
    /* Timer: heartbeat */
    const t = SetInterval(() => {
      console.log('heartbeat');
    }, 1000);
    ```
- **Caveats / Limitations**:
  - Clear the interval with `ClearInterval` to prevent leaks.
- **Reference**: https://docs.fivem.net/natives/?n=SetInterval

##### SetMapName
- **Scope**: Server
- **Signature(s)**: `void SET_MAP_NAME(string mapName)`
- **Purpose**: Defines the map name presented in server browsers.
- **Parameters / Returns**:
  - `mapName` (`string`): Map label.
  - **Returns**: None.
- **OneSync / Networking**: Replicated as server info.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Server Init; Name: set_map; Use: sets map name; Created: 2025-09-11; By: VSSVSSN ]]
    SetMapName('Los Santos')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: set_map */
    SetMapName('Los Santos');
    ```
- **Caveats / Limitations**:
  - Informational only.
- **Reference**: https://docs.fivem.net/natives/?n=SetMapName

##### SetPlayerRoutingBucket
- **Scope**: Server
- **Signature(s)**: `void SET_PLAYER_ROUTING_BUCKET(Player playerSrc, int bucket)`
- **Purpose**: Moves a player into a specific routing bucket (instance).
- **Parameters / Returns**:
  - `playerSrc` (`Player`): Source ID.
  - `bucket` (`number`): Target bucket ID.
  - **Returns**: None.
- **OneSync / Networking**: Requires OneSync; affects entity visibility for the player.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: bucket; Use: swap player bucket; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('bucket', function(src, args)
        SetPlayerRoutingBucket(src, tonumber(args[1]) or 0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: bucket */
    RegisterCommand('bucket', (src, args) => {
      SetPlayerRoutingBucket(src, Number(args[0]) || 0);
    });
    ```
- **Caveats / Limitations**:
  - Player entities migrate on next frame; ensure cleanup in old bucket.
- **Reference**: https://docs.fivem.net/natives/?n=SetPlayerRoutingBucket

##### SetRoutingBucketEntityLockdownMode
- **Scope**: Server
- **Signature(s)**: `void SET_ROUTING_BUCKET_ENTITY_LOCKDOWN_MODE(int bucket, string mode)`
- **Purpose**: Controls whether foreign entities can migrate into the bucket.
- **Parameters / Returns**:
  - `bucket` (`number`): Bucket ID.
  - `mode` (`string`): "strict" blocks, "relaxed" allows.
  - **Returns**: None.
- **OneSync / Networking**: OneSync required; influences cross-bucket entity replication.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Server Init; Name: lockdown; Use: sets lockdown to strict; Created: 2025-09-11; By: VSSVSSN ]]
    SetRoutingBucketEntityLockdownMode(1, 'strict')
    ```
  - JavaScript:
    ```javascript
    /* Server Init: lockdown */
    SetRoutingBucketEntityLockdownMode(1, 'strict');
    ```
- **Caveats / Limitations**:
  - Use carefully to avoid orphaned entities.
- **Reference**: https://docs.fivem.net/natives/?n=SetRoutingBucketEntityLockdownMode

##### SetRoutingBucketPopulationEnabled
- **Scope**: Server
- **Signature(s)**: `void SET_ROUTING_BUCKET_POPULATION_ENABLED(int bucket, bool enabled)`
- **Purpose**: Toggles ambient population generation within a bucket.
- **Parameters / Returns**:
  - `bucket` (`number`): Bucket ID.
  - `enabled` (`boolean`): Enable or disable.
  - **Returns**: None.
- **OneSync / Networking**: OneSync required; affects new ambient peds/vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Server Init; Name: pop_disable; Use: disables population in bucket 2; Created: 2025-09-11; By: VSSVSSN ]]
    SetRoutingBucketPopulationEnabled(2, false)
    ```
  - JavaScript:
    ```javascript
    /* Server Init: pop_disable */
    SetRoutingBucketPopulationEnabled(2, false);
    ```
- **Caveats / Limitations**:
  - Existing population remains until removed manually.
- **Reference**: https://docs.fivem.net/natives/?n=SetRoutingBucketPopulationEnabled

##### SetTimeout
- **Scope**: Server
- **Signature(s)**: `int SET_TIMEOUT(function callback, int ms)`
- **Purpose**: Executes a function once after the specified delay.
- **Parameters / Returns**:
  - `callback` (`function`): Function to run.
  - `ms` (`number`): Delay in milliseconds.
  - **Returns**: `number` timer identifier.
- **OneSync / Networking**: Local to server runtime.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Timer; Name: delayed_msg; Use: prints after 1s; Created: 2025-09-11; By: VSSVSSN ]]
    SetTimeout(function()
        print('delayed')
    end, 1000)
    ```
  - JavaScript:
    ```javascript
    /* Timer: delayed_msg */
    SetTimeout(() => {
      console.log('delayed');
    }, 1000);
    ```
- **Caveats / Limitations**:
  - Clear with `ClearTimeout` if not needed.
- **Reference**: https://docs.fivem.net/natives/?n=SetTimeout

##### StartFindKvp
- **Scope**: Server
- **Signature(s)**: `int START_FIND_KVP(string prefix)`
- **Purpose**: Begins an iteration over key-value pairs with the given prefix.
- **Parameters / Returns**:
  - `prefix` (`string`): Key prefix to search.
  - **Returns**: `number` search handle.
- **OneSync / Networking**: Local to server storage.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Utility; Name: list_kvp; Use: logs all KVP keys starting with 'cfg'; Created: 2025-09-11; By: VSSVSSN ]]
    local h = StartFindKvp('cfg')
    while true do
        local k = FindKvp(h)
        if not k then break end
        print(k)
    end
    EndFindKvp(h)
    ```
  - JavaScript:
    ```javascript
    /* Utility: list_kvp */
    const h = StartFindKvp('cfg');
    for (;;) {
      const k = FindKvp(h);
      if (!k) break;
      console.log(k);
    }
    EndFindKvp(h);
    ```
- **Caveats / Limitations**:
  - Use `EndFindKvp` to release handles.
- **Reference**: https://docs.fivem.net/natives/?n=StartFindKvp

##### StartResource
- **Scope**: Server
- **Signature(s)**: `BOOL START_RESOURCE(string resourceName)`
- **Purpose**: Starts the specified resource.
- **Parameters / Returns**:
  - `resourceName` (`string`): Name of resource.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Triggers resource start which may register events/net handlers.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Admin Cmd; Name: start_res; Use: starts a resource; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('start_res', function(src, args)
        StartResource(args[1])
    end, true)
    ```
  - JavaScript:
    ```javascript
    /* Command: start_res */
    RegisterCommand('start_res', (src, args) => {
      StartResource(args[0]);
    }, true);
    ```
- **Caveats / Limitations**:
  - Fails if resource is missing or already running.
- **Reference**: https://docs.fivem.net/natives/?n=StartResource

##### StopFindKvp
- **Scope**: Server
- **Signature(s)**: `void STOP_FIND_KVP(int handle)`
- **Purpose**: Ends a KVP search started with `StartFindKvp`.
- **Parameters / Returns**:
  - `handle` (`number`): Search handle.
  - **Returns**: None.
- **OneSync / Networking**: Local to server.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Utility; Name: end_kvp; Use: closes KVP search; Created: 2025-09-11; By: VSSVSSN ]]
    local h = StartFindKvp('cfg')
    StopFindKvp(h)
    ```
  - JavaScript:
    ```javascript
    /* Utility: end_kvp */
    const h = StartFindKvp('cfg');
    StopFindKvp(h);
    ```
- **Caveats / Limitations**:
  - Handle becomes invalid after call.
- **Reference**: https://docs.fivem.net/natives/?n=StopFindKvp

##### StopResource
- **Scope**: Server
- **Signature(s)**: `BOOL STOP_RESOURCE(string resourceName)`
- **Purpose**: Stops a running resource.
- **Parameters / Returns**:
  - `resourceName` (`string`): Name to stop.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Resource cleanup triggered.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Admin Cmd; Name: stop_res; Use: stops a resource; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('stop_res', function(src, args)
        StopResource(args[1])
    end, true)
    ```
  - JavaScript:
    ```javascript
    /* Command: stop_res */
    RegisterCommand('stop_res', (src, args) => {
      StopResource(args[0]);
    }, true);
    ```
- **Caveats / Limitations**:
  - Ensure dependent resources handle the stop cleanly.
- **Reference**: https://docs.fivem.net/natives/?n=StopResource

##### TriggerClientEvent
- **Scope**: Server
- **Signature(s)**: `void TRIGGER_CLIENT_EVENT(string eventName, Player playerSrc, ...)`
- **Purpose**: Sends a network event from server to targeted client(s).
- **Parameters / Returns**:
  - `eventName` (`string`): Event to trigger.
  - `playerSrc` (`Player`): Target player ID or `-1` for all.
  - `...` (varargs): Event payload.
  - **Returns**: None.
- **OneSync / Networking**: Respects routing buckets and owner checks; data serialized over network.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: pingall; Use: sends ping event; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('pingall', function()
        TriggerClientEvent('chat:addMessage', -1, { args = { '[PING]', 'pong' } })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: pingall */
    RegisterCommand('pingall', () => {
      emitNet('chat:addMessage', -1, { args: ['[PING]', 'pong'] });
    });
    ```
- **Caveats / Limitations**:
  - Validate payloads; clients can send malformed responses.
- **Reference**: https://docs.fivem.net/natives/?n=TriggerClientEvent

##### TriggerClientEventInternal
- **Scope**: Server
- **Signature(s)**: Not documented on official page.
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Internal function for low-level event dispatch.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Placeholder; Name: tce_internal; Use: calls internal API; Created: 2025-09-11; By: VSSVSSN ]]
    TriggerClientEventInternal('event', 1, '', 0)
    ```
  - JavaScript:
    ```javascript
    /* Placeholder: tce_internal */
    TriggerClientEventInternal('event', 1, '', 0);
    ```
- **Caveats / Limitations**:
  - Intended for internal use; parameters may change.
- **Reference**: https://docs.fivem.net/natives/?n=TriggerClientEventInternal
  - TODO(next-run): verify semantics.

##### TriggerEvent
- **Scope**: Server
- **Signature(s)**: `void TRIGGER_EVENT(string eventName, ...)`
- **Purpose**: Executes a server-side event.
- **Parameters / Returns**:
  - `eventName` (`string`): Name of event.
  - `...` (varargs): Payload.
  - **Returns**: None.
- **OneSync / Networking**: Local to server; not sent to clients.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Utility; Name: call_event; Use: fires custom event; Created: 2025-09-11; By: VSSVSSN ]]
    TriggerEvent('my:event', 1, 2, 3)
    ```
  - JavaScript:
    ```javascript
    /* Utility: call_event */
    TriggerEvent('my:event', 1, 2, 3);
    ```
- **Caveats / Limitations**:
  - Ensure event handlers validate input.
- **Reference**: https://docs.fivem.net/natives/?n=TriggerEvent

##### TriggerEventInternal
- **Scope**: Server
- **Signature(s)**: Not documented on official page.
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Internal server event dispatcher.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Placeholder; Name: te_internal; Use: calls internal API; Created: 2025-09-11; By: VSSVSSN ]]
    TriggerEventInternal('my:event', '', 0)
    ```
  - JavaScript:
    ```javascript
    /* Placeholder: te_internal */
    TriggerEventInternal('my:event', '', 0);
    ```
- **Caveats / Limitations**:
  - Parameters undocumented; avoid in production.
- **Reference**: https://docs.fivem.net/natives/?n=TriggerEventInternal
  - TODO(next-run): verify semantics.

##### TriggerLatentClientEvent
- **Scope**: Server
- **Signature(s)**: `void TRIGGER_LATENT_CLIENT_EVENT(string eventName, Player playerSrc, int bps, ...)`
- **Purpose**: Sends a client event with bandwidth throttling for large payloads.
- **Parameters / Returns**:
  - `eventName` (`string`): Event to trigger.
  - `playerSrc` (`Player`): Target player ID or `-1` for broadcast.
  - `bps` (`int`): Bytes-per-second limit for transfer.
  - `...` (varargs): Event payload.
  - **Returns**: None.
- **OneSync / Networking**: Respects routing buckets; data is fragmented according to `bps`.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: bigmsg; Use: sends large message slowly; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('bigmsg', function()
        local data = string.rep('A', 200000)
        TriggerLatentClientEvent('chat:addMessage', -1, 50000, { args = { '[BIG]', data } })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: bigmsg */
    RegisterCommand('bigmsg', () => {
      const data = 'A'.repeat(200000);
      TriggerLatentClientEvent('chat:addMessage', -1, 50000, { args: ['[BIG]', data] });
    });
    ```
- **Caveats / Limitations**:
  - Use moderate `bps` values to avoid congestion.
- **Reference**: https://docs.fivem.net/natives/?n=TriggerLatentClientEvent

##### TriggerLatentClientEventInternal
- **Scope**: Server
- **Signature(s)**: Not documented on official page.
- **Purpose**: Undocumented/unclear on official docs.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Internal latent-event dispatcher.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Placeholder; Name: tlce_internal; Use: calls internal latent API; Created: 2025-09-11; By: VSSVSSN ]]
    TriggerLatentClientEventInternal('event', 1, '', 0, 0)
    ```
  - JavaScript:
    ```javascript
    /* Placeholder: tlce_internal */
    TriggerLatentClientEventInternal('event', 1, '', 0, 0);
    ```
- **Caveats / Limitations**:
  - Not intended for production; parameters may change.
- **Reference**: https://docs.fivem.net/natives/?n=TriggerLatentClientEventInternal
  - TODO(next-run): verify semantics.

##### VerifyPasswordHash
- **Scope**: Server
- **Signature(s)**: `bool VERIFY_PASSWORD_HASH(string password, string hash)`
- **Purpose**: Checks a plaintext password against a stored hash.
- **Parameters / Returns**:
  - `password` (`string`): Plain text input.
  - `hash` (`string`): Hash generated via `GetPasswordHash`.
  - **Returns**: `bool` match result.
- **OneSync / Networking**: Server-only verification.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: checkpass; Use: verifies a password; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('checkpass', function(_, args)
        local ok = VerifyPasswordHash(args[1] or '', args[2] or '')
        print('Match:', ok)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: checkpass */
    RegisterCommand('checkpass', (_src, args) => {
      const ok = VerifyPasswordHash(args[0] || '', args[1] || '');
      console.log('Match:', ok);
    });
    ```
- **Caveats / Limitations**:
  - Only hashes produced with `GetPasswordHash` are supported.
- **Reference**: https://docs.fivem.net/natives/?n=VerifyPasswordHash

##### WasEventCanceled
- **Scope**: Shared
- **Signature(s)**: `bool WAS_EVENT_CANCELED()`
- **Purpose**: Determines whether the current event has been canceled via `CancelEvent`.
- **Parameters / Returns**:
  - **Returns**: `bool` cancellation status.
- **OneSync / Networking**: Local to the executing context.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Event Handler; Name: example_evt; Use: checks if canceled; Created: 2025-09-11; By: VSSVSSN ]]
    AddEventHandler('example', function()
        if WasEventCanceled() then
            print('Event was canceled')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Event Handler: example_evt */
    on('example', () => {
      if (WasEventCanceled()) {
        console.log('Event was canceled');
      }
    });
    ```
- **Caveats / Limitations**:
  - Only meaningful inside an event handler.
  - **Reference**: https://docs.fivem.net/natives/?n=WasEventCanceled

##### CreateVehicle
- **Scope**: Shared
- **Signature(s)**: `Vehicle CREATE_VEHICLE(Hash modelHash, float x, float y, float z, float heading, bool isNetwork, bool bScriptHostVeh, bool p7)`
- **Purpose**: Spawns a vehicle at the specified location.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Vehicle model.
  - `x`, `y`, `z` (`float`): Spawn coordinates.
  - `heading` (`float`): Initial heading.
  - `isNetwork` (`bool`): Create as networked entity.
  - `bScriptHostVeh` (`bool`): Sets script ownership.
  - `p7` (`bool`): Undocumented flag.
  - **Returns**: `Vehicle` handle.
- **OneSync / Networking**: Use `isNetwork` and be entity owner for replication.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: spawnadder
        -- Use: Spawns an Adder
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('spawnadder', function()
        local model = `adder`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local veh = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false, false)
        SetPedIntoVehicle(ped, veh, -1)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: spawnadder */
    RegisterCommand('spawnadder', () => {
      const model = GetHashKey('adder');
      RequestModel(model);
      while (!HasModelLoaded(model)) Wait(0);
      const ped = PlayerPedId();
      const [x, y, z] = GetEntityCoords(ped);
      const veh = CreateVehicle(model, x, y, z, GetEntityHeading(ped), true, false, false);
      SetPedIntoVehicle(ped, veh, -1);
    });
    ```
- **Caveats / Limitations**:
  - Model must be loaded prior to spawning.
- **Reference**: https://docs.fivem.net/natives/?n=CreateVehicle

##### DeleteMissionTrain
- **Scope**: Shared
- **Signature(s)**: `void DELETE_MISSION_TRAIN(Vehicle train)`
- **Purpose**: Removes a scripted train.
- **Parameters / Returns**:
  - `train` (`Vehicle`): Train entity.
- **OneSync / Networking**: Caller must own the train entity.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: deltrain
        -- Use: Deletes the mission train the player is in
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('deltrain', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DeleteMissionTrain(veh)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: deltrain */
    RegisterCommand('deltrain', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DeleteMissionTrain(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only affects mission-scripted trains.
- **Reference**: https://docs.fivem.net/natives/?n=DeleteMissionTrain

##### DeleteScriptVehicleGenerator
- **Scope**: Shared
- **Signature(s)**: `void DELETE_SCRIPT_VEHICLE_GENERATOR(int generator)`
- **Purpose**: Removes a previously created vehicle generator.
- **Parameters / Returns**:
  - `generator` (`int`): Generator ID.
- **OneSync / Networking**: Removal is networked if generator spawned net vehicles.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: delgen
        -- Use: Deletes a script vehicle generator
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('delgen', function()
        if genId then
            DeleteScriptVehicleGenerator(genId)
            genId = nil
        end
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: delgen */
    RegisterCommand('delgen', () => {
      if (global.genId) {
        DeleteScriptVehicleGenerator(global.genId);
        global.genId = null;
      }
    });
    ```
- **Caveats / Limitations**:
  - Generator ID must be stored after creation.
- **Reference**: https://docs.fivem.net/natives/?n=DeleteScriptVehicleGenerator

##### DeleteVehicle
- **Scope**: Shared
- **Signature(s)**: `void DELETE_VEHICLE(Vehicle vehicle)`
- **Purpose**: Deletes a vehicle entity.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
- **OneSync / Networking**: Caller must own entity for network removal.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: delveh
        -- Use: Deletes the player's current vehicle
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('delveh', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DeleteVehicle(veh)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: delveh */
    RegisterCommand('delveh', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DeleteVehicle(veh);
    });
    ```
- **Caveats / Limitations**:
  - Non-networked vehicles only despawn locally.
- **Reference**: https://docs.fivem.net/natives/?n=DeleteVehicle

##### DetachVehicleFromAnyCargobob
- **Scope**: Shared
- **Signature(s)**: `bool DETACH_VEHICLE_FROM_ANY_CARGOBOB(Vehicle vehicle)`
- **Purpose**: Detaches a vehicle from any Cargobob carrying it.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to detach.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Call from owner of the vehicle and Cargobob.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: detach_cargo
        -- Use: Detaches vehicle from Cargobob
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('detach_cargo', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DetachVehicleFromAnyCargobob(veh)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: detach_cargo */
    RegisterCommand('detach_cargo', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DetachVehicleFromAnyCargobob(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only works if vehicle is attached to a Cargobob.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromAnyCargobob

##### DetachVehicleFromAnyTowTruck
- **Scope**: Shared
- **Signature(s)**: `bool DETACH_VEHICLE_FROM_ANY_TOW_TRUCK(Vehicle vehicle)`
- **Purpose**: Releases a vehicle from any tow truck.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to detach.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Requires ownership of both entities for replication.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: detach_tow
        -- Use: Detaches vehicle from tow truck
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('detach_tow', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DetachVehicleFromAnyTowTruck(veh)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: detach_tow */
    RegisterCommand('detach_tow', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DetachVehicleFromAnyTowTruck(veh);
    });
    ```
- **Caveats / Limitations**:
  - No effect if vehicle is not towed.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromAnyTowTruck

##### DetachVehicleFromCargobob
- **Scope**: Shared
- **Signature(s)**: `bool DETACH_VEHICLE_FROM_CARGOBOB(Vehicle cargobob, Vehicle vehicle)`
- **Purpose**: Releases a vehicle from a specific Cargobob.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Cargobob handle.
  - `vehicle` (`Vehicle`): Attached vehicle.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Invoke from entity owner to sync detachment.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: detach_specific
        -- Use: Detaches given vehicle from Cargobob
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('detach_specific', function()
        local ped = PlayerPedId()
        local cb = GetVehiclePedIsIn(ped, true)
        local veh = GetVehiclePedIsIn(ped, false)
        DetachVehicleFromCargobob(cb, veh)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: detach_specific */
    RegisterCommand('detach_specific', () => {
      const ped = PlayerPedId();
      const cb = GetVehiclePedIsIn(ped, true);
      const veh = GetVehiclePedIsIn(ped, false);
      DetachVehicleFromCargobob(cb, veh);
    });
    ```
- **Caveats / Limitations**:
  - Only applicable to Cargobob helicopters.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromCargobob

##### DetachVehicleFromTowTruck
- **Scope**: Shared
- **Signature(s)**: `bool DETACH_VEHICLE_FROM_TOW_TRUCK(Vehicle towTruck, Vehicle vehicle)`
- **Purpose**: Unhooks a vehicle from a tow truck.
- **Parameters / Returns**:
  - `towTruck` (`Vehicle`): Tow truck entity.
  - `vehicle` (`Vehicle`): Vehicle to unhook.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Call by owner of both vehicles.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: unhook
        -- Use: Detaches vehicle from tow truck
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('unhook', function()
        local tow = GetVehiclePedIsIn(PlayerPedId(), true)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DetachVehicleFromTowTruck(tow, veh)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: unhook */
    RegisterCommand('unhook', () => {
      const ped = PlayerPedId();
      const tow = GetVehiclePedIsIn(ped, true);
      const veh = GetVehiclePedIsIn(ped, false);
      DetachVehicleFromTowTruck(tow, veh);
    });
    ```
- **Caveats / Limitations**:
  - Only for vehicles attached via tow truck hook.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromTowTruck

##### DetachVehicleWindscreen
- **Scope**: Shared
- **Signature(s)**: `void DETACH_VEHICLE_WINDSCREEN(Vehicle vehicle)`
- **Purpose**: Breaks and detaches the vehicle's windshield.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
- **OneSync / Networking**: Requires ownership to propagate breakage.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Command
        -- Name: break_glass
        -- Use: Detaches current vehicle windscreen
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    RegisterCommand('break_glass', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DetachVehicleWindscreen(veh)
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: break_glass */
    RegisterCommand('break_glass', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DetachVehicleWindscreen(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only certain vehicle classes support windshield detachment.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleWindscreen

##### DisableVehicleFirstPersonCamThisFrame
- **Scope**: Client
- **Signature(s)**: `void DISABLE_VEHICLE_FIRST_PERSON_CAM_THIS_FRAME()`
- **Purpose**: Prevents first-person camera inside vehicles for the current frame.
- **Parameters / Returns**:
  - **Returns**: None.
- **OneSync / Networking**: Client-side visual effect only.
- **Examples**:
  - Lua:

    ```lua
    --[[
        -- Type: Tick
        -- Name: disable_fp
        -- Use: Disables first-person view each frame
        -- Created: 2025-09-11
        -- By: VSSVSSN
    --]]
    CreateThread(function()
        while true do
            DisableVehicleFirstPersonCamThisFrame()
            Wait(0)
        end
    end)
    ```
  - JavaScript:

    ```javascript
    /* Tick: disable_fp */
    setTick(() => {
      DisableVehicleFirstPersonCamThisFrame();
    });
    ```
- **Caveats / Limitations**:
  - Must be called every frame to maintain effect.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleFirstPersonCamThisFrame

##### DisableVehicleImpactExplosionActivation
- **Scope**: Shared
- **Signature(s)**: `void DISABLE_VEHICLE_IMPACT_EXPLOSION_ACTIVATION(Vehicle vehicle, bool toggle)`
- **Purpose**: Prevents vehicle impact from triggering an explosion.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `toggle` (`bool`): True disables explosion activation.
- **OneSync / Networking**: Caller must own the vehicle for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: safe_car; Use: Toggles impact explosions; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('safe_car', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DisableVehicleImpactExplosionActivation(veh, args[1] == '1')
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: safe_car */
    RegisterCommand('safe_car', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DisableVehicleImpactExplosionActivation(veh, args[0] === '1');
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify default state and persistence.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleImpactExplosionActivation

##### DisableVehicleNeonLights
- **Scope**: Shared
- **Signature(s)**: `void DISABLE_VEHICLE_NEON_LIGHTS(Vehicle vehicle, bool disable)`
- **Purpose**: Suppresses all neon lighting on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `disable` (`bool`): True to turn off all neon lights.
- **OneSync / Networking**: Requires entity ownership to sync.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: neon_off; Use: Disables neon lights; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('neon_off', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DisableVehicleNeonLights(veh, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: neon_off */
    RegisterCommand('neon_off', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DisableVehicleNeonLights(veh, true);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): confirm if individual neon indices can be toggled.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleNeonLights

##### DisableVehicleTurretMovementThisFrame
- **Scope**: Client
- **Signature(s)**: `void DISABLE_VEHICLE_TURRET_MOVEMENT_THIS_FRAME(Vehicle vehicle)`
- **Purpose**: Freezes turret rotation for current frame.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle whose turret is frozen.
- **OneSync / Networking**: Visual-only; call on controlling client.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Tick; Name: freeze_turret; Use: Holds turret still; Created: 2025-09-11; By: VSSVSSN ]]
    CreateThread(function()
        while true do
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            DisableVehicleTurretMovementThisFrame(veh)
            Wait(0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Tick: freeze_turret */
    setTick(() => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DisableVehicleTurretMovementThisFrame(veh);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify multiplayer effects on remote clients.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleTurretMovementThisFrame

##### DisableVehicleWeapon
- **Scope**: Shared
- **Signature(s)**: `void DISABLE_VEHICLE_WEAPON(bool disabled, Hash weaponHash, Vehicle vehicle, Ped owner)`
- **Purpose**: Toggles availability of a specific vehicle weapon.
- **Parameters / Returns**:
  - `disabled` (`bool`): True to disable firing.
  - `weaponHash` (`Hash`): Weapon identifier.
  - `vehicle` (`Vehicle`): Vehicle containing the weapon.
  - `owner` (`Ped`): Ped controlling the weapon.
- **OneSync / Networking**: Call from weapon owner's host to replicate.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: lock_gun; Use: Disables vehicle weapon; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('lock_gun', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local owner = PlayerPedId()
        DisableVehicleWeapon(true, `VEHICLE_WEAPON_SPACE_ROCKET`, veh, owner)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lock_gun */
    RegisterCommand('lock_gun', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const owner = PlayerPedId();
      DisableVehicleWeapon(true, GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'), veh, owner);
    });
    ```
- **Caveats / Limitations**:
  - Weapon hash must exist for the vehicle.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleWeapon

##### DisableVehicleWorldCollision
- **Scope**: Shared
- **Signature(s)**: `void DISABLE_VEHICLE_WORLD_COLLISION(Vehicle vehicle, bool toggle)`
- **Purpose**: Enables or disables collision of the vehicle with the world.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `toggle` (`bool`): True disables collision.
- **OneSync / Networking**: Ownership required; may desync physics if misused.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: noclip_car; Use: Toggle world collision; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('noclip_car', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        DisableVehicleWorldCollision(veh, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: noclip_car */
    RegisterCommand('noclip_car', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      DisableVehicleWorldCollision(veh, true);
    });
    ```
- **Caveats / Limitations**:
  - Vehicle may fall through map; use carefully.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleWorldCollision

##### DisplayDistantVehicleSmoke
- **Scope**: Client
- **Signature(s)**: `void DISPLAY_DISTANT_VEHICLE_SMOKE(bool toggle)`
- **Purpose**: Toggles rendering of exhaust smoke for distant vehicles.
- **Parameters / Returns**:
  - `toggle` (`bool`): True to show smoke.
- **OneSync / Networking**: Visual-only; client preference.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: smoke; Use: Toggles distant smoke; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('smoke', function(_, args)
        DisplayDistantVehicleSmoke(args[1] == '1')
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: smoke */
    RegisterCommand('smoke', (src, args) => {
      DisplayDistantVehicleSmoke(args[0] === '1');
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify impact on performance.
- **Reference**: https://docs.fivem.net/natives/?n=DisplayDistantVehicleSmoke

##### DisplayPlayerInVehicleBadgeThisFrame
- **Scope**: Client
- **Signature(s)**: `void DISPLAY_PLAYER_IN_VEHICLE_BADGE_THIS_FRAME(Player player, string badgeText, int alpha)`
- **Purpose**: Shows a temporary HUD badge for the specified player in a vehicle.
- **Parameters / Returns**:
  - `player` (`Player`): Target player.
  - `badgeText` (`string`): Text label.
  - `alpha` (`int`): Transparency value 0–255.
- **OneSync / Networking**: Local display; not networked.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: badge; Use: Displays player badge; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('badge', function(_, args)
        DisplayPlayerInVehicleBadgeThisFrame(PlayerId(), args[1] or 'TEST', 255)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: badge */
    RegisterCommand('badge', (src, args) => {
      DisplayPlayerInVehicleBadgeThisFrame(PlayerId(), args[0] || 'TEST', 255);
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): verify correct parameter order.
- **Reference**: https://docs.fivem.net/natives/?n=DisplayPlayerInVehicleBadgeThisFrame

##### DoesCargobobHavePickupMagnet
- **Scope**: Shared
- **Signature(s)**: `bool DOES_CARGOBOB_HAVE_PICKUP_MAGNET(Vehicle cargobob)`
- **Purpose**: Checks if a Cargobob has a magnet attachment.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): The Cargobob to inspect.
  - **Returns**: `bool` magnet presence.
- **OneSync / Networking**: Requires owning the Cargobob for accurate state.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: has_magnet; Use: Reports magnet attachment; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('has_magnet', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(DoesCargobobHavePickupMagnet(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_magnet */
    RegisterCommand('has_magnet', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(DoesCargobobHavePickupMagnet(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only valid for Cargobob models.
- **Reference**: https://docs.fivem.net/natives/?n=DoesCargobobHavePickupMagnet

##### DoesCargobobHavePickupRope
- **Scope**: Shared
- **Signature(s)**: `bool DOES_CARGOBOB_HAVE_PICKUP_ROPE(Vehicle cargobob)`
- **Purpose**: Returns whether a Cargobob has a pickup rope deployed.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): The helicopter to check.
  - **Returns**: `bool` rope status.
- **OneSync / Networking**: Ownership needed to check rope state.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: has_rope; Use: Prints rope presence; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('has_rope', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(DoesCargobobHavePickupRope(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_rope */
    RegisterCommand('has_rope', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(DoesCargobobHavePickupRope(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for Cargobob helicopters.
- **Reference**: https://docs.fivem.net/natives/?n=DoesCargobobHavePickupRope

##### DoesVehicleHaveLandingGear
- **Scope**: Shared
- **Signature(s)**: `bool DOES_VEHICLE_HAVE_LANDING_GEAR(Vehicle vehicle)`
- **Purpose**: Determines if a vehicle is equipped with retractable landing gear.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool` landing gear availability.
- **OneSync / Networking**: Ownership required to ensure accurate info.
- **Examples**:
  - Lua:
    ```lua
    --[[ Type: Command; Name: has_gear; Use: Checks for landing gear; Created: 2025-09-11; By: VSSVSSN ]]
    RegisterCommand('has_gear', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(DoesVehicleHaveLandingGear(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_gear */
    RegisterCommand('has_gear', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(DoesVehicleHaveLandingGear(veh));
    });
    ```
- **Caveats / Limitations**:
  - TODO(next-run): confirm if applies to all aircraft classes.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveLandingGear

##### DoesVehicleHaveRoof
- **Scope**: Shared
- **Signature(s)**: `BOOL DOES_VEHICLE_HAVE_ROOF(Vehicle vehicle)`
- **Purpose**: Checks if a vehicle model features a roof structure.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle entity.
  - **Returns**: `bool` roof presence.
- **OneSync / Networking**: Requires network ownership of the vehicle for accurate state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_roof
        -- Use: Prints if the current vehicle has a roof
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_roof', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(DoesVehicleHaveRoof(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_roof */
    RegisterCommand('has_roof', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(DoesVehicleHaveRoof(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns false for open vehicles such as bikes or boats.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveRoof

##### DoesVehicleHaveSearchlight
- **Scope**: Shared
- **Signature(s)**: `BOOL DOES_VEHICLE_HAVE_SEARCHLIGHT(Vehicle vehicle)`
- **Purpose**: Detects whether a vehicle includes a searchlight component.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool` searchlight presence.
- **OneSync / Networking**: Entity ownership required to query attachments reliably.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_searchlight
        -- Use: Reports if the current vehicle has a searchlight
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_searchlight', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(DoesVehicleHaveSearchlight(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_searchlight */
    RegisterCommand('has_searchlight', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(DoesVehicleHaveSearchlight(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only certain emergency or utility vehicles support searchlights.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveSearchlight

##### DoesVehicleHaveStuckVehicleCheck
- **Scope**: Shared
- **Signature(s)**: `BOOL DOES_VEHICLE_HAVE_STUCK_VEHICLE_CHECK(Vehicle vehicle)`
- **Purpose**: Indicates if the engine maintains a stuck-vehicle check for the entity.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle queried.
  - **Returns**: `bool` flag for active stuck check.
- **OneSync / Networking**: Requires control of vehicle to read internal state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_stuck_check
        -- Use: Prints whether a vehicle has a stuck check
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_stuck_check', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(DoesVehicleHaveStuckVehicleCheck(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_stuck_check */
    RegisterCommand('has_stuck_check', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(DoesVehicleHaveStuckVehicleCheck(veh));
    });
    ```
- **Caveats / Limitations**:
  - Official docs omit return description; semantics inferred.
  - TODO(next-run): verify maximum simultaneous checks.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveStuckVehicleCheck

##### DoesVehicleHaveWeapons
- **Scope**: Shared
- **Signature(s)**: `BOOL DOES_VEHICLE_HAVE_WEAPONS(Vehicle vehicle)`
- **Purpose**: Determines if the vehicle is armed with built-in weapons.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool` weapon capability.
- **OneSync / Networking**: Caller must control the vehicle to read modifications.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_weapons
        -- Use: Reports if the current vehicle has weapons
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_weapons', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(DoesVehicleHaveWeapons(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_weapons */
    RegisterCommand('has_weapons', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(DoesVehicleHaveWeapons(veh));
    });
    ```
- **Caveats / Limitations**:
  - Documentation lacks details on supported weapon types.
  - TODO(next-run): verify behaviour with addon vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveWeapons

##### DoesVehicleTyreExist
- **Scope**: Shared
- **Signature(s)**: `BOOL _DOES_VEHICLE_TYRE_EXIST(Vehicle vehicle, int tyreIndex)`
- **Purpose**: Returns whether the specified tyre index exists and is installed.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `tyreIndex` (`int`): Tyre index 0–5 for cars.
  - **Returns**: `bool` existence state.
- **OneSync / Networking**: Requires vehicle ownership for accurate tyre state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tyre_exists
        -- Use: Checks tyre presence by index
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tyre_exists', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local idx = tonumber(args[1]) or 0
        print(_DoesVehicleTyreExist(veh, idx))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tyre_exists */
    RegisterCommand('tyre_exists', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const idx = parseInt(args[0]) || 0;
      console.log(_DoesVehicleTyreExist(veh, idx));
    });
    ```
- **Caveats / Limitations**:
  - Tyres removed via mods return false.
- **Reference**: https://docs.fivem.net/natives/?n=_DOES_VEHICLE_TYRE_EXIST

##### EjectJb700Roof
- **Scope**: Client
- **Signature(s)**: `void _EJECT_JB700_ROOF(Vehicle vehicle, float x, float y, float z)`
- **Purpose**: Forces the JB700's roof to detach using a force vector.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): JB700 model vehicle.
  - `x` (`float`), `y` (`float`), `z` (`float`): Force direction.
  - **Returns**: None.
- **OneSync / Networking**: Visual effect is local; ensure entity ownership for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: eject_roof
        -- Use: Ejects the JB700 roof
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('eject_roof', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        _EjectJb700Roof(veh, 0.0, 0.0, 1.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: eject_roof */
    RegisterCommand('eject_roof', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      _EjectJb700Roof(veh, 0.0, 0.0, 1.0);
    });
    ```
- **Caveats / Limitations**:
  - Only applies to JB700 vehicles.
  - TODO(next-run): confirm force vector units.
- **Reference**: https://docs.fivem.net/natives/?n=_EjectJb700Roof

##### EnableIndividualPlanePropeller
- **Scope**: Shared
- **Signature(s)**: `void _ENABLE_INDIVIDUAL_PLANE_PROPELLER(Vehicle plane, int propeller)`
- **Purpose**: Starts a specific propeller on multi-engine planes.
- **Parameters / Returns**:
  - `plane` (`Vehicle`): Target propeller aircraft.
  - `propeller` (`int`): Propeller index starting at 0.
  - **Returns**: None.
- **OneSync / Networking**: Requires entity control to replicate propeller state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Thread
        -- Name: prop_start
        -- Use: Sequentially starts propellers
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    CreateThread(function()
        local plane = GetVehiclePedIsIn(PlayerPedId(), false)
        DisableIndividualPlanePropeller(plane, 0)
        DisableIndividualPlanePropeller(plane, 1)
        Wait(5000)
        _EnableIndividualPlanePropeller(plane, 1)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Thread: prop_start */
    setTimeout(() => {
      const plane = GetVehiclePedIsIn(PlayerPedId(), false);
      DisableIndividualPlanePropeller(plane, 0);
      DisableIndividualPlanePropeller(plane, 1);
      setTimeout(() => {
        _EnableIndividualPlanePropeller(plane, 1);
      }, 5000);
    }, 0);
    ```
- **Caveats / Limitations**:
  - Prop indices vary by aircraft model.
- **Reference**: https://docs.fivem.net/natives/?n=_EnableIndividualPlanePropeller

##### ExplodeVehicle
- **Scope**: Shared
- **Signature(s)**: `void EXPLODE_VEHICLE(Vehicle vehicle, BOOL isAudible, BOOL isInvisible)`
- **Purpose**: Blows up a vehicle with optional sound and visuals.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to destroy.
  - `isAudible` (`bool`): Play explosion audio.
  - `isInvisible` (`bool`): Hide explosion FX.
  - **Returns**: None.
- **OneSync / Networking**: Requires network control; explosion sync depends on ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom
        -- Use: Explodes the current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ExplodeVehicle(veh, true, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom */
    RegisterCommand('boom', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ExplodeVehicle(veh, true, false);
    });
    ```
- **Caveats / Limitations**:
  - Invisible explosions still damage nearby entities.
- **Reference**: https://docs.fivem.net/natives/?n=ExplodeVehicle

##### ExplodeVehicleInCutscene
- **Scope**: Shared
- **Signature(s)**: `void EXPLODE_VEHICLE_IN_CUTSCENE(Vehicle vehicle, BOOL p1)`
- **Purpose**: Triggers a cinematic explosion for scripted scenes.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to explode.
  - `p1` (`bool`): Unknown flag.
  - **Returns**: None.
- **OneSync / Networking**: Use on controlled vehicles; effect may differ for remote clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_cs
        -- Use: Explodes vehicle using cutscene style
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_cs', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ExplodeVehicleInCutscene(veh, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_cs */
    RegisterCommand('boom_cs', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ExplodeVehicleInCutscene(veh, true);
    });
    ```
- **Caveats / Limitations**:
  - `p1` meaning undocumented.
  - TODO(next-run): verify difference from standard explosion.
- **Reference**: https://docs.fivem.net/natives/?n=ExplodeVehicleInCutscene

##### FindRandomPointInSpace
- **Scope**: Client
- **Signature(s)**: `Vector3 _FIND_RANDOM_POINT_IN_SPACE(Ped ped)`
- **Purpose**: Generates a distant random position relative to a ped.
- **Parameters / Returns**:
  - `ped` (`Ped`): Reference ped.
  - **Returns**: `vector3` location roughly 250–400 units away.
- **OneSync / Networking**: Pure calculation; no network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: random_point
        -- Use: Prints a random space position
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('random_point', function()
        local pos = _FindRandomPointInSpace(PlayerPedId())
        print(string.format('%.2f %.2f %.2f', pos.x, pos.y, pos.z))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: random_point */
    RegisterCommand('random_point', () => {
      const pos = _FindRandomPointInSpace(PlayerPedId());
      console.log(`${pos[0].toFixed(2)} ${pos[1].toFixed(2)} ${pos[2].toFixed(2)}`);
    });
    ```
- **Caveats / Limitations**:
  - Returned point may not be navigable.
- **Reference**: https://docs.fivem.net/natives/?n=_FindRandomPointInSpace

##### FindVehicleCarryingThisEntity
- **Scope**: Shared
- **Signature(s)**: `Vehicle _FIND_VEHICLE_CARRYING_THIS_ENTITY(Entity entity)`
- **Purpose**: Finds a handler-frame vehicle transporting the given entity.
- **Parameters / Returns**:
  - `entity` (`Entity`): Entity attached via handler frame.
  - **Returns**: `Vehicle` carrier or 0 if none.
- **OneSync / Networking**: Entity must be networked; ensure control for consistent results.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Function
        -- Name: carrier_of
        -- Use: Prints vehicle carrying a specified entity
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    function carrier_of(ent)
        local veh = _FindVehicleCarryingThisEntity(ent)
        print(veh)
    end
    ```
  - JavaScript:
    ```javascript
    /* Function: carrierOf */
    function carrierOf(ent){
      const veh = _FindVehicleCarryingThisEntity(ent);
      console.log(veh);
    }
    ```
- **Caveats / Limitations**:
  - Works only with entities using handler frame models like `prop_contr_03b_ld`.
- **Reference**: https://docs.fivem.net/natives/?n=_FindVehicleCarryingThisEntity

##### FixVehicleWindow
- **Scope**: Shared
- **Signature(s)**: `void FIX_VEHICLE_WINDOW(Vehicle vehicle, int windowIndex)`
- **Purpose**: Restores a broken window to intact state.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle containing the window.
  - `windowIndex` (`int`): Window slot per eWindowId.
  - **Returns**: None.
- **OneSync / Networking**: Requires entity ownership to replicate window state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: fix_window
        -- Use: Repairs a specified window
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('fix_window', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local idx = tonumber(args[1]) or 0
        FixVehicleWindow(veh, idx)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: fix_window */
    RegisterCommand('fix_window', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const idx = parseInt(args[0]) || 0;
      FixVehicleWindow(veh, idx);
    });
    ```
- **Caveats / Limitations**:
  - Ignored for bikes, boats, trains, and submarines.
- **Reference**: https://docs.fivem.net/natives/?n=FixVehicleWindow
##### ForcePlaybackRecordedVehicleUpdate
- **Scope**: Shared
- **Signature(s)**: `void FORCE_PLAYBACK_RECORDED_VEHICLE_UPDATE(Vehicle vehicle, BOOL p1)`
- **Purpose**: Forces immediate update of a playback recording on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle running a recording.
  - `p1` (`bool`): Unknown flag, usually `true`.
  - **Returns**: None.
- **OneSync / Networking**: Use on owned vehicles to sync playback position.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: force_playback
        -- Use: Updates playback on current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('force_playback', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ForcePlaybackRecordedVehicleUpdate(veh, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: force_playback */
    RegisterCommand('force_playback', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ForcePlaybackRecordedVehicleUpdate(veh, true);
    });
    ```
- **Caveats / Limitations**:
  - Typically paired with playback skip functions.
- **Reference**: https://docs.fivem.net/natives/?n=ForcePlaybackRecordedVehicleUpdate

##### ForceSubmarineNeurtalBuoyancy
- **Scope**: Shared
- **Signature(s)**: `void FORCE_SUBMARINE_NEURTAL_BUOYANCY(Vehicle submarine, int time)`
- **Purpose**: Keeps a submarine neutrally buoyant for a duration in milliseconds.
- **Parameters / Returns**:
  - `submarine` (`Vehicle`): Submarine to affect.
  - `time` (`int`): Duration in ms for neutral buoyancy.
  - **Returns**: None.
- **OneSync / Networking**: Requires ownership; state may desync if remote.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: buoyancy
        -- Use: Applies neutral buoyancy for 10s
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('buoyancy', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        ForceSubmarineNeurtalBuoyancy(veh, 10000)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: buoyancy */
    RegisterCommand('buoyancy', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      ForceSubmarineNeurtalBuoyancy(veh, 10000);
    });
    ```
- **Caveats / Limitations**:
  - Applies only to submarine-type vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=ForceSubmarineNeurtalBuoyancy

##### ForceSubmarineSurfaceMode
- **Scope**: Shared
- **Signature(s)**: `void FORCE_SUBMARINE_SURFACE_MODE(Vehicle vehicle, BOOL toggle)`
- **Purpose**: Forces a submarine to surface mode when toggled.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Submarine to control.
  - `toggle` (`bool`): Enable or disable forced surface.
  - **Returns**: None.
- **OneSync / Networking**: Ownership required; remote subs may ignore the toggle.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: surface_mode
        -- Use: Toggles forced surface mode
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('surface_mode', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local flag = args[1] == '1'
        ForceSubmarineSurfaceMode(veh, flag)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: surface_mode */
    RegisterCommand('surface_mode', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const flag = args[0] === '1';
      ForceSubmarineSurfaceMode(veh, flag);
    });
    ```
- **Caveats / Limitations**:
  - Only meaningful for submarines.
- **Reference**: https://docs.fivem.net/natives/?n=ForceSubmarineSurfaceMode

##### FullyChargeNitrous
- **Scope**: Shared
- **Signature(s)**: `void FULLY_CHARGE_NITROUS(Vehicle vehicle)`
- **Purpose**: Refills the vehicle's nitrous system to its configured maximum.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with nitrous enabled.
  - **Returns**: None.
- **OneSync / Networking**: Ensure entity ownership; nitrous syncs via state bags.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nitro_full
        -- Use: Fully recharges nitrous
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('nitro_full', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        SetOverrideNitrousLevel(veh, true, 1.0, 1.0, 0.0, false)
        FullyChargeNitrous(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nitro_full */
    RegisterCommand('nitro_full', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      SetOverrideNitrousLevel(veh, true, 1.0, 1.0, 0.0, false);
      FullyChargeNitrous(veh);
    });
    ```
- **Caveats / Limitations**:
  - Requires prior nitrous setup via `SetOverrideNitrousLevel`.
- **Reference**: https://docs.fivem.net/natives/?n=FullyChargeNitrous

##### GetAllVehicles
- **Scope**: Server
- **Signature(s)**: `int GET_ALL_VEHICLES(int* vehArray)`
- **Purpose**: Retrieves an array of all vehicles in the pool.
- **Parameters / Returns**:
  - `vehArray` (`int*`): Preallocated array to populate.
  - **Returns**: `int` count of vehicles copied.
- **OneSync / Networking**: Server-only; clients should use `GetGamePool('CVehicle')`.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Function
        -- Name: list_vehicles
        -- Use: Prints all vehicles on the server
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    function list_vehicles()
        local pool = GetGamePool('CVehicle')
        for _, veh in ipairs(pool) do
            print(veh)
        end
    end
    ```
  - JavaScript:
    ```javascript
    /* Function: listVehicles */
    function listVehicles(){
      const pool = GetGamePool('CVehicle');
      for (const veh of pool) {
        console.log(veh);
      }
    }
    ```
- **Caveats / Limitations**:
  - Superseded by `GetGamePool` in FiveM scripts.
- **Reference**: https://docs.fivem.net/natives/?n=GetAllVehicles

##### GetBoatBoomPositionRatio
- **Scope**: Shared
- **Signature(s)**: `float GET_BOAT_BOOM_POSITION_RATIO(Vehicle vehicle)`
- **Purpose**: Retrieves the current ratio (0.0–1.0) of a boat boom's position.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Boat with movable boom.
  - **Returns**: `float` position ratio.
- **OneSync / Networking**: Requires ownership to sync boom state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_ratio
        -- Use: Prints boom position ratio
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_ratio', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetBoatBoomPositionRatio(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_ratio */
    RegisterCommand('boom_ratio', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetBoatBoomPositionRatio(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for boats with boom apparatus.
- **Reference**: https://docs.fivem.net/natives/?n=GetBoatBoomPositionRatio

##### GetBoatBoomPositionRatio_2
- **Scope**: Shared
- **Signature(s)**: `void _GET_BOAT_BOOM_POSITION_RATIO_2(Vehicle vehicle, BOOL p1)`
- **Purpose**: Internal function related to boom animation state.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target boat.
  - `p1` (`bool`): Unknown flag.
  - **Returns**: None.
- **OneSync / Networking**: Effect uncertain; assumes ownership required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_ratio2
        -- Use: Calls secondary boom ratio native
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_ratio2', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        _GetBoatBoomPositionRatio_2(veh, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_ratio2 */
    RegisterCommand('boom_ratio2', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      _GetBoatBoomPositionRatio_2(veh, true);
    });
    ```
- **Caveats / Limitations**:
  - Purpose not documented.
  - TODO(next-run): clarify behaviour.
- **Reference**: https://docs.fivem.net/natives/?n=_GetBoatBoomPositionRatio_2

##### GetBoatBoomPositionRatio_3
- **Scope**: Shared
- **Signature(s)**: `void _GET_BOAT_BOOM_POSITION_RATIO_3(Vehicle vehicle, BOOL p1)`
- **Purpose**: Additional internal variant for boom position control.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Boat to adjust.
  - `p1` (`bool`): Unknown.
  - **Returns**: None.
- **OneSync / Networking**: Assumes ownership required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_ratio3
        -- Use: Invokes tertiary boom ratio native
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_ratio3', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        _GetBoatBoomPositionRatio_3(veh, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_ratio3 */
    RegisterCommand('boom_ratio3', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      _GetBoatBoomPositionRatio_3(veh, true);
    });
    ```
- **Caveats / Limitations**:
  - Behaviour undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=_GetBoatBoomPositionRatio_3

##### GetBoatVehicleModelAgility
- **Scope**: Shared
- **Signature(s)**: `float GET_BOAT_VEHICLE_MODEL_AGILITY(Hash modelHash)`
- **Purpose**: Returns agility metric for a boat model including mods.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Boat model identifier.
  - **Returns**: `float` agility value.
- **OneSync / Networking**: Pure lookup; no network considerations.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boat_agility
        -- Use: Prints agility of current boat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boat_agility', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local model = GetEntityModel(veh)
        print(GetBoatVehicleModelAgility(model))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boat_agility */
    RegisterCommand('boat_agility', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const model = GetEntityModel(veh);
      console.log(GetBoatVehicleModelAgility(model));
    });
    ```
- **Caveats / Limitations**:
  - Only valid for boat models.
- **Reference**: https://docs.fivem.net/natives/?n=GetBoatVehicleModelAgility

##### GetCanVehicleJump
- **Scope**: Shared
- **Signature(s)**: `BOOL _GET_CAN_VEHICLE_JUMP(Vehicle vehicle)`
- **Purpose**: Returns whether the vehicle supports jump ability.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool` jump capability.
- **OneSync / Networking**: Requires entity control to inspect flags.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: can_jump
        -- Use: Indicates if current vehicle can jump
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('can_jump', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GetCanVehicleJump(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_jump */
    RegisterCommand('can_jump', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GetCanVehicleJump(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only certain vehicles (e.g., Ruiner 2000) return true.
- **Reference**: https://docs.fivem.net/natives/?n=_GetCanVehicleJump

##### GetCargobobHookPosition
- **Scope**: Shared
- **Signature(s)**: `Vector3 _GET_CARGOBOB_HOOK_POSITION(Vehicle cargobob)`
- **Purpose**: Retrieves world coordinates of the active Cargobob hook.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Cargobob helicopter.
  - **Returns**: `vector3` hook position.
- **OneSync / Networking**: Requires ownership of the Cargobob for accurate hook location.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hook_pos
        -- Use: Prints Cargobob hook position
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('hook_pos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local pos = _GetCargobobHookPosition(veh)
        print(pos.x, pos.y, pos.z)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hook_pos */
    RegisterCommand('hook_pos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const pos = _GetCargobobHookPosition(veh);
      console.log(pos[0], pos[1], pos[2]);
    });
    ```
- **Caveats / Limitations**:
  - Only valid for Cargobob models.
- **Reference**: https://docs.fivem.net/natives/?n=_GetCargobobHookPosition

##### GetClosestVehicle
- **Scope**: Shared
- **Signature(s)**: `Vehicle GET_CLOSEST_VEHICLE(float x, float y, float z, float radius, Hash modelHash, int flags)`
- **Purpose**: Returns the nearest vehicle to a point within a radius.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Origin coordinates.
  - `radius` (`float`): Search radius.
  - `modelHash` (`Hash`): Restrict to model or 0 for any.
  - `flags` (`int`): Behaviour flags.
  - **Returns**: `Vehicle` handle or 0 if none.
- **OneSync / Networking**: Query is local; ensure entity exists for remote clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: near_veh
        -- Use: Prints closest vehicle to player
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('near_veh', function()
        local pos = GetEntityCoords(PlayerPedId())
        local veh = GetClosestVehicle(pos.x, pos.y, pos.z, 50.0, 0, 70)
        print(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: near_veh */
    RegisterCommand('near_veh', () => {
      const pos = GetEntityCoords(PlayerPedId());
      const veh = GetClosestVehicle(pos[0], pos[1], pos[2], 50.0, 0, 70);
      console.log(veh);
    });
    ```
- **Caveats / Limitations**:
  - Flags control filtering; behaviour undocumented and may exclude aircraft.
  - TODO(next-run): detail flag meanings.
- **Reference**: https://docs.fivem.net/natives/?n=GetClosestVehicle

##### GetConvertibleRoofState
- **Scope**: Shared
- **Signature(s)**: `int GET_CONVERTIBLE_ROOF_STATE(Vehicle vehicle)`
- **Purpose**: Returns the convertible roof's current state enum.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target convertible.
  - **Returns**: `int` roof state (0=raised, 1=lowering, 2=lowered, etc.).
- **OneSync / Networking**: Ownership required to observe real-time state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: roof_state
        -- Use: Prints roof state of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('roof_state', function()
        local veh = GetVehiclePedIsIn(PlayerPedId())
        print(GetConvertibleRoofState(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: roof_state */
    RegisterCommand('roof_state', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetConvertibleRoofState(veh));
    });
    ```
- **Caveats / Limitations**:
  - Ensure the vehicle supports convertible roofs.
- **Reference**: https://docs.fivem.net/natives/?n=GetConvertibleRoofState

##### GetCurrentPlaybackForVehicle
- **Name**: GetCurrentPlaybackForVehicle
- **Scope**: Shared
- **Signature(s)**: `int GET_CURRENT_PLAYBACK_FOR_VEHICLE(Vehicle vehicle)`
- **Purpose**: Returns the playback ID currently assigned to a vehicle if a recording is playing.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle being checked.
  - **Returns**: `int` playback identifier or 0 when not recording.
- **OneSync / Networking**: Vehicle must be owned locally to query playback state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_id
        -- Use: Prints current playback handle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_id', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetCurrentPlaybackForVehicle(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_id */
    RegisterCommand('playback_id', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetCurrentPlaybackForVehicle(veh));
    });
    ```
- **Caveats / Limitations**:
  - Works only on vehicles playing recorded paths.
  - TODO(next-run): verify return value when playback is absent.
- **Reference**: https://docs.fivem.net/natives/?n=GetCurrentPlaybackForVehicle

##### GetDisplayNameFromVehicleModel
- **Name**: GetDisplayNameFromVehicleModel
- **Scope**: Shared
- **Signature(s)**: `char* GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(Hash modelHash)`
- **Purpose**: Retrieves the internal display name label for a vehicle model.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Vehicle model identifier.
  - **Returns**: `string` label such as `ADDER`.
- **OneSync / Networking**: Pure lookup; no network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_name
        -- Use: Prints display name for model
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_name', function(_, args)
        local model = GetHashKey(args[1] or 'adder')
        print(GetDisplayNameFromVehicleModel(model))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_name */
    RegisterCommand('veh_name', (src, args) => {
      const model = GetHashKey(args[0] || 'adder');
      console.log(GetDisplayNameFromVehicleModel(model));
    });
    ```
- **Caveats / Limitations**:
  - Returned label may need `GetLabelText` for localization.
- **Reference**: https://docs.fivem.net/natives/?n=GetDisplayNameFromVehicleModel

##### GetEntityAttachedToCargobob
- **Name**: GetEntityAttachedToCargobob
- **Scope**: Shared
- **Signature(s)**: `Entity GET_ENTITY_ATTACHED_TO_CARGOBOB(Vehicle cargobob)`
- **Purpose**: Returns the entity currently attached to a Cargobob's hook.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Cargobob helicopter.
  - **Returns**: `Entity` handle or 0.
- **OneSync / Networking**: Requires ownership of the Cargobob for accurate state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cargobob_cargo
        -- Use: Prints entity attached to Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('cargobob_cargo', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetEntityAttachedToCargobob(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cargobob_cargo */
    RegisterCommand('cargobob_cargo', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetEntityAttachedToCargobob(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only valid for Cargobob helicopters.
- **Reference**: https://docs.fivem.net/natives/?n=GetEntityAttachedToCargobob

##### GetEntityAttachedToTowTruck
- **Name**: GetEntityAttachedToTowTruck
- **Scope**: Shared
- **Signature(s)**: `Entity GET_ENTITY_ATTACHED_TO_TOW_TRUCK(Vehicle towTruck)`
- **Purpose**: Retrieves the entity currently hooked to a tow truck.
- **Parameters / Returns**:
  - `towTruck` (`Vehicle`): Tow truck vehicle.
  - **Returns**: `Entity` handle or 0 if none.
- **OneSync / Networking**: Tow truck must be owned locally.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tow_target
        -- Use: Prints entity hooked to tow truck
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tow_target', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetEntityAttachedToTowTruck(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tow_target */
    RegisterCommand('tow_target', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetEntityAttachedToTowTruck(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only for tow trucks with a valid attachment.
- **Reference**: https://docs.fivem.net/natives/?n=GetEntityAttachedToTowTruck

##### GetHasRocketBoost
- **Name**: GetHasRocketBoost
- **Scope**: Shared
- **Signature(s)**: `bool GET_HAS_ROCKET_BOOST(Vehicle vehicle)`
- **Purpose**: Checks if a vehicle has a rocket boost system installed.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool` rocket boost availability.
- **OneSync / Networking**: Requires network ownership for correct information.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_boost
        -- Use: Prints if current vehicle has rocket boost
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_boost', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetHasRocketBoost(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_boost */
    RegisterCommand('has_boost', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetHasRocketBoost(veh));
    });
    ```
- **Caveats / Limitations**:
  - Applies only to vehicles supporting rocket boost.
- **Reference**: https://docs.fivem.net/natives/?n=GetHasRocketBoost

##### GetHasVehicleBeenOwnedByPlayer
- **Name**: GetHasVehicleBeenOwnedByPlayer
- **Scope**: Shared
- **Signature(s)**: `bool GET_HAS_VEHICLE_BEEN_OWNED_BY_PLAYER(Vehicle vehicle)`
- **Purpose**: Indicates whether a vehicle has ever been owned by a player.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` ownership history.
- **OneSync / Networking**: Ownership should be local to ensure accuracy.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: owned_by_player
        -- Use: Prints if vehicle was owned by a player
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('owned_by_player', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetHasVehicleBeenOwnedByPlayer(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: owned_by_player */
    RegisterCommand('owned_by_player', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetHasVehicleBeenOwnedByPlayer(veh));
    });
    ```
- **Caveats / Limitations**:
  - Meaning of "owned" varies between game modes.
  - TODO(next-run): clarify exact ownership criteria.
- **Reference**: https://docs.fivem.net/natives/?n=GetHasVehicleBeenOwnedByPlayer

##### GetHeliMainRotorHealth
- **Name**: GetHeliMainRotorHealth
- **Scope**: Shared
- **Signature(s)**: `float GET_HELI_MAIN_ROTOR_HEALTH(Vehicle vehicle)`
- **Purpose**: Returns the health value of a helicopter's main rotor.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Helicopter to query.
  - **Returns**: `float` rotor health.
- **OneSync / Networking**: Helicopter should be owned locally for reliable data.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: main_rotor
        -- Use: Prints main rotor health
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('main_rotor', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetHeliMainRotorHealth(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: main_rotor */
    RegisterCommand('main_rotor', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetHeliMainRotorHealth(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only meaningful for helicopters.
- **Reference**: https://docs.fivem.net/natives/?n=GetHeliMainRotorHealth

##### GetHeliTailRotorHealth
- **Name**: GetHeliTailRotorHealth
- **Scope**: Shared
- **Signature(s)**: `float GET_HELI_TAIL_ROTOR_HEALTH(Vehicle vehicle)`
- **Purpose**: Retrieves the health value of a helicopter's tail rotor.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Helicopter to inspect.
  - **Returns**: `float` tail rotor health.
- **OneSync / Networking**: Requires local ownership of the helicopter.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tail_rotor
        -- Use: Prints tail rotor health
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tail_rotor', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetHeliTailRotorHealth(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tail_rotor */
    RegisterCommand('tail_rotor', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetHeliTailRotorHealth(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only meaningful for helicopters.
- **Reference**: https://docs.fivem.net/natives/?n=GetHeliTailRotorHealth

##### GetIsDoorValid
- **Name**: GetIsDoorValid
- **Scope**: Shared
- **Signature(s)**: `bool GET_IS_DOOR_VALID(Vehicle vehicle, int doorIndex)`
- **Purpose**: Checks whether a door index is valid for a given vehicle model.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `doorIndex` (`int`): Door index (0=driver, etc.).
  - **Returns**: `bool` validity.
- **OneSync / Networking**: Requires vehicle ownership to ensure door data is up to date.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: door_valid
        -- Use: Prints if specified door index is valid
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('door_valid', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local index = tonumber(args[1]) or 0
        print(GetIsDoorValid(veh, index))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: door_valid */
    RegisterCommand('door_valid', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const index = parseInt(args[0] || '0');
      console.log(GetIsDoorValid(veh, index));
    });
    ```
- **Caveats / Limitations**:
  - Door indices vary across vehicle types.
- **Reference**: https://docs.fivem.net/natives/?n=GetIsDoorValid

##### GetIsLeftVehicleHeadlightDamaged
- **Name**: GetIsLeftVehicleHeadlightDamaged
- **Scope**: Shared
- **Signature(s)**: `bool GET_IS_LEFT_VEHICLE_HEADLIGHT_DAMAGED(Vehicle vehicle)`
- **Purpose**: Determines whether the left headlight of a vehicle is broken.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool` damage status.
- **OneSync / Networking**: Requires vehicle ownership to read accurate damage state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: left_headlight
        -- Use: Prints left headlight damage status
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('left_headlight', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetIsLeftVehicleHeadlightDamaged(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: left_headlight */
    RegisterCommand('left_headlight', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetIsLeftVehicleHeadlightDamaged(veh));
    });
    ```
- **Caveats / Limitations**:
  - Damage state may be unreliable for remote vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=GetIsLeftVehicleHeadlightDamaged

##### GetIsRightVehicleHeadlightDamaged
- **Name**: GetIsRightVehicleHeadlightDamaged
- **Scope**: Shared
- **Signature(s)**: `bool GET_IS_RIGHT_VEHICLE_HEADLIGHT_DAMAGED(Vehicle vehicle)`
- **Purpose**: Checks whether the right headlight of a vehicle is broken.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool` damage status.
- **OneSync / Networking**: Ownership required for accurate results.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: right_headlight
        -- Use: Prints right headlight damage status
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('right_headlight', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetIsRightVehicleHeadlightDamaged(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: right_headlight */
    RegisterCommand('right_headlight', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetIsRightVehicleHeadlightDamaged(veh));
    });
    ```
- **Caveats / Limitations**:
  - Damage state may desync on non-owned vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=GetIsRightVehicleHeadlightDamaged

##### GetIsVehicleEngineRunning
- **Name**: GetIsVehicleEngineRunning
- **Scope**: Shared
- **Signature(s)**: `bool GET_IS_VEHICLE_ENGINE_RUNNING(Vehicle vehicle)`
- **Purpose**: Returns whether a vehicle's engine is currently active.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` engine running state.
- **OneSync / Networking**: Requires local ownership for real-time status.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: engine_running
        -- Use: Prints if vehicle engine is running
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('engine_running', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetIsVehicleEngineRunning(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: engine_running */
    RegisterCommand('engine_running', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetIsVehicleEngineRunning(veh));
    });
    ```
- **Caveats / Limitations**:
  - Engine state may lag behind for remote entities.
- **Reference**: https://docs.fivem.net/natives/?n=GetIsVehicleEngineRunning

##### GetIsVehiclePrimaryColourCustom
- **Name**: GetIsVehiclePrimaryColourCustom
- **Scope**: Shared
- **Signature(s)**: `bool GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(Vehicle vehicle)`
- **Purpose**: Determines whether a vehicle is using a custom primary paint.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - **Returns**: `bool` custom colour flag.
- **OneSync / Networking**: Requires vehicle ownership to read accurate cosmetic data.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: primary_colour
        -- Use: Prints if current vehicle has custom primary colour
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('primary_colour', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetIsVehiclePrimaryColourCustom(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: primary_colour */
    RegisterCommand('primary_colour', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetIsVehiclePrimaryColourCustom(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only reports true if a custom RGB colour was applied.
- **Reference**: https://docs.fivem.net/natives/?n=GetIsVehiclePrimaryColourCustom

##### GetIsVehicleSecondaryColourCustom
- **Name**: GetIsVehicleSecondaryColourCustom
- **Scope**: Shared
- **Signature(s)**: `bool GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(Vehicle vehicle)`
- **Purpose**: Checks if a vehicle has a custom secondary paint set.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - **Returns**: `bool` custom colour flag.
- **OneSync / Networking**: Entity ownership recommended for consistent results.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: secondary_colour
        -- Use: Prints if current vehicle has custom secondary colour
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('secondary_colour', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetIsVehicleSecondaryColourCustom(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: secondary_colour */
    RegisterCommand('secondary_colour', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetIsVehicleSecondaryColourCustom(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns false for vehicles without mod kits.
- **Reference**: https://docs.fivem.net/natives/?n=GetIsVehicleSecondaryColourCustom

##### _GetIsVehicleShuntBoostActive
- **Name**: _GetIsVehicleShuntBoostActive
- **Scope**: Shared
- **Signature(s)**: `bool _GET_IS_VEHICLE_SHUNT_BOOST_ACTIVE(Vehicle vehicle)`
- **Purpose**: Indicates whether the vehicle's Arena War shunt boost is active.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle equipped with shunt boost.
  - **Returns**: `bool` boost state.
- **OneSync / Networking**: Call from owning client to prevent desync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: shunt_active
        -- Use: Prints if shunt boost is active
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('shunt_active', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GetIsVehicleShuntBoostActive(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: shunt_active */
    RegisterCommand('shunt_active', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GetIsVehicleShuntBoostActive(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for vehicles with Arena War shunt boost modification.
- **Reference**: https://docs.fivem.net/natives/?n=_GetIsVehicleShuntBoostActive

##### _GetIsWheelsLoweredStateActive
- **Name**: _GetIsWheelsLoweredStateActive
- **Scope**: Shared
- **Signature(s)**: `bool _GET_IS_WHEELS_LOWERED_STATE_ACTIVE(Vehicle vehicle)`
- **Purpose**: Returns whether a vehicle's hydraulics are lowered.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target lowrider.
  - **Returns**: `bool` lowered state.
- **OneSync / Networking**: Ownership required to read suspension state accurately.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wheels_lowered
        -- Use: Prints if hydraulics are lowered
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('wheels_lowered', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GetIsWheelsLoweredStateActive(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wheels_lowered */
    RegisterCommand('wheels_lowered', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GetIsWheelsLoweredStateActive(veh));
    });
    ```
- **Caveats / Limitations**:
  - Applies only to vehicles with adjustable hydraulics.
- **Reference**: https://docs.fivem.net/natives/?n=_GetIsWheelsLoweredStateActive

##### GetLandingGearState
- **Name**: GetLandingGearState
- **Scope**: Shared
- **Signature(s)**: `int GET_LANDING_GEAR_STATE(Vehicle vehicle)`
- **Purpose**: Reports the current landing gear state of aircraft.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft to query.
  - **Returns**: `int` state (0 deployed, 1 closing, 3 opening, 4 retracted, 5 broken).
- **OneSync / Networking**: Use on owned aircraft to stay in sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: gear_state
        -- Use: Prints landing gear state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('gear_state', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetLandingGearState(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: gear_state */
    RegisterCommand('gear_state', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetLandingGearState(veh));
    });
    ```
- **Caveats / Limitations**:
  - State value 2 is unused.
- **Reference**: https://docs.fivem.net/natives/?n=GetLandingGearState

##### GetLastDrivenVehicle
- **Name**: GetLastDrivenVehicle
- **Scope**: Shared
- **Signature(s)**: `Vehicle GET_LAST_DRIVEN_VEHICLE()`
- **Purpose**: Retrieves the vehicle last operated by the local player.
- **Parameters / Returns**:
  - **Returns**: `Vehicle` handle or 0 if none.
- **OneSync / Networking**: Client-side query; result is local to caller.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: last_vehicle
        -- Use: Prints handle of last driven vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('last_vehicle', function()
        print(GetLastDrivenVehicle())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: last_vehicle */
    RegisterCommand('last_vehicle', () => {
      console.log(GetLastDrivenVehicle());
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if player has never driven a vehicle this session.
- **Reference**: https://docs.fivem.net/natives/?n=GetLastDrivenVehicle

##### GetLastPedInVehicleSeat
- **Name**: GetLastPedInVehicleSeat
- **Scope**: Shared
- **Signature(s)**: `Ped GET_LAST_PED_IN_VEHICLE_SEAT(Vehicle vehicle, int seatIndex)`
- **Purpose**: Returns the last ped occupying a specified seat.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - `seatIndex` (`int`): Seat identifier; see `IsVehicleSeatFree` for indices.
  - **Returns**: `Ped` handle or 0.
- **OneSync / Networking**: Seat history is local; ownership ensures accuracy.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: last_seat
        -- Use: Prints last ped in passenger seat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('last_seat', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetLastPedInVehicleSeat(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: last_seat */
    RegisterCommand('last_seat', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetLastPedInVehicleSeat(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if seat has never been occupied.
- **Reference**: https://docs.fivem.net/natives/?n=GetLastPedInVehicleSeat

##### _GetLastRammedVehicle
- **Name**: _GetLastRammedVehicle
- **Scope**: Shared
- **Signature(s)**: `Vehicle _GET_LAST_RAMMED_VEHICLE(Vehicle vehicle)`
- **Purpose**: Retrieves the last vehicle hit using the shunt boost mechanic.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle performing the ram.
  - **Returns**: `Vehicle` handle or 0.
- **OneSync / Networking**: Ownership required for reliable results.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: last_rammed
        -- Use: Prints last vehicle rammed with shunt boost
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('last_rammed', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GetLastRammedVehicle(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: last_rammed */
    RegisterCommand('last_rammed', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GetLastRammedVehicle(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only applicable to vehicles with shunt boost.
- **Reference**: https://docs.fivem.net/natives/?n=_GetLastRammedVehicle

##### GetLiveryName
- **Name**: GetLiveryName
- **Scope**: Shared
- **Signature(s)**: `char* GET_LIVERY_NAME(Vehicle vehicle, int liveryIndex)`
- **Purpose**: Returns the internal label for a vehicle livery.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - `liveryIndex` (`int`): Index from 0 to `GetVehicleLiveryCount`-1.
  - **Returns**: `string` label (use `_GET_LABEL_TEXT` for localized name).
- **OneSync / Networking**: Requires mod kit present and vehicle ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: livery_name
        -- Use: Prints label of current livery
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('livery_name', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local idx = GetVehicleLivery(veh)
        print(GetLiveryName(veh, idx))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: livery_name */
    RegisterCommand('livery_name', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const idx = GetVehicleLivery(veh);
      console.log(GetLiveryName(veh, idx));
    });
    ```
- **Caveats / Limitations**:
  - Returns null if mod kit is not initialized.
- **Reference**: https://docs.fivem.net/natives/?n=GetLiveryName

##### GetMakeNameFromVehicleModel
- **Name**: GetMakeNameFromVehicleModel
- **Scope**: Shared
- **Signature(s)**: `char* GET_MAKE_NAME_FROM_VEHICLE_MODEL(Hash modelHash)`
- **Purpose**: Retrieves the manufacturer label associated with a vehicle model.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Vehicle model identifier.
  - **Returns**: `string` manufacturer label or "CARNOTFOUND".
- **OneSync / Networking**: Pure lookup; no network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: make_name
        -- Use: Prints manufacturer of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('make_name', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetMakeNameFromVehicleModel(GetEntityModel(veh)))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: make_name */
    RegisterCommand('make_name', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetMakeNameFromVehicleModel(GetEntityModel(veh)));
    });
    ```
- **Caveats / Limitations**:
  - Returns "CARNOTFOUND" for unknown models.
- **Reference**: https://docs.fivem.net/natives/?n=GetMakeNameFromVehicleModel

##### GetModSlotName
- **Name**: GetModSlotName
- **Scope**: Shared
- **Signature(s)**: `char* GET_MOD_SLOT_NAME(Vehicle vehicle, int modType)`
- **Purpose**: Provides the label of a vehicle modification slot.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `modType` (`int`): Modification category.
  - **Returns**: `string` slot label.
- **OneSync / Networking**: Ownership ensures correct mod kit data.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mod_slot
        -- Use: Prints label of mod slot 0
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mod_slot', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetModSlotName(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mod_slot */
    RegisterCommand('mod_slot', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetModSlotName(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Requires mod kit set with `SetVehicleModKit`.
- **Reference**: https://docs.fivem.net/natives/?n=GetModSlotName

##### GetModTextLabel
- **Name**: GetModTextLabel
- **Scope**: Shared
- **Signature(s)**: `char* GET_MOD_TEXT_LABEL(Vehicle vehicle, int modType, int modValue)`
- **Purpose**: Fetches the internal label for a specific mod option.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `modType` (`int`): Modification category.
  - `modValue` (`int`): Index within the category.
  - **Returns**: `string` label.
- **OneSync / Networking**: Ownership required for mod data consistency.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mod_label
        -- Use: Prints label of spoiler option 0
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mod_label', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetModTextLabel(veh, 0, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mod_label */
    RegisterCommand('mod_label', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetModTextLabel(veh, 0, 0));
    });
    ```
- **Caveats / Limitations**:
  - Use `_GET_LABEL_TEXT` to localize the label.
- **Reference**: https://docs.fivem.net/natives/?n=GetModTextLabel

##### GetNumModColors
- **Name**: GetNumModColors
- **Scope**: Shared
- **Signature(s)**: `int GET_NUM_MOD_COLORS(int paintType, BOOL p1)`
- **Purpose**: Returns the number of available colours for a paint type.
- **Parameters / Returns**:
  - `paintType` (`int`): Paint category (0 normal, 1 metallic, 2 pearl, 3 matte, 4 metal, 5 chrome).
  - `p1` (`bool`): Unknown flag.
  - **Returns**: `int` colour count.
- **OneSync / Networking**: Pure lookup; no network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mod_colors
        -- Use: Prints number of metallic colours
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mod_colors', function()
        print(GetNumModColors(1, false))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mod_colors */
    RegisterCommand('mod_colors', () => {
      console.log(GetNumModColors(1, false));
    });
    ```
- **Caveats / Limitations**:
  - Second parameter is undocumented.
  - TODO(next-run): verify semantics of `p1`.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumModColors

##### GetNumModKits
- **Name**: GetNumModKits
- **Scope**: Shared
- **Signature(s)**: `int GET_NUM_MOD_KITS(Vehicle vehicle)`
- **Purpose**: Retrieves number of mod kits available for a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` mod kit count.
- **OneSync / Networking**: Ownership required to access mod kit data.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mod_kits
        -- Use: Prints number of mod kits on current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mod_kits', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetNumModKits(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mod_kits */
    RegisterCommand('mod_kits', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetNumModKits(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 for vehicles without mod support.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumModKits

##### GetNumVehicleMods
- **Name**: GetNumVehicleMods
- **Scope**: Shared
- **Signature(s)**: `int GET_NUM_VEHICLE_MODS(Vehicle vehicle, int modType)`
- **Purpose**: Gives the count of modification options for a category.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `modType` (`int`): Modification category.
  - **Returns**: `int` number of mods.
- **OneSync / Networking**: Call on owner to receive accurate counts.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mod_count
        -- Use: Prints number of spoiler options
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mod_count', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetNumVehicleMods(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mod_count */
    RegisterCommand('mod_count', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetNumVehicleMods(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Some categories may return 0 even if visible in game.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumVehicleMods
##### GetNumVehicleWindowTints
- **Name**: GetNumVehicleWindowTints
- **Scope**: Shared
- **Signature(s)**: `int GET_NUM_VEHICLE_WINDOW_TINTS()`
- **Purpose**: Returns the total number of window tint options available.
- **Parameters / Returns**:
  - **Returns**: `int` tint count.
- **OneSync / Networking**: Pure lookup; no replication concerns.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tint_count
        -- Use: Prints available window tint count
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tint_count', function()
        print(GetNumVehicleWindowTints())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tint_count */
    RegisterCommand('tint_count', () => {
      console.log(GetNumVehicleWindowTints());
    });
    ```
- **Caveats / Limitations**:
  - Documentation does not clarify if stock tint is counted.
  - TODO(next-run): verify enumeration order.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumVehicleWindowTints

##### GetNumberOfVehicleColours
- **Name**: GetNumberOfVehicleColours
- **Scope**: Shared
- **Signature(s)**: `int GET_NUMBER_OF_VEHICLE_COLOURS(Vehicle vehicle)`
- **Purpose**: Returns the number of colour combinations available for the specified vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - **Returns**: `int` combination count.
- **OneSync / Networking**: Query on entity owner to ensure modded colours are considered.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: color_combos
        -- Use: Prints colour combinations for current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('color_combos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetNumberOfVehicleColours(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: color_combos */
    RegisterCommand('color_combos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetNumberOfVehicleColours(veh));
    });
    ```
- **Caveats / Limitations**:
  - Function name suggests colours but actually counts combinations.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumberOfVehicleColours

##### _GET_NUMBER_OF_VEHICLE_DOORS
- **Name**: _GET_NUMBER_OF_VEHICLE_DOORS
- **Scope**: Shared
- **Signature(s)**: `int _GET_NUMBER_OF_VEHICLE_DOORS(Vehicle vehicle)`
- **Purpose**: Retrieves the number of door indices supported by a vehicle model.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `int` door count.
- **OneSync / Networking**: Call on entity owner for consistent mod states.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: door_count
        -- Use: Prints door count of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('door_count', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GET_NUMBER_OF_VEHICLE_DOORS(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: door_count */
    RegisterCommand('door_count', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GET_NUMBER_OF_VEHICLE_DOORS(veh));
    });
    ```
- **Caveats / Limitations**:
  - Undocumented native; may not exist for all vehicle types.
  - TODO(next-run): confirm behavior for bikes and boats.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_NUMBER_OF_VEHICLE_DOORS

##### GetNumberOfVehicleNumberPlates
- **Name**: GetNumberOfVehicleNumberPlates
- **Scope**: Shared
- **Signature(s)**: `int GET_NUMBER_OF_VEHICLE_NUMBER_PLATES()`
- **Purpose**: Returns the count of available licence plate styles.
- **Parameters / Returns**:
  - **Returns**: `int` style count.
- **OneSync / Networking**: Static query; no networking impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: plate_styles
        -- Use: Prints number plate style count
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('plate_styles', function()
        print(GetNumberOfVehicleNumberPlates())
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: plate_styles */
    RegisterCommand('plate_styles', () => {
      console.log(GetNumberOfVehicleNumberPlates());
    });
    ```
- **Caveats / Limitations**:
  - Returns total styles, not which are unlockable.
- **Reference**: https://docs.fivem.net/natives/?n=GetNumberOfVehicleNumberPlates

##### GetPedInVehicleSeat
- **Name**: GetPedInVehicleSeat
- **Scope**: Shared
- **Signature(s)**: `Ped GET_PED_IN_VEHICLE_SEAT(Vehicle vehicle, int seatIndex)`
- **Purpose**: Retrieves the ped occupying a specific seat of a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `seatIndex` (`int`): Seat identifier (-1 driver, 0 front passenger, etc.).
  - **Returns**: `Ped` handle or 0.
- **OneSync / Networking**: Ensure the vehicle is owned locally for accurate state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: seat_driver
        -- Use: Prints ped in driver's seat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('seat_driver', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetPedInVehicleSeat(veh, -1))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: seat_driver */
    RegisterCommand('seat_driver', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetPedInVehicleSeat(veh, -1));
    });
    ```
- **Caveats / Limitations**:
  - Ambient vehicles may spawn temporary occupants if seat is empty.
- **Reference**: https://docs.fivem.net/natives/?n=GetPedInVehicleSeat

##### GetPedUsingVehicleDoor
- **Name**: GetPedUsingVehicleDoor
- **Scope**: Shared
- **Signature(s)**: `Ped GET_PED_USING_VEHICLE_DOOR(Vehicle vehicle, int doorIndex)`
- **Purpose**: Returns the ped currently operating a given vehicle door.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `doorIndex` (`int`): Door identifier.
  - **Returns**: `Ped` handle or 0.
- **OneSync / Networking**: Query owner for real-time status.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: door_user
        -- Use: Prints ped using door 0
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('door_user', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetPedUsingVehicleDoor(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: door_user */
    RegisterCommand('door_user', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetPedUsingVehicleDoor(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Door indices vary by vehicle class.
- **Reference**: https://docs.fivem.net/natives/?n=GetPedUsingVehicleDoor

##### GetPositionInRecording
- **Name**: GetPositionInRecording
- **Scope**: Shared
- **Signature(s)**: `float GET_POSITION_IN_RECORDING(Vehicle vehicle)`
- **Purpose**: Returns distance traveled along the vehicle's current recording playback.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with active recording.
  - **Returns**: `float` travelled distance.
- **OneSync / Networking**: Recording playback occurs client-side; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_pos
        -- Use: Prints distance along recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_pos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetPositionInRecording(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_pos */
    RegisterCommand('rec_pos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetPositionInRecording(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if no recording is active.
- **Reference**: https://docs.fivem.net/natives/?n=GetPositionInRecording

##### GetPositionOfVehicleRecordingAtTime
- **Name**: GetPositionOfVehicleRecordingAtTime
- **Scope**: Shared
- **Signature(s)**: `Vector3 GET_POSITION_OF_VEHICLE_RECORDING_AT_TIME(int recording, float time, char* script)`
- **Purpose**: Provides the world coordinates of a path point in a vehicle recording at a given time.
- **Parameters / Returns**:
  - `recording` (`int`): Recording handle.
  ￼  - `time` (`float`): Playback time.
  - `script` (`string`): Recording identifier.
  - **Returns**: `Vector3` position.
- **OneSync / Networking**: Local lookup; results not automatically replicated.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_pos_at
        -- Use: Prints position at 10s into recording 0
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_pos_at', function()
        local pos = GetPositionOfVehicleRecordingAtTime(0, 10.0, 'recording1')
        print(('%s,%s,%s'):format(pos.x, pos.y, pos.z))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_pos_at */
    RegisterCommand('rec_pos_at', () => {
      const pos = GetPositionOfVehicleRecordingAtTime(0, 10.0, 'recording1');
      console.log(`${pos.x},${pos.y},${pos.z}`);
    });
    ```
- **Caveats / Limitations**:
  - No interpolation between points; results step between path nodes.
- **Reference**: https://docs.fivem.net/natives/?n=GetPositionOfVehicleRecordingAtTime

##### GetPositionOfVehicleRecordingIdAtTime
- **Name**: GetPositionOfVehicleRecordingIdAtTime
- **Scope**: Shared
- **Signature(s)**: `Vector3 GET_POSITION_OF_VEHICLE_RECORDING_ID_AT_TIME(int id, float time)`
- **Purpose**: Retrieves position from a recording referenced by ID at a specified time.
- **Parameters / Returns**:
  - `id` (`int`): Recording ID from `GetVehicleRecordingId`.
  - `time` (`float`): Playback time.
  - **Returns**: `Vector3` position.
- **OneSync / Networking**: Local computation only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_id_pos
        -- Use: Prints position at 5s into recording id
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_id_pos', function()
        local pos = GetPositionOfVehicleRecordingIdAtTime(0, 5.0)
        print(('%s,%s,%s'):format(pos.x, pos.y, pos.z))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_id_pos */
    RegisterCommand('rec_id_pos', () => {
      const pos = GetPositionOfVehicleRecordingIdAtTime(0, 5.0);
      console.log(`${pos.x},${pos.y},${pos.z}`);
    });
    ```
- **Caveats / Limitations**:
  - Requires recording loaded via `RequestVehicleRecording`.
- **Reference**: https://docs.fivem.net/natives/?n=GetPositionOfVehicleRecordingIdAtTime

##### GetRandomVehicleBackBumperInSphere
- **Name**: GetRandomVehicleBackBumperInSphere
- **Scope**: Shared
- **Signature(s)**: `Vehicle GET_RANDOM_VEHICLE_BACK_BUMPER_IN_SPHERE(float x, float y, float z, float radius, int p4, int p5, int p6)`
- **Purpose**: Finds a vehicle whose rear bumper lies within a sphere.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Sphere centre.
  - `radius` (`float`): Search radius.
  - `p4`, `p5`, `p6` (`int`): Unknown flags.
  - **Returns**: `Vehicle` handle or 0.
- **OneSync / Networking**: Search occurs locally; ensure area is streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: random_back
        -- Use: Prints vehicle found behind player
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('random_back', function()
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetRandomVehicleBackBumperInSphere(coords.x, coords.y, coords.z, 5.0, 0, 0, 0)
        print(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: random_back */
    RegisterCommand('random_back', () => {
      const coords = GetEntityCoords(PlayerPedId());
      const veh = GetRandomVehicleBackBumperInSphere(coords[0], coords[1], coords[2], 5.0, 0, 0, 0);
      console.log(veh);
    });
    ```
- **Caveats / Limitations**:
  - Parameters after radius are undocumented.
  - TODO(next-run): verify search behaviour and flags.
- **Reference**: https://docs.fivem.net/natives/?n=GetRandomVehicleBackBumperInSphere

##### GetRandomVehicleFrontBumperInSphere
- **Name**: GetRandomVehicleFrontBumperInSphere
- **Scope**: Shared
- **Signature(s)**: `Vehicle GET_RANDOM_VEHICLE_FRONT_BUMPER_IN_SPHERE(float x, float y, float z, float radius, int p4, int p5, int p6)`
- **Purpose**: Retrieves a vehicle whose front bumper is within a sphere.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Sphere centre.
  - `radius` (`float`): Search radius.
  - `p4`, `p5`, `p6` (`int`): Unknown flags.
  - **Returns**: `Vehicle` handle or 0.
- **OneSync / Networking**: Local search; requires streaming.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: random_front
        -- Use: Prints vehicle found in front sphere
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('random_front', function()
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetRandomVehicleFrontBumperInSphere(coords.x, coords.y, coords.z, 5.0, 0, 0, 0)
        print(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: random_front */
    RegisterCommand('random_front', () => {
      const coords = GetEntityCoords(PlayerPedId());
      const veh = GetRandomVehicleFrontBumperInSphere(coords[0], coords[1], coords[2], 5.0, 0, 0, 0);
      console.log(veh);
    });
    ```
- **Caveats / Limitations**:
  - Behaviour of unknown flags needs confirmation.
  - TODO(next-run): clarify p4–p6.
- **Reference**: https://docs.fivem.net/natives/?n=GetRandomVehicleFrontBumperInSphere

##### GetRandomVehicleInSphere
- **Name**: GetRandomVehicleInSphere
- **Scope**: Shared
- **Signature(s)**: `Vehicle GET_RANDOM_VEHICLE_IN_SPHERE(float x, float y, float z, float radius, Hash modelHash, int flags)`
- **Purpose**: Returns a random vehicle within a sphere, optionally filtered by model.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Sphere centre.
  - `radius` (`float`): Search radius.
  - `modelHash` (`Hash`): Filter; 0 for any.
  - `flags` (`int`): Search behaviour flags.
  - **Returns**: `Vehicle` handle or 0.
- **OneSync / Networking**: Local search; ensure entities are streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: random_vehicle
        -- Use: Prints random nearby vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('random_vehicle', function()
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetRandomVehicleInSphere(coords.x, coords.y, coords.z, 10.0, 0, 0)
        print(veh)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: random_vehicle */
    RegisterCommand('random_vehicle', () => {
      const coords = GetEntityCoords(PlayerPedId());
      const veh = GetRandomVehicleInSphere(coords[0], coords[1], coords[2], 10.0, 0, 0);
      console.log(veh);
    });
    ```
- **Caveats / Limitations**:
  - Flag meanings are largely undocumented.
  - TODO(next-run): enumerate flag options.
- **Reference**: https://docs.fivem.net/natives/?n=GetRandomVehicleInSphere

##### GetRandomVehicleModelInMemory
- **Name**: GetRandomVehicleModelInMemory
- **Scope**: Shared
- **Signature(s)**: `void GET_RANDOM_VEHICLE_MODEL_IN_MEMORY(BOOL p0, Hash* modelHash, int* successIndicator)`
- **Purpose**: Selects a random vehicle model loaded in memory.
- **Parameters / Returns**:
  - `p0` (`bool`): Unknown, usually true.
  - `modelHash` (`Hash*`): Output model hash pointer.
  - `successIndicator` (`int*`): Output status (0 success, -1 fail).
- **OneSync / Networking**: Model lookup only; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: random_model
        -- Use: Prints a random loaded vehicle model
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('random_model', function()
        local modelPtr = Citizen.PointerValueInt()
        local okPtr = Citizen.PointerValueInt()
        GetRandomVehicleModelInMemory(true, modelPtr, okPtr)
        print(('model:%s ok:%s'):format(Citizen.PointerValueInt(modelPtr), Citizen.PointerValueInt(okPtr)))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: random_model */
    RegisterCommand('random_model', () => {
      const modelPtr = Memory.alloc(8);
      const okPtr = Memory.alloc(4);
      GetRandomVehicleModelInMemory(true, modelPtr, okPtr);
      console.log(`model:${Memory.readInt(modelPtr)} ok:${Memory.readInt(okPtr)}`);
    });
    ```
- **Caveats / Limitations**:
  - Low-level pointer use; not available in all runtimes.
  - TODO(next-run): validate pointer helper functions per runtime.
- **Reference**: https://docs.fivem.net/natives/?n=GetRandomVehicleModelInMemory

##### _GET_REMAINING_NITROUS_DURATION
- **Name**: _GET_REMAINING_NITROUS_DURATION
- **Scope**: Shared
- **Signature(s)**: `float _GET_REMAINING_NITROUS_DURATION(Vehicle vehicle)`
- **Purpose**: Returns remaining nitrous boost time for a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with nitrous system.
  - **Returns**: `float` seconds remaining.
- **OneSync / Networking**: Query on owner to reflect current state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nitro_time
        -- Use: Prints nitrous time left
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('nitro_time', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GET_REMAINING_NITROUS_DURATION(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nitro_time */
    RegisterCommand('nitro_time', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GET_REMAINING_NITROUS_DURATION(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only relevant when nitrous system is active.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_REMAINING_NITROUS_DURATION

##### GetRotationOfVehicleRecordingAtTime
- **Name**: GetRotationOfVehicleRecordingAtTime
- **Scope**: Shared
- **Signature(s)**: `Vector3 GET_ROTATION_OF_VEHICLE_RECORDING_AT_TIME(int recording, float time, char* script)`
- **Purpose**: Retrieves the rotation at a time within a vehicle recording.
- **Parameters / Returns**:
  - `recording` (`int`): Recording handle.
  - `time` (`float`): Playback time.
  - `script` (`string`): Recording identifier.
  - **Returns**: `Vector3` rotation (deg).
- **OneSync / Networking**: Local computation; no network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_rot_at
        -- Use: Prints rotation at 10s of recording 0
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_rot_at', function()
        local rot = GetRotationOfVehicleRecordingAtTime(0, 10.0, 'recording1')
        print(('%s,%s,%s'):format(rot.x, rot.y, rot.z))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_rot_at */
    RegisterCommand('rec_rot_at', () => {
      const rot = GetRotationOfVehicleRecordingAtTime(0, 10.0, 'recording1');
      console.log(`${rot.x},${rot.y},${rot.z}`);
    });
    ```
- **Caveats / Limitations**:
  - No interpolation between keyframes.
- **Reference**: https://docs.fivem.net/natives/?n=GetRotationOfVehicleRecordingAtTime

##### GetRotationOfVehicleRecordingIdAtTime
- **Name**: GetRotationOfVehicleRecordingIdAtTime
- **Scope**: Shared
- **Signature(s)**: `Vector3 GET_ROTATION_OF_VEHICLE_RECORDING_ID_AT_TIME(int id, float time)`
- **Purpose**: Returns rotation for a recording referenced by ID.
- **Parameters / Returns**:
  - `id` (`int`): Recording ID.
  - `time` (`float`): Playback time.
  - **Returns**: `Vector3` rotation.
- **OneSync / Networking**: Local lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_id_rot
        -- Use: Prints rotation at 5s into recording id
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_id_rot', function()
        local rot = GetRotationOfVehicleRecordingIdAtTime(0, 5.0)
        print(('%s,%s,%s'):format(rot.x, rot.y, rot.z))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_id_rot */
    RegisterCommand('rec_id_rot', () => {
      const rot = GetRotationOfVehicleRecordingIdAtTime(0, 5.0);
      console.log(`${rot.x},${rot.y},${rot.z}`);
    });
    ```
- **Caveats / Limitations**:
  - Requires preloaded recording.
- **Reference**: https://docs.fivem.net/natives/?n=GetRotationOfVehicleRecordingIdAtTime

##### GetSubmarineIsUnderDesignDepth
- **Name**: GetSubmarineIsUnderDesignDepth
- **Scope**: Shared
- **Signature(s)**: `BOOL GET_SUBMARINE_IS_UNDER_DESIGN_DEPTH(Vehicle submarine)`
- **Purpose**: Checks if a submarine is below its safe operating depth.
- **Parameters / Returns**:
  - `submarine` (`Vehicle`): Submarine entity.
  - **Returns**: `bool` true if below design depth.
- **OneSync / Networking**: Query owner for accurate depth.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sub_depth
        -- Use: Prints if submarine is too deep
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('sub_depth', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetSubmarineIsUnderDesignDepth(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sub_depth */
    RegisterCommand('sub_depth', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetSubmarineIsUnderDesignDepth(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only meaningful for submarine models.
- **Reference**: https://docs.fivem.net/natives/?n=GetSubmarineIsUnderDesignDepth

##### GetSubmarineNumberOfAirLeaks
- **Name**: GetSubmarineNumberOfAirLeaks
- **Scope**: Shared
- **Signature(s)**: `int GET_SUBMARINE_NUMBER_OF_AIR_LEAKS(Vehicle submarine)`
- **Purpose**: Returns how many air leaks a submarine currently has.
- **Parameters / Returns**:
  - `submarine` (`Vehicle`): Submarine vehicle.
  - **Returns**: `int` leak count.
- **OneSync / Networking**: Query on owner for real-time state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sub_leaks
        -- Use: Prints submarine air leak count
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('sub_leaks', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetSubmarineNumberOfAirLeaks(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sub_leaks */
    RegisterCommand('sub_leaks', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetSubmarineNumberOfAirLeaks(veh));
    });
    ```
- **Caveats / Limitations**:
  - Exceeding four leaks causes player drowning.
- **Reference**: https://docs.fivem.net/natives/?n=GetSubmarineNumberOfAirLeaks

##### GetTimePositionInRecording
- **Name**: GetTimePositionInRecording
- **Scope**: Shared
- **Signature(s)**: `float GET_TIME_POSITION_IN_RECORDING(Vehicle vehicle)`
- **Purpose**: Returns the elapsed time within the vehicle's current recording playback.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with recording.
  - **Returns**: `float` time in seconds.
- **OneSync / Networking**: Client-side; no network effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_time
        -- Use: Prints recording time
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_time', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetTimePositionInRecording(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_time */
    RegisterCommand('rec_time', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetTimePositionInRecording(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if recording not started.
- **Reference**: https://docs.fivem.net/natives/?n=GetTimePositionInRecording

##### GetTotalDurationOfVehicleRecording
- **Name**: GetTotalDurationOfVehicleRecording
- **Scope**: Shared
- **Signature(s)**: `float GET_TOTAL_DURATION_OF_VEHICLE_RECORDING(int recording, char* script)`
- **Purpose**: Retrieves total length of a vehicle recording.
- **Parameters / Returns**:
  - `recording` (`int`): Recording handle.
  - `script` (`string`): Recording identifier.
  - **Returns**: `float` total duration.
- **OneSync / Networking**: Local lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_total
        -- Use: Prints total duration of recording 0
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_total', function()
        print(GetTotalDurationOfVehicleRecording(0, 'recording1'))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_total */
    RegisterCommand('rec_total', () => {
      console.log(GetTotalDurationOfVehicleRecording(0, 'recording1'));
    });
    ```
- **Caveats / Limitations**:
  - Recording must be requested before calling.
- **Reference**: https://docs.fivem.net/natives/?n=GetTotalDurationOfVehicleRecording

##### GetTotalDurationOfVehicleRecordingId
- **Name**: GetTotalDurationOfVehicleRecordingId
- **Scope**: Shared
- **Signature(s)**: `float GET_TOTAL_DURATION_OF_VEHICLE_RECORDING_ID(int id)`
- **Purpose**: Returns total duration for a recording referenced by ID.
- **Parameters / Returns**:
  - `id` (`int`): Recording ID.
  - **Returns**: `float` total time.
- **OneSync / Networking**: Local computation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rec_id_total
        -- Use: Prints total duration for recording id
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rec_id_total', function()
        print(GetTotalDurationOfVehicleRecordingId(0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rec_id_total */
    RegisterCommand('rec_id_total', () => {
      console.log(GetTotalDurationOfVehicleRecordingId(0));
    });
    ```
- **Caveats / Limitations**:
  - Requires valid recording ID.
- **Reference**: https://docs.fivem.net/natives/?n=GetTotalDurationOfVehicleRecordingId

##### GetTrainCarriage
- **Name**: GetTrainCarriage
- **Scope**: Shared
- **Signature(s)**: `Entity GET_TRAIN_CARRIAGE(Vehicle train, int trailerNumber)`
- **Purpose**: Retrieves a handle to a train carriage by index.
- **Parameters / Returns**:
  - `train` (`Vehicle`): Train engine entity.
  - `trailerNumber` (`int`): Carriage index starting at 1.
  - **Returns**: `Entity` carriage handle or 0.
- **OneSync / Networking**: Owner must query to ensure valid entity.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: carriage
        -- Use: Prints handle for first carriage
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('carriage', function()
        local train = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetTrainCarriage(train, 1))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: carriage */
    RegisterCommand('carriage', () => {
      const train = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetTrainCarriage(train, 1));
    });
    ```
- **Caveats / Limitations**:
  - Trailer numbering is 1-based and depends on train length.
- **Reference**: https://docs.fivem.net/natives/?n=GetTrainCarriage

##### _GET_TYRE_HEALTH
- **Name**: _GET_TYRE_HEALTH
- **Scope**: Shared
- **Signature(s)**: `float _GET_TYRE_HEALTH(Vehicle vehicle, int wheelIndex)`
- **Purpose**: Returns the health value of a vehicle tyre.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `wheelIndex` (`int`): Tyre index.
  - **Returns**: `float` health from 0–1000.
- **OneSync / Networking**: Query owner to reflect current damage.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tyre_health
        -- Use: Prints health of front-left tyre
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tyre_health', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GET_TYRE_HEALTH(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tyre_health */
    RegisterCommand('tyre_health', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GET_TYRE_HEALTH(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Returns 1000 for pristine tyres.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_TYRE_HEALTH

##### _GET_TYRE_WEAR_MULTIPLIER
- **Name**: _GET_TYRE_WEAR_MULTIPLIER
- **Scope**: Shared
- **Signature(s)**: `float _GET_TYRE_WEAR_MULTIPLIER(Vehicle vehicle, int wheelIndex)`
- **Purpose**: Retrieves tyre wear multiplier affecting degradation rate.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `wheelIndex` (`int`): Tyre index.
  - **Returns**: `float` wear multiplier.
- **OneSync / Networking**: Owner query needed for sync accuracy.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tyre_wear
        -- Use: Prints wear multiplier of front-left tyre
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tyre_wear', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GET_TYRE_WEAR_MULTIPLIER(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tyre_wear */
    RegisterCommand('tyre_wear', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GET_TYRE_WEAR_MULTIPLIER(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Multiplier defaults to 1.0; meaning of other values undocumented.
  - TODO(next-run): confirm range.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_TYRE_WEAR_MULTIPLIER

##### GetVehicleAcceleration
- **Name**: GetVehicleAcceleration
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_ACCELERATION(Vehicle vehicle)`
- **Purpose**: Returns the base acceleration stat of a vehicle considering mods.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` acceleration value.
- **OneSync / Networking**: Use on owner for modded vehicles to ensure accuracy.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: accel
        -- Use: Prints acceleration of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('accel', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleAcceleration(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: accel */
    RegisterCommand('accel', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleAcceleration(veh));
    });
    ```
  - C#:
    ```cs
    // Command: accel
    using static CitizenFX.Core.Native.API;
    RegisterCommand("accel", new Action<int, List<object>, string>((src, args, raw) => {
        var veh = GetVehiclePedIsIn(PlayerPedId(), false);
        Debug.WriteLine(GetVehicleAcceleration(veh).ToString());
    }), false);
    ```
- **Caveats / Limitations**:
  - Value is static; does not reflect temporary boosts.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleAcceleration
##### GetVehicleAttachedToCargobob
- **Name**: GetVehicleAttachedToCargobob
- **Scope**: Shared
- **Signature(s)**: `Vehicle GET_VEHICLE_ATTACHED_TO_CARGOBOB(Vehicle cargobob)`
- **Purpose**: Returns the vehicle currently hooked to a Cargobob.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Cargobob handle.
  - **Returns**: `Vehicle` handle or `0` if none.
- **OneSync / Networking**: Call on the helicopter's owner to ensure accurate state in OneSync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hooked
        -- Use: Prints vehicle attached to current Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('hooked', function()
        local cb = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleAttachedToCargobob(cb))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hooked */
    RegisterCommand('hooked', () => {
      const cb = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleAttachedToCargobob(cb));
    });
    ```
- **Caveats / Limitations**:
  - Only returns a vehicle if the Cargobob model has a working hook.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleAttachedToCargobob

##### GetVehicleBodyHealth
- **Name**: GetVehicleBodyHealth
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_BODY_HEALTH(Vehicle vehicle)`
- **Purpose**: Retrieves chassis health (0–1000) independent of engine health.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - **Returns**: `float` body health.
- **OneSync / Networking**: Query on entity owner for up-to-date damage state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: body_health
        -- Use: Prints body health of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('body_health', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleBodyHealth(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: body_health */
    RegisterCommand('body_health', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleBodyHealth(veh));
    });
    ```
- **Caveats / Limitations**:
  - Vehicle may remain drivable even at 0 health.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleBodyHealth

##### _GET_VEHICLE_BOMB_COUNT
- **Name**: _GET_VEHICLE_BOMB_COUNT
- **Scope**: Shared
- **Signature(s)**: `int _GET_VEHICLE_BOMB_COUNT(Vehicle aircraft)`
- **Purpose**: Returns number of bombs stored on an aircraft.
- **Parameters / Returns**:
  - `aircraft` (`Vehicle`): Plane or VTOL handle.
  - **Returns**: `int` remaining bombs.
- **OneSync / Networking**: Use on entity owner to track bomb inventory across clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: bomb_count
        -- Use: Prints remaining bomb count
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('bomb_count', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleBombCount(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: bomb_count */
    RegisterCommand('bomb_count', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleBombCount(veh));
    });
    ```
- **Caveats / Limitations**:
  - Does not directly affect weapon ammo; scripts must enforce usage.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleBombCount

##### _GET_VEHICLE_CAN_ACTIVATE_PARACHUTE
- **Name**: _GET_VEHICLE_CAN_ACTIVATE_PARACHUTE
- **Scope**: Shared
- **Signature(s)**: `BOOL _GET_VEHICLE_CAN_ACTIVATE_PARACHUTE(Vehicle vehicle)`
- **Purpose**: Checks if a parachute system can be engaged for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - **Returns**: `bool` parachute availability.
- **OneSync / Networking**: Local check; server should validate parachute deployment separately.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: can_para
        -- Use: Prints if vehicle supports parachute
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('can_para', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleCanActivateParachute(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: can_para */
    RegisterCommand('can_para', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleCanActivateParachute(veh));
    });
    ```
- **Caveats / Limitations**:
  - Documentation lacks detail on conditions.
  - TODO(next-run): verify server support.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleCanActivateParachute

##### GetVehicleCauseOfDestruction
- **Name**: GetVehicleCauseOfDestruction
- **Scope**: Shared
- **Signature(s)**: `Hash GET_VEHICLE_CAUSE_OF_DESTRUCTION(Vehicle vehicle)`
- **Purpose**: Returns weapon hash that destroyed the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Destroyed vehicle.
  - **Returns**: `Hash` of destruction cause or `0`.
- **OneSync / Networking**: Requires entity existence; servers should verify against abuse.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: destroy_cause
        -- Use: Prints hash that destroyed the last vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('destroy_cause', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), true)
        print(GetVehicleCauseOfDestruction(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: destroy_cause */
    RegisterCommand('destroy_cause', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), true);
      console.log(GetVehicleCauseOfDestruction(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if cause unknown.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleCauseOfDestruction

##### GetVehicleClass
- **Name**: GetVehicleClass
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_CLASS(Vehicle vehicle)`
- **Purpose**: Returns the class index of the vehicle model.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `int` class ID (0=Compacts … 22=Open Wheel).
- **OneSync / Networking**: Pure lookup; no replication concerns.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_class
        -- Use: Prints class ID of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_class', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleClass(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_class */
    RegisterCommand('veh_class', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleClass(veh));
    });
    ```
- **Caveats / Limitations**:
  - Class name translation requires lookup tables.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleClass

##### GetVehicleClassEstimatedMaxSpeed
- **Name**: GetVehicleClassEstimatedMaxSpeed
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_CLASS_ESTIMATED_MAX_SPEED(int vehicleClass)`
- **Purpose**: Returns the estimated top speed for a vehicle class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: `float` speed value in m/s.
- **OneSync / Networking**: Constant lookup; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: class_max_speed
        -- Use: Prints estimated max speed for class 6 (Sports)
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('class_max_speed', function()
        print(GetVehicleClassEstimatedMaxSpeed(6))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: class_max_speed */
    RegisterCommand('class_max_speed', () => {
      console.log(GetVehicleClassEstimatedMaxSpeed(6));
    });
    ```
- **Caveats / Limitations**:
  - Values are approximations and ignore modifications.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleClassEstimatedMaxSpeed

##### GetVehicleClassFromName
- **Name**: GetVehicleClassFromName
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_CLASS_FROM_NAME(Hash modelHash)`
- **Purpose**: Retrieves class ID for a model hash without spawning the vehicle.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Model identifier.
  - **Returns**: `int` class ID.
- **OneSync / Networking**: Server-side lookup useful for validation before spawn.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: class_from_name
        -- Use: Prints class of adder model
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('class_from_name', function()
        print(GetVehicleClassFromName(joaat('adder')))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: class_from_name */
    RegisterCommand('class_from_name', () => {
      console.log(GetVehicleClassFromName(joaat('adder')));
    });
    ```
- **Caveats / Limitations**:
  - Requires hashed model names.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleClassFromName

##### GetVehicleClassMaxAcceleration
- **Name**: GetVehicleClassMaxAcceleration
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_CLASS_MAX_ACCELERATION(int vehicleClass)`
- **Purpose**: Gives the baseline acceleration stat for a vehicle class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: `float` acceleration stat.
- **OneSync / Networking**: Constant lookup; unaffected by network.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: class_max_accel
        -- Use: Prints class acceleration for class 6
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('class_max_accel', function()
        print(GetVehicleClassMaxAcceleration(6))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: class_max_accel */
    RegisterCommand('class_max_accel', () => {
      console.log(GetVehicleClassMaxAcceleration(6));
    });
    ```
- **Caveats / Limitations**:
  - Stats are base-game constants.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleClassMaxAcceleration

##### GetVehicleClassMaxAgility
- **Name**: GetVehicleClassMaxAgility
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_CLASS_MAX_AGILITY(int vehicleClass)`
- **Purpose**: Provides handling agility metric for a vehicle class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: `float` agility value.
- **OneSync / Networking**: Static lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: class_max_agility
        -- Use: Prints agility value for class 6
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('class_max_agility', function()
        print(GetVehicleClassMaxAgility(6))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: class_max_agility */
    RegisterCommand('class_max_agility', () => {
      console.log(GetVehicleClassMaxAgility(6));
    });
    ```
- **Caveats / Limitations**:
  - Units are arbitrary handling stats.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleClassMaxAgility

##### GetVehicleClassMaxBraking
- **Name**: GetVehicleClassMaxBraking
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_CLASS_MAX_BRAKING(int vehicleClass)`
- **Purpose**: Returns braking capability statistic for a class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: `float` braking stat.
- **OneSync / Networking**: Static lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: class_max_brake
        -- Use: Prints braking stat for class 6
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('class_max_brake', function()
        print(GetVehicleClassMaxBraking(6))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: class_max_brake */
    RegisterCommand('class_max_brake', () => {
      console.log(GetVehicleClassMaxBraking(6));
    });
    ```
- **Caveats / Limitations**:
  - Values may not match modified vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleClassMaxBraking

##### GetVehicleClassMaxTraction
- **Name**: GetVehicleClassMaxTraction
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_CLASS_MAX_TRACTION(int vehicleClass)`
- **Purpose**: Provides traction stat for a vehicle class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: `float` traction value.
- **OneSync / Networking**: Lookup only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: class_max_traction
        -- Use: Prints traction stat for class 6
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('class_max_traction', function()
        print(GetVehicleClassMaxTraction(6))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: class_max_traction */
    RegisterCommand('class_max_traction', () => {
      console.log(GetVehicleClassMaxTraction(6));
    });
    ```
- **Caveats / Limitations**:
  - Traction metric is not actual grip.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleClassMaxTraction

##### GetVehicleColor
- **Name**: GetVehicleColor
- **Scope**: Shared
- **Signature(s)**: `void GET_VEHICLE_COLOR(Vehicle vehicle, int* r, int* g, int* b)`
- **Purpose**: Reads the custom primary colour RGB values.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `r` (`int*`), `g` (`int*`), `b` (`int*`): Output colour values.
- **OneSync / Networking**: Use on owner to capture latest custom paint.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_color
        -- Use: Prints custom primary colour RGB
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_color', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local r_ptr,g_ptr,b_ptr=Citizen.PointerValueInt(),Citizen.PointerValueInt(),Citizen.PointerValueInt()
        GetVehicleColor(veh, r_ptr, g_ptr, b_ptr)
        print(Citizen.PointerGetValue(r_ptr), Citizen.PointerGetValue(g_ptr), Citizen.PointerGetValue(b_ptr))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_color */
    RegisterCommand('veh_color', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const r = Citizen.pointerValueInt();
      const g = Citizen.pointerValueInt();
      const b = Citizen.pointerValueInt();
      GetVehicleColor(veh, r, g, b);
      console.log(Citizen.pointerGetValue(r), Citizen.pointerGetValue(g), Citizen.pointerGetValue(b));
    });
    ```
- **Caveats / Limitations**:
  - Returns custom colour; factory colours use `GetVehicleColours`.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleColor

##### GetVehicleColourCombination
- **Name**: GetVehicleColourCombination
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_COLOUR_COMBINATION(Vehicle vehicle)`
- **Purpose**: Retrieves current colour combination index for vehicles supporting presets.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` combination index.
- **OneSync / Networking**: Call on owner to sync modded colours.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: colour_combo
        -- Use: Prints colour combination index
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('colour_combo', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleColourCombination(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: colour_combo */
    RegisterCommand('colour_combo', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleColourCombination(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only certain vehicles support colour presets.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleColourCombination

##### GetVehicleColours
- **Name**: GetVehicleColours
- **Scope**: Shared
- **Signature(s)**: `void GET_VEHICLE_COLOURS(Vehicle vehicle, int* colorPrimary, int* colorSecondary)`
- **Purpose**: Retrieves stock primary and secondary colour indices.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `colorPrimary` (`int*`), `colorSecondary` (`int*`): Output indices.
- **OneSync / Networking**: Query owner to account for mod changes.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_colours
        -- Use: Prints factory colour indices
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_colours', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local p_ptr,s_ptr=Citizen.PointerValueInt(),Citizen.PointerValueInt()
        GetVehicleColours(veh, p_ptr, s_ptr)
        print(Citizen.PointerGetValue(p_ptr), Citizen.PointerGetValue(s_ptr))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_colours */
    RegisterCommand('veh_colours', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const p = Citizen.pointerValueInt();
      const s = Citizen.pointerValueInt();
      GetVehicleColours(veh, p, s);
      console.log(Citizen.pointerGetValue(p), Citizen.pointerGetValue(s));
    });
    ```
- **Caveats / Limitations**:
  - Values are paint indices; map to RGB via colour tables.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleColours

##### GetVehicleColoursWhichCanBeSet
- **Name**: GetVehicleColoursWhichCanBeSet
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_COLOURS_WHICH_CAN_BE_SET(Vehicle vehicle)`
- **Purpose**: Returns bitfield indicating which colour slots the shader exposes.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` bitmask of supported colour channels.
- **OneSync / Networking**: Pure lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: settable_colours
        -- Use: Prints colour capability bitmask
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('settable_colours', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleColoursWhichCanBeSet(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: settable_colours */
    RegisterCommand('settable_colours', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleColoursWhichCanBeSet(veh));
    });
    ```
- **Caveats / Limitations**:
  - Bit meanings: 1 primary, 2 secondary, 4 pearl, etc.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleColoursWhichCanBeSet

##### _GET_VEHICLE_COUNTERMEASURE_COUNT
- **Name**: _GET_VEHICLE_COUNTERMEASURE_COUNT
- **Scope**: Shared
- **Signature(s)**: `int _GET_VEHICLE_COUNTERMEASURE_COUNT(Vehicle aircraft)`
- **Purpose**: Returns remaining countermeasures on an aircraft.
- **Parameters / Returns**:
  - `aircraft` (`Vehicle`): Plane handle.
  - **Returns**: `int` count of countermeasures.
- **OneSync / Networking**: Query owner to keep counts synchronized.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: counter_count
        -- Use: Prints remaining countermeasures
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('counter_count', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleCountermeasureCount(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: counter_count */
    RegisterCommand('counter_count', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleCountermeasureCount(veh));
    });
    ```
- **Caveats / Limitations**:
  - Requires aircraft equipped with countermeasures.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleCountermeasureCount

##### _GET_VEHICLE_CURRENT_SLIPSTREAM_DRAFT
- **Name**: _GET_VEHICLE_CURRENT_SLIPSTREAM_DRAFT
- **Scope**: Shared
- **Signature(s)**: `float _GET_VEHICLE_CURRENT_SLIPSTREAM_DRAFT(Vehicle vehicle)`
- **Purpose**: Returns slipstream boost factor (0.0–3.0).
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` draft multiplier.
- **OneSync / Networking**: Local-only; servers should not trust without validation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: slipstream
        -- Use: Prints slipstream draft value
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('slipstream', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleCurrentSlipstreamDraft(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: slipstream */
    RegisterCommand('slipstream', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleCurrentSlipstreamDraft(veh));
    });
    ```
- **Caveats / Limitations**:
  - Value interpretation is unclear.
  - TODO(next-run): validate range and units.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleCurrentSlipstreamDraft

##### GetVehicleCustomPrimaryColour
- **Name**: GetVehicleCustomPrimaryColour
- **Scope**: Shared
- **Signature(s)**: `void GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(Vehicle vehicle, int* r, int* g, int* b)`
- **Purpose**: Retrieves custom primary paint RGB values.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `r` (`int*`), `g` (`int*`), `b` (`int*`): Output colours.
- **OneSync / Networking**: Owner query recommended.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cust_primary
        -- Use: Prints custom primary RGB
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('cust_primary', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local r,g,b=Citizen.PointerValueInt(),Citizen.PointerValueInt(),Citizen.PointerValueInt()
        GetVehicleCustomPrimaryColour(veh, r, g, b)
        print(Citizen.PointerGetValue(r), Citizen.PointerGetValue(g), Citizen.PointerGetValue(b))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cust_primary */
    RegisterCommand('cust_primary', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const r = Citizen.pointerValueInt();
      const g = Citizen.pointerValueInt();
      const b = Citizen.pointerValueInt();
      GetVehicleCustomPrimaryColour(veh, r, g, b);
      console.log(Citizen.pointerGetValue(r), Citizen.pointerGetValue(g), Citizen.pointerGetValue(b));
    });
    ```
- **Caveats / Limitations**:
  - Defaults to zero if no custom colour is set.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleCustomPrimaryColour

##### GetVehicleCustomSecondaryColour
- **Name**: GetVehicleCustomSecondaryColour
- **Scope**: Shared
- **Signature(s)**: `void GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(Vehicle vehicle, int* r, int* g, int* b)`
- **Purpose**: Retrieves custom secondary paint RGB values.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `r` (`int*`), `g` (`int*`), `b` (`int*`): Output colours.
- **OneSync / Networking**: Owner query recommended.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cust_secondary
        -- Use: Prints custom secondary RGB
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('cust_secondary', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local r,g,b=Citizen.PointerValueInt(),Citizen.PointerValueInt(),Citizen.PointerValueInt()
        GetVehicleCustomSecondaryColour(veh, r, g, b)
        print(Citizen.PointerGetValue(r), Citizen.PointerGetValue(g), Citizen.PointerGetValue(b))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cust_secondary */
    RegisterCommand('cust_secondary', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const r = Citizen.pointerValueInt();
      const g = Citizen.pointerValueInt();
      const b = Citizen.pointerValueInt();
      GetVehicleCustomSecondaryColour(veh, r, g, b);
      console.log(Citizen.pointerGetValue(r), Citizen.pointerGetValue(g), Citizen.pointerGetValue(b));
    });
    ```
- **Caveats / Limitations**:
  - Defaults to zero if unset.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleCustomSecondaryColour

##### _GET_VEHICLE_DASHBOARD_COLOR
- **Name**: _GET_VEHICLE_DASHBOARD_COLOR
- **Scope**: Shared
- **Signature(s)**: `void _GET_VEHICLE_DASHBOARD_COLOR(Vehicle vehicle, int* color)`
- **Purpose**: Obtains dashboard colour index used for vehicle interior lighting.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `color` (`int*`): Output colour index.
- **OneSync / Networking**: Owner query needed for modded interiors.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: dash_color
        -- Use: Prints dashboard colour index
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('dash_color', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local c=Citizen.PointerValueInt()
        GetVehicleDashboardColor(veh, c)
        print(Citizen.PointerGetValue(c))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: dash_color */
    RegisterCommand('dash_color', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const c = Citizen.pointerValueInt();
      GetVehicleDashboardColor(veh, c);
      console.log(Citizen.pointerGetValue(c));
    });
    ```
- **Caveats / Limitations**:
  - Requires vehicles supporting dashboard colour customization.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleDashboardColor

##### GetVehicleDeformationAtPos
- **Name**: GetVehicleDeformationAtPos
- **Scope**: Shared
- **Signature(s)**: `Vector3 GET_VEHICLE_DEFORMATION_AT_POS(Vehicle vehicle, float offsetX, float offsetY, float offsetZ)`
- **Purpose**: Returns deformation offset at a specific point on the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `offsetX`, `offsetY`, `offsetZ` (`float`): Local space offsets.
  - **Returns**: `vector3` deformation magnitude.
- **OneSync / Networking**: Call on owner to receive up-to-date damage info.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: deform_pos
        -- Use: Prints deformation vector at bonnet
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('deform_pos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local v = GetVehicleDeformationAtPos(veh, 0.0, 2.0, 0.5)
        print(v.x, v.y, v.z)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: deform_pos */
    RegisterCommand('deform_pos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const v = GetVehicleDeformationAtPos(veh, 0.0, 2.0, 0.5);
      console.log(v[0], v[1], v[2]);
    });
    ```
- **Caveats / Limitations**:
  - Coordinates are in vehicle local space.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleDeformationAtPos

##### GetVehicleDirtLevel
- **Name**: GetVehicleDirtLevel
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_DIRT_LEVEL(Vehicle vehicle)`
- **Purpose**: Returns dirt accumulation level (0.0–15.0).
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` dirt value.
- **OneSync / Networking**: Check on owner; cleaning should be broadcast via native setters.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: dirt_level
        -- Use: Prints current dirt level
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('dirt_level', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleDirtLevel(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: dirt_level */
    RegisterCommand('dirt_level', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleDirtLevel(veh));
    });
    ```
- **Caveats / Limitations**:
  - Getter for `SetVehicleDirtLevel`.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleDirtLevel

##### GetVehicleDoorAngleRatio
- **Name**: GetVehicleDoorAngleRatio
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_DOOR_ANGLE_RATIO(Vehicle vehicle, int doorIndex)`
- **Purpose**: Returns the open ratio for a door from 0.0 (closed) to 1.0 (open).
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `doorIndex` (`int`): Door index.
  - **Returns**: `float` open ratio.
- **OneSync / Networking**: Call on owner; door state syncs when using door natives.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: door_angle
        -- Use: Prints driver door open ratio
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('door_angle', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleDoorAngleRatio(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: door_angle */
    RegisterCommand('door_angle', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleDoorAngleRatio(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Requires correct door index; see `eDoorId`.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleDoorAngleRatio

##### GetVehicleDoorLockStatus
- **Name**: GetVehicleDoorLockStatus
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_DOOR_LOCK_STATUS(Vehicle vehicle)`
- **Purpose**: Returns door lock state enum for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` lock status.
- **OneSync / Networking**: Query owner; lock changes propagate with corresponding setter.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lock_status
        -- Use: Prints door lock status enum
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lock_status', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleDoorLockStatus(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lock_status */
    RegisterCommand('lock_status', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleDoorLockStatus(veh));
    });
    ```
- **Caveats / Limitations**:
  - Refer to `SetVehicleDoorsLocked` for enum meanings.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleDoorLockStatus
##### GetVehicleDoorsLockedForPlayer
- **Name**: GetVehicleDoorsLockedForPlayer
- **Scope**: Shared
- **Signature(s)**: `BOOL GET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(Vehicle vehicle, Player player)`
- **Purpose**: Checks if a vehicle's doors are locked for a specific player.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `player` (`Player`): Target player.
  - **Returns**: `bool` locked state.
- **OneSync / Networking**: Query on vehicle owner for authoritative lock state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: doors_locked
        -- Use: Prints if current vehicle is locked for self
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('doors_locked', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleDoorsLockedForPlayer(veh, PlayerId()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: doors_locked */
    RegisterCommand('doors_locked', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleDoorsLockedForPlayer(veh, PlayerId()));
    });
    ```
- **Caveats / Limitations**:
  - Returns false if vehicle or player is invalid.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleDoorsLockedForPlayer

##### _GET_VEHICLE_DRIVETRAIN_TYPE
- **Name**: _GET_VEHICLE_DRIVETRAIN_TYPE
- **Scope**: Shared
- **Signature(s)**: `int _GET_VEHICLE_DRIVETRAIN_TYPE(Hash vehicleModel)`
- **Purpose**: Retrieves drivetrain type of a vehicle model.
- **Parameters / Returns**:
  - `vehicleModel` (`Hash`): Vehicle model hash.
  - **Returns**: `int` enum (0=INVALID,1=FWD,2=RWD,3=AWD).
- **OneSync / Networking**: Model hash must be streamed to the client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: drivetrain
        -- Use: Prints drivetrain type of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('drivetrain', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local model = GetEntityModel(veh)
        print(_GET_VEHICLE_DRIVETRAIN_TYPE(model))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: drivetrain */
    RegisterCommand('drivetrain', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const model = GetEntityModel(veh);
      console.log(_GET_VEHICLE_DRIVETRAIN_TYPE(model));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if model not loaded.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_VEHICLE_DRIVETRAIN_TYPE

##### GetVehicleEngineHealth
- **Name**: GetVehicleEngineHealth
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_ENGINE_HEALTH(Vehicle vehicle)`
- **Purpose**: Retrieves current engine health (-4000 to 1000).
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` engine health.
- **OneSync / Networking**: Call on the entity owner for accurate health.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: engine_health
        -- Use: Prints engine health of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('engine_health', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleEngineHealth(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: engine_health */
    RegisterCommand('engine_health', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleEngineHealth(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns 1000 when vehicle handle is invalid.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleEngineHealth

##### GetVehicleEnveffScale
- **Name**: GetVehicleEnveffScale
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_ENVEFF_SCALE(Vehicle vehicle)`
- **Purpose**: Gets paint fade value (0 fresh – 1 fully faded).
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` fade factor.
- **OneSync / Networking**: Query owner so paint state is up to date.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: paint_fade
        -- Use: Prints paint fade percentage
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('paint_fade', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleEnveffScale(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: paint_fade */
    RegisterCommand('paint_fade', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleEnveffScale(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns 0.0 if vehicle does not exist.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleEnveffScale

##### GetVehicleEstimatedMaxSpeed
- **Name**: GetVehicleEstimatedMaxSpeed
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_ESTIMATED_MAX_SPEED(Vehicle vehicle)`
- **Purpose**: Provides a static max speed estimate accounting for mods.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` max speed estimate.
- **OneSync / Networking**: Use on vehicle owner for modded stats.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: max_speed
        -- Use: Prints estimated max speed
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('max_speed', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleEstimatedMaxSpeed(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: max_speed */
    RegisterCommand('max_speed', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleEstimatedMaxSpeed(veh));
    });
    ```
- **Caveats / Limitations**:
  - Value is static; not affected by runtime damage.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleEstimatedMaxSpeed

##### GetVehicleExtraColours
- **Name**: GetVehicleExtraColours
- **Scope**: Shared
- **Signature(s)**: `void GET_VEHICLE_EXTRA_COLOURS(Vehicle vehicle, int* pearlescentColor, int* wheelColor)`
- **Purpose**: Retrieves pearlescent and wheel colour indices.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int pearlescentColor`, `int wheelColor`.
- **OneSync / Networking**: Only the owner has authoritative colour state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: extra_colours
        -- Use: Prints pearlescent and wheel colours
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('extra_colours', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local pearlescent, wheel = GetVehicleExtraColours(veh)
        print(pearlescent, wheel)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: extra_colours */
    RegisterCommand('extra_colours', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const [pearlescent, wheel] = GetVehicleExtraColours(veh);
      console.log(pearlescent, wheel);
    });
    ```
- **Caveats / Limitations**:
  - Colour indices map to game colour table.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleExtraColours

##### GetVehicleFlightNozzlePosition
- **Name**: GetVehicleFlightNozzlePosition
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_FLIGHT_NOZZLE_POSITION(Vehicle aircraft)`
- **Purpose**: Returns VTOL nozzle position (0 normal, 1 hover).
- **Parameters / Returns**:
  - `aircraft` (`Vehicle`): VTOL aircraft handle.
  - **Returns**: `float` hover percentage.
- **OneSync / Networking**: Call on owner; nozzle state replicates automatically.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nozzle_pos
        -- Use: Prints VTOL nozzle position
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('nozzle_pos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleFlightNozzlePosition(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nozzle_pos */
    RegisterCommand('nozzle_pos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleFlightNozzlePosition(veh));
    });
    ```
- **Caveats / Limitations**:
  - Applicable only to VTOL-capable aircraft.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleFlightNozzlePosition

##### GetVehicleHasKers
- **Name**: GetVehicleHasKers
- **Scope**: Shared
- **Signature(s)**: `BOOL GET_VEHICLE_HAS_KERS(Vehicle vehicle)`
- **Purpose**: Checks if a vehicle has KERS boost capability.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` KERS availability.
- **OneSync / Networking**: Query owner to ensure mod data is present.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_kers
        -- Use: Prints if vehicle has KERS
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_kers', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleHasKers(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_kers */
    RegisterCommand('has_kers', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleHasKers(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only certain bikes support KERS.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleHasKers

##### _GET_VEHICLE_HAS_PARACHUTE
- **Name**: _GET_VEHICLE_HAS_PARACHUTE
- **Scope**: Shared
- **Signature(s)**: `BOOL _GET_VEHICLE_HAS_PARACHUTE(Vehicle vehicle)`
- **Purpose**: Determines if a vehicle is equipped with a deployable parachute.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` parachute availability.
- **OneSync / Networking**: Mod info must exist on owning client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_chute
        -- Use: Prints if vehicle has a parachute
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_chute', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(_GET_VEHICLE_HAS_PARACHUTE(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_chute */
    RegisterCommand('has_chute', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(_GET_VEHICLE_HAS_PARACHUTE(veh));
    });
    ```
- **Caveats / Limitations**:
  - Applies to certain planes/vehicles only.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_VEHICLE_HAS_PARACHUTE

##### GetVehicleHealthPercentage
- **Name**: GetVehicleHealthPercentage
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_HEALTH_PERCENTAGE(Vehicle vehicle)`
- **Purpose**: Returns overall health percentage combining vehicle components.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` health ratio.
- **OneSync / Networking**: Query on owner; value depends on multiple subsystems.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: health_pct
        -- Use: Prints overall vehicle health percentage
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('health_pct', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleHealthPercentage(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: health_pct */
    RegisterCommand('health_pct', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleHealthPercentage(veh));
    });
    ```
- **Caveats / Limitations**:
  - Detailed component maxima not exposed; value may vary across vehicle classes.
  - TODO(next-run): verify added parameters for advanced health calculation.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleHealthPercentage

##### GetVehicleHomingLockonState
- **Name**: GetVehicleHomingLockonState
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_HOMING_LOCKON_STATE(Vehicle vehicle)`
- **Purpose**: Returns missile lock-on state for vehicle weapons.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` (0 none, 1 locking, 2 locked).
- **OneSync / Networking**: Requires querying weapon owner to avoid desync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lockon_state
        -- Use: Prints homing lock-on state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lockon_state', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleHomingLockonState(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lockon_state */
    RegisterCommand('lockon_state', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleHomingLockonState(veh));
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for homing-capable weapons.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleHomingLockonState

##### GetVehicleIndividualDoorLockStatus
- **Name**: GetVehicleIndividualDoorLockStatus
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_INDIVIDUAL_DOOR_LOCK_STATUS(Vehicle vehicle, int doorIndex)`
- **Purpose**: Retrieves lock state of a specific door.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `doorIndex` (`int`): Door ID (see `eDoorId`).
  - **Returns**: `int` door lock state.
- **OneSync / Networking**: Only owner holds authoritative door states.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: door_lock
        -- Use: Prints driver door lock state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('door_lock', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleIndividualDoorLockStatus(veh, 0))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: door_lock */
    RegisterCommand('door_lock', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleIndividualDoorLockStatus(veh, 0));
    });
    ```
- **Caveats / Limitations**:
  - Door indices vary by vehicle type.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleIndividualDoorLockStatus

##### _GET_VEHICLE_INTERIOR_COLOR
- **Name**: _GET_VEHICLE_INTERIOR_COLOR
- **Scope**: Shared
- **Signature(s)**: `void _GET_VEHICLE_INTERIOR_COLOR(Vehicle vehicle, int* color)`
- **Purpose**: Gets current interior color index.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int color` index.
- **OneSync / Networking**: Fetch on vehicle owner for proper mod state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: interior_color
        -- Use: Prints vehicle interior color index
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('interior_color', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local color = _GET_VEHICLE_INTERIOR_COLOR(veh)
        print(color)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: interior_color */
    RegisterCommand('interior_color', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const color = _GET_VEHICLE_INTERIOR_COLOR(veh);
      console.log(color);
    });
    ```
- **Caveats / Limitations**:
  - Color indices correspond to interior palette.
- **Reference**: https://docs.fivem.net/natives/?n=_GET_VEHICLE_INTERIOR_COLOR

##### GetVehicleIsMercenary
- **Name**: GetVehicleIsMercenary
- **Scope**: Shared
- **Signature(s)**: `BOOL GET_VEHICLE_IS_MERCENARY(Vehicle vehicle)`
- **Purpose**: Indicates if vehicle belongs to mercenary NPCs.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` mercenary status.
- **OneSync / Networking**: State set by script; owner lookup recommended.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: is_merc
        -- Use: Prints if vehicle is mercenary
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('is_merc', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleIsMercenary(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: is_merc */
    RegisterCommand('is_merc', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleIsMercenary(veh));
    });
    ```
- **Caveats / Limitations**:
  - Rarely used outside specific missions.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleIsMercenary

##### GetVehicleLayoutHash
- **Name**: GetVehicleLayoutHash
- **Scope**: Shared
- **Signature(s)**: `Hash GET_VEHICLE_LAYOUT_HASH(Vehicle vehicle)`
- **Purpose**: Returns layout hash defining seat arrangement.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `Hash` layout identifier.
- **OneSync / Networking**: Layout is constant per model; no sync issues.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: layout_hash
        -- Use: Prints layout hash
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('layout_hash', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleLayoutHash(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: layout_hash */
    RegisterCommand('layout_hash', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleLayoutHash(veh));
    });
    ```
- **Caveats / Limitations**:
  - Hash values require lookup to interpret.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleLayoutHash

##### GetVehicleLightsState
- **Name**: GetVehicleLightsState
- **Scope**: Shared
- **Signature(s)**: `BOOL GET_VEHICLE_LIGHTS_STATE(Vehicle vehicle, BOOL* lightsOn, BOOL* highbeamsOn)`
- **Purpose**: Obtains headlight and high-beam states.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool success`, plus `bool lightsOn`, `bool highbeamsOn`.
- **OneSync / Networking**: Owner must be queried for real-time light status.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lights_state
        -- Use: Prints headlight and high-beam states
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lights_state', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local success, lights, high = GetVehicleLightsState(veh)
        if success then
            print(lights, high)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lights_state */
    RegisterCommand('lights_state', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, lights, high] = GetVehicleLightsState(veh);
      if (success) console.log(lights, high);
    });
    ```
- **Caveats / Limitations**:
  - High-beam detection only valid for vehicles with headlights.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleLightsState

##### GetVehicleLivery
- **Name**: GetVehicleLivery
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_LIVERY(Vehicle vehicle)`
- **Purpose**: Returns current livery index or -1 if none.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` livery index.
- **OneSync / Networking**: Livery changes replicate via owner only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: livery
        -- Use: Prints current livery index
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('livery', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleLivery(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: livery */
    RegisterCommand('livery', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleLivery(veh));
    });
    ```
- **Caveats / Limitations**:
  - Returns -1 if vehicle does not support liveries.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleLivery

##### GetVehicleLiveryCount
- **Name**: GetVehicleLiveryCount
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_LIVERY_COUNT(Vehicle vehicle)`
- **Purpose**: Provides number of available liveries for a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` count or -1 if unsupported.
- **OneSync / Networking**: Query owner to account for mod kits.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: livery_count
        -- Use: Prints total livery options
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('livery_count', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleLiveryCount(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: livery_count */
    RegisterCommand('livery_count', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleLiveryCount(veh));
    });
    ```
- **Caveats / Limitations**:
  - -1 indicates no livery support.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleLiveryCount

##### GetVehicleLockOnTarget
- **Name**: GetVehicleLockOnTarget
- **Scope**: Shared
- **Signature(s)**: `BOOL GET_VEHICLE_LOCK_ON_TARGET(Vehicle vehicle, Entity* entity)`
- **Purpose**: Retrieves entity currently locked onto by vehicle weapons.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `bool` success, `Entity` lock target.
- **OneSync / Networking**: Call on weapon owner for accurate targeting.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lock_target
        -- Use: Prints entity ID vehicle is locked onto
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lock_target', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local success, target = GetVehicleLockOnTarget(veh)
        if success then
            print(target)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lock_target */
    RegisterCommand('lock_target', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, target] = GetVehicleLockOnTarget(veh);
      if (success) console.log(target);
    });
    ```
- **Caveats / Limitations**:
  - Target handle may be 0 when not locked.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleLockOnTarget

##### GetVehicleMaxBraking
- **Name**: GetVehicleMaxBraking
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_MAX_BRAKING(Vehicle vehicle)`
- **Purpose**: Returns the maximum braking force value of a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` braking stat.
- **OneSync / Networking**: Use on owner to respect performance mods.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: max_brake
        -- Use: Prints max braking stat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('max_brake', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleMaxBraking(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: max_brake */
    RegisterCommand('max_brake', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleMaxBraking(veh));
    });
    ```
- **Caveats / Limitations**:
  - Static stat; dynamic braking due to damage not reflected.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleMaxBraking

##### GetVehicleMaxNumberOfPassengers
- **Name**: GetVehicleMaxNumberOfPassengers
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(Vehicle vehicle)`
- **Purpose**: Returns maximum passenger seats excluding driver.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int` seat count.
- **OneSync / Networking**: Seat count is model constant; no sync issues.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: max_peds
        -- Use: Prints max passenger count
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('max_peds', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleMaxNumberOfPassengers(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: max_peds */
    RegisterCommand('max_peds', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleMaxNumberOfPassengers(veh));
    });
    ```
- **Caveats / Limitations**:
  - Includes seats that may be blocked by layout.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleMaxNumberOfPassengers

##### GetVehicleMaxTraction
- **Name**: GetVehicleMaxTraction
- **Scope**: Shared
- **Signature(s)**: `float GET_VEHICLE_MAX_TRACTION(Vehicle vehicle)`
- **Purpose**: Returns maximum traction stat of the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `float` traction stat.
- **OneSync / Networking**: Must query owner for mod-influenced values.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: max_traction
        -- Use: Prints max traction stat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('max_traction', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleMaxTraction(veh))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: max_traction */
    RegisterCommand('max_traction', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleMaxTraction(veh));
    });
    ```
- **Caveats / Limitations**:
  - Stat may not reflect current tyre condition.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleMaxTraction

##### GetVehicleMod
- **Name**: GetVehicleMod
- **Scope**: Shared
- **Signature(s)**: `int GET_VEHICLE_MOD(Vehicle vehicle, int modType)`
- **Purpose**: Retrieves applied mod index for a specific mod slot.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `modType` (`int`): Slot from `eVehicleModType`.
  - **Returns**: `int` mod index or -1 if stock.
- **OneSync / Networking**: Check on owner for reliable mod data.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mod_index
        -- Use: Prints installed engine mod index
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mod_index', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleMod(veh, 11))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mod_index */
    RegisterCommand('mod_index', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleMod(veh, 11));
    });
    ```
- **Caveats / Limitations**:
  - `modType` 11 corresponds to engine upgrades.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleMod

##### GetVehicleModColor_1
- **Name**: GetVehicleModColor_1
- **Scope**: Shared
- **Signature(s)**: `void GET_VEHICLE_MOD_COLOR_1(Vehicle vehicle, int* paintType, int* color, int* pearlescentColor)`
- **Purpose**: Retrieves primary mod colour info.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: `int paintType`, `int color`, `int pearlescentColor`.
- **OneSync / Networking**: Owner query ensures accurate visual state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mod_color1
        -- Use: Prints primary mod colour indices
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mod_color1', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local paint, color, pearl = GetVehicleModColor_1(veh)
        print(paint, color, pearl)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mod_color1 */
    RegisterCommand('mod_color1', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const [paint, color, pearl] = GetVehicleModColor_1(veh);
      console.log(paint, color, pearl);
    });
    ```
- **Caveats / Limitations**:
  - Colour indices follow vehicle mod colour tables.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleModColor_1

##### GetVehicleModColor_1Name
- **Name**: GetVehicleModColor_1Name
- **Scope**: Shared
- **Signature(s)**: `char* GET_VEHICLE_MOD_COLOR_1_NAME(Vehicle vehicle, BOOL p1)`
- **Purpose**: Returns code name of current primary colour.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `p1` (`bool`): Unused, pass false.
  - **Returns**: `string` colour code name.
- **OneSync / Networking**: Query owner for current mod colour.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: color1_name
        -- Use: Prints primary colour code name
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('color1_name', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        print(GetVehicleModColor_1Name(veh, false))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: color1_name */
    RegisterCommand('color1_name', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      console.log(GetVehicleModColor_1Name(veh, false));
    });
    ```
- **Caveats / Limitations**:
  - Returns internal code names, not localized strings.
- **Reference**: https://docs.fivem.net/natives/?n=GetVehicleModColor_1Name

CONTINUE-HERE — 2025-09-12T04:23 — next: Vehicle :: GetVehicleModColor_2
