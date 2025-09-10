--[[
    -- Type: Event handlers
    -- Name: shops server
    -- Use: Handles shop transactions and cash interactions
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]

local locations = {}
local itemTypes = {}

--[[
    -- Type: Event
    -- Name: itemMoneyCheck
    -- Use: Verifies a player's cash before granting an item purchase
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterServerEvent("itemMoneyCheck")
AddEventHandler("itemMoneyCheck", function(itemType, askingPrice)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end

    local price = tonumber(askingPrice) or 0
    if user:getCash() >= price then
        user:removeMoney(price)
        if price > 0 then
            TriggerClientEvent("DoShortHudText", src, "Purchased", 8)
        end
        TriggerClientEvent("player:receiveItem", src, itemType, 1)
    else
        TriggerClientEvent("DoShortHudText", src, "Not enough money", 2)
    end
end)

--[[
    -- Type: Event
    -- Name: shop:useVM:server
    -- Use: Handles payment for vending machine interactions
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterServerEvent("shop:useVM:server")
AddEventHandler("shop:useVM:server", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end

    if user:getCash() >= 20 then
        user:removeMoney(20)
        TriggerClientEvent("shop:useVM:finish", src)
    else
        TriggerClientEvent("DoLongHudText", src, "You need $20", 2)
    end
end)

--[[
    -- Type: Event
    -- Name: take100
    -- Use: Removes $100 from a target player
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterServerEvent("take100")
AddEventHandler("take100", function(tgtsent)
    local tgt = tonumber(tgtsent)
    local target = exports["np-base"]:getModule("Player"):GetUser(tgt)
    if target then
        target:removeMoney(100)
    end
end)

--[[
    -- Type: Event
    -- Name: movieticket
    -- Use: Handles movie ticket purchases
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterServerEvent("movieticket")
AddEventHandler("movieticket", function(askingPrice)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end

    local price = tonumber(askingPrice) or 0
    if user:getCash() >= price then
        user:removeMoney(price)
        TriggerClientEvent("startmovies", src)
    else
        TriggerClientEvent("DoShortHudText", src, "Not enough money", 2)
    end
end)

--[[
    -- Type: Event
    -- Name: cash:remove
    -- Use: Safely removes cash from the calling player's wallet
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterServerEvent("cash:remove")
AddEventHandler("cash:remove", function(amount)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if user then
        user:removeMoney(tonumber(amount) or 0)
    end
end)
