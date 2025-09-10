fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    '@np-infinity/client/cl_lib.lua',
    'client/main.lua'
}

server_scripts {
    '@np-infinity/server/sv_lib.lua',
    'server/main.lua'
}

ui_page 'client/html/index.html'

files {
    'client/html/index.html',
    'client/html/sounds/*.ogg'
}
