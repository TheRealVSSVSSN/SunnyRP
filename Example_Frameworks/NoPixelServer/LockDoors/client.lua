--[[
    -- Type: Resource
    -- Name: LockDoors
    -- Use: Handles vehicle locking and unlocking with sound and light feedback
    -- Created: 2025-05-18
    -- By: VSSVSSN
--]]

local playSound = true

--[[
    -- Type: Function
    -- Name: getVehicleInDirection
    -- Use: Returns a vehicle entity in the direction between two coordinates
    -- Created: 2025-05-18
    -- By: VSSVSSN
--]]
local function getVehicleInDirection(from, to)
    local ray = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, 10, PlayerPedId(), 0)
    local _, hit, _, _, entity = GetShapeTestResult(ray)

    if hit == 1 and entity ~= 0 then
        local distance = #(from - GetEntityCoords(entity))
        if distance <= 25.0 then
            return entity
        end
    end

    return 0
end

--[[
    -- Type: Function
    -- Name: flashVehicleLights
    -- Use: Flashes vehicle lights to indicate lock or unlock state
    -- Created: 2025-05-18
    -- By: VSSVSSN
--]]
local function flashVehicleLights(vehicle, unlocking)
    SetVehicleLights(vehicle, 2)
    SetVehicleBrakeLights(vehicle, true)
    SetVehicleInteriorlight(vehicle, true)
    SetVehicleIndicatorLights(vehicle, 0, true)
    SetVehicleIndicatorLights(vehicle, 1, true)

    if unlocking then SetVehicleFullbeam(vehicle, true) end

    Wait(450)
    SetVehicleIndicatorLights(vehicle, 0, false)
    SetVehicleIndicatorLights(vehicle, 1, false)
    Wait(450)
    SetVehicleIndicatorLights(vehicle, 0, true)
    SetVehicleIndicatorLights(vehicle, 1, true)
    Wait(450)

    SetVehicleLights(vehicle, 0)
    SetVehicleBrakeLights(vehicle, false)
    SetVehicleInteriorlight(vehicle, false)
    SetVehicleIndicatorLights(vehicle, 0, false)
    SetVehicleIndicatorLights(vehicle, 1, false)

    if unlocking then SetVehicleFullbeam(vehicle, false) end
end

--[[
    -- Type: Event
    -- Name: keys:unlockDoor
    -- Use: Toggles vehicle door locks and triggers lights/sounds
    -- Created: 2025-05-18
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:unlockDoor', function(vehicle, allow)
    if not allow then return end

    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped, false)
    local status = GetVehicleDoorLockStatus(vehicle)

    TriggerEvent('dooranim')

    if status == 1 or status == 0 then
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
        if playSound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lock', 0.4)
        end
        if not inVehicle then
            flashVehicleLights(vehicle, false)
        end
    else
        SetVehicleDoorsLocked(vehicle, 1)
        if playSound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'unlock', 0.1)
        end
        if not inVehicle then
            flashVehicleLights(vehicle, true)
        end
    end
end)

--[[
    -- Type: Event
    -- Name: event:control:cardoors
    -- Use: Initiates door lock check on the nearest vehicle
    -- Created: 2025-05-18
    -- By: VSSVSSN
--]]
RegisterNetEvent('event:control:cardoors', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)

    if vehicle == 0 then
        local from = GetEntityCoords(ped)
        local to = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
        vehicle = getVehicleInDirection(from, to)
    end

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        TriggerEvent('keys:hasKeys', 'doors', vehicle)
    end

    Wait(500)
end)
