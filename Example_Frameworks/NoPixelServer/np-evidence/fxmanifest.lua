fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/ui.html'

files {
  'html/ui.html',
  'html/css/site.css',
  'html/css/materialize.min.css',
  'html/js/site.js',
  'html/js/materialize.min.js',
  'html/js/moment.min.js',
  'html/images/bag_texture.png',
  'html/images/cursor.png'
}

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  'client.lua'
}

server_scripts {
  'server.lua'
}
