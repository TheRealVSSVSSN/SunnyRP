fx_version 'cerulean'
game 'gta5'

name 'sunnyrp-chat'
author 'SunnyRP'
description 'SunnyRP proximity chat with scopes, rate limits, profanity filter, NUI'
version '0.2.0'
lua54 'yes'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js',
}

shared_scripts {
  -- none
}

client_scripts {
  'client/main.lua',
}

server_scripts {
  'server/main.lua',
}

dependencies {
  'sunnyrp-base'
}