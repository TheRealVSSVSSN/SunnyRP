--[[
    -- Type: Function
    -- Name: sanitizeVehicleColors
    -- Use: Ensures vehicle color indices are valid
    -- Created: 2024-05-24
    -- By: VSSVSSN
--]]
local function sanitizeVehicleColors(color1, color2)
    color1 = color1 == 0 and 1 or color1 == -1 and 158 or math.min(color1, 158)
    color2 = color2 == 0 and 2 or color2 == -1 and 158 or math.min(color2, 158)
    return color1, color2
end

local announcements = 0

--[[
    -- Type: Event
    -- Name: AlertReckless
    -- Use: Handles reckless driving reports
    -- Created: 2024-05-24
    -- By: VSSVSSN
--]]
RegisterNetEvent('AlertReckless')
AddEventHandler('AlertReckless', function(street1, gender, plate, make, color1, color2, street2)
    color1, color2 = sanitizeVehicleColors(color1, color2)
    TriggerEvent('dispatch:svNotify', { dispatchCode = "10-94", gender = gender, firstStreet1 = street1, secondStreet = street2, model = make, plate = plate })
end)

--[[
    -- Type: Event
    -- Name: thiefInProgressS1
    -- Use: Reports vehicle theft in progress
    -- Created: 2024-05-24
    -- By: VSSVSSN
--]]
RegisterNetEvent('thiefInProgressS1')
AddEventHandler('thiefInProgressS1', function(street1, gender, plate, make, color1, color2, pOrigin)
    color1, color2 = sanitizeVehicleColors(color1, color2)
    plate = string.upper(plate)
    TriggerEvent('dispatch:svNotify', { dispatchCode = "10-60", gender = gender, firstStreet1 = street1, model = make, plate = plate, firstColor = color1, secondColor = color2, origin = pOrigin })
end)

--[[
    -- Type: Event
    -- Name: judgeAnnounce
    -- Use: Broadcasts state announcements
    -- Created: 2024-05-24
    -- By: VSSVSSN
--]]
RegisterNetEvent('judgeAnnounce')
AddEventHandler('judgeAnnounce', function(Message)
    announcements = announcements + 1
    if announcements < 3 then
        TriggerClientEvent('chatMessage', -1, "^1[State Announcement]", {255, 0, 0}, Message)
    else
        TriggerClientEvent('chatMessage', -1, "^1No", {255, 0, 0}, "Too many announcements sent.")
    end
end)

--[[
    -- Type: Event
    -- Name: actionclose
    -- Use: Sends range text to a specific player
    -- Created: 2024-05-24
    -- By: VSSVSSN
--]]
RegisterNetEvent('actionclose')
AddEventHandler('actionclose', function(player, text, id)
    TriggerClientEvent('outlawNoticeRangeText', player, id, text)
end)
