fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'srp_base'
description 'SunnyRP Base — server-authoritative spine, live-config, buckets, RP defaults + zones/keybinds/taskbar/errorlog'
author 'SunnyRP'
version '2.3.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/app.js',
  'html/style.css'
}

shared_scripts {
  'shared/utils.lua',
  'shared/constants.lua',
  'shared/zones.lua',
  'config.lua'
}

client_scripts {
  'client/rpc.lua',
  'client/keybinds.lua',
  'client/taskbar.lua',
  'client/errorlog.lua',
  'client/world.lua',
  'client/main.lua',
  'client/time_weather.lua',
  'client/ipls.lua'
}

server_scripts {
  'server/http.lua',
  'server/rpc.lua',
  'server/player.lua',
  'server/keybinds.lua',
  'server/world.lua',
  'server/errorlog.lua',
  'server/permissions.lua',
  'server/state.lua',
  'server/buckets.lua',
  'server/config_bus.lua',
  'server/commands.lua',
  'server/config_live.lua',
  'server/inbox.lua',
  'server/outbox.lua',
  'server/telemetry.lua',
  'server/devtools.lua',
  'server/deferrals.lua',
  'server/main.lua'
}

dependencies {
  -- add voice/chat deps later if needed
}