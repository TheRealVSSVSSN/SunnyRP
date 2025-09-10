--[[
    -- Type: Server Event
    -- Name: np-dirtymoney:attemptDirtyMoneyDrops
    -- Use: Handles a player's attempt to drop dirty money by charging a fee and starting the dropoff process.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("np-dirtymoney:attemptDirtyMoneyDrops", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end

    local dirtyMoney = user:getDirtyMoney()
    if dirtyMoney >= 500 then
        TriggerClientEvent("np-dirtymoney:attemptDirtyMoneyDrops", src)
        user:alterDirtyMoney(dirtyMoney - 500)
        TriggerClientEvent("UPV", src, 500)
    else
        TriggerClientEvent("DoLongHudText", src, "You need $500 in Marked Bills.", 2)
    end
end)

--[[
    -- Type: Server Event
    -- Name: np-dirtymoney:alterDirtyMoney
    -- Use: Adjusts a player's dirty money based on the provided reason and amount.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("np-dirtymoney:alterDirtyMoney", function(reason, amount)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end

    local amt = tonumber(amount) or 0
    if amt <= 0 then return end

    local dirtyMoney = user:getDirtyMoney()
    if reason == "ItemDrop" then
        if dirtyMoney >= amt then
            TriggerClientEvent("np-dirtymoney:attemptDirtyMoneyDrops", src)
            user:alterDirtyMoney(dirtyMoney - amt)
            TriggerClientEvent("UPV", src, amt)
        else
            TriggerClientEvent("DoLongHudText", src, "Insufficient Marked Bills.", 2)
        end
    else
        user:alterDirtyMoney(dirtyMoney + amt)
    end
end)

--[[
    -- Type: Server Event
    -- Name: np-dirtymoney:moneyPickup
    -- Use: Converts collected dirty money into clean cash for the player.
    -- Created: 2024-06-08
    -- By: VSSVSSN
--]]
RegisterNetEvent("np-dirtymoney:moneyPickup", function(amount)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end

    local amt = tonumber(amount) or 0
    if amt <= 0 then return end

    user:addMoney(amt)
end)
