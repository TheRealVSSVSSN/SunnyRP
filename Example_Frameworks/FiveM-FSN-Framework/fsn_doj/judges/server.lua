--[[
    -- Type: Server
    -- Name: judges/server.lua
    -- Use: Judge command handling and utilities
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]

local judges = {
    'steam:11000010e0828a9',
    'steam:110000101c2956e',
    'steam:11000010620e2e0',
    'steam:110000108e0a227'
}

--[[
    -- Type: Function
    -- Name: isJudge
    -- Use: Determines if a player is authorized as a judge
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
local function isJudge(src)
    local identifier = GetPlayerIdentifier(src, 0)
    for _, v in ipairs(judges) do
        if v == identifier then
            return true
        end
    end
    return false
end

--[[
    -- Type: Function
    -- Name: judgeCPIC
    -- Use: Sends CPIC search results to the requesting judge
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
local function judgeCPIC(id, src)
    local charId = exports.fsn_main:fsn_CharID(id)
    MySQL.Async.fetchAll('SELECT * FROM `fsn_tickets` WHERE `receiver_id` = @id', {['@id'] = charId}, function(results)
        for _, v in ipairs(results) do
            local t = os.date('*t', v.ticket_date)
            v.ticket_date = string.format('%02d:%02d %02d/%02d/%04d', t.hour, t.min, t.month, t.day, t.year)
        end
        TriggerClientEvent('fsn_police:database:CPIC:search:result', src, results)
    end)
end

--[[
    -- Type: Command
    -- Name: /judge
    -- Use: Provides judge utilities
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
RegisterCommand('judge', function(source, args)
    if not isJudge(source) then
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^1:fsn_doj:^0^r You are not a judge, you cannot use this function')
        return
    end

    local action = args[1]
    if action == 'msg' then
        local msg = table.concat(args, ' ', 2)
        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*^1JUDGE ANNOUNCEMENT |^0^r '..msg)
    elseif action == 'cpic' then
        local id = tonumber(args[2])
        if id then judgeCPIC(id, source) end
    elseif action == 'pay' then
        TriggerClientEvent('fsn_bank:change:walletAdd', tonumber(args[2]), tonumber(args[3]))
    elseif action == 'bill' then
        TriggerEvent('fsn_police:ticket', tonumber(args[2]), tonumber(args[3]))
    elseif action == 'jail' then
        TriggerEvent('fsn_jail:sendsuspect', source, tonumber(args[2]), tonumber(args[3]) * 60)
    elseif action == 'license' then
        local sub = args[2]
        if sub == 'infractions' and args[3] == 'set' then
            local target, licType, amount = tonumber(args[4]), args[5], tonumber(args[6])
            TriggerClientEvent('fsn_licenses:setinfractions', target, licType, amount)
            TriggerClientEvent('fsn_notify:displayNotification', target, ':FSN: A judge ('..source..') set your '..licType..' license infractions to '..amount, 'centerLeft', 8000, 'info')
        end
    elseif action == 'setlock' then
        local state = args[2]
        local lock = state == 'true'
        TriggerClientEvent('fsn_doj:judge:toggleLock', -1, lock)
        local text = lock and 'The courtroom has been locked' or 'The courtroom has been unlocked'
        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*^1JUDGE ANNOUNCEMENT |^0^r '..text)
    elseif action == 'remand' then
        TriggerClientEvent('fsn_doj:court:remandMe', tonumber(args[2]), source)
    elseif action == 'car' then
        local cars = {
            [1] = 'p90d',
            [2] = 'm5f90'
        }
        local car = cars[tonumber(args[2])]
        if car then
            TriggerClientEvent('fsn_doj:judge:spawnCar', source, car)
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^1:fsn_doj:^0^r Unrecognised car')
        end
    end
end, false)
