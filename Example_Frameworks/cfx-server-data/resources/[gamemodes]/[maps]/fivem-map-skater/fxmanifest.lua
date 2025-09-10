--[[
    -- Type: Manifest
    -- Name: fivem-map-skater
    -- Use: Defines metadata for the skater spawn map
    -- Updated: 2024-05-31
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
lua54 'yes'
game 'gta5'

version '1.1.0'
author 'Cfx.re <root@cfx.re>'
description 'Example spawn points for FiveM with a "skater" model.'
repository 'https://github.com/citizenfx/cfx-server-data'

this_is_a_map 'yes'
resource_type 'map' { gameTypes = { ['basic-gamemode'] = true } }

map 'map.lua'
