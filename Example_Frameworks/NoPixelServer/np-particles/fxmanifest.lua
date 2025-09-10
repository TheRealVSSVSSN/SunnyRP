fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'particle_client.lua'
}

server_scripts {
    'particle_server.lua'
}

exports {
    'particleStart',
    'particleStop'
}
