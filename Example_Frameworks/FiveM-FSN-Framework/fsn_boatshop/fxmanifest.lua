--[[
    -- Type: Manifest
    -- Name: fsn_boatshop
    -- Use: Defines resource metadata and script loading
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@fsn_main/server_settings/sh_settings.lua',
    'config.lua'
}

client_scripts {
    '@fsn_main/cl_utils.lua',
    'cl_boatshop.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@mysql-async/lib/MySQL.lua',
    'sv_boatshop.lua'
}
