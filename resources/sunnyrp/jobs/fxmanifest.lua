fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-jobs'
author 'Sunny Roleplay'
description 'SRP Jobs — definitions, grades, duty, access + salary source'
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