--[[
    -- Type: Server
    -- Name: attorneys/server.lua
    -- Use: Attorney command handling
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]

local attorneys = {
    'steam:11000010e0828a9' -- placeholder IDs
}

--[[
    -- Type: Function
    -- Name: isAttorney
    -- Use: Checks if source is an attorney
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
local function isAttorney(src)
    local identifier = GetPlayerIdentifier(src, 0)
    for _, v in ipairs(attorneys) do
        if v == identifier then
            return true
        end
    end
    return false
end

--[[
    -- Type: Command
    -- Name: /attorney
    -- Use: Provides attorney utilities
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
RegisterCommand('attorney', function(source, args)
    if not isAttorney(source) then
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^1:fsn_doj:^0^r You are not an attorney, you cannot use this function')
        return
    end

    local action = args[1]
    if action == 'msg' then
        local msg = table.concat(args, ' ', 2)
        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*^2ATTORNEY ANNOUNCEMENT |^0^r '..msg)
    elseif action == 'car' then
        local cars = {
            [1] = 'felon',
            [2] = 'tailgater'
        }
        local car = cars[tonumber(args[2])]
        if car then
            TriggerClientEvent('fsn_doj:attorney:spawnCar', source, car)
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^1:fsn_doj:^0^r Unrecognised car')
        end
    end
end, false)
