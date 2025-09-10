fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Resource metadata
name 'np-stash'
description 'Simple stash house system'

-- UI assets
ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/cursor.png',
    'html/styles.css',
    'html/scripts.js',
    'html/sounds/lockUnlocked.ogg'
}

client_scripts {
    'stashhouse_client.lua'
}

server_scripts {
    'server/stashhouse_server.lua',
    'server/svstashes.lua'
}

dependency 'ghmattimysql'

