--[[
    -- Type: Server Script
    -- Name: sv_errorlog
    -- Use: Receives client error logs and forwards them to Discord
    -- Created: 2024-05-27
    -- By: VSSVSSN
--]]

local WEBHOOK_URL = 'https://canary.discord.com/api/webhooks/801641849546342410/LJYXEy_wyWjPpCr412cPcs4ae5-7ynLx86pwPPzxdao8p1Wpv6B_VBBTdOxWTK_qn28u'

local function sendToDiscord(title, message)
    local embeds = {
        {
            color = 16711680,
            title = title,
            description = message or 'no message',
            footer = { text = 'Made by Sway' }
        }
    }

    PerformHttpRequest(
        WEBHOOK_URL,
        function(err, text, headers) end,
        'POST',
        json.encode({
            username = 'Error Log',
            embeds = embeds,
            avatar_url = 'https://i.imgur.com/VuKnN5P_d.webp?maxwidth=728&fidelity=grand'
        }),
        { ['Content-Type'] = 'application/json' }
    )
end

RegisterNetEvent('np-errorlog:logError', function(resource, message)
    sendToDiscord(string.format('```Error in %s```', resource or 'unknown'), message)
end)

