fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Infinity Helper'
version '1.0.0'

client_scripts {
    'client/classes/*.lua',
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_*.lua'
}

client_script 'tests/cl_*.lua'
server_script 'tests/sv_*.lua'

