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

-- Shared first (constants/utils/state), then config
shared_scripts {
  'shared/core/constants.lua',
  'shared/core/utils.lua',
  'shared/core/state.lua',
  'shared/world/zones.lua',
  'config.lua',
}

client_scripts {
  -- core (boot/helpers)
  'client/core/errorlog.lua',
  'client/core/keybinds.lua',
  'client/core/main.lua',

  -- networking & UI helpers
  'client/net/rpc.lua',
  'client/ui/taskbar.lua',

  -- state + world (presence/ipls/time/weather/world)
  'client/state/presence.lua',
  'client/world/ipls.lua',
  'client/world/time_weather.lua',
  'client/world/world.lua',
}

server_scripts {
  -- core (boot/deferrals/player attach/logging/keybinds)
  'server/core/errorlog.lua',
  'server/core/keybinds.lua',
  'server/core/deferrals.lua',
  'server/core/player.lua',
  'server/core/main.lua',

  -- security (guard & permissions)
  'server/security/guard.lua',
  'server/security/permissions.lua',
  'server/security/telemetry.lua',

  -- state (buckets/instances/state/charstate/presence/world)
  'server/state/buckets.lua',
  'server/state/instance.lua',
  'server/state/state.lua',
  'server/state/charstate.lua',
  'server/state/presence.lua',
  'server/state/world.lua',

  -- integration bridges (http/outbox/inbox/hud/config/rpc)
  'server/integration/http.lua',
  'server/integration/outbox.lua',
  'server/integration/inbox.lua',
  'server/integration/hudbridge.lua',
  'server/integration/config_bus.lua',
  'server/integration/config_live.lua',
  'server/integration/rpc.lua',

  -- features (commands/locks/devtools) — loaded last
  'server/features/commands.lua',
  'server/features/locks.lua',
  'server/features/devtools.lua',
}

server_exports {
  -- player module (if provided by server/core/player.lua)
  'getModule',

  -- security/permissions
  'HasScope',
  'RefreshPerms',

  -- buckets/instances
  'SetBucket',
  'ToLoading',
  'ToMain',
  'ToCharacter',
  'ToAdmin',

  'InstanceCreate',
  'InstanceAddPlayer',
  'InstanceRemovePlayer',
  'InstanceDestroy',

  -- command/guard helpers
  'RegisterCommandEx',
  'GuardNetEvent',

  -- HUD patch coalescer
  'EmitHud',

  -- locks & concurrency
  'TryLock',
  'Unlock',
  'WithLock',

  -- state helpers
  'SetState',
  'GetState',
  'SetStateMany',
  'StateKey',

  -- character state
  'SetCharacterState',
}

dependencies {
  -- add voice/chat deps later if needed
}