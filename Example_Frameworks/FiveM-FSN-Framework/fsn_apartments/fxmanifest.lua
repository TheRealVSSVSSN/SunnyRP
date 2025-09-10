fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Apartments for the server'

client_scripts {
    '@fsn_main/cl_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    'client.lua',
    'cl_instancing.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
    'sv_instancing.lua'
}

ui_page 'gui/ui.html'

files {
    'gui/ui.html',
    'gui/ui.js',
    'gui/ui.css'
}

exports {
    'inInstance',
    'isNearStorage',
    'EnterMyApartment'
}

