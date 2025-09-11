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
| Player | 248 | 65 | 183 | 2025-09-11 |

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

##### _GetWantedLevelParoleDuration (0xA72200F51875FEA4)
- **Scope**: Client
- **Signature**: `int _GetWantedLevelParoleDuration()`
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
        print(('_GET_WANTED_LEVEL_PAROLE_DURATION: %d'):format(_GetWantedLevelParoleDuration()))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: parole */
    RegisterCommand('parole', () => {
      console.log(`_GET_WANTED_LEVEL_PAROLE_DURATION: ${_GetWantedLevelParoleDuration()}`);
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

##### _HasPlayerBeenShotByCop (0xBC0753C9CA14B506 0x9DF75B2A)
- **Scope**: Client
- **Signature**: `BOOL _HasPlayerBeenShotByCop(Player player, int ms, BOOL p2)`
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
        print(('_HAS_PLAYER_BEEN_SHOT_BY_COP: %s'):format(tostring(_HasPlayerBeenShotByCop(PlayerId(), 5000, false))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: copshot */
    RegisterCommand('copshot', () => {
      console.log(`_HAS_PLAYER_BEEN_SHOT_BY_COP: ${_HasPlayerBeenShotByCop(PlayerId(), 5000, false)}`);
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

##### _IsPlayerDrivingDangerously (0xF10B44FD479D69F3 0x1E359CC8)
- **Scope**: Client
- **Signature**: `BOOL _IsPlayerDrivingDangerously(Player player, int type)`
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
        print(('Dangerous: %s'):format(tostring(_IsPlayerDrivingDangerously(PlayerId(), 0))))
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: drivedanger */
    RegisterCommand('drivedanger', () => {
      console.log(`Dangerous: ${_IsPlayerDrivingDangerously(PlayerId(), 0)}`);
    });
    ```
- **Caveats / Limitations**:
  - `type` parameter lacks official description.
- **Reference**: https://docs.fivem.net/natives/?n=_IsPlayerDrivingDangerously

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
### Server Natives by Category


CONTINUE-HERE — 2025-09-11T03:25:53+00:00 — next: 13.2 Client Natives > Player category :: IsPlayerTeleportActive
