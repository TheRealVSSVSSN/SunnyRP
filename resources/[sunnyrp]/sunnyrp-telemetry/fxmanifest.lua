fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-telemetry'
author 'Sunny Roleplay'
description 'SRP Telemetry & Anticheat: sampling, detectors, staff alerts'
version '1.0.0'

client_scripts {
  '@sunnyrp-base/shared/utils.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
  '@sunnyrp-base/shared/utils.lua',
  '@sunnyrp-base/config.lua',
  'config.lua',
  'server/main.lua'
}