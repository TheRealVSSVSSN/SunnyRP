--[[
    -- Type: Client
    -- Name: fsn_doj/client.lua
    -- Use: Manages DOJ related blips and notifications
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]

local courtRoomBlip = nil

local COURT_COORDS = vector3(-517.0159, -196.0146, 38.2196)
local CITY_HALL_COORDS = vector3(-540.8025, -211.3674, 37.6498)

--[[
    -- Type: Function
    -- Name: createCourtBlip
    -- Use: Displays a blip for the courtroom when nearby
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
local function createCourtBlip()
    courtRoomBlip = AddBlipForCoord(COURT_COORDS.x, COURT_COORDS.y, COURT_COORDS.z)
    SetBlipSprite(courtRoomBlip, 285)
    SetBlipColour(courtRoomBlip, 2)
    SetBlipAsShortRange(courtRoomBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Court Room')
    EndTextCommandSetBlipName(courtRoomBlip)
    SetBlipScale(courtRoomBlip, 0.5)
end

CreateThread(function()
    local cityHallBlip = AddBlipForCoord(CITY_HALL_COORDS.x, CITY_HALL_COORDS.y, CITY_HALL_COORDS.z)
    SetBlipSprite(cityHallBlip, 58)
    SetBlipColour(cityHallBlip, 36)
    SetBlipAsShortRange(cityHallBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('City Hall')
    EndTextCommandSetBlipName(cityHallBlip)

    while true do
        Wait(1000)
        local dist = #(GetEntityCoords(PlayerPedId()) - COURT_COORDS)
        if dist < 50.0 then
            if not DoesBlipExist(courtRoomBlip) then
                createCourtBlip()
            end
        elseif courtRoomBlip then
            RemoveBlip(courtRoomBlip)
            courtRoomBlip = nil
        end
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_doj:judge:toggleLock
    -- Use: Notifies the player about courtroom lock status
    -- Created: 2024-11-04
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_doj:judge:toggleLock')
AddEventHandler('fsn_doj:judge:toggleLock', function(isLocked)
    local msg = isLocked and 'The courtroom has been locked' or 'The courtroom has been unlocked'
    TriggerEvent('fsn_notify:displayNotification', msg, 'centerLeft', 4000, 'info')
end)
