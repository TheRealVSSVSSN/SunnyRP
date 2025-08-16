fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-voice'
author 'Sunny Roleplay'
description 'SRP.Voice abstraction: native Mumble default, pma adapter optional'
version '1.0.0'

client_scripts {
  '@sunnyrp-base/shared/utils.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
  '@sunnyrp-base/shared/utils.lua',
  'config.lua',
  'server/main.lua'
}