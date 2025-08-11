fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-crime'
author 'Sunny Roleplay'
description 'SRP Crime Systems — heat/cooldowns, loot, dirty money, lockpick abstraction'
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