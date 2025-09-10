fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'np-jobmanager'
description 'Job management system'
author 'VSSVSSN'
version '1.0.1'

dependency 'np-base'

shared_scripts {
    'shared/sh_jobmanager.lua'
}

server_scripts {
    'server/sv_jobmanager.lua'
}

client_scripts {
    'client/cl_jobmanager.lua'
}
