--[[
    -- Type: Manifest
    -- Name: fsn_priority
    -- Use: Resource manifest
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
lua54 'yes'
game 'gta5'

shared_script '@fsn_main/server_settings/sh_settings.lua'

client_scripts {
    '@fsn_main/cl_utils.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@mysql-async/lib/MySQL.lua',
    '@connectqueue/connectqueue.lua',
    'server.lua',
    'administration.lua'
}

dependencies {
    'connectqueue',
    'mysql-async'
}

