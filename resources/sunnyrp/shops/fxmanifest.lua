fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-shops'
author 'Sunny Roleplay'
description 'SRP Businesses & Shops foundation — catalogs, purchases, registers'
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