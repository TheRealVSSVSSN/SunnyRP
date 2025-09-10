fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'NoPixel Inventory'

ui_page 'nui/ui.html'

files {
  'nui/ui.html',
  'nui/pricedown.ttf',
  'nui/default.png',
  'nui/background.png',
  'nui/weight-hanging-solid.png',
  'nui/hand-holding-solid.png',
  'nui/search-solid.png',
  'nui/invbg.png',
  'nui/styles.css',
  'nui/scripts.js',
  'nui/debounce.min.js',
  'nui/loading.gif',
  'nui/loading.svg',
  'nui/icons/*'
}

shared_script 'shared_list.js'

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  '@PolyZone/client.lua',
  'client.js',
  'functions.lua'
}

server_scripts {
  'server_degradation.js',
  'server_shops.js',
  'server.js'
}

dependencies {
  'PolyZone'
}

exports {
  'hasEnoughOfItem',
  'getQuantity',
  'GetCurrentWeapons',
  'GetItemInfo'
}
