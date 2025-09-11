local id_spot = vector3(-551.4475, -190.3376, 38.21968)
local dl_spot = vector3(-553.8140, -191.7673, 38.21967)

local myChar = {}

--[[
    -- Type: Event
    -- Name: fsn_main:character
    -- Use: Stores character data for ID requests
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_main:character', function(tbl)
    myChar = tbl
end)

--[[
    -- Type: Thread
    -- Name: ID Desk Thread
    -- Use: Handles ID collection interaction at the city hall desk
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if #(GetEntityCoords(PlayerPedId()) - vector3(-548.1985, -199.1042, 38.21966)) < 50 then
            DrawMarker(25, id_spot.x, id_spot.y, id_spot.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 150, false, false, 2, false, false, false, false)
            DrawMarker(25, dl_spot.x, dl_spot.y, dl_spot.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 150, false, false, 2, false, false, false, false)

            if #(GetEntityCoords(PlayerPedId()) - dl_spot) < 0.5 then
                Util.DrawText3D(dl_spot.x, dl_spot.y, dl_spot.z, '[E] Buy ~b~Drivers License~w~ ($500)\n~r~UNAVAILABLE', {255,255,255,200}, 0.25)
            end

            if #(GetEntityCoords(PlayerPedId()) - id_spot) < 0.5 then
                Util.DrawText3D(id_spot.x, id_spot.y, id_spot.z, '[E] Collect ~g~Citizen ID', {255,255,255,200}, 0.25)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('fsn_licenses:id:request', myChar)
                end
            end
        end
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:giveID
    -- Use: Requests an ID card from the server
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:giveID')
AddEventHandler('fsn_licenses:giveID', function()
    TriggerServerEvent('fsn_licenses:id:request', myChar)
end)

