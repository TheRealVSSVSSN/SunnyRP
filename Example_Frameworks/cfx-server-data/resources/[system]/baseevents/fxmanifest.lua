-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.1.0'
author 'Cfx.re <root@cfx.re>'
description 'Adds basic events for developers to use in their scripts. Some third party resources may depend on this resource.'
repository 'https://github.com/citizenfx/cfx-server-data'

client_scripts {
    'client/utils.lua',
    'client/vehiclechecker.lua',
    'client/deathevents.lua'
}

server_script 'server/main.lua'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

