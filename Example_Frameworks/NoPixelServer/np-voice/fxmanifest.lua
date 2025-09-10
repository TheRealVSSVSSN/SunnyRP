fx_version 'cerulean'
game 'gta5'
lua54 'yes'

server_scripts {
    'config.lua',
    'server/modules/*.lua',
    'server/*.lua'
}

client_scripts {
    'config.lua',
    'client/tools/*.lua',
    'client/classes/*.lua',
    'client/modules/*.lua',
    'client/client.lua'
}

-- ui_page "nui/ui.html"

-- files {
--     "nui/sounds/*.*",
--     "nui/sounds/clicks/*.*",
--     "nui/ui.html",
--     "nui/css/style.css",
--     "nui/lib/libopus.wasm",
--     "nui/lib/libopus.wasm.js",
--     "nui/js/AudioEngine.js",
--     "nui/js/script.js"
-- }
