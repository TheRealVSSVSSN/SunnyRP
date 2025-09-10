fx_version 'cerulean'
game 'gta5'

description 'NoPixel Drift School'

dependencies {
    'PolyZone',
    'np-base'
}

ui_page 'client/html/index.html'

files {
    'client/html/index.html',
    'client/html/script.js'
}

client_scripts {
    '@PolyZone/client.lua',
    'client.lua'
}

server_scripts {
    'server.lua'
}

