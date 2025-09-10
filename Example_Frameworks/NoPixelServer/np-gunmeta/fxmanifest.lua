--[[
    -- Type: Resource Manifest
    -- Name: np-gunmeta
    -- Use: Defines weapon metadata for custom weapons
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'gta5'

description 'Gun metadata definitions'

files {
    'weapon_snspistol.meta',
    'weapon_pumpshotgun_mk2.meta',
    'weapon_revolver_mk2.meta',
    'weapons.meta'
}

data_file 'WEAPONINFO_FILE' 'weapon_snspistol.meta'
data_file 'WEAPONINFO_FILE' 'weapon_pumpshotgun_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapon_revolver_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons.meta'

