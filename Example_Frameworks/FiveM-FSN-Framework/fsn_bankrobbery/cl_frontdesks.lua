--[[ 
    -- Type: Client Script
    -- Name: cl_frontdesks.lua
    -- Use: Handles front desk hacking interactions for bank robberies
    -- Created: 2024-04-XX
    -- By: VSSVSSN
--]]

local desks = {}

RegisterNetEvent('fsn_bankrobbery:desks:receive')
AddEventHandler('fsn_bankrobbery:desks:receive', function(tbl)
    desks = tbl or {}
end)

TriggerServerEvent('fsn_bankrobbery:desks:request')

CreateThread(function()
    while true do
        Wait(0)
        local ply = PlayerPedId()
        local plyCoords = GetEntityCoords(ply)
        for bank, data in pairs(desks) do
            local door = data.door
            if #(plyCoords - vector3(door.x, door.y, door.z)) < 3.0 then
                local obj = GetClosestObjectOfType(door.x, door.y, door.z, 1.0, door.mdl, false, false, false)
                if obj ~= 0 then
                    FreezeEntityPosition(obj, door.locked)
                    DoorSystemSetDoorState(door.mdl, door.locked and 4 or 0, false, false)
                    if door.locked then
                        Util.DrawText3D(door.x, door.y, door.z, 'LOCKED', {255, 0, 0, 140}, 0.2)
                    end
                end
            end

            if not door.locked then
                for key, keyboard in pairs(data.keyboards) do
                    local robSpot = keyboard.robspot
                    if #(plyCoords - vector3(robSpot.x, robSpot.y, robSpot.z)) < 0.5 then
                        if keyboard.robbed == 'nothacked' then
                            Util.DrawText3D(keyboard.x, keyboard.y, keyboard.z, '[E] Begin hack', {255,255,255,200}, 0.25)
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent('fsn_bankrobbery:desks:startHack', bank, key)
                                local function afterHack(success)
                                    TriggerServerEvent('fsn_bankrobbery:desks:endHack', bank, key, success)
                                    TriggerEvent('fsn_needs:stress:add', 5)
                                    TriggerEvent('mhacking:hide')
                                end
                                TriggerEvent('mhacking:show')
                                TriggerEvent('mhacking:start', 8, 30, afterHack)
                            end
                        elseif keyboard.robbed == 'hacking' then
                            Util.DrawText3D(keyboard.x, keyboard.y, keyboard.z, 'Hack ongoing...', {245,188,66,200}, 0.25)
                        elseif keyboard.robbed == 'hackingfailed' then
                            Util.DrawText3D(keyboard.x, keyboard.y, keyboard.z, '[E] Try again', {245,188,66,200}, 0.25)
                        else
                            Util.DrawText3D(keyboard.x, keyboard.y, keyboard.z, 'Computer Offline', {255,0,0,100}, 0.25)
                        end
                    end
                end
            end
        end
    end
end)
