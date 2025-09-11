--[[/   :FSN:   \]]--
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
  '@fsn_main/cl_utils.lua',
  '@fsn_main/server_settings/sh_settings.lua',
  'cl_doors.lua'
}

server_scripts {
  '@fsn_main/sv_utils.lua',
  '@fsn_main/server_settings/sh_settings.lua',
  '@mysql-async/lib/MySQL.lua',
  'sv_doors.lua'
}

exports {
  'IsDoorLocked'
}

--[[/   :FSN:   \]]--
