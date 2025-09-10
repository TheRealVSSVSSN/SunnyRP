RegisterServerEvent('np:infinity:player:ready')
AddEventHandler('np:infinity:player:ready', function()
    local coords = {}
    for _, id in ipairs(GetPlayers()) do
        local ped = GetPlayerPed(id)
        if DoesEntityExist(ped) then
            coords[tonumber(id)] = GetEntityCoords(ped)
        end
    end
    TriggerClientEvent('np:infinity:player:coords', -1, coords)
end)

RegisterServerEvent('np:infinity:entity:coords')
AddEventHandler('np:infinity:entity:coords', function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local coords = false

    if entity ~= 0 and DoesEntityExist(entity) then
        coords = GetEntityCoords(entity)
    end

    TriggerClientEvent('np:infinity:entity:coords', source, netId, coords)
end)

