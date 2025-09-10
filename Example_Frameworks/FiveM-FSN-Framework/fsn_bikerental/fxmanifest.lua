fx_version 'cerulean'
game 'gta5'

description 'Bikerental for the server'

shared_scripts {
    '@fsn_main/server_settings/sh_settings.lua'
}

client_scripts {
    '@fsn_main/cl_utils.lua',
    'client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/cursor.png'
}
