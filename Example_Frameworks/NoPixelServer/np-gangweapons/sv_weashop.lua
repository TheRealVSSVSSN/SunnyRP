--[[
    -- Type: Server Script
    -- Name: sv_weashop.lua
    -- Use: Handles gang weapon shop purchases and validations
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]

local MySQL = MySQL

--[[
    -- Type: Function
    -- Name: getPlayerLicense
    -- Use: Retrieves the player's license identifier
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function getPlayerLicense(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1,8) == 'license:' then
            return id:sub(9)
        end
    end
    return nil
end

--[[
    -- Type: Event
    -- Name: np-gangweapons:purchaseWeapon
    -- Use: Checks funds and gives weapon to player
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-gangweapons:purchaseWeapon', function(weapon)
    local src = source
    local price = Config.ItemPrices[weapon]
    if not price then
        TriggerClientEvent('np-gangweapons:purchaseResult', src, false, 'Invalid weapon')
        return
    end

    local license = getPlayerLicense(src)
    if not license then
        TriggerClientEvent('np-gangweapons:purchaseResult', src, false, 'Missing license')
        return
    end

    local cash = MySQL.scalar.await('SELECT cash FROM players WHERE license = ?', { license }) or 0
    if cash < price then
        TriggerClientEvent('np-gangweapons:purchaseResult', src, false, 'Insufficient funds')
        return
    end

    MySQL.update.await('UPDATE players SET cash = cash - ? WHERE license = ?', { price, license })

    GiveWeaponToPed(GetPlayerPed(src), GetHashKey(weapon), 250, false, true)
    TriggerClientEvent('np-gangweapons:purchaseResult', src, true, weapon)
end)

