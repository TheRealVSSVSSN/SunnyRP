| Overall | 6442 | 933 | 5509 | 2025-09-12T17:02:12+00:00 |
| Vehicle | 751 | 602 | 149 | 2025-09-12T17:02:12+00:00 |
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

CONTINUE-HERE — 2025-09-12T17:02:12+00:00 — next: Vehicle :: SetVehicleHasBeenDrivenFlag
