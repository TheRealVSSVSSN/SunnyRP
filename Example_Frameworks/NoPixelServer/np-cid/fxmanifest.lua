--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata for FiveM
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'

client_script '@np-errorlog/client/cl_errorlog.lua'
client_script 'cid_client.lua'
server_script 'cid_server.lua'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/styles.css',
    'html/scripts.js',
    'html/background2.png'
}
