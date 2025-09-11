local function drawRct(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

local function getThirst()
    return exports["fsn_needs"]:fsn_thirst()
end

local function getHunger()
    return exports["fsn_needs"]:fsn_hunger()
end

local function getStress()
    return exports["fsn_needs"]:fsn_stress()
end

CreateThread(function()
    while true do
        Wait(0)

        if not IsAimCamActive() or not IsFirstPersonAimCamActive() then
            HideHudComponentThisFrame(14)
        end

        for _, hud_comp in pairs({1, 6, 7, 9}) do
            if IsHudComponentActive(hud_comp) then
                HideHudComponentThisFrame(hud_comp)
            end
        end

        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            HideHudComponentThisFrame(0)
        end
        SetPedMinGroundTimeForStungun(PlayerPedId(), 8000)

        drawRct(0.015, 0.9677, 0.1418, 0.028, 81, 81, 84, 165)

        local health = GetEntityHealth(PlayerPedId()) - 100
        local varSet = 0.06938 * (health / 100)
        drawRct(0.016, 0.97, 0.06938, 0.01, 188, 188, 188, 80)
        drawRct(0.016, 0.97, varSet, 0.01, 55, 185, 55, 177)

        local armor = math.min(GetPedArmour(PlayerPedId()), 100.0)
        varSet = 0.06938 * (armor / 100)
        drawRct(0.0865, 0.97, 0.06938, 0.01, 188, 188, 188, 80)
        drawRct(0.0865, 0.97, varSet, 0.01, 115, 115, 255, 177)

        varSet = 0.05848 * (getHunger() / 100)
        drawRct(0.016, 0.983, 0.05848, 0.01, 188, 188, 188, 80)
        drawRct(0.016, 0.983, varSet, 0.01, 200, 93, 4, 177)

        varSet = 0.05848 * (getThirst() / 100)
        drawRct(0.0754, 0.983, 0.05848, 0.01, 188, 188, 188, 80)
        drawRct(0.0754, 0.983, varSet, 0.01, 91, 255, 238, 177)

        varSet = 0.02038 * (getStress() / 100)
        drawRct(0.1352, 0.983, 0.02038, 0.01, 188, 188, 188, 80)
        drawRct(0.1352, 0.983, varSet, 0.01, 230, 255, 0, 177)
    end
end)

RegisterNetEvent('fsn_inventory:useArmor')
AddEventHandler('fsn_inventory:useArmor', function()
    local playerPed = PlayerPedId()
    if GetPedArmour(playerPed) < 100 then
        exports["fsn_progress"]:fsn_ProgressBar(58, 133, 255, 'Putting on armor', 10)
        Wait(10000)
        TriggerEvent('fsn_inventory:item:take', 'armor', 1)
        AddArmourToPed(playerPed, 100)
    else
        exports['mythic_notify']:DoCustomHudText('error', 'You already have full armor', 5000)
    end
    if GetPedArmour(playerPed) >= 100 then
        SetPedArmour(playerPed, 100)
    end
end)

