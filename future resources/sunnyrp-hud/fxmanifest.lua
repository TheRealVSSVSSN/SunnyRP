fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-hud'
author 'Sunny Roleplay'
description 'SRP HUD — vitals, status, identity, voice; per-item/group visibility; low-GPU NUI'
version '1.0.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js'
}

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