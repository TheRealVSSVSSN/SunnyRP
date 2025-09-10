--[[/ :FSN: \]]--
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Shared configuration
shared_script '@fsn_main/server_settings/sh_settings.lua'

-- Core scripts
client_script '@fsn_main/cl_utils.lua'
server_script '@fsn_main/sv_utils.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/ :FSN: \]]--

exports {
  'fsn_HasItem',
  'fsn_GetItemAmount',
  'fsn_GetItemDetails',
  'fsn_CanCarry',
  'EnumerateObjects'
}

server_exports {
  'fsn_itemStock'
}

-- Item scripts
client_scripts {
  '_item_misc/binoculars.lua',
  '_item_misc/dm_laundering.lua',
  '_item_misc/burger_store.lua',
  '_item_misc/cl_breather.lua',
  'cl_presets.lua',
  'cl_uses.lua',
  'cl_inventory.lua',
  'pd_locker/cl_locker.lua',
  --'cl_dropping.lua', -- legacy script disabled
  'cl_vehicles.lua'
}

server_scripts {
  'sv_presets.lua',
  'sv_inventory.lua',
  --'sv_dropping.lua', -- legacy script disabled
  'sv_vehicles.lua',
  'pd_locker/sv_locker.lua'
}

-- new gui
ui_page 'html/ui.html'
files {
  'html/ui.html',
  'html/css/ui.css',
  'html/css/jquery-ui.css',
  'html/js/inventory.js',
  'html/js/config.js',
  -- JS LOCALES
  'html/locales/cs.js',
  'html/locales/en.js',
  'html/locales/fr.js',
  -- IMAGES
  'html/img/bullet.png',
  -- ICONS
  'html/img/items/*.png'
}

