--  -----------------------------
--  BEGIN:         FiveM Manifest
--  -----------------------------

fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

author      'Crutchie'
description 'FSN Developer'
version     '0.0.1'

--  -----------------------------
--  END:           FiveM Manifest
--  -----------------------------

--  -----------------------------
--  BEGIN: Client Scripts/Exports
--  -----------------------------

client_scripts {

    'client/client.lua',
    'client/cl_noclip.lua',

}

--  -----------------------------
--  END:   Client Scripts/Exports
--  -----------------------------

--  -----------------------------
--  BEGIN: Server Scripts/Exports
--  -----------------------------

server_scripts {

    '@oxmysql/lib/MySQL.lua',

    'config.lua',
    'server/server.lua',

}

--  -----------------------------
--  END:   Server Scripts/Exports
--  -----------------------------