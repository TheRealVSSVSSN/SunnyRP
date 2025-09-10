fx_version 'cerulean'
game 'gta5'
lua54 'yes'

--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata and scripts
    -- Created: 2024-05-15
    -- By: VSSVSSN
--]]

description 'Modernized dispatch system'

dependencies {
    'ghmattimysql'
}

ui_page 'client/dist/index.html'

files {
    'client/dist/index.html',
    'client/dist/js/app.js',
    'client/dist/css/app.css'
}

client_script 'client/*.lua'
server_script 'server/*.lua'
