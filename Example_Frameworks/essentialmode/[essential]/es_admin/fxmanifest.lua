fx_version 'cerulean'
game 'gta5'

description 'es_admin addon for essentialmode'

dependency 'essentialmode'

client_scripts {
    'cl_admin.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_admin.lua'
}
