--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata and file references
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script '@np-errorlog/client/cl_errorlog.lua'

ui_page 'index.html'

files {
    'index.html',
    'scripts.js',
    'css/style.css'
}

client_script 'client.lua'

exports {
    'taskBar',
    'closeGuiFail'
}

