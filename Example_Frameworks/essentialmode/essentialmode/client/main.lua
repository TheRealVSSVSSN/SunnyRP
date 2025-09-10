--[[
    -- Type: Thread
    -- Name: InitializeSession
    -- Use: Waits for network session then notifies server of first join
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(500)
    end
    TriggerServerEvent('es:firstJoinProper')
end)

local cash = 0
local oldPos
local decorators = {}

--[[
    -- Type: Thread
    -- Name: PositionReporter
    -- Use: Sends position updates
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(1000)
        local pos = GetEntityCoords(PlayerPedId())
        if not oldPos or pos.x ~= oldPos.x or pos.y ~= oldPos.y or pos.z ~= oldPos.z then
            TriggerServerEvent('es:updatePositions', pos.x, pos.y, pos.z)
            oldPos = pos
        end
    end
end)

RegisterNetEvent('es:setPlayerDecorator')
AddEventHandler('es:setPlayerDecorator', function(key, value, applyNow)
    decorators[key] = value
    if not DecorIsRegisteredAsType(key, 3) then
        DecorRegister(key, 3)
    end
    if applyNow then
        DecorSetInt(PlayerPedId(), key, value)
    end
end)

AddEventHandler('playerSpawned', function()
    for k, v in pairs(decorators) do
        DecorSetInt(PlayerPedId(), k, v)
    end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(amount)
    SendNUIMessage({
        setmoney = true,
        money = amount
    })
    cash = amount
end)

RegisterNetEvent('es:addedMoney')
AddEventHandler('es:addedMoney', function(amount)
    cash = cash + amount
    SendNUIMessage({
        addcash = true,
        money = amount
    })
end)

RegisterNetEvent('es:removedMoney')
AddEventHandler('es:removedMoney', function(amount)
    cash = cash - amount
    SendNUIMessage({
        removecash = true,
        money = amount
    })
end)

RegisterNetEvent('es:setMoneyDisplay')
AddEventHandler('es:setMoneyDisplay', function(val)
    SendNUIMessage({
        setDisplay = true,
        display = val
    })
end)

RegisterNetEvent('es:enablePvp')
AddEventHandler('es:enablePvp', function()
    SetCanAttackFriendly(PlayerPedId(), true, true)
    NetworkSetFriendlyFireOption(true)
end)
