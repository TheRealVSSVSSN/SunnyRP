--[[
    -- Type: Event
    -- Name: np-login:disconnectPlayer
    -- Use: Drops a player from the server
    -- Created: 2024-05-26
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-login:disconnectPlayer', function()
    DropPlayer(source, "You have been disconnected from the server")
end)

--[[
    -- Type: Event
    -- Name: np-login:getPlayerInformation
    -- Use: Placeholder for player info retrieval
    -- Created: 2024-05-26
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-login:getPlayerInformation', function()
    local src = source
    -- implement data fetch if needed
end)
