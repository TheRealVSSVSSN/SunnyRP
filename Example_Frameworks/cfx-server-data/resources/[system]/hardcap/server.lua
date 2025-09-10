--[[
    -- Type: Function
    -- Name: isServerFull
    -- Use: Checks if the number of active players meets or exceeds sv_maxclients.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function isServerFull()
    local maxClients = GetConvarInt('sv_maxclients', 32)
    local players = GetPlayers()
    return #players >= maxClients, maxClients
end

--[[
    -- Type: Event Handler
    -- Name: playerConnecting
    -- Use: Enforces the player limit and rejects connections when the server is full.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    print(('Connecting: %s^7'):format(name))

    local full, limit = isServerFull()
    if not full then
        return
    end

    local message = ('This server is full (past %d players).'):format(limit)

    if deferrals then
        deferrals.done(message)
    else
        setKickReason(message)
    end

    CancelEvent()
end)
