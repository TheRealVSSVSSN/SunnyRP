-- luacheck: globals fx_version game author description version shared_scripts client_scripts
fx_version 'cerulean'
game 'gta5'

author 'iTzCrutchie'
description 'Activities for the server'
version '0.1.0'

shared_scripts {
    '@fsn_main/server_settings/sh_settings.lua'
}

client_scripts {
    '@fsn_main/cl_utils.lua',
    'yoga/client.lua',
    'fishing/client.lua',
    'hunting/client.lua'
}
