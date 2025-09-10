--[[
    -- Type: Thread
    -- Name: deathEventWatcher
    -- Use: Detects player death and dispatches baseevents
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    local isDead = false
    local hasBeenDead = false
    local diedAt

    while true do
        Wait(0)
        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()

            if IsPedFatallyInjured(ped) and not isDead then
                isDead = true
                diedAt = diedAt or GetGameTimer()

                local killer, weapon = NetworkGetEntityKillerOfPlayer(player)
                local killerEntityType = GetEntityType(killer)
                local killerPedType = -1
                local killerInVehicle = false
                local killerVehicleName = ''
                local killerVehicleSeat = 0

                if killerEntityType == 1 then
                    killerPedType = GetPedType(killer)
                    if IsPedInAnyVehicle(killer, false) then
                        killerInVehicle = true
                        local veh = GetVehiclePedIsUsing(killer)
                        killerVehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                        killerVehicleSeat = GetPedVehicleSeat(killer)
                    end
                end

                local killerId = NetworkGetPlayerIndexFromPed(killer)
                if killer ~= ped and killerId ~= nil and NetworkIsPlayerActive(killerId) then
                    killerId = GetPlayerServerId(killerId)
                else
                    killerId = -1
                end

                local coords = GetEntityCoords(ped)

                if killer == ped or killerId == -1 then
                    TriggerEvent('baseevents:onPlayerDied', killerPedType, {coords.x, coords.y, coords.z})
                    TriggerServerEvent('baseevents:onPlayerDied', killerPedType, {coords.x, coords.y, coords.z})
                    hasBeenDead = true
                else
                    local data = {
                        killertype = killerPedType,
                        weaponhash = weapon,
                        killerinveh = killerInVehicle,
                        killervehseat = killerVehicleSeat,
                        killervehname = killerVehicleName,
                        killerpos = {coords.x, coords.y, coords.z}
                    }
                    TriggerEvent('baseevents:onPlayerKilled', killerId, data)
                    TriggerServerEvent('baseevents:onPlayerKilled', killerId, data)
                    hasBeenDead = true
                end
            elseif not IsPedFatallyInjured(ped) and isDead then
                isDead = false
                hasBeenDead = false
                diedAt = nil
            end

            if not hasBeenDead and diedAt then
                local coords = GetEntityCoords(ped)
                TriggerEvent('baseevents:onPlayerWasted', {coords.x, coords.y, coords.z})
                TriggerServerEvent('baseevents:onPlayerWasted', {coords.x, coords.y, coords.z})
                hasBeenDead = true
            end
        end
    end
end)
