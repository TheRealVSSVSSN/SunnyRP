fx_version 'cerulean'
game 'gta5'

description 'Bankrobbery for the server'

lua54 'yes'

client_scripts {
    '@fsn_main/cl_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    'client.lua',
    'cl_safeanim.lua',
    'cl_frontdesks.lua',
    'trucks.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
    'sv_frontdesks.lua'
}
