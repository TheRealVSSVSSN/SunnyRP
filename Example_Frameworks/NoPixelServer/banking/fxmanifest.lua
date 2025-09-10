fx_version 'cerulean'
game 'gta5'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/bank-icon.png',
    'html/logo.png',
    'html/cursor.png',
    'html/styles.css',
    'html/scripts.js',
    'html/debounce.min.js'
}

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    '@np-infinity/client/cl_lib.lua',
    'client.lua'
}

server_scripts {
    '@np-fml/server/lib.lua',
    '@np-infinity/server/sv_lib.lua',
    'server.lua'
}
