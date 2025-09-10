--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource configuration for koilWeatherSync
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

exports {
    'SetEnableSync'
}

