--[[
    -- Type: Event
    -- Name: e-blips:updateBlips
    -- Use: Broadcasts blip updates to all clients
    -- Created: 2024-09-08
    -- By: VSSVSSN
--]]
RegisterNetEvent('e-blips:updateBlips')
AddEventHandler('e-blips:updateBlips', function(id, job, name)
    local data = {
        netId = id,
        job = job,
        callsign = name
    }

    TriggerClientEvent('e-blips:addHandler', -1, data)
end)