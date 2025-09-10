fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- client scripts
client_scripts {
    'server_settings/sh_settings.lua',
    'debug/sh_debug.lua',
    'cl_utils.lua',
    'initial/client.lua',
    'money/client.lua',
    'hud/client.lua',
    'playermanager/client.lua',
    'misc/servername.lua',
    'misc/shitlordjumping.lua',
    'misc/timer.lua'
}

-- gui assets
ui_page 'gui/index.html'
files {
    'gui/index.html',
    'gui/index.js',
    'gui/motd.txt',
    'gui/pdown.ttf',
    'gui/logo_new.png',
    'gui/logo_old.png',
    'gui/logos/logo.png'
}

-- server scripts
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'misc/db.lua',
    'server_settings/sh_settings.lua',
    'initial/server.lua',
    'money/server.lua',
    'playermanager/server.lua',
    'misc/logging.lua',
    'misc/version.lua',
    'banmanager/sv_bans.lua',
    'sv_utils.lua'
}

-- exports
exports {
    'fsn_GetWallet',
    'fsn_GetBank',
    'fsn_CanAfford',
    'fsn_CharID',
    'fsn_FindNearbyPed',
    'fsn_FindPedNearbyCoords',
    'fsn_GetTime'
}

server_export 'fsn_GetPlayerFromCharacterId'
server_export 'fsn_GetCharacterInfo'
server_export 'fsn_GetPlayerFromPhoneNumber'
server_export 'fsn_GetPlayerPhoneNumber'
server_export 'fsn_CharID'
server_export 'fsn_GetWallet'
server_export 'fsn_GetBank'
