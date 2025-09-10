fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'lockpicking_client.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/cursor.png',
    'html/background2.png',
    'html/scripts.js',
    'html/styles.css',
    'html/sounds/pinbreak.ogg',
    'html/sounds/lockUnlocked.ogg',
    'html/sounds/lockpick.ogg'
}

exports {
    'lockpick'
}

