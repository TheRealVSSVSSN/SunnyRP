local names = {}

RconLog({
    msgType = 'serverStart',
    hostname = GetConvar('sv_hostname', 'unknown'),
    maxplayers = GetConvarInt('sv_maxclients', 32)
})

--[[
    -- Type: Event
    -- Name: rlPlayerActivated
    -- Use: Registers when a player joins the session
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('rlPlayerActivated', function()
    local src = source

    RconLog({
        msgType = 'playerActivated',
        netID = src,
        name = GetPlayerName(src),
        guid = GetPlayerIdentifiers(src)[1],
        ip = GetPlayerEndpoint(src)
    })

    names[src] = { name = GetPlayerName(src), id = src }

    local hostId = tonumber(GetHostId())
    if hostId then
        TriggerClientEvent('rlUpdateNames', hostId)
    end
end)

--[[
    -- Type: Event
    -- Name: rlUpdateNamesResult
    -- Use: Receives updated player name data from the host
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('rlUpdateNamesResult', function(res)
    local src = source
    if src ~= tonumber(GetHostId()) then
        print('rlUpdateNamesResult: invalid source')
        return
    end

    for id, data in pairs(res) do
        if data and data.name then
            if not names[id] then
                names[id] = data
            end

            if names[id].name ~= data.name or names[id].id ~= data.id then
                names[id] = data
                RconLog({ msgType = 'playerRenamed', netID = id, name = data.name })
            end
        else
            names[id] = nil
        end
    end
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Logs when a player disconnects
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function(reason)
    local src = source
    RconLog({ msgType = 'playerDropped', netID = src, name = GetPlayerName(src), reason = reason })
    names[src] = nil
end)

--[[
    -- Type: Event
    -- Name: chatMessage
    -- Use: Logs chat messages to RCON
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('chatMessage', function(netID, name, message)
    RconLog({ msgType = 'chatMessage', netID = netID, name = name, message = message, guid = GetPlayerIdentifiers(netID)[1] })
end)

--[[
    -- Type: Command
    -- Name: status
    -- Use: Prints list of connected players with identifiers
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterCommand('status', function(source, args, raw)
    if source ~= 0 then return end

    for netid, data in pairs(names) do
        local guid = GetPlayerIdentifiers(netid)
        if guid and guid[1] and data then
            local ping = GetPlayerPing(netid)
            RconPrint(('%s %s %s %s %s\n'):format(netid, guid[1], data.name, GetPlayerEndpoint(netid), ping))
        end
    end
end, true)

--[[
    -- Type: Command
    -- Name: clientkick
    -- Use: Kicks a player from the server
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterCommand('clientkick', function(source, args)
    if source ~= 0 then return end

    local playerId = table.remove(args, 1)
    local msg = table.concat(args, ' ')
    DropPlayer(playerId, msg)
end, true)

--[[
    -- Type: Command
    -- Name: tempbanclient
    -- Use: Temporarily bans a player from the server
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterCommand('tempbanclient', function(source, args)
    if source ~= 0 then return end

    local playerId = table.remove(args, 1)
    local msg = table.concat(args, ' ')
    TempBanPlayer(playerId, msg)
end, true)

