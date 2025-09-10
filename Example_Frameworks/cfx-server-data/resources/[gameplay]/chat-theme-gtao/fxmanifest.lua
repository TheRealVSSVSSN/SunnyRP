fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.1.0'
author 'Cfx.re <root@cfx.re>'
description 'A GTA Online-styled theme for the chat resource.'
repository 'https://github.com/citizenfx/cfx-server-data'

files {
    'style.css',
    'shadow.js'
}

chat_theme 'gtao' {
    styleSheet = 'style.css',
    script = 'shadow.js',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}
