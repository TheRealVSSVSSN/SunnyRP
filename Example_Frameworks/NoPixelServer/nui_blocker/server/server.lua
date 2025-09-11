--[[
    -- Type: Event
    -- Name: nui_blocker:devtoolsDetected
    -- Use: Logs devtools usage and disconnects offending players
    -- Created: 2024-03-09
    -- By: VSSVSSN
--]]

local WEBHOOK_URL = 'https://discord.com/api/webhooks/794144881588961310/6SJYFpSdmd8xyTgMcWWI3awUDoF7uQT7wbZ53uTNscMm0YIt_DMF7Ti16PAn3H3MX4JW'

--[[
    -- Type: Function
    -- Name: logToDiscord
    -- Use: Sends a formatted embed to Discord
    -- Created: 2024-03-09
    -- By: VSSVSSN
--]]
local function logToDiscord(title, message)
    local embed = {
        {
            color = 16711680,
            title = title,
            description = message,
            footer = { text = 'Made by sway' }
        }
    }

    PerformHttpRequest(WEBHOOK_URL, function() end, 'POST', json.encode({
        username = 'Asshole Log',
        embeds = embed,
        avatar_url = 'https://miro.medium.com/max/1000/1*MqFcwBk0Vr8UsFDVV-1Zfg.gif'
    }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('nui_blocker:devtoolsDetected')
AddEventHandler('nui_blocker:devtoolsDetected', function()
    local src = source
    local playerName = GetPlayerName(src)

    print(('detekted %s'):format(playerName))
    logToDiscord('Asshole Logged', ('%s tried to use nui_devtools at %s'):format(playerName, os.time()))
    DropPlayer(src, 'Hmm, what you wanna do in this inspector?')
end)

