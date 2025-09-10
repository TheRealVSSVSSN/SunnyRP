--[[
    -- Type: Variable
    -- Name: progressActive
    -- Use: Tracks whether a progress bar is currently displayed
    -- Created: 2024-07-XX
    -- By: VSSVSSN
--]]
local progressActive = false

--[[
    -- Type: Function
    -- Name: fsn_ProgressBar
    -- Use: Displays a NUI-based progress bar for a specified duration
    -- Created: 2024-07-XX
    -- By: VSSVSSN
--]]
local function fsn_ProgressBar(r, g, b, title, length)
    if progressActive then return end
    progressActive = true

    SendNUIMessage({
        type = 'progressBar',
        display = true,
        duration = length,
        title = title,
        color = { r = r, g = g, b = b }
    })

    CreateThread(function()
        Wait(length)
        progressActive = false
        SendNUIMessage({ type = 'progressBar', display = false })
    end)
end

--[[
    -- Type: Function
    -- Name: removeBar
    -- Use: Immediately hides the NUI progress bar
    -- Created: 2024-07-XX
    -- By: VSSVSSN
--]]
local function removeBar()
    progressActive = false
    SendNUIMessage({ type = 'progressBar', display = false })
end

exports('fsn_ProgressBar', fsn_ProgressBar)
exports('removeBar', removeBar)

