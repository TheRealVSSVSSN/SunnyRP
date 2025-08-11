fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-base'
author 'Sunny Roleplay'
description 'SRP Base Framework - Phase A'
version '1.0.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js'
}

shared_scripts {
  'shared/utils.lua',
  'config.lua'
}

client_scripts {
  'client/main.lua'
}

server_scripts {
  'server/main.lua'
}