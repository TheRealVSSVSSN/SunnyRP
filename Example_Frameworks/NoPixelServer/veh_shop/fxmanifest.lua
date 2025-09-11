fx_version 'cerulean'
game 'gta5'

description 'Vehicle shop resource'

lua54 'yes'

dependencies {
  'PolyZone',
  'np-base'
}

server_script 'vehshop_s.lua'

client_scripts {
  '@PolyZone/client.lua',
  '@np-errorlog/client/cl_errorlog.lua',
  'vehshop.lua'
}
