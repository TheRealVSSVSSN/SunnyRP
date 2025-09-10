-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

fx_version 'cerulean'
game 'gta5'

author 'Cfx.re <root@cfx.re>'
description 'Persistent player identifier storage.'
version '1.1.0'
repository 'https://github.com/citizenfx/cfx-server-data'

lua54 'yes'

server_script 'server.lua'

provides {
    'cfx.re/playerData.v1alpha1'
}
