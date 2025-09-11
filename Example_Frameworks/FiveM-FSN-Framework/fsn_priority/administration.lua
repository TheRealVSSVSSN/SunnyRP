--[[
    -- Type: Server Script
    -- Name: Priority Administration
    -- Use: Provides commands for moderating queue priority
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local moderators = {
    'steam:11000010e0828a9',
    'steam:11000011098d978',
    'steam:110000106f35cce'
}

--[[
    -- Type: Function
    -- Name: getSteamId
    -- Use: Retrieves a player's steam identifier
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function getSteamId(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1,5) == 'steam' then
            return id
        end
    end
    return nil
end

--[[
    -- Type: Function
    -- Name: isModerator
    -- Use: Checks if a player has moderation rights
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function isModerator(src)
    local steamid = getSteamId(src)
    if not steamid then return false end
    for _, id in ipairs(moderators) do
        if id == steamid then return true end
    end
    return false
end

--[[
    -- Type: Function
    -- Name: sendMessage
    -- Use: Sends a chat message to a player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function sendMessage(target, msg)
    TriggerClientEvent('chatMessage', target, '', {255,255,255}, msg)
end

--[[
    -- Type: Command
    -- Name: priority
    -- Use: Handles priority administration and checking
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterCommand('priority', function(source, args)
    if args[1] == 'admin' then
        if not isModerator(source) then
            sendMessage(source, '^1^*:fsn_priority:^0^r You do not have permission to modify priority.')
            return
        end

        local action = args[2]
        local targetId = tonumber(args[3])
        if not targetId then
            sendMessage(source, '^1^*:fsn_priority:^0^r Invalid target.')
            return
        end

        local steamid = getSteamId(targetId)
        if not steamid then
            sendMessage(source, '^1^*:fsn_priority:^0^r Steam ID not found for target.')
            return
        end

        if action == 'check' then
            MySQL.Async.fetchAll('SELECT priority, name FROM fsn_users WHERE steamid = @steamid', {['@steamid']=steamid}, function(res)
                local usr = res[1]
                if usr and usr.priority ~= 0 then
                    sendMessage(source, '^1^*:fsn_priority:^0^r '..usr.name..' priority level: '..usr.priority)
                else
                    sendMessage(source, '^1^*:fsn_priority:^0^r '..(usr and usr.name or steamid)..' does not have priority.')
                end
            end)
        elseif action == 'set' then
            local level = tonumber(args[4])
            if not level or level > 90 then
                sendMessage(source, '^1^*:fsn_priority:^0^r Admin priority levels need to be set in the database!')
                return
            end
            Queue.AddPriority(steamid, level)
            MySQL.Async.execute('UPDATE fsn_users SET priority = @prio WHERE steamid = @steamid', {['@prio']=level, ['@steamid']=steamid}, function()
                sendMessage(targetId, '^1^*:fsn_priority:^0^r A moderator updated your priority. Use: /priority check')
                sendMessage(source, '^1^*:fsn_priority:^0^r You set '..steamid..' priority to: '..level)
            end)
        elseif action == 'remove' then
            Queue.RemovePriority(steamid)
            MySQL.Async.execute('UPDATE fsn_users SET priority = 0 WHERE steamid = @steamid', {['@steamid']=steamid}, function()
                sendMessage(targetId, '^1^*:fsn_priority:^0^r A moderator removed your priority')
                sendMessage(source, '^1^*:fsn_priority:^0^r You removed '..steamid..' priority')
            end)
        elseif action == 'tempset' then
            local level = tonumber(args[4])
            if not level or level > 90 then
                sendMessage(source, '^1^*:fsn_priority:^0^r Admin priority levels need to be set in the database!')
                return
            end
            Queue.AddPriority(steamid, level)
            sendMessage(targetId, '^1^*:fsn_priority:^0^r A moderator temporarily set your priority to: '..level)
            sendMessage(targetId, '^1^*:fsn_priority:^0^r This is in place until the next server restart')
            sendMessage(source, '^1^*:fsn_priority:^0^r You temporarily set '..steamid..' priority to: '..level)
            sendMessage(source, '^1^*:fsn_priority:^0^r This is in place until the next server restart')
        end
    elseif args[1] == 'check' then
        local steamid = getSteamId(source)
        if not steamid then
            sendMessage(source, '^1^*:fsn_priority:^0^r Steam ID not found.')
            return
        end
        MySQL.Async.fetchAll('SELECT priority FROM fsn_users WHERE steamid = @steamid', {['@steamid']=steamid}, function(res)
            local usr = res[1]
            if usr and usr.priority ~= 0 then
                sendMessage(source, '^1^*:fsn_priority:^0^r Your current priority level is: '..usr.priority)
            else
                sendMessage(source, '^1^*:fsn_priority:^0^r You do not have priority.')
            end
        end)
    end
end, false)

