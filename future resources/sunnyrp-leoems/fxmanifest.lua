fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-leoems'
author 'Sunny Roleplay'
description 'SRP LEO/EMS/DOJ Foundations — MDT, Dispatch, /911 /311, cuff/escort, revive'
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