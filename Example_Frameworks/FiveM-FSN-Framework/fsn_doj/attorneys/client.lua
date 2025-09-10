--[[
    -- Type: Client
    -- Name: attorneys/client.lua
    -- Use: Handles attorney specific client utilities
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]

--[[
    -- Type: Event
    -- Name: fsn_doj:attorney:spawnCar
    -- Use: Spawns a vehicle for attorneys
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_doj:attorney:spawnCar')
AddEventHandler('fsn_doj:attorney:spawnCar', function(car)
    local model = joaat(car)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(vehicle, true, true)
    TriggerEvent('fsn_cargarage:makeMine', vehicle, GetDisplayNameFromVehicleModel(model), GetVehicleNumberPlateText(vehicle))
    TriggerEvent('fsn_notify:displayNotification', 'You now own this vehicle!', 'centerLeft', 4000, 'success')
    TriggerEvent('fsn_notify:displayNotification', 'You spawned '..car, 'centerLeft', 2000, 'info')
end)
