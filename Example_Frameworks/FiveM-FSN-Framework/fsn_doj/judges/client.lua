--[[
    -- Type: Client
    -- Name: judges/client.lua
    -- Use: Handles judge specific client features
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]

local isRemanded = false
local REMAND_POS = { coords = vector3(255.2421, -317.2813, -118.5199), heading = 78.6788 }
local RELEASE_POS = vector3(246.6311, -337.2972, -118.8000)

--[[
    -- Type: Function
    -- Name: teleportToRemand
    -- Use: Moves player to remand location and sets animation
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
local function teleportToRemand()
    SetEntityCoords(PlayerPedId(), REMAND_POS.coords.x, REMAND_POS.coords.y, REMAND_POS.coords.z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), REMAND_POS.heading)
    ExecuteCommand('e sit3')
end

RegisterNetEvent('fsn_doj:court:remandMe')
AddEventHandler('fsn_doj:court:remandMe', function(judge)
    if isRemanded then
        isRemanded = false
        TriggerEvent('fsn_notify:displayNotification', 'You were released from remand', 'centerLeft', 4000, 'success')
        SetEntityCoords(PlayerPedId(), RELEASE_POS.x, RELEASE_POS.y, RELEASE_POS.z)
        TriggerServerEvent('fsn_notify:displayNotification', judge, 'The player has been released from remand', 'centerLeft', 4000, 'success')
    else
        local judgePed = GetPlayerPed(GetPlayerFromServerId(judge))
        if #(GetEntityCoords(judgePed) - GetEntityCoords(PlayerPedId())) < 5.0 then
            isRemanded = true
            teleportToRemand()
            TriggerEvent('fsn_notify:displayNotification', 'You have been remanded by a judge for violent behaviour', 'centerLeft', 4000, 'error')
        else
            TriggerServerEvent('fsn_notify:displayNotification', judge, 'You need to be closer to remand a person', 'centerLeft', 4000, 'error')
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        if isRemanded then
            if #(GetEntityCoords(PlayerPedId()) - REMAND_POS.coords) > 5.0 then
                teleportToRemand()
                TriggerEvent('fsn_notify:displayNotification', 'You cannot escape from remand.', 'centerLeft', 4000, 'error')
            end
        end
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_doj:judge:spawnCar
    -- Use: Spawns a vehicle for judges
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_doj:judge:spawnCar')
AddEventHandler('fsn_doj:judge:spawnCar', function(car)
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
