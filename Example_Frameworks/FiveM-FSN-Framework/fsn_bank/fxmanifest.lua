fx_version 'cerulean'
game 'gta5'

description 'Banking for the server'
lua54 'yes'

shared_scripts {
  '@fsn_main/server_settings/sh_settings.lua'
}

client_scripts {
  '@fsn_main/cl_utils.lua',
  'client.lua'
}

server_scripts {
  '@fsn_main/sv_utils.lua',
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}

ui_page 'gui/index.html'

files {
  'gui/index.html',
  'gui/index.js',
  'gui/index.css',
  'gui/atm_logo.png',
  'gui/atm_button_sound.mp3'
}
