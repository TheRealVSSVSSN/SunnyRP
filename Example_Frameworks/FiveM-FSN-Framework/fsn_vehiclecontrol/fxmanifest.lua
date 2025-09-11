fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@fsn_main/server_settings/sh_settings.lua'
}

client_scripts {
    '@fsn_main/cl_utils.lua',
    'client.lua',
    'odometer/client.lua',
    'fuel/client.lua',
    'speedcameras/client.lua',
    'compass/essentials.lua',
    'compass/compass.lua',
    'compass/streetname.lua',
    'carhud/carhud.lua',
    'damage/config.lua',
    'damage/client.lua',
    'damage/cl_crashes.lua',
    'engine/client.lua',
    'inventory/client.lua',
    'carwash/client.lua',
    'trunk/client.lua',
    'holdup/client.lua',
    'aircontrol/aircontrol.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@mysql-async/lib/MySQL.lua',
    'odometer/server.lua',
    'fuel/server.lua',
    'keys/server.lua',
    'inventory/server.lua',
    'trunk/server.lua'
}

exports {
    'GetVehicleInventory'
}

