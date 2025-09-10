--[[
    Type: Client Script
    Name: carwash_client.lua
    Use: Handles carwash interaction, blips, and feedback to the player.
    Created: 2024-06-05
    By: VSSVSSN
]]

local INTERACT_KEY = 201 -- ENTER

local washStations = {
    vec3(26.5906, -1392.0261, 27.3634),
    vec3(167.1034, -1719.4704, 27.2916),
    vec3(-74.5693, 6427.8715, 29.44),
    vec3(-699.6325, -932.7043, 17.0139)
}

CreateThread(function()
    for _, coords in ipairs(washStations) do
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 100)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
    end
end)

local function drawSpecialText(text, duration)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(duration, true)
end

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local pCoords = GetEntityCoords(ped)
            for _, coords in ipairs(washStations) do
                local distance = #(pCoords - coords)
                if distance < 10.0 then
                    sleep = 0
                    DrawMarker(27, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 2.0, 0, 157, 0, 155, false, false, 2, false, nil, nil, false)
                    if distance < 5.0 then
                        drawSpecialText("Press ~g~ENTER~s~ to clean your vehicle!", 1)
                        if IsControlJustReleased(1, INTERACT_KEY) then
                            TriggerServerEvent("carwash:checkmoney")
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent("carwash:success", function(price)
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleUndriveable(vehicle, false)
    drawSpecialText(("Vehicle ~y~Clean~s~! ~g~-$%s~s~!"):format(price), 5000)
end)

RegisterNetEvent("carwash:notenoughmoney", function(moneyLeft)
    drawSpecialText(("~h~~r~You don't have enough money! $%s left!"):format(moneyLeft), 5000)
end)

RegisterNetEvent("carwash:free", function()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleUndriveable(vehicle, false)
    drawSpecialText("Vehicle ~y~Clean~s~ for free!", 5000)
end)
