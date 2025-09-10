fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    '@np-infinity/client/cl_lib.lua',
    'carhud.lua',
    'cl_autoKick.lua',
    'newsStands.lua'
}

server_scripts {
    '@np-infinity/server/sv_lib.lua',
    'carhud_server.lua',
    'sr_autoKick.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/styles.css',
    'html/img/*.svg',
    'html/img/*.png'
}

exports {
    'playerLocation',
    'playerZone'
}
