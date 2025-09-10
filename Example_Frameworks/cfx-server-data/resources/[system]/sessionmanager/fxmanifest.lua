--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata and scripts for session manager
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
games { 'gta4', 'gta5' }
lua54 'yes'

version '1.1.0'
author 'Cfx.re <root@cfx.re>'
description 'Handles the "host lock" for non-OneSync servers. Do not disable.'
repository 'https://github.com/citizenfx/cfx-server-data'

server_script 'server/host_lock.lua'
client_script 'client/empty.lua'
