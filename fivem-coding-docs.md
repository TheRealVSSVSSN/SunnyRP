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
| Player | 248 | 231 | 17 | 2025-09-11T06:06 |

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

##### _ClearPlayerReserveParachuteModelOverride (0x290D248E25815AE8)
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
        _ClearPlayerReserveParachuteModelOverride(PlayerId())
    end)
    ```
  - JavaScript:

    ```javascript
    /* Command: clear_para_reserve */
    RegisterCommand('clear_para_reserve', () => {
      _ClearPlayerReserveParachuteModelOverride(PlayerId());
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

##### _GetAchievementProgress (0x1C186837D0619335)
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

##### _SetPlayerWeaponDefenseModifier_2 (hash unknown)
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
        -- Use: Calls _SetPlayerWeaponDefenseModifier_2
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

##### _SetSpecialAbility (hash unknown)
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
        -- Use: Calls _SetSpecialAbility
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

##### _SetWantedLevelHiddenEvasionTime (hash unknown)
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
        -- Use: Calls _SetWantedLevelHiddenEvasionTime
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

##### _SpecialAbilityActivate (hash unknown)
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
        -- Use: Calls _SpecialAbilityActivate
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

##### _SpecialAbilityDeplete (0x17F7471EACA78290)
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

##### _UpdatePlayerTeleport (0xE23D5873C2394C61 / _HAS_PLAYER_TELEPORT_FINISHED)
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

### Server Natives by Category



CONTINUE-HERE — 2025-09-11T06:06 — next: 13.2 Client Natives > Player category :: GetEntityPlayerIsFreeAimingAt
