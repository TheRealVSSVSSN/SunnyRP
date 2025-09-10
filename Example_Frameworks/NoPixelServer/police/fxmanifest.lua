--[[
    -- Resource Manifest
    -- Converted from legacy __resource.lua to fxmanifest for modern FiveM support
    -- Created: 2024-08-21
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
lua54 'yes'
game 'gta5'

-- External error logging
client_script '@np-errorlog/client/cl_errorlog.lua'

-- Client-side scripts
client_scripts {
    'client.lua',
    'client_trunk.lua',
    'evidence.lua'
}

-- Server-side scripts
server_scripts {
    'server.lua'
}

-- Exported functions for other resources
exports {
    'getIsInService',
    'getIsCop',
    'getIsCuffed'
}

