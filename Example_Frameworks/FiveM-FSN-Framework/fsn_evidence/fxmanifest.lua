--[[/   :FSN:   \]]--
fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    '@fsn_main/server_settings/sh_settings.lua'
}

client_scripts {
    '@fsn_main/cl_utils.lua',
    '__descriptions-male.lua',
    '__descriptions-female.lua',
    '__descriptions.lua',
    'cl_evidence.lua',
    'casings/cl_casings.lua',
    -- 'bleeding/cl_bleeding.lua',
    'ped/cl_ped.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@mysql-async/lib/MySQL.lua',
    'sv_evidence.lua',
    'ped/sv_ped.lua'
}

exports({
        'getSex',
        'getJacket',
        'getTop',
        'getPants'
})
--[[/   :FSN:   \]]--

