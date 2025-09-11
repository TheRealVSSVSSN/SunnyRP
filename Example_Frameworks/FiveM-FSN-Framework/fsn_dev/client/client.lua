--  -------------------
--  BEGIN:       Locals
--  -------------------

--  -------------------
--  END:         Locals
--  -------------------

--  -------------------
--  BEGIN:      Threads
--  -------------------

--  -------------------
--  END:        Threads
--  -------------------

--[[
    -- Type: Function
    -- Name: loadModel
    -- Use: Requests and loads a model into memory
    -- Created: 2024-07-02
    -- By: VSSVSSN
--]]
local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
    end
    return hash
end

--[[
    -- Type: Function
    -- Name: SpawnVehicle
    -- Use: Spawns a vehicle at the specified coordinates
    -- Created: 2024-07-02
    -- By: VSSVSSN
--]]
local function SpawnVehicle(model, coordinates, heading, licensePlate)
    local hash = loadModel(model)
    local vehicle = CreateVehicle(hash, coordinates.x, coordinates.y, coordinates.z, heading, true, true)

    SetEntityAsMissionEntity(vehicle, true, true)

    if licensePlate then
        SetVehicleNumberPlateText(vehicle, licensePlate)
    end

    SetModelAsNoLongerNeeded(hash)

    return vehicle
end

--[[
    -- Type: Function
    -- Name: getVehicleInDirection
    -- Use: Returns entity handle of vehicle in raycast
    -- Created: 2024-07-02
    -- By: VSSVSSN
--]]
local function getVehicleInDirection(coordFrom, coordTo)
    local playerPed = PlayerPedId()
    local rayHandle = StartShapeTestRay(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, playerPed, 0)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

--[[
    -- Type: Function
    -- Name: lookingAt
    -- Use: Finds vehicle player is looking at
    -- Created: 2024-07-02
    -- By: VSSVSSN
--]]
local function lookingAt()
    local playerPed = PlayerPedId()
    local coordA = GetEntityCoords(playerPed, false)
    local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 20.0, -1.0)
    return getVehicleInDirection(coordA, coordB)
end

--  -------------------
--  END:      Functions
--  -------------------

--  -------------------
--  BEGIN:      Exports
--  -------------------

--  -------------------
--  END:        Exports
--  -------------------

--  -------------------
--  BEGIN:       Events
--  -------------------

RegisterNetEvent('fsn_developer:deleteVehicle')
AddEventHandler('fsn_developer:deleteVehicle', function()

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) then

        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)

    else

        local vehicle = lookingAt()
        if vehicle ~= 0 then
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
        end

    end

end)

RegisterNetEvent('fsn_developer:spawnVehicle')
AddEventHandler('fsn_developer:spawnVehicle', function(vehmodel)

    local playerPed     = PlayerPedId()
    local playerCoords  = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local model         = vehmodel
    local devPlate      = ' DevCar '
    local vehicle       = SpawnVehicle(model, playerCoords, playerHeading, devPlate)

    SetVehicleOnGroundProperly(vehicle)

    --exports['LegacyFuel']:SetFuel(vehicle, 100)

    SetVehicleNumberPlateTextIndex(vehicle, 4)
    SetPedIntoVehicle(playerPed, vehicle, -1)

    TriggerEvent('fsn_cargarage:makeMine', vehicle, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), GetVehicleNumberPlateText(vehicle))

    TriggerEvent('fsn_notify:displayNotification', 'You now own this vehicle!', 'centerLeft', 4000, 'success')
    TriggerEvent('fsn_notify:displayNotification', 'You spawned '..model, 'centerLeft', 2000, 'info')

end)

RegisterNetEvent('fsn_developer:fixVehicle')
AddEventHandler('fsn_developer:fixVehicle', function()

    local playerPed     = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)

    if vehicle ~= 0 then

        TriggerEvent('fsn_fuel:update', vehicle, 100)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0)
        
    end


end)

RegisterNetEvent('fsn_developer:getKeys')
AddEventHandler('fsn_developer:getKeys', function()

    local playerPed     = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)

    if vehicle ~= 0 then

		TriggerEvent('fsn_cargarage:makeMine', vehicle, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), GetVehicleNumberPlateText(vehicle))
		TriggerEvent('fsn_notify:displayNotification', 'You now own this vehicle!', 'centerLeft', 4000, 'success')
        
    end


end)

RegisterNetEvent('fsn_developer:sendXYZ')
AddEventHandler('fsn_developer:sendXYZ', function()

    local playerPed = PlayerPedId()
    local x, y, z   = table.unpack(GetEntityCoords(playerPed, true))
    local h         = GetEntityHeading(playerPed)

    TriggerServerEvent('fsn_developer:printXYZ', x, y, z, h)

end)

--  -------------------
--  END:         Events
--  -------------------

