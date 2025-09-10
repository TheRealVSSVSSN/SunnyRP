fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Builders for the framework'

--[[/   :FSN:   \]]--
client_scripts {
    '@fsn_main/cl_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua',
    'xml.lua',
    'schema.lua',
    'handling_builder.lua'
}

--[[/   :FSN:   \]]--

