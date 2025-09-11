--[[
    -- Type: Server Script
    -- Name: Steam Login Server
    -- Use: Validates Steam authentication and stores player sessions
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]

local PLAYER_TABLE = 'fsn_users'

--[[
    -- Type: Function
    -- Name: ensurePlayerTable
    -- Use: Creates the player table if it does not exist
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function ensurePlayerTable()
    MySQL.ready(function()
        MySQL.Async.execute(string.format([[
            CREATE TABLE IF NOT EXISTS %s (
                steamid VARCHAR(21) PRIMARY KEY,
                player_name VARCHAR(50),
                last_seen TIMESTAMP NULL
            )
        ]], PLAYER_TABLE))
    end)
end

ensurePlayerTable()

--[[
    -- Type: Event
    -- Name: playerConnecting
    -- Use: Defers connection to verify Steam and register player
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()

    Wait(0)

    local steamId = GetPlayerIdentifierByType(src, 'steam')
    if not steamId then
        deferrals.done('Steam is required to play on this server.')
        return
    end

    MySQL.Async.execute(
        string.format('INSERT IGNORE INTO %s (steamid, player_name) VALUES (@id, @name)', PLAYER_TABLE),
        {['@id'] = steamId, ['@name'] = name},
        function()
            deferrals.done()
        end
    )
end)

--[[
    -- Type: Event
    -- Name: fsn_steamlogin:clientReady
    -- Use: Updates last seen timestamp when client reports readiness
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_steamlogin:clientReady')
AddEventHandler('fsn_steamlogin:clientReady', function()
    local src = source
    local steamId = GetPlayerIdentifierByType(src, 'steam')
    if steamId then
        MySQL.Async.execute(
            string.format('UPDATE %s SET last_seen = NOW(), player_name = @name WHERE steamid = @id', PLAYER_TABLE),
            {['@id'] = steamId, ['@name'] = GetPlayerName(src)}
        )
    end
end)
