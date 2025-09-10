fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Simple Notification Script using https://notifyjs.com/'

ui_page 'html/index.html'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'cl_notify.lua'
}

files {
    'html/index.html',
    'html/pNotify.js',
    'html/noty.js',
    'html/noty.css',
    'html/themes.css'
}

exports {
    'SetQueueMax',
    'SendNotification'
}
