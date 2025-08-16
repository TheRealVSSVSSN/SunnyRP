fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-properties'
author 'Sunny Roleplay'
description 'SRP Properties & Housing — buy/sell/rent, keys, locks, instance routing, stash linkage'
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