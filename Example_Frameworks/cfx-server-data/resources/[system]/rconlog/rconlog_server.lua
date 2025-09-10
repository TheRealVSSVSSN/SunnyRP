--[[
    -- Type: Resource Script
    -- Name: rconlog_server.lua
    -- Use: Handles logging of server events to the RCON console and implements basic RCON commands
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]

local names = {}

--[[
    -- Type: Function
    -- Name: log
    -- Use: Wrapper for the RconLog native to keep calls consistent
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function log(payload)
    RconLog(payload)
end

--[[
    -- Type: Function
    -- Name: broadcastNames
    -- Use: Requests the host to send the latest player name table
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function broadcastNames()
    local host = GetHostId()
    if host then
        TriggerClientEvent('rlUpdateNames', host)
    end
end

--[[
    -- Type: Function
    -- Name: handlePlayerActivated
    -- Use: Logs when a player joins and updates the name cache
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function handlePlayerActivated()
    local src = source
    local playerName = GetPlayerName(src)

    log({
        msgType = 'playerActivated',
        netID = src,
        name = playerName,
        guid = GetPlayerIdentifier(src, 0),
        ip = GetPlayerEndpoint(src)
    })

    names[src] = { name = playerName, id = src }
    broadcastNames()
end
RegisterNetEvent('rlPlayerActivated')
AddEventHandler('rlPlayerActivated', handlePlayerActivated)

--[[
    -- Type: Function
    -- Name: handleNamesResult
    -- Use: Receives updated name information from the host client
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function handleNamesResult(res)
    if source ~= tonumber(GetHostId()) then
        print('Unauthorized rlUpdateNamesResult from', source)
        return
    end

    for id, data in pairs(res) do
        if data then
            if not names[id] or names[id].name ~= data.name or names[id].id ~= data.id then
                names[id] = data
                log({ msgType = 'playerRenamed', netID = id, name = data.name })
            end
        else
            names[id] = nil
        end
    end
end
RegisterNetEvent('rlUpdateNamesResult')
AddEventHandler('rlUpdateNamesResult', handleNamesResult)

--[[
    -- Type: Function
    -- Name: handlePlayerDropped
    -- Use: Logs when a player disconnects from the server
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function handlePlayerDropped()
    local src = source
    log({ msgType = 'playerDropped', netID = src, name = GetPlayerName(src) })
    names[src] = nil
end
AddEventHandler('playerDropped', handlePlayerDropped)

--[[
    -- Type: Event Handler
    -- Name: chatMessage
    -- Use: Logs chat messages to the RCON console
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
AddEventHandler('chatMessage', function(netID, name, message)
    log({
        msgType = 'chatMessage',
        netID = netID,
        name = name,
        message = message,
        guid = GetPlayerIdentifier(netID, 0)
    })
end)

--[[
    -- Type: Function
    -- Name: commandStatus
    -- Use: Outputs the current player list to the RCON console
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function commandStatus(source, args)
    if source ~= 0 then return end

    for netid, data in pairs(names) do
        local guid = GetPlayerIdentifier(netid, 0) or 'unknown'
        local endpoint = GetPlayerEndpoint(netid) or 'unknown'
        local ping = GetPlayerPing(netid) or -1

        RconPrint(('%s %s %s %s %s\n'):format(netid, guid, data.name, endpoint, ping))
    end
end
RegisterCommand('status', commandStatus, true)

--[[
    -- Type: Function
    -- Name: commandClientKick
    -- Use: Kicks a player from the server via RCON command
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function commandClientKick(source, args)
    if source ~= 0 then return end

    local playerId = table.remove(args, 1)
    local msg = table.concat(args, ' ')

    if playerId then
        DropPlayer(playerId, msg or '')
    end
end
RegisterCommand('clientkick', commandClientKick, true)

--[[
    -- Type: Function
    -- Name: commandTempBanClient
    -- Use: Temporarily bans a player via RCON command
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function commandTempBanClient(source, args)
    if source ~= 0 then return end

    local playerId = table.remove(args, 1)
    local msg = table.concat(args, ' ')

    if playerId then
        TempBanPlayer(playerId, msg or '')
    end
end
RegisterCommand('tempbanclient', commandTempBanClient, true)

log({
    msgType = 'serverStart',
    hostname = GetConvar('sv_hostname', 'unknown'),
    maxplayers = GetConvarInt('sv_maxclients', 32)
})

