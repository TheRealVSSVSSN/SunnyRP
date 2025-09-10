-- luacheck: globals fx_version game lua54 client_scripts

fx_version 'cerulean'

-- Resource: np-gym
-- Modernized manifest using FXServer's fxmanifest format.

game 'gta5'
lua54 'yes'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'client.lua'
}

