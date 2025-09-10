fx_version 'cerulean'
game 'gta5'

-- Resource metadata
name 'np-scoreboard'
description 'Refactored scoreboard with modern fxmanifest'
author 'VSSVSSN'

-- Dependencies
dependency 'np-base'

-- Client scripts
client_scripts {
    '@warmenu/warmenu.lua',
    '@np-errorlog/client/cl_errorlog.lua',
    'cl_scoreboard.lua'
}

-- Server scripts
server_scripts {
    'sv_scoreboard.lua'
}

