fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Model Menu v3 by Frazzle :D'

client_scripts {
    '@fsn_main/cl_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    'gui.lua',
    'client.lua',
    'config.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

exports {
    'isClothingOpen',
    'GetOutfit'
}
