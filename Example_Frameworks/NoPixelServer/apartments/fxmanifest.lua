fx_version 'cerulean'
game 'gta5'

lua54 'yes'

ui_page 'index.html'

files {
  'index.html',
  'scripts.js',
  'css/style.css'
}

client_scripts {
  'apart_client.lua',
  'GUI.lua',
  'hotel_client.lua',
  'houserobberies_client.lua',
  'safecracking.lua'
}

server_scripts {
  'apart_server.lua',
  'hotel_server.lua'
}

exports {
  'nearClothingMotel'
}
