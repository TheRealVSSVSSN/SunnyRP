--[[
    -- Type: Client Script
    -- Name: ped-money-drops client
    -- Use: Spawns money pickups from dead NPCs
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]

local function spawnMoneyPickup(victim)
    local coords = GetEntityCoords(victim)
    coords = vec3(coords.x, coords.y, coords.z - 0.7)

    local pickup = CreatePickupRotate(`PICKUP_MONEY_VARIABLE`, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 512, 0, false, 0)
    local netId = NetworkGetNetworkIdFromEntity(victim)
    local collected = false

    CreateThread(function()
        local playerPed = PlayerPedId()
        while not collected do
            Wait(50)
            if #(GetEntityCoords(playerPed) - coords) < 2.5 and HasPickupBeenCollected(pickup) then
                TriggerServerEvent('money:tryPickup', netId)
                RemovePickup(pickup)
                collected = true
            end
        end
    end)

    SetTimeout(15000, function()
        if not collected then
            RemovePickup(pickup)
            collected = true
        end
    end)

    TriggerServerEvent('money:allowPickupNear', netId)
end

AddEventHandler('gameEventTriggered', function(eventName, args)
    if eventName ~= 'CEventNetworkEntityDamage' then
        return
    end

    local victim, attacker, _, fatal = table.unpack(args)
    if fatal ~= 1 then
        return
    end

    if attacker ~= PlayerPedId() then
        return
    end

    if not IsEntityAPed(victim) or IsPedAPlayer(victim) then
        return
    end

    if not NetworkGetEntityIsNetworked(victim) then
        return
    end

    spawnMoneyPickup(victim)
end)

