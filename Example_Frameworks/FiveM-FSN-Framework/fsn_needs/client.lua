local hunger, thirst, stress = 100.0, 100.0, 0.0
local init, paused, ded = false, false, false
local notifStarve, notifThirst = false, false
local isAnimated = false

local function getThirst()
    return thirst
end
exports('fsn_thirst', getThirst)

local function getHunger()
    return hunger
end
exports('fsn_hunger', getHunger)

local function getStress()
    return stress
end
exports('fsn_stress', getStress)

AddEventHandler('fsn_inventory:initChar', function()
    init = true
    hunger, thirst, stress = 0.0, 0.0, 0.0
end)

RegisterNetEvent('fsn_hungerandthirst:pause')
AddEventHandler('fsn_hungerandthirst:pause', function()
    paused = true
    TriggerEvent('fsn_notify:displayNotification', 'Hunger, thirst, and stress usage has been paused', 'centerRight', 3000, 'info')
end)

RegisterNetEvent('fsn_hungerandthirst:unpause')
AddEventHandler('fsn_hungerandthirst:unpause', function()
    paused = false
    TriggerEvent('fsn_notify:displayNotification', 'Hunger, thirst, and stress usage has been reactivated', 'centerRight', 3000, 'info')
end)

RegisterNetEvent('fsn_ems:reviveMe')
AddEventHandler('fsn_ems:reviveMe', function()
    ded = false
end)

CreateThread(function()
    while true do
        Wait(1000)
        if init then
            local playerPed = PlayerPedId()
            local currentHealth = GetEntityHealth(playerPed)

            -- Hunger handling
            if hunger <= 0.006 then
                currentHealth = currentHealth - 3
                if currentHealth < 105 and not ded then
                    TriggerEvent('fsn_ems:killMe')
                    TriggerEvent('fsn_notify:displayNotification', 'You forgot to eat!', 'centerLeft', 5000, 'error')
                    ded = true
                else
                    if not ded then
                        SetEntityHealth(playerPed, currentHealth - 2)
                    end
                    if not notifStarve then
                        TriggerEvent('fsn_notify:displayNotification', 'You are <b>STARVING', 'centerLeft', 3000, 'info')
                        notifStarve = true
                    end
                end
            elseif not paused then
                hunger = math.max(hunger - 0.005, 0)
                notifStarve = false
            end

            -- Thirst handling
            if thirst <= 0.007 then
                currentHealth = currentHealth - 3
                if currentHealth < 105 and not ded then
                    TriggerEvent('fsn_ems:killMe')
                    TriggerEvent('fsn_notify:displayNotification', 'You forgot to drink!', 'centerLeft', 5000, 'error')
                    ded = true
                else
                    if not ded then
                        SetEntityHealth(playerPed, currentHealth - 2)
                    end
                    if not notifThirst then
                        TriggerEvent('fsn_notify:displayNotification', 'You are <b>THIRSTY', 'centerLeft', 3000, 'info')
                        notifThirst = true
                    end
                end
            elseif not paused then
                thirst = math.max(thirst - 0.01, 0)
                notifThirst = false
            end
        end
    end
end)

-- blacklisted weapons (no stress from these)
local blacklistedWeapons = {
    'WEAPON_FIREEXTINGUISHER',
    'WEAPON_FLARE'
}

local function isBlacklistedWeapon()
    local _, currentWeapon = GetCurrentPedWeapon(PlayerPedId())
    for _, weaponName in ipairs(blacklistedWeapons) do
        if currentWeapon == GetHashKey(weaponName) then
            return true
        end
    end
    return false
end

CreateThread(function()
    while true do
        Wait(10)
        local playerPed = PlayerPedId()
        if IsPedShooting(playerPed) and not exports.fsn_police:fsn_PDDuty() and not isBlacklistedWeapon() then
            TriggerEvent('fsn_needs:stress:add', 1)
        elseif IsPedShooting(playerPed) and exports.fsn_police:fsn_PDDuty() and not isBlacklistedWeapon() then
            TriggerEvent('fsn_needs:stress:add', 0.1)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(10)
        if stress >= 100 then
            Wait(2000)
            ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.10)
        elseif stress >= 90 then
            Wait(2000)
            ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.06)
        elseif stress >= 50 then
            Wait(4000)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
        elseif stress >= 25 then
            Wait(6000)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.04)
        else
            Wait(1000)
        end
    end
end)

RegisterNetEvent('fsn_inventory:use:food')
AddEventHandler('fsn_inventory:use:food', function(relief)
    if hunger + relief >= 100 then
        hunger = 100
    else
        hunger = hunger + relief
    end
    eat()
end)

RegisterNetEvent('fsn_inventory:use:drink')
AddEventHandler('fsn_inventory:use:drink', function(relief)
    if thirst + relief >= 100 then
        thirst = 100
    else
        thirst = thirst + relief
    end
    drink()
end)

RegisterNetEvent('fsn_needs:stress:add')
AddEventHandler('fsn_needs:stress:add', function(increase)
    if stress + increase >= 100 then
        stress = 100
    else
        stress = stress + increase
    end
end)

RegisterNetEvent('fsn_needs:stress:remove')
AddEventHandler('fsn_needs:stress:remove', function(relief)
    if stress - relief <= 0 then
        stress = 0
    else
        stress = stress - relief
    end
end)

function drink()
    if not isAnimated then
        local propName = 'prop_ld_flow_bottle'
        isAnimated = true
        CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(propName), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.032, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

            RequestAnimDict('mp_player_intdrink')
            while not HasAnimDictLoaded('mp_player_intdrink') do
                Wait(0)
            end
            TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

            Wait(3000)
            isAnimated = false
            ClearPedSecondaryTask(playerPed)
            DeleteObject(prop)
        end)
    end
end

function eat()
    if not isAnimated then
        local propName = 'prop_cs_burger_01'
        isAnimated = true
        CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(propName), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

            RequestAnimDict('mp_player_inteat@burger')
            while not HasAnimDictLoaded('mp_player_inteat@burger') do
                Wait(0)
            end
            TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, 2000, 0, 1, true, true, true)

            Wait(3000)
            isAnimated = false
            ClearPedSecondaryTask(playerPed)
            DeleteObject(prop)
        end)
    end
end

