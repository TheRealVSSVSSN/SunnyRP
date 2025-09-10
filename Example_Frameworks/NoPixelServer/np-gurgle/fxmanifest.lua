fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/cursor.png',
    'html/background.png',
    'html/styles.css',
    'html/scripts.js',
    'html/debounce.min.js'
}

client_script '@np-errorlog/client/cl_errorlog.lua'
client_script 'client.lua'
server_script 'server.lua'
