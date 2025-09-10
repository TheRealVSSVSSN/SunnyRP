--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata for FiveM
    -- Created: 2024-06-29
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/cursor.png',
    'html/background.png',
    'html/styles.css',
    'html/scripts.js'
}

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'client.lua'
}
