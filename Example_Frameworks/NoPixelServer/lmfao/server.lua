--[[
    -- Type: Event
    -- Name: mission:completed
    -- Use: Adds validated mission payout to player's account
    -- Created: 2024-05-30
    -- By: VSSVSSN
--]]
RegisterNetEvent('mission:completed', function(money)
    local src = source
    local amount = tonumber(money) or 0
    if amount <= 0 or amount > 1000 then return end
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    user:addMoney(amount)
end)

--[[
    -- Type: Event
    -- Name: mission:caughtMoney
    -- Use: Rewards validated random cash from fishing
    -- Created: 2024-05-30
    -- By: VSSVSSN
--]]
RegisterNetEvent('mission:caughtMoney', function(rnd)
    local src = source
    local amount = tonumber(rnd) or 0
    if amount <= 0 or amount > 1000 then return end
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    user:addMoney(amount)
end)

--[[
    -- Type: Command
    -- Name: ooc
    -- Use: Sends global out-of-character message
    -- Created: 2024-05-30
    -- By: VSSVSSN
--]]
RegisterCommand('ooc', function(source, args)
    if not args[1] then return end
    local src = source
    local msg = table.concat(args, " ")
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local name = char.first_name .. " " .. char.last_name
    TriggerClientEvent('chatMessage', -1, "OOC " .. name, 2, msg)
    exports["np-log"]:AddLog("OOC Chat [" .. src .. "]", user, name .. ": " .. msg, {})
    print(msg)
end, false)

