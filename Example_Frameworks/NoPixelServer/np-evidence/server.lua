--[[
    -- Type: Server
    -- Name: np-evidence server
    -- Use: Relays evidence updates between clients
    -- Created: 2024-02-29
    -- By: VSSVSSN
--]]

local function broadcast(event, ...)
    TriggerClientEvent(event, -1, ...)
end

RegisterNetEvent('evidence:pooled', function(data)
    local src = source
    if type(data) ~= 'table' then return end
    broadcast('evidence:pooled', data)
end)

RegisterNetEvent('evidence:removal', function(id)
    if type(id) ~= 'string' then return end
    broadcast('evidence:remove:done', id)
end)

RegisterNetEvent('evidence:clear', function(ids)
    if type(ids) ~= 'table' then return end
    for i = 1, #ids do
        broadcast('evidence:remove:done', ids[i])
    end
end)
