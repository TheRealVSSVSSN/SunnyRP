fx_version 'cerulean'
game 'gta5'

--[[
    -- Type: Manifest
    -- Name: fsn_cargarage/fxmanifest.lua
    -- Use: Resource definition for garage system
    -- Created: 2024-11-27
    -- By: VSSVSSN
--]]

description 'Garages for the server'
lua54 'yes'

shared_script '@fsn_main/server_settings/sh_settings.lua'

client_scripts {
    '@fsn_main/cl_utils.lua',
    'client.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@ghmattimysql/ghmattimysql-server.lua',
    'server.lua'
}

ui_page 'gui/ui.html'

files {
  'gui/ui.css',
  'gui/ui.html',
  'gui/ui.js'
}

exports {
  'fsn_IsVehicleOwner',
  'fsn_GetVehicleVehIDP',
  'fsn_SpawnVehicle',
  'fsn_IsVehicleOwnerP',
  'getCarDetails'
}
