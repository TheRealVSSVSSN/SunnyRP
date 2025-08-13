fx_version 'cerulean'
game 'gta5'

name 'sunnyrp-base'
author 'SunnyRP'
description 'Sunny Roleplay Base Framework (server-authoritative)'
version '0.4.0'
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
  'shared/state.lua',
}

client_scripts {
  'client/main.lua',
  'client/presence.lua',
}

server_scripts {
  'server/locks.lua',
  'server/buckets.lua',
  'server/instance.lua',
  'server/permissions.lua',
  'server/player.lua',
  'server/state.lua',
  'server/charstate.lua',
  'server/presence.lua',
  'server/hudbridge.lua',
  'server/guard.lua',
  'server/commands.lua',
  'server/deferrals.lua',
  'server/main.lua',
}

server_exports {
  'getModule',            -- player.lua (NP-style)
  'HasScope',             -- permissions.lua
  'RefreshPerms',         -- permissions.lua

  'SetBucket',            -- buckets.lua
  'ToLoading',
  'ToMain',
  'ToCharacter',
  'ToAdmin',

  'InstanceCreate',       -- instance.lua
  'InstanceAddPlayer',
  'InstanceRemovePlayer',
  'InstanceDestroy',

  'RegisterCommandEx',    -- commands.lua
  'GuardNetEvent',        -- guard.lua

  'EmitHud',              -- hudbridge.lua

  'TryLock',              -- locks.lua
  'Unlock',
  'WithLock',

  'SetState',             -- state.lua
  'GetState',
  'SetStateMany',
  'StateKey',

  'SetCharacterState',    -- charstate.lua
}

dependencies {
  -- add voice/chat deps later if needed
}