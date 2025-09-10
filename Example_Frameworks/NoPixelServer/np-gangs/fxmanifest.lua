fx_version 'cerulean'
game 'gta5'

--[[
    -- Type: Manifest
    -- Name: fxmanifest
    -- Use: Defines resource metadata and scripts
    -- Created: 2024-08-18
    -- By: VSSVSSN
--]]

client_scripts {
    '@np-errorlog/client/cl_errorlog.lua',
    'chostility.lua',
    'taskconfig.lua',
    'client_gangtasks.lua'
}

server_scripts {
    'server_gangtasks.lua',
    'sweed.lua'
}

-- gang 1 weed, gang 2 meth, gang 3 launder, gang 4 run runs
