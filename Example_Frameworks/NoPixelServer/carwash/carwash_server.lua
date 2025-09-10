--[[
    Type: Server Script
    Name: carwash_server.lua
    Use: Validates player funds and processes carwash payments.
    Created: 2024-06-05
    By: VSSVSSN
]]

local PRICE = 70

RegisterNetEvent('carwash:checkmoney', function()
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)

    if not user then return end

    if user:getCash() >= PRICE then
        user:removeMoney(PRICE)
        TriggerClientEvent('carwash:success', src, PRICE)
    else
        local short = PRICE - user:getCash()
        TriggerClientEvent('carwash:notenoughmoney', src, short)
    end
end)
