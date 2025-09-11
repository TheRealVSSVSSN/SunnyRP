-------------------
-- Instance stuff
-------------------
local instanced = false
local instance_debug = false
local myinstance = {}

function inInstance()
    return instanced
end

CreateThread(function()
    while true do
        Wait(0)
        if instance_debug then
            local xyz = GetEntityCoords(PlayerPedId())
            if instanced then
                fsn_drawText3D(xyz.x, xyz.y, xyz.z, 'InstanceID: '..myinstance.id..'\nPlayers: '..table.concat(myinstance.players, ', ')..'\nCreated: '..myinstance.created)
            else
                fsn_drawText3D(xyz.x, xyz.y, xyz.z, 'No instance')
            end
        end
        for _, id in ipairs(GetActivePlayers()) do
            if instanced then
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetRandomVehicleDensityMultiplierThisFrame(0.0)
                if table.contains(myinstance.players, GetPlayerServerId(id)) then
                    local ped = GetPlayerPed(id)
                    SetEntityVisible(ped, true, 0)
                    SetEntityCollision(ped, true, true)
                else
                    local ped = GetPlayerPed(id)
                    if ped ~= PlayerPedId() then
                        SetEntityVisible(ped, false, 0)
                        SetEntityCollision(ped, false, false)
                    end
                end
            else
                SetVehicleDensityMultiplierThisFrame(0.2)
                SetRandomVehicleDensityMultiplierThisFrame(0.2)
                local ped = GetPlayerPed(id)
                if ped ~= PlayerPedId() then
                    SetEntityVisible(ped, true, 0)
                    SetEntityCollision(ped, true, true)
                end
            end
        end
    end
end)

RegisterNetEvent('fsn_apartments:instance:join')
AddEventHandler('fsn_apartments:instance:join', function(inst)
    instanced = true
    myinstance = inst
end)

RegisterNetEvent('fsn_apartments:instance:update')
AddEventHandler('fsn_apartments:instance:update', function(inst)
    myinstance = inst
end)

RegisterNetEvent('fsn_apartments:instance:leave')
AddEventHandler('fsn_apartments:instance:leave', function()
    instanced = false
    myinstance = {}
end)

RegisterNetEvent('fsn_apartments:instance:debug')
AddEventHandler('fsn_apartments:instance:debug', function()
    instance_debug = not instance_debug
end)

function table.contains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

