--[[
    -- Type: Manifest
    -- Name: np-gunmetaDLC
    -- Use: Loads custom weapon metadata for improved gun mechanics
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]

fx_version 'cerulean'

--[[
    -- FiveM Game Compatibility
    -- Allowed Values: 'gta5', 'rdr3'
    -- Default: 'gta5'
--]]
game 'gta5'

description 'Enhanced weapon configuration for FiveM'
version '1.0.0'

files {
    'gunmetaDLC.meta'
}

data_file 'WEAPONINFO_FILE' 'gunmetaDLC.meta'
