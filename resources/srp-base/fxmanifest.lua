-- SRP Base Resource
fx_version 'cerulean'
lua54 'yes'

description 'SRP Base Failover'

shared_scripts {
  'shared/srp.lua'
}

server_scripts {
  'server/http.lua',
  'server/failover.lua',
  'server/sql.lua',
  'server/rpc.lua',
  'server/http_handler.lua',
  'server/modules/base.lua',
  'server/modules/sessions.lua',
  'server/modules/voice.lua',
  'server/modules/ux.lua',
  'server/modules/world.lua',
  'server/modules/jobs.lua'
}
