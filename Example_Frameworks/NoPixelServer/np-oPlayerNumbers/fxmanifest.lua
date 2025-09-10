--[[
    -- Type: Manifest
    -- Name: fxmanifest
    -- Use: Defines resource metadata for FiveM.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'

lua54 'yes'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    '@np-infinity/client/cl_lib.lua',
    'client.lua'
}

server_scripts {
    '@np-infinity/server/sv_lib.lua'
}

