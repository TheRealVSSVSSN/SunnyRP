--[[
    -- Type: Server Script
    -- Name: banking/server.lua
    -- Use: Handles all server-side banking interactions
    -- Created: 2024-05-13
    -- By: VSSVSSN
--]]

local getUser = function(src)
    return exports["np-base"]:getModule("Player"):GetUser(src)
end

RegisterNetEvent('bank:deposit', function(amount)
    local src = source
    local user = getUser(src)
    amount = tonumber(amount)
    if not amount or amount <= 0 then
        TriggerClientEvent('DoShortHudText', src, 'Invalid amount', 2)
        return
    end

    if user:getCash() >= amount then
        user:removeMoney(amount)
        user:addBank(amount)
    else
        TriggerClientEvent('DoShortHudText', src, 'You do not have enough money to deposit', 2)
    end
end)

RegisterNetEvent('bank:withdraw', function(amount)
    local src = source
    local user = getUser(src)
    amount = tonumber(amount)
    if not amount or amount <= 0 then
        TriggerClientEvent('DoShortHudText', src, 'Invalid amount', 2)
        return
    end

    if user:getBalance() >= amount then
        user:removeBank(amount)
        user:addMoney(amount)
    else
        TriggerClientEvent('DoShortHudText', src, 'You do not have enough money to withdraw', 2)
    end
end)

RegisterNetEvent('bank:givecash', function(receiver, amount)
    local src = source
    local user = getUser(src)
    local target = getUser(tonumber(receiver))
    amount = tonumber(amount)
    if not amount or amount <= 0 or not target then
        TriggerClientEvent('DoShortHudText', src, 'Invalid request', 2)
        return
    end

    if user:getCash() >= amount then
        user:removeMoney(amount)
        target:addMoney(amount)
        exports["np-log"]:AddLog("Transfer", user, "User gave cash to "..tonumber(receiver).." $"..tonumber(amount), {target = receiver, src = src})
    else
        TriggerClientEvent('DoShortHudText', src, 'Not enough money', 2)
    end
end)

RegisterNetEvent('bank:transfer', function(receiver, amount)
    local src = source
    local user = getUser(src)
    local target = getUser(tonumber(receiver))
    amount = tonumber(amount)
    if not amount or amount <= 0 or not target then
        TriggerClientEvent('DoShortHudText', src, 'Invalid request', 2)
        return
    end

    if user:getBalance() >= amount then
        user:removeBank(amount)
        target:addBank(amount)
        exports["np-log"]:AddLog("Bank Transfer", user, "User transfered to "..tonumber(receiver).." $"..tonumber(amount), {target = receiver, src = src})
    else
        TriggerClientEvent('DoShortHudText', src, 'Not enough money', 2)
    end
end)

RegisterCommand('cash', function(source)
    local user = getUser(source)
    local char = user:getCurrentCharacter()
    TriggerClientEvent('banking:updateCash', source, char.cash, true)
end)

RegisterNetEvent('bank:withdrawAmende', function(amount)
    local src = source
    local user = getUser(src)
    amount = tonumber(amount)
    if amount and amount > 0 then
        user:removeMoney(amount)
    end
end)

RegisterCommand('givecash', function(source, args)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    if target and amount and amount > 0 then
        TriggerClientEvent('bank:givecash', source, target, amount)
    end
end)

