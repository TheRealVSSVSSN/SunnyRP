fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-vehicles'
author 'Sunny Roleplay'
description 'SRP Vehicles — ownership, keys, garages, world persistence, impound, anti-dupe streaming'
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