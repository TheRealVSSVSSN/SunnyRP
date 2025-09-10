fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script '@np-errorlog/client/cl_errorlog.lua'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/cursor.png',
    'html/background.png',
    'html/styles.css',
    'html/scripts.js'
}

client_script 'client.lua'
server_script 'server.lua'
