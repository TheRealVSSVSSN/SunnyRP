RegisterNetEvent('thermite:StartFireAtLocation')
AddEventHandler('thermite:StartFireAtLocation', function(x, y, z, arg1, arg2)
    TriggerClientEvent('thermite:StartClientFires', -1, x, y, z, arg1, arg2)
end)

RegisterNetEvent('thermite:StopFires')
AddEventHandler('thermite:StopFires', function()
    TriggerClientEvent('thermite:StopFiresClient', -1)
end)

