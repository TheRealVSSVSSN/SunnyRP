fx_version 'cerulean'
game 'gta5'
lua54 'yes'

dependency 'np-base'
dependency 'ghmattimysql'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/styles.css'
}

shared_scripts {
    'shared/sh_admin.lua',
    'shared/sh_commands.lua',
    'shared/sh_ranks.lua'
}

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    '@warmenu/warmenu.lua',
    '@np-infinity/client/cl_lib.lua',
    'client/cl_menu.lua',
    'client/cl_noclip.lua',
    'client/cl_admin.lua'
}

server_scripts {
    '@np-infinity/server/sv_lib.lua',
    'server.lua',
    'server/sv_db.lua'
}
