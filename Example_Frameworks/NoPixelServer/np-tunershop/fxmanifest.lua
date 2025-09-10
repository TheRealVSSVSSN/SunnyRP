--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata and client scripts
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0.0'

this_is_a_map 'yes'

client_scripts {
    'lib/common.lua',
    'dlc_import/vehicle_warehouse_2.lua',
    'client.lua'
}

