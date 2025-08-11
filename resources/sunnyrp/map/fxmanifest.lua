fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-map'
author 'Sunny Roleplay'
description 'SRP Map Manager — zones, blips, buckets, telemetry'
version '1.0.0'

client_scripts {
  '@sunnyrp-base/shared/utils.lua',
  'client/main.lua'
}

server_scripts {
  '@sunnyrp-base/shared/utils.lua',
  '@sunnyrp-base/config.lua',
  'server/main.lua'
}