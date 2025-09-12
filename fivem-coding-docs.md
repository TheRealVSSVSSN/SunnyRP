# FiveM Coding Documentation

## 1. Overview
FiveM provides a framework for extending Grand Theft Auto V with multiplayer scripts. Resources run on FXServer and can execute on clients and the server simultaneously. This document summarizes official guidance for building secure and efficient code.

**References**
- https://docs.fivem.net/docs/

## 2. Environment Setup (FXServer, server.cfg, txAdmin)
- Download the latest FXServer artifact and extract it on the host.
- Create a `server.cfg` to define ports, resources, and settings.
- Run the server directly or via **txAdmin** for web-based management and monitoring.

```sh
# launch FXServer
./run.sh +exec server.cfg

# launch via txAdmin profile
./fxserver +set serverProfile dev
```

**References**
- https://docs.fivem.net/docs/server-manual/setting-up-a-server/
- https://docs.fivem.net/docs/server-manual/setting-up-a-server-using-txadmin/
- https://docs.fivem.net/docs/server-manual/server-cfg/

## 3. Resource Anatomy & fxmanifest.lua
- A resource is a folder with an `fxmanifest.lua` describing files and runtime options.
- Client scripts run on players; server scripts run on FXServer; shared scripts load on both.
- Assets such as HTML, data files, or streaming content are referenced from the manifest.

```lua
-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_script 'config.lua'
client_scripts { 'client/main.lua' }
server_scripts { 'server/main.lua' }
```

**References**
- https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/

## 4. Runtimes: Lua, JavaScript, C#
- **Lua**: default runtime; enable Lua 5.4 with `lua54 'yes'`.
- **JavaScript**: uses Node.js features; scripts are listed with `.js` paths.
- **C#**: compiled assemblies loaded via `client_script`/`server_script` entries pointing to `.net.dll` files.

```lua
--[[
    -- Type: Server Script
    -- Name: hello.lua
    -- Use: Prints a server message
    -- Created: 2025-09-12
    -- By: VSSVSSN
--]]
print('Hello from Lua runtime')
```

```javascript
/* Server Script: hello.js */
console.log('Hello from JavaScript runtime');
```

```csharp
// Server Script: Hello.cs
using CitizenFX.Core;
public class Hello : BaseScript
{
    public Hello() { Debug.WriteLine("Hello from C# runtime"); }
}
```

**References**
- https://docs.fivem.net/docs/scripting-manual/runtimes/lua/
- https://docs.fivem.net/docs/scripting-manual/runtimes/javascript/
- https://docs.fivem.net/docs/scripting-manual/runtimes/csharp/

## 5. Events: Listening, Triggering, Net Events
- Register local events with `AddEventHandler` and cross-network events with `RegisterNetEvent`.
- Use `TriggerServerEvent` and `TriggerClientEvent` to communicate between client and server.

Flow diagrams:
- **Client → Server**: `Client TriggerServerEvent → Server AddEventHandler`
- **Server → Clients**: `Server TriggerClientEvent → Client AddEventHandler`

```lua
--[[
    -- Type: Client Script
    -- Name: hello_evt.lua
    -- Use: Sends greeting to server
    -- Created: 2025-09-12
    -- By: VSSVSSN
--]]
RegisterCommand('hi', function()
    TriggerServerEvent('hello:server', 'Hi from client')
end)

RegisterNetEvent('hello:client')
AddEventHandler('hello:client', function(msg)
    print(('Server says: %s'):format(msg))
end)
```

```javascript
/* Client Script: hello_evt.js */
RegisterCommand('hi', () => {
  TriggerServerEvent('hello:server', 'Hi from client');
});

onNet('hello:client', (msg) => {
  console.log(`Server says: ${msg}`);
});
```

Server side:

```lua
--[[ Server Script: hello_srv.lua ]]--
RegisterNetEvent('hello:server')
AddEventHandler('hello:server', function(msg)
    print(('Client says: %s'):format(msg))
    TriggerClientEvent('hello:client', source, 'Greetings from server')
end)
```

```javascript
/* Server Script: hello_srv.js */
onNet('hello:server', (msg) => {
  console.log(`Client says: ${msg}`);
  emitNet('hello:client', global.source, 'Greetings from server');
});
```

**References**
- https://docs.fivem.net/docs/scripting-manual/events/

## 6. ConVars & Commands
- ConVars configure runtime behavior; define them in `server.cfg` or at runtime with `SetConvar`.
- Commands are registered with `RegisterCommand` and can be restricted with ACL.

```lua
--[[ Command: ping ]]--
RegisterCommand('ping', function(src)
    TriggerClientEvent('chat:addMessage', src, { args = { 'Pong!' } })
end, false)

-- read a ConVar
local host = GetConvar('mysql_host', 'localhost')
```

```javascript
/* Command: ping */
RegisterCommand('ping', (src) => {
  emitNet('chat:addMessage', src, { args: ['Pong!'] });
}, false);

// read a ConVar
const host = GetConvar('mysql_host', 'localhost');
```

**References**
- https://docs.fivem.net/docs/scripting-manual/commands/
- https://docs.fivem.net/docs/scripting-reference/convars/

## 7. Networking & Sync: OneSync + State Bags
- Enable OneSync in `server.cfg` with `onesync on` for improved entity routing and ownership.
- State bags provide key-value storage on entities that automatically replicate to owners and nearby clients.

```lua
--[[ Vehicle state bag example ]]--
local veh = GetVehiclePedIsIn(PlayerPedId(), false)
if veh ~= 0 then
    Entity(veh).state:set('locked', true, true) -- last true makes it replicated
end
```

```javascript
/* Vehicle state bag example */
const veh = GetVehiclePedIsIn(PlayerPedId(), false);
if (veh !== 0) {
  Entity(veh).state.set('locked', true, true); // replicate to all
}
```

**References**
- https://docs.fivem.net/docs/scripting-reference/onesync/
- https://docs.fivem.net/docs/scripting-reference/state-bags/

## 8. Access Control (ACL), Principals, Permissions
- ACL uses principals (`identifier.steam:`, `resource.`) and ACEs to grant or deny commands and events.
- Modify permissions in `server.cfg` using `add_principal` and `add_ace`.

```cfg
add_principal identifier.steam:110000112345678 group.admin
add_ace group.admin command allow
add_ace resource.myresource command.mycmd allow
```

**References**
- https://docs.fivem.net/docs/scripting-manual/access-control/
- https://docs.fivem.net/docs/server-manual/permissions/

## 9. Debugging & Profiling
- Use console commands like `txaEvent` and `print` for quick debugging.
- The built-in profiler measures CPU usage: `profiler record <ms>` then `profiler view`.

```sh
profiler record 5000
profiler view
```

**References**
- https://docs.fivem.net/docs/scripting-reference/debugging/
- https://docs.fivem.net/docs/scripting-reference/profiling/

## 10. Security & Best Practices Checklist
- Never trust client input; validate on the server.
- Use parameterized queries when interacting with MySQL to avoid injection.
- Check the `source` of events to prevent spoofing.
- Limit expensive loops and rate-limit external calls.

**Limitations / Notes**
- Security recommendations evolve with new platform updates.
- TODO(next-run): verify latest hardening guidelines.

**References**
- https://docs.fivem.net/docs/scripting-manual/security-practices/

## 11. Appendices (Templates)
### Lua Resource Template
```lua
-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script 'client.lua'
server_script 'server.lua'
```

```lua
-- client.lua
print('client ready')
```

```lua
-- server.lua
print('server ready')
```

### JavaScript Resource Template
```lua
-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

client_script 'client.js'
server_script 'server.js'
```

```javascript
// client.js
console.log('client ready');
```

```javascript
// server.js
console.log('server ready');
```

### server.cfg Template
```cfg
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"
ensure my-resource
onesync on
```

**References**
- https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/
- https://docs.fivem.net/docs/server-manual/server-cfg/

## 12. References
- https://docs.fivem.net/docs/
- https://docs.fivem.net/docs/server-manual/setting-up-a-server/
- https://docs.fivem.net/docs/server-manual/setting-up-a-server-using-txadmin/
- https://docs.fivem.net/docs/server-manual/server-cfg/
- https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/
- https://docs.fivem.net/docs/scripting-manual/runtimes/lua/
- https://docs.fivem.net/docs/scripting-manual/runtimes/javascript/
- https://docs.fivem.net/docs/scripting-manual/runtimes/csharp/
- https://docs.fivem.net/docs/scripting-manual/events/
- https://docs.fivem.net/docs/scripting-manual/commands/
- https://docs.fivem.net/docs/scripting-reference/convars/
- https://docs.fivem.net/docs/scripting-reference/onesync/
- https://docs.fivem.net/docs/scripting-reference/state-bags/
- https://docs.fivem.net/docs/scripting-manual/access-control/
- https://docs.fivem.net/docs/server-manual/permissions/
- https://docs.fivem.net/docs/scripting-reference/debugging/
- https://docs.fivem.net/docs/scripting-reference/profiling/
- https://docs.fivem.net/docs/scripting-manual/security-practices/

## 13. Natives Index (Client / Server, by Category)
### 13.0 Processing Ledger
| Category | Total | Done | Remaining | Last Updated |
| Overall | 6442 | 958 | 5484 | 2025-09-12T18:34:33+00:00 |
| Vehicle | 751 | 627 | 124 | 2025-09-12T18:34:33+00:00 |

### 13.1 Taxonomy & Scope Notes
- Natives are grouped by high-level game systems (e.g., Vehicle, Player) and scope (Client or Server).
- Entries are sorted alphabetically within each category.

### 13.2 Client Natives by Category
#### Vehicle
##### SetVehicleDoorsShut
- **Name**: SetVehicleDoorsShut
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_DOORS_SHUT(Vehicle vehicle, BOOL closeInstantly);`
- **Purpose**: Closes all vehicle doors; optionally snaps them shut instantly.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `closeInstantly` (`bool`): `true` closes without animation.
  - **Returns**: `void`
- **OneSync / Networking**: Invoke on vehicle owner so door state replicates to other clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_doorsshut
        -- Use: Close all vehicle doors
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_doorsshut', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleDoorsShut(veh, args[1] == 'instant') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_doorsshut */
    RegisterCommand('veh_doorsshut', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleDoorsShut(veh, args[0] === 'instant');
    });
    ```
- **Caveats / Limitations**:
  - The "instant" mode snaps doors without closing animation.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleDoorsShut

##### SetVehicleDropsMoneyWhenBlownUp
- **Name**: SetVehicleDropsMoneyWhenBlownUp
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_DROPS_MONEY_WHEN_BLOWN_UP(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Toggles spawning of cash pickups when the vehicle explodes.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to modify.
  - `toggle` (`bool`): `true` enables money drop.
  - **Returns**: `void`
- **OneSync / Networking**: Call on the vehicle owner before destruction to replicate pickup creation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_moneydrop
        -- Use: Toggle money drops on explosion
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_moneydrop', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleDropsMoneyWhenBlownUp(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_moneydrop */
    RegisterCommand('veh_moneydrop', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleDropsMoneyWhenBlownUp(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Only works on vehicle models classified as cars.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleDropsMoneyWhenBlownUp

##### SetVehicleEngineCanDegrade
- **Name**: SetVehicleEngineCanDegrade
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_ENGINE_CAN_DEGRADE(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Enables or disables gradual engine health degradation.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): `true` allows degradation.
  - **Returns**: `void`
- **OneSync / Networking**: Call on vehicle owner so degradation state syncs.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_degrade
        -- Use: Toggle engine degradation
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_degrade', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleEngineCanDegrade(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_degrade */
    RegisterCommand('veh_degrade', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleEngineCanDegrade(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Degradation applies only while the vehicle exists locally.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleEngineCanDegrade

##### SetVehicleEngineHealth
- **Name**: SetVehicleEngineHealth
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_ENGINE_HEALTH(Vehicle vehicle, float health);`
- **Purpose**: Sets engine health level for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `health` (`float`): Engine health (-4000.0 to 1000.0).
  - **Returns**: `void`
- **OneSync / Networking**: Call on vehicle owner so health value propagates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_enghealth
        -- Use: Set engine health value
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_enghealth', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleEngineHealth(veh, tonumber(args[1]) or 1000.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_enghealth */
    RegisterCommand('veh_enghealth', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleEngineHealth(veh, parseFloat(args[0]) || 1000.0);
    });
    ```
- **Caveats / Limitations**:
  - Values below 0 cause engine fire; -4000 destroys the engine.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleEngineHealth

##### SetVehicleEngineOn
- **Name**: SetVehicleEngineOn
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_ENGINE_ON(Vehicle vehicle, BOOL value, BOOL instantly, BOOL disableAutoStart);`
- **Purpose**: Starts or stops a vehicle engine, optionally instantly and with auto-start control.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `value` (`bool`): `true` to turn engine on.
  - `instantly` (`bool`): `true` to change state without animation.
  - `disableAutoStart` (`bool`): Prevents engine from auto-starting when entering.
  - **Returns**: `void`
- **OneSync / Networking**: Execute on vehicle owner to sync engine state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_engine
        -- Use: Toggle engine state instantly
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_engine', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local on = args[1] == 'on'
            SetVehicleEngineOn(veh, on, true, not on)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_engine */
    RegisterCommand('veh_engine', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const on = args[0] === 'on';
        SetVehicleEngineOn(veh, on, true, !on);
      }
    });
    ```
- **Caveats / Limitations**:
  - Helicopter rotors may stop visually when toggled.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleEngineOn

##### SetVehicleEnveffScale
- **Name**: SetVehicleEnveffScale
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_ENVEFF_SCALE(Vehicle vehicle, float fade);`
- **Purpose**: Adjusts the paint fade (environmental effect) of the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `fade` (`float`): Fade amount 0.0–1.0.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner to replicate paint fade.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_fade
        -- Use: Set paint fade
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_fade', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleEnveffScale(veh, tonumber(args[1]) or 0.5) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_fade */
    RegisterCommand('veh_fade', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleEnveffScale(veh, parseFloat(args[0]) || 0.5);
    });
    ```
- **Caveats / Limitations**:
  - Extreme values may appear visually incorrect.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleEnveffScale

##### SetVehicleExclusiveDriver
- **Name**: SetVehicleExclusiveDriver
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_EXCLUSIVE_DRIVER(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Toggles a flag related to exclusive driver handling.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): `true` enables the flag.
  - **Returns**: `void`
- **OneSync / Networking**: Apply on owner to propagate driver restrictions.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_exdriver
        -- Use: Toggle exclusive driver flag
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_exdriver', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleExclusiveDriver(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_exdriver */
    RegisterCommand('veh_exdriver', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleExclusiveDriver(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Misnamed native; does not fully enforce exclusive driver behavior.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleExclusiveDriver

##### _SetVehicleExclusiveDriver_2
- **Name**: _SetVehicleExclusiveDriver_2
- **Scope**: Client
- **Signature**: `void _SET_VEHICLE_EXCLUSIVE_DRIVER_2(Vehicle vehicle, Ped ped, int index);`
- **Purpose**: Assigns a specific ped as the exclusive driver for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `ped` (`Ped`): Ped allowed to drive.
  - `index` (`int`): Driver slot index.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call to enforce driver assignment.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_setdriver
        -- Use: Set self as exclusive driver
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_setdriver', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then _SetVehicleExclusiveDriver_2(veh, PlayerPedId(), 0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_setdriver */
    RegisterCommand('veh_setdriver', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) _SetVehicleExclusiveDriver_2(veh, PlayerPedId(), 0);
    });
    ```
- **Caveats / Limitations**:
  - Only one ped per index can be assigned.
- **Reference**: https://docs.fivem.net/natives/?n=_SetVehicleExclusiveDriver_2

##### SetVehicleExplodesOnHighExplosionDamage
- **Name**: SetVehicleExplodesOnHighExplosionDamage
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_EXPLODES_ON_HIGH_EXPLOSION_DAMAGE(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Controls whether high explosion damage instantly destroys the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): Boolean to enable or disable instant explosion.
  - **Returns**: `void`
- **OneSync / Networking**: Call on vehicle owner before explosions to ensure consistent damage behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_noexplode
        -- Use: Toggle high-explosion resistance
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_noexplode', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleExplodesOnHighExplosionDamage(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_noexplode */
    RegisterCommand('veh_noexplode', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleExplodesOnHighExplosionDamage(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Documentation is inconsistent on boolean meaning.
  - TODO(next-run): verify true/false behavior.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleExplodesOnHighExplosionDamage

##### _SetVehicleExplosiveDamageScale
- **Name**: _SetVehicleExplosiveDamageScale
- **Scope**: Client
- **Signature**: `Any _SET_VEHICLE_EXPLOSIVE_DAMAGE_SCALE(Vehicle vehicle, float scale);`
- **Purpose**: Adjusts how much explosive damage the vehicle receives.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `scale` (`float`): Multiplier for explosive damage.
  - **Returns**: `Any` (undocumented)
- **OneSync / Networking**: Owner must call to replicate damage scaling.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_exploscale
        -- Use: Scale explosive damage
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_exploscale', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then _SetVehicleExplosiveDamageScale(veh, tonumber(args[1]) or 1.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_exploscale */
    RegisterCommand('veh_exploscale', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) _SetVehicleExplosiveDamageScale(veh, parseFloat(args[0]) || 1.0);
    });
    ```
- **Caveats / Limitations**:
  - Introduced in build 3407; return value unused.
- **Reference**: https://docs.fivem.net/natives/?n=_SetVehicleExplosiveDamageScale

##### SetVehicleExtendedRemovalRange
- **Name**: SetVehicleExtendedRemovalRange
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_EXTENDED_REMOVAL_RANGE(Vehicle vehicle, int range);`
- **Purpose**: Sets distance at which the game can remove the vehicle when far away.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `range` (`int`): Distance limit (max 32767).
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call; extremely high ranges may affect streaming.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_removerange
        -- Use: Extend removal distance
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_removerange', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleExtendedRemovalRange(veh, tonumber(args[1]) or 1000) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_removerange */
    RegisterCommand('veh_removerange', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleExtendedRemovalRange(veh, parseInt(args[0]) || 1000);
    });
    ```
- **Caveats / Limitations**:
  - Setting very high ranges may degrade performance.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleExtendedRemovalRange

##### SetVehicleExtra
- **Name**: SetVehicleExtra
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_EXTRA(Vehicle vehicle, int extraId, BOOL disable);`
- **Purpose**: Enables or disables specific vehicle extras.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `extraId` (`int`): Extra identifier.
  - `disable` (`bool`): `true` turns the extra off.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner to sync extra visibility.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_extra
        -- Use: Toggle a vehicle extra
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_extra', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local id = tonumber(args[1])
        if veh ~= 0 and id then
            SetVehicleExtra(veh, id, args[2] ~= 'on')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_extra */
    RegisterCommand('veh_extra', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const id = parseInt(args[0]);
      if (veh !== 0 && !isNaN(id)) {
        SetVehicleExtra(veh, id, args[1] !== 'on');
      }
    });
    ```
- **Caveats / Limitations**:
  - Only vehicles with defined extras respond.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleExtra

##### SetVehicleExtraColours
- **Name**: SetVehicleExtraColours
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_EXTRA_COLOURS(Vehicle vehicle, int pearlescentColor, int wheelColor);`
- **Purpose**: Sets pearlescent and wheel colors.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `pearlescentColor` (`int`): Pearlescent color index.
  - `wheelColor` (`int`): Wheel color index.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner so colors replicate.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_extracolor
        -- Use: Set pearlescent and wheel colors
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_extracolor', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local p = tonumber(args[1]) or 0
        local w = tonumber(args[2]) or 0
        if veh ~= 0 then SetVehicleExtraColours(veh, p, w) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_extracolor */
    RegisterCommand('veh_extracolor', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const p = parseInt(args[0]) || 0;
      const w = parseInt(args[1]) || 0;
      if (veh !== 0) SetVehicleExtraColours(veh, p, w);
    });
    ```
- **Caveats / Limitations**:
  - Uses same color indices as `SetVehicleColours`.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleExtraColours

##### SetVehicleFixed
- **Name**: SetVehicleFixed
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_FIXED(Vehicle vehicle);`
- **Purpose**: Repairs vehicle body and cosmetic damage.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to repair.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call for repair to replicate.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_fix
        -- Use: Repair vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_fix', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleFixed(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_fix */
    RegisterCommand('veh_fix', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleFixed(veh);
    });
    ```
- **Caveats / Limitations**:
  - Does not repair destroyed engines.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleFixed

##### SetVehicleFlightNozzlePosition
- **Name**: SetVehicleFlightNozzlePosition
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_FLIGHT_NOZZLE_POSITION(Vehicle vehicle, float angleRatio);`
- **Purpose**: Sets VTOL flight nozzle angle ratio for aircraft like the Hydra.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): VTOL aircraft.
  - `angleRatio` (`float`): Desired nozzle angle 0.0–1.0.
  - **Returns**: `void`
- **OneSync / Networking**: Call on vehicle owner to sync nozzle position.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_nozzle
        -- Use: Adjust VTOL nozzle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_nozzle', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleFlightNozzlePosition(veh, tonumber(args[1]) or 0.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_nozzle */
    RegisterCommand('veh_nozzle', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleFlightNozzlePosition(veh, parseFloat(args[0]) || 0.0);
    });
    ```
- **Caveats / Limitations**:
  - Applies only to aircraft with VTOL capability.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleFlightNozzlePosition

##### SetVehicleFlightNozzlePositionImmediate
- **Name**: SetVehicleFlightNozzlePositionImmediate
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_FLIGHT_NOZZLE_POSITION_IMMEDIATE(Vehicle vehicle, float angle);`
- **Purpose**: Instantly sets VTOL nozzle angle without interpolation.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): VTOL aircraft.
  - `angle` (`float`): Angle value.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call to sync sudden nozzle change.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_nozzleimm
        -- Use: Snap VTOL nozzle angle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_nozzleimm', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleFlightNozzlePositionImmediate(veh, tonumber(args[1]) or 0.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_nozzleimm */
    RegisterCommand('veh_nozzleimm', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleFlightNozzlePositionImmediate(veh, parseFloat(args[0]) || 0.0);
    });
    ```
- **Caveats / Limitations**:
  - No smoothing is applied; abrupt changes may look unnatural.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleFlightNozzlePositionImmediate

##### SetVehicleForceAfterburner
- **Name**: SetVehicleForceAfterburner
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_FORCE_AFTERBURNER(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Forces aircraft afterburner on or off.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft.
  - `toggle` (`bool`): `true` forces afterburner.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner to replicate exhaust effects.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_afterburner
        -- Use: Toggle forced afterburner
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_afterburner', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleForceAfterburner(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_afterburner */
    RegisterCommand('veh_afterburner', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleForceAfterburner(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Effective only on vehicles with afterburner capability.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleForceAfterburner

##### SetVehicleForwardSpeed
- **Name**: SetVehicleForwardSpeed
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_FORWARD_SPEED(Vehicle vehicle, float speed);`
- **Purpose**: Sets the vehicle's forward speed in meters per second.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `speed` (`float`): Speed in m/s.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner to force movement speed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_speed
        -- Use: Set forward speed
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_speed', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleForwardSpeed(veh, tonumber(args[1]) or 10.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_speed */
    RegisterCommand('veh_speed', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleForwardSpeed(veh, parseFloat(args[0]) || 10.0);
    });
    ```
- **Caveats / Limitations**:
  - Sudden speed changes may desync if not owned by caller.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleForwardSpeed

##### SetVehicleFrictionOverride
- **Name**: SetVehicleFrictionOverride
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_FRICTION_OVERRIDE(Vehicle vehicle, float friction);`
- **Purpose**: Overrides vehicle friction coefficient.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `friction` (`float`): Friction value.
  - **Returns**: `void`
- **OneSync / Networking**: Must be applied each frame on owner to persist.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_friction
        -- Use: Set friction override
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_friction', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleFrictionOverride(veh, tonumber(args[1]) or 1.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_friction */
    RegisterCommand('veh_friction', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleFrictionOverride(veh, parseFloat(args[0]) || 1.0);
    });
    ```
- **Caveats / Limitations**:
  - Effect resets if not reapplied each frame.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleFrictionOverride

##### SetVehicleFullbeam
- **Name**: SetVehicleFullbeam
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_FULLBEAM(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Toggles high-beam headlights.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): `true` enables high beams.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call to replicate light state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_fullbeam
        -- Use: Toggle high beams
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_fullbeam', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleFullbeam(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_fullbeam */
    RegisterCommand('veh_fullbeam', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleFullbeam(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Only affects vehicles with headlight support.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleFullbeam

##### SetVehicleGeneratesEngineShockingEvents
- **Name**: SetVehicleGeneratesEngineShockingEvents
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_GENERATES_ENGINE_SHOCKING_EVENTS(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Enables creation of engine-related shocking events like flybys.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): `true` to generate events.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call to propagate event generation state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_shock
        -- Use: Toggle engine shocking events
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_shock', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleGeneratesEngineShockingEvents(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_shock */
    RegisterCommand('veh_shock', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleGeneratesEngineShockingEvents(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Primarily relevant for aircraft flybys.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleGeneratesEngineShockingEvents

##### SetVehicleGeneratorAreaOfInterest
- **Name**: SetVehicleGeneratorAreaOfInterest
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_GENERATOR_AREA_OF_INTEREST(float x, float y, float z, float radius);`
- **Purpose**: Focuses vehicle generators on a specific area.
- **Parameters / Returns**:
  - `x` (`float`): X coordinate center.
  - `y` (`float`): Y coordinate center.
  - `z` (`float`): Z coordinate center.
  - `radius` (`float`): Area radius.
  - **Returns**: `void`
- **OneSync / Networking**: Local to the caller; does not replicate to other players.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_cargen
        -- Use: Focus spawns around player
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_cargen', function(_, args)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        SetVehicleGeneratorAreaOfInterest(coords.x, coords.y, coords.z, tonumber(args[1]) or 100.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_cargen */
    RegisterCommand('veh_cargen', (_src, args) => {
      const ped = PlayerPedId();
      const coords = GetEntityCoords(ped, false);
      SetVehicleGeneratorAreaOfInterest(coords[0], coords[1], coords[2], parseFloat(args[0]) || 100.0);
    });
    ```
- **Caveats / Limitations**:
  - Use `ClearVehicleGeneratorAreaOfInterest` to reset.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleGeneratorAreaOfInterest

##### SetVehicleGravity
- **Name**: SetVehicleGravity
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_GRAVITY(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Enables or disables gravity effect on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): `true` enables gravity.
  - **Returns**: `void`
- **OneSync / Networking**: Apply on vehicle owner for consistent physics.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_gravity
        -- Use: Toggle gravity
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_gravity', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleGravity(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_gravity */
    RegisterCommand('veh_gravity', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleGravity(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Disabling gravity can cause unpredictable physics.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleGravity

##### SetVehicleHandbrake
- **Name**: SetVehicleHandbrake
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_HANDBRAKE(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Engages or releases the vehicle handbrake.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): `true` applies handbrake.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner to sync brake state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_handbrake
        -- Use: Toggle handbrake
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_handbrake', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleHandbrake(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_handbrake */
    RegisterCommand('veh_handbrake', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleHandbrake(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Does not visually press the brake pedal.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleHandbrake

##### _SetVehicleHandlingHashForAi
- **Name**: _SetVehicleHandlingHashForAi
- **Scope**: Client
- **Signature**: `void _SET_VEHICLE_HANDLING_HASH_FOR_AI(Vehicle vehicle, Hash hash);`
- **Purpose**: Overrides handling data used by AI drivers for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `hash` (`Hash`): Handling identifier.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call; affects how AI controls the vehicle.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_aihandling
        -- Use: Set AI handling profile
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_aihandling', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            _SetVehicleHandlingHashForAi(veh, GetHashKey(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_aihandling */
    RegisterCommand('veh_aihandling', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        _SetVehicleHandlingHashForAi(veh, GetHashKey(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Undocumented native; semantics may change.
  - TODO(next-run): verify handling hash behavior.
- **Reference**: https://docs.fivem.net/natives/?n=_SetVehicleHandlingHashForAi

### 13.3 Server Natives by Category
- No server native entries documented yet.

##### SetVehicleHasBeenDrivenFlag
- **Name**: SetVehicleHasBeenDrivenFlag
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_HAS_BEEN_DRIVEN_FLAG(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Marks a vehicle as having been driven, influencing persistence logic.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): `true` sets the flag.
  - **Returns**: `void`
- **OneSync / Networking**: Call on vehicle owner; affects only local state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_drivenflag
        -- Use: Toggle driven flag
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_drivenflag', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleHasBeenDrivenFlag(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_drivenflag */
    RegisterCommand('veh_drivenflag', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleHasBeenDrivenFlag(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Impact on network cleanup is undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleHasBeenDrivenFlag

##### SetVehicleHasStrongAxles
- **Name**: SetVehicleHasStrongAxles
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_HAS_STRONG_AXLES(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Makes axles resistant to deformation during collisions.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): Enables heavy-duty axles when `true`.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call to sync damage behaviour.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_axles
        -- Use: Toggle strong axles
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_axles', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleHasStrongAxles(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_axles */
    RegisterCommand('veh_axles', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleHasStrongAxles(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Only affects collision deformation, not suspension strength.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleHasStrongAxles

##### SetVehicleHomingLockon
- **Name**: SetVehicleHomingLockon
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_HOMING_LOCKON(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Toggles homing missile lock-on capability for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `toggle` (`bool`): Enables lock-on when `true`.
  - **Returns**: `void`
- **OneSync / Networking**: Owner should call to ensure weapon state sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_homing
        -- Use: Toggle homing lock-on
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_homing', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleHomingLockon(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_homing */
    RegisterCommand('veh_homing', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleHomingLockon(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Affects certain aircraft and weaponized vehicles only.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleHomingLockon

##### SetVehicleIndicatorLights
- **Name**: SetVehicleIndicatorLights
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_INDICATOR_LIGHTS(Vehicle vehicle, int turnSignal, BOOL toggle);`
- **Purpose**: Controls left/right indicator lights.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle entity.
  - `turnSignal` (`int`): `0` left, `1` right.
  - `toggle` (`bool`): `true` enables the light.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call required to replicate light state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_blink
        -- Use: Toggle indicators
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_blink', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            SetVehicleIndicatorLights(veh, tonumber(args[1]) or 0, args[2] == 'on')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_blink */
    RegisterCommand('veh_blink', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        SetVehicleIndicatorLights(veh, parseInt(args[0]) || 0, args[1] === 'on');
      }
    });
    ```
- **Caveats / Limitations**:
  - Only visual; no built-in blinking timer.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleIndicatorLights

##### SetVehicleInteriorColor
- **Name**: SetVehicleInteriorColor
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_INTERIOR_COLOR(Vehicle vehicle, int color);`
- **Purpose**: Sets interior trim color index.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `color` (`int`): Interior color ID.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call needed to replicate to others.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_intcol
        -- Use: Set interior color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_intcol', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleInteriorColor(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_intcol */
    RegisterCommand('veh_intcol', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleInteriorColor(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Color indices vary by vehicle model.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleInteriorColor

##### SetVehicleInteriorlight
- **Name**: SetVehicleInteriorlight
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_INTERIORLIGHT(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Toggles interior dome light.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`): `true` turns on light.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call to sync light state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_dome
        -- Use: Toggle interior light
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_dome', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleInteriorlight(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_dome */
    RegisterCommand('veh_dome', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleInteriorlight(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Light may auto-toggle with door state.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleInteriorlight

##### SetVehicleIsConsideredByPlayer
- **Name**: SetVehicleIsConsideredByPlayer
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_IS_CONSIDERED_BY_PLAYER(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Excludes vehicle from player targeting when disabled.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`): `false` removes from targeting.
  - **Returns**: `void`
- **OneSync / Networking**: Client-side only; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_ignore
        -- Use: Toggle player consideration
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_ignore', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleIsConsideredByPlayer(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_ignore */
    RegisterCommand('veh_ignore', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleIsConsideredByPlayer(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Does not prevent damage or collision.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleIsConsideredByPlayer

##### SetVehicleIsStolen
- **Name**: SetVehicleIsStolen
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_IS_STOLEN(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Marks a vehicle as stolen, affecting police response.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`): `true` marks as stolen.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner for AI police to react consistently.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_stolen
        -- Use: Toggle stolen state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_stolen', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleIsStolen(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_stolen */
    RegisterCommand('veh_stolen', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleIsStolen(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - AI behavior impact varies; not network-critical.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleIsStolen

##### SetVehicleIsWanted
- **Name**: SetVehicleIsWanted
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_IS_WANTED(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Marks vehicle as wanted for police tracking.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`): Wanted state.
  - **Returns**: `void`
- **OneSync / Networking**: Local AI only; not replicated.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_wanted
        -- Use: Toggle wanted flag
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_wanted', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleIsWanted(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_wanted */
    RegisterCommand('veh_wanted', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleIsWanted(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Primarily used for AI police dispatch.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleIsWanted

##### SetVehicleKeepEngineOnWhenAbandoned
- **Name**: SetVehicleKeepEngineOnWhenAbandoned
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_KEEP_ENGINE_ON_WHEN_ABANDONED(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Keeps engine running even when driver exits.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`): `true` leaves engine on.
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner; engine state replicates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_engineon
        -- Use: Keep engine running after exit
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_engineon', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleKeepEngineOnWhenAbandoned(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_engineon */
    RegisterCommand('veh_engineon', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleKeepEngineOnWhenAbandoned(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Engine may still shut off after timeout.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleKeepEngineOnWhenAbandoned

##### SetVehicleLivery
- **Name**: SetVehicleLivery
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_LIVERY(Vehicle vehicle, int livery);`
- **Purpose**: Applies a vehicle livery by index.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `livery` (`int`): Livery index.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must apply so others see it.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_livery
        -- Use: Set livery
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_livery', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleLivery(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_livery */
    RegisterCommand('veh_livery', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleLivery(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Valid indices depend on vehicle model.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleLivery

##### SetVehicleLivery2
- **Name**: SetVehicleLivery2
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_LIVERY2(Vehicle vehicle, int livery);`
- **Purpose**: Sets secondary livery layer when supported.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `livery` (`int`): Secondary livery index.
  - **Returns**: `void`
- **OneSync / Networking**: Apply on owner to replicate.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_livery2
        -- Use: Set secondary livery
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_livery2', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleLivery2(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_livery2 */
    RegisterCommand('veh_livery2', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleLivery2(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Not all vehicles support a second livery.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleLivery2

##### SetVehicleLodMultiplier
- **Name**: SetVehicleLodMultiplier
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_LOD_MULTIPLIER(Vehicle vehicle, float multiplier);`
- **Purpose**: Adjusts Level-of-Detail distance scaling for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `multiplier` (`float`): LOD distance scale.
  - **Returns**: `void`
- **OneSync / Networking**: Client-side visual tweak; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_lod
        -- Use: Set LOD multiplier
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_lod', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleLodMultiplier(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_lod */
    RegisterCommand('veh_lod', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleLodMultiplier(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Extreme values may impact performance.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleLodMultiplier

##### SetVehicleLights
- **Name**: SetVehicleLights
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_LIGHTS(Vehicle vehicle, int state);`
- **Purpose**: Forces vehicle lights state.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `state` (`int`): `0` normal, `1` always on, `2` always off, `3` unknown.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call required for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_lights
        -- Use: Set lights state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_lights', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleLights(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_lights */
    RegisterCommand('veh_lights', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleLights(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Some states may revert based on time-of-day.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleLights

##### SetVehicleLightsMode
- **Name**: SetVehicleLightsMode
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_LIGHTS_MODE(Vehicle vehicle, int mode);`
- **Purpose**: Overrides automatic headlight logic.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `mode` (`int`): `0` auto, `1` off, `2` on.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call ensures others see the mode.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_lightmode
        -- Use: Set lights mode
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_lightmode', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleLightsMode(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_lightmode */
    RegisterCommand('veh_lightmode', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleLightsMode(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Some vehicles ignore manual modes.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleLightsMode

##### SetVehicleLightsOnPlayerVehicle
- **Name**: SetVehicleLightsOnPlayerVehicle
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_LIGHTS_ON_PLAYER_VEHICLE(Player player, BOOL toggle);`
- **Purpose**: Forces headlights for a player’s current vehicle.
- **Parameters / Returns**:
  - `player` (`Player`)
  - `toggle` (`bool`): `true` lights on.
  - **Returns**: `void`
- **OneSync / Networking**: Local effect; only affects specified player’s view.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: player_lights
        -- Use: Force player's vehicle lights
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('player_lights', function(src, args)
        local toggle = args[1] == 'on'
        SetVehicleLightsOnPlayerVehicle(src, toggle)
    end, false)
    ```
  - JavaScript:
    ```javascript
    /* Command: player_lights */
    RegisterCommand('player_lights', (src, args) => {
      SetVehicleLightsOnPlayerVehicle(src, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Requires server context to target other players.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleLightsOnPlayerVehicle

##### SetVehicleMaxSpeed
- **Name**: SetVehicleMaxSpeed
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_MAX_SPEED(Vehicle vehicle, float speed);`
- **Purpose**: Caps maximum vehicle speed (m/s).
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `speed` (`float`): Max speed in meters per second.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call; speed cap replicates via physics.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_speed
        -- Use: Set max speed
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_speed', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleMaxSpeed(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_speed */
    RegisterCommand('veh_speed', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleMaxSpeed(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Setting `speed` to `-1` removes limit.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleMaxSpeed

##### SetVehicleMod
- **Name**: SetVehicleMod
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_MOD(Vehicle vehicle, int modType, int modIndex, BOOL customTires);`
- **Purpose**: Applies a mod kit component.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `modType` (`int`): Mod slot.
  - `modIndex` (`int`): Component index.
  - `customTires` (`bool`): Only for wheels.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must apply for others to see modification.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_mod
        -- Use: Apply vehicle mod
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_mod', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] and args[2] then
            SetVehicleMod(veh, tonumber(args[1]), tonumber(args[2]), args[3] == 'true')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_mod */
    RegisterCommand('veh_mod', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args.length >= 2) {
        SetVehicleMod(veh, parseInt(args[0]), parseInt(args[1]), args[2] === 'true');
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires mod kit installed via `SetVehicleModKit`.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleMod

##### SetVehicleModColor1
- **Name**: SetVehicleModColor1
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_MOD_COLOR_1(Vehicle vehicle, int paintType, int color, int pearlescent);`
- **Purpose**: Sets primary paint mod color.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `paintType` (`int`): Color category.
  - `color` (`int`): Color index.
  - `pearlescent` (`int`): Pearlescent index.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call required to sync visual change.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_modcol1
        -- Use: Set primary mod color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_modcol1', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] and args[2] and args[3] then
            SetVehicleModColor1(veh, tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_modcol1 */
    RegisterCommand('veh_modcol1', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args.length >= 3) {
        SetVehicleModColor1(veh, parseInt(args[0]), parseInt(args[1]), parseInt(args[2]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Valid indices depend on paint type.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleModColor1

##### SetVehicleModColor2
- **Name**: SetVehicleModColor2
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_MOD_COLOR_2(Vehicle vehicle, int paintType, int color);`
- **Purpose**: Sets secondary paint mod color.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `paintType` (`int`)
  - `color` (`int`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner call required for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_modcol2
        -- Use: Set secondary mod color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_modcol2', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] and args[2] then
            SetVehicleModColor2(veh, tonumber(args[1]), tonumber(args[2]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_modcol2 */
    RegisterCommand('veh_modcol2', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args.length >= 2) {
        SetVehicleModColor2(veh, parseInt(args[0]), parseInt(args[1]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Secondary paint may not be visible on all models.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleModColor2

##### SetVehicleModKit
- **Name**: SetVehicleModKit
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_MOD_KIT(Vehicle vehicle, int modKit);`
- **Purpose**: Selects mod kit allowing installation of modifications.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `modKit` (`int`): Usually `0` for default kit.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must set before applying mods.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_modkit
        -- Use: Set mod kit
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_modkit', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleModKit(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_modkit */
    RegisterCommand('veh_modkit', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleModKit(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Required before any `SetVehicleMod` calls.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleModKit

##### SetVehicleModelAlpha
- **Name**: SetVehicleModelAlpha
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_MODEL_ALPHA(Vehicle vehicle, int alpha);`
- **Purpose**: Sets vehicle model alpha transparency.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `alpha` (`int`): 0-255 transparency.
  - **Returns**: `void`
- **OneSync / Networking**: Client-side effect; non-replicated.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_alpha
        -- Use: Set vehicle transparency
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_alpha', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleModelAlpha(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_alpha */
    RegisterCommand('veh_alpha', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleModelAlpha(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Transparency resets when model reloads.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleModelAlpha

##### SetVehicleModelIsSuppressed
- **Name**: SetVehicleModelIsSuppressed
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_MODEL_IS_SUPPRESSED(Hash model, BOOL toggle);`
- **Purpose**: Suppresses ambient spawning of specified vehicle model.
- **Parameters / Returns**:
  - `model` (`Hash`): Vehicle model hash.
  - `toggle` (`bool`): `true` prevents spawning.
  - **Returns**: `void`
- **OneSync / Networking**: Global effect; call on server for all clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: model_suppress
        -- Use: Toggle model suppression
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('model_suppress', function(_, args)
        if args[1] then
            SetVehicleModelIsSuppressed(GetHashKey(args[1]), args[2] == 'on')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: model_suppress */
    RegisterCommand('model_suppress', (_src, args) => {
      if (args[0]) {
        SetVehicleModelIsSuppressed(GetHashKey(args[0]), args[1] === 'on');
      }
    });
    ```
- **Caveats / Limitations**:
  - Does not despawn existing vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleModelIsSuppressed

##### SetVehicleNeonLightEnabled
- **Name**: SetVehicleNeonLightEnabled
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_NEON_LIGHT_ENABLED(Vehicle vehicle, int index, BOOL toggle);`
- **Purpose**: Enables or disables neon light tubes by index.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `index` (`int`): 0=left,1=right,2=front,3=back.
  - `toggle` (`bool`): `true` enables.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call required; neon state replicates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_neon
        -- Use: Toggle neon lights
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_neon', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleNeonLightEnabled(veh, tonumber(args[1]), args[2] == 'on')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_neon */
    RegisterCommand('veh_neon', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args.length >= 2) {
        SetVehicleNeonLightEnabled(veh, parseInt(args[0]), args[1] === 'on');
      }
    });
    ```
- **Caveats / Limitations**:
  - Neon mods must be installed first.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleNeonLightEnabled

##### SetVehicleNeonLightsColour
- **Name**: SetVehicleNeonLightsColour
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_NEON_LIGHTS_COLOUR(Vehicle vehicle, int r, int g, int b);`
- **Purpose**: Sets RGB color for neon lighting.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `r` (`int`)
  - `g` (`int`)
  - `b` (`int`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call; color replicates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_neoncol
        -- Use: Set neon color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_neoncol', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] and args[2] and args[3] then
            SetVehicleNeonLightsColour(veh, tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_neoncol */
    RegisterCommand('veh_neoncol', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args.length >= 3) {
        SetVehicleNeonLightsColour(veh, parseInt(args[0]), parseInt(args[1]), parseInt(args[2]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Values outside 0-255 are clamped.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleNeonLightsColour
CONTINUE-HERE — 2025-09-12T18:34:33+00:00 — next: Vehicle :: SetVehicleNumberPlateText
