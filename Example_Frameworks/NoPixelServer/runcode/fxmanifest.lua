fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0.0'
author 'Cfx.re <root@cfx.re>'
description 'Allows server owners to execute arbitrary server-side or client-side JavaScript/Lua code. *Consider only using this on development servers.*'
repository 'https://github.com/citizenfx/cfx-server-data'

client_scripts {
    'runcode_cl.lua',
    'runcode_ui.lua'
}

server_scripts {
    'runcode_sv.lua',
    'runcode_web.lua'
}

shared_scripts {
    'runcode_shared.lua',
    'runcode.js'
}

ui_page 'web/nui.html'

files {
    'web/nui.html'
}
