fx_version 'cerulean'
game 'gta5'
lua54 'yes'

dependencies {
    'PolyZone',
    'np-base'
}

client_scripts {
    '@PolyZone/client.lua',
    '@np-errorlog/client/cl_errorlog.lua',
    'vehshop.lua'
}

server_scripts {
    'vehshop_s.lua'
}
