--[[
    -- Type: Table
    -- Name: inside
    -- Use: Tracks players who requested spawn
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local inside = {}
local spawned = false

--[[
    -- Type: Event
    -- Name: request:spawn
    -- Use: Handles interior spawn logic
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('request:spawn', function()
    local src = source
    if not spawned then
        spawned = true
        TriggerClientEvent('accept:vinewoodspawn', src, true)
    else
        TriggerClientEvent('accept:vinewoodspawn', src, false)
    end
    table.insert(inside, src)
end)
