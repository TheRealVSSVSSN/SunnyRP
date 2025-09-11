--[[/   :FSN:   \]]--
fx_version 'cerulean'
lua54 'yes'
game 'gta5'

client_scripts {
    '@fsn_main/cl_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    'cl_manage.lua',
    'cl_properties.lua'
}

server_scripts {
    '@fsn_main/sv_utils.lua',
    '@fsn_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua',
    'sv_conversion.lua',
    'sv_properties.lua'
}

ui_page 'nui/ui.html'
files {
    'nui/ui.html',
    'nui/ui.js',
    'nui/ui.css'
}
--[[/   :FSN:   \]]--

