local BROADCAST_RADIO = 19829
local STATIONS = { vector3(1989.08, -1753.94, -158.86) }
local NEAR_DISTANCE = 3.0
local LEAVE_DISTANCE = 30.0

local isBroadcasting = false

--[[ 
    -- Type: Function
    -- Name: drawText3D
    -- Use: Renders 3D text at a world coordinate
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
local function drawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

--[[ 
    -- Type: Function
    -- Name: isPlayerNearStation
    -- Use: Checks if player is within distance of a broadcast station
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
local function isPlayerNearStation(dist)
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    for _, station in ipairs(STATIONS) do
        if #(pCoords - station) < dist then
            return true, station
        end
    end
    return false, nil
end

--[[ 
    -- Type: Function
    -- Name: startBroadcast
    -- Use: Adds player to radio channel and marks broadcasting
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
local function startBroadcast()
    TriggerServerEvent('TokoVoip:addPlayerToRadio', BROADCAST_RADIO, GetPlayerServerId(PlayerId()))
    isBroadcasting = true
end

--[[ 
    -- Type: Function
    -- Name: stopBroadcast
    -- Use: Removes player from radio and job
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
local function stopBroadcast()
    isBroadcasting = false
    TriggerServerEvent('TokoVoip:removePlayerFromAllRadio', GetPlayerServerId(PlayerId()))
    TriggerServerEvent('jobssystem:jobs', 'unemployed')
    TriggerEvent('DoLongHudText', 'You have left the broadcasting job!', 1)
end

RegisterNetEvent('event:control:broadcast')
AddEventHandler('event:control:broadcast', function(useID)
    if useID == 1 then
        TriggerServerEvent('attemptBroadcast')
    elseif useID == 2 and isBroadcasting then
        stopBroadcast()
    end
end)

RegisterNetEvent('broadcast:becomejob')
AddEventHandler('broadcast:becomejob', startBroadcast)

CreateThread(function()
    while true do
        local sleep = 1000
        local near, station = isPlayerNearStation(NEAR_DISTANCE)
        if near then
            sleep = 5
            drawText3D(station.x, station.y, station.z, '[E] Start Broadcasting | [F] Stop Broadcasting')
        end

        if isBroadcasting and not isPlayerNearStation(LEAVE_DISTANCE) then
            stopBroadcast()
        end

        Wait(sleep)
    end
end)

