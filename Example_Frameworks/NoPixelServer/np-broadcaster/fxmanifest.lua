fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Refactored broadcaster resource'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'cl_broadcast.lua'
}

server_script 'sv_broadcast.lua'

