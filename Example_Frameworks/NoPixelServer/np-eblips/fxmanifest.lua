fx_version 'cerulean'
game 'gta5'

description 'Emergency blips handlers'

client_scripts {
    '@np-infinity/client/classes/blip.lua',
    '@np-infinity/client/cl_lib.lua',
    'cl_eblips.lua'
}

server_scripts {
    '@np-infinity/server/sv_lib.lua',
    'sv_eblips.lua'
}

lua54 'yes'
