fx_version 'cerulean'
game 'gta5'
lua54 'yes'

dependency 'np-base'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/styles.css',
    'html/cursor.png',
    'html/header.png'
}

server_scripts {
    'server/sv_login.lua'
}

client_scripts {
    -- '@np-errorlog/client/cl_errorlog.lua',
    'client/cl_login.lua',
    'client/cl_cswitch.lua'
}
