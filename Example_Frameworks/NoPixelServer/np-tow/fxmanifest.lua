--[[
    -- Type: Manifest
    -- Name: fxmanifest
    -- Use: Defines resource metadata and scripts
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

files {
    'carvariations.meta',
    'carcols.meta'
}

data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'

client_scripts {
    'towlivery_names.lua'
}
