fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/styles.css',
    'html/scripts.js'
}

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'client.lua'
}

server_scripts {
    'server.lua'
}

