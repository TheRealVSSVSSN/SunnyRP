--[[
    -- Type: Server Script
    -- Name: Ragdoll Server Handlers
    -- Use: Manages death state and revival logic
    -- Created: 2024-02-23
    -- By: VSSVSSN
--]]

local CPR_PRICE = 10000

--[[
    -- Type: Event
    -- Name: ragdoll:playerDied
    -- Use: Placeholder for logging when a player dies
--]]
RegisterNetEvent('ragdoll:playerDied', function(cause)
    -- future implementation: log cause or update database
end)

--[[
    -- Type: Event
    -- Name: ragdoll:confirmKill
    -- Use: Notifies a target client that they have been killed
--]]
RegisterNetEvent('ragdoll:confirmKill', function(target)
    if target then
        TriggerClientEvent('ragdoll:setDead', target)
    end
end)

--[[
    -- Type: Event
    -- Name: ragdoll:grantRevive
    -- Use: Revives a target client
--]]
RegisterNetEvent('ragdoll:grantRevive', function(target)
    TriggerClientEvent('ragdoll:revive', target)
end)

--[[
    -- Type: Event
    -- Name: ragdoll:tryCPR
    -- Use: Charges player and triggers CPR animation
--]]
RegisterNetEvent('ragdoll:tryCPR', function()
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then return end

    if user:getCash() >= CPR_PRICE then
        user:removeMoney(CPR_PRICE)
        TriggerClientEvent('ragdoll:doCPR', src)
    else
        TriggerClientEvent('DoLongHudText', src, "You can't afford that CPR", 2)
    end
end)

--[[
    -- Type: Event
    -- Name: ragdoll:serverCPR
    -- Use: Used after successful CPR to revive the player
--]]
RegisterNetEvent('ragdoll:serverCPR', function()
    TriggerClientEvent('ragdoll:revive', source)
end)
