local steamIds = {
    ["steam:11000013218ef32"] = true, -- syd
    ["steam:1100001113b37ba"] = true, -- syd
}

local jailDoors = {}
for i = 10, 56 do
    jailDoors[#jailDoors + 1] = i
end

--[[ 
    -- Type: Event
    -- Name: np-doors:alterlockstate2
    -- Use: Unlocks predefined jail doors and syncs state with the client
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-doors:alterlockstate2', function()
    for _, id in ipairs(jailDoors) do
        if NPX.DoorCoords[id] then
            NPX.DoorCoords[id].lock = 0
        end
    end
    TriggerClientEvent('np-doors:sync', source, NPX.DoorCoords)
end)

--[[ 
    -- Type: Event
    -- Name: np-doors:alterlockstate
    -- Use: Toggles a door's lock state and broadcasts the update
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-doors:alterlockstate', function(alterNum)
    if NPX.DoorCoords[alterNum] then
        NPX.alterState(alterNum)
    end
end)

--[[ 
    -- Type: Event
    -- Name: np-doors:ForceLockState
    -- Use: Forces a specific lock state for a door and syncs to all clients
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-doors:ForceLockState', function(alterNum, state)
    if NPX.DoorCoords[alterNum] then
        NPX.DoorCoords[alterNum].lock = state
        TriggerClientEvent('NPX:Door:alterState', -1, alterNum, state)
    end
end)

--[[ 
    -- Type: Event
    -- Name: np-doors:requestlatest
    -- Use: Sends the latest door state table to the requesting client
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-doors:requestlatest', function()
    local src = source
    local steamcheck = GetPlayerIdentifiers(src)[1]
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys', src, true)
    end
    TriggerClientEvent('np-doors:sync', src, NPX.DoorCoords)
end)

--[[ 
    -- Type: Function
    -- Name: isDoorLocked
    -- Use: Returns the lock state of the requested door for external resources
    -- Created: 2024-10-27
    -- By: VSSVSSN
--]]
function isDoorLocked(door)
    return NPX.DoorCoords[door] and NPX.DoorCoords[door].lock == 1
end
