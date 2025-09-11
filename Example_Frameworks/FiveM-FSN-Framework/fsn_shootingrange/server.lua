local ranges = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false
}

local playerRanges = {}

--[[
    -- Type: Event
    -- Name: fsn_shootingrange:requestJoin
    -- Use: Assigns a free range slot to the requesting player
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_shootingrange:requestJoin', function()
    local src = source
    for id, used in ipairs(ranges) do
        if not used then
            ranges[id] = true
            playerRanges[src] = id
            TriggerClientEvent('fsn_shootingrange:join', src, id)
            return
        end
    end
    TriggerClientEvent('fsn_shootingrange:noRange', src)
end)

--[[
    -- Type: Event
    -- Name: fsn_shootingrange:leave
    -- Use: Frees a range slot when a player leaves
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_shootingrange:leave', function(id)
    local src = source
    ranges[id] = false
    playerRanges[src] = nil
end)

AddEventHandler('playerDropped', function()
    local src = source
    local id = playerRanges[src]
    if id then
        ranges[id] = false
        playerRanges[src] = nil
    end
end)

