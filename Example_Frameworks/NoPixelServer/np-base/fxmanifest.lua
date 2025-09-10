fx_version 'cerulean'
game 'gta5'

lua54 'yes'

dependencies {
    'ghmattimysql'
}

shared_scripts {
    'sh_init.lua',
    'core/sh_core.lua',
    'core/sh_enums.lua',
    'utility/sh_util.lua'
}

client_scripts {
    'events/cl_events.lua',
    'utility/cl_util.lua',
    'core/cl_core.lua',
    'spawnmanager/cl_spawnmanager.lua',
    'player/cl_player.lua',
    'player/cl_controls.lua',
    'player/cl_settings.lua',
    'blipmanager/cl_blipmanager.lua',
    'blipmanager/cl_blips.lua',
    'gameplay/cl_gameplay.lua',
    'commands/cl_commands.lua'
}

server_scripts {
    'events/sv_events.lua',
    'database/sv_db.lua',
    'core/sv_core.lua',
    'core/sv_characters.lua',
    'spawnmanager/sv_spawnmanager.lua',
    'player/sv_player.lua',
    'player/sv_controls.lua',
    'player/sv_settings.lua',
    'commands/sv_commands.lua'
}

exports {
    'getModule',
    'addModule'
}

server_exports {
    'getModule',
    'addModule'
}

