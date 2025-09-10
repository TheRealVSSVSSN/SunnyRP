local guiEnabled = false

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Sends NUI message to display task notification
    -- Created: 2024-05-09
    -- By: VSSVSSN
--]]
local function openGui(color, msg, time)
    guiEnabled = true
    SendNUIMessage({
        runProgress = true,
        colorsent = color,
        textsent = msg,
        fadesent = time
    })
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Sends NUI message to hide task notifications
    -- Created: 2024-05-09
    -- By: VSSVSSN
--]]
local function closeGui()
    guiEnabled = false
    SendNUIMessage({ closeProgress = true })
end

--[[
    -- Type: Event
    -- Name: tasknotify:guiupdate
    -- Use: Triggered to display a new notification
    -- Created: 2024-05-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('tasknotify:guiupdate', function(color, message, time)
    openGui(color, message, time)
end)

--[[
    -- Type: Event
    -- Name: tasknotify:guiclose
    -- Use: Triggered to clear all notifications
    -- Created: 2024-05-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('tasknotify:guiclose', function()
    closeGui()
end)
