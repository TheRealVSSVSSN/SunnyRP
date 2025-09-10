fx_version 'cerulean'
game 'gta5'

description 'EssentialMode by Kanersps.'

ui_page 'ui.html'

files {
    'ui.html',
    'pdown.ttf'
}

server_scripts {
    'server/classes/player.lua',
    'server/classes/groups.lua',
    'server/player/login.lua',
    'server/main.lua',
    'server/util.lua'
}

client_scripts {
    'client/main.lua'
}
