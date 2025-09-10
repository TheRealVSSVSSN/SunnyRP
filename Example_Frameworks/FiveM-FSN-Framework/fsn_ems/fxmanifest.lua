fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    '@fsn_main/server_settings/sh_settings.lua'
}

client_scripts {
    '@fsn_main/cl_utils.lua',
    'client.lua',
    'cl_advanceddamage.lua',
    'cl_volunteering.lua',
    'cl_carrydead.lua',
    'beds/client.lua',
    'blip.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
    'sv_carrydead.lua',
    'beds/server.lua'
}

client_exports {
    'fsn_IsDead',
    'fsn_EMSDuty',
    'fsn_getEMSLevel',
    'fsn_Airlift',
    'ems_isBleeding',
    'isCrouching',
    'carryingWho'
}

--[[/   :FSN:   \]]--

