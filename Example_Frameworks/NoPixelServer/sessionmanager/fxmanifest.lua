--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata and scripts
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'

author 'Cfx.re <root@cfx.re>'
description 'Handles the "host lock" for non-OneSync servers. Do not disable.'
repository 'https://github.com/citizenfx/cfx-server-data'
version '1.0.0'

lua54 'yes'

server_scripts {
    'server/host_lock.lua'
}

client_scripts {
    'client/empty.lua'
}

