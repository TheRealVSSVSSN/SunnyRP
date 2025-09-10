local koil = vehicleBaseRepairCost

RegisterNetEvent('np-bennys:attemptPurchase')
AddEventHandler('np-bennys:attemptPurchase', function(cheap, type, upgradeLevel)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then return end

    if type == 'repair' then
        if user:getCash() >= koil then
            user:removeMoney(koil)
            TriggerClientEvent('np-bennys:purchaseSuccessful', src)
        else
            TriggerClientEvent('np-bennys:purchaseFailed', src)
        end
    elseif type == 'performance' then
        local price = vehicleCustomisationPrices[type].prices[upgradeLevel]
        if user:getCash() >= price then
            user:removeMoney(price)
            TriggerClientEvent('np-bennys:purchaseSuccessful', src)
        else
            TriggerClientEvent('np-bennys:purchaseFailed', src)
        end
    else
        local price = vehicleCustomisationPrices[type].price
        if user:getCash() >= price then
            user:removeMoney(price)
            TriggerClientEvent('np-bennys:purchaseSuccessful', src)
        else
            TriggerClientEvent('np-bennys:purchaseFailed', src)
        end
    end
end)

RegisterNetEvent('np-bennys:updateRepairCost')
AddEventHandler('np-bennys:updateRepairCost', function(cost)
    koil = tonumber(cost) or vehicleBaseRepairCost
end)
