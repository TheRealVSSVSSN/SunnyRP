--[[
    -- Type: Manifest
    -- Name: fxmanifest.lua
    -- Use: Defines resource metadata for the RedM example map
    -- Updated: 2025-02-14
    -- By: VSSVSSN
--]]

fx_version 'cerulean'
game 'rdr3'

lua54 'yes'
this_is_a_map 'yes'

author 'Cfx.re <root@cfx.re>'
description 'Example spawn points for RedM.'
repository 'https://github.com/citizenfx/cfx-server-data'

version '1.0.1'

resource_type 'map' { gameTypes = { ['basic-gamemode'] = true } }

map 'map.lua'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
