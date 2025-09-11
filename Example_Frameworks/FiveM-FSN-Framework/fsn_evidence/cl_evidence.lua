local evidence = {}

--[[
    -- Type: Event Handler
    -- Name: fsn_evidence:receive
    -- Use: Updates local evidence list from the server
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_evidence:receive', function(tbl)
    evidence = tbl
end)

local collecting, destroying = false, false
local actionId, actionStart = 0, 0
local actionDuration = 4000

Util.Tick(function()
    local ped = PlayerPedId()
    if collecting then
        if actionStart + actionDuration < GetGameTimer() then
            TriggerServerEvent('fsn_evidence:collect', actionId)
            actionStart = 0
            FreezeEntityPosition(ped, false)
            ClearPedTasks(ped)
            collecting = false
        else
            FreezeEntityPosition(ped, true)
        end
    elseif destroying then
        if actionStart + actionDuration < GetGameTimer() then
            TriggerServerEvent('fsn_evidence:destroy', actionId)
            actionStart = 0
            FreezeEntityPosition(ped, false)
            ClearPedTasks(ped)
            destroying = false
        else
            FreezeEntityPosition(ped, true)

            local dict = 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@'
            local anim = 'plant_floor'
            if not HasAnimDictLoaded(dict) then
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Wait(0)
                end
            end
            if not IsEntityPlayingAnim(ped, dict, anim, 3) and not IsPedRagdoll(ped) then
                TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 49, 1.0, false, false, false)
            end
        end
    end
end)

local displaying = false

--[[
    -- Type: Event Handler
    -- Name: fsn_evidence:display
    -- Use: Displays evidence details on screen
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_evidence:display', function(tbl)
    displaying = tbl
end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local plyCoords = GetEntityCoords(ped)

        if displaying then
            if displaying.e_type == 'blood' then
                Util.DrawText3D(displaying.loc.x, displaying.loc.y, displaying.loc.z,
                    ('~r~Blood~w~\nDNA MARKUP: %s\n\n[LALT+E] Close'):format(displaying.details.dnastring),
                    {255,255,255,240}, 0.25)
            elseif displaying.e_type == 'casing' then
                Util.DrawText3D(displaying.loc.x, displaying.loc.y, displaying.loc.z,
                    ('~r~%s Casing~w~\nMarking: %s\n\n[LALT+E] Close'):format(displaying.details.ammoType, displaying.details.serial),
                    {255,255,255,240}, 0.25)
            end
            if IsControlPressed(0, 19) and IsControlJustPressed(0, 38) then
                displaying = false
            end
        end

        for k, e in ipairs(evidence) do
            local dist = #(vector3(e.loc.x, e.loc.y, e.loc.z) - plyCoords)
            if e.e_type == 'blood' and dist < 50.0 then
                DrawMarker(25, e.loc.x, e.loc.y, e.loc.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 150, false, false, 2, false, 0, 0, false)
                if dist < 0.5 then
                    if not exports['fsn_ems']:isCrouching() then
                        Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Crouch to interact', {255,255,255,50}, 0.2)
                    else
                        if collecting or destroying then
                            Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Blood~w~\nWorking...', {255,255,255,240}, 0.2)
                        else
                            if exports['fsn_police']:fsn_PDDuty() then
                                Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Blood\n[LALT+E] Collect', {255,255,255,100}, 0.2)
                                if IsControlPressed(0, 19) and IsControlJustPressed(0, 38) then
                                    collecting = true
                                    actionId = k
                                    actionStart = GetGameTimer()
                                end
                            else
                                Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Blood~w~\n[LALT+E] Destroy', {255,255,255,100}, 0.2)
                                if IsControlPressed(0, 19) and IsControlJustPressed(0, 38) then
                                    destroying = true
                                    actionId = k
                                    actionStart = GetGameTimer()
                                end
                            end
                        end
                    end
                end
            elseif e.e_type == 'casing' and dist < 50.0 then
                DrawMarker(25, e.loc.x, e.loc.y, e.loc.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 150, false, false, 2, false, 0, 0, false)
                if dist < 0.5 then
                    if not exports['fsn_ems']:isCrouching() then
                        Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Crouch to interact', {255,255,255,50}, 0.2)
                    else
                        if collecting or destroying then
                            Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, ('~r~%s Casing~w~\nWorking...'):format(e.details.ammoType), {255,255,255,240}, 0.2)
                        else
                            if exports['fsn_police']:fsn_PDDuty() then
                                Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, ('~r~%s Casing~w~\n[LALT+E] Collect'):format(e.details.ammoType), {255,255,255,100}, 0.2)
                                if IsControlPressed(0, 19) and IsControlJustPressed(0, 38) then
                                    collecting = true
                                    actionId = k
                                    actionStart = GetGameTimer()
                                end
                            else
                                Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, ('~r~%s Casing~w~\n[LALT+E] Destroy'):format(e.details.ammoType), {255,255,255,100}, 0.2)
                                if IsControlPressed(0, 19) and IsControlJustPressed(0, 38) then
                                    destroying = true
                                    actionId = k
                                    actionStart = GetGameTimer()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

TriggerServerEvent('fsn_evidence:request')

