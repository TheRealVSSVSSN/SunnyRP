fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'EssentialMode by Kanersps.'

ui_page 'ui.html'

files {
    'ui.html',
    'pdown.ttf'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/config.lua',
    'server/util.lua',
    'server/classes/player.lua',
    'server/classes/groups.lua',
    'server/player/login.lua',
    'server/main.lua'
}

server_exports {
    'stringsplit',
    'startswith',
    'returnIndexesInTable',
    'debugMsg'
}

client_scripts {
    'client/main.lua'
}

