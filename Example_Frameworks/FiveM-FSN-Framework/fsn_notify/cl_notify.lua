--[[
    -- Type: Function
    -- Name: SetQueueMax
    -- Use: Updates maximum queue for notifications
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function SetQueueMax(queue, max)
    SendNUIMessage({maxNotifications = {queue = tostring(queue), max = tonumber(max) or 1}})
end

--[[
    -- Type: Function
    -- Name: SendNotification
    -- Use: Sends notification options to NUI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function SendNotification(opts)
    local options = {
        type = opts.type or 'success',
        layout = opts.layout or 'topRight',
        theme = opts.theme or 'gta',
        text = opts.text or 'Empty Notification',
        timeout = opts.timeout or 5000,
        progressBar = opts.progressBar ~= false,
        closeWith = opts.closeWith or {},
        animation = {
            open = opts.animation and opts.animation.open or 'gta_effects_open',
            close = opts.animation and opts.animation.close or 'gta_effects_close'
        },
        sounds = {
            volume = opts.sounds and opts.sounds.volume or 1,
            conditions = opts.sounds and opts.sounds.conditions or {},
            sources = opts.sounds and opts.sounds.sources or {}
        },
        docTitle = {
            conditions = opts.docTitle and opts.docTitle.conditions or {}
        },
        modal = opts.modal or false,
        id = opts.id or false,
        force = opts.force or false,
        queue = opts.queue or 'global',
        killer = opts.killer or false,
        container = opts.container or false,
        buttons = opts.buttons or false
    }

    SendNUIMessage({options = options})
end

exports('SetQueueMax', SetQueueMax)
exports('SendNotification', SendNotification)

--[[
    -- Type: Function
    -- Name: pNotify:SendNotification
    -- Use: Event wrapper for SendNotification
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('pNotify:SendNotification')
AddEventHandler('pNotify:SendNotification', function(options)
    SendNotification(options)
end)

--[[
    -- Type: Function
    -- Name: pNotify:SetQueueMax
    -- Use: Event wrapper for SetQueueMax
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('pNotify:SetQueueMax')
AddEventHandler('pNotify:SetQueueMax', function(queue, max)
    SetQueueMax(queue, max)
end)

--[[
    -- Type: Function
    -- Name: fsn_notify:displayNotification
    -- Use: Displays notification using pNotify wrapper
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_notify:displayNotification')
AddEventHandler('fsn_notify:displayNotification', function(msg, layout, timeout, nType)
    SendNotification({
        text = msg,
        layout = layout,
        timeout = timeout,
        type = nType
    })
end)
