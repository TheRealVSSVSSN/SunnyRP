--[[
    -- Type: Server Event Handler
    -- Name: np-driftschool:takemoney
    -- Use: Deducts funds for drift school interactions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-driftschool:takemoney')
AddEventHandler('np-driftschool:takemoney', function(cost)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)

    if user:getCash() >= cost then
        user:removeMoney(cost)
        TriggerClientEvent('np-driftschool:tookmoney', src, true)
    else
        TriggerClientEvent('np-driftschool:tookmoney', src, false)
        TriggerClientEvent('DoLongHudText', src, "You don't have enough money to do that.", 2)
    end
end)


