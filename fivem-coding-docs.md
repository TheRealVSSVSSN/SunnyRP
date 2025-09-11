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
| Player | 248 | 25 | 223 | 2025-09-11 |

### Taxonomy & Scope Notes
- **Client-only** natives run in game clients and cannot be executed on the server.
- **Server-only** natives run in FXServer and manage resources or network state.
- **Shared** natives work in both realms.
- OneSync dictates entity ownership; some natives require the entity owner to call them for replication.

#### References
- https://docs.fivem.net/natives/

### Client Natives by Category

#### Player

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

### Server Natives by Category

CONTINUE-HERE — 2025-09-11T03:06:47+00:00 — next: 13.2 Client Natives > Player category :: GetPlayerWeaponDamageModifier
