--[[
Complete List of Options:
        type
        layout
        theme
        text
        timeout
        progressBar
        closeWith
        animation = {
            open
            close
        }
        sounds = {
            volume
            conditions
            sources
        }
        docTitle = {
            conditions
        }
        modal
        id
        force
        queue
        killer
        container
        buttons

More details below or visit the creators website http://ned.im/noty/options.html

Layouts:
    top
    topLeft
    topCenter
    topRight
    center
    centerLeft
    centerRight
    bottom
    bottomLeft
    bottomCenter
    bottomRight

Types:
    alert
    success
    error
    warning
    info

Themes: -- You can create more themes inside html/themes.css, use the gta theme as a template.
    gta
    mint
    relax
    metroui

Animations:
    open:
        noty_effects_open
        gta_effects_open
        gta_effects_open_left
        gta_effects_fade_in
    close:
        noty_effects_close
        gta_effects_close
        gta_effects_close_left
        gta_effects_fade_out

closeWith: -- array, You will probably never use this.
    click
    button

sounds:
    volume: 0.0 - 1.0
    conditions: -- array
        docVisible
        docHidden
    sources: -- array of sound files

modal:
    true
    false

force:
    true
    false

queue: -- default is global, you can make it what ever you want though.
    global

killer: -- will close all visible notifications and show only this one
    true
    false

visit the creators website http://ned.im/noty/options.html for more information
--]]

local hudStage = 1

local function setQueueMax(queue, max)
    SendNUIMessage({
        maxNotifications = {
            queue = tostring(queue),
            max = tonumber(max)
        }
    })
end
exports('SetQueueMax', setQueueMax)

local function sendNotification(opts)
    opts.animation = opts.animation or {}
    opts.sounds = opts.sounds or {}
    opts.docTitle = opts.docTitle or {}

    local options = {
        type = opts.type or 'success',
        layout = opts.layout or 'topRight',
        theme = opts.theme or 'gta',
        text = opts.text or 'Empty Notification',
        timeout = opts.timeout or 5000,
        progressBar = opts.progressBar ~= false,
        closeWith = opts.closeWith or {},
        animation = {
            open = opts.animation.open or 'gta_effects_open',
            close = opts.animation.close or 'gta_effects_close'
        },
        sounds = {
            volume = opts.sounds.volume or 1,
            conditions = opts.sounds.conditions or {},
            sources = opts.sounds.sources or {}
        },
        docTitle = {
            conditions = opts.docTitle.conditions or {}
        },
        modal = opts.modal or false,
        id = opts.id or false,
        force = opts.force or false,
        queue = opts.queue or 'global',
        killer = opts.killer or false,
        container = opts.container or false,
        buttons = opts.buttons or false
    }

    SendNUIMessage({ options = options })
end
exports('SendNotification', sendNotification)

RegisterNetEvent('disableHUD', function(passedinfo)
    hudStage = passedinfo
end)

RegisterNetEvent('pNotify:SendNotification', function(opts)
    if hudStage < 3 then
        sendNotification(opts)
    end
end)

RegisterNetEvent('pNotify:SetQueueMax', function(queue, max)
    setQueueMax(queue, max)
end)

