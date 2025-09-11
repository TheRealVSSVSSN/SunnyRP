--[[
    -- Type: Manifest
    -- Name: fxmanifest
    -- Use: Defines resource metadata and scripts
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
lua54 'yes'
game 'gta5'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'cl_utils.lua',
    'gui.lua',
    'cl_towgarage.lua',
    'sh_tow.lua'
}

server_scripts {
    'sv_towgarage.lua'
}
