--[[
    -- Type: Module
    -- Name: sv_log
    -- Use: Provides server-side logging utility to persist events.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local MySQL = exports['ghmattimysql']

--[[
    -- Type: Function
    -- Name: AddLog
    -- Use: Insert log entries into the logs table and optionally alert for exploiters.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function AddLog(logType, user, message, data)
    logType = logType and tostring(logType) or "None"

    if logType == "Exploiter" then
        exports['np-base']:getModule('Admin'):ExploitAlertDiscord(user, message)
    end

    local steamId, characterId = "Unknown", 0

    if type(user) == 'table' then
        steamId = user.steamid or "Unknown"
        if user.getCurrentCharacter then
            local char = user:getCurrentCharacter()
            if char and char.id then
                characterId = char.id
            end
        end
    elseif type(user) == 'string' then
        steamId = user
    end

    message = message and tostring(message) or "None"
    local encodedData = "None"
    if data then
        encodedData = (type(data) == 'string') and data or json.encode(data)
    end

    local query = [[
        INSERT INTO logs (type, log, data, cid, steam_id)
        VALUES (@type, @log, @data, @cid, @steam_id)
    ]]

    local params = {
        type = logType,
        log = message,
        data = encodedData,
        cid = characterId,
        steam_id = steamId
    }

    MySQL:execute(query, params)
end

exports('AddLog', AddLog)
