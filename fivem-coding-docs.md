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
