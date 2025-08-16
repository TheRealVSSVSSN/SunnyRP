fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunnyrp-identity'
author 'Sunny Roleplay'
description 'SRP Identity & Permissions (Phase B)'
version '1.0.0'

server_scripts {
  '@sunnyrp-base/shared/utils.lua',   -- ensure base loads first; helpers if needed
  'server/main.lua'
}