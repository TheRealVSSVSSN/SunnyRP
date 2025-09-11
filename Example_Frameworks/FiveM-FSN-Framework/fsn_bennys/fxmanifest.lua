fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Benny Tuning for the server'

shared_script '@fsn_main/server_settings/sh_settings.lua'

client_scripts {
    '@fsn_main/cl_utils.lua',
    'menu.lua',
    'cl_config.lua',
    'cl_bennys.lua'
}
