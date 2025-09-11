--[[/   :FSN:   \]]--
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_script '@fsn_main/server_settings/sh_settings.lua'

client_scripts {
    '@fsn_main/cl_utils.lua',
    'client.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
--[[/   :FSN:   \]]--
