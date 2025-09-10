fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/sounds/panic.mp3',
    'html/sounds/metaldetected.mp3'
}

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    '@np-infinity/client/cl_lib.lua',
    'client.lua'
}

server_scripts {
    '@np-infinity/server/sv_lib.lua',
    'server.lua'
}
