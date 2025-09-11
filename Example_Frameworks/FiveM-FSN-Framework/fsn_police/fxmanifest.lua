fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
  '@fsn_main/server_settings/sh_settings.lua'
}

client_scripts {
  '@fsn_main/cl_utils.lua',
  'client.lua',
  'dispatch.lua',
  'radar/client.lua',
  'dispatch/client.lua',
  'pedmanagement/client.lua',
  'evidencelocker/client.lua',
  'armory/cl_armory.lua',
  'MDT/mdt_client.lua',
  'tackle/client.lua',
  'K9/client.lua'
}

server_scripts {
  '@fsn_main/sv_utils.lua',
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
  'armory/sv_armory.lua',
  'MDT/mdt_server.lua',
  'tackle/server.lua',
  'K9/server.lua',
  'evidencelocker/server.lua'
}

ui_page 'MDT/gui/index.html'

files {
  'MDT/gui/index.html',
  'MDT/gui/index.css',
  'MDT/gui/index.js',
  'MDT/gui/images/base_pc.png',
  'MDT/gui/images/win_icon.png',
  'MDT/gui/images/background.png',
  'MDT/gui/images/icons/booking.png',
  'MDT/gui/images/icons/cpic.png',
  'MDT/gui/images/icons/dmv.png',
  'MDT/gui/images/icons/warrants.png',
  'MDT/gui/images/pwr_icon.png'
}

exports {
  'fsn_getIllegalItems',
  'fsn_PDDuty',
  'fsn_getPDLevel',
  'fsn_getCopAmt'
}
