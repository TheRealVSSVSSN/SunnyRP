--[[
    -- Type: Server Script
    -- Name: ped-money-drops server
    -- Use: Validates pickup locations and rewards players
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]

local safePositions = {}

RegisterNetEvent('money:allowPickupNear', function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    Wait(250)

    if not DoesEntityExist(entity) then
        return
    end

    if GetEntityHealth(entity) > 100 then
        return
    end

    safePositions[netId] = GetEntityCoords(entity)
end)

RegisterNetEvent('money:tryPickup', function(netId)
    local coords = safePositions[netId]
    if not coords then
        return
    end

    local src = source
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)

    if #(coords - playerCoords) < 2.5 then
        exports.money:addMoney(src, 'cash', 40)
    end

    safePositions[netId] = nil
end)

AddEventHandler('entityRemoved', function(netId)
    safePositions[netId] = nil
end)

