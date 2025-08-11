fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-admin'
author 'Sunny Roleplay'
description 'SRP Admin Toolkit — spectate, noclip, bring/goto, cleanup, bans, audit'
version '1.0.0'

client_scripts {
  '@sunnyrp-base/shared/utils.lua',
  'client/main.lua'
}

server_scripts {
  '@sunnyrp-base/shared/utils.lua',
  '@sunnyrp-base/config.lua',
  'config.lua',
  'server/main.lua'
}

ui_page 'html/index.html'
files { 'html/index.html', 'html/style.css', 'html/app.js' }