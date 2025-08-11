fx_version 'cerulean'
game 'gta5'

name 'sunnyrp-base'
author 'SunnyRP'
description 'Sunny Roleplay Base Framework (server-authoritative)'
version '0.2.0'

lua54 'yes'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/app.js',
  'html/style.css',
}

shared_scripts {
  'config.lua',
  'shared/utils.lua',
}

client_scripts {
  'client/main.lua',
}

server_scripts {
  'server/buckets.lua',
  'server/permissions.lua',
  'server/player.lua',
  'server/guard.lua',
  'server/commands.lua',
  'server/deferrals.lua',
  'server/main.lua',
}

server_exports {
  'getModule',          -- from player.lua (NP-style)
  'HasScope',           -- from permissions.lua
  'RefreshPerms',       -- from permissions.lua
  'SetBucket',          -- from buckets.lua
  'ToLoading',          -- from buckets.lua
  'ToMain',             -- from buckets.lua
  'ToCharacter',        -- from buckets.lua
  'ToAdmin',            -- from buckets.lua
  'RegisterCommandEx',  -- from commands.lua
  'GuardNetEvent',      -- from guard.lua
}

dependencies {
  -- add voice/chat deps later if needed
}