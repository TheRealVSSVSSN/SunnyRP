fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Keypad interface for traphouse locks'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'keypad_client.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/cursor.png',
    'html/styles.css',
    'html/scripts.js',
    'html/debounce.min.js'
}

