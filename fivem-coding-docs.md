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
| Overall | 6442 | 1008 | 5434 | 2025-09-12T20:13:58.131329+00:00 |
| Vehicle | 751 | 677 | 74 | 2025-09-12T20:13:58.131329+00:00 |

### 13.1 Taxonomy & Scope Notes
- Natives are grouped by high-level game systems (e.g., Vehicle, Player) and scope (Client or Server).
- Entries are sorted alphabetically within each category.

### 13.2 Client Natives by Category
#### Vehicle
##### AddRoadNodeSpeedZone
- **Name**: AddRoadNodeSpeedZone
- **Scope**: Client
- **Signature**: `int ADD_ROAD_NODE_SPEED_ZONE(float x, float y, float z, float radius, float speed, BOOL p5);`
- **Purpose**: Defines a temporary speed limit area for AI vehicles.
- **Parameters / Returns**:
  - `x` (`float`)
  - `y` (`float`)
  - `z` (`float`)
  - `radius` (`float`): Zone radius in meters.
  - `speed` (`float`): Max speed in m/s.
  - `p5` (`bool`): Unknown flag.
  - **Returns**: `int` zone ID.
- **OneSync / Networking**: Local client only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: roadspeedzone
        -- Use: Slow traffic near player
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('roadspeedzone', function()
        local pos = GetEntityCoords(PlayerPedId())
        AddRoadNodeSpeedZone(pos.x, pos.y, pos.z, 50.0, 10.0, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: roadspeedzone */
    RegisterCommand('roadspeedzone', (_src) => {
      const [x, y, z] = GetEntityCoords(PlayerPedId(), false);
      AddRoadNodeSpeedZone(x, y, z, 50.0, 10.0, false);
    });
    ```
- **Caveats / Limitations**:
  - Zone disappears on resource stop.
  - TODO(next-run): verify `p5`.
- **Reference**: https://docs.fivem.net/natives/?n=AddRoadNodeSpeedZone

##### AddVehicleCombatAngledAvoidanceArea
- **Name**: AddVehicleCombatAngledAvoidanceArea
- **Scope**: Client
- **Signature**: `Any ADD_VEHICLE_COMBAT_ANGLED_AVOIDANCE_AREA(float p0, float p1, float p2, float p3, float p4, float p5, float p6);`
- **Purpose**: Marks an angled region that AI drivers will try to avoid.
- **Parameters / Returns**:
  - `p0–p6` (`float`): Corner coordinates of the area; semantics undocumented.
  - **Returns**: `Any` handle.
- **OneSync / Networking**: Client-side only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_avoid_area
        -- Use: Keep NPC cars away from crash scene
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_avoid_area', function()
        local pos = GetEntityCoords(PlayerPedId())
        AddVehicleCombatAngledAvoidanceArea(pos.x+5.0,pos.y+5.0,pos.z,pos.x-5.0,pos.y-5.0,pos.z+5.0,5.0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_avoid_area */
    RegisterCommand('veh_avoid_area', () => {
      const [x,y,z]=GetEntityCoords(PlayerPedId(), false);
      AddVehicleCombatAngledAvoidanceArea(x+5.0,y+5.0,z,x-5.0,y-5.0,z+5.0,5.0);
    });
    ```
- **Caveats / Limitations**:
  - Parameters lack official docs.
  - TODO(next-run): verify usage.
- **Reference**: https://docs.fivem.net/natives/?n=AddVehicleCombatAngledAvoidanceArea

##### AddVehiclePhoneExplosiveDevice
- **Name**: AddVehiclePhoneExplosiveDevice
- **Scope**: Client
- **Signature**: `void ADD_VEHICLE_PHONE_EXPLOSIVE_DEVICE(Vehicle vehicle);`
- **Purpose**: Attaches a remotely detonated bomb to a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - **Returns**: `void`
- **OneSync / Networking**: Trigger on vehicle owner so device syncs.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_bomb
        -- Use: Plant phone explosive on current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_bomb', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then AddVehiclePhoneExplosiveDevice(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_bomb */
    RegisterCommand('veh_bomb', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) AddVehiclePhoneExplosiveDevice(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only works on vehicles supporting remote explosives.
- **Reference**: https://docs.fivem.net/natives/?n=AddVehiclePhoneExplosiveDevice

##### AddVehicleStuckCheckWithWarp
- **Name**: AddVehicleStuckCheckWithWarp
- **Scope**: Client
- **Signature**: `void ADD_VEHICLE_STUCK_CHECK_WITH_WARP(Any p0, float p1, Any p2, BOOL p3, BOOL p4, BOOL p5, Any p6);`
- **Purpose**: Monitors a vehicle for being stuck and warps it when necessary.
- **Parameters / Returns**:
  - `p0` (`Any`): Vehicle handle.
  - `p1` (`float`): Time in seconds before warp.
  - `p2`–`p6` (`Any/bool`): Undocumented flags.
  - **Returns**: `void`
- **OneSync / Networking**: Run on owner to avoid conflicting warps.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_stuckwarp
        -- Use: Auto-warp stuck vehicles after 10s
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_stuckwarp', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then AddVehicleStuckCheckWithWarp(veh, 10.0, 0, true, true, true, 0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_stuckwarp */
    RegisterCommand('veh_stuckwarp', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) AddVehicleStuckCheckWithWarp(veh, 10.0, 0, true, true, true, 0);
    });
    ```
- **Caveats / Limitations**:
  - Parameters largely undocumented.
  - TODO(next-run): confirm flag meanings.
- **Reference**: https://docs.fivem.net/natives/?n=AddVehicleStuckCheckWithWarp

##### AddVehicleUpsidedownCheck
- **Name**: AddVehicleUpsidedownCheck
- **Scope**: Client
- **Signature**: `void ADD_VEHICLE_UPSIDEDOWN_CHECK(Vehicle vehicle);`
- **Purpose**: Enables automatic upside-down detection for a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to monitor.
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_flipcheck
        -- Use: Start upside-down monitoring
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_flipcheck', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then AddVehicleUpsidedownCheck(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_flipcheck */
    RegisterCommand('veh_flipcheck', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) AddVehicleUpsidedownCheck(veh);
    });
    ```
- **Caveats / Limitations**:
  - Behaviour after detection controlled by game engine.
- **Reference**: https://docs.fivem.net/natives/?n=AddVehicleUpsidedownCheck

##### AllowAmbientVehiclesToAvoidAdverseConditions
- **Name**: AllowAmbientVehiclesToAvoidAdverseConditions
- **Scope**: Client
- **Signature**: `void ALLOW_AMBIENT_VEHICLES_TO_AVOID_ADVERSE_CONDITIONS(Vehicle vehicle);`
- **Purpose**: Debug native that hints ambient AI to reroute around hazards.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Reference model for avoidance.
  - **Returns**: `void`
- **OneSync / Networking**: Local hint only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_avoid
        -- Use: Encourage local traffic to reroute
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_avoid', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then AllowAmbientVehiclesToAvoidAdverseConditions(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_avoid */
    RegisterCommand('veh_avoid', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) AllowAmbientVehiclesToAvoidAdverseConditions(veh);
    });
    ```
- **Caveats / Limitations**:
  - Native flagged as debug and may have no effect.
- **Reference**: https://docs.fivem.net/natives/?n=AllowAmbientVehiclesToAvoidAdverseConditions
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

##### SetVehicleNumberPlateText
- **Name**: SetVehicleNumberPlateText
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_NUMBER_PLATE_TEXT(Vehicle vehicle, const char* text);`
- **Purpose**: Writes custom license plate text to a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target vehicle.
  - `text` (`string`): Up to 8 characters.
  - **Returns**: `void`
- **OneSync / Networking**: Must be called on the entity owner so the plate syncs.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_plate
        -- Use: Change number plate text
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_plate', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleNumberPlateText(veh, args[1])
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_plate */
    RegisterCommand('veh_plate', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleNumberPlateText(veh, args[0]);
      }
    });
    ```
- **Caveats / Limitations**:
  - Plate text is truncated beyond eight characters.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleNumberPlateText

##### SetVehicleNumberPlateTextIndex
- **Name**: SetVehicleNumberPlateTextIndex
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(Vehicle vehicle, int index);`
- **Purpose**: Sets license plate style by index.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `index` (`int`): Plate style ID.
  - **Returns**: `void`
- **OneSync / Networking**: Run on owner to sync plate style.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_plateindex
        -- Use: Set plate style
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_plateindex', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleNumberPlateTextIndex(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_plateindex */
    RegisterCommand('veh_plateindex', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleNumberPlateTextIndex(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Style indices differ between game builds.
  - TODO(next-run): verify exact index mapping.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleNumberPlateTextIndex

##### SetVehicleOilLevel
- **Name**: SetVehicleOilLevel
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_OIL_LEVEL(Vehicle vehicle, float level);`
- **Purpose**: Adjusts the oil level used by engine damage calculations.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `level` (`float`): 0.0–1.0 recommended.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must apply to sync engine condition.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_oil
        -- Use: Set oil level
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_oil', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleOilLevel(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_oil */
    RegisterCommand('veh_oil', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleOilLevel(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Extreme values may instantly stall the engine.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleOilLevel

##### SetVehicleOnGroundProperly
- **Name**: SetVehicleOnGroundProperly
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_ON_GROUND_PROPERLY(Vehicle vehicle);`
- **Purpose**: Snaps a vehicle to the ground to prevent floating.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner; positioning replicates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_ground
        -- Use: Force vehicle onto ground
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_ground', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleOnGroundProperly(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_ground */
    RegisterCommand('veh_ground', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleOnGroundProperly(veh);
    });
    ```
- **Caveats / Limitations**:
  - May clip through geometry on uneven terrain.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleOnGroundProperly

##### SetVehicleOutOfControl
- **Name**: SetVehicleOutOfControl
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_OUT_OF_CONTROL(Vehicle vehicle, BOOL killDriver, BOOL explodeOnImpact);`
- **Purpose**: Forces driver loss of control and optional explosion.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `killDriver` (`bool`): Kills driver if true.
  - `explodeOnImpact` (`bool`): Explodes when crashing.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must execute; explosion syncs automatically.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_outofcontrol
        -- Use: Make vehicle lose control
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_outofcontrol', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            SetVehicleOutOfControl(veh, args[1] == 'kill', args[2] == 'boom')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_outofcontrol */
    RegisterCommand('veh_outofcontrol', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        SetVehicleOutOfControl(veh, args[0] === 'kill', args[1] === 'boom');
      }
    });
    ```
- **Caveats / Limitations**:
  - May ignore seatbelt or safety scripts.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleOutOfControl

##### SetVehiclePaintFade
- **Name**: SetVehiclePaintFade
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_PAINT_FADE(Vehicle vehicle, float value);`
- **Purpose**: Fades vehicle paint to a worn look.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `value` (`float`): 0.0 pristine, 1.0 fully faded.
  - **Returns**: `void`
- **OneSync / Networking**: Apply on owner to sync appearance.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_paintfade
        -- Use: Adjust paint fade
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_paintfade', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehiclePaintFade(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_paintfade */
    RegisterCommand('veh_paintfade', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehiclePaintFade(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Value outside 0.0–1.0 clamps.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehiclePaintFade

##### SetVehiclePetrolTankHealth
- **Name**: SetVehiclePetrolTankHealth
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_PETROL_TANK_HEALTH(Vehicle vehicle, float health);`
- **Purpose**: Sets fuel tank durability affecting fire/explosion.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `health` (`float`): Negative values cause leaks.
  - **Returns**: `void`
- **OneSync / Networking**: Owner should adjust to sync damage.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_tankhealth
        -- Use: Modify petrol tank health
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_tankhealth', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehiclePetrolTankHealth(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_tankhealth */
    RegisterCommand('veh_tankhealth', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehiclePetrolTankHealth(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Unrealistic values may crash game.
  - TODO(next-run): verify health range.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehiclePetrolTankHealth

##### SetVehicleProvidesCover
- **Name**: SetVehicleProvidesCover
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_PROVIDES_COVER(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Makes vehicle usable as cover in combat.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner call required to sync cover flag.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_cover
        -- Use: Toggle cover capability
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_cover', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleProvidesCover(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_cover */
    RegisterCommand('veh_cover', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleProvidesCover(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Affects AI cover behavior; no effect for destructible props.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleProvidesCover

##### SetVehicleRocketBoostRefillTime
- **Name**: SetVehicleRocketBoostRefillTime
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_ROCKET_BOOST_REFILL_TIME(Vehicle vehicle, float seconds);`
- **Purpose**: Sets recharge duration for rocket boost vehicles.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `seconds` (`float`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner call; boost state replicates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_boostrefill
        -- Use: Adjust boost refill time
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_boostrefill', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleRocketBoostRefillTime(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_boostrefill */
    RegisterCommand('veh_boostrefill', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleRocketBoostRefillTime(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Only affects vehicles with rocket boost mod.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleRocketBoostRefillTime

##### SetVehicleRocketBoostPercentage
- **Name**: SetVehicleRocketBoostPercentage
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_ROCKET_BOOST_PERCENTAGE(Vehicle vehicle, float percentage);`
- **Purpose**: Sets current boost charge percentage.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `percentage` (`float`): 0.0–1.0.
  - **Returns**: `void`
- **OneSync / Networking**: Owner should update to sync boost gauge.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_boostpct
        -- Use: Set boost charge
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_boostpct', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleRocketBoostPercentage(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_boostpct */
    RegisterCommand('veh_boostpct', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleRocketBoostPercentage(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Values over 1.0 are clamped.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleRocketBoostPercentage

##### SetVehicleSteerBias
- **Name**: SetVehicleSteerBias
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_STEER_BIAS(Vehicle vehicle, float bias);`
- **Purpose**: Applies directional bias to steering for drifting.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `bias` (`float`): -1.0 left to 1.0 right.
  - **Returns**: `void`
- **OneSync / Networking**: Execute on owner; affects handling sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_steerbias
        -- Use: Apply steering bias
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_steerbias', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleSteerBias(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_steerbias */
    RegisterCommand('veh_steerbias', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleSteerBias(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Extreme values may cause vehicle spinouts.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleSteerBias

##### SetVehicleSteeringAngle
- **Name**: SetVehicleSteeringAngle
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_STEERING_ANGLE(Vehicle vehicle, float angle);`
- **Purpose**: Overrides current steering angle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `angle` (`float`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner call; angle replicates.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_steerangle
        -- Use: Force steering angle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_steerangle', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleSteeringAngle(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_steerangle */
    RegisterCommand('veh_steerangle', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleSteeringAngle(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Only temporary; game physics overrides quickly.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleSteeringAngle

##### SetVehicleSteeringScale
- **Name**: SetVehicleSteeringScale
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_STEERING_SCALE(Vehicle vehicle, float scale);`
- **Purpose**: Scales steering sensitivity.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `scale` (`float`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner call required for synchronization.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_steerscale
        -- Use: Adjust steering sensitivity
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_steerscale', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleSteeringScale(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_steerscale */
    RegisterCommand('veh_steerscale', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleSteeringScale(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Value <1 reduces turn radius; >1 increases risk of rollover.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleSteeringScale

##### SetVehicleStrong
- **Name**: SetVehicleStrong
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_STRONG(Vehicle vehicle, BOOL strong);`
- **Purpose**: Toggles reduced deformation for the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `strong` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call for consistency across clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_strong
        -- Use: Toggle strong body
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_strong', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleStrong(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_strong */
    RegisterCommand('veh_strong', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleStrong(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Does not make vehicle indestructible.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleStrong

##### SetVehicleTimedExplosion
- **Name**: SetVehicleTimedExplosion
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_TIMED_EXPLOSION(Vehicle vehicle, Vehicle owner, BOOL toggle);`
- **Purpose**: Arms a timed explosive on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `owner` (`Vehicle`): Vehicle responsible for explosion (e.g., attacker).
  - `toggle` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Must run on server or owner to sync explosion.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_explode
        -- Use: Arm timed explosion
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_explode', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            SetVehicleTimedExplosion(veh, veh, args[1] == 'on')
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_explode */
    RegisterCommand('veh_explode', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        SetVehicleTimedExplosion(veh, veh, args[0] === 'on');
      }
    });
    ```
- **Caveats / Limitations**:
  - Explosion timer length is fixed by game; cannot be adjusted.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleTimedExplosion

##### SetVehicleTyreBurst
- **Name**: SetVehicleTyreBurst
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_TYRE_BURST(Vehicle vehicle, int index, BOOL onRim, float damage);`
- **Purpose**: Bursts a tyre with optional rim damage.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `index` (`int`): Tyre index.
  - `onRim` (`bool`): Leave rim intact when false.
  - `damage` (`float`): Applied tyre health reduction.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must apply to sync wheel state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_burst
        -- Use: Burst a tyre
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_burst', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleTyreBurst(veh, tonumber(args[1]), true, 1000.0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_burst */
    RegisterCommand('veh_burst', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleTyreBurst(veh, parseInt(args[0]), true, 1000.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Tyre index varies by vehicle class; consult model data.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleTyreBurst

##### SetVehicleTyreFixed
- **Name**: SetVehicleTyreFixed
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_TYRE_FIXED(Vehicle vehicle, int index);`
- **Purpose**: Repairs a blown tyre.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `index` (`int`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must repair to sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_fixwheel
        -- Use: Fix a tyre
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_fixwheel', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleTyreFixed(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_fixwheel */
    RegisterCommand('veh_fixwheel', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleTyreFixed(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Does not repair rim or body damage.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleTyreFixed

##### SetVehicleTyreSmokeColor
- **Name**: SetVehicleTyreSmokeColor
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_TYRE_SMOKE_COLOR(Vehicle vehicle, int r, int g, int b);`
- **Purpose**: Sets RGB color for tyre smoke mods.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `r` (`int`)
  - `g` (`int`)
  - `b` (`int`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner call; color replicates with tyre smoke mod installed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_smokecol
        -- Use: Set tyre smoke color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_smokecol', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] and args[2] and args[3] then
            SetVehicleTyreSmokeColor(veh, tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_smokecol */
    RegisterCommand('veh_smokecol', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args.length >= 3) {
        SetVehicleTyreSmokeColor(veh, parseInt(args[0]), parseInt(args[1]), parseInt(args[2]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires tyre smoke mod to be installed.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleTyreSmokeColor

##### SetVehicleUndriveable
- **Name**: SetVehicleUndriveable
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_UNDRIVEABLE(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Toggles ability to control the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call for consistent control state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_lock
        -- Use: Disable vehicle controls
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_lock', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleUndriveable(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_lock */
    RegisterCommand('veh_lock', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleUndriveable(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Vehicle can still move due to physics even when undriveable.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleUndriveable

##### SetVehicleWheelSize
- **Name**: SetVehicleWheelSize
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_WHEEL_SIZE(Vehicle vehicle, float size);`
- **Purpose**: Scales wheel diameter.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `size` (`float`)
- **Returns**: `void`
- **OneSync / Networking**: Owner call required; may not replicate in all builds.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_wheelsize
        -- Use: Set wheel size
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_wheelsize', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleWheelSize(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_wheelsize */
    RegisterCommand('veh_wheelsize', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleWheelSize(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Visual-only; handling may not adjust.
  - TODO(next-run): confirm replication reliability.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleWheelSize

##### SetVehicleWheelWidth
- **Name**: SetVehicleWheelWidth
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_WHEEL_WIDTH(Vehicle vehicle, float width);`
- **Purpose**: Adjusts wheel width.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `width` (`float`)
- **Returns**: `void`
- **OneSync / Networking**: Owner call; may not be networked.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_wheelwidth
        -- Use: Set wheel width
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_wheelwidth', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleWheelWidth(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_wheelwidth */
    RegisterCommand('veh_wheelwidth', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleWheelWidth(veh, parseFloat(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Purely cosmetic on most models.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleWheelWidth

##### SetVehicleWheelsCanBreak
- **Name**: SetVehicleWheelsCanBreak
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_WHEELS_CAN_BREAK(Vehicle vehicle, BOOL enabled);`
- **Purpose**: Allows or prevents wheel detachment.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `enabled` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must apply for network consistency.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_wheelbreak
        -- Use: Toggle wheel detachment
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_wheelbreak', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleWheelsCanBreak(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_wheelbreak */
    RegisterCommand('veh_wheelbreak', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleWheelsCanBreak(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Disabling may conflict with damage scripts.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleWheelsCanBreak

##### SetVehicleWillCrashWhenLeaving
- **Name**: SetVehicleWillCrashWhenLeaving
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_WILL_CRASH_WHEN_LEAVING(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Forces a vehicle to crash when the driver exits.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call for consistent crash behavior.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_exitcrash
        -- Use: Enable exit crash
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_exitcrash', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleWillCrashWhenLeaving(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_exitcrash */
    RegisterCommand('veh_exitcrash', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleWillCrashWhenLeaving(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Primarily affects scripted sequences; behavior may be inconsistent.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleWillCrashWhenLeaving

##### SetVehicleWindowTint
- **Name**: SetVehicleWindowTint
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_WINDOW_TINT(Vehicle vehicle, int tint);`
- **Purpose**: Applies predefined window tint level.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `tint` (`int`): 0 stock, higher values darker.
  - **Returns**: `void`
- **OneSync / Networking**: Owner call to sync tint with others.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_tint
        -- Use: Change window tint
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_tint', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            SetVehicleWindowTint(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_tint */
    RegisterCommand('veh_tint', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        SetVehicleWindowTint(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Tint options depend on vehicle class.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleWindowTint

##### SetVehicleWindscreenArmour
- **Name**: SetVehicleWindscreenArmour
- **Scope**: Client
- **Signature**: `void SET_VEHICLE_WINDSCREEN_ARMOUR(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Enables bullet-resistant windscreen.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call; affects bullet penetration.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_windscreen
        -- Use: Toggle windscreen armour
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_windscreen', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleWindscreenArmour(veh, args[1] == 'on') end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_windscreen */
    RegisterCommand('veh_windscreen', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SetVehicleWindscreenArmour(veh, args[0] === 'on');
    });
    ```
- **Caveats / Limitations**:
  - Only applies to vehicles supporting armour mods.
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleWindscreenArmour


##### SetVehicleXenonLightsColor
- **Name**: SetVehicleXenonLightsColor
- **Scope**: Client
- **Signature**: `void _SET_VEHICLE_XENON_LIGHTS_COLOR(Vehicle vehicle, int color);`
- **Purpose**: Changes xenon headlight color.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `color` (`int`): 0–12 paint index.
  - **Returns**: `void`
- **OneSync / Networking**: Vehicle owner must apply for sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_xenon
        -- Use: Set xenon color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_xenon', function(_, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and args[1] then
            ToggleVehicleMod(veh, 22, true)
            SetVehicleHeadlightsColour(veh, tonumber(args[1]))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_xenon */
    RegisterCommand('veh_xenon', (_src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && args[0]) {
        ToggleVehicleMod(veh, 22, true);
        SetVehicleHeadlightsColour(veh, parseInt(args[0]));
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires xenon mod installed (mod index 22).
- **Reference**: https://docs.fivem.net/natives/?n=SetVehicleXenonLightsColor

##### SkipTimeInPlaybackRecordedVehicle
- **Name**: SkipTimeInPlaybackRecordedVehicle
- **Scope**: Client
- **Signature**: `void SKIP_TIME_IN_PLAYBACK_RECORDED_VEHICLE(Vehicle vehicle, float time);`
- **Purpose**: Fast-forwards a playback recording by the given time.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `time` (`float`): Seconds to skip.
  - **Returns**: `void`
- **OneSync / Networking**: Playback is local; owner must run for sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_skip
        -- Use: Skip 5s of current recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_skip', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SkipTimeInPlaybackRecordedVehicle(veh, 5.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_skip */
    RegisterCommand('playback_skip', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SkipTimeInPlaybackRecordedVehicle(veh, 5.0);
    });
    ```
- **Caveats / Limitations**:
  - Only works while playback is active.
- **Reference**: https://docs.fivem.net/natives/?n=SkipTimeInPlaybackRecordedVehicle

##### SkipToEndAndStopPlaybackRecordedVehicle
- **Name**: SkipToEndAndStopPlaybackRecordedVehicle
- **Scope**: Client
- **Signature**: `void SKIP_TO_END_AND_STOP_PLAYBACK_RECORDED_VEHICLE(Vehicle vehicle);`
- **Purpose**: Jumps to the end of a playback recording and stops it.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_end
        -- Use: Finish current vehicle recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_end', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SkipToEndAndStopPlaybackRecordedVehicle(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_end */
    RegisterCommand('playback_end', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SkipToEndAndStopPlaybackRecordedVehicle(veh);
    });
    ```
- **Caveats / Limitations**:
  - Recording must be loaded.
- **Reference**: https://docs.fivem.net/natives/?n=SkipToEndAndStopPlaybackRecordedVehicle

##### SmashVehicleWindow
- **Name**: SmashVehicleWindow
- **Scope**: Client
- **Signature**: `void SMASH_VEHICLE_WINDOW(Vehicle vehicle, int windowIndex);`
- **Purpose**: Breaks a specified vehicle window.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `windowIndex` (`int`): Window ID (see `IsVehicleWindowIntact`).
  - **Returns**: `void`
- **OneSync / Networking**: Call on owner so damage syncs.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: smash_window
        -- Use: Break driver's window
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('smash_window', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SmashVehicleWindow(veh, 0) end -- 0: driver
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: smash_window */
    RegisterCommand('smash_window', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) SmashVehicleWindow(veh, 0);
    });
    ```
- **Caveats / Limitations**:
  - Only affects intact windows.
- **Reference**: https://docs.fivem.net/natives/?n=SmashVehicleWindow

##### StabiliseEntityAttachedToHeli
- **Name**: StabiliseEntityAttachedToHeli
- **Scope**: Client
- **Signature**: `void STABILISE_ENTITY_ATTACHED_TO_HELI(Vehicle vehicle, Entity entity, float p2);`
- **Purpose**: Reduces swing of an entity attached to a helicopter.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Helicopter.
  - `entity` (`Entity`): Attached entity.
  - `p2` (`float`): Strength factor.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must manage both entities.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: heli_stabilise
        -- Use: Stabilise attached cargo
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('heli_stabilise', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        local attached = GetEntityAttachedTo(heli)
        if heli ~= 0 and attached ~= 0 then
            StabiliseEntityAttachedToHeli(heli, attached, 1.0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: heli_stabilise */
    RegisterCommand('heli_stabilise', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      const attached = GetEntityAttachedTo(heli);
      if (heli !== 0 && attached !== 0) {
        StabiliseEntityAttachedToHeli(heli, attached, 1.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Only for helicopter attachments.
- **Reference**: https://docs.fivem.net/natives/?n=StabiliseEntityAttachedToHeli

##### StartPlaybackRecordedVehicle
- **Name**: StartPlaybackRecordedVehicle
- **Scope**: Client
- **Signature**: `void START_PLAYBACK_RECORDED_VEHICLE(Vehicle vehicle, int recording, char* script, BOOL p3);`
- **Purpose**: Starts playing a prerecorded driving path on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `recording` (`int`): Recording ID.
  - `script` (`string`)
  - `p3` (`bool`): Trailer flag.
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only; ensure recording loaded.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_start
        -- Use: Play recording 1
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_start', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then StartPlaybackRecordedVehicle(veh, 1, "scripts", false) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_start */
    RegisterCommand('playback_start', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) StartPlaybackRecordedVehicle(veh, 1, 'scripts', false);
    });
    ```
- **Caveats / Limitations**:
  - Recording must be requested beforehand.
- **Reference**: https://docs.fivem.net/natives/?n=StartPlaybackRecordedVehicle

##### StartPlaybackRecordedVehicleUsingAi
- **Name**: StartPlaybackRecordedVehicleUsingAi
- **Scope**: Client
- **Signature**: `void START_PLAYBACK_RECORDED_VEHICLE_USING_AI(Vehicle vehicle, int recording, char* script, float speed, int drivingStyle);`
- **Purpose**: Plays a vehicle recording while letting AI handle driving decisions.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `recording` (`int`)
  - `script` (`string`)
  - `speed` (`float`): Playback speed multiplier.
  - `drivingStyle` (`int`): AI style flags.
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only; AI may interact with traffic.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_ai
        -- Use: Play recording using AI at normal speed
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_ai', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then StartPlaybackRecordedVehicleUsingAi(veh, 1, "scripts", 1.0, 0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_ai */
    RegisterCommand('playback_ai', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) StartPlaybackRecordedVehicleUsingAi(veh, 1, 'scripts', 1.0, 0);
    });
    ```
- **Caveats / Limitations**:
  - Driving style values mirror SetDriveTaskDrivingStyle.
- **Reference**: https://docs.fivem.net/natives/?n=StartPlaybackRecordedVehicleUsingAi

##### StartPlaybackRecordedVehicleWithFlags
- **Name**: StartPlaybackRecordedVehicleWithFlags
- **Scope**: Client
- **Signature**: `void START_PLAYBACK_RECORDED_VEHICLE_WITH_FLAGS(Vehicle vehicle, int recording, char* script, int flags, int time, int drivingStyle);`
- **Purpose**: Starts playback with extra control flags and initial offset.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `recording` (`int`)
  - `script` (`string`)
  - `flags` (`int`): Bitfield affecting AI behaviour.
  - `time` (`int`): Start offset ms.
  - `drivingStyle` (`int`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_flags
        -- Use: Start recording with flags
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_flags', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then StartPlaybackRecordedVehicleWithFlags(veh,1,"scripts",0,0,0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_flags */
    RegisterCommand('playback_flags', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) StartPlaybackRecordedVehicleWithFlags(veh,1,'scripts',0,0,0);
    });
    ```
- **Caveats / Limitations**:
  - Flags usage undocumented.
- **Reference**: https://docs.fivem.net/natives/?n=StartPlaybackRecordedVehicleWithFlags

##### StartVehicleAlarm
- **Name**: StartVehicleAlarm
- **Scope**: Client
- **Signature**: `void START_VEHICLE_ALARM(Vehicle vehicle);`
- **Purpose**: Triggers the vehicle's alarm siren.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must trigger to sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_alarm
        -- Use: Start car alarm
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_alarm', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then StartVehicleAlarm(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_alarm */
    RegisterCommand('veh_alarm', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) StartVehicleAlarm(veh);
    });
    ```
- **Caveats / Limitations**:
  - Alarm stops automatically after timeout.
- **Reference**: https://docs.fivem.net/natives/?n=StartVehicleAlarm

##### StartVehicleHorn
- **Name**: StartVehicleHorn
- **Scope**: Client
- **Signature**: `void START_VEHICLE_HORN(Vehicle vehicle, int duration, Hash mode, BOOL forever);`
- **Purpose**: Sounds the vehicle horn for a duration.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `duration` (`int`): milliseconds.
  - `mode` (`Hash`): 0, `NORMAL`, or `HELDDOWN`.
  - `forever` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner triggers horn.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_horn
        -- Use: Honk for 2s
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_horn', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then StartVehicleHorn(veh, 2000, `NORMAL`, false) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_horn */
    RegisterCommand('veh_horn', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) StartVehicleHorn(veh, 2000, GetHashKey('NORMAL'), false);
    });
    ```
- **Caveats / Limitations**:
  - Players inside vehicle may override horn.
- **Reference**: https://docs.fivem.net/natives/?n=StartVehicleHorn

##### StopAllGarageActivity
- **Name**: StopAllGarageActivity
- **Scope**: Client
- **Signature**: `void STOP_ALL_GARAGE_ACTIVITY();`
- **Purpose**: Cancels all ongoing scripted garage operations.
- **Parameters / Returns**:
  - **Returns**: `void`
- **OneSync / Networking**: Not networked.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: garage_stop
        -- Use: Stop garage scenes
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('garage_stop', function()
        StopAllGarageActivity()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: garage_stop */
    RegisterCommand('garage_stop', () => {
      StopAllGarageActivity();
    });
    ```
- **Caveats / Limitations**:
  - Only affects scripted sequences using garage system.
- **Reference**: https://docs.fivem.net/natives/?n=StopAllGarageActivity

##### StopBringVehicleToHalt
- **Name**: StopBringVehicleToHalt
- **Scope**: Client
- **Signature**: `void _STOP_BRING_VEHICLE_TO_HALT(Vehicle vehicle);`
- **Purpose**: Aborts the engine-controlled halting task.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must cancel halt.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: halt_cancel
        -- Use: Cancel forced stopping
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('halt_cancel', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then StopBringVehicleToHalt(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: halt_cancel */
    RegisterCommand('halt_cancel', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) StopBringVehicleToHalt(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only cancels CTaskBringVehicleToHalt.
- **Reference**: https://docs.fivem.net/natives/?n=StopBringVehicleToHalt

##### StopPlaybackRecordedVehicle
- **Name**: StopPlaybackRecordedVehicle
- **Scope**: Client
- **Signature**: `void STOP_PLAYBACK_RECORDED_VEHICLE(Vehicle vehicle);`
- **Purpose**: Stops playback mode for a vehicle recording.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_stop
        -- Use: Stop current recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_stop', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then StopPlaybackRecordedVehicle(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_stop */
    RegisterCommand('playback_stop', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) StopPlaybackRecordedVehicle(veh);
    });
    ```
- **Caveats / Limitations**:
  - Vehicle remains in last playback state.
- **Reference**: https://docs.fivem.net/natives/?n=StopPlaybackRecordedVehicle

##### SwitchTrainTrack
- **Name**: SwitchTrainTrack
- **Scope**: Client
- **Signature**: `void SWITCH_TRAIN_TRACK(int trackId, BOOL state);`
- **Purpose**: Enables or disables ambient trains on a specific track.
- **Parameters / Returns**:
  - `trackId` (`int`): Track index.
  - `state` (`bool`): `true` allow trains.
  - **Returns**: `void`
- **OneSync / Networking**: Changes affect all clients when run on server.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: train_toggle
        -- Use: Toggle main train track
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('train_toggle', function(_, args)
        local on = args[1] == 'on'
        SwitchTrainTrack(0, on)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: train_toggle */
    RegisterCommand('train_toggle', (_src, args) => {
      const on = args[0] === 'on';
      SwitchTrainTrack(0, on);
    });
    ```
- **Caveats / Limitations**:
  - Only toggles spawning; existing trains persist.
- **Reference**: https://docs.fivem.net/natives/?n=SwitchTrainTrack

##### ToggleVehicleMod
- **Name**: ToggleVehicleMod
- **Scope**: Client
- **Signature**: `void TOGGLE_VEHICLE_MOD(Vehicle vehicle, int modType, BOOL toggle);`
- **Purpose**: Enables or disables a vehicle modification.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `modType` (`int`)
  - `toggle` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_turbo
        -- Use: Toggle turbo mod
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_turbo', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ToggleVehicleMod(veh, 18, true) end -- 18: turbo
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_turbo */
    RegisterCommand('veh_turbo', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) ToggleVehicleMod(veh, 18, true);
    });
    ```
- **Caveats / Limitations**:
  - Vehicle must support the mod.
- **Reference**: https://docs.fivem.net/natives/?n=ToggleVehicleMod

##### TrackVehicleVisibility
- **Name**: TrackVehicleVisibility
- **Scope**: Client
- **Signature**: `void TRACK_VEHICLE_VISIBILITY(Vehicle vehicle);`
- **Purpose**: Starts tracking if a vehicle becomes unseen for cleanup logic.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Local only; use with missions.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_track
        -- Use: Track current vehicle visibility
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_track', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then TrackVehicleVisibility(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_track */
    RegisterCommand('veh_track', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) TrackVehicleVisibility(veh);
    });
    ```
- **Caveats / Limitations**:
  - Requires external checks to act when hidden.
- **Reference**: https://docs.fivem.net/natives/?n=TrackVehicleVisibility

##### TransformToCar
- **Name**: TransformToCar
- **Scope**: Client
- **Signature**: `void TRANSFORM_TO_CAR(Vehicle vehicle, BOOL instantly);`
- **Purpose**: Converts the Stromberg into its land form.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `instantly` (`bool`): Skip animation.
  - **Returns**: `void`
- **OneSync / Networking**: Owner transforms entity.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: stromberg_car
        -- Use: Transform to car
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('stromberg_car', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then TransformToCar(veh, false) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stromberg_car */
    RegisterCommand('stromberg_car', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) TransformToCar(veh, false);
    });
    ```
- **Caveats / Limitations**:
  - Only works on Stromberg model.
- **Reference**: https://docs.fivem.net/natives/?n=TransformToCar

##### TransformToSubmarine
- **Name**: TransformToSubmarine
- **Scope**: Client
- **Signature**: `void TRANSFORM_TO_SUBMARINE(Vehicle vehicle, BOOL instantly);`
- **Purpose**: Switches the Stromberg into submarine mode.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `instantly` (`bool`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner must trigger.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: stromberg_sub
        -- Use: Transform to submarine
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('stromberg_sub', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then TransformToSubmarine(veh, false) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stromberg_sub */
    RegisterCommand('stromberg_sub', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) TransformToSubmarine(veh, false);
    });
    ```
- **Caveats / Limitations**:
  - Only works on Stromberg model.
- **Reference**: https://docs.fivem.net/natives/?n=TransformToSubmarine

##### UnpausePlaybackRecordedVehicle
- **Name**: UnpausePlaybackRecordedVehicle
- **Scope**: Client
- **Signature**: `void UNPAUSE_PLAYBACK_RECORDED_VEHICLE(Vehicle vehicle);`
- **Purpose**: Resumes a paused vehicle recording.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_resume
        -- Use: Resume vehicle recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_resume', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then UnpausePlaybackRecordedVehicle(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_resume */
    RegisterCommand('playback_resume', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) UnpausePlaybackRecordedVehicle(veh);
    });
    ```
- **Caveats / Limitations**:
  - Recording must have been paused previously.
- **Reference**: https://docs.fivem.net/natives/?n=UnpausePlaybackRecordedVehicle

CONTINUE-HERE — 2025-09-12T20:13:58.131329+00:00 — next: Vehicle :: AreAllVehicleWindowsIntact
