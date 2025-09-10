fx_version 'cerulean'
game 'gta5'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/background.png',
    'html/styles.css',
    'html/scripts.js'
}

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'main.lua'
}

server_script 'server.lua'

