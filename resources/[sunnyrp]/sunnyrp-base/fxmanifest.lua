fx_version 'cerulean'
game 'gta5'

name 'sunnyrp-base'
author 'SunnyRP'
description 'Sunny Roleplay Base Framework (server-authoritative)'
version '0.3.0'
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
  'server/locks.lua',
  'server/buckets.lua',
  'server/instance.lua',
  'server/permissions.lua',
  'server/player.lua',
  'server/hudbridge.lua',
  'server/guard.lua',
  'server/commands.lua',
  'server/deferrals.lua',
  'server/main.lua',
}

server_exports {
  'getModule',          -- player.lua
  'HasScope',           -- permissions.lua
  'RefreshPerms',       -- permissions.lua
  'SetBucket',          -- buckets.lua
  'ToLoading',          -- buckets.lua
  'ToMain',             -- buckets.lua
  'ToCharacter',        -- buckets.lua
  'ToAdmin',            -- buckets.lua
  'InstanceCreate',     -- instance.lua
  'InstanceAddPlayer',  -- instance.lua
  'InstanceRemovePlayer', -- instance.lua
  'InstanceDestroy',    -- instance.lua
  'RegisterCommandEx',  -- commands.lua
  'GuardNetEvent',      -- guard.lua
  'EmitHud',            -- hudbridge.lua
  'TryLock',            -- locks.lua
  'Unlock',             -- locks.lua
  'WithLock',           -- locks.lua
}

dependencies {
  -- add voice/chat deps later if needed
}