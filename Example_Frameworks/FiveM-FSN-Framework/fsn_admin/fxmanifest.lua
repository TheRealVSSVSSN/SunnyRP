--  -----------------------------
--  BEGIN:         FiveM Manifest
--  -----------------------------

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Crutchie'
description 'FSN Admin'
version '0.1.0'

--  -----------------------------
--  END:           FiveM Manifest
--  -----------------------------

--  -----------------------------
--  BEGIN: Client Scripts/Exports
--  -----------------------------

client_scripts {
    'client/client.lua'
}

--  -----------------------------
--  END:   Client Scripts/Exports
--  -----------------------------

--  -----------------------------
--  BEGIN: Server Scripts/Exports
--  -----------------------------

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/server.lua'
}

--  -----------------------------
--  END:   Server Scripts/Exports
--  -----------------------------