fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Simple Notification Script using Noty.js'

ui_page 'html/index.html'

client_scripts {
    'cl_notify.lua'
}

server_scripts {
    'server.lua'
}

exports {
    'SetQueueMax',
    'SendNotification'
}

files {
    'html/index.html',
    'html/noty.js',
    'html/noty.css',
    'html/themes.css',
    'html/pNotify.js'
}
