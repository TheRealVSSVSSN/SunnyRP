fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

description 'Vehicleshop for the server'

--[[/   :FSN:   \]]--
client_scripts {
    '@fsn_main/cl_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua'
}
server_scripts {
    '@fsn_main/sv_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua'
}
--[[/   :FSN:   \]]--

client_scripts {
    'cl_carstore.lua',
    'cl_menu.lua',
}

server_scripts {
    'sv_carstore.lua',
}

ui_page 'gui/index.html'

files {
  'gui/index.html',
  'gui/index.js',
  'gui/index.css',
  'gui/logo.png',
}

-- exports
exports {
  'ShowVehshopBlips',
}
