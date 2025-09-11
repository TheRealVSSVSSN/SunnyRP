fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Character details for the server'

client_scripts {
    '@fsn_main/cl_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    'gui_manager.lua',
    'tattoos/config.lua',
    'tattoos/client.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua'
}

ui_page 'gui/ui.html'

files {
  'gui/ui.html',
  'gui/ui.css',
  'gui/ui.js'
}

exports {
  'GetPreviousTattoos',
  'GetTattooCategory'
}
