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
| Overall | 6442 | 259 | 6183 | 2025-09-12T22:43:32+00:00 |
| Vehicle | 751 | 259 | 492 | 2025-09-12T22:43:32+00:00 |

### 13.1 Taxonomy & Scope Notes
- Natives are grouped by high-level game systems (e.g., Vehicle, Player) and scope (Client or Server).
- Entries are sorted alphabetically within each category.

### 13.2 Client Natives by Category
#### Vehicle
##### AreAllVehicleWindowsIntact
- **Name**: AreAllVehicleWindowsIntact
- **Scope**: Client
- **Signature**: `BOOL ARE_ALL_VEHICLE_WINDOWS_INTACT(Vehicle vehicle);`
- **Purpose**: Checks if every window on a vehicle is undamaged.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Works on any streamed vehicle; ownership not required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: checkglass
        -- Use: Reports if the current vehicle has intact windows
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('checkglass', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and AreAllVehicleWindowsIntact(veh) then
            TriggerEvent('chat:addMessage', { args = { 'Windows undamaged' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: checkglass */
    RegisterCommand('checkglass', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && AreAllVehicleWindowsIntact(veh)) {
        emit('chat:addMessage', { args: ['Windows undamaged'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns true for vehicles without windows.
- **Reference**: https://docs.fivem.net/natives/?n=AreAllVehicleWindowsIntact

##### AreAnyVehicleSeatsFree
- **Name**: AreAnyVehicleSeatsFree
- **Scope**: Client
- **Signature**: `BOOL ARE_ANY_VEHICLE_SEATS_FREE(Vehicle vehicle);`
- **Purpose**: Determines if any seat in the vehicle is unoccupied.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Local check; streaming required for remote vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: seatcheck
        -- Use: Notify if a seat is free in current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('seatcheck', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and AreAnyVehicleSeatsFree(veh) then
            TriggerEvent('chat:addMessage', { args = { 'Seat available' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: seatcheck */
    RegisterCommand('seatcheck', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && AreAnyVehicleSeatsFree(veh)) {
        emit('chat:addMessage', { args: ['Seat available'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Does not identify which seat is free.
- **Reference**: https://docs.fivem.net/natives/?n=AreAnyVehicleSeatsFree

##### AreBombBayDoorsOpen
- **Name**: AreBombBayDoorsOpen
- **Scope**: Client
- **Signature**: `BOOL _ARE_BOMB_BAY_DOORS_OPEN(Vehicle aircraft);`
- **Purpose**: Checks whether an aircraft's bomb bay is currently open.
- **Parameters / Returns**:
  - `aircraft` (`Vehicle`): Plane to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: The aircraft must be streamed to the client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: bombbayclose
        -- Use: Close bomb bay if open
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('bombbayclose', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and AreBombBayDoorsOpen(veh) then
            CloseBombBayDoors(veh)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: bombbayclose */
    RegisterCommand('bombbayclose', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && AreBombBayDoorsOpen(veh)) {
        CloseBombBayDoors(veh);
      }
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for aircraft with bomb bay doors.
- **Reference**: https://docs.fivem.net/natives/?n=AreBombBayDoorsOpen

##### AreHeliStubWingsDeployed
- **Name**: AreHeliStubWingsDeployed
- **Scope**: Client
- **Signature**: `BOOL _ARE_HELI_STUB_WINGS_DEPLOYED(Vehicle vehicle);`
- **Purpose**: Indicates if a helicopter's stub wings are extended.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Helicopter handle.
  - **Returns**: `bool`.
- **OneSync / Networking**: Requires the heli to be owned or local for reliable results.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: stubwings
        -- Use: Report helicopter wing state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('stubwings', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local deployed = AreHeliStubWingsDeployed(veh)
            TriggerEvent('chat:addMessage', { args = { deployed and 'Wings out' or 'Wings retracted' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stubwings */
    RegisterCommand('stubwings', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const deployed = AreHeliStubWingsDeployed(veh);
        emit('chat:addMessage', { args: [deployed ? 'Wings out' : 'Wings retracted'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only applies to helicopters with deployable wings.
- **Reference**: https://docs.fivem.net/natives/?n=AreHeliStubWingsDeployed

##### AreOutriggerLegsDeployed
- **Name**: AreOutriggerLegsDeployed
- **Scope**: Client
- **Signature**: `BOOL _ARE_OUTRIGGER_LEGS_DEPLOYED(Vehicle vehicle);`
- **Purpose**: Checks if a vehicle's outrigger legs are deployed.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Local check; entity must be streamed in.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: outriggers
        -- Use: Announce outrigger state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('outriggers', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local state = AreOutriggerLegsDeployed(veh)
            TriggerEvent('chat:addMessage', { args = { state and 'Outriggers down' or 'Outriggers up' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: outriggers */
    RegisterCommand('outriggers', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const state = AreOutriggerLegsDeployed(veh);
        emit('chat:addMessage', { args: [state ? 'Outriggers down' : 'Outriggers up'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for vehicles equipped with outriggers.
- **Reference**: https://docs.fivem.net/natives/?n=AreOutriggerLegsDeployed

##### ArePlaneControlPanelsIntact
- **Name**: ArePlaneControlPanelsIntact
- **Scope**: Client
- **Signature**: `BOOL ARE_PLANE_CONTROL_PANELS_INTACT(Vehicle vehicle, BOOL checkForZeroHealth);`
- **Purpose**: Tests if the aircraft's control panels are undamaged.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Plane to inspect.
  - `checkForZeroHealth` (`bool`): Treat zero-health parts as damaged.
  - **Returns**: `bool`.
- **OneSync / Networking**: Only checks components known on the invoking client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: panelcheck
        -- Use: Verify plane control panels
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('panelcheck', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            if not ArePlaneControlPanelsIntact(veh, true) then
                TriggerEvent('chat:addMessage', { args = { 'Control panels damaged' } })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: panelcheck */
    RegisterCommand('panelcheck', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && !ArePlaneControlPanelsIntact(veh, true)) {
        emit('chat:addMessage', { args: ['Control panels damaged'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only valid for aircraft with control panels.
- **Reference**: https://docs.fivem.net/natives/?n=ArePlaneControlPanelsIntact

##### ArePlanePropellersIntact
- **Name**: ArePlanePropellersIntact
- **Scope**: Client
- **Signature**: `BOOL ARE_PLANE_PROPELLERS_INTACT(Vehicle plane);`
- **Purpose**: Determines whether all propellers are still attached.
- **Parameters / Returns**:
  - `plane` (`Vehicle`): Plane to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Requires client to own or stream the plane.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: propcheck
        -- Use: Check if plane propellers are intact
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('propcheck', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and not ArePlanePropellersIntact(veh) then
            TriggerEvent('chat:addMessage', { args = { 'Propeller damaged' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: propcheck */
    RegisterCommand('propcheck', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && !ArePlanePropellersIntact(veh)) {
        emit('chat:addMessage', { args: ['Propeller damaged'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only applies to propeller aircraft.
- **Reference**: https://docs.fivem.net/natives/?n=ArePlanePropellersIntact

##### ArePlaneWingsIntact
- **Name**: ArePlaneWingsIntact
- **Scope**: Client
- **Signature**: `BOOL _ARE_PLANE_WINGS_INTACT(Vehicle plane);`
- **Purpose**: Checks if both wings are still attached to the aircraft.
- **Parameters / Returns**:
  - `plane` (`Vehicle`): Plane to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Plane must be streamed to the client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: wingcheck
        -- Use: Report plane wing damage
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('wingcheck', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and not ArePlaneWingsIntact(veh) then
            TriggerEvent('chat:addMessage', { args = { 'Wing missing' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: wingcheck */
    RegisterCommand('wingcheck', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && !ArePlaneWingsIntact(veh)) {
        emit('chat:addMessage', { args: ['Wing missing'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Intended for aircraft only.
- **Reference**: https://docs.fivem.net/natives/?n=ArePlaneWingsIntact

##### AttachContainerToHandlerFrame
- **Name**: AttachContainerToHandlerFrame
- **Scope**: Client
- **Signature**: `void _ATTACH_CONTAINER_TO_HANDLER_FRAME(Vehicle handler, Entity container);`
- **Purpose**: Locks a freight container onto a handler vehicle frame.
- **Parameters / Returns**:
  - `handler` (`Vehicle`): Handler vehicle.
  - `container` (`Entity`): Container entity to attach.
  - **Returns**: `void`.
- **OneSync / Networking**: Both entities must be network-owned by the same client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: dock_attach
        -- Use: Attach targeted container to handler
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('dock_attach', function()
        local handler = GetVehiclePedIsIn(PlayerPedId(), false)
        local container = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if handler ~= 0 and container ~= 0 then
            AttachContainerToHandlerFrame(handler, container)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: dock_attach */
    RegisterCommand('dock_attach', () => {
      const handler = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, container] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (handler !== 0 && success) {
        AttachContainerToHandlerFrame(handler, container);
      }
    });
    ```
- **Caveats / Limitations**:
  - Container must match handler type.
- **Reference**: https://docs.fivem.net/natives/?n=AttachContainerToHandlerFrame

##### AttachEntityToCargobob
- **Name**: AttachEntityToCargobob
- **Scope**: Client
- **Signature**: `void ATTACH_ENTITY_TO_CARGOBOB(Vehicle vehicle, Entity entity, int p2, float x, float y, float z);`
- **Purpose**: Suspends an entity from a Cargobob using its hook.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Cargobob helicopter.
  - `entity` (`Entity`): Object or vehicle to attach.
  - `p2` (`int`): Attachment method flag.
  - `x` (`float`): Offset X.
  - `y` (`float`): Offset Y.
  - `z` (`float`): Offset Z.
  - **Returns**: `void`.
- **OneSync / Networking**: Both entities must be owned by the executing client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cargohook
        -- Use: Attach aimed vehicle to your Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('cargohook', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        local target = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if heli ~= 0 and target ~= 0 then
            AttachEntityToCargobob(heli, target, 0, 0.0, 0.0, -1.0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cargohook */
    RegisterCommand('cargohook', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, target] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (heli !== 0 && success) {
        AttachEntityToCargobob(heli, target, 0, 0.0, 0.0, -1.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Fails if hook is retracted.
- **Reference**: https://docs.fivem.net/natives/?n=AttachEntityToCargobob
##### AttachVehicleOnToTrailer
- **Name**: AttachVehicleOnToTrailer
- **Scope**: Client
- **Signature**: `void ATTACH_VEHICLE_ON_TO_TRAILER(Vehicle vehicle, Vehicle trailer, float offsetX, float offsetY, float offsetZ, float coordsX, float coordsY, float coordsZ, float rotationX, float rotationY, float rotationZ, float disableColls);`
- **Purpose**: Precisely places a vehicle onto a trailer with offsets and rotations.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to mount.
  - `trailer` (`Vehicle`): Target trailer.
  - `offsetX`, `offsetY`, `offsetZ` (`float`): Attachment offsets.
  - `coordsX`, `coordsY`, `coordsZ` (`float`): Trailer-relative coordinates.
  - `rotationX`, `rotationY`, `rotationZ` (`float`): Rotation applied on the trailer.
  - `disableColls` (`float`): Non-zero disables vehicle-trailer collision.
  - **Returns**: `void`.
- **OneSync / Networking**: Both vehicles must be controlled by the same client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: loadtrailer
        -- Use: Mount current vehicle onto aimed trailer
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('loadtrailer', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local trailer = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if veh ~= 0 and trailer ~= 0 then
            AttachVehicleOnToTrailer(veh, trailer, 0.0,0.0,0.0,0.0,0.0,0.5,0.0,0.0,0.0,0.0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: loadtrailer */
    RegisterCommand('loadtrailer', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, trailer] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (veh !== 0 && success) {
        AttachVehicleOnToTrailer(veh, trailer, 0.0,0.0,0.0,0.0,0.0,0.5,0.0,0.0,0.0,0.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Incorrect offsets may cause clipping.
- **Reference**: https://docs.fivem.net/natives/?n=AttachVehicleOnToTrailer

##### AttachVehicleToCargobob
- **Name**: AttachVehicleToCargobob
- **Scope**: Client
- **Signature**: `void ATTACH_VEHICLE_TO_CARGOBOB(Vehicle cargobob, Vehicle vehicle, int vehicleBoneIndex, float x, float y, float z);`
- **Purpose**: Hooks a vehicle onto a Cargobob.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Helicopter with hook.
  - `vehicle` (`Vehicle`): Vehicle to attach.
  - `vehicleBoneIndex` (`int`): Bone on vehicle to attach.
  - `x`, `y`, `z` (`float`): Offset relative to hook.
  - **Returns**: `void`.
- **OneSync / Networking**: Executing client must own both entities.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hookcar
        -- Use: Lift aimed vehicle with current Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('hookcar', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        local target = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if heli ~= 0 and target ~= 0 then
            AttachVehicleToCargobob(heli, target, 0, 0.0, 0.0, -1.0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hookcar */
    RegisterCommand('hookcar', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, target] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (heli !== 0 && success) {
        AttachVehicleToCargobob(heli, target, 0, 0.0, 0.0, -1.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Hook must be deployed and within range.
- **Reference**: https://docs.fivem.net/natives/?n=AttachVehicleToCargobob

##### AttachVehicleToTowTruck
- **Name**: AttachVehicleToTowTruck
- **Scope**: Client
- **Signature**: `void ATTACH_VEHICLE_TO_TOW_TRUCK(Vehicle towTruck, Vehicle vehicle, BOOL rear, float hookOffsetX, float hookOffsetY, float hookOffsetZ);`
- **Purpose**: Connects a vehicle to a tow truck.
- **Parameters / Returns**:
  - `towTruck` (`Vehicle`): Tow truck.
  - `vehicle` (`Vehicle`): Vehicle being towed.
  - `rear` (`bool`): Attach to rear of tow truck.
  - `hookOffsetX`, `hookOffsetY`, `hookOffsetZ` (`float`): Hook offsets.
  - **Returns**: `void`.
- **OneSync / Networking**: Both vehicles need the same network owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: towcar
        -- Use: Tow aimed vehicle with current truck
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('towcar', function()
        local truck = GetVehiclePedIsIn(PlayerPedId(), false)
        local target = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if truck ~= 0 and target ~= 0 then
            AttachVehicleToTowTruck(truck, target, false, 0.0, 0.0, 0.0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: towcar */
    RegisterCommand('towcar', () => {
      const truck = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, target] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (truck !== 0 && success) {
        AttachVehicleToTowTruck(truck, target, false, 0.0, 0.0, 0.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Tow arm must be extended.
- **Reference**: https://docs.fivem.net/natives/?n=AttachVehicleToTowTruck

##### AttachVehicleToTrailer
- **Name**: AttachVehicleToTrailer
- **Scope**: Client
- **Signature**: `void ATTACH_VEHICLE_TO_TRAILER(Vehicle vehicle, Vehicle trailer, float radius);`
- **Purpose**: Links a vehicle to a trailer using default attachment points.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to attach.
  - `trailer` (`Vehicle`): Trailer entity.
  - `radius` (`float`): Attachment tolerance radius.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires ownership of both entities.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hitch
        -- Use: Attach current vehicle to aimed trailer
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('hitch', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local trailer = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if veh ~= 0 and trailer ~= 0 then
            AttachVehicleToTrailer(veh, trailer, 5.0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hitch */
    RegisterCommand('hitch', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, trailer] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (veh !== 0 && success) {
        AttachVehicleToTrailer(veh, trailer, 5.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Trailer must support the vehicle type.
- **Reference**: https://docs.fivem.net/natives/?n=AttachVehicleToTrailer

##### BringVehicleToHalt
- **Name**: BringVehicleToHalt
- **Scope**: Client
- **Signature**: `void BRING_VEHICLE_TO_HALT(Vehicle vehicle, float distance, int duration, BOOL bControlVerticalVelocity);`
- **Purpose**: Gradually stops a vehicle within the given distance and duration.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to stop.
  - `distance` (`float`): Desired stopping distance.
  - `duration` (`int`): Time in milliseconds to brake.
  - `bControlVerticalVelocity` (`bool`): Control Z velocity for aircraft.
  - **Returns**: `void`.
- **OneSync / Networking**: Only effective if client has control of the vehicle.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: halt
        -- Use: Stop the current vehicle quickly
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('halt', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            BringVehicleToHalt(veh, 10.0, 3000, false)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: halt */
    RegisterCommand('halt', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        BringVehicleToHalt(veh, 10.0, 3000, false);
      }
    });
    ```
- **Caveats / Limitations**:
  - Sudden halt may look unnatural on remote clients.
- **Reference**: https://docs.fivem.net/natives/?n=BringVehicleToHalt

##### CanAnchorBoatHere
- **Name**: CanAnchorBoatHere
- **Scope**: Client
- **Signature**: `BOOL CAN_ANCHOR_BOAT_HERE(Vehicle boat);`
- **Purpose**: Checks if the water depth allows anchoring the boat.
- **Parameters / Returns**:
  - `boat` (`Vehicle`): Boat to test.
  - **Returns**: `bool`.
- **OneSync / Networking**: Requires local control to anchor.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: anchorcheck
        -- Use: Notify if current boat can anchor
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('anchorcheck', function()
        local boat = GetVehiclePedIsIn(PlayerPedId(), false)
        if boat ~= 0 and CanAnchorBoatHere(boat) then
            TriggerEvent('chat:addMessage', { args = { 'Safe to anchor' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: anchorcheck */
    RegisterCommand('anchorcheck', () => {
      const boat = GetVehiclePedIsIn(PlayerPedId(), false);
      if (boat !== 0 && CanAnchorBoatHere(boat)) {
        emit('chat:addMessage', { args: ['Safe to anchor'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Ignores proximity to other boats.
- **Reference**: https://docs.fivem.net/natives/?n=CanAnchorBoatHere

##### CanAnchorBoatHereIgnorePlayers
- **Name**: CanAnchorBoatHereIgnorePlayers
- **Scope**: Client
- **Signature**: `BOOL CAN_ANCHOR_BOAT_HERE_IGNORE_PLAYERS(Vehicle boat);`
- **Purpose**: Anchor check that ignores nearby players when evaluating space.
- **Parameters / Returns**:
  - `boat` (`Vehicle`): Boat to test.
  - **Returns**: `bool`.
- **OneSync / Networking**: Local check.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: anchorignore
        -- Use: Anchor check ignoring player collision
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('anchorignore', function()
        local boat = GetVehiclePedIsIn(PlayerPedId(), false)
        if boat ~= 0 and CanAnchorBoatHereIgnorePlayers(boat) then
            TriggerEvent('chat:addMessage', { args = { 'Anchor spot clear' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: anchorignore */
    RegisterCommand('anchorignore', () => {
      const boat = GetVehiclePedIsIn(PlayerPedId(), false);
      if (boat !== 0 && CanAnchorBoatHereIgnorePlayers(boat)) {
        emit('chat:addMessage', { args: ['Anchor spot clear'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Still blocked by world geometry.
- **Reference**: https://docs.fivem.net/natives/?n=CanAnchorBoatHereIgnorePlayers

##### CanCargobobPickUpEntity
- **Name**: CanCargobobPickUpEntity
- **Scope**: Client
- **Signature**: `BOOL CAN_CARGOBOB_PICK_UP_ENTITY(Vehicle cargobob, Entity entity);`
- **Purpose**: Tests if the Cargobob can pick up the specified entity.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Helicopter.
  - `entity` (`Entity`): Object or vehicle to pick up.
  - **Returns**: `bool`.
- **OneSync / Networking**: Both entities must be streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: canhook
        -- Use: Check if aimed entity can be hooked
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('canhook', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        local target = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if heli ~= 0 and target ~= 0 then
            local can = CanCargobobPickUpEntity(heli, target)
            TriggerEvent('chat:addMessage', { args = { can and 'Hookable' or 'Not hookable' } })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: canhook */
    RegisterCommand('canhook', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, target] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (heli !== 0 && success) {
        const can = CanCargobobPickUpEntity(heli, target);
        emit('chat:addMessage', { args: [can ? 'Hookable' : 'Not hookable'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Some entities are hardcoded as non-hookable.
- **Reference**: https://docs.fivem.net/natives/?n=CanCargobobPickUpEntity

##### CanShuffleSeat
- **Name**: CanShuffleSeat
- **Scope**: Client
- **Signature**: `BOOL CAN_SHUFFLE_SEAT(Vehicle vehicle, int seatIndex);`
- **Purpose**: Checks whether the player can move to a target seat.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle being checked.
  - `seatIndex` (`int`): Target seat index.
  - **Returns**: `bool`.
- **OneSync / Networking**: Seat occupancy must be up to date on the client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: shuffle
        -- Use: Attempt to shuffle to passenger seat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('shuffle', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and CanShuffleSeat(veh, 0) then
            SetPedIntoVehicle(PlayerPedId(), veh, 0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: shuffle */
    RegisterCommand('shuffle', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && CanShuffleSeat(veh, 0)) {
        SetPedIntoVehicle(PlayerPedId(), veh, 0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Seat indexes vary by vehicle type.
- **Reference**: https://docs.fivem.net/natives/?n=CanShuffleSeat

##### ClearLastDrivenVehicle
- **Name**: ClearLastDrivenVehicle
- **Scope**: Client
- **Signature**: `void CLEAR_LAST_DRIVEN_VEHICLE();`
- **Purpose**: Clears the script's stored reference to the last driven vehicle.
- **Parameters / Returns**:
  - **Returns**: `void`.
- **OneSync / Networking**: Client-side state only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: clearlast
        -- Use: Forget last driven vehicle for tasks
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('clearlast', function()
        ClearLastDrivenVehicle()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clearlast */
    RegisterCommand('clearlast', () => {
      ClearLastDrivenVehicle();
    });
    ```
- **Caveats / Limitations**:
  - Only affects scripts using the native.
- **Reference**: https://docs.fivem.net/natives/?n=ClearLastDrivenVehicle
##### ClearNitrous
- **Name**: ClearNitrous
- **Scope**: Client
- **Signature**: `void CLEAR_NITROUS(Vehicle vehicle);`
- **Purpose**: Resets nitrous levels on the specified vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to modify.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires network control of the vehicle.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: clearnos
        -- Use: Remove nitrous from current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('clearnos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ClearNitrous(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clearnos */
    RegisterCommand('clearnos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) ClearNitrous(veh);
    });
    ```
- **Caveats / Limitations**:
  - Affects only vehicles with nitrous components.
- **Reference**: https://docs.fivem.net/natives/?n=ClearNitrous

##### ClearVehicleCustomPrimaryColour
- **Name**: ClearVehicleCustomPrimaryColour
- **Scope**: Client | Server
- **Signature**: `void CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR(Vehicle vehicle);`
- **Purpose**: Removes custom primary paint from a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to modify.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires owner to replicate appearance.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: clearpri
        -- Use: Reset vehicle's primary color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('clearpri', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ClearVehicleCustomPrimaryColour(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clearpri */
    RegisterCommand('clearpri', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) ClearVehicleCustomPrimaryColour(veh);
    });
    ```
- **Caveats / Limitations**:
  - Color change may not replicate if vehicle not networked.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleCustomPrimaryColour

##### ClearVehicleCustomSecondaryColour
- **Name**: ClearVehicleCustomSecondaryColour
- **Scope**: Client | Server
- **Signature**: `void CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR(Vehicle vehicle);`
- **Purpose**: Removes custom secondary paint from a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to modify.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires network ownership for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: clearsec
        -- Use: Reset vehicle's secondary color
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('clearsec', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ClearVehicleCustomSecondaryColour(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clearsec */
    RegisterCommand('clearsec', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) ClearVehicleCustomSecondaryColour(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only affects vehicles with custom colors set.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleCustomSecondaryColour

##### ClearVehicleGeneratorAreaOfInterest
- **Name**: ClearVehicleGeneratorAreaOfInterest
- **Scope**: Client
- **Signature**: `void CLEAR_VEHICLE_GENERATOR_AREA_OF_INTEREST();`
- **Purpose**: Resets any vehicle generator area set with `SET_VEHICLE_GENERATOR_AREA_OF_INTEREST`.
- **Parameters / Returns**:
  - **Returns**: `void`.
- **OneSync / Networking**: Local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: clearvgaoi
        -- Use: Clear previously defined generator area
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('clearvgaoi', function()
        ClearVehicleGeneratorAreaOfInterest()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clearvgaoi */
    RegisterCommand('clearvgaoi', () => {
      ClearVehicleGeneratorAreaOfInterest();
    });
    ```
- **Caveats / Limitations**:
  - Only affects local generator operations.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleGeneratorAreaOfInterest

##### ClearVehiclePhoneExplosiveDevice
- **Name**: ClearVehiclePhoneExplosiveDevice
- **Scope**: Client
- **Signature**: `void _CLEAR_VEHICLE_PHONE_EXPLOSIVE_DEVICE();`
- **Purpose**: Removes a planted phone bomb from the player’s current vehicle.
- **Parameters / Returns**:
  - **Returns**: `void`.
- **OneSync / Networking**: Affects vehicle owned by executing client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: disarmbomb
        -- Use: Clear phone bomb from current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('disarmbomb', function()
        ClearVehiclePhoneExplosiveDevice()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: disarmbomb */
    RegisterCommand('disarmbomb', () => {
      ClearVehiclePhoneExplosiveDevice();
    });
    ```
- **Caveats / Limitations**:
  - Only works if a phone bomb was previously armed.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehiclePhoneExplosiveDevice

##### ClearVehicleRouteHistory
- **Name**: ClearVehicleRouteHistory
- **Scope**: Client
- **Signature**: `void CLEAR_VEHICLE_ROUTE_HISTORY(Vehicle vehicle);`
- **Purpose**: Clears recorded route data used by autopilot or trains.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to clear.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires vehicle control.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: clearroute
        -- Use: Reset route history for current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('clearroute', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ClearVehicleRouteHistory(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: clearroute */
    RegisterCommand('clearroute', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) ClearVehicleRouteHistory(veh);
    });
    ```
- **Caveats / Limitations**:
  - Applies to scripted routes only.
- **Reference**: https://docs.fivem.net/natives/?n=ClearVehicleRouteHistory

##### CloseBombBayDoors
- **Name**: CloseBombBayDoors
- **Scope**: Client
- **Signature**: `void CLOSE_BOMB_BAY_DOORS(Vehicle vehicle);`
- **Purpose**: Closes the bomb bay on supported aircraft.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft to modify.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires control of the aircraft.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: bombclose
        -- Use: Close bomb bay immediately
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('bombclose', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then CloseBombBayDoors(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: bombclose */
    RegisterCommand('bombclose', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) CloseBombBayDoors(veh);
    });
    ```
- **Caveats / Limitations**:
  - Ignored on aircraft without bomb bays.
- **Reference**: https://docs.fivem.net/natives/?n=CloseBombBayDoors

##### ControlLandingGear
- **Name**: ControlLandingGear
- **Scope**: Client
- **Signature**: `void CONTROL_LANDING_GEAR(Vehicle vehicle, int state);`
- **Purpose**: Sets aircraft landing gear state.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft.
  - `state` (`int`): Gear state (0–4).
  - **Returns**: `void`.
- **OneSync / Networking**: Requires network ownership for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: gear
        -- Use: Toggle landing gear
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('gear', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local state = GetLandingGearState(veh)
            ControlLandingGear(veh, state == 0 and 1 or 0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: gear */
    RegisterCommand('gear', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const state = GetLandingGearState(veh);
        ControlLandingGear(veh, state === 0 ? 1 : 0);
      }
    });
    ```
- **Caveats / Limitations**:
  - State values vary between aircraft.
- **Reference**: https://docs.fivem.net/natives/?n=ControlLandingGear

##### CopyVehicleDamages
- **Name**: CopyVehicleDamages
- **Scope**: Client
- **Signature**: `void COPY_VEHICLE_DAMAGES(Vehicle sourceVehicle, Vehicle targetVehicle);`
- **Purpose**: Transfers damage status from one vehicle to another.
- **Parameters / Returns**:
  - `sourceVehicle` (`Vehicle`): Vehicle to copy from.
  - `targetVehicle` (`Vehicle`): Vehicle to apply damage to.
  - **Returns**: `void`.
- **OneSync / Networking**: Both vehicles must be controlled by the same client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: copydamage
        -- Use: Apply current vehicle damage to aimed vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('copydamage', function()
        local src = GetVehiclePedIsIn(PlayerPedId(), false)
        local tgt = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if src ~= 0 and tgt ~= 0 then
            CopyVehicleDamages(src, tgt)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: copydamage */
    RegisterCommand('copydamage', () => {
      const src = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, tgt] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (src !== 0 && success) {
        CopyVehicleDamages(src, tgt);
      }
    });
    ```
- **Caveats / Limitations**:
  - Does not copy dirt levels.
- **Reference**: https://docs.fivem.net/natives/?n=CopyVehicleDamages

##### CreateMissionTrain
- **Name**: CreateMissionTrain
- **Scope**: Client | Server
- **Signature**: `Vehicle CREATE_MISSION_TRAIN(int variation, float x, float y, float z, BOOL direction);`
- **Purpose**: Spawns a train with a preset variation at coordinates.
- **Parameters / Returns**:
  - `variation` (`int`): Train preset ID.
  - `x`, `y`, `z` (`float`): Spawn coordinates.
  - `direction` (`bool`): Train direction.
  - **Returns**: `Vehicle` train handle.
- **OneSync / Networking**: On server, spawned train is networked automatically.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: spawntrain
        -- Use: Spawn a mission train ahead of player
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('spawntrain', function()
        local pos = GetEntityCoords(PlayerPedId())
        CreateMissionTrain(0, pos.x, pos.y + 50.0, pos.z, true)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: spawntrain */
    RegisterCommand('spawntrain', () => {
      const [x, y, z] = GetEntityCoords(PlayerPedId(), false);
      CreateMissionTrain(0, x, y + 50.0, z, true);
    });
    ```
- **Caveats / Limitations**:
  - Variations correspond to predefined consist layouts.
- **Reference**: https://docs.fivem.net/natives/?n=CreateMissionTrain
##### CreatePickUpRopeForCargobob
- **Name**: CreatePickUpRopeForCargobob
- **Scope**: Client
- **Signature**: `void CREATE_PICK_UP_ROPE_FOR_CARGOBOB(Vehicle cargobob, int state);`
- **Purpose**: Creates or retracts a pickup rope for the Cargobob.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Helicopter.
  - `state` (`int`): 0 deploy, 1 retract.
  - **Returns**: `void`.
- **OneSync / Networking**: Only affects Cargobobs owned by the client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: ropetoggle
        -- Use: Deploy pickup rope
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('ropetoggle', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        if heli ~= 0 then CreatePickUpRopeForCargobob(heli, 0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: ropetoggle */
    RegisterCommand('ropetoggle', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      if (heli !== 0) CreatePickUpRopeForCargobob(heli, 0);
    });
    ```
- **Caveats / Limitations**:
  - Only valid on Cargobobs with hook capability.
- **Reference**: https://docs.fivem.net/natives/?n=CreatePickUpRopeForCargobob

##### CreateScriptVehicleGenerator
- **Name**: CreateScriptVehicleGenerator
- **Scope**: Client | Server
- **Signature**: `int CREATE_SCRIPT_VEHICLE_GENERATOR(float x, float y, float z, float heading, float p4, float p5, Hash modelHash, int p7, int p8, int p9, int p10, BOOL p11, BOOL p12, BOOL p13, BOOL p14, BOOL p15, int p16);`
- **Purpose**: Creates a vehicle generator that spawns vehicles over time.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Generator position.
  - `heading` (`float`): Spawn heading.
  - `p4`, `p5` (`float`): Area dimensions.
  - `modelHash` (`Hash`): Vehicle model.
  - `p7`–`p10` (`int`): Unknown flags.
  - `p11`–`p15` (`bool`): Spawn conditions.
  - `p16` (`int`): Variations.
  - **Returns**: `int` generator ID.
- **OneSync / Networking**: Server generators spawn networked vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: creategen
        -- Use: Create a simple vehicle generator
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('creategen', function()
        local pos = GetEntityCoords(PlayerPedId())
        CreateScriptVehicleGenerator(pos.x, pos.y, pos.z, 0.0, 5.0, 3.0, `adder`,1,1,1,1,true,false,false,false,false,0)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: creategen */
    RegisterCommand('creategen', () => {
      const [x, y, z] = GetEntityCoords(PlayerPedId(), false);
      CreateScriptVehicleGenerator(x, y, z, 0.0, 5.0, 3.0, GetHashKey('adder'),1,1,1,1,true,false,false,false,false,0);
    });
    ```
- **Caveats / Limitations**:
  - Many parameters undocumented; adjust with caution.
- **Reference**: https://docs.fivem.net/natives/?n=CreateScriptVehicleGenerator

##### CreateVehicle
- **Name**: CreateVehicle
- **Scope**: Client | Server
- **Signature**: `Vehicle CREATE_VEHICLE(Hash modelHash, float x, float y, float z, float heading, BOOL isNetwork, BOOL netMissionEntity);`
- **Purpose**: Spawns a vehicle of the given model at specified coordinates.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Vehicle model.
  - `x`, `y`, `z` (`float`): Spawn position.
  - `heading` (`float`): Facing angle.
  - `isNetwork` (`bool`): Create as network object.
  - `netMissionEntity` (`bool`): Register as mission entity.
  - **Returns**: `Vehicle` handle.
- **OneSync / Networking**: Server-spawned networked vehicles replicate to clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: spawnadder
        -- Use: Spawn an Adder at player location
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('spawnadder', function()
        local pos = GetEntityCoords(PlayerPedId())
        CreateVehicle(`adder`, pos.x, pos.y, pos.z, GetEntityHeading(PlayerPedId()), true, false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: spawnadder */
    RegisterCommand('spawnadder', () => {
      const [x, y, z] = GetEntityCoords(PlayerPedId(), false);
      CreateVehicle(GetHashKey('adder'), x, y, z, GetEntityHeading(PlayerPedId()), true, false);
    });
    ```
- **Caveats / Limitations**:
  - Model must be loaded beforehand.
- **Reference**: https://docs.fivem.net/natives/?n=CreateVehicle

##### DeleteAllTrains
- **Name**: DeleteAllTrains
- **Scope**: Client | Server
- **Signature**: `void DELETE_ALL_TRAINS();`
- **Purpose**: Removes all train entities from the world.
- **Parameters / Returns**:
  - **Returns**: `void`.
- **OneSync / Networking**: Server call replicates to all clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cleartrains
        -- Use: Remove all trains from the world
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('cleartrains', function()
        DeleteAllTrains()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cleartrains */
    RegisterCommand('cleartrains', () => {
      DeleteAllTrains();
    });
    ```
- **Caveats / Limitations**:
  - Existing train handles become invalid.
- **Reference**: https://docs.fivem.net/natives/?n=DeleteAllTrains

##### DeleteMissionTrain
- **Name**: DeleteMissionTrain
- **Scope**: Client | Server
- **Signature**: `void DELETE_MISSION_TRAIN(Vehicle* train);`
- **Purpose**: Deletes a mission train created via `CreateMissionTrain`.
- **Parameters / Returns**:
  - `train` (`Vehicle`): Train handle to delete.
  - **Returns**: `void`.
- **OneSync / Networking**: Deletion syncs to all clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: deltrain
        -- Use: Delete the nearest mission train
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('deltrain', function()
        local train = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 50.0, 0, 8192)
        if train ~= 0 then DeleteMissionTrain(train) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: deltrain */
    RegisterCommand('deltrain', () => {
      const [x, y, z] = GetEntityCoords(PlayerPedId(), false);
      const train = GetClosestVehicle(x, y, z, 50.0, 0, 8192);
      if (train !== 0) DeleteMissionTrain(train);
    });
    ```
- **Caveats / Limitations**:
  - Train handle is invalidated after deletion.
- **Reference**: https://docs.fivem.net/natives/?n=DeleteMissionTrain

##### DeleteScriptVehicleGenerator
- **Name**: DeleteScriptVehicleGenerator
- **Scope**: Client | Server
- **Signature**: `void DELETE_SCRIPT_VEHICLE_GENERATOR(int vehicleGenerator);`
- **Purpose**: Removes a vehicle generator previously created.
- **Parameters / Returns**:
  - `vehicleGenerator` (`int`): Generator ID.
  - **Returns**: `void`.
- **OneSync / Networking**: Server side removal stops further spawns.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: delgen
        -- Use: Remove a stored generator
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    local lastGen
    RegisterCommand('creategen', function()
        local pos = GetEntityCoords(PlayerPedId())
        lastGen = CreateScriptVehicleGenerator(pos.x, pos.y, pos.z, 0.0, 5.0, 3.0, `blista`,1,1,1,1,true,false,false,false,false,0)
    end)
    RegisterCommand('delgen', function()
        if lastGen then DeleteScriptVehicleGenerator(lastGen) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: delgen */
    let lastGen;
    RegisterCommand('creategen', () => {
      const [x, y, z] = GetEntityCoords(PlayerPedId(), false);
      lastGen = CreateScriptVehicleGenerator(x, y, z, 0.0,5.0,3.0, GetHashKey('blista'),1,1,1,1,true,false,false,false,false,0);
    });
    RegisterCommand('delgen', () => {
      if (lastGen) DeleteScriptVehicleGenerator(lastGen);
    });
    ```
- **Caveats / Limitations**:
  - Existing spawned vehicles remain.
- **Reference**: https://docs.fivem.net/natives/?n=DeleteScriptVehicleGenerator

##### DeleteVehicle
- **Name**: DeleteVehicle
- **Scope**: Client | Server
- **Signature**: `void DELETE_VEHICLE(Vehicle* vehicle);`
- **Purpose**: Deletes a vehicle entity.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to remove.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires network ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: delveh
        -- Use: Delete vehicle player is in
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('delveh', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then DeleteVehicle(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: delveh */
    RegisterCommand('delveh', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) DeleteVehicle(veh);
    });
    ```
- **Caveats / Limitations**:
  - May leave players without a fallback vehicle.
- **Reference**: https://docs.fivem.net/natives/?n=DeleteVehicle

##### DetachContainerFromHandlerFrame
- **Name**: DetachContainerFromHandlerFrame
- **Scope**: Client
- **Signature**: `void DETACH_CONTAINER_FROM_HANDLER_FRAME(Vehicle vehicle);`
- **Purpose**: Releases a container from a handler vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Handler vehicle.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires ownership of handler.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: dock_detach
        -- Use: Detach container from handler
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('dock_detach', function()
        local handler = GetVehiclePedIsIn(PlayerPedId(), false)
        if handler ~= 0 then DetachContainerFromHandlerFrame(handler) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: dock_detach */
    RegisterCommand('dock_detach', () => {
      const handler = GetVehiclePedIsIn(PlayerPedId(), false);
      if (handler !== 0) DetachContainerFromHandlerFrame(handler);
    });
    ```
- **Caveats / Limitations**:
  - Container drops instantly; ensure safe position.
- **Reference**: https://docs.fivem.net/natives/?n=DetachContainerFromHandlerFrame

##### DetachEntityFromCargobob
- **Name**: DetachEntityFromCargobob
- **Scope**: Client
- **Signature**: `Any DETACH_ENTITY_FROM_CARGOBOB(Vehicle vehicle, Entity entity);`
- **Purpose**: Releases an entity from a Cargobob hook.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Cargobob.
  - `entity` (`Entity`): Attached entity.
  - **Returns**: `Any` (unused).
- **OneSync / Networking**: Requires control of both entities.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: unhook
        -- Use: Detach hooked entity
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('unhook', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        local target = GetEntityAttachedToEntity(heli)
        if heli ~= 0 and target ~= 0 then
            DetachEntityFromCargobob(heli, target)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: unhook */
    RegisterCommand('unhook', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      const target = GetEntityAttachedToEntity(heli);
      if (heli !== 0 && target !== 0) {
        DetachEntityFromCargobob(heli, target);
      }
    });
    ```
- **Caveats / Limitations**:
  - Return value unused.
- **Reference**: https://docs.fivem.net/natives/?n=DetachEntityFromCargobob

##### DetachVehicleFromAnyCargobob
- **Name**: DetachVehicleFromAnyCargobob
- **Scope**: Client
- **Signature**: `BOOL DETACH_VEHICLE_FROM_ANY_CARGOBOB(Vehicle vehicle);`
- **Purpose**: Detaches the vehicle from any Cargobob if hooked.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to release.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Vehicle must be network-controlled.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: unhookme
        -- Use: Detach current vehicle from any Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('unhookme', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then DetachVehicleFromAnyCargobob(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: unhookme */
    RegisterCommand('unhookme', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) DetachVehicleFromAnyCargobob(veh);
    });
    ```
- **Caveats / Limitations**:
  - Only affects vehicles currently attached.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromAnyCargobob
##### DetachVehicleFromAnyTowTruck
- **Name**: DetachVehicleFromAnyTowTruck
- **Scope**: Client
- **Signature**: `BOOL DETACH_VEHICLE_FROM_ANY_TOW_TRUCK(Vehicle vehicle);`
- **Purpose**: Releases the vehicle from any tow truck.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to release.
  - **Returns**: `bool` success.
- **OneSync / Networking**: Requires vehicle ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: untow
        -- Use: Detach current vehicle from tow trucks
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('untow', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then DetachVehicleFromAnyTowTruck(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: untow */
    RegisterCommand('untow', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) DetachVehicleFromAnyTowTruck(veh);
    });
    ```
- **Caveats / Limitations**:
  - Does nothing if not towed.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromAnyTowTruck

##### DetachVehicleFromCargobob
- **Name**: DetachVehicleFromCargobob
- **Scope**: Client
- **Signature**: `void DETACH_VEHICLE_FROM_CARGOBOB(Vehicle cargobob, Vehicle vehicle);`
- **Purpose**: Detaches a specific vehicle from a Cargobob.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Helicopter.
  - `vehicle` (`Vehicle`): Vehicle to release.
  - **Returns**: `void`.
- **OneSync / Networking**: Both entities must be owned locally.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: unhookcar
        -- Use: Detach targeted vehicle from Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('unhookcar', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        local target = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if heli ~= 0 and target ~= 0 then
            DetachVehicleFromCargobob(heli, target)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: unhookcar */
    RegisterCommand('unhookcar', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, target] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (heli !== 0 && success) {
        DetachVehicleFromCargobob(heli, target);
      }
    });
    ```
- **Caveats / Limitations**:
  - No effect if vehicle not attached to given Cargobob.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromCargobob

##### DetachVehicleFromTowTruck
- **Name**: DetachVehicleFromTowTruck
- **Scope**: Client
- **Signature**: `void DETACH_VEHICLE_FROM_TOW_TRUCK(Vehicle towTruck, Vehicle vehicle);`
- **Purpose**: Detaches a vehicle from a specific tow truck.
- **Parameters / Returns**:
  - `towTruck` (`Vehicle`): Tow truck.
  - `vehicle` (`Vehicle`): Vehicle to release.
  - **Returns**: `void`.
- **OneSync / Networking**: Same owner required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: untowcar
        -- Use: Release aimed vehicle from tow truck
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('untowcar', function()
        local truck = GetVehiclePedIsIn(PlayerPedId(), false)
        local target = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if truck ~= 0 and target ~= 0 then
            DetachVehicleFromTowTruck(truck, target)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: untowcar */
    RegisterCommand('untowcar', () => {
      const truck = GetVehiclePedIsIn(PlayerPedId(), false);
      const [success, target] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (truck !== 0 && success) {
        DetachVehicleFromTowTruck(truck, target);
      }
    });
    ```
- **Caveats / Limitations**:
  - Tow winch must be active.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromTowTruck

##### DetachVehicleFromTrailer
- **Name**: DetachVehicleFromTrailer
- **Scope**: Client
- **Signature**: `void DETACH_VEHICLE_FROM_TRAILER(Vehicle vehicle);`
- **Purpose**: Unhitches a vehicle from its trailer.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to detach.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires control of vehicle.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: unhitch
        -- Use: Detach current vehicle from trailer
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('unhitch', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then DetachVehicleFromTrailer(veh) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: unhitch */
    RegisterCommand('unhitch', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) DetachVehicleFromTrailer(veh);
    });
    ```
- **Caveats / Limitations**:
  - Trailer remains in place.
- **Reference**: https://docs.fivem.net/natives/?n=DetachVehicleFromTrailer

##### DetonateVehiclePhoneExplosiveDevice
- **Name**: DetonateVehiclePhoneExplosiveDevice
- **Scope**: Client
- **Signature**: `void DETONATE_VEHICLE_PHONE_EXPLOSIVE_DEVICE();`
- **Purpose**: Triggers the phone bomb on the player's current vehicle.
- **Parameters / Returns**:
  - **Returns**: `void`.
- **OneSync / Networking**: Requires vehicle ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: detonate
        -- Use: Detonate phone bomb on current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('detonate', function()
        DetonateVehiclePhoneExplosiveDevice()
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: detonate */
    RegisterCommand('detonate', () => {
      DetonateVehiclePhoneExplosiveDevice();
    });
    ```
- **Caveats / Limitations**:
  - Fails if no bomb is armed.
- **Reference**: https://docs.fivem.net/natives/?n=DetonateVehiclePhoneExplosiveDevice

##### DisableIndividualPlanePropeller
- **Name**: DisableIndividualPlanePropeller
- **Scope**: Client
- **Signature**: `void DISABLE_INDIVIDUAL_PLANE_PROPELLER(Vehicle vehicle, int propeller);`
- **Purpose**: Disables a specific propeller on a plane.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Plane.
  - `propeller` (`int`): Propeller index.
  - **Returns**: `void`.
- **OneSync / Networking**: Must own the aircraft.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: killprop
        -- Use: Disable propeller 0
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('killprop', function()
        local plane = GetVehiclePedIsIn(PlayerPedId(), false)
        if plane ~= 0 then DisableIndividualPlanePropeller(plane, 0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: killprop */
    RegisterCommand('killprop', () => {
      const plane = GetVehiclePedIsIn(PlayerPedId(), false);
      if (plane !== 0) DisableIndividualPlanePropeller(plane, 0);
    });
    ```
- **Caveats / Limitations**:
  - Index varies with aircraft model.
- **Reference**: https://docs.fivem.net/natives/?n=DisableIndividualPlanePropeller

##### DisablePlaneAileron
- **Name**: DisablePlaneAileron
- **Scope**: Client
- **Signature**: `void DISABLE_PLANE_AILERON(Vehicle vehicle, BOOL p1, BOOL p2);`
- **Purpose**: Temporarily disables a plane's aileron control.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Plane.
  - `p1` (`bool`): Left aileron.
  - `p2` (`bool`): Right aileron.
  - **Returns**: `void`.
- **OneSync / Networking**: Ownership required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: disableail
        -- Use: Disable left aileron
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('disableail', function()
        local plane = GetVehiclePedIsIn(PlayerPedId(), false)
        if plane ~= 0 then DisablePlaneAileron(plane, true, false) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: disableail */
    RegisterCommand('disableail', () => {
      const plane = GetVehiclePedIsIn(PlayerPedId(), false);
      if (plane !== 0) DisablePlaneAileron(plane, true, false);
    });
    ```
- **Caveats / Limitations**:
  - Use sparingly; affects handling.
- **Reference**: https://docs.fivem.net/natives/?n=DisablePlaneAileron

##### DisableVehicleNeonLights
- **Name**: DisableVehicleNeonLights
- **Scope**: Client
- **Signature**: `void _DISABLE_VEHICLE_NEON_LIGHTS(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Enables or disables neon light effects globally on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to modify.
  - `toggle` (`bool`): Disable when true.
  - **Returns**: `void`.
- **OneSync / Networking**: Requires ownership for replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: neoff
        -- Use: Disable neon lights on current car
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('neoff', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then DisableVehicleNeonLights(veh, true) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: neoff */
    RegisterCommand('neoff', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) DisableVehicleNeonLights(veh, true);
    });
    ```
- **Caveats / Limitations**:
  - Individual neon tubes cannot be toggled with this native.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleNeonLights

##### DisableVehicleTurretMovementThisFrame
- **Name**: DisableVehicleTurretMovementThisFrame
- **Scope**: Client
- **Signature**: `void _DISABLE_VEHICLE_TURRET_MOVEMENT_THIS_FRAME(Vehicle vehicle);`
- **Purpose**: Freezes vehicle turret rotation for the current frame.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with turret.
  - **Returns**: `void`.
- **OneSync / Networking**: Call each frame on controlling client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Thread
        -- Name: lockturret
        -- Use: Continuously lock current vehicle turret
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    CreateThread(function()
        while true do
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh ~= 0 then DisableVehicleTurretMovementThisFrame(veh) end
            Wait(0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Thread: lockturret */
    setTick(() => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) DisableVehicleTurretMovementThisFrame(veh);
    });
    ```
- **Caveats / Limitations**:
  - Must be called every frame to maintain lock.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleTurretMovementThisFrame

##### DisableVehicleWeapon
- **Name**: DisableVehicleWeapon
- **Scope**: Client
- **Signature**: `void DISABLE_VEHICLE_WEAPON(BOOL disabled, Hash weaponHash, Vehicle vehicle, Ped owner);`
- **Purpose**: Disables a specific mounted weapon on the given vehicle.
- **Parameters / Returns**:
  - `disabled` (`bool`): True to disable.
  - `weaponHash` (`Hash`): Weapon identifier.
  - `vehicle` (`Vehicle`): Vehicle containing the weapon.
  - `owner` (`Ped`): Ped controlling the weapon.
  - **Returns**: `void`.
- **OneSync / Networking**: Client must control the vehicle to enforce disable.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: disablegun
        -- Use: Disable mounted vehicle weapon
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('disablegun', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            DisableVehicleWeapon(true, `VEHICLE_WEAPON_ENEMY_LASER`, veh, PlayerPedId())
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: disablegun */
    RegisterCommand('disablegun', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        DisableVehicleWeapon(true, GetHashKey('VEHICLE_WEAPON_ENEMY_LASER'), veh, PlayerPedId());
      }
    });
    ```
- **Caveats / Limitations**:
  - Weapon hash must exist on the vehicle model.
- **Reference**: https://docs.fivem.net/natives/?n=DisableVehicleWeapon
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

##### DisableVehicleWorldCollision
- **Name**: _DISABLE_VEHICLE_WORLD_COLLISION (0x75627043C6AA90AD)
- **Scope**: Client
- **Signature**: `void _DISABLE_VEHICLE_WORLD_COLLISION(Vehicle vehicle);`
- **Purpose**: Temporarily disables collisions between a vehicle and static world geometry.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle whose world collisions will be disabled.
- **OneSync / Networking**: Requires entity control; other clients see the vehicle passing through mapped world objects but still collide with dynamic entities.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_nocol
        -- Use: Lets the player drive through buildings with their current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_nocol', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            DisableVehicleWorldCollision(veh)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_nocol */
    RegisterCommand('veh_nocol', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        DisableVehicleWorldCollision(veh);
      }
    });
    ```
- **Caveats / Limitations**:
  - No native to re-enable collision; recreate vehicle to reset.
- **Reference**: https://docs.fivem.net/natives/?n=_DISABLE_VEHICLE_WORLD_COLLISION

##### DoesCargobobHavePickUpRope
- **Name**: DOES_CARGOBOB_HAVE_PICK_UP_ROPE (0x1821D91AD4B56108)
- **Scope**: Client
- **Signature**: `BOOL DOES_CARGOBOB_HAVE_PICK_UP_ROPE(Vehicle cargobob);`
- **Purpose**: Checks if a Cargobob helicopter currently has its hook deployed.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Target Cargobob.
  - **Returns**: `bool` indicating whether the hook is active.
- **OneSync / Networking**: Only reliable for streamed Cargobobs.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rope_status
        -- Use: Reports if a nearby Cargobob has its pick-up rope deployed
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rope_status', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesCargobobHavePickUpRope(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Hook ready.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rope_status */
    RegisterCommand('rope_status', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesCargobobHavePickUpRope(veh)) {
        emit('chat:addMessage', { args: ['System', 'Hook ready.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns false when the magnet attachment is active.
- **Reference**: https://docs.fivem.net/natives/?n=DoesCargobobHavePickUpRope

##### DoesCargobobHavePickupMagnet
- **Name**: DOES_CARGOBOB_HAVE_PICKUP_MAGNET (0x6E08BF5B3722BAC9)
- **Scope**: Client
- **Signature**: `BOOL DOES_CARGOBOB_HAVE_PICKUP_MAGNET(Vehicle cargobob);`
- **Purpose**: Determines if a Cargobob has its magnet deployed for pickups.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Target helicopter.
  - **Returns**: `bool` indicating magnet availability.
- **OneSync / Networking**: Streamed Cargobob ownership needed for accurate state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: magnet_status
        -- Use: Sends chat notice when the player's Cargobob magnet is active
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('magnet_status', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesCargobobHavePickupMagnet(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Magnet active.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: magnet_status */
    RegisterCommand('magnet_status', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesCargobobHavePickupMagnet(veh)) {
        emit('chat:addMessage', { args: ['System', 'Magnet active.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns false when the hook is deployed instead.
- **Reference**: https://docs.fivem.net/natives/?n=DoesCargobobHavePickupMagnet

##### DoesExtraExist
- **Name**: DOES_EXTRA_EXIST (0x1262D55792428154)
- **Scope**: Client
- **Signature**: `BOOL DOES_EXTRA_EXIST(Vehicle vehicle, int extraId);`
- **Purpose**: Tests whether a given extra component is available on a vehicle model.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `extraId` (`number`): Extra index to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Extras change only appear to others when the vehicle is network-owned.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: has_extra
        -- Use: Informs the player if extra 1 exists on the current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('has_extra', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesExtraExist(veh, 1) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Extra 1 available.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: has_extra */
    RegisterCommand('has_extra', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesExtraExist(veh, 1)) {
        emit('chat:addMessage', { args: ['System', 'Extra 1 available.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only checks model capability; does not indicate if extra is enabled.
- **Reference**: https://docs.fivem.net/natives/?n=DoesExtraExist

##### DoesScriptVehicleGeneratorExist
- **Name**: DOES_SCRIPT_VEHICLE_GENERATOR_EXIST (0xF6086BC836400876)
- **Scope**: Client
- **Signature**: `BOOL DOES_SCRIPT_VEHICLE_GENERATOR_EXIST(int vehicleGenerator);`
- **Purpose**: Verifies if a script-created vehicle generator still exists.
- **Parameters / Returns**:
  - `vehicleGenerator` (`number`): Handle returned by `CreateScriptVehicleGenerator`.
  - **Returns**: `bool`.
- **OneSync / Networking**: Generator presence is local; use server coordination to spawn shared vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: check_generator
        -- Use: Confirms whether a stored generator handle is valid
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    local gen
    RegisterCommand('spawn_gen', function()
        gen = CreateScriptVehicleGenerator(0.0, 0.0, 72.0, 0.0, 0.0, 0.0, GetHashKey('adder'), 1, 1, 1, 1, 0, 0, 0, 0, 0)
    end)
    RegisterCommand('check_generator', function()
        if gen and DoesScriptVehicleGeneratorExist(gen) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Generator active.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: spawn_gen & check_generator */
    let gen;
    RegisterCommand('spawn_gen', () => {
      gen = CreateScriptVehicleGenerator(0.0, 0.0, 72.0, 0.0, 0.0, 0.0, GetHashKey('adder'), 1, 1, 1, 1, 0, 0, 0, 0, 0);
    });
    RegisterCommand('check_generator', () => {
      if (gen && DoesScriptVehicleGeneratorExist(gen)) {
        emit('chat:addMessage', { args: ['System', 'Generator active.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Local generators do not automatically synchronize across clients.
- **Reference**: https://docs.fivem.net/natives/?n=DoesScriptVehicleGeneratorExist

##### DoesVehicleAllowRappel
- **Name**: _DOES_VEHICLE_ALLOW_RAPPEL (0x4E417C547182C84D)
- **Scope**: Client
- **Signature**: `BOOL _DOES_VEHICLE_ALLOW_RAPPEL(Vehicle vehicle);`
- **Purpose**: Checks if a vehicle model permits rappelling.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to test.
  - **Returns**: `bool`.
- **OneSync / Networking**: Only meaningful for helicopters streamed to the client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rappel_check
        -- Use: Alerts the player when the current helicopter supports rappelling
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rappel_check', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesVehicleAllowRappel(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Rappelling allowed.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rappel_check */
    RegisterCommand('rappel_check', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesVehicleAllowRappel(veh)) {
        emit('chat:addMessage', { args: ['System', 'Rappelling allowed.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only true for models flagged with `FLAG_ALLOWS_RAPPEL`.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleAllowRappel

##### DoesVehicleExistWithDecorator
- **Name**: DOES_VEHICLE_EXIST_WITH_DECORATOR (0x956B409B984D9BF7)
- **Scope**: Client
- **Signature**: `BOOL DOES_VEHICLE_EXIST_WITH_DECORATOR(char* decorator);`
- **Purpose**: Searches for any vehicle in the world tagged with the given decorator.
- **Parameters / Returns**:
  - `decorator` (`string`): Decorator key to search for.
  - **Returns**: `bool`.
- **OneSync / Networking**: Only detects vehicles within streaming range.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: find_decor
        -- Use: Checks if any streamed vehicle has the decorator "missionCar"
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('find_decor', function()
        if DoesVehicleExistWithDecorator('missionCar') then
            TriggerEvent('chat:addMessage', {args = {'System', 'Mission car nearby.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: find_decor */
    RegisterCommand('find_decor', () => {
      if (DoesVehicleExistWithDecorator('missionCar')) {
        emit('chat:addMessage', { args: ['System', 'Mission car nearby.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires decorator to be registered and applied beforehand.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleExistWithDecorator

##### DoesVehicleHaveLandingGear
- **Name**: _DOES_VEHICLE_HAVE_LANDING_GEAR (0xE43701C36CAFF1A4)
- **Scope**: Client
- **Signature**: `BOOL _DOES_VEHICLE_HAVE_LANDING_GEAR(Vehicle vehicle);`
- **Purpose**: Detects if an aircraft model features landing gear.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Requires ownership for accurate gear state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: gear_check
        -- Use: Notifies the player if the current aircraft has landing gear
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('gear_check', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesVehicleHaveLandingGear(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Landing gear installed.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: gear_check */
    RegisterCommand('gear_check', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesVehicleHaveLandingGear(veh)) {
        emit('chat:addMessage', { args: ['System', 'Landing gear installed.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns false for aircraft with fixed gear.
- **Reference**: https://docs.fivem.net/natives/?n=_DOES_VEHICLE_HAVE_LANDING_GEAR

##### DoesVehicleHaveRoof
- **Name**: DOES_VEHICLE_HAVE_ROOF (0x8AC862B0B32C5B80)
- **Scope**: Client
- **Signature**: `BOOL DOES_VEHICLE_HAVE_ROOF(Vehicle vehicle);`
- **Purpose**: Indicates if a vehicle model includes a roof.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - **Returns**: `bool`.
- **OneSync / Networking**: Works on streamed vehicles; model-based.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: check_roof
        -- Use: Displays a chat message if the current vehicle has a roof
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('check_roof', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesVehicleHaveRoof(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Roof present.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: check_roof */
    RegisterCommand('check_roof', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesVehicleHaveRoof(veh)) {
        emit('chat:addMessage', { args: ['System', 'Roof present.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Convertible vehicles report true even with the roof down.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveRoof

##### DoesVehicleHaveSearchlight
- **Name**: DOES_VEHICLE_HAVE_SEARCHLIGHT (0x99015ED7DBEA5113)
- **Scope**: Client
- **Signature**: `BOOL DOES_VEHICLE_HAVE_SEARCHLIGHT(Vehicle vehicle);`
- **Purpose**: Determines if a vehicle supports an operable searchlight.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Use network ownership for toggling the searchlight.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: searchlight_check
        -- Use: Alerts the player if their vehicle has a searchlight
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('searchlight_check', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesVehicleHaveSearchlight(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Searchlight equipped.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: searchlight_check */
    RegisterCommand('searchlight_check', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesVehicleHaveSearchlight(veh)) {
        emit('chat:addMessage', { args: ['System', 'Searchlight equipped.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only applicable to helicopters with built-in searchlights.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveSearchlight

##### DoesVehicleHaveStuckVehicleCheck
- **Name**: DoesVehicleHaveStuckVehicleCheck
- **Scope**: Client
- **Signature**: `BOOL DOES_VEHICLE_HAVE_STUCK_VEHICLE_CHECK(Vehicle vehicle);`
- **Purpose**: Detects if a vehicle currently has a stuck check task active.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - **Returns**: `bool`.
- **OneSync / Networking**: Local query; the vehicle must be streamed to inspect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: stuck_check
        -- Use: Adds a warp check to free a wedged vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('stuck_check', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and not DoesVehicleHaveStuckVehicleCheck(veh) then
            -- allow the game to warp the vehicle if it becomes immobile
            AddVehicleStuckCheckWithWarp(veh, 0.2, 1000, false, false, false, 0)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: stuck_check */
    RegisterCommand('stuck_check', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && !DoesVehicleHaveStuckVehicleCheck(veh)) {
        // enable automatic warp if the vehicle gets stuck
        AddVehicleStuckCheckWithWarp(veh, 0.2, 1000, false, false, false, 0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Only 16 vehicles can have stuck checks simultaneously.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveStuckVehicleCheck

##### DoesVehicleHaveWeapons
- **Name**: DoesVehicleHaveWeapons
- **Scope**: Client
- **Signature**: `BOOL DOES_VEHICLE_HAVE_WEAPONS(Vehicle vehicle);`
- **Purpose**: Determines if a vehicle model is equipped with built-in weapons.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Query any streamed vehicle; weapon use requires ownership.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_weapons
        -- Use: Notifies if the current vehicle carries weapons
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_weapons', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and DoesVehicleHaveWeapons(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Weapons installed.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_weapons */
    RegisterCommand('veh_weapons', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesVehicleHaveWeapons(veh)) {
        emit('chat:addMessage', { args: ['System', 'Weapons installed.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Applies to armed vehicles such as the Lazer or weaponized quads.
- **Reference**: https://docs.fivem.net/natives/?n=DoesVehicleHaveWeapons

##### _DOES_VEHICLE_TYRE_EXIST (0x534E36D4DB9ECC5D)
- **Name**: _DOES_VEHICLE_TYRE_EXIST (0x534E36D4DB9ECC5D)
- **Scope**: Client
- **Signature**: `BOOL _DOES_VEHICLE_TYRE_EXIST(Vehicle vehicle, int tyreIndex);`
- **Purpose**: Checks whether a tyre exists at a given wheel index.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `tyreIndex` (`int`): Wheel slot (0–5 typical).
  - **Returns**: `bool`.
- **OneSync / Networking**: Use on streamed vehicles; ownership needed to modify tyres.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tyre_exists
        -- Use: Reports if a tyre slot is present
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tyre_exists', function(src, args)
        local idx = tonumber(args[1]) or 0
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and _DoesVehicleTyreExist(veh, idx) then
            TriggerEvent('chat:addMessage', {args = {'System', ('Tyre %d present'):format(idx)}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tyre_exists */
    RegisterCommand('tyre_exists', (src, args) => {
      const idx = parseInt(args[0]) || 0;
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && DoesVehicleTyreExist(veh, idx)) {
        emit('chat:addMessage', { args: ['System', `Tyre ${idx} present`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns false if the tyre was removed or the index is invalid.
- **Reference**: https://docs.fivem.net/natives/?n=_DOES_VEHICLE_TYRE_EXIST

##### _EJECT_JB700_ROOF (0xE38CB9D7D39FDBCC)
- **Name**: _EJECT_JB700_ROOF (0xE38CB9D7D39FDBCC)
- **Scope**: Client
- **Signature**: `void _EJECT_JB700_ROOF(Vehicle vehicle, float x, float y, float z);`
- **Purpose**: Detaches the JB700's roof with an impulse vector.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `x`, `y`, `z` (`float`): Impulse direction.
  - **Returns**: `void`
- **OneSync / Networking**: Only affects the vehicle owner for proper sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: eject_roof
        -- Use: Blasts off the JB700 roof forward
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('eject_roof', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then _EjectJb700Roof(veh, 0.0, 5.0, 1.0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: eject_roof */
    RegisterCommand('eject_roof', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        EjectJb700Roof(veh, 0.0, 5.0, 1.0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Only vehicles of model JB700 support this feature.
- **Reference**: https://docs.fivem.net/natives/?n=_EJECT_JB700_ROOF

##### _ENABLE_INDIVIDUAL_PLANE_PROPELLER (0xDC05D2777F855F44)
- **Name**: _ENABLE_INDIVIDUAL_PLANE_PROPELLER (0xDC05D2777F855F44)
- **Scope**: Client
- **Signature**: `void _ENABLE_INDIVIDUAL_PLANE_PROPELLER(Vehicle plane, int propeller);`
- **Purpose**: Starts a specific propeller on a prop-driven aircraft.
- **Parameters / Returns**:
  - `plane` (`Vehicle`): Propeller plane.
  - `propeller` (`int`): Index of prop to enable.
  - **Returns**: `void`
- **OneSync / Networking**: Call on aircraft owner to sync prop state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: prop_enable
        -- Use: Re-enables a plane's first propeller
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('prop_enable', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then _EnableIndividualPlanePropeller(veh, 0) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: prop_enable */
    RegisterCommand('prop_enable', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        EnableIndividualPlanePropeller(veh, 0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Use after disabling a prop via `_DISABLE_INDIVIDUAL_PLANE_PROPELLER`.
- **Reference**: https://docs.fivem.net/natives/?n=_ENABLE_INDIVIDUAL_PLANE_PROPELLER

##### ExplodeVehicle
- **Name**: ExplodeVehicle
- **Scope**: Client
- **Signature**: `void EXPLODE_VEHICLE(Vehicle vehicle, BOOL isAudible, BOOL isInvisible);`
- **Purpose**: Detonates a vehicle with optional sound and visual effects.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `isAudible` (`bool`): Play explosion sound.
  - `isInvisible` (`bool`): Hide explosion visuals.
  - **Returns**: `void`
- **OneSync / Networking**: Only the network owner can trigger a synced explosion.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom
        -- Use: Destroys the nearest vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ExplodeVehicle(veh, true, false) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom */
    RegisterCommand('boom', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        ExplodeVehicle(veh, true, false);
      }
    });
    ```
- **Caveats / Limitations**:
  - Invisible explosions still damage nearby entities.
- **Reference**: https://docs.fivem.net/natives/?n=ExplodeVehicle

##### ExplodeVehicleInCutscene
- **Name**: ExplodeVehicleInCutscene
- **Scope**: Client
- **Signature**: `void EXPLODE_VEHICLE_IN_CUTSCENE(Vehicle vehicle, BOOL p1);`
- **Purpose**: Instantly destroys a vehicle during scripted sequences.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `p1` (`bool`): Unknown flag.
  - **Returns**: `void`
- **OneSync / Networking**: Use only on mission vehicles you control.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_cs
        -- Use: Explodes current vehicle without normal FX
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_cs', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ExplodeVehicleInCutscene(veh, true) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_cs */
    RegisterCommand('boom_cs', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        ExplodeVehicleInCutscene(veh, true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Intended for cutscenes; physics may behave oddly in freeplay.
- **Reference**: https://docs.fivem.net/natives/?n=ExplodeVehicleInCutscene

##### _FIND_RANDOM_POINT_IN_SPACE (0x8DC9675797123522)
- **Name**: _FIND_RANDOM_POINT_IN_SPACE (0x8DC9675797123522)
- **Scope**: Client
- **Signature**: `Vector3 _FIND_RANDOM_POINT_IN_SPACE(Ped ped);`
- **Purpose**: Calculates a distant random position relative to a ped.
- **Parameters / Returns**:
  - `ped` (`Ped`)
  - **Returns**: `Vector3` position.
- **OneSync / Networking**: Result is local only; moving entities requires server validation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: random_space
        -- Use: Draws a marker at a far random point
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('random_space', function()
        local ped = PlayerPedId()
        local pos = _FindRandomPointInSpace(ped)
        DrawMarker(1, pos.x, pos.y, pos.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.0,1.0,1.0, 0,255,0,150, false,true,2,nil,nil,false)
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: random_space */
    RegisterCommand('random_space', () => {
      const ped = PlayerPedId();
      const pos = FindRandomPointInSpace(ped);
      DrawMarker(1, pos.x, pos.y, pos.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.0,1.0,1.0, 0,255,0,150, false, true, 2, undefined, undefined, false);
    });
    ```
- **Caveats / Limitations**:
  - Often returns positions high above ground; validate before teleporting.
- **Reference**: https://docs.fivem.net/natives/?n=_FIND_RANDOM_POINT_IN_SPACE

##### _FIND_VEHICLE_CARRYING_THIS_ENTITY (0x375E7FC44F21C8AB)
- **Name**: _FIND_VEHICLE_CARRYING_THIS_ENTITY (0x375E7FC44F21C8AB)
- **Scope**: Client
- **Signature**: `Vehicle _FIND_VEHICLE_CARRYING_THIS_ENTITY(Entity entity);`
- **Purpose**: Returns the handler-frame vehicle transporting a container entity.
- **Parameters / Returns**:
  - `entity` (`Entity`)
  - **Returns**: `Vehicle` or `0` if none.
- **OneSync / Networking**: Entity and carrier must be streamed to query.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: carrier_check
        -- Use: Finds the vehicle carrying an aimed-at container
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('carrier_check', function()
        local _, ent = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if ent and ent ~= 0 then
            local veh = _FindVehicleCarryingThisEntity(ent)
            if veh ~= 0 then
                TriggerEvent('chat:addMessage', {args = {'System', 'Carrier detected.'}})
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: carrier_check */
    RegisterCommand('carrier_check', () => {
      const [hit, ent] = GetEntityPlayerIsFreeAimingAt(PlayerId());
      if (hit) {
        const veh = FindVehicleCarryingThisEntity(ent);
        if (veh !== 0) {
          emit('chat:addMessage', { args: ['System', 'Carrier detected.'] });
        }
      }
    });
    ```
- **Caveats / Limitations**:
  - Works only with handler-frame cargo entities.
- **Reference**: https://docs.fivem.net/natives/?n=_FIND_VEHICLE_CARRYING_THIS_ENTITY

##### FixVehicleWindow
- **Name**: FixVehicleWindow
- **Scope**: Client
- **Signature**: `void FIX_VEHICLE_WINDOW(Vehicle vehicle, int windowIndex);`
- **Purpose**: Repairs a broken vehicle window by index.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `windowIndex` (`int`): Window slot.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must call to sync repair.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: fix_window
        -- Use: Restores the driver's window
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('fix_window', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then FixVehicleWindow(veh, 0) end -- 0 = driver
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: fix_window */
    RegisterCommand('fix_window', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        FixVehicleWindow(veh, 0);
      }
    });
    ```
- **Caveats / Limitations**:
  - Unsupported on bikes, boats, or trains.
- **Reference**: https://docs.fivem.net/natives/?n=FixVehicleWindow

##### ForcePlaybackRecordedVehicleUpdate
- **Name**: ForcePlaybackRecordedVehicleUpdate
- **Scope**: Client
- **Signature**: `void FORCE_PLAYBACK_RECORDED_VEHICLE_UPDATE(Vehicle vehicle, BOOL p1);`
- **Purpose**: Immediately applies a skipped playback frame to a recorded vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `p1` (`bool`): Unknown flag.
  - **Returns**: `void`
- **OneSync / Networking**: Playback must run on the owner to sync movement.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_skip
        -- Use: Skips 5 seconds ahead in a recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_skip', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            SkipTimeInPlaybackRecordedVehicle(veh, 5000)
            ForcePlaybackRecordedVehicleUpdate(veh, true)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_skip */
    RegisterCommand('playback_skip', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        SkipTimeInPlaybackRecordedVehicle(veh, 5000);
        ForcePlaybackRecordedVehicleUpdate(veh, true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Ensure recording is loaded before forcing updates.
- **Reference**: https://docs.fivem.net/natives/?n=ForcePlaybackRecordedVehicleUpdate

##### ForceSubmarineNeurtalBuoyancy
- **Name**: ForceSubmarineNeurtalBuoyancy
- **Scope**: Client
- **Signature**: `void FORCE_SUBMARINE_NEURTAL_BUOYANCY(Vehicle submarine, int time);`
- **Purpose**: Keeps a submarine neutrally buoyant for a set duration.
- **Parameters / Returns**:
  - `submarine` (`Vehicle`)
  - `time` (`int`): Duration in milliseconds.
  - **Returns**: `void`
- **OneSync / Networking**: Owner-only; replicates position as normal.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sub_neutral
        -- Use: Holds submarine depth for 30 seconds
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('sub_neutral', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ForceSubmarineNeurtalBuoyancy(veh, 30000) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sub_neutral */
    RegisterCommand('sub_neutral', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        ForceSubmarineNeurtalBuoyancy(veh, 30000);
      }
    });
    ```
- **Caveats / Limitations**:
  - Time must be >0; submarine rises normally after.
- **Reference**: https://docs.fivem.net/natives/?n=ForceSubmarineNeurtalBuoyancy

##### ForceSubmarineSurfaceMode
- **Name**: ForceSubmarineSurfaceMode
- **Scope**: Client
- **Signature**: `void FORCE_SUBMARINE_SURFACE_MODE(Vehicle vehicle, BOOL toggle);`
- **Purpose**: Forces a submarine to operate in surface mode.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - `toggle` (`bool`): Enable or disable surface mode.
  - **Returns**: `void`
- **OneSync / Networking**: Owner must toggle for network sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: sub_surface
        -- Use: Toggles surface mode on the current submarine
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('sub_surface', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then ForceSubmarineSurfaceMode(veh, true) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: sub_surface */
    RegisterCommand('sub_surface', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        ForceSubmarineSurfaceMode(veh, true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Only applicable to submarine vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=ForceSubmarineSurfaceMode

##### FullyChargeNitrous
- **Name**: FullyChargeNitrous
- **Scope**: Client
- **Signature**: `void FULLY_CHARGE_NITROUS(Vehicle vehicle);`
- **Purpose**: Recharges a vehicle's nitrous system to full.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`)
  - **Returns**: `void`
- **OneSync / Networking**: Must be run by vehicle owner to replicate nitrous level.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nitro_full
        -- Use: Refills nitrous after setting mods
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('nitro_full', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            SetOverrideNitrousLevel(veh, true, 1.5, 2.0, 0.5, false)
            FullyChargeNitrous(veh)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nitro_full */
    RegisterCommand('nitro_full', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        SetOverrideNitrousLevel(veh, true, 1.5, 2.0, 0.5, false);
        FullyChargeNitrous(veh);
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires nitrous mods to be configured beforehand.
- **Reference**: https://docs.fivem.net/natives/?n=FullyChargeNitrous

##### GetAllVehicles
- **Name**: GetAllVehicles
- **Scope**: Client
- **Signature**: `int GET_ALL_VEHICLES(int* vehArray);`
- **Purpose**: Fills an array with handles for every vehicle in the current game pool. Deprecated in favor of `GetGamePool`.
- **Parameters / Returns**:
  - `vehArray` (`int*`): Pre-allocated array to receive vehicle handles.
  - **Returns**: `int` count of vehicles written.
- **OneSync / Networking**: Client-side only; use `GetGamePool` to cover all streamed vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehicles_count
        -- Use: Reports total streamed vehicles
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehicles_count', function()
        local vehs = GetGamePool('CVehicle') -- replacement for GetAllVehicles
        TriggerEvent('chat:addMessage', {args = {'System', ('%s vehicles active'):format(#vehs)}})
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehicles_count */
    RegisterCommand('vehicles_count', () => {
      const vehs = GetGamePool('CVehicle'); // replacement for GetAllVehicles
      emit('chat:addMessage', { args: ['System', `${vehs.length} vehicles active`] });
    });
    ```
- **Caveats / Limitations**:
  - Native is deprecated; `GetGamePool` provides the same functionality.
- **Reference**: https://docs.fivem.net/natives/?n=GetAllVehicles

##### GetBoatBoomPositionRatio
- **Name**: GetBoatBoomPositionRatio
- **Scope**: Client
- **Signature**: `float GET_BOAT_BOOM_POSITION_RATIO(Vehicle vehicle);`
- **Purpose**: Returns a normalized ratio describing the boom position for supported boat models.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Boat to query.
  - **Returns**: `float` ratio from 0.0 (retracted) to 1.0 (extended).
- **OneSync / Networking**: Only meaningful for boats the client owns or controls.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_ratio
        -- Use: Shows boom extension percentage on the current boat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_ratio', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and IsThisModelABoat(GetEntityModel(veh)) then
            local ratio = GetBoatBoomPositionRatio(veh)
            TriggerEvent('chat:addMessage', {args = {'System', ('Boom: %d%%'):format(ratio*100)}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_ratio */
    RegisterCommand('boom_ratio', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && IsThisModelABoat(GetEntityModel(veh))) {
        const ratio = GetBoatBoomPositionRatio(veh);
        emit('chat:addMessage', { args: ['System', `Boom: ${Math.floor(ratio*100)}%`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only certain boats have controllable booms.
- **Reference**: https://docs.fivem.net/natives/?n=GetBoatBoomPositionRatio

##### GetBoatBoomPositionRatio_2
- **Name**: _GET_BOAT_BOOM_POSITION_RATIO_2
- **Scope**: Client
- **Signature**: `void _GET_BOAT_BOOM_POSITION_RATIO_2(Vehicle vehicle, BOOL p1);`
- **Purpose**: Internal variant for retrieving a secondary boom ratio on specific boats.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target boat.
  - `p1` (`bool`): Unknown flag.
  - **Returns**: `void` (value obtained through native-specific context).
- **OneSync / Networking**: Local effect only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_ratio2
        -- Use: Invokes hidden boom ratio function on current boat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_ratio2', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then _GET_BOAT_BOOM_POSITION_RATIO_2(veh, true) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_ratio2 */
    RegisterCommand('boom_ratio2', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        GetBoatBoomPositionRatio_2(veh, true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Behavior is undocumented; useful data output is unknown.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=GetBoatBoomPositionRatio_2

##### GetBoatBoomPositionRatio_3
- **Name**: _GET_BOAT_BOOM_POSITION_RATIO_3
- **Scope**: Client
- **Signature**: `void _GET_BOAT_BOOM_POSITION_RATIO_3(Vehicle vehicle, BOOL p1);`
- **Purpose**: Another internal call for alternative boom ratio retrieval.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Target boat.
  - `p1` (`bool`): Unknown usage.
  - **Returns**: `void`.
- **OneSync / Networking**: Local-only; does not sync.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boom_ratio3
        -- Use: Invokes tertiary boom ratio function
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boom_ratio3', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then _GET_BOAT_BOOM_POSITION_RATIO_3(veh, true) end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boom_ratio3 */
    RegisterCommand('boom_ratio3', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        GetBoatBoomPositionRatio_3(veh, true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Function purpose not documented.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?n=GetBoatBoomPositionRatio_3

##### GetBoatVehicleModelAgility
- **Name**: GetBoatVehicleModelAgility
- **Scope**: Client
- **Signature**: `float GET_BOAT_VEHICLE_MODEL_AGILITY(Hash modelHash);`
- **Purpose**: Retrieves the agility factor for a boat model, accounting for installed modifications.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Boat model identifier.
  - **Returns**: `float` agility rating.
- **OneSync / Networking**: Static model data; same across clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: boat_agility
        -- Use: Displays agility rating for current boat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('boat_agility', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and IsThisModelABoat(GetEntityModel(veh)) then
            local agility = GetBoatVehicleModelAgility(GetEntityModel(veh))
            TriggerEvent('chat:addMessage', {args = {'System', ('Agility: %.2f'):format(agility)}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: boat_agility */
    RegisterCommand('boat_agility', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && IsThisModelABoat(GetEntityModel(veh))) {
        const agility = GetBoatVehicleModelAgility(GetEntityModel(veh));
        emit('chat:addMessage', { args: ['System', `Agility: ${agility.toFixed(2)}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only applies to boat models.
- **Reference**: https://docs.fivem.net/natives/?n=GetBoatVehicleModelAgility

##### GetCanVehicleJump
- **Name**: _GET_CAN_VEHICLE_JUMP
- **Scope**: Client
- **Signature**: `BOOL _GET_CAN_VEHICLE_JUMP(Vehicle vehicle);`
- **Purpose**: Checks if a vehicle has a built-in jump ability.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool` indicating if jump is available.
- **OneSync / Networking**: Only valid for the client-owned vehicle.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: veh_can_jump
        -- Use: Reports if the current vehicle can jump
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('veh_can_jump', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and _GET_CAN_VEHICLE_JUMP(veh) then
            TriggerEvent('chat:addMessage', {args = {'System', 'Jump system available.'}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: veh_can_jump */
    RegisterCommand('veh_can_jump', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetCanVehicleJump(veh)) {
        emit('chat:addMessage', { args: ['System', 'Jump system available.'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only certain vehicles (e.g., Ruiner 2000) support jumping.
- **Reference**: https://docs.fivem.net/natives/?n=GetCanVehicleJump

##### GetCargobobHookPosition
- **Name**: _GET_CARGOBOB_HOOK_POSITION
- **Scope**: Client
- **Signature**: `Vector3 _GET_CARGOBOB_HOOK_POSITION(Vehicle cargobob);`
- **Purpose**: Provides world coordinates of an active Cargobob hook.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Target Cargobob helicopter.
  - **Returns**: `vector3` hook position.
- **OneSync / Networking**: Accurate only when the hook exists locally; sync depends on entity owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hook_pos
        -- Use: Prints hook location for the current Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('hook_pos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local pos = _GET_CARGOBOB_HOOK_POSITION(veh)
            TriggerEvent('chat:addMessage', {args = {'System', ('Hook at %.1f %.1f %.1f'):format(pos.x, pos.y, pos.z)}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hook_pos */
    RegisterCommand('hook_pos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const pos = GetCargobobHookPosition(veh);
        emit('chat:addMessage', { args: ['System', `Hook at ${pos[0].toFixed(1)} ${pos[1].toFixed(1)} ${pos[2].toFixed(1)}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only valid for Cargobob models with deployed hook.
- **Reference**: https://docs.fivem.net/natives/?n=GetCargobobHookPosition

##### GetClosestVehicle
- **Name**: GetClosestVehicle
- **Scope**: Client
- **Signature**: `Vehicle GET_CLOSEST_VEHICLE(float x, float y, float z, float radius, Hash modelHash, int flags);`
- **Purpose**: Finds the nearest vehicle to a position within a radius.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Position to search from.
  - `radius` (`float`): Search radius.
  - `modelHash` (`Hash`): Optional vehicle model filter; 0 for any.
  - `flags` (`int`): Bitwise search modifiers (commonly 70).
  - **Returns**: `Vehicle` handle or 0 if none found.
- **OneSync / Networking**: Only considers vehicles streamed to the client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: near_vehicle
        -- Use: Targets closest vehicle within 15m
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('near_vehicle', function()
        local p = PlayerPedId()
        local coords = GetEntityCoords(p)
        local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 15.0, 0, 70)
        if veh ~= 0 then
            SetEntityAsMissionEntity(veh, true, true)
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: near_vehicle */
    RegisterCommand('near_vehicle', () => {
      const ped = PlayerPedId();
      const [x, y, z] = GetEntityCoords(ped);
      const veh = GetClosestVehicle(x, y, z, 15.0, 0, 70);
      if (veh !== 0) {
        SetEntityAsMissionEntity(veh, true, true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Flags control included vehicle types; helicopters/boats require specific flags.
- **Reference**: https://docs.fivem.net/natives/?n=GetClosestVehicle

##### GetConvertibleRoofState
- **Name**: GetConvertibleRoofState
- **Scope**: Client
- **Signature**: `int GET_CONVERTIBLE_ROOF_STATE(Vehicle vehicle);`
- **Purpose**: Returns the roof animation state for convertible vehicles.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `int` `eRoofState` enum.
- **OneSync / Networking**: Requires entity ownership for accurate state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: roof_state
        -- Use: Displays convertible roof state
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('roof_state', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local state = GetConvertibleRoofState(veh)
            TriggerEvent('chat:addMessage', {args = {'System', ('Roof state: %d'):format(state)}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: roof_state */
    RegisterCommand('roof_state', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const state = GetConvertibleRoofState(veh);
        emit('chat:addMessage', { args: ['System', `Roof state: ${state}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only valid on convertible vehicles.
- **Reference**: https://docs.fivem.net/natives/?n=GetConvertibleRoofState

##### GetCurrentPlaybackForVehicle
- **Name**: GetCurrentPlaybackForVehicle
- **Scope**: Client
- **Signature**: `int GET_CURRENT_PLAYBACK_FOR_VEHICLE(Vehicle vehicle);`
- **Purpose**: Retrieves the recording playback identifier currently running on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle being played back.
  - **Returns**: `int` playback ID or 0 if none.
- **OneSync / Networking**: Playback must be started by the owner to replicate.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: playback_id
        -- Use: Reports current vehicle recording ID
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('playback_id', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local id = GetCurrentPlaybackForVehicle(veh)
            TriggerEvent('chat:addMessage', {args = {'System', ('Playback ID: %d'):format(id)}})
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: playback_id */
    RegisterCommand('playback_id', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const id = GetCurrentPlaybackForVehicle(veh);
        emit('chat:addMessage', { args: ['System', `Playback ID: ${id}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 when no playback is active.
- **Reference**: https://docs.fivem.net/natives/?n=GetCurrentPlaybackForVehicle

##### GetDisplayNameFromVehicleModel
- **Name**: GetDisplayNameFromVehicleModel
- **Scope**: Client
- **Signature**: `char* GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(Hash modelHash);`
- **Purpose**: Returns the display name text label for the provided vehicle model.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Vehicle model hash to query.
  - **Returns**: `string` display label or `CARNOTFOUND`.
- **OneSync / Networking**: Pure metadata lookup; no ownership required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehlabel
        -- Use: Show current vehicle display label
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehlabel', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local name = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
            TriggerEvent('chat:addMessage', { args = {'Vehicle', name} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehlabel */
    RegisterCommand('vehlabel', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const name = GetDisplayNameFromVehicleModel(GetEntityModel(veh));
        emit('chat:addMessage', { args: ['Vehicle', name] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns `CARNOTFOUND` for unknown models.
- **Reference**: https://docs.fivem.net/natives/?_0xB215AAC32D25D019

##### _GET_DOES_VEHICLE_HAVE_TOMBSTONE
- **Name**: _GET_DOES_VEHICLE_HAVE_TOMBSTONE
- **Scope**: Client
- **Signature**: `BOOL _GET_DOES_VEHICLE_HAVE_TOMBSTONE(Vehicle vehicle);`
- **Purpose**: Checks if the vehicle supports a decorative tombstone.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Vehicle must be streamed to query decor data.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tombstone
        -- Use: Notify if the current vehicle has a tombstone option
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tombstone', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetDoesVehicleHaveTombstone(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Tombstone available'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tombstone */
    RegisterCommand('tombstone', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetDoesVehicleHaveTombstone(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Tombstone available'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Documentation for this native is limited.
  - TODO(next-run): verify semantics.
- **Reference**: https://docs.fivem.net/natives/?_0x71AFB258CCED3A27

##### _GET_DRIFT_TYRES_ENABLED
- **Name**: _GET_DRIFT_TYRES_ENABLED
- **Scope**: Client
- **Signature**: `BOOL _GET_DRIFT_TYRES_ENABLED(Vehicle vehicle);`
- **Purpose**: Returns whether drift tyre mode is enabled on the vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Requires vehicle to be streamed; state sync is owner-driven.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: drifttyres
        -- Use: Report if current vehicle uses drift tyres
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('drifttyres', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetDriftTyresEnabled(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Drift tyres active'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: drifttyres */
    RegisterCommand('drifttyres', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetDriftTyresEnabled(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Drift tyres active'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only applicable to vehicles with drift mode support.
- **Reference**: https://docs.fivem.net/natives/?_0x2F5A72430E78C8D3

##### _GET_ENTITY_ATTACHED_TO_CARGOBOB
- **Name**: _GET_ENTITY_ATTACHED_TO_CARGOBOB
- **Scope**: Client
- **Signature**: `Entity _GET_ENTITY_ATTACHED_TO_CARGOBOB(Vehicle vehicle);`
- **Purpose**: Retrieves the entity currently attached to the specified Cargobob.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Cargobob to check.
  - **Returns**: `Entity` handle or `0`.
- **OneSync / Networking**: Cargobob must be owned or streamed to access attachment state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cargobobload
        -- Use: Show entity attached to current Cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('cargobobload', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local ent = GetEntityAttachedToCargobob(veh)
            if ent ~= 0 then
                TriggerEvent('chat:addMessage', { args = {'Cargobob', ('Attached entity: %s'):format(ent)} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cargobobload */
    RegisterCommand('cargobobload', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const ent = GetEntityAttachedToCargobob(veh);
        if (ent !== 0) {
          emit('chat:addMessage', { args: ['Cargobob', `Attached entity: ${ent}`] });
        }
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 when nothing is attached.
- **Reference**: https://docs.fivem.net/natives/?_0x99093F60746708CA

##### GetEntityAttachedToTowTruck
- **Name**: GetEntityAttachedToTowTruck
- **Scope**: Client
- **Signature**: `Entity GET_ENTITY_ATTACHED_TO_TOW_TRUCK(Vehicle towTruck);`
- **Purpose**: Returns the entity currently towed by the tow truck.
- **Parameters / Returns**:
  - `towTruck` (`Vehicle`): Tow truck vehicle handle.
  - **Returns**: `Entity` handle or `0`.
- **OneSync / Networking**: Tow truck must be streamed; attachment sync handled by owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: towload
        -- Use: Report the entity attached to the tow truck
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('towload', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local ent = GetEntityAttachedToTowTruck(veh)
            if ent ~= 0 then
                TriggerEvent('chat:addMessage', { args = {'Tow', ('Attached entity: %s'):format(ent)} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: towload */
    RegisterCommand('towload', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const ent = GetEntityAttachedToTowTruck(veh);
        if (ent !== 0) {
          emit('chat:addMessage', { args: ['Tow', `Attached entity: ${ent}`] });
        }
      }
    });
    ```
- **Caveats / Limitations**:
  - Only returns vehicles attached via tow mechanism.
- **Reference**: https://docs.fivem.net/natives/?_0xEFEA18DCF10F8F75

##### _GET_ENTRY_POSITION_OF_DOOR
- **Name**: _GET_ENTRY_POSITION_OF_DOOR
- **Scope**: Client
- **Signature**: `Vector3 _GET_ENTRY_POSITION_OF_DOOR(Vehicle vehicle, int doorIndex);`
- **Purpose**: Provides the world position where a ped would enter the specified door.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to sample.
  - `doorIndex` (`int`): Door ID (see eDoorId).
  - **Returns**: `vector3` coordinates.
- **OneSync / Networking**: Vehicle must be streamed; purely local calculation.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: doorpos
        -- Use: Print entry position for driver's door
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('doorpos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local pos = GetEntryPositionOfDoor(veh, 0)
            TriggerEvent('chat:addMessage', { args = {'Door', ('%.2f %.2f %.2f'):format(pos.x, pos.y, pos.z)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: doorpos */
    RegisterCommand('doorpos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const pos = GetEntryPositionOfDoor(veh, 0);
        emit('chat:addMessage', { args: ['Door', `${pos.x.toFixed(2)} ${pos.y.toFixed(2)} ${pos.z.toFixed(2)}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Coordinates are local to client; may differ slightly across machines.
- **Reference**: https://docs.fivem.net/natives/?_0xC0572928C0ABFDA3

##### _GET_HAS_RETRACTABLE_WHEELS
- **Name**: _GET_HAS_RETRACTABLE_WHEELS
- **Scope**: Client
- **Signature**: `BOOL _GET_HAS_RETRACTABLE_WHEELS(Vehicle vehicle);`
- **Purpose**: Determines if the vehicle features retractable landing gear or wheels.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Requires vehicle entity to be streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: retractwheels
        -- Use: Check if current vehicle has retractable wheels
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('retractwheels', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetHasRetractableWheels(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Retractable wheels'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: retractwheels */
    RegisterCommand('retractwheels', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetHasRetractableWheels(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Retractable wheels'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Typically true for aircraft like Hydra.
- **Reference**: https://docs.fivem.net/natives/?_0xDCA174A42133F08C

##### _GET_HAS_ROCKET_BOOST
- **Name**: _GET_HAS_ROCKET_BOOST
- **Scope**: Client
- **Signature**: `BOOL _GET_HAS_ROCKET_BOOST(Vehicle vehicle);`
- **Purpose**: Checks if the vehicle includes a rocket boost system.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Rocket boost state syncs with vehicle owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rocketboost
        -- Use: Determine if current vehicle has rocket boost
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rocketboost', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetHasRocketBoost(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Rocket boost ready'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rocketboost */
    RegisterCommand('rocketboost', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetHasRocketBoost(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Rocket boost ready'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only for vehicles supporting rocket boost upgrades.
- **Reference**: https://docs.fivem.net/natives/?_0x36D782F68B309BDA

##### GetHeliMainRotorHealth
- **Name**: GetHeliMainRotorHealth
- **Scope**: Client
- **Signature**: `float GET_HELI_MAIN_ROTOR_HEALTH(Vehicle vehicle);`
- **Purpose**: Retrieves main rotor health; 0 stalls the rotor.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Helicopter to check.
  - **Returns**: `float` (max 1000).
- **OneSync / Networking**: Health syncs from owning client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: mainrotor
        -- Use: Report main rotor health of current heli
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('mainrotor', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local hp = GetHeliMainRotorHealth(veh)
            TriggerEvent('chat:addMessage', { args = {'Heli', ('Main rotor: %d'):format(math.floor(hp))} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: mainrotor */
    RegisterCommand('mainrotor', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const hp = GetHeliMainRotorHealth(veh);
        emit('chat:addMessage', { args: ['Heli', `Main rotor: ${Math.floor(hp)}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Value ranges 0–1000.
- **Reference**: https://docs.fivem.net/natives/?_0xE4CB7541F413D2C5

##### GetHeliTailBoomHealth
- **Name**: GetHeliTailBoomHealth
- **Scope**: Client
- **Signature**: `float GET_HELI_TAIL_BOOM_HEALTH(Vehicle vehicle);`
- **Purpose**: Returns tail boom structural health; -100 stalls rotors.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Helicopter to inspect.
  - **Returns**: `float` (max 1000).
- **OneSync / Networking**: Synced with helicopter owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tailboom
        -- Use: Report tail boom health of current heli
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tailboom', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local hp = GetHeliTailBoomHealth(veh)
            TriggerEvent('chat:addMessage', { args = {'Heli', ('Tail boom: %d'):format(math.floor(hp))} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tailboom */
    RegisterCommand('tailboom', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const hp = GetHeliTailBoomHealth(veh);
        emit('chat:addMessage', { args: ['Heli', `Tail boom: ${Math.floor(hp)}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Below -100 rotor failure occurs.
- **Reference**: https://docs.fivem.net/natives/?_0xAC51915D27E4A5F7

##### GetHeliTailRotorHealth
- **Name**: GetHeliTailRotorHealth
- **Scope**: Client
- **Signature**: `float GET_HELI_TAIL_ROTOR_HEALTH(Vehicle heli);`
- **Purpose**: Gets health of the tail rotor; 0 stalls the rotor.
- **Parameters / Returns**:
  - `heli` (`Vehicle`): Helicopter to inspect.
  - **Returns**: `float` (max 1000).
- **OneSync / Networking**: Health value owned by controlling client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tailrotor
        -- Use: Report tail rotor health of current heli
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tailrotor', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local hp = GetHeliTailRotorHealth(veh)
            TriggerEvent('chat:addMessage', { args = {'Heli', ('Tail rotor: %d'):format(math.floor(hp))} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tailrotor */
    RegisterCommand('tailrotor', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const hp = GetHeliTailRotorHealth(veh);
        emit('chat:addMessage', { args: ['Heli', `Tail rotor: ${Math.floor(hp)}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Max value 1000.
- **Reference**: https://docs.fivem.net/natives/?_0xAE8CE82A4219AC8C

##### _GET_HYDRAULIC_WHEEL_VALUE
- **Name**: _GET_HYDRAULIC_WHEEL_VALUE
- **Scope**: Client
- **Signature**: `float _GET_HYDRAULIC_WHEEL_VALUE(Vehicle vehicle, int wheelId);`
- **Purpose**: Returns the hydraulic suspension value for a wheel.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `wheelId` (`int`): Wheel index.
  - **Returns**: `float` height ratio.
- **OneSync / Networking**: Hydraulic positions replicate from owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: hydrowheel
        -- Use: Display hydraulic value for front left wheel
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('hydrowheel', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local v = GetHydraulicWheelValue(veh, 0)
            TriggerEvent('chat:addMessage', { args = {'Hydraulics', ('Wheel: %.2f'):format(v)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: hydrowheel */
    RegisterCommand('hydrowheel', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const v = GetHydraulicWheelValue(veh, 0);
        emit('chat:addMessage', { args: ['Hydraulics', `Wheel: ${v.toFixed(2)}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Wheel indices vary by vehicle.
- **Reference**: https://docs.fivem.net/natives/?_0x0BB5CBDDD0F25AE3

##### GetIsBoatCapsized
- **Name**: GetIsBoatCapsized
- **Scope**: Client
- **Signature**: `BOOL GET_IS_BOAT_CAPSIZED(Vehicle vehicle);`
- **Purpose**: Checks whether the boat is overturned in water.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Boat to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Requires streamed boat; state derived locally.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: capsized
        -- Use: Warn if current boat is capsized
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('capsized', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsBoatCapsized(veh) then
            TriggerEvent('chat:addMessage', { args = {'Boat', 'Capsized!'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: capsized */
    RegisterCommand('capsized', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsBoatCapsized(veh)) {
        emit('chat:addMessage', { args: ['Boat', 'Capsized!'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only valid for boat-class vehicles.
- **Reference**: https://docs.fivem.net/natives/?_0xBA91D045575699AD

##### _GET_IS_DOOR_VALID
- **Name**: _GET_IS_DOOR_VALID
- **Scope**: Client
- **Signature**: `BOOL _GET_IS_DOOR_VALID(Vehicle vehicle, int doorIndex);`
- **Purpose**: Verifies that a specific vehicle door index exists.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `doorIndex` (`int`): Door ID.
  - **Returns**: `bool`.
- **OneSync / Networking**: Local query; vehicle must be streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: doorvalid
        -- Use: Check if rear left door index is valid
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('doorvalid', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsDoorValid(veh, 2) then
            TriggerEvent('chat:addMessage', { args = {'Door', 'Rear left door exists'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: doorvalid */
    RegisterCommand('doorvalid', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsDoorValid(veh, 2)) {
        emit('chat:addMessage', { args: ['Door', 'Rear left door exists'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Door indices differ between vehicles.
- **Reference**: https://docs.fivem.net/natives/?_0x645F4B6E8499F632

##### GetIsLeftVehicleHeadlightDamaged
- **Name**: GetIsLeftVehicleHeadlightDamaged
- **Scope**: Client
- **Signature**: `BOOL GET_IS_LEFT_VEHICLE_HEADLIGHT_DAMAGED(Vehicle vehicle);`
- **Purpose**: Determines if the left headlight is broken from driver's view.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Damage state shared by owning client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: leftlight
        -- Use: Report status of left headlight
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('leftlight', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsLeftVehicleHeadlightDamaged(veh) then
            TriggerEvent('chat:addMessage', { args = {'Lights', 'Left headlight broken'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: leftlight */
    RegisterCommand('leftlight', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsLeftVehicleHeadlightDamaged(veh)) {
        emit('chat:addMessage', { args: ['Lights', 'Left headlight broken'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Perspective is from driver seat.
- **Reference**: https://docs.fivem.net/natives/?_0x5EF77C9ADD3B11A3

##### GetIsRightVehicleHeadlightDamaged
- **Name**: GetIsRightVehicleHeadlightDamaged
- **Scope**: Client
- **Signature**: `BOOL GET_IS_RIGHT_VEHICLE_HEADLIGHT_DAMAGED(Vehicle vehicle);`
- **Purpose**: Determines if the right headlight is broken from driver's view.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Damage state shared by owning client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rightlight
        -- Use: Report status of right headlight
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rightlight', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsRightVehicleHeadlightDamaged(veh) then
            TriggerEvent('chat:addMessage', { args = {'Lights', 'Right headlight broken'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rightlight */
    RegisterCommand('rightlight', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsRightVehicleHeadlightDamaged(veh)) {
        emit('chat:addMessage', { args: ['Lights', 'Right headlight broken'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Perspective is from driver seat.
- **Reference**: https://docs.fivem.net/natives/?_0xA7ECB73355EB2F20

##### _GET_IS_VEHICLE_ELECTRIC
- **Name**: _GET_IS_VEHICLE_ELECTRIC
- **Scope**: Client
- **Signature**: `BOOL _GET_IS_VEHICLE_ELECTRIC(Hash vehicleModel);`
- **Purpose**: Checks if a vehicle model is electric-powered.
- **Parameters / Returns**:
  - `vehicleModel` (`Hash`): Model hash to test.
  - **Returns**: `bool`.
- **OneSync / Networking**: Model metadata lookup only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: elecmodel
        -- Use: Inform if current vehicle model is electric
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('elecmodel', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local model = GetEntityModel(veh)
            if GetIsVehicleElectric(model) then
                TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Electric model'} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: elecmodel */
    RegisterCommand('elecmodel', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const model = GetEntityModel(veh);
        if (GetIsVehicleElectric(model)) {
          emit('chat:addMessage', { args: ['Vehicle', 'Electric model'] });
        }
      }
    });
    ```
- **Caveats / Limitations**:
  - Introduced in later game builds; not all models defined.
- **Reference**: https://docs.fivem.net/natives/?_0x1FCB07FE230B6639

##### _GET_IS_VEHICLE_EMP_DISABLED
- **Name**: _GET_IS_VEHICLE_EMP_DISABLED
- **Scope**: Client
- **Signature**: `BOOL _GET_IS_VEHICLE_EMP_DISABLED(Vehicle vehicle);`
- **Purpose**: Returns whether the vehicle is disabled by an EMP effect.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: EMP state must be synced by owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: empcheck
        -- Use: Alert if current vehicle is EMP disabled
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('empcheck', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsVehicleEmpDisabled(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'EMP disabled'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: empcheck */
    RegisterCommand('empcheck', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsVehicleEmpDisabled(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'EMP disabled'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires game build with EMP mines support.
- **Reference**: https://docs.fivem.net/natives/?_0x0506ED94363AD905

##### GetIsVehicleEngineRunning
- **Name**: GetIsVehicleEngineRunning
- **Scope**: Client
- **Signature**: `BOOL GET_IS_VEHICLE_ENGINE_RUNNING(Vehicle vehicle);`
- **Purpose**: Returns true if the engine is currently on.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Engine state syncs to all clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: engine
        -- Use: Inform if current vehicle engine is running
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('engine', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsVehicleEngineRunning(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Engine on'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: engine */
    RegisterCommand('engine', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsVehicleEngineRunning(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Engine on'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns false during entry/exit animations.
- **Reference**: https://docs.fivem.net/natives/?_0xAE31E7DF9B5B132E

##### GetIsVehiclePrimaryColourCustom
- **Name**: GetIsVehiclePrimaryColourCustom
- **Scope**: Client
- **Signature**: `BOOL GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(Vehicle vehicle);`
- **Purpose**: Checks if the vehicle uses a custom primary colour.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Colour customization is synced with owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: primarycolor
        -- Use: Inform if vehicle primary colour is custom
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('primarycolor', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsVehiclePrimaryColourCustom(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Primary colour custom'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: primarycolor */
    RegisterCommand('primarycolor', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsVehiclePrimaryColourCustom(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Primary colour custom'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only reflects paint applied via mod shops or scripts.
- **Reference**: https://docs.fivem.net/natives/?_0xF095C0405307B21B

##### GetIsVehicleSecondaryColourCustom
- **Name**: GetIsVehicleSecondaryColourCustom
- **Scope**: Client
- **Signature**: `BOOL GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(Vehicle vehicle);`
- **Purpose**: Checks if the vehicle uses a custom secondary colour.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Colour customization is synced with owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: secondarycolor
        -- Use: Inform if vehicle secondary colour is custom
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('secondarycolor', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsVehicleSecondaryColourCustom(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Secondary colour custom'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: secondarycolor */
    RegisterCommand('secondarycolor', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsVehicleSecondaryColourCustom(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Secondary colour custom'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only reflects paint applied via mod shops or scripts.
- **Reference**: https://docs.fivem.net/natives/?_0x910A32E7AAD2656C

##### _GET_IS_VEHICLE_SHUNT_BOOST_ACTIVE
- **Name**: _GET_IS_VEHICLE_SHUNT_BOOST_ACTIVE
- **Scope**: Client
- **Signature**: `BOOL _GET_IS_VEHICLE_SHUNT_BOOST_ACTIVE(Vehicle vehicle);`
- **Purpose**: Checks if the vehicle's shunt boost is currently active.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: `bool`.
- **OneSync / Networking**: Boost state synced from owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: shuntboost
        -- Use: Notify if shunt boost is active
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('shuntboost', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsVehicleShuntBoostActive(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Shunt boost active'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: shuntboost */
    RegisterCommand('shuntboost', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsVehicleShuntBoostActive(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Shunt boost active'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires vehicles with Arena War shunt boost.
- **Reference**: https://docs.fivem.net/natives/?_0xA2459F72C14E2E8D

##### _GET_IS_WHEELS_LOWERED_STATE_ACTIVE
- **Name**: _GET_IS_WHEELS_LOWERED_STATE_ACTIVE
- **Scope**: Client
- **Signature**: `BOOL _GET_IS_WHEELS_LOWERED_STATE_ACTIVE(Vehicle vehicle);`
- **Purpose**: Returns whether the vehicle's lowered wheel state is active.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: `bool`.
- **OneSync / Networking**: Lowered state synchronized by owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lowwheels
        -- Use: Notify if wheels are lowered
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lowwheels', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetIsWheelsLoweredStateActive(veh) then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', 'Wheels lowered'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lowwheels */
    RegisterCommand('lowwheels', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetIsWheelsLoweredStateActive(veh)) {
        emit('chat:addMessage', { args: ['Vehicle', 'Wheels lowered'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only for vehicles with hydraulic lowering.
- **Reference**: https://docs.fivem.net/natives/?_0x1DA0DA9CB3F0C8BF

##### GetLandingGearState
- **Name**: GetLandingGearState
- **Scope**: Client
- **Signature**: `int GET_LANDING_GEAR_STATE(Vehicle vehicle);`
- **Purpose**: Retrieves landing gear deployment state.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Aircraft to inspect.
  - **Returns**: `int` state (0 deployed, 1 closing, 3 opening, 4 retracted, 5 broken).
- **OneSync / Networking**: Gear state synced by owner.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: gearstate
        -- Use: Report landing gear state of current aircraft
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('gearstate', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local state = GetLandingGearState(veh)
            TriggerEvent('chat:addMessage', { args = {'Gear', ('State: %d'):format(state)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: gearstate */
    RegisterCommand('gearstate', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const state = GetLandingGearState(veh);
        emit('chat:addMessage', { args: ['Gear', `State: ${state}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Some aircraft may not support all states.
- **Reference**: https://docs.fivem.net/natives/?_0x9B0F3DCA3DB0F4CD

##### GetLastDrivenVehicle
- **Name**: GetLastDrivenVehicle
- **Scope**: Client
- **Signature**: `Vehicle GET_LAST_DRIVEN_VEHICLE();`
- **Purpose**: Returns the last vehicle the player controlled.
- **Parameters / Returns**:
  - **Returns**: `Vehicle` handle or `0` if none.
- **OneSync / Networking**: Handle valid only if vehicle still exists locally.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lastveh
        -- Use: Teleport back to last driven vehicle if it exists
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lastveh', function()
        local veh = GetLastDrivenVehicle()
        if veh ~= 0 then
            SetEntityCoords(PlayerPedId(), GetEntityCoords(veh))
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lastveh */
    RegisterCommand('lastveh', () => {
      const veh = GetLastDrivenVehicle();
      if (veh !== 0) {
        const coords = GetEntityCoords(veh, false);
        SetEntityCoords(PlayerPedId(), coords[0], coords[1], coords[2], false, false, false, true);
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if the vehicle has despawned.
- **Reference**: https://docs.fivem.net/natives/?_0xB2D06FAEDE65B577

##### GetLastPedInVehicleSeat
- **Name**: GetLastPedInVehicleSeat
- **Scope**: Client
- **Signature**: `Ped GET_LAST_PED_IN_VEHICLE_SEAT(Vehicle vehicle, int seatIndex);`
- **Purpose**: Retrieves the last ped that occupied the specified seat in a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - `seatIndex` (`int`): Seat index (-1 for driver, etc.).
  - **Returns**: `Ped` handle or `0` if none.
- **OneSync / Networking**: Vehicle must be streamed to the client to access occupant history.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lastpedseat
        -- Use: Show last ped handle for a given seat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lastpedseat', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local seat = tonumber(args[1]) or -1
            local ped = GetLastPedInVehicleSeat(veh, seat)
            if ped ~= 0 then
                TriggerEvent('chat:addMessage', { args = {'Seat', ('Ped ID: %d'):format(ped)} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lastpedseat */
    RegisterCommand('lastpedseat', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const seat = parseInt(args[0]) || -1;
        const ped = GetLastPedInVehicleSeat(veh, seat);
        if (ped !== 0) emit('chat:addMessage', { args: ['Seat', `Ped ID: ${ped}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Seat index must correspond to a valid seat.
- **Reference**: https://docs.fivem.net/natives/?_0x83F969AA1EE2A664

##### _GET_LAST_RAMMED_VEHICLE
- **Name**: _GET_LAST_RAMMED_VEHICLE
- **Scope**: Client
- **Signature**: `Vehicle _GET_LAST_RAMMED_VEHICLE(Vehicle vehicle);`
- **Purpose**: Returns the last vehicle rammed by the specified vehicle using shunt boost.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle that performed the ram.
  - **Returns**: `Vehicle` handle or `0` if none.
- **OneSync / Networking**: Only valid for vehicles currently streamed; result may be `0` on remote entities.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: lastram
        -- Use: Display the model name of the last rammed vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('lastram', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local rammed = GetLastRammedVehicle(veh)
            if rammed ~= 0 then
                local label = GetDisplayNameFromVehicleModel(GetEntityModel(rammed))
                TriggerEvent('chat:addMessage', { args = {'Rammed', label} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: lastram */
    RegisterCommand('lastram', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const rammed = GetLastRammedVehicle(veh);
        if (rammed !== 0) {
          const label = GetDisplayNameFromVehicleModel(GetEntityModel(rammed));
          emit('chat:addMessage', { args: ['Rammed', label] });
        }
      }
    });
    ```
- **Caveats / Limitations**:
  - Only tracks impacts performed with shunt boost mechanics.
- **Reference**: https://docs.fivem.net/natives/?_0x04F2FA6E234162F7

##### GetLiveryName
- **Name**: GetLiveryName
- **Scope**: Client
- **Signature**: `char* GET_LIVERY_NAME(Vehicle vehicle, int liveryIndex);`
- **Purpose**: Retrieves the internal label for a specific livery on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - `liveryIndex` (`int`): Livery slot.
  - **Returns**: Label string; use `_GET_LABEL_TEXT` for localized name.
- **OneSync / Networking**: Requires vehicle owner sync; ensure mod kit initialized.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: liveryname
        -- Use: List the label of each livery
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('liveryname', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local count = GetVehicleLiveryCount(veh)
            for i = 0, count - 1 do
                local name = GetLiveryName(veh, i)
                TriggerEvent('chat:addMessage', { args = {'Livery', name or 'nil'} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: liveryname */
    RegisterCommand('liveryname', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const count = GetVehicleLiveryCount(veh);
        for (let i = 0; i < count; i++) {
          const name = GetLiveryName(veh, i);
          emit('chat:addMessage', { args: ['Livery', name || 'nil'] });
        }
      }
    });
    ```
- **Caveats / Limitations**:
  - Vehicle must have a mod kit set, otherwise returns `NULL`.
- **Reference**: https://docs.fivem.net/natives/?_0xB4C7A93837C91A1F

##### GetMakeNameFromVehicleModel
- **Name**: GetMakeNameFromVehicleModel
- **Scope**: Client
- **Signature**: `char* GET_MAKE_NAME_FROM_VEHICLE_MODEL(Hash modelHash);`
- **Purpose**: Returns the manufacturer name for a vehicle model hash.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Vehicle model identifier.
  - **Returns**: Manufacturer label or `CARNOTFOUND`.
- **OneSync / Networking**: Pure lookup; no networking impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: makename
        -- Use: Show manufacturer of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('makename', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local manu = GetMakeNameFromVehicleModel(GetEntityModel(veh))
            TriggerEvent('chat:addMessage', { args = {'Make', manu} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: makename */
    RegisterCommand('makename', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const manu = GetMakeNameFromVehicleModel(GetEntityModel(veh));
        emit('chat:addMessage', { args: ['Make', manu] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns `CARNOTFOUND` for custom or unknown models.
- **Reference**: https://docs.fivem.net/natives/?_0xF7AF4F159FF99F97

##### GetModSlotName
- **Name**: GetModSlotName
- **Scope**: Client
- **Signature**: `char* GET_MOD_SLOT_NAME(Vehicle vehicle, int modType);`
- **Purpose**: Provides the label for a mod slot on a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with mod kit.
  - `modType` (`int`): eVehicleModType index.
  - **Returns**: Slot label string.
- **OneSync / Networking**: Vehicle must be streamed; local only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: modslot
        -- Use: Show name of the mod slot
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('modslot', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local slot = tonumber(args[1]) or 0
        if veh ~= 0 then
            local label = GetModSlotName(veh, slot)
            TriggerEvent('chat:addMessage', { args = {'Mod', label or 'nil'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: modslot */
    RegisterCommand('modslot', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const slot = parseInt(args[0]) || 0;
      if (veh !== 0) {
        const label = GetModSlotName(veh, slot);
        emit('chat:addMessage', { args: ['Mod', label || 'nil'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns `NULL` if the slot is unused or mod kit not set.
- **Reference**: https://docs.fivem.net/natives/?_0x51F0FEB9F6AE98C0

##### GetModTextLabel
- **Name**: GetModTextLabel
- **Scope**: Client
- **Signature**: `char* GET_MOD_TEXT_LABEL(Vehicle vehicle, int modType, int modValue);`
- **Purpose**: Retrieves the internal label for a specific mod value.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `modType` (`int`): eVehicleModType index.
  - `modValue` (`int`): Specific mod variation.
  - **Returns**: Label string; localize with `_GET_LABEL_TEXT`.
- **OneSync / Networking**: Vehicle must be streamed with mod kit initialized.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: modlabel
        -- Use: Fetch label for a mod value
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('modlabel', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local slot = tonumber(args[1]) or 0
            local value = tonumber(args[2]) or 0
            local label = GetModTextLabel(veh, slot, value)
            TriggerEvent('chat:addMessage', { args = {'Mod', label or 'nil'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: modlabel */
    RegisterCommand('modlabel', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const slot = parseInt(args[1]) || 0;
        const value = parseInt(args[2]) || 0;
        const label = GetModTextLabel(veh, slot, value);
        emit('chat:addMessage', { args: ['Mod', label || 'nil'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires valid mod kit; returns `NULL` when mod unavailable.
- **Reference**: https://docs.fivem.net/natives/?_0x8935624F8C5592CC

##### GetNumModColors
- **Name**: GetNumModColors
- **Scope**: Client
- **Signature**: `int GET_NUM_MOD_COLORS(int paintType, BOOL p1);`
- **Purpose**: Returns count of available colors for a paint type.
- **Parameters / Returns**:
  - `paintType` (`int`): 0 Normal, 1 Metallic, 2 Pearl, 3 Matte, 4 Metal, 5 Chrome.
  - `p1` (`BOOL`): Unused flag, often `false`.
  - **Returns**: Number of colors.
- **OneSync / Networking**: Pure lookup; no network considerations.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: colorcount
        -- Use: Show number of colors for a paint type
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('colorcount', function(source, args)
        local type = tonumber(args[1]) or 0
        local count = GetNumModColors(type, false)
        TriggerEvent('chat:addMessage', { args = {'Colors', tostring(count)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: colorcount */
    RegisterCommand('colorcount', (src, args) => {
      const type = parseInt(args[0]) || 0;
      const count = GetNumModColors(type, false);
      emit('chat:addMessage', { args: ['Colors', String(count)] });
    });
    ```
- **Caveats / Limitations**:
  - `p1` purpose remains undocumented.
- **Reference**: https://docs.fivem.net/natives/?_0xA551BE18C11A476D

##### GetNumModKits
- **Name**: GetNumModKits
- **Scope**: Client
- **Signature**: `int GET_NUM_MOD_KITS(Vehicle vehicle);`
- **Purpose**: Returns the number of mod kits available for a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - **Returns**: Count of mod kits.
- **OneSync / Networking**: Vehicle must be streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: modkits
        -- Use: Show how many mod kits the vehicle supports
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('modkits', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local count = GetNumModKits(veh)
            TriggerEvent('chat:addMessage', { args = {'ModKits', tostring(count)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: modkits */
    RegisterCommand('modkits', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const count = GetNumModKits(veh);
        emit('chat:addMessage', { args: ['ModKits', String(count)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Some vehicles may only support a single mod kit.
- **Reference**: https://docs.fivem.net/natives/?_0x33F2E3FE70EAAE1D

##### GetNumVehicleMods
- **Name**: GetNumVehicleMods
- **Scope**: Client
- **Signature**: `int GET_NUM_VEHICLE_MODS(Vehicle vehicle, int modType);`
- **Purpose**: Retrieves number of mod variations for a specific mod type.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `modType` (`int`): eVehicleModType index.
  - **Returns**: Count of available mods.
- **OneSync / Networking**: Requires streamed vehicle.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: modcount
        -- Use: Show number of variations for a mod slot
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('modcount', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local slot = tonumber(args[1]) or 0
        if veh ~= 0 then
            local count = GetNumVehicleMods(veh, slot)
            TriggerEvent('chat:addMessage', { args = {'Mods', tostring(count)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: modcount */
    RegisterCommand('modcount', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const slot = parseInt(args[0]) || 0;
      if (veh !== 0) {
        const count = GetNumVehicleMods(veh, slot);
        emit('chat:addMessage', { args: ['Mods', String(count)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Some mod types may have zero options on certain vehicles.
- **Reference**: https://docs.fivem.net/natives/?_0xE38E9162A2500646

##### GetNumVehicleWindowTints
- **Name**: GetNumVehicleWindowTints
- **Scope**: Client
- **Signature**: `int GET_NUM_VEHICLE_WINDOW_TINTS();`
- **Purpose**: Returns number of predefined window tint levels.
- **Parameters / Returns**:
  - **Returns**: Total available tint options.
- **OneSync / Networking**: Pure lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tintcount
        -- Use: Show total window tint options
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tintcount', function()
        TriggerEvent('chat:addMessage', { args = {'Tints', tostring(GetNumVehicleWindowTints())} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tintcount */
    RegisterCommand('tintcount', () => {
      emit('chat:addMessage', { args: ['Tints', String(GetNumVehicleWindowTints())] });
    });
    ```
- **Caveats / Limitations**:
  - Does not reflect custom tint levels.
- **Reference**: https://docs.fivem.net/natives/?_0x9D1224004B3A6707

##### GetNumberOfVehicleColours
- **Name**: GetNumberOfVehicleColours
- **Scope**: Client
- **Signature**: `int GET_NUMBER_OF_VEHICLE_COLOURS(Vehicle vehicle);`
- **Purpose**: Returns the number of color combinations a vehicle supports.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: Count of color combinations.
- **OneSync / Networking**: Requires vehicle to be streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: colorcombo
        -- Use: Show color combination count
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('colorcombo', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local count = GetNumberOfVehicleColours(veh)
            TriggerEvent('chat:addMessage', { args = {'Colours', tostring(count)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: colorcombo */
    RegisterCommand('colorcombo', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const count = GetNumberOfVehicleColours(veh);
        emit('chat:addMessage', { args: ['Colours', String(count)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Some vehicles restrict combinations to predefined sets.
- **Reference**: https://docs.fivem.net/natives/?_0x3B963160CD65D41E

##### _GET_NUMBER_OF_VEHICLE_DOORS
- **Name**: _GET_NUMBER_OF_VEHICLE_DOORS
- **Scope**: Client
- **Signature**: `int _GET_NUMBER_OF_VEHICLE_DOORS(Vehicle vehicle);`
- **Purpose**: Returns the number of doors on the given vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - **Returns**: Door count.
- **OneSync / Networking**: Vehicle must be streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: doorcount
        -- Use: Report how many doors the vehicle has
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('doorcount', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            TriggerEvent('chat:addMessage', { args = {'Doors', tostring(GetNumberOfVehicleDoors(veh))} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: doorcount */
    RegisterCommand('doorcount', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        emit('chat:addMessage', { args: ['Doors', String(GetNumberOfVehicleDoors(veh))] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Function name begins with underscore in native database.
- **Reference**: https://docs.fivem.net/natives/?_0x92922A607497B14D

##### GetNumberOfVehicleNumberPlates
- **Name**: GetNumberOfVehicleNumberPlates
- **Scope**: Client
- **Signature**: `int GET_NUMBER_OF_VEHICLE_NUMBER_PLATES();`
- **Purpose**: Returns total number of plate text styles available.
- **Parameters / Returns**:
  - **Returns**: Count of plate styles.
- **OneSync / Networking**: Pure lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: platecount
        -- Use: Show available number plate styles
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('platecount', function()
        TriggerEvent('chat:addMessage', { args = {'Plates', tostring(GetNumberOfVehicleNumberPlates())} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: platecount */
    RegisterCommand('platecount', () => {
      emit('chat:addMessage', { args: ['Plates', String(GetNumberOfVehicleNumberPlates())] });
    });
    ```
- **Caveats / Limitations**:
  - Does not include custom or addon plate types.
- **Reference**: https://docs.fivem.net/natives/?_0x4C4D6B2644F458CB

##### GetPedInVehicleSeat
- **Name**: GetPedInVehicleSeat
- **Scope**: Client
- **Signature**: `Ped GET_PED_IN_VEHICLE_SEAT(Vehicle vehicle, int seatIndex);`
- **Purpose**: Obtains the ped currently occupying a specific seat.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `seatIndex` (`int`): Seat index (-1 driver, etc.).
  - **Returns**: `Ped` handle or `0`.
- **OneSync / Networking**: Spawns ambient peds if seat empty; mark as mission entity to retain.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: seatped
        -- Use: Report ped in a given seat
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('seatped', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local seat = tonumber(args[1]) or -1
        if veh ~= 0 then
            local ped = GetPedInVehicleSeat(veh, seat)
            if ped ~= 0 then
                TriggerEvent('chat:addMessage', { args = {'Seat', ('Ped ID: %d'):format(ped)} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: seatped */
    RegisterCommand('seatped', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const seat = parseInt(args[0]) || -1;
      if (veh !== 0) {
        const ped = GetPedInVehicleSeat(veh, seat);
        if (ped !== 0) emit('chat:addMessage', { args: ['Seat', `Ped ID: ${ped}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - May spawn ambient ped occupants automatically.
- **Reference**: https://docs.fivem.net/natives/?_0xBB40DD2270B65366

##### GetPedUsingVehicleDoor
- **Name**: GetPedUsingVehicleDoor
- **Scope**: Client
- **Signature**: `Ped GET_PED_USING_VEHICLE_DOOR(Vehicle vehicle, int doorIndex);`
- **Purpose**: Returns the ped interacting with a specific vehicle door.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle handle.
  - `doorIndex` (`int`): eDoorId index.
  - **Returns**: `Ped` handle or `0`.
- **OneSync / Networking**: Requires vehicle to be streamed and door to exist.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: doorman
        -- Use: Identify ped using a vehicle door
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('doorman', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local door = tonumber(args[1]) or 0
        if veh ~= 0 then
            local ped = GetPedUsingVehicleDoor(veh, door)
            if ped ~= 0 then
                TriggerEvent('chat:addMessage', { args = {'Door', ('Ped ID: %d'):format(ped)} })
            end
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: doorman */
    RegisterCommand('doorman', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const door = parseInt(args[0]) || 0;
      if (veh !== 0) {
        const ped = GetPedUsingVehicleDoor(veh, door);
        if (ped !== 0) emit('chat:addMessage', { args: ['Door', `Ped ID: ${ped}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Door index must be valid for the vehicle model.
- **Reference**: https://docs.fivem.net/natives/?_0x218297BF0CFD853B

##### GetPositionInRecording
- **Name**: GetPositionInRecording
- **Scope**: Client
- **Signature**: `float GET_POSITION_IN_RECORDING(Vehicle vehicle);`
- **Purpose**: Returns the distance traveled in the vehicle's current recording.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with an active recording.
  - **Returns**: Distance along recording path.
- **OneSync / Networking**: Applies to local playback of recordings only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: recpos
        -- Use: Report current distance in vehicle recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('recpos', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local dist = GetPositionInRecording(veh)
            TriggerEvent('chat:addMessage', { args = {'Recording', ('%.2f'):format(dist)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: recpos */
    RegisterCommand('recpos', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const dist = GetPositionInRecording(veh);
        emit('chat:addMessage', { args: ['Recording', dist.toFixed(2)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if no recording is playing.
- **Reference**: https://docs.fivem.net/natives/?_0x2DACD605FC681475

##### GetPositionOfVehicleRecordingAtTime
- **Name**: GetPositionOfVehicleRecordingAtTime
- **Scope**: Client
- **Signature**: `Vector3 GET_POSITION_OF_VEHICLE_RECORDING_AT_TIME(int recording, float time, char* script);`
- **Purpose**: Provides the position of a vehicle recording at a specific time.
- **Parameters / Returns**:
  - `recording` (`int`): Recording index.
  - `time` (`float`): Playback time.
  - `script` (`char*`): Recording file name.
  - **Returns**: `vector3` position.
- **OneSync / Networking**: Local query; no replication.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: recat
        -- Use: Get position of a recording at time
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('recat', function(source, args)
        local id = tonumber(args[1]) or 1
        local t = tonumber(args[2]) or 0.0
        local pos = GetPositionOfVehicleRecordingAtTime(id, t, 'race1')
        TriggerEvent('chat:addMessage', { args = {'Pos', ('%.2f %.2f %.2f'):format(pos.x, pos.y, pos.z)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: recat */
    RegisterCommand('recat', (src, args) => {
      const id = parseInt(args[0]) || 1;
      const t = parseFloat(args[1]) || 0.0;
      const pos = GetPositionOfVehicleRecordingAtTime(id, t, 'race1');
      emit('chat:addMessage', { args: ['Pos', `${pos[0].toFixed(2)} ${pos[1].toFixed(2)} ${pos[2].toFixed(2)}`] });
    });
    ```
- **Caveats / Limitations**:
  - No interpolation between path points.
- **Reference**: https://docs.fivem.net/natives/?_0xD242728AA6F0FBA2

##### GetPositionOfVehicleRecordingIdAtTime
- **Name**: GetPositionOfVehicleRecordingIdAtTime
- **Scope**: Client
- **Signature**: `Vector3 GET_POSITION_OF_VEHICLE_RECORDING_ID_AT_TIME(int id, float time);`
- **Purpose**: Returns position from a recording by handle ID at a given time.
- **Parameters / Returns**:
  - `id` (`int`): Recording handle.
  - `time` (`float`): Playback time.
  - **Returns**: `vector3` position.
- **OneSync / Networking**: Local; no network effect.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: recidpos
        -- Use: Get position of recording by ID
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('recidpos', function(source, args)
        local id = tonumber(args[1]) or 1
        local t = tonumber(args[2]) or 0.0
        local pos = GetPositionOfVehicleRecordingIdAtTime(id, t)
        TriggerEvent('chat:addMessage', { args = {'Pos', ('%.2f %.2f %.2f'):format(pos.x, pos.y, pos.z)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: recidpos */
    RegisterCommand('recidpos', (src, args) => {
      const id = parseInt(args[0]) || 1;
      const t = parseFloat(args[1]) || 0.0;
      const pos = GetPositionOfVehicleRecordingIdAtTime(id, t);
      emit('chat:addMessage', { args: ['Pos', `${pos[0].toFixed(2)} ${pos[1].toFixed(2)} ${pos[2].toFixed(2)}`] });
    });
    ```
- **Caveats / Limitations**:
  - Recording must be requested beforehand.
- **Reference**: https://docs.fivem.net/natives/?_0x92523B76657A517D

##### GetRandomVehicleBackBumperInSphere
- **Name**: GetRandomVehicleBackBumperInSphere
- **Scope**: Client
- **Signature**: `Vehicle GET_RANDOM_VEHICLE_BACK_BUMPER_IN_SPHERE(float x, float y, float z, float radius, int p4, int p5, int p6);`
- **Purpose**: Retrieves a random vehicle whose rear bumper is within a sphere.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Sphere center.
  - `radius` (`float`): Search radius.
  - `p4`, `p5`, `p6` (`int`): Unknown flags.
  - **Returns**: Vehicle handle or `0`.
- **OneSync / Networking**: Only finds vehicles streamed to client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: backbump
        -- Use: Find a nearby vehicle by rear bumper
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('backbump', function()
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetRandomVehicleBackBumperInSphere(coords.x, coords.y, coords.z, 5.0, 0, 0, 0)
        if veh ~= 0 then
            local label = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
            TriggerEvent('chat:addMessage', { args = {'Vehicle', label} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: backbump */
    RegisterCommand('backbump', () => {
      const coords = GetEntityCoords(PlayerPedId(), false);
      const veh = GetRandomVehicleBackBumperInSphere(coords[0], coords[1], coords[2], 5.0, 0, 0, 0);
      if (veh !== 0) {
        const label = GetDisplayNameFromVehicleModel(GetEntityModel(veh));
        emit('chat:addMessage', { args: ['Vehicle', label] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Parameters `p4`–`p6` remain undocumented.
  - TODO(next-run): verify flag semantics.
- **Reference**: https://docs.fivem.net/natives/?_0xB50807EABE20A8DC

##### GetRandomVehicleFrontBumperInSphere
- **Name**: GetRandomVehicleFrontBumperInSphere
- **Scope**: Client
- **Signature**: `Vehicle GET_RANDOM_VEHICLE_FRONT_BUMPER_IN_SPHERE(float x, float y, float z, float radius, int p4, int p5, int p6);`
- **Purpose**: Retrieves a random vehicle whose front bumper lies within a sphere.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Sphere center.
  - `radius` (`float`): Search radius.
  - `p4`, `p5`, `p6` (`int`): Unknown flags.
  - **Returns**: Vehicle handle or `0`.
- **OneSync / Networking**: Only finds vehicles streamed to client.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: frontbump
        -- Use: Find a nearby vehicle by front bumper
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('frontbump', function()
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetRandomVehicleFrontBumperInSphere(coords.x, coords.y, coords.z, 5.0, 0, 0, 0)
        if veh ~= 0 then
            local label = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
            TriggerEvent('chat:addMessage', { args = {'Vehicle', label} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: frontbump */
    RegisterCommand('frontbump', () => {
      const coords = GetEntityCoords(PlayerPedId(), false);
      const veh = GetRandomVehicleFrontBumperInSphere(coords[0], coords[1], coords[2], 5.0, 0, 0, 0);
      if (veh !== 0) {
        const label = GetDisplayNameFromVehicleModel(GetEntityModel(veh));
        emit('chat:addMessage', { args: ['Vehicle', label] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Parameters `p4`–`p6` undocumented.
  - TODO(next-run): verify flag semantics.
- **Reference**: https://docs.fivem.net/natives/?_0xC5574E0AEB86BA68

##### GetRandomVehicleInSphere
- **Name**: GetRandomVehicleInSphere
- **Scope**: Client
- **Signature**: `Vehicle GET_RANDOM_VEHICLE_IN_SPHERE(float x, float y, float z, float radius, Hash modelHash, int flags);`
- **Purpose**: Selects a random vehicle within a sphere.
- **Parameters / Returns**:
  - `x`, `y`, `z` (`float`): Center coordinates.
  - `radius` (`float`): Search radius (max 9999.9004).
  - `modelHash` (`Hash`): Limit to model or 0 for any.
  - `flags` (`int`): Bitwise search flags.
  - **Returns**: Vehicle handle or `0`.
- **OneSync / Networking**: Only considers streamed vehicles; results vary by flags.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rveh
        -- Use: Find a random vehicle nearby
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rveh', function()
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetRandomVehicleInSphere(coords.x, coords.y, coords.z, 10.0, 0, 0)
        if veh ~= 0 then
            TriggerEvent('chat:addMessage', { args = {'Vehicle', GetDisplayNameFromVehicleModel(GetEntityModel(veh))} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rveh */
    RegisterCommand('rveh', () => {
      const coords = GetEntityCoords(PlayerPedId(), false);
      const veh = GetRandomVehicleInSphere(coords[0], coords[1], coords[2], 10.0, 0, 0);
      if (veh !== 0) {
        const label = GetDisplayNameFromVehicleModel(GetEntityModel(veh));
        emit('chat:addMessage', { args: ['Vehicle', label] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Flags modify search behaviour; see native docs for bits.
- **Reference**: https://docs.fivem.net/natives/?_0x386F6CE5BAF6091C

##### GetRandomVehicleModelInMemory
- **Name**: GetRandomVehicleModelInMemory
- **Scope**: Client
- **Signature**: `void GET_RANDOM_VEHICLE_MODEL_IN_MEMORY(BOOL p0, Hash* modelHash, int* successIndicator);`
- **Purpose**: Retrieves a random vehicle model currently loaded into memory.
- **Parameters / Returns**:
  - `p0` (`BOOL`): Typically `true`.
  - `modelHash` (`Hash*`): Output model hash.
  - `successIndicator` (`int*`): `0` on success, `-1` on failure.
- **OneSync / Networking**: Lookup is local; no network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: randmodel
        -- Use: Fetch a random loaded vehicle model
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('randmodel', function()
        local hashPtr = ffi.new('unsigned int[1]')
        local resPtr = ffi.new('int[1]')
        GetRandomVehicleModelInMemory(true, hashPtr, resPtr)
        if resPtr[0] == 0 then
            TriggerEvent('chat:addMessage', { args = {'Model', tostring(hashPtr[0])} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: randmodel */
    RegisterCommand('randmodel', () => {
      const hashBuf = new Uint32Array(1);
      const resBuf = new Int32Array(1);
      GetRandomVehicleModelInMemory(true, hashBuf, resBuf);
      if (resBuf[0] === 0) {
        emit('chat:addMessage', { args: ['Model', hashBuf[0].toString()] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Not present in retail; may always return failure.
- **Reference**: https://docs.fivem.net/natives/?_0x055BF0AC0C34F4FD

##### _GET_REMAINING_NITROUS_DURATION
- **Name**: _GET_REMAINING_NITROUS_DURATION
- **Scope**: Client
- **Signature**: `float _GET_REMAINING_NITROUS_DURATION(Vehicle vehicle);`
- **Purpose**: Retrieves remaining time for active nitrous boost.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle with nitrous system.
  - **Returns**: Remaining duration in seconds.
- **OneSync / Networking**: Requires vehicle to be owned; state replicated to passengers.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: nitrodur
        -- Use: Display remaining nitrous duration
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('nitrodur', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and IsNitrousActive(veh) then
            local timeLeft = GetRemainingNitrousDuration(veh)
            TriggerEvent('chat:addMessage', { args = {'Nitrous', ('%.2f s'):format(timeLeft)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: nitrodur */
    RegisterCommand('nitrodur', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && IsNitrousActive(veh)) {
        const timeLeft = GetRemainingNitrousDuration(veh);
        emit('chat:addMessage', { args: ['Nitrous', `${timeLeft.toFixed(2)} s`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if nitrous not installed or inactive.
- **Reference**: https://docs.fivem.net/natives/?_0xBEC4B8653462450E

##### GetRotationOfVehicleRecordingAtTime
- **Name**: GetRotationOfVehicleRecordingAtTime
- **Scope**: Client
- **Signature**: `Vector3 GET_ROTATION_OF_VEHICLE_RECORDING_AT_TIME(int recording, float time, char* script);`
- **Purpose**: Retrieves orientation of a vehicle recording at a specified time.
- **Parameters / Returns**:
  - `recording` (`int`): Recording index.
  - `time` (`float`): Playback time.
  - `script` (`char*`): Recording file name.
  - **Returns**: Euler rotation vector.
- **OneSync / Networking**: Local query only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: recrot
        -- Use: Get rotation of recording at time
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('recrot', function(source, args)
        local id = tonumber(args[1]) or 1
        local t = tonumber(args[2]) or 0.0
        local rot = GetRotationOfVehicleRecordingAtTime(id, t, 'race1')
        TriggerEvent('chat:addMessage', { args = {'Rot', ('%.2f %.2f %.2f'):format(rot.x, rot.y, rot.z)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: recrot */
    RegisterCommand('recrot', (src, args) => {
      const id = parseInt(args[0]) || 1;
      const t = parseFloat(args[1]) || 0.0;
      const rot = GetRotationOfVehicleRecordingAtTime(id, t, 'race1');
      emit('chat:addMessage', { args: ['Rot', `${rot[0].toFixed(2)} ${rot[1].toFixed(2)} ${rot[2].toFixed(2)}`] });
    });
    ```
- **Caveats / Limitations**:
  - Rotation is not interpolated between path points.
- **Reference**: https://docs.fivem.net/natives/?_0x2058206FBE79A8AD

##### GetRotationOfVehicleRecordingIdAtTime
- **Name**: GetRotationOfVehicleRecordingIdAtTime
- **Scope**: Client
- **Signature**: `Vector3 GET_ROTATION_OF_VEHICLE_RECORDING_ID_AT_TIME(int id, float time);`
- **Purpose**: Retrieves orientation from a recording handle at a specific time.
- **Parameters / Returns**:
  - `id` (`int`): Recording handle.
  - `time` (`float`): Playback time.
  - **Returns**: Euler rotation vector.
- **OneSync / Networking**: Local query.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: recidrot
        -- Use: Get rotation of recording by ID
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('recidrot', function(source, args)
        local id = tonumber(args[1]) or 1
        local t = tonumber(args[2]) or 0.0
        local rot = GetRotationOfVehicleRecordingIdAtTime(id, t)
        TriggerEvent('chat:addMessage', { args = {'Rot', ('%.2f %.2f %.2f'):format(rot.x, rot.y, rot.z)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: recidrot */
    RegisterCommand('recidrot', (src, args) => {
      const id = parseInt(args[0]) || 1;
      const t = parseFloat(args[1]) || 0.0;
      const rot = GetRotationOfVehicleRecordingIdAtTime(id, t);
      emit('chat:addMessage', { args: ['Rot', `${rot[0].toFixed(2)} ${rot[1].toFixed(2)} ${rot[2].toFixed(2)}`] });
    });
    ```
- **Caveats / Limitations**:
  - Recording must be requested and loaded.
- **Reference**: https://docs.fivem.net/natives/?_0xF0F2103EFAF8CBA7
##### GetSubmarineIsUnderDesignDepth
- **Name**: GetSubmarineIsUnderDesignDepth
- **Scope**: Client
- **Signature**: `BOOL GET_SUBMARINE_IS_UNDER_DESIGN_DEPTH(Vehicle submarine);`
- **Purpose**: Determines if the submarine is operating below its designated crush depth.
- **Parameters / Returns**:
  - `submarine` (`Vehicle`): Submarine vehicle to evaluate.
  - **Returns**: `bool` indicating unsafe depth.
- **OneSync / Networking**: Works on any streamed submarine; ownership not required.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: subcrush
        -- Use: Warns if current submarine is below design depth
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('subcrush', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 and GetSubmarineIsUnderDesignDepth(veh) then
            TriggerEvent('chat:addMessage', { args = {'Sub', 'Hull at risk'} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: subcrush */
    RegisterCommand('subcrush', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0 && GetSubmarineIsUnderDesignDepth(veh)) {
        emit('chat:addMessage', { args: ['Sub', 'Hull at risk'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only applicable to submarine models.
- **Reference**: https://docs.fivem.net/natives/?_0x3E71D0B300B7AA79

##### GetSubmarineNumberOfAirLeaks
- **Name**: GetSubmarineNumberOfAirLeaks
- **Scope**: Client
- **Signature**: `int GET_SUBMARINE_NUMBER_OF_AIR_LEAKS(Vehicle submarine);`
- **Purpose**: Returns how many active air leaks exist on a submarine.
- **Parameters / Returns**:
  - `submarine` (`Vehicle`): Submarine to inspect.
  - **Returns**: Leak count; excessive leaks will drown occupants.
- **OneSync / Networking**: Requires the submarine to be streamed.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: subleaks
        -- Use: Reports leak count for current submarine
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('subleaks', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local leaks = GetSubmarineNumberOfAirLeaks(veh)
            TriggerEvent('chat:addMessage', { args = {'Leaks', leaks} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: subleaks */
    RegisterCommand('subleaks', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const leaks = GetSubmarineNumberOfAirLeaks(veh);
        emit('chat:addMessage', { args: ['Leaks', leaks] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Leak threshold for drowning is engine-defined.
- **Reference**: https://docs.fivem.net/natives/?_0x093D6DDCA5B8FBAE

##### GetTimePositionInRecording
- **Name**: GetTimePositionInRecording
- **Scope**: Client
- **Signature**: `float GET_TIME_POSITION_IN_RECORDING(Vehicle vehicle);`
- **Purpose**: Obtains current playback time for a vehicle recording.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle playing a recording.
  - **Returns**: Time elapsed in seconds.
- **OneSync / Networking**: Local to the client; recordings are not networked.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: rectime
        -- Use: Reports current time of a vehicle recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('rectime', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local t = GetTimePositionInRecording(veh)
            TriggerEvent('chat:addMessage', { args = {'Recording', ('%.2f s'):format(t)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: rectime */
    RegisterCommand('rectime', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const t = GetTimePositionInRecording(veh);
        emit('chat:addMessage', { args: ['Recording', `${t.toFixed(2)} s`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires a recording started with `StartPlaybackRecordedVehicle`.
- **Reference**: https://docs.fivem.net/natives/?_0x5746F3A7AB7FE544

##### GetTotalDurationOfVehicleRecording
- **Name**: GetTotalDurationOfVehicleRecording
- **Scope**: Client
- **Signature**: `float GET_TOTAL_DURATION_OF_VEHICLE_RECORDING(int recording, char* script);`
- **Purpose**: Retrieves total length of a vehicle recording defined by script and index.
- **Parameters / Returns**:
  - `recording` (`int`): Recording index.
  - `script` (`string`): Recording file name.
  - **Returns**: Duration in seconds.
- **OneSync / Networking**: Local query; recordings are not synchronized.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: reclen
        -- Use: Shows total duration of a vehicle recording
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('reclen', function(source, args)
        local id = tonumber(args[1]) or 1
        local len = GetTotalDurationOfVehicleRecording(id, 'race1')
        TriggerEvent('chat:addMessage', { args = {'Recording', ('%.2f s'):format(len)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: reclen */
    RegisterCommand('reclen', (src, args) => {
      const id = parseInt(args[0]) || 1;
      const len = GetTotalDurationOfVehicleRecording(id, 'race1');
      emit('chat:addMessage', { args: ['Recording', `${len.toFixed(2)} s`] });
    });
    ```
- **Caveats / Limitations**:
  - Recording must be loaded prior to querying length.
- **Reference**: https://docs.fivem.net/natives/?_0x0E48D1C262390950

##### GetTotalDurationOfVehicleRecordingId
- **Name**: GetTotalDurationOfVehicleRecordingId
- **Scope**: Client
- **Signature**: `float GET_TOTAL_DURATION_OF_VEHICLE_RECORDING_ID(int id);`
- **Purpose**: Retrieves total length from an active recording handle.
- **Parameters / Returns**:
  - `id` (`int`): Recording handle obtained from `OpenVehicleRecording`.
  - **Returns**: Duration in seconds.
- **OneSync / Networking**: Local operation without network impact.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: recidlen
        -- Use: Shows total duration of a recording handle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('recidlen', function(source, args)
        local id = tonumber(args[1]) or 1
        local len = GetTotalDurationOfVehicleRecordingId(id)
        TriggerEvent('chat:addMessage', { args = {'Recording', ('%.2f s'):format(len)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: recidlen */
    RegisterCommand('recidlen', (src, args) => {
      const id = parseInt(args[0]) || 1;
      const len = GetTotalDurationOfVehicleRecordingId(id);
      emit('chat:addMessage', { args: ['Recording', `${len.toFixed(2)} s`] });
    });
    ```
- **Caveats / Limitations**:
  - Recording handle must be valid.
- **Reference**: https://docs.fivem.net/natives/?_0x102D125411A7B6E6

##### GetTrainCarriage
- **Name**: GetTrainCarriage
- **Scope**: Client
- **Signature**: `Entity GET_TRAIN_CARRIAGE(Vehicle train, int trailerNumber);`
- **Purpose**: Fetches a specific carriage entity from a train.
- **Parameters / Returns**:
  - `train` (`Vehicle`): Train engine entity.
  - `trailerNumber` (`int`): 1-based carriage index.
  - **Returns**: Carriage `Entity` handle or 0.
- **OneSync / Networking**: Requires train to be streamed; remote carriages may not be available.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: traincar
        -- Use: Prints model of a specified train carriage
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('traincar', function(source, args)
        local train = GetVehiclePedIsIn(PlayerPedId(), false)
        local idx = tonumber(args[1]) or 1
        local car = GetTrainCarriage(train, idx)
        if car ~= 0 then
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(car))
            TriggerEvent('chat:addMessage', { args = {'Carriage', model} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: traincar */
    RegisterCommand('traincar', (src, args) => {
      const train = GetVehiclePedIsIn(PlayerPedId(), false);
      const idx = parseInt(args[0]) || 1;
      const car = GetTrainCarriage(train, idx);
      if (car !== 0) {
        const model = GetDisplayNameFromVehicleModel(GetEntityModel(car));
        emit('chat:addMessage', { args: ['Carriage', model] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Indexing starts at 1 for trailers; 0 returns engine.
- **Reference**: https://docs.fivem.net/natives/?_0x08AAFD0814722BC3

##### _GET_TYRE_HEALTH
- **Name**: _GET_TYRE_HEALTH
- **Scope**: Client
- **Signature**: `float _GET_TYRE_HEALTH(Vehicle vehicle, int wheelIndex);`
- **Purpose**: Retrieves health value for a specific wheel.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `wheelIndex` (`int`): Wheel slot index.
  - **Returns**: Health value (0.0–1.0).
- **OneSync / Networking**: Accurate only for owned vehicles with wheel data.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tyrehealth
        -- Use: Displays tyre health for the specified wheel
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tyrehealth', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local idx = tonumber(args[1]) or 0
        if veh ~= 0 then
            local health = GetTyreHealth(veh, idx)
            TriggerEvent('chat:addMessage', { args = {'Tyre', ('%.2f'):format(health)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tyrehealth */
    RegisterCommand('tyrehealth', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const idx = parseInt(args[0]) || 0;
      if (veh !== 0) {
        const health = GetTyreHealth(veh, idx);
        emit('chat:addMessage', { args: ['Tyre', health.toFixed(2)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Wheel indices vary by vehicle model.
- **Reference**: https://docs.fivem.net/natives/?_0x55EAB010FAEE9380

##### _GET_TYRE_WEAR_MULTIPLIER
- **Name**: _GET_TYRE_WEAR_MULTIPLIER
- **Scope**: Client
- **Signature**: `float _GET_TYRE_WEAR_MULTIPLIER(Vehicle vehicle, int wheelIndex);`
- **Purpose**: Returns wear multiplier affecting tyre degradation.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `wheelIndex` (`int`): Wheel slot index.
  - **Returns**: Wear multiplier.
- **OneSync / Networking**: Values may desync for non-owned vehicles.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: tyrewear
        -- Use: Shows wear multiplier for a tyre
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('tyrewear', function(source, args)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local idx = tonumber(args[1]) or 0
        if veh ~= 0 then
            local wear = GetTyreWearMultiplier(veh, idx)
            TriggerEvent('chat:addMessage', { args = {'TyreWear', ('%.2f'):format(wear)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: tyrewear */
    RegisterCommand('tyrewear', (src, args) => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      const idx = parseInt(args[0]) || 0;
      if (veh !== 0) {
        const wear = GetTyreWearMultiplier(veh, idx);
        emit('chat:addMessage', { args: ['TyreWear', wear.toFixed(2)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Requires racing DLC vehicles for meaningful values.
- **Reference**: https://docs.fivem.net/natives/?_0x6E387895952F4F71

##### GetVehicleAcceleration
- **Name**: GetVehicleAcceleration
- **Scope**: Client
- **Signature**: `float GET_VEHICLE_ACCELERATION(Vehicle vehicle);`
- **Purpose**: Returns the maximum drive force value of a vehicle including modifications.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - **Returns**: Acceleration value as float.
- **OneSync / Networking**: Snapshot only; not replicated to others.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehaccel
        -- Use: Reports acceleration stat for current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehaccel', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local accel = GetVehicleAcceleration(veh)
            TriggerEvent('chat:addMessage', { args = {'Accel', ('%.2f'):format(accel)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehaccel */
    RegisterCommand('vehaccel', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const accel = GetVehicleAcceleration(veh);
        emit('chat:addMessage', { args: ['Accel', accel.toFixed(2)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Does not reflect real-time speed or traction.
- **Reference**: https://docs.fivem.net/natives/?_0x5DD35C8D074E57AE

##### GetVehicleAttachedToCargobob
- **Name**: GetVehicleAttachedToCargobob
- **Scope**: Client
- **Signature**: `Vehicle GET_VEHICLE_ATTACHED_TO_CARGOBOB(Vehicle cargobob);`
- **Purpose**: Returns vehicle currently hooked to a cargobob.
- **Parameters / Returns**:
  - `cargobob` (`Vehicle`): Cargobob helicopter.
  - **Returns**: Attached vehicle handle or 0.
- **OneSync / Networking**: Requires ownership of cargobob for up-to-date attachment state.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: cargoload
        -- Use: Reports model attached to current cargobob
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('cargoload', function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        local veh = GetVehicleAttachedToCargobob(heli)
        if veh ~= 0 then
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
            TriggerEvent('chat:addMessage', { args = {'Cargo', model} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: cargoload */
    RegisterCommand('cargoload', () => {
      const heli = GetVehiclePedIsIn(PlayerPedId(), false);
      const veh = GetVehicleAttachedToCargobob(heli);
      if (veh !== 0) {
        const model = GetDisplayNameFromVehicleModel(GetEntityModel(veh));
        emit('chat:addMessage', { args: ['Cargo', model] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns 0 if no vehicle is attached or if the entity is not a cargobob.
- **Reference**: https://docs.fivem.net/natives/?_0x873B82D42AC2B9E5

##### GetVehicleBodyHealth
- **Name**: GetVehicleBodyHealth
- **Scope**: Client
- **Signature**: `float GET_VEHICLE_BODY_HEALTH(Vehicle vehicle);`
- **Purpose**: Retrieves body integrity value of a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - **Returns**: Health from 0.0 to 1000.0.
- **OneSync / Networking**: Works on both owned and remote vehicles but may lag on remote.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: bodyhp
        -- Use: Reports body health of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('bodyhp', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local hp = GetVehicleBodyHealth(veh)
            TriggerEvent('chat:addMessage', { args = {'Body', ('%.1f'):format(hp)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: bodyhp */
    RegisterCommand('bodyhp', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const hp = GetVehicleBodyHealth(veh);
        emit('chat:addMessage', { args: ['Body', hp.toFixed(1)] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Vehicle may still operate when health is 0.
- **Reference**: https://docs.fivem.net/natives/?_0xF271147EB7B40F12

##### _GET_VEHICLE_BOMB_COUNT
- **Name**: _GET_VEHICLE_BOMB_COUNT
- **Scope**: Client
- **Signature**: `int _GET_VEHICLE_BOMB_COUNT(Vehicle aircraft);`
- **Purpose**: Returns remaining bombs on a compatible aircraft.
- **Parameters / Returns**:
  - `aircraft` (`Vehicle`): Plane equipped with bomb bay.
  - **Returns**: Bomb count.
- **OneSync / Networking**: Syncs with passengers; owner must manage decrementing when bombs dropped.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: bombcount
        -- Use: Displays remaining aircraft bombs
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('bombcount', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local count = GetVehicleBombCount(veh)
            TriggerEvent('chat:addMessage', { args = {'Bombs', count} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: bombcount */
    RegisterCommand('bombcount', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const count = GetVehicleBombCount(veh);
        emit('chat:addMessage', { args: ['Bombs', count] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Does not decrement automatically when bombs are dropped via weapons API.
- **Reference**: https://docs.fivem.net/natives/?_0xEA12BD130D7569A1

##### _GET_VEHICLE_CAN_ACTIVATE_PARACHUTE
- **Name**: _GET_VEHICLE_CAN_ACTIVATE_PARACHUTE
- **Scope**: Client
- **Signature**: `BOOL _GET_VEHICLE_CAN_ACTIVATE_PARACHUTE(Vehicle vehicle);`
- **Purpose**: Checks if a vehicle's deployable parachute is ready.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to query.
  - **Returns**: `bool`.
- **OneSync / Networking**: State is local; ensure ownership for accurate result.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: canpara
        -- Use: Indicates if current vehicle can deploy parachute
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('canpara', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local ready = GetVehicleCanActivateParachute(veh)
            TriggerEvent('chat:addMessage', { args = {'Parachute', tostring(ready)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: canpara */
    RegisterCommand('canpara', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const ready = GetVehicleCanActivateParachute(veh);
        emit('chat:addMessage', { args: ['Parachute', ready ? 'true' : 'false'] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Only relevant for vehicles with parachute mod installed.
- **Reference**: https://docs.fivem.net/natives/?_0xA916396DF4154EE3

##### GetVehicleCauseOfDestruction
- **Name**: GetVehicleCauseOfDestruction
- **Scope**: Client
- **Signature**: `Hash GET_VEHICLE_CAUSE_OF_DESTRUCTION(Vehicle vehicle);`
- **Purpose**: Provides weapon or entity hash responsible for destroying a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Destroyed vehicle handle.
  - **Returns**: Hash for cause; 0 if unknown.
- **OneSync / Networking**: Accurate only on the owner that witnessed destruction.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehcause
        -- Use: Reports destruction cause of last driven vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehcause', function()
        local veh = GetLastDrivenVehicle()
        if veh ~= 0 then
            local cause = GetVehicleCauseOfDestruction(veh)
            TriggerEvent('chat:addMessage', { args = {'Cause', tostring(cause)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehcause */
    RegisterCommand('vehcause', () => {
      const veh = GetLastDrivenVehicle();
      if (veh !== 0) {
        const cause = GetVehicleCauseOfDestruction(veh);
        emit('chat:addMessage', { args: ['Cause', `${cause}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Causes may map to weapon hashes; translation required.
- **Reference**: https://docs.fivem.net/natives/?_0xE495D1EF4C91FD20

##### GetVehicleClass
- **Name**: GetVehicleClass
- **Scope**: Client
- **Signature**: `int GET_VEHICLE_CLASS(Vehicle vehicle);`
- **Purpose**: Returns the numeric class identifier for a vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to classify.
  - **Returns**: Class ID (0–22).
- **OneSync / Networking**: Static lookup; no sync concerns.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehclass
        -- Use: Displays class ID for current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehclass', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local class = GetVehicleClass(veh)
            TriggerEvent('chat:addMessage', { args = {'Class', class} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehclass */
    RegisterCommand('vehclass', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const cls = GetVehicleClass(veh);
        emit('chat:addMessage', { args: ['Class', cls] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Use `_GET_LABEL_TEXT` to resolve class names.
- **Reference**: https://docs.fivem.net/natives/?_0x29439776AAA00A62

##### GetVehicleClassEstimatedMaxSpeed
- **Name**: GetVehicleClassEstimatedMaxSpeed
- **Scope**: Client
- **Signature**: `float GET_VEHICLE_CLASS_ESTIMATED_MAX_SPEED(int vehicleClass);`
- **Purpose**: Provides rough top-speed estimate for a vehicle class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: Estimated speed in m/s.
- **OneSync / Networking**: Pure lookup with no networking.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: classspeed
        -- Use: Shows estimated max speed for a vehicle class
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('classspeed', function(source, args)
        local class = tonumber(args[1]) or 0
        local speed = GetVehicleClassEstimatedMaxSpeed(class)
        TriggerEvent('chat:addMessage', { args = {'MaxSpeed', ('%.1f'):format(speed)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: classspeed */
    RegisterCommand('classspeed', (src, args) => {
      const cls = parseInt(args[0]) || 0;
      const speed = GetVehicleClassEstimatedMaxSpeed(cls);
      emit('chat:addMessage', { args: ['MaxSpeed', speed.toFixed(1)] });
    });
    ```
- **Caveats / Limitations**:
  - Estimates ignore modifications.
- **Reference**: https://docs.fivem.net/natives/?_0x00C09F246ABEDD82

##### GetVehicleClassFromName
- **Name**: GetVehicleClassFromName
- **Scope**: Client
- **Signature**: `int GET_VEHICLE_CLASS_FROM_NAME(Hash modelHash);`
- **Purpose**: Resolves class ID from a vehicle model hash.
- **Parameters / Returns**:
  - `modelHash` (`Hash`): Vehicle model identifier.
- **Returns**: Class ID.
- **OneSync / Networking**: None; uses static lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: classfromname
        -- Use: Shows class ID for a model name
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('classfromname', function(source, args)
        local name = args[1] or 'adder'
        local class = GetVehicleClassFromName(GetHashKey(name))
        TriggerEvent('chat:addMessage', { args = {'Class', class} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: classfromname */
    RegisterCommand('classfromname', (src, args) => {
      const name = args[0] || 'adder';
      const cls = GetVehicleClassFromName(GetHashKey(name));
      emit('chat:addMessage', { args: ['Class', cls] });
    });
    ```
- **Caveats / Limitations**:
  - Model must be loaded or present in game data.
- **Reference**: https://docs.fivem.net/natives/?_0xDEDF1C8BD47C2200

##### GetVehicleClassMaxAcceleration
- **Name**: GetVehicleClassMaxAcceleration
- **Scope**: Client
- **Signature**: `float GET_VEHICLE_CLASS_MAX_ACCELERATION(int vehicleClass);`
- **Purpose**: Returns peak acceleration characteristic for a vehicle class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: Acceleration value.
- **OneSync / Networking**: Static lookup; not networked.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: classaccel
        -- Use: Shows max acceleration value for a class
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('classaccel', function(source, args)
        local class = tonumber(args[1]) or 0
        local accel = GetVehicleClassMaxAcceleration(class)
        TriggerEvent('chat:addMessage', { args = {'Accel', ('%.2f'):format(accel)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: classaccel */
    RegisterCommand('classaccel', (src, args) => {
      const cls = parseInt(args[0]) || 0;
      const accel = GetVehicleClassMaxAcceleration(cls);
      emit('chat:addMessage', { args: ['Accel', accel.toFixed(2)] });
    });
    ```
- **Caveats / Limitations**:
  - Value is theoretical and not affected by mods.
- **Reference**: https://docs.fivem.net/natives/?_0x2F83E7E45D9EA7AE

##### GetVehicleClassMaxAgility
- **Name**: GetVehicleClassMaxAgility
- **Scope**: Client
- **Signature**: `float GET_VEHICLE_CLASS_MAX_AGILITY(int vehicleClass);`
- **Purpose**: Returns agility stat for given vehicle class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: Agility value.
- **OneSync / Networking**: Pure lookup.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: classagility
        -- Use: Displays agility stat for a class
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('classagility', function(source, args)
        local class = tonumber(args[1]) or 0
        local ag = GetVehicleClassMaxAgility(class)
        TriggerEvent('chat:addMessage', { args = {'Agility', ('%.2f'):format(ag)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: classagility */
    RegisterCommand('classagility', (src, args) => {
      const cls = parseInt(args[0]) || 0;
      const ag = GetVehicleClassMaxAgility(cls);
      emit('chat:addMessage', { args: ['Agility', ag.toFixed(2)] });
    });
    ```
- **Caveats / Limitations**:
  - Used mostly for AI handling; gameplay use limited.
- **Reference**: https://docs.fivem.net/natives/?_0x4F930AD022D6DE3B

##### GetVehicleClassMaxBraking
- **Name**: GetVehicleClassMaxBraking
- **Scope**: Client
- **Signature**: `float GET_VEHICLE_CLASS_MAX_BRAKING(int vehicleClass);`
- **Purpose**: Provides theoretical braking value for a class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: Braking force value.
- **OneSync / Networking**: Static data; not replicated.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: classbrake
        -- Use: Shows max braking for a class
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('classbrake', function(source, args)
        local class = tonumber(args[1]) or 0
        local brake = GetVehicleClassMaxBraking(class)
        TriggerEvent('chat:addMessage', { args = {'Braking', ('%.2f'):format(brake)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: classbrake */
    RegisterCommand('classbrake', (src, args) => {
      const cls = parseInt(args[0]) || 0;
      const brake = GetVehicleClassMaxBraking(cls);
      emit('chat:addMessage', { args: ['Braking', brake.toFixed(2)] });
    });
    ```
- **Caveats / Limitations**:
  - Represents maximum possible braking, not current state.
- **Reference**: https://docs.fivem.net/natives/?_0x4BF54C16EC8FEC03

##### GetVehicleClassMaxTraction
- **Name**: GetVehicleClassMaxTraction
- **Scope**: Client
- **Signature**: `float GET_VEHICLE_CLASS_MAX_TRACTION(int vehicleClass);`
- **Purpose**: Returns highest traction value for a class.
- **Parameters / Returns**:
  - `vehicleClass` (`int`): Class ID.
  - **Returns**: Traction stat.
- **OneSync / Networking**: Lookup only.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: classtraction
        -- Use: Shows max traction for a class
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('classtraction', function(source, args)
        local class = tonumber(args[1]) or 0
        local tr = GetVehicleClassMaxTraction(class)
        TriggerEvent('chat:addMessage', { args = {'Traction', ('%.2f'):format(tr)} })
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: classtraction */
    RegisterCommand('classtraction', (src, args) => {
      const cls = parseInt(args[0]) || 0;
      const tr = GetVehicleClassMaxTraction(cls);
      emit('chat:addMessage', { args: ['Traction', tr.toFixed(2)] });
    });
    ```
- **Caveats / Limitations**:
  - Not affected by weather or surface conditions.
- **Reference**: https://docs.fivem.net/natives/?_0xDBC86D85C5059461

##### GetVehicleColor
- **Name**: GetVehicleColor
- **Scope**: Client
- **Signature**: `void GET_VEHICLE_COLOR(Vehicle vehicle, int* r, int* g, int* b);`
- **Purpose**: Retrieves the RGB color applied to a vehicle's paint.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to read.
  - `r` (`int`): Primary red component.
  - `g` (`int`): Primary green component.
  - `b` (`int`): Primary blue component.
  - **Returns**: None.
- **OneSync / Networking**: Requires ownership for accurate values.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehcolor
        -- Use: Displays RGB color of current vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehcolor', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local r,g,b = 0,0,0
            r,g,b = GetVehicleColor(veh)
            TriggerEvent('chat:addMessage', { args = {'Color', ("%d %d %d"):format(r,g,b)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehcolor */
    RegisterCommand('vehcolor', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const [r, g, b] = GetVehicleColor(veh);
        emit('chat:addMessage', { args: ['Color', `${r} ${g} ${b}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns stock color even if custom color set; use `GetVehicleCustomPrimaryColour` for custom values.
- **Reference**: https://docs.fivem.net/natives/?_0xF3CC740D36221548

##### GetVehicleColourCombination
- **Name**: GetVehicleColourCombination
- **Scope**: Client
- **Signature**: `int GET_VEHICLE_COLOUR_COMBINATION(Vehicle vehicle);`
- **Purpose**: Retrieves index of preset colour combination applied to vehicle.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: Combination index.
- **OneSync / Networking**: Local lookup; combination sync handled automatically.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: colourcombo
        -- Use: Shows colour combination index
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('colourcombo', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local combo = GetVehicleColourCombination(veh)
            TriggerEvent('chat:addMessage', { args = {'Combo', combo} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: colourcombo */
    RegisterCommand('colourcombo', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const combo = GetVehicleColourCombination(veh);
        emit('chat:addMessage', { args: ['Combo', combo] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Custom colours may not map to preset indices.
- **Reference**: https://docs.fivem.net/natives/?_0x6A842D197F845D56

##### GetVehicleColours
- **Name**: GetVehicleColours
- **Scope**: Client
- **Signature**: `void GET_VEHICLE_COLOURS(Vehicle vehicle, int* colorPrimary, int* colorSecondary);`
- **Purpose**: Retrieves primary and secondary paint indices.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to inspect.
  - `colorPrimary` (`int*`): Primary colour index.
  - `colorSecondary` (`int*`): Secondary colour index.
  - **Returns**: None.
- **OneSync / Networking**: Accurate for owned vehicles; remote ones may lag.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: vehcolours
        -- Use: Lists colour indices for vehicle
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('vehcolours', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local p,s = GetVehicleColours(veh)
            TriggerEvent('chat:addMessage', { args = {'Colours', (p .. ' / ' .. s)} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: vehcolours */
    RegisterCommand('vehcolours', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const [p, s] = GetVehicleColours(veh);
        emit('chat:addMessage', { args: ['Colours', `${p} / ${s}`] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Returns mod kit indices, not RGB values.
- **Reference**: https://docs.fivem.net/natives/?_0xA19435F193E081AC

##### GetVehicleColoursWhichCanBeSet
- **Name**: GetVehicleColoursWhichCanBeSet
- **Scope**: Client
- **Signature**: `int GET_VEHICLE_COLOURS_WHICH_CAN_BE_SET(Vehicle vehicle);`
- **Purpose**: Returns bitfield indicating which colour slots are supported.
- **Parameters / Returns**:
  - `vehicle` (`Vehicle`): Vehicle to check.
  - **Returns**: Bitmask of available colour slots.
- **OneSync / Networking**: Depends on shader; consistent across clients.
- **Examples**:
  - Lua:
    ```lua
    --[[
        -- Type: Command
        -- Name: colourscan
        -- Use: Displays colour capability bitmask
        -- Created: 2025-09-12
        -- By: VSSVSSN
    --]]
    RegisterCommand('colourscan', function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            local mask = GetVehicleColoursWhichCanBeSet(veh)
            TriggerEvent('chat:addMessage', { args = {'ColourMask', mask} })
        end
    end)
    ```
  - JavaScript:
    ```javascript
    /* Command: colourscan */
    RegisterCommand('colourscan', () => {
      const veh = GetVehiclePedIsIn(PlayerPedId(), false);
      if (veh !== 0) {
        const mask = GetVehicleColoursWhichCanBeSet(veh);
        emit('chat:addMessage', { args: ['ColourMask', mask] });
      }
    });
    ```
- **Caveats / Limitations**:
  - Bit meanings vary; refer to enum for flags.
- **Reference**: https://docs.fivem.net/natives/?_0xEEBFC7A7EFDC35B4

CONTINUE-HERE — 2025-09-12T22:43:32+00:00 — next: Vehicle :: GetVehicleCountermeasureCount
