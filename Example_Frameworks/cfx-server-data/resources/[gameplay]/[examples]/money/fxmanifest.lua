-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.1.0'
description 'Example money system using KVPs.'
repository 'https://github.com/citizenfx/cfx-server-data'
author 'Cfx.re <root@cfx.re>'

fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'
server_script 'server.lua'

dependency 'cfx.re/playerData.v1alpha1'
lua54 'yes'
