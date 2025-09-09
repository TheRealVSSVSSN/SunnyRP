# FiveM-FSN-Framework Documentation

## Overview
This repository contains the FSN framework resources for FiveM. Each folder under the root represents an individual resource providing gameplay features such as banking, police systems, and vehicle control. Scripts are written in Lua and use MySQL for persistence and NUI for browser-based interfaces.

## Table of Contents
- [README.md](#READMEmd) (Shared)
- [agents.md](#agentsmd) (Shared)
- [pipeline.yml](#pipelineyml) (Shared)
- [fsn_activities](#fsn_activities)
  - [fsn_activities/agents.md](#fsn_activities-agentsmd) (Shared)
  - [fsn_activities/fishing/client.lua](#fsn_activities-fishing-clientlua) (Client)
  - [fsn_activities/fxmanifest.lua](#fsn_activities-fxmanifestlua) (Shared)
  - [fsn_activities/hunting/client.lua](#fsn_activities-hunting-clientlua) (Client)
  - [fsn_activities/yoga/client.lua](#fsn_activities-yoga-clientlua) (Client)
- [fsn_admin](#fsn_admin)
  - [fsn_admin/agents.md](#fsn_admin-agentsmd) (Shared)
  - [fsn_admin/client.lua](#fsn_admin-clientlua) (Client)
  - [fsn_admin/client/client.lua](#fsn_admin-client-clientlua) (Client)
  - [fsn_admin/config.lua](#fsn_admin-configlua) (Shared)
  - [fsn_admin/fxmanifest.lua](#fsn_admin-fxmanifestlua) (Shared)
  - [fsn_admin/oldresource.lua](#fsn_admin-oldresourcelua) (Shared)
  - [fsn_admin/server.lua](#fsn_admin-serverlua) (Server)
  - [fsn_admin/server/server.lua](#fsn_admin-server-serverlua) (Server)
  - [fsn_admin/server_announce.lua](#fsn_admin-server_announcelua) (Server)
- [fsn_apartments](#fsn_apartments)
  - [fsn_apartments/agents.md](#fsn_apartments-agentsmd) (Shared)
  - [fsn_apartments/cl_instancing.lua](#fsn_apartments-cl_instancinglua) (Shared)
  - [fsn_apartments/client.lua](#fsn_apartments-clientlua) (Client)
  - [fsn_apartments/fxmanifest.lua](#fsn_apartments-fxmanifestlua) (Shared)
  - [fsn_apartments/gui/ui.css](#fsn_apartments-gui-uicss) (NUI)
  - [fsn_apartments/gui/ui.html](#fsn_apartments-gui-uihtml) (NUI)
  - [fsn_apartments/gui/ui.js](#fsn_apartments-gui-uijs) (NUI)
  - [fsn_apartments/server.lua](#fsn_apartments-serverlua) (Server)
  - [fsn_apartments/sv_instancing.lua](#fsn_apartments-sv_instancinglua) (Shared)
- [fsn_bank](#fsn_bank)
  - [fsn_bank/agents.md](#fsn_bank-agentsmd) (Shared)
  - [fsn_bank/client.lua](#fsn_bank-clientlua) (Client)
  - [fsn_bank/fxmanifest.lua](#fsn_bank-fxmanifestlua) (Shared)
  - [fsn_bank/gui/atm_button_sound.mp3](#fsn_bank-gui-atm_button_soundmp3) (NUI)
  - [fsn_bank/gui/atm_logo.png](#fsn_bank-gui-atm_logopng) (NUI)
  - [fsn_bank/gui/index.css](#fsn_bank-gui-indexcss) (NUI)
  - [fsn_bank/gui/index.html](#fsn_bank-gui-indexhtml) (NUI)
  - [fsn_bank/gui/index.js](#fsn_bank-gui-indexjs) (NUI)
  - [fsn_bank/server.lua](#fsn_bank-serverlua) (Server)
- [fsn_bankrobbery](#fsn_bankrobbery)
  - [fsn_bankrobbery/agents.md](#fsn_bankrobbery-agentsmd) (Shared)
  - [fsn_bankrobbery/cl_frontdesks.lua](#fsn_bankrobbery-cl_frontdeskslua) (Shared)
  - [fsn_bankrobbery/cl_safeanim.lua](#fsn_bankrobbery-cl_safeanimlua) (Shared)
  - [fsn_bankrobbery/client.lua](#fsn_bankrobbery-clientlua) (Client)
  - [fsn_bankrobbery/fxmanifest.lua](#fsn_bankrobbery-fxmanifestlua) (Shared)
  - [fsn_bankrobbery/server.lua](#fsn_bankrobbery-serverlua) (Server)
  - [fsn_bankrobbery/sv_frontdesks.lua](#fsn_bankrobbery-sv_frontdeskslua) (Shared)
  - [fsn_bankrobbery/trucks.lua](#fsn_bankrobbery-truckslua) (Shared)
- [fsn_bennys](#fsn_bennys)
  - [fsn_bennys/agents.md](#fsn_bennys-agentsmd) (Shared)
  - [fsn_bennys/cl_bennys.lua](#fsn_bennys-cl_bennyslua) (Shared)
  - [fsn_bennys/cl_config.lua](#fsn_bennys-cl_configlua) (Shared)
  - [fsn_bennys/fxmanifest.lua](#fsn_bennys-fxmanifestlua) (Shared)
  - [fsn_bennys/menu.lua](#fsn_bennys-menulua) (Shared)
- [fsn_bikerental](#fsn_bikerental)
  - [fsn_bikerental/agents.md](#fsn_bikerental-agentsmd) (Shared)
  - [fsn_bikerental/client.lua](#fsn_bikerental-clientlua) (Client)
  - [fsn_bikerental/fxmanifest.lua](#fsn_bikerental-fxmanifestlua) (Shared)
  - [fsn_bikerental/html/cursor.png](#fsn_bikerental-html-cursorpng) (NUI)
  - [fsn_bikerental/html/index.html](#fsn_bikerental-html-indexhtml) (NUI)
  - [fsn_bikerental/html/script.js](#fsn_bikerental-html-scriptjs) (NUI)
  - [fsn_bikerental/html/style.css](#fsn_bikerental-html-stylecss) (NUI)
- [fsn_boatshop](#fsn_boatshop)
  - [fsn_boatshop/agents.md](#fsn_boatshop-agentsmd) (Shared)
  - [fsn_boatshop/cl_boatshop.lua](#fsn_boatshop-cl_boatshoplua) (Shared)
  - [fsn_boatshop/cl_menu.lua](#fsn_boatshop-cl_menulua) (Shared)
  - [fsn_boatshop/fxmanifest.lua](#fsn_boatshop-fxmanifestlua) (Shared)
  - [fsn_boatshop/sv_boatshop.lua](#fsn_boatshop-sv_boatshoplua) (Shared)
- [fsn_builders](#fsn_builders)
  - [fsn_builders/agents.md](#fsn_builders-agentsmd) (Shared)
  - [fsn_builders/fxmanifest.lua](#fsn_builders-fxmanifestlua) (Shared)
  - [fsn_builders/handling_builder.lua](#fsn_builders-handling_builderlua) (Shared)
  - [fsn_builders/schema.lua](#fsn_builders-schemalua) (Shared)
  - [fsn_builders/schemas/cbikehandlingdata.lua](#fsn_builders-schemas-cbikehandlingdatalua) (Shared)
  - [fsn_builders/schemas/ccarhandlingdata.lua](#fsn_builders-schemas-ccarhandlingdatalua) (Shared)
  - [fsn_builders/schemas/chandlingdata.lua](#fsn_builders-schemas-chandlingdatalua) (Shared)
  - [fsn_builders/xml.lua](#fsn_builders-xmllua) (Shared)
- [fsn_cargarage](#fsn_cargarage)
  - [fsn_cargarage/agents.md](#fsn_cargarage-agentsmd) (Shared)
  - [fsn_cargarage/client.lua](#fsn_cargarage-clientlua) (Client)
  - [fsn_cargarage/fxmanifest.lua](#fsn_cargarage-fxmanifestlua) (Shared)
  - [fsn_cargarage/gui/ui.css](#fsn_cargarage-gui-uicss) (NUI)
  - [fsn_cargarage/gui/ui.html](#fsn_cargarage-gui-uihtml) (NUI)
  - [fsn_cargarage/gui/ui.js](#fsn_cargarage-gui-uijs) (NUI)
  - [fsn_cargarage/server.lua](#fsn_cargarage-serverlua) (Server)
- [fsn_carstore](#fsn_carstore)
  - [fsn_carstore/agents.md](#fsn_carstore-agentsmd) (Shared)
  - [fsn_carstore/cl_carstore.lua](#fsn_carstore-cl_carstorelua) (Shared)
  - [fsn_carstore/cl_menu.lua](#fsn_carstore-cl_menulua) (Shared)
  - [fsn_carstore/fxmanifest.lua](#fsn_carstore-fxmanifestlua) (Shared)
  - [fsn_carstore/gui/index.html](#fsn_carstore-gui-indexhtml) (NUI)
  - [fsn_carstore/sv_carstore.lua](#fsn_carstore-sv_carstorelua) (Shared)
  - [fsn_carstore/vehshop_server.lua](#fsn_carstore-vehshop_serverlua) (Server)
- [fsn_characterdetails](#fsn_characterdetails)
  - [fsn_characterdetails/agents.md](#fsn_characterdetails-agentsmd) (Shared)
  - [fsn_characterdetails/facial/client.lua](#fsn_characterdetails-facial-clientlua) (Client)
  - [fsn_characterdetails/facial/server.lua](#fsn_characterdetails-facial-serverlua) (Server)
  - [fsn_characterdetails/fxmanifest.lua](#fsn_characterdetails-fxmanifestlua) (Shared)
  - [fsn_characterdetails/gui/ui.css](#fsn_characterdetails-gui-uicss) (NUI)
  - [fsn_characterdetails/gui/ui.html](#fsn_characterdetails-gui-uihtml) (NUI)
  - [fsn_characterdetails/gui/ui.js](#fsn_characterdetails-gui-uijs) (NUI)
  - [fsn_characterdetails/gui_manager.lua](#fsn_characterdetails-gui_managerlua) (Shared)
  - [fsn_characterdetails/tattoos/client.lua](#fsn_characterdetails-tattoos-clientlua) (Client)
  - [fsn_characterdetails/tattoos/config.lua](#fsn_characterdetails-tattoos-configlua) (Shared)
  - [fsn_characterdetails/tattoos/server.lua](#fsn_characterdetails-tattoos-serverlua) (Server)
  - [fsn_characterdetails/tattoos/server.zip](#fsn_characterdetails-tattoos-serverzip) (Shared)
- [fsn_clothing](#fsn_clothing)
  - [fsn_clothing/agents.md](#fsn_clothing-agentsmd) (Shared)
  - [fsn_clothing/client.lua](#fsn_clothing-clientlua) (Client)
  - [fsn_clothing/config.lua](#fsn_clothing-configlua) (Shared)
  - [fsn_clothing/fxmanifest.lua](#fsn_clothing-fxmanifestlua) (Shared)
  - [fsn_clothing/gui.lua](#fsn_clothing-guilua) (Shared)
  - [fsn_clothing/models.txt](#fsn_clothing-modelstxt) (Shared)
  - [fsn_clothing/server.lua](#fsn_clothing-serverlua) (Server)
- [fsn_commands](#fsn_commands)
  - [fsn_commands/agents.md](#fsn_commands-agentsmd) (Shared)
  - [fsn_commands/client.lua](#fsn_commands-clientlua) (Client)
  - [fsn_commands/fxmanifest.lua](#fsn_commands-fxmanifestlua) (Shared)
  - [fsn_commands/server.lua](#fsn_commands-serverlua) (Server)
- [fsn_crafting](#fsn_crafting)
  - [fsn_crafting/agents.md](#fsn_crafting-agentsmd) (Shared)
  - [fsn_crafting/client.lua](#fsn_crafting-clientlua) (Client)
  - [fsn_crafting/fxmanifest.lua](#fsn_crafting-fxmanifestlua) (Shared)
  - [fsn_crafting/nui/index.css](#fsn_crafting-nui-indexcss) (NUI)
  - [fsn_crafting/nui/index.html](#fsn_crafting-nui-indexhtml) (NUI)
  - [fsn_crafting/nui/index.js](#fsn_crafting-nui-indexjs) (NUI)
  - [fsn_crafting/server.lua](#fsn_crafting-serverlua) (Server)
- [fsn_criminalmisc](#fsn_criminalmisc)
  - [fsn_criminalmisc/agents.md](#fsn_criminalmisc-agentsmd) (Shared)
  - [fsn_criminalmisc/client.lua](#fsn_criminalmisc-clientlua) (Client)
  - [fsn_criminalmisc/drugs/_effects/client.lua](#fsn_criminalmisc-drugs-_effects-clientlua) (Client)
  - [fsn_criminalmisc/drugs/_streetselling/client.lua](#fsn_criminalmisc-drugs-_streetselling-clientlua) (Client)
  - [fsn_criminalmisc/drugs/_streetselling/server.lua](#fsn_criminalmisc-drugs-_streetselling-serverlua) (Server)
  - [fsn_criminalmisc/drugs/_weedprocess/client.lua](#fsn_criminalmisc-drugs-_weedprocess-clientlua) (Client)
  - [fsn_criminalmisc/drugs/client.lua](#fsn_criminalmisc-drugs-clientlua) (Client)
  - [fsn_criminalmisc/fxmanifest.lua](#fsn_criminalmisc-fxmanifestlua) (Shared)
  - [fsn_criminalmisc/handcuffs/client.lua](#fsn_criminalmisc-handcuffs-clientlua) (Client)
  - [fsn_criminalmisc/handcuffs/server.lua](#fsn_criminalmisc-handcuffs-serverlua) (Server)
  - [fsn_criminalmisc/lockpicking/client.lua](#fsn_criminalmisc-lockpicking-clientlua) (Client)
  - [fsn_criminalmisc/pawnstore/cl_pawnstore.lua](#fsn_criminalmisc-pawnstore-cl_pawnstorelua) (Shared)
  - [fsn_criminalmisc/remapping/client.lua](#fsn_criminalmisc-remapping-clientlua) (Client)
  - [fsn_criminalmisc/remapping/server.lua](#fsn_criminalmisc-remapping-serverlua) (Server)
  - [fsn_criminalmisc/robbing/cl_houses-build.lua](#fsn_criminalmisc-robbing-cl_houses-buildlua) (Shared)
  - [fsn_criminalmisc/robbing/cl_houses-config.lua](#fsn_criminalmisc-robbing-cl_houses-configlua) (Shared)
  - [fsn_criminalmisc/robbing/cl_houses.lua](#fsn_criminalmisc-robbing-cl_houseslua) (Shared)
  - [fsn_criminalmisc/robbing/client.lua](#fsn_criminalmisc-robbing-clientlua) (Client)
  - [fsn_criminalmisc/streetracing/client.lua](#fsn_criminalmisc-streetracing-clientlua) (Client)
  - [fsn_criminalmisc/streetracing/server.lua](#fsn_criminalmisc-streetracing-serverlua) (Server)
  - [fsn_criminalmisc/weaponinfo/client.lua](#fsn_criminalmisc-weaponinfo-clientlua) (Client)
  - [fsn_criminalmisc/weaponinfo/server.lua](#fsn_criminalmisc-weaponinfo-serverlua) (Server)
  - [fsn_criminalmisc/weaponinfo/weapon_list.lua](#fsn_criminalmisc-weaponinfo-weapon_listlua) (Shared)
- [fsn_customanimations](#fsn_customanimations)
  - [fsn_customanimations/agents.md](#fsn_customanimations-agentsmd) (Shared)
  - [fsn_customanimations/client.lua](#fsn_customanimations-clientlua) (Client)
  - [fsn_customanimations/fxmanifest.lua](#fsn_customanimations-fxmanifestlua) (Shared)
- [fsn_customs](#fsn_customs)
  - [fsn_customs/agents.md](#fsn_customs-agentsmd) (Shared)
  - [fsn_customs/fxmanifest.lua](#fsn_customs-fxmanifestlua) (Shared)
  - [fsn_customs/lscustoms.lua](#fsn_customs-lscustomslua) (Shared)
- [fsn_dev](#fsn_dev)
  - [fsn_dev/agents.md](#fsn_dev-agentsmd) (Shared)
  - [fsn_dev/client/cl_noclip.lua](#fsn_dev-client-cl_nocliplua) (Shared)
  - [fsn_dev/client/client.lua](#fsn_dev-client-clientlua) (Client)
  - [fsn_dev/config.lua](#fsn_dev-configlua) (Shared)
  - [fsn_dev/fxmanifest.lua](#fsn_dev-fxmanifestlua) (Shared)
  - [fsn_dev/oldresource.lua](#fsn_dev-oldresourcelua) (Shared)
  - [fsn_dev/server/server.lua](#fsn_dev-server-serverlua) (Server)
- [fsn_doj](#fsn_doj)
  - [fsn_doj/agents.md](#fsn_doj-agentsmd) (Shared)
  - [fsn_doj/attorneys/client.lua](#fsn_doj-attorneys-clientlua) (Client)
  - [fsn_doj/attorneys/server.lua](#fsn_doj-attorneys-serverlua) (Server)
  - [fsn_doj/client.lua](#fsn_doj-clientlua) (Client)
  - [fsn_doj/fxmanifest.lua](#fsn_doj-fxmanifestlua) (Shared)
  - [fsn_doj/judges/client.lua](#fsn_doj-judges-clientlua) (Client)
  - [fsn_doj/judges/server.lua](#fsn_doj-judges-serverlua) (Server)
- [fsn_doormanager](#fsn_doormanager)
  - [fsn_doormanager/agents.md](#fsn_doormanager-agentsmd) (Shared)
  - [fsn_doormanager/cl_doors.lua](#fsn_doormanager-cl_doorslua) (Shared)
  - [fsn_doormanager/client.lua](#fsn_doormanager-clientlua) (Client)
  - [fsn_doormanager/fxmanifest.lua](#fsn_doormanager-fxmanifestlua) (Shared)
  - [fsn_doormanager/server.lua](#fsn_doormanager-serverlua) (Server)
  - [fsn_doormanager/sv_doors.lua](#fsn_doormanager-sv_doorslua) (Shared)
- [fsn_emotecontrol](#fsn_emotecontrol)
  - [fsn_emotecontrol/agents.md](#fsn_emotecontrol-agentsmd) (Shared)
  - [fsn_emotecontrol/client.lua](#fsn_emotecontrol-clientlua) (Client)
  - [fsn_emotecontrol/fxmanifest.lua](#fsn_emotecontrol-fxmanifestlua) (Shared)
  - [fsn_emotecontrol/walktypes/client.lua](#fsn_emotecontrol-walktypes-clientlua) (Client)
- [fsn_ems](#fsn_ems)
  - [fsn_ems/agents.md](#fsn_ems-agentsmd) (Shared)
  - [fsn_ems/beds/client.lua](#fsn_ems-beds-clientlua) (Client)
  - [fsn_ems/beds/server.lua](#fsn_ems-beds-serverlua) (Server)
  - [fsn_ems/blip.lua](#fsn_ems-bliplua) (Shared)
  - [fsn_ems/cl_advanceddamage.lua](#fsn_ems-cl_advanceddamagelua) (Shared)
  - [fsn_ems/cl_carrydead.lua](#fsn_ems-cl_carrydeadlua) (Shared)
  - [fsn_ems/cl_volunteering.lua](#fsn_ems-cl_volunteeringlua) (Shared)
  - [fsn_ems/client.lua](#fsn_ems-clientlua) (Client)
  - [fsn_ems/debug_kng.lua](#fsn_ems-debug_knglua) (Shared)
  - [fsn_ems/fxmanifest.lua](#fsn_ems-fxmanifestlua) (Shared)
  - [fsn_ems/info.txt](#fsn_ems-infotxt) (Shared)
  - [fsn_ems/server.lua](#fsn_ems-serverlua) (Server)
  - [fsn_ems/sv_carrydead.lua](#fsn_ems-sv_carrydeadlua) (Shared)
- [fsn_entfinder](#fsn_entfinder)
  - [fsn_entfinder/agents.md](#fsn_entfinder-agentsmd) (Shared)
  - [fsn_entfinder/client.lua](#fsn_entfinder-clientlua) (Client)
  - [fsn_entfinder/fxmanifest.lua](#fsn_entfinder-fxmanifestlua) (Shared)
- [fsn_errorcontrol](#fsn_errorcontrol)
  - [fsn_errorcontrol/agents.md](#fsn_errorcontrol-agentsmd) (Shared)
  - [fsn_errorcontrol/client.lua](#fsn_errorcontrol-clientlua) (Client)
  - [fsn_errorcontrol/fxmanifest.lua](#fsn_errorcontrol-fxmanifestlua) (Shared)
- [fsn_evidence](#fsn_evidence)
  - [fsn_evidence/__descriptions-carpaint.lua](#fsn_evidence-__descriptions-carpaintlua) (Shared)
  - [fsn_evidence/__descriptions-female.lua](#fsn_evidence-__descriptions-femalelua) (Shared)
  - [fsn_evidence/__descriptions-male.lua](#fsn_evidence-__descriptions-malelua) (Shared)
  - [fsn_evidence/__descriptions.lua](#fsn_evidence-__descriptionslua) (Shared)
  - [fsn_evidence/agents.md](#fsn_evidence-agentsmd) (Shared)
  - [fsn_evidence/casings/cl_casings.lua](#fsn_evidence-casings-cl_casingslua) (Shared)
  - [fsn_evidence/cl_evidence.lua](#fsn_evidence-cl_evidencelua) (Shared)
  - [fsn_evidence/fxmanifest.lua](#fsn_evidence-fxmanifestlua) (Shared)
  - [fsn_evidence/ped/cl_ped.lua](#fsn_evidence-ped-cl_pedlua) (Shared)
  - [fsn_evidence/ped/sv_ped.lua](#fsn_evidence-ped-sv_pedlua) (Shared)
  - [fsn_evidence/sv_evidence.lua](#fsn_evidence-sv_evidencelua) (Shared)
- [fsn_gangs](#fsn_gangs)
  - [fsn_gangs/agents.md](#fsn_gangs-agentsmd) (Shared)
  - [fsn_gangs/cl_gangs.lua](#fsn_gangs-cl_gangslua) (Shared)
  - [fsn_gangs/fxmanifest.lua](#fsn_gangs-fxmanifestlua) (Shared)
  - [fsn_gangs/sv_gangs.lua](#fsn_gangs-sv_gangslua) (Shared)
- [fsn_handling](#fsn_handling)
  - [fsn_handling/agents.md](#fsn_handling-agentsmd) (Shared)
  - [fsn_handling/data/handling.meta](#fsn_handling-data-handlingmeta) (Shared)
  - [fsn_handling/fxmanifest.lua](#fsn_handling-fxmanifestlua) (Shared)
  - [fsn_handling/src/compact.lua](#fsn_handling-src-compactlua) (Shared)
  - [fsn_handling/src/coupes.lua](#fsn_handling-src-coupeslua) (Shared)
  - [fsn_handling/src/government.lua](#fsn_handling-src-governmentlua) (Shared)
  - [fsn_handling/src/motorcycles.lua](#fsn_handling-src-motorcycleslua) (Shared)
  - [fsn_handling/src/muscle.lua](#fsn_handling-src-musclelua) (Shared)
  - [fsn_handling/src/offroad.lua](#fsn_handling-src-offroadlua) (Shared)
  - [fsn_handling/src/schafter.lua](#fsn_handling-src-schafterlua) (Shared)
  - [fsn_handling/src/sedans.lua](#fsn_handling-src-sedanslua) (Shared)
  - [fsn_handling/src/sports.lua](#fsn_handling-src-sportslua) (Shared)
  - [fsn_handling/src/sportsclassics.lua](#fsn_handling-src-sportsclassicslua) (Shared)
  - [fsn_handling/src/super.lua](#fsn_handling-src-superlua) (Shared)
  - [fsn_handling/src/suvs.lua](#fsn_handling-src-suvslua) (Shared)
  - [fsn_handling/src/vans.lua](#fsn_handling-src-vanslua) (Shared)
- [fsn_inventory](#fsn_inventory)
  - [fsn_inventory/_item_misc/binoculars.lua](#fsn_inventory-_item_misc-binocularslua) (Shared)
  - [fsn_inventory/_item_misc/burger_store.lua](#fsn_inventory-_item_misc-burger_storelua) (Shared)
  - [fsn_inventory/_item_misc/cl_breather.lua](#fsn_inventory-_item_misc-cl_breatherlua) (Shared)
  - [fsn_inventory/_item_misc/dm_laundering.lua](#fsn_inventory-_item_misc-dm_launderinglua) (Shared)
  - [fsn_inventory/_old/_item_misc/_drug_selling.lua](#fsn_inventory-_old-_item_misc-_drug_sellinglua) (Shared)
  - [fsn_inventory/_old/client.lua](#fsn_inventory-_old-clientlua) (Client)
  - [fsn_inventory/_old/items.lua](#fsn_inventory-_old-itemslua) (Shared)
  - [fsn_inventory/_old/pedfinder.lua](#fsn_inventory-_old-pedfinderlua) (Shared)
  - [fsn_inventory/_old/server.lua](#fsn_inventory-_old-serverlua) (Server)
  - [fsn_inventory/agents.md](#fsn_inventory-agentsmd) (Shared)
  - [fsn_inventory/cl_inventory.lua](#fsn_inventory-cl_inventorylua) (Shared)
  - [fsn_inventory/cl_presets.lua](#fsn_inventory-cl_presetslua) (Shared)
  - [fsn_inventory/cl_uses.lua](#fsn_inventory-cl_useslua) (Shared)
  - [fsn_inventory/cl_vehicles.lua](#fsn_inventory-cl_vehicleslua) (Shared)
  - [fsn_inventory/fxmanifest.lua](#fsn_inventory-fxmanifestlua) (Shared)
  - [fsn_inventory/html/css/jquery-ui.css](#fsn_inventory-html-css-jquery-uicss) (NUI)
  - [fsn_inventory/html/css/ui.css](#fsn_inventory-html-css-uicss) (NUI)
  - [fsn_inventory/html/img/bullet.png](#fsn_inventory-html-img-bulletpng) (NUI)
  - [fsn_inventory/html/img/items/2g_weed.png](#fsn_inventory-html-img-items-2g_weedpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_ADVANCEDRIFLE.png](#fsn_inventory-html-img-items-WEAPON_ADVANCEDRIFLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_APPISTOL.png](#fsn_inventory-html-img-items-WEAPON_APPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE.png](#fsn_inventory-html-img-items-WEAPON_ASSAULTRIFLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE_MK2.png](#fsn_inventory-html-img-items-WEAPON_ASSAULTRIFLE_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_ASSAULTSHOTGUN.png](#fsn_inventory-html-img-items-WEAPON_ASSAULTSHOTGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_ASSAULTSMG.png](#fsn_inventory-html-img-items-WEAPON_ASSAULTSMGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_AUTOSHOTGUN.png](#fsn_inventory-html-img-items-WEAPON_AUTOSHOTGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_BALL.png](#fsn_inventory-html-img-items-WEAPON_BALLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_BAT.png](#fsn_inventory-html-img-items-WEAPON_BATpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_BATTLEAXE.png](#fsn_inventory-html-img-items-WEAPON_BATTLEAXEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_BOTTLE.png](#fsn_inventory-html-img-items-WEAPON_BOTTLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE.png](#fsn_inventory-html-img-items-WEAPON_BULLPUPRIFLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE_MK2.png](#fsn_inventory-html-img-items-WEAPON_BULLPUPRIFLE_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_BULLPUPSHOTGUN.png](#fsn_inventory-html-img-items-WEAPON_BULLPUPSHOTGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_CARBINERIFLE.png](#fsn_inventory-html-img-items-WEAPON_CARBINERIFLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_CARBINERIFLE_MK2.png](#fsn_inventory-html-img-items-WEAPON_CARBINERIFLE_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_COMBATMG.png](#fsn_inventory-html-img-items-WEAPON_COMBATMGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_COMBATMG_MK2.png](#fsn_inventory-html-img-items-WEAPON_COMBATMG_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_COMBATPDW.png](#fsn_inventory-html-img-items-WEAPON_COMBATPDWpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_COMBATPISTOL.png](#fsn_inventory-html-img-items-WEAPON_COMBATPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_COMPACTLAUNCHER.png](#fsn_inventory-html-img-items-WEAPON_COMPACTLAUNCHERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_COMPACTRIFLE.png](#fsn_inventory-html-img-items-WEAPON_COMPACTRIFLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_CROWBAR.png](#fsn_inventory-html-img-items-WEAPON_CROWBARpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_DAGGER.png](#fsn_inventory-html-img-items-WEAPON_DAGGERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_DBSHOTGUN.png](#fsn_inventory-html-img-items-WEAPON_DBSHOTGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_DOUBLEACTION.png](#fsn_inventory-html-img-items-WEAPON_DOUBLEACTIONpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_FIREEXTINGUISHER.png](#fsn_inventory-html-img-items-WEAPON_FIREEXTINGUISHERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_FIREWORK.png](#fsn_inventory-html-img-items-WEAPON_FIREWORKpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_FLARE.png](#fsn_inventory-html-img-items-WEAPON_FLAREpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_FLAREGUN.png](#fsn_inventory-html-img-items-WEAPON_FLAREGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_FLASHLIGHT.png](#fsn_inventory-html-img-items-WEAPON_FLASHLIGHTpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_GOLFCLUB.png](#fsn_inventory-html-img-items-WEAPON_GOLFCLUBpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_GRENADE.png](#fsn_inventory-html-img-items-WEAPON_GRENADEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_GRENADELAUNCHER.png](#fsn_inventory-html-img-items-WEAPON_GRENADELAUNCHERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_GUSENBERG.png](#fsn_inventory-html-img-items-WEAPON_GUSENBERGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_HAMMER.png](#fsn_inventory-html-img-items-WEAPON_HAMMERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_HATCHET.png](#fsn_inventory-html-img-items-WEAPON_HATCHETpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_HEAVYPISTOL.png](#fsn_inventory-html-img-items-WEAPON_HEAVYPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_HEAVYSHOTGUN.png](#fsn_inventory-html-img-items-WEAPON_HEAVYSHOTGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER.png](#fsn_inventory-html-img-items-WEAPON_HEAVYSNIPERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER_MK2.png](#fsn_inventory-html-img-items-WEAPON_HEAVYSNIPER_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_HOMINGLAUNCHER.png](#fsn_inventory-html-img-items-WEAPON_HOMINGLAUNCHERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_KNIFE.png](#fsn_inventory-html-img-items-WEAPON_KNIFEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_KNUCKLE.png](#fsn_inventory-html-img-items-WEAPON_KNUCKLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MACHETE.png](#fsn_inventory-html-img-items-WEAPON_MACHETEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MACHINEPISTOL.png](#fsn_inventory-html-img-items-WEAPON_MACHINEPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MARKSMANPISTOL.png](#fsn_inventory-html-img-items-WEAPON_MARKSMANPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE.png](#fsn_inventory-html-img-items-WEAPON_MARKSMANRIFLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE_MK2.png](#fsn_inventory-html-img-items-WEAPON_MARKSMANRIFLE_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MG.png](#fsn_inventory-html-img-items-WEAPON_MGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MICROSMG.png](#fsn_inventory-html-img-items-WEAPON_MICROSMGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MINIGUN.png](#fsn_inventory-html-img-items-WEAPON_MINIGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MINISMG.png](#fsn_inventory-html-img-items-WEAPON_MINISMGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MOLOTOV.png](#fsn_inventory-html-img-items-WEAPON_MOLOTOVpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_MUSKET.png](#fsn_inventory-html-img-items-WEAPON_MUSKETpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_NIGHTSTICK.png](#fsn_inventory-html-img-items-WEAPON_NIGHTSTICKpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PETROLCAN.png](#fsn_inventory-html-img-items-WEAPON_PETROLCANpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PIPEBOMB.png](#fsn_inventory-html-img-items-WEAPON_PIPEBOMBpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PISTOL.png](#fsn_inventory-html-img-items-WEAPON_PISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PISTOL50.png](#fsn_inventory-html-img-items-WEAPON_PISTOL50png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PISTOL_MK2.png](#fsn_inventory-html-img-items-WEAPON_PISTOL_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_POOLCUE.png](#fsn_inventory-html-img-items-WEAPON_POOLCUEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PROXMINE.png](#fsn_inventory-html-img-items-WEAPON_PROXMINEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN.png](#fsn_inventory-html-img-items-WEAPON_PUMPSHOTGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN_MK2.png](#fsn_inventory-html-img-items-WEAPON_PUMPSHOTGUN_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_RAILGUN.png](#fsn_inventory-html-img-items-WEAPON_RAILGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_RAYCARBINE.png](#fsn_inventory-html-img-items-WEAPON_RAYCARBINEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_RAYMINIGUN.png](#fsn_inventory-html-img-items-WEAPON_RAYMINIGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_RAYPISTOL.png](#fsn_inventory-html-img-items-WEAPON_RAYPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_REVOLVER.png](#fsn_inventory-html-img-items-WEAPON_REVOLVERpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_REVOLVER_MK2.png](#fsn_inventory-html-img-items-WEAPON_REVOLVER_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_RPG.png](#fsn_inventory-html-img-items-WEAPON_RPGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SAWNOFFSHOTGUN.png](#fsn_inventory-html-img-items-WEAPON_SAWNOFFSHOTGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SMG.png](#fsn_inventory-html-img-items-WEAPON_SMGpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SMG_MK2.png](#fsn_inventory-html-img-items-WEAPON_SMG_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SMOKEGRENADE.png](#fsn_inventory-html-img-items-WEAPON_SMOKEGRENADEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SNIPERRIFLE.png](#fsn_inventory-html-img-items-WEAPON_SNIPERRIFLEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SNOWBALL.png](#fsn_inventory-html-img-items-WEAPON_SNOWBALLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SNSPISTOL.png](#fsn_inventory-html-img-items-WEAPON_SNSPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SNSPISTOL_MK2.png](#fsn_inventory-html-img-items-WEAPON_SNSPISTOL_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE.png](#fsn_inventory-html-img-items-WEAPON_SPECIALCARBINEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE_MK2.png](#fsn_inventory-html-img-items-WEAPON_SPECIALCARBINE_MK2png) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_STICKYBOMB.png](#fsn_inventory-html-img-items-WEAPON_STICKYBOMBpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_STONE_HATCHET.png](#fsn_inventory-html-img-items-WEAPON_STONE_HATCHETpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_STUNGUN.png](#fsn_inventory-html-img-items-WEAPON_STUNGUNpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_SWITCHBLADE.png](#fsn_inventory-html-img-items-WEAPON_SWITCHBLADEpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_VINTAGEPISTOL.png](#fsn_inventory-html-img-items-WEAPON_VINTAGEPISTOLpng) (NUI)
  - [fsn_inventory/html/img/items/WEAPON_WRENCH.png](#fsn_inventory-html-img-items-WEAPON_WRENCHpng) (NUI)
  - [fsn_inventory/html/img/items/acetone.png](#fsn_inventory-html-img-items-acetonepng) (NUI)
  - [fsn_inventory/html/img/items/ammo_mg.png](#fsn_inventory-html-img-items-ammo_mgpng) (NUI)
  - [fsn_inventory/html/img/items/ammo_mg_large.png](#fsn_inventory-html-img-items-ammo_mg_largepng) (NUI)
  - [fsn_inventory/html/img/items/ammo_pistol.png](#fsn_inventory-html-img-items-ammo_pistolpng) (NUI)
  - [fsn_inventory/html/img/items/ammo_pistol_large.png](#fsn_inventory-html-img-items-ammo_pistol_largepng) (NUI)
  - [fsn_inventory/html/img/items/ammo_rifle.png](#fsn_inventory-html-img-items-ammo_riflepng) (NUI)
  - [fsn_inventory/html/img/items/ammo_rifle_large.png](#fsn_inventory-html-img-items-ammo_rifle_largepng) (NUI)
  - [fsn_inventory/html/img/items/ammo_shotgun.png](#fsn_inventory-html-img-items-ammo_shotgunpng) (NUI)
  - [fsn_inventory/html/img/items/ammo_shotgun_large.png](#fsn_inventory-html-img-items-ammo_shotgun_largepng) (NUI)
  - [fsn_inventory/html/img/items/ammo_smg.png](#fsn_inventory-html-img-items-ammo_smgpng) (NUI)
  - [fsn_inventory/html/img/items/ammo_smg_large.png](#fsn_inventory-html-img-items-ammo_smg_largepng) (NUI)
  - [fsn_inventory/html/img/items/ammo_sniper.png](#fsn_inventory-html-img-items-ammo_sniperpng) (NUI)
  - [fsn_inventory/html/img/items/ammo_sniper_large.png](#fsn_inventory-html-img-items-ammo_sniper_largepng) (NUI)
  - [fsn_inventory/html/img/items/armor.png](#fsn_inventory-html-img-items-armorpng) (NUI)
  - [fsn_inventory/html/img/items/bandage.png](#fsn_inventory-html-img-items-bandagepng) (NUI)
  - [fsn_inventory/html/img/items/beef_jerky.png](#fsn_inventory-html-img-items-beef_jerkypng) (NUI)
  - [fsn_inventory/html/img/items/binoculars.png](#fsn_inventory-html-img-items-binocularspng) (NUI)
  - [fsn_inventory/html/img/items/burger.png](#fsn_inventory-html-img-items-burgerpng) (NUI)
  - [fsn_inventory/html/img/items/burger_bun.png](#fsn_inventory-html-img-items-burger_bunpng) (NUI)
  - [fsn_inventory/html/img/items/cigarette.png](#fsn_inventory-html-img-items-cigarettepng) (NUI)
  - [fsn_inventory/html/img/items/coffee.png](#fsn_inventory-html-img-items-coffeepng) (NUI)
  - [fsn_inventory/html/img/items/cooked_burger.png](#fsn_inventory-html-img-items-cooked_burgerpng) (NUI)
  - [fsn_inventory/html/img/items/cooked_meat.png](#fsn_inventory-html-img-items-cooked_meatpng) (NUI)
  - [fsn_inventory/html/img/items/cupcake.png](#fsn_inventory-html-img-items-cupcakepng) (NUI)
  - [fsn_inventory/html/img/items/dirty_money.png](#fsn_inventory-html-img-items-dirty_moneypng) (NUI)
  - [fsn_inventory/html/img/items/drill.png](#fsn_inventory-html-img-items-drillpng) (NUI)
  - [fsn_inventory/html/img/items/ecola.png](#fsn_inventory-html-img-items-ecolapng) (NUI)
  - [fsn_inventory/html/img/items/empty_canister.png](#fsn_inventory-html-img-items-empty_canisterpng) (NUI)
  - [fsn_inventory/html/img/items/evidence.png](#fsn_inventory-html-img-items-evidencepng) (NUI)
  - [fsn_inventory/html/img/items/fries.png](#fsn_inventory-html-img-items-friespng) (NUI)
  - [fsn_inventory/html/img/items/frozen_burger.png](#fsn_inventory-html-img-items-frozen_burgerpng) (NUI)
  - [fsn_inventory/html/img/items/frozen_fries.png](#fsn_inventory-html-img-items-frozen_friespng) (NUI)
  - [fsn_inventory/html/img/items/gas_canister.png](#fsn_inventory-html-img-items-gas_canisterpng) (NUI)
  - [fsn_inventory/html/img/items/id.png](#fsn_inventory-html-img-items-idpng) (NUI)
  - [fsn_inventory/html/img/items/joint.png](#fsn_inventory-html-img-items-jointpng) (NUI)
  - [fsn_inventory/html/img/items/keycard.png](#fsn_inventory-html-img-items-keycardpng) (NUI)
  - [fsn_inventory/html/img/items/lockpick.png](#fsn_inventory-html-img-items-lockpickpng) (NUI)
  - [fsn_inventory/html/img/items/meth_rocks.png](#fsn_inventory-html-img-items-meth_rockspng) (NUI)
  - [fsn_inventory/html/img/items/microwave_burrito.png](#fsn_inventory-html-img-items-microwave_burritopng) (NUI)
  - [fsn_inventory/html/img/items/minced_meat.png](#fsn_inventory-html-img-items-minced_meatpng) (NUI)
  - [fsn_inventory/html/img/items/modified_drillbit.png](#fsn_inventory-html-img-items-modified_drillbitpng) (NUI)
  - [fsn_inventory/html/img/items/morphine.png](#fsn_inventory-html-img-items-morphinepng) (NUI)
  - [fsn_inventory/html/img/items/packaged_cocaine.png](#fsn_inventory-html-img-items-packaged_cocainepng) (NUI)
  - [fsn_inventory/html/img/items/painkillers.png](#fsn_inventory-html-img-items-painkillerspng) (NUI)
  - [fsn_inventory/html/img/items/panini.png](#fsn_inventory-html-img-items-paninipng) (NUI)
  - [fsn_inventory/html/img/items/pepsi.png](#fsn_inventory-html-img-items-pepsipng) (NUI)
  - [fsn_inventory/html/img/items/pepsi_max.png](#fsn_inventory-html-img-items-pepsi_maxpng) (NUI)
  - [fsn_inventory/html/img/items/phone.png](#fsn_inventory-html-img-items-phonepng) (NUI)
  - [fsn_inventory/html/img/items/phosphorus.png](#fsn_inventory-html-img-items-phosphoruspng) (NUI)
  - [fsn_inventory/html/img/items/radio_receiver.png](#fsn_inventory-html-img-items-radio_receiverpng) (NUI)
  - [fsn_inventory/html/img/items/repair_kit.png](#fsn_inventory-html-img-items-repair_kitpng) (NUI)
  - [fsn_inventory/html/img/items/tuner_chip.png](#fsn_inventory-html-img-items-tuner_chippng) (NUI)
  - [fsn_inventory/html/img/items/uncooked_meat.png](#fsn_inventory-html-img-items-uncooked_meatpng) (NUI)
  - [fsn_inventory/html/img/items/vpn1.png](#fsn_inventory-html-img-items-vpn1png) (NUI)
  - [fsn_inventory/html/img/items/vpn2.png](#fsn_inventory-html-img-items-vpn2png) (NUI)
  - [fsn_inventory/html/img/items/water.png](#fsn_inventory-html-img-items-waterpng) (NUI)
  - [fsn_inventory/html/img/items/zipties.png](#fsn_inventory-html-img-items-ziptiespng) (NUI)
  - [fsn_inventory/html/js/config.js](#fsn_inventory-html-js-configjs) (NUI)
  - [fsn_inventory/html/js/inventory.js](#fsn_inventory-html-js-inventoryjs) (NUI)
  - [fsn_inventory/html/locales/cs.js](#fsn_inventory-html-locales-csjs) (NUI)
  - [fsn_inventory/html/locales/en.js](#fsn_inventory-html-locales-enjs) (NUI)
  - [fsn_inventory/html/locales/fr.js](#fsn_inventory-html-locales-frjs) (NUI)
  - [fsn_inventory/html/ui.html](#fsn_inventory-html-uihtml) (NUI)
  - [fsn_inventory/pd_locker/cl_locker.lua](#fsn_inventory-pd_locker-cl_lockerlua) (Shared)
  - [fsn_inventory/pd_locker/datastore.txt](#fsn_inventory-pd_locker-datastoretxt) (Shared)
  - [fsn_inventory/pd_locker/sv_locker.lua](#fsn_inventory-pd_locker-sv_lockerlua) (Shared)
  - [fsn_inventory/sv_inventory.lua](#fsn_inventory-sv_inventorylua) (Shared)
  - [fsn_inventory/sv_presets.lua](#fsn_inventory-sv_presetslua) (Shared)
  - [fsn_inventory/sv_vehicles.lua](#fsn_inventory-sv_vehicleslua) (Shared)
- [fsn_inventory_dropping](#fsn_inventory_dropping)
  - [fsn_inventory_dropping/agents.md](#fsn_inventory_dropping-agentsmd) (Shared)
  - [fsn_inventory_dropping/cl_dropping.lua](#fsn_inventory_dropping-cl_droppinglua) (Shared)
  - [fsn_inventory_dropping/fxmanifest.lua](#fsn_inventory_dropping-fxmanifestlua) (Shared)
  - [fsn_inventory_dropping/sv_dropping.lua](#fsn_inventory_dropping-sv_droppinglua) (Shared)
- [fsn_jail](#fsn_jail)
  - [fsn_jail/agents.md](#fsn_jail-agentsmd) (Shared)
  - [fsn_jail/client.lua](#fsn_jail-clientlua) (Client)
  - [fsn_jail/fxmanifest.lua](#fsn_jail-fxmanifestlua) (Shared)
  - [fsn_jail/server.lua](#fsn_jail-serverlua) (Server)
- [fsn_jewellerystore](#fsn_jewellerystore)
  - [fsn_jewellerystore/agents.md](#fsn_jewellerystore-agentsmd) (Shared)
  - [fsn_jewellerystore/client.lua](#fsn_jewellerystore-clientlua) (Client)
  - [fsn_jewellerystore/fxmanifest.lua](#fsn_jewellerystore-fxmanifestlua) (Shared)
  - [fsn_jewellerystore/server.lua](#fsn_jewellerystore-serverlua) (Server)
- [fsn_jobs](#fsn_jobs)
  - [fsn_jobs/agents.md](#fsn_jobs-agentsmd) (Shared)
  - [fsn_jobs/client.lua](#fsn_jobs-clientlua) (Client)
  - [fsn_jobs/delivery/client.lua](#fsn_jobs-delivery-clientlua) (Client)
  - [fsn_jobs/farming/client.lua](#fsn_jobs-farming-clientlua) (Client)
  - [fsn_jobs/fxmanifest.lua](#fsn_jobs-fxmanifestlua) (Shared)
  - [fsn_jobs/garbage/client.lua](#fsn_jobs-garbage-clientlua) (Client)
  - [fsn_jobs/hunting/client.lua](#fsn_jobs-hunting-clientlua) (Client)
  - [fsn_jobs/mechanic/client.lua](#fsn_jobs-mechanic-clientlua) (Client)
  - [fsn_jobs/mechanic/mechmenu.lua](#fsn_jobs-mechanic-mechmenulua) (Shared)
  - [fsn_jobs/mechanic/server.lua](#fsn_jobs-mechanic-serverlua) (Server)
  - [fsn_jobs/news/client.lua](#fsn_jobs-news-clientlua) (Client)
  - [fsn_jobs/repo/client.lua](#fsn_jobs-repo-clientlua) (Client)
  - [fsn_jobs/repo/server.lua](#fsn_jobs-repo-serverlua) (Server)
  - [fsn_jobs/scrap/client.lua](#fsn_jobs-scrap-clientlua) (Client)
  - [fsn_jobs/server.lua](#fsn_jobs-serverlua) (Server)
  - [fsn_jobs/taxi/client.lua](#fsn_jobs-taxi-clientlua) (Client)
  - [fsn_jobs/taxi/server.lua](#fsn_jobs-taxi-serverlua) (Server)
  - [fsn_jobs/tow/client.lua](#fsn_jobs-tow-clientlua) (Client)
  - [fsn_jobs/tow/server.lua](#fsn_jobs-tow-serverlua) (Server)
  - [fsn_jobs/trucker/client.lua](#fsn_jobs-trucker-clientlua) (Client)
  - [fsn_jobs/whitelists/client.lua](#fsn_jobs-whitelists-clientlua) (Client)
  - [fsn_jobs/whitelists/server.lua](#fsn_jobs-whitelists-serverlua) (Server)
- [fsn_licenses](#fsn_licenses)
  - [fsn_licenses/agents.md](#fsn_licenses-agentsmd) (Shared)
  - [fsn_licenses/cl_desk.lua](#fsn_licenses-cl_desklua) (Shared)
  - [fsn_licenses/client.lua](#fsn_licenses-clientlua) (Client)
  - [fsn_licenses/fxmanifest.lua](#fsn_licenses-fxmanifestlua) (Shared)
  - [fsn_licenses/server.lua](#fsn_licenses-serverlua) (Server)
  - [fsn_licenses/sv_desk.lua](#fsn_licenses-sv_desklua) (Shared)
- [fsn_loadingscreen](#fsn_loadingscreen)
  - [fsn_loadingscreen/agents.md](#fsn_loadingscreen-agentsmd) (Shared)
  - [fsn_loadingscreen/fxmanifest.lua](#fsn_loadingscreen-fxmanifestlua) (Shared)
  - [fsn_loadingscreen/index.html](#fsn_loadingscreen-indexhtml) (NUI)
- [fsn_main](#fsn_main)
  - [fsn_main/agents.md](#fsn_main-agentsmd) (Shared)
  - [fsn_main/banmanager/sv_bans.lua](#fsn_main-banmanager-sv_banslua) (Shared)
  - [fsn_main/cl_utils.lua](#fsn_main-cl_utilslua) (Shared)
  - [fsn_main/debug/cl_subframetime.js](#fsn_main-debug-cl_subframetimejs) (NUI)
  - [fsn_main/debug/sh_debug.lua](#fsn_main-debug-sh_debuglua) (Shared)
  - [fsn_main/debug/sh_scheduler.lua](#fsn_main-debug-sh_schedulerlua) (Shared)
  - [fsn_main/fxmanifest.lua](#fsn_main-fxmanifestlua) (Shared)
  - [fsn_main/gui/index.html](#fsn_main-gui-indexhtml) (NUI)
  - [fsn_main/gui/index.js](#fsn_main-gui-indexjs) (NUI)
  - [fsn_main/gui/logo_new.png](#fsn_main-gui-logo_newpng) (NUI)
  - [fsn_main/gui/logo_old.png](#fsn_main-gui-logo_oldpng) (NUI)
  - [fsn_main/gui/logos/discord.png](#fsn_main-gui-logos-discordpng) (NUI)
  - [fsn_main/gui/logos/discord.psd](#fsn_main-gui-logos-discordpsd) (Shared)
  - [fsn_main/gui/logos/logo.png](#fsn_main-gui-logos-logopng) (NUI)
  - [fsn_main/gui/logos/main.psd](#fsn_main-gui-logos-mainpsd) (Shared)
  - [fsn_main/gui/motd.txt](#fsn_main-gui-motdtxt) (Shared)
  - [fsn_main/gui/pdown.ttf](#fsn_main-gui-pdownttf) (Shared)
  - [fsn_main/hud/client.lua](#fsn_main-hud-clientlua) (Client)
  - [fsn_main/initial/client.lua](#fsn_main-initial-clientlua) (Client)
  - [fsn_main/initial/desc.txt](#fsn_main-initial-desctxt) (Shared)
  - [fsn_main/initial/server.lua](#fsn_main-initial-serverlua) (Server)
  - [fsn_main/misc/db.lua](#fsn_main-misc-dblua) (Shared)
  - [fsn_main/misc/logging.lua](#fsn_main-misc-logginglua) (Shared)
  - [fsn_main/misc/servername.lua](#fsn_main-misc-servernamelua) (Server)
  - [fsn_main/misc/shitlordjumping.lua](#fsn_main-misc-shitlordjumpinglua) (Shared)
  - [fsn_main/misc/timer.lua](#fsn_main-misc-timerlua) (Shared)
  - [fsn_main/misc/version.lua](#fsn_main-misc-versionlua) (Shared)
  - [fsn_main/money/client.lua](#fsn_main-money-clientlua) (Client)
  - [fsn_main/money/server.lua](#fsn_main-money-serverlua) (Server)
  - [fsn_main/playermanager/client.lua](#fsn_main-playermanager-clientlua) (Client)
  - [fsn_main/playermanager/server.lua](#fsn_main-playermanager-serverlua) (Server)
  - [fsn_main/server_settings/sh_settings.lua](#fsn_main-server_settings-sh_settingslua) (Shared)
  - [fsn_main/sv_utils.lua](#fsn_main-sv_utilslua) (Shared)
- [fsn_menu](#fsn_menu)
  - [fsn_menu/agents.md](#fsn_menu-agentsmd) (Shared)
  - [fsn_menu/fxmanifest.lua](#fsn_menu-fxmanifestlua) (Shared)
  - [fsn_menu/gui/ui.css](#fsn_menu-gui-uicss) (NUI)
  - [fsn_menu/gui/ui.html](#fsn_menu-gui-uihtml) (NUI)
  - [fsn_menu/gui/ui.js](#fsn_menu-gui-uijs) (NUI)
  - [fsn_menu/main_client.lua](#fsn_menu-main_clientlua) (Client)
  - [fsn_menu/ui.css](#fsn_menu-uicss) (NUI)
  - [fsn_menu/ui.html](#fsn_menu-uihtml) (NUI)
  - [fsn_menu/ui.js](#fsn_menu-uijs) (NUI)
- [fsn_needs](#fsn_needs)
  - [fsn_needs/agents.md](#fsn_needs-agentsmd) (Shared)
  - [fsn_needs/client.lua](#fsn_needs-clientlua) (Client)
  - [fsn_needs/fxmanifest.lua](#fsn_needs-fxmanifestlua) (Shared)
  - [fsn_needs/hud.lua](#fsn_needs-hudlua) (Shared)
  - [fsn_needs/vending.lua](#fsn_needs-vendinglua) (Shared)
- [fsn_newchat](#fsn_newchat)
  - [fsn_newchat/README.md](#fsn_newchat-READMEmd) (Shared)
  - [fsn_newchat/agents.md](#fsn_newchat-agentsmd) (Shared)
  - [fsn_newchat/cl_chat.lua](#fsn_newchat-cl_chatlua) (Shared)
  - [fsn_newchat/fxmanifest.lua](#fsn_newchat-fxmanifestlua) (Shared)
  - [fsn_newchat/html/App.js](#fsn_newchat-html-Appjs) (NUI)
  - [fsn_newchat/html/Message.js](#fsn_newchat-html-Messagejs) (NUI)
  - [fsn_newchat/html/Suggestions.js](#fsn_newchat-html-Suggestionsjs) (NUI)
  - [fsn_newchat/html/config.default.js](#fsn_newchat-html-configdefaultjs) (NUI)
  - [fsn_newchat/html/index.css](#fsn_newchat-html-indexcss) (NUI)
  - [fsn_newchat/html/index.html](#fsn_newchat-html-indexhtml) (NUI)
  - [fsn_newchat/html/vendor/animate.3.5.2.min.css](#fsn_newchat-html-vendor-animate352mincss) (NUI)
  - [fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css](#fsn_newchat-html-vendor-flexboxgrid631mincss) (NUI)
  - [fsn_newchat/html/vendor/fonts/LatoBold.woff2](#fsn_newchat-html-vendor-fonts-LatoBoldwoff2) (Shared)
  - [fsn_newchat/html/vendor/fonts/LatoBold2.woff2](#fsn_newchat-html-vendor-fonts-LatoBold2woff2) (Shared)
  - [fsn_newchat/html/vendor/fonts/LatoLight.woff2](#fsn_newchat-html-vendor-fonts-LatoLightwoff2) (Shared)
  - [fsn_newchat/html/vendor/fonts/LatoLight2.woff2](#fsn_newchat-html-vendor-fonts-LatoLight2woff2) (Shared)
  - [fsn_newchat/html/vendor/fonts/LatoRegular.woff2](#fsn_newchat-html-vendor-fonts-LatoRegularwoff2) (Shared)
  - [fsn_newchat/html/vendor/fonts/LatoRegular2.woff2](#fsn_newchat-html-vendor-fonts-LatoRegular2woff2) (Shared)
  - [fsn_newchat/html/vendor/latofonts.css](#fsn_newchat-html-vendor-latofontscss) (NUI)
  - [fsn_newchat/html/vendor/vue.2.3.3.min.js](#fsn_newchat-html-vendor-vue233minjs) (NUI)
  - [fsn_newchat/sv_chat.lua](#fsn_newchat-sv_chatlua) (Shared)
- [fsn_notify](#fsn_notify)
  - [fsn_notify/agents.md](#fsn_notify-agentsmd) (Shared)
  - [fsn_notify/cl_notify.lua](#fsn_notify-cl_notifylua) (Shared)
  - [fsn_notify/fxmanifest.lua](#fsn_notify-fxmanifestlua) (Shared)
  - [fsn_notify/html/index.html](#fsn_notify-html-indexhtml) (NUI)
  - [fsn_notify/html/noty.css](#fsn_notify-html-notycss) (NUI)
  - [fsn_notify/html/noty.js](#fsn_notify-html-notyjs) (NUI)
  - [fsn_notify/html/noty_license.txt](#fsn_notify-html-noty_licensetxt) (Shared)
  - [fsn_notify/html/pNotify.js](#fsn_notify-html-pNotifyjs) (NUI)
  - [fsn_notify/html/themes.css](#fsn_notify-html-themescss) (NUI)
  - [fsn_notify/server.lua](#fsn_notify-serverlua) (Server)
- [fsn_phones](#fsn_phones)
  - [fsn_phones/agents.md](#fsn_phones-agentsmd) (Shared)
  - [fsn_phones/cl_phone.lua](#fsn_phones-cl_phonelua) (Shared)
  - [fsn_phones/darkweb/cl_order.lua](#fsn_phones-darkweb-cl_orderlua) (Shared)
  - [fsn_phones/datastore/contacts/sample.txt](#fsn_phones-datastore-contacts-sampletxt) (Shared)
  - [fsn_phones/datastore/messages/sample.txt](#fsn_phones-datastore-messages-sampletxt) (Shared)
  - [fsn_phones/fxmanifest.lua](#fsn_phones-fxmanifestlua) (Shared)
  - [fsn_phones/html/img/Apple/Ads.png](#fsn_phones-html-img-Apple-Adspng) (NUI)
  - [fsn_phones/html/img/Apple/Banner/Adverts.png](#fsn_phones-html-img-Apple-Banner-Advertspng) (NUI)
  - [fsn_phones/html/img/Apple/Banner/Grey.png](#fsn_phones-html-img-Apple-Banner-Greypng) (NUI)
  - [fsn_phones/html/img/Apple/Banner/Yellow.png](#fsn_phones-html-img-Apple-Banner-Yellowpng) (NUI)
  - [fsn_phones/html/img/Apple/Banner/fleeca.png](#fsn_phones-html-img-Apple-Banner-fleecapng) (NUI)
  - [fsn_phones/html/img/Apple/Banner/log-inBackground.png](#fsn_phones-html-img-Apple-Banner-log-inBackgroundpng) (NUI)
  - [fsn_phones/html/img/Apple/Contact.png](#fsn_phones-html-img-Apple-Contactpng) (NUI)
  - [fsn_phones/html/img/Apple/Fleeca.png](#fsn_phones-html-img-Apple-Fleecapng) (NUI)
  - [fsn_phones/html/img/Apple/Frame.png](#fsn_phones-html-img-Apple-Framepng) (NUI)
  - [fsn_phones/html/img/Apple/Garage.png](#fsn_phones-html-img-Apple-Garagepng) (NUI)
  - [fsn_phones/html/img/Apple/Lock icon.png](#fsn_phones-html-img-Apple-Lock iconpng) (NUI)
  - [fsn_phones/html/img/Apple/Mail.png](#fsn_phones-html-img-Apple-Mailpng) (NUI)
  - [fsn_phones/html/img/Apple/Messages.png](#fsn_phones-html-img-Apple-Messagespng) (NUI)
  - [fsn_phones/html/img/Apple/Noti.png](#fsn_phones-html-img-Apple-Notipng) (NUI)
  - [fsn_phones/html/img/Apple/Phone.png](#fsn_phones-html-img-Apple-Phonepng) (NUI)
  - [fsn_phones/html/img/Apple/Twitter.png](#fsn_phones-html-img-Apple-Twitterpng) (NUI)
  - [fsn_phones/html/img/Apple/Wallet.png](#fsn_phones-html-img-Apple-Walletpng) (NUI)
  - [fsn_phones/html/img/Apple/Whitelist.png](#fsn_phones-html-img-Apple-Whitelistpng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/adverts.png](#fsn_phones-html-img-Apple-banner_icons-advertspng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/call.png](#fsn_phones-html-img-Apple-banner_icons-callpng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/contacts.png](#fsn_phones-html-img-Apple-banner_icons-contactspng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/fleeca.png](#fsn_phones-html-img-Apple-banner_icons-fleecapng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/garage.png](#fsn_phones-html-img-Apple-banner_icons-garagepng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/mail.png](#fsn_phones-html-img-Apple-banner_icons-mailpng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/messages.png](#fsn_phones-html-img-Apple-banner_icons-messagespng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/twitter.png](#fsn_phones-html-img-Apple-banner_icons-twitterpng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/wallet.png](#fsn_phones-html-img-Apple-banner_icons-walletpng) (NUI)
  - [fsn_phones/html/img/Apple/banner_icons/wl.png](#fsn_phones-html-img-Apple-banner_icons-wlpng) (NUI)
  - [fsn_phones/html/img/Apple/battery.png](#fsn_phones-html-img-Apple-batterypng) (NUI)
  - [fsn_phones/html/img/Apple/call-in.png](#fsn_phones-html-img-Apple-call-inpng) (NUI)
  - [fsn_phones/html/img/Apple/call-out.png](#fsn_phones-html-img-Apple-call-outpng) (NUI)
  - [fsn_phones/html/img/Apple/darkweb.png](#fsn_phones-html-img-Apple-darkwebpng) (NUI)
  - [fsn_phones/html/img/Apple/default-avatar.png](#fsn_phones-html-img-Apple-default-avatarpng) (NUI)
  - [fsn_phones/html/img/Apple/feedgrey.png](#fsn_phones-html-img-Apple-feedgreypng) (NUI)
  - [fsn_phones/html/img/Apple/fleeca-bg.png](#fsn_phones-html-img-Apple-fleeca-bgpng) (NUI)
  - [fsn_phones/html/img/Apple/missed-in.png](#fsn_phones-html-img-Apple-missed-inpng) (NUI)
  - [fsn_phones/html/img/Apple/missed-out.png](#fsn_phones-html-img-Apple-missed-outpng) (NUI)
  - [fsn_phones/html/img/Apple/node_other_server__1247323.png](#fsn_phones-html-img-Apple-node_other_server__1247323png) (NUI)
  - [fsn_phones/html/img/Apple/signal.png](#fsn_phones-html-img-Apple-signalpng) (NUI)
  - [fsn_phones/html/img/Apple/wallpaper.png](#fsn_phones-html-img-Apple-wallpaperpng) (NUI)
  - [fsn_phones/html/img/Apple/wifi.png](#fsn_phones-html-img-Apple-wifipng) (NUI)
  - [fsn_phones/html/img/cursor.png](#fsn_phones-html-img-cursorpng) (NUI)
  - [fsn_phones/html/index.css](#fsn_phones-html-indexcss) (NUI)
  - [fsn_phones/html/index.html](#fsn_phones-html-indexhtml) (NUI)
  - [fsn_phones/html/index.html.old](#fsn_phones-html-indexhtmlold) (Shared)
  - [fsn_phones/html/index.js](#fsn_phones-html-indexjs) (NUI)
  - [fsn_phones/html/pages_css/iphone/adverts.css](#fsn_phones-html-pages_css-iphone-advertscss) (NUI)
  - [fsn_phones/html/pages_css/iphone/call.css](#fsn_phones-html-pages_css-iphone-callcss) (NUI)
  - [fsn_phones/html/pages_css/iphone/contacts.css](#fsn_phones-html-pages_css-iphone-contactscss) (NUI)
  - [fsn_phones/html/pages_css/iphone/darkweb.css](#fsn_phones-html-pages_css-iphone-darkwebcss) (NUI)
  - [fsn_phones/html/pages_css/iphone/email.css](#fsn_phones-html-pages_css-iphone-emailcss) (NUI)
  - [fsn_phones/html/pages_css/iphone/fleeca.css](#fsn_phones-html-pages_css-iphone-fleecacss) (NUI)
  - [fsn_phones/html/pages_css/iphone/garage.css](#fsn_phones-html-pages_css-iphone-garagecss) (NUI)
  - [fsn_phones/html/pages_css/iphone/home.css](#fsn_phones-html-pages_css-iphone-homecss) (NUI)
  - [fsn_phones/html/pages_css/iphone/main.css](#fsn_phones-html-pages_css-iphone-maincss) (NUI)
  - [fsn_phones/html/pages_css/iphone/messages.css](#fsn_phones-html-pages_css-iphone-messagescss) (NUI)
  - [fsn_phones/html/pages_css/iphone/pay.css](#fsn_phones-html-pages_css-iphone-paycss) (NUI)
  - [fsn_phones/html/pages_css/iphone/phone.css](#fsn_phones-html-pages_css-iphone-phonecss) (NUI)
  - [fsn_phones/html/pages_css/iphone/twitter.css](#fsn_phones-html-pages_css-iphone-twittercss) (NUI)
  - [fsn_phones/html/pages_css/iphone/whitelists.css](#fsn_phones-html-pages_css-iphone-whitelistscss) (NUI)
  - [fsn_phones/html/pages_css/samsung/adverts.css](#fsn_phones-html-pages_css-samsung-advertscss) (NUI)
  - [fsn_phones/html/pages_css/samsung/call.css](#fsn_phones-html-pages_css-samsung-callcss) (NUI)
  - [fsn_phones/html/pages_css/samsung/contacts.css](#fsn_phones-html-pages_css-samsung-contactscss) (NUI)
  - [fsn_phones/html/pages_css/samsung/email.css](#fsn_phones-html-pages_css-samsung-emailcss) (NUI)
  - [fsn_phones/html/pages_css/samsung/fleeca.css](#fsn_phones-html-pages_css-samsung-fleecacss) (NUI)
  - [fsn_phones/html/pages_css/samsung/home.css](#fsn_phones-html-pages_css-samsung-homecss) (NUI)
  - [fsn_phones/html/pages_css/samsung/main.css](#fsn_phones-html-pages_css-samsung-maincss) (NUI)
  - [fsn_phones/html/pages_css/samsung/messages.css](#fsn_phones-html-pages_css-samsung-messagescss) (NUI)
  - [fsn_phones/html/pages_css/samsung/pay.css](#fsn_phones-html-pages_css-samsung-paycss) (NUI)
  - [fsn_phones/html/pages_css/samsung/phone.css](#fsn_phones-html-pages_css-samsung-phonecss) (NUI)
  - [fsn_phones/html/pages_css/samsung/twitter.css](#fsn_phones-html-pages_css-samsung-twittercss) (NUI)
  - [fsn_phones/html/pages_css/samsung/whitelists.css](#fsn_phones-html-pages_css-samsung-whitelistscss) (NUI)
  - [fsn_phones/sv_phone.lua](#fsn_phones-sv_phonelua) (Shared)
- [fsn_playerlist](#fsn_playerlist)
  - [fsn_playerlist/agents.md](#fsn_playerlist-agentsmd) (Shared)
  - [fsn_playerlist/client.lua](#fsn_playerlist-clientlua) (Client)
  - [fsn_playerlist/fxmanifest.lua](#fsn_playerlist-fxmanifestlua) (Shared)
  - [fsn_playerlist/gui/index.html](#fsn_playerlist-gui-indexhtml) (NUI)
  - [fsn_playerlist/gui/index.js](#fsn_playerlist-gui-indexjs) (NUI)
- [fsn_police](#fsn_police)
  - [fsn_police/K9/client.lua](#fsn_police-K9-clientlua) (Client)
  - [fsn_police/K9/server.lua](#fsn_police-K9-serverlua) (Server)
  - [fsn_police/MDT/gui/images/background.png](#fsn_police-MDT-gui-images-backgroundpng) (NUI)
  - [fsn_police/MDT/gui/images/base_pc.png](#fsn_police-MDT-gui-images-base_pcpng) (NUI)
  - [fsn_police/MDT/gui/images/icons/booking.png](#fsn_police-MDT-gui-images-icons-bookingpng) (NUI)
  - [fsn_police/MDT/gui/images/icons/cpic.png](#fsn_police-MDT-gui-images-icons-cpicpng) (NUI)
  - [fsn_police/MDT/gui/images/icons/dmv.png](#fsn_police-MDT-gui-images-icons-dmvpng) (NUI)
  - [fsn_police/MDT/gui/images/icons/warrants.png](#fsn_police-MDT-gui-images-icons-warrantspng) (NUI)
  - [fsn_police/MDT/gui/images/pwr_icon.png](#fsn_police-MDT-gui-images-pwr_iconpng) (NUI)
  - [fsn_police/MDT/gui/images/win_icon.png](#fsn_police-MDT-gui-images-win_iconpng) (NUI)
  - [fsn_police/MDT/gui/index.css](#fsn_police-MDT-gui-indexcss) (NUI)
  - [fsn_police/MDT/gui/index.html](#fsn_police-MDT-gui-indexhtml) (NUI)
  - [fsn_police/MDT/gui/index.js](#fsn_police-MDT-gui-indexjs) (NUI)
  - [fsn_police/MDT/mdt_client.lua](#fsn_police-MDT-mdt_clientlua) (Client)
  - [fsn_police/MDT/mdt_server.lua](#fsn_police-MDT-mdt_serverlua) (Server)
  - [fsn_police/agents.md](#fsn_police-agentsmd) (Shared)
  - [fsn_police/armory/cl_armory.lua](#fsn_police-armory-cl_armorylua) (Shared)
  - [fsn_police/armory/sv_armory.lua](#fsn_police-armory-sv_armorylua) (Shared)
  - [fsn_police/client.lua](#fsn_police-clientlua) (Client)
  - [fsn_police/dispatch.lua](#fsn_police-dispatchlua) (Shared)
  - [fsn_police/dispatch/client.lua](#fsn_police-dispatch-clientlua) (Client)
  - [fsn_police/fxmanifest.lua](#fsn_police-fxmanifestlua) (Shared)
  - [fsn_police/pedmanagement/client.lua](#fsn_police-pedmanagement-clientlua) (Client)
  - [fsn_police/pedmanagement/server.lua](#fsn_police-pedmanagement-serverlua) (Server)
  - [fsn_police/radar/client.lua](#fsn_police-radar-clientlua) (Client)
  - [fsn_police/server.lua](#fsn_police-serverlua) (Server)
  - [fsn_police/tackle/client.lua](#fsn_police-tackle-clientlua) (Client)
  - [fsn_police/tackle/server.lua](#fsn_police-tackle-serverlua) (Server)
- [fsn_priority](#fsn_priority)
  - [fsn_priority/administration.lua](#fsn_priority-administrationlua) (Shared)
  - [fsn_priority/agents.md](#fsn_priority-agentsmd) (Shared)
  - [fsn_priority/fxmanifest.lua](#fsn_priority-fxmanifestlua) (Shared)
  - [fsn_priority/server.lua](#fsn_priority-serverlua) (Server)
- [fsn_progress](#fsn_progress)
  - [fsn_progress/agents.md](#fsn_progress-agentsmd) (Shared)
  - [fsn_progress/client.lua](#fsn_progress-clientlua) (Client)
  - [fsn_progress/fxmanifest.lua](#fsn_progress-fxmanifestlua) (Shared)
  - [fsn_progress/gui/index.html](#fsn_progress-gui-indexhtml) (NUI)
  - [fsn_progress/gui/index.js](#fsn_progress-gui-indexjs) (NUI)
- [fsn_properties](#fsn_properties)
  - [fsn_properties/agents.md](#fsn_properties-agentsmd) (Shared)
  - [fsn_properties/cl_manage.lua](#fsn_properties-cl_managelua) (Shared)
  - [fsn_properties/cl_properties.lua](#fsn_properties-cl_propertieslua) (Shared)
  - [fsn_properties/fxmanifest.lua](#fsn_properties-fxmanifestlua) (Shared)
  - [fsn_properties/nui/ui.css](#fsn_properties-nui-uicss) (NUI)
  - [fsn_properties/nui/ui.html](#fsn_properties-nui-uihtml) (NUI)
  - [fsn_properties/nui/ui.js](#fsn_properties-nui-uijs) (NUI)
  - [fsn_properties/sv_conversion.lua](#fsn_properties-sv_conversionlua) (Shared)
  - [fsn_properties/sv_properties.lua](#fsn_properties-sv_propertieslua) (Shared)
- [fsn_shootingrange](#fsn_shootingrange)
  - [fsn_shootingrange/agents.md](#fsn_shootingrange-agentsmd) (Shared)
  - [fsn_shootingrange/client.lua](#fsn_shootingrange-clientlua) (Client)
  - [fsn_shootingrange/fxmanifest.lua](#fsn_shootingrange-fxmanifestlua) (Shared)
  - [fsn_shootingrange/server.lua](#fsn_shootingrange-serverlua) (Server)
- [fsn_spawnmanager](#fsn_spawnmanager)
  - [fsn_spawnmanager/agents.md](#fsn_spawnmanager-agentsmd) (Shared)
  - [fsn_spawnmanager/client.lua](#fsn_spawnmanager-clientlua) (Client)
  - [fsn_spawnmanager/fxmanifest.lua](#fsn_spawnmanager-fxmanifestlua) (Shared)
  - [fsn_spawnmanager/nui/index.css](#fsn_spawnmanager-nui-indexcss) (NUI)
  - [fsn_spawnmanager/nui/index.html](#fsn_spawnmanager-nui-indexhtml) (NUI)
  - [fsn_spawnmanager/nui/index.js](#fsn_spawnmanager-nui-indexjs) (NUI)
- [fsn_steamlogin](#fsn_steamlogin)
  - [fsn_steamlogin/agents.md](#fsn_steamlogin-agentsmd) (Shared)
  - [fsn_steamlogin/client.lua](#fsn_steamlogin-clientlua) (Client)
  - [fsn_steamlogin/fxmanifest.lua](#fsn_steamlogin-fxmanifestlua) (Shared)
- [fsn_storagelockers](#fsn_storagelockers)
  - [fsn_storagelockers/agents.md](#fsn_storagelockers-agentsmd) (Shared)
  - [fsn_storagelockers/client.lua](#fsn_storagelockers-clientlua) (Client)
  - [fsn_storagelockers/fxmanifest.lua](#fsn_storagelockers-fxmanifestlua) (Shared)
  - [fsn_storagelockers/nui/ui.css](#fsn_storagelockers-nui-uicss) (NUI)
  - [fsn_storagelockers/nui/ui.html](#fsn_storagelockers-nui-uihtml) (NUI)
  - [fsn_storagelockers/nui/ui.js](#fsn_storagelockers-nui-uijs) (NUI)
  - [fsn_storagelockers/server.lua](#fsn_storagelockers-serverlua) (Server)
- [fsn_store](#fsn_store)
  - [fsn_store/agents.md](#fsn_store-agentsmd) (Shared)
  - [fsn_store/client.lua](#fsn_store-clientlua) (Client)
  - [fsn_store/fxmanifest.lua](#fsn_store-fxmanifestlua) (Shared)
  - [fsn_store/server.lua](#fsn_store-serverlua) (Server)
- [fsn_store_guns](#fsn_store_guns)
  - [fsn_store_guns/agents.md](#fsn_store_guns-agentsmd) (Shared)
  - [fsn_store_guns/client.lua](#fsn_store_guns-clientlua) (Client)
  - [fsn_store_guns/fxmanifest.lua](#fsn_store_guns-fxmanifestlua) (Shared)
  - [fsn_store_guns/server.lua](#fsn_store_guns-serverlua) (Server)
- [fsn_stripclub](#fsn_stripclub)
  - [fsn_stripclub/agents.md](#fsn_stripclub-agentsmd) (Shared)
  - [fsn_stripclub/client.lua](#fsn_stripclub-clientlua) (Client)
  - [fsn_stripclub/fxmanifest.lua](#fsn_stripclub-fxmanifestlua) (Shared)
  - [fsn_stripclub/server.lua](#fsn_stripclub-serverlua) (Server)
- [fsn_teleporters](#fsn_teleporters)
  - [fsn_teleporters/agents.md](#fsn_teleporters-agentsmd) (Shared)
  - [fsn_teleporters/client.lua](#fsn_teleporters-clientlua) (Client)
  - [fsn_teleporters/fxmanifest.lua](#fsn_teleporters-fxmanifestlua) (Shared)
- [fsn_timeandweather](#fsn_timeandweather)
  - [fsn_timeandweather/agents.md](#fsn_timeandweather-agentsmd) (Shared)
  - [fsn_timeandweather/client.lua](#fsn_timeandweather-clientlua) (Client)
  - [fsn_timeandweather/fxmanifest.lua](#fsn_timeandweather-fxmanifestlua) (Shared)
  - [fsn_timeandweather/server.lua](#fsn_timeandweather-serverlua) (Server)
  - [fsn_timeandweather/timecycle_mods_4.xml](#fsn_timeandweather-timecycle_mods_4xml) (Shared)
  - [fsn_timeandweather/w_blizzard.xml](#fsn_timeandweather-w_blizzardxml) (Shared)
  - [fsn_timeandweather/w_clear.xml](#fsn_timeandweather-w_clearxml) (Shared)
  - [fsn_timeandweather/w_clearing.xml](#fsn_timeandweather-w_clearingxml) (Shared)
  - [fsn_timeandweather/w_clouds.xml](#fsn_timeandweather-w_cloudsxml) (Shared)
  - [fsn_timeandweather/w_extrasunny.xml](#fsn_timeandweather-w_extrasunnyxml) (Shared)
  - [fsn_timeandweather/w_foggy.xml](#fsn_timeandweather-w_foggyxml) (Shared)
  - [fsn_timeandweather/w_neutral.xml](#fsn_timeandweather-w_neutralxml) (Shared)
  - [fsn_timeandweather/w_overcast.xml](#fsn_timeandweather-w_overcastxml) (Shared)
  - [fsn_timeandweather/w_rain.xml](#fsn_timeandweather-w_rainxml) (Shared)
  - [fsn_timeandweather/w_smog.xml](#fsn_timeandweather-w_smogxml) (Shared)
  - [fsn_timeandweather/w_snow.xml](#fsn_timeandweather-w_snowxml) (Shared)
  - [fsn_timeandweather/w_snowlight.xml](#fsn_timeandweather-w_snowlightxml) (Shared)
  - [fsn_timeandweather/w_thunder.xml](#fsn_timeandweather-w_thunderxml) (Shared)
  - [fsn_timeandweather/w_xmas.xml](#fsn_timeandweather-w_xmasxml) (Shared)
- [fsn_vehiclecontrol](#fsn_vehiclecontrol)
  - [fsn_vehiclecontrol/agents.md](#fsn_vehiclecontrol-agentsmd) (Shared)
  - [fsn_vehiclecontrol/aircontrol/aircontrol.lua](#fsn_vehiclecontrol-aircontrol-aircontrollua) (Shared)
  - [fsn_vehiclecontrol/carhud/carhud.lua](#fsn_vehiclecontrol-carhud-carhudlua) (Shared)
  - [fsn_vehiclecontrol/carwash/client.lua](#fsn_vehiclecontrol-carwash-clientlua) (Client)
  - [fsn_vehiclecontrol/client.lua](#fsn_vehiclecontrol-clientlua) (Client)
  - [fsn_vehiclecontrol/compass/compass.lua](#fsn_vehiclecontrol-compass-compasslua) (Shared)
  - [fsn_vehiclecontrol/compass/essentials.lua](#fsn_vehiclecontrol-compass-essentialslua) (Shared)
  - [fsn_vehiclecontrol/compass/streetname.lua](#fsn_vehiclecontrol-compass-streetnamelua) (Shared)
  - [fsn_vehiclecontrol/damage/cl_crashes.lua](#fsn_vehiclecontrol-damage-cl_crasheslua) (Shared)
  - [fsn_vehiclecontrol/damage/client.lua](#fsn_vehiclecontrol-damage-clientlua) (Client)
  - [fsn_vehiclecontrol/damage/config.lua](#fsn_vehiclecontrol-damage-configlua) (Shared)
  - [fsn_vehiclecontrol/engine/client.lua](#fsn_vehiclecontrol-engine-clientlua) (Client)
  - [fsn_vehiclecontrol/fuel/client.lua](#fsn_vehiclecontrol-fuel-clientlua) (Client)
  - [fsn_vehiclecontrol/fuel/server.lua](#fsn_vehiclecontrol-fuel-serverlua) (Server)
  - [fsn_vehiclecontrol/fxmanifest.lua](#fsn_vehiclecontrol-fxmanifestlua) (Shared)
  - [fsn_vehiclecontrol/holdup/client.lua](#fsn_vehiclecontrol-holdup-clientlua) (Client)
  - [fsn_vehiclecontrol/inventory/client.lua](#fsn_vehiclecontrol-inventory-clientlua) (Client)
  - [fsn_vehiclecontrol/inventory/server.lua](#fsn_vehiclecontrol-inventory-serverlua) (Server)
  - [fsn_vehiclecontrol/keys/server.lua](#fsn_vehiclecontrol-keys-serverlua) (Server)
  - [fsn_vehiclecontrol/odometer/client.lua](#fsn_vehiclecontrol-odometer-clientlua) (Client)
  - [fsn_vehiclecontrol/odometer/server.lua](#fsn_vehiclecontrol-odometer-serverlua) (Server)
  - [fsn_vehiclecontrol/speedcameras/client.lua](#fsn_vehiclecontrol-speedcameras-clientlua) (Client)
  - [fsn_vehiclecontrol/trunk/client.lua](#fsn_vehiclecontrol-trunk-clientlua) (Client)
  - [fsn_vehiclecontrol/trunk/server.lua](#fsn_vehiclecontrol-trunk-serverlua) (Server)
- [fsn_voicecontrol](#fsn_voicecontrol)
  - [fsn_voicecontrol/agents.md](#fsn_voicecontrol-agentsmd) (Shared)
  - [fsn_voicecontrol/client.lua](#fsn_voicecontrol-clientlua) (Client)
  - [fsn_voicecontrol/fxmanifest.lua](#fsn_voicecontrol-fxmanifestlua) (Shared)
  - [fsn_voicecontrol/server.lua](#fsn_voicecontrol-serverlua) (Server)
- [fsn_weaponcontrol](#fsn_weaponcontrol)
  - [fsn_weaponcontrol/agents.md](#fsn_weaponcontrol-agentsmd) (Shared)
  - [fsn_weaponcontrol/client.lua](#fsn_weaponcontrol-clientlua) (Client)
  - [fsn_weaponcontrol/fxmanifest.lua](#fsn_weaponcontrol-fxmanifestlua) (Shared)
  - [fsn_weaponcontrol/server.lua](#fsn_weaponcontrol-serverlua) (Server)

## README.md
*Role:* Shared. Generated description based on file name.

## agents.md
*Role:* Shared. Generated description based on file name.

## pipeline.yml
*Role:* Shared. Generated description based on file name.

## fsn_activities
Resource providing game feature.
### fsn_activities/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_activities/fishing/client.lua
*Role:* Client. Generated description based on file name.

### fsn_activities/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_activities/hunting/client.lua
*Role:* Client. Generated description based on file name.

### fsn_activities/yoga/client.lua
*Role:* Client. Generated description based on file name.


## fsn_admin
Resource providing game feature.
### fsn_admin/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_admin/client.lua
*Role:* Client. Generated description based on file name.

### fsn_admin/client/client.lua
*Role:* Client. Generated description based on file name.

### fsn_admin/config.lua
*Role:* Shared. Generated description based on file name.

### fsn_admin/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_admin/oldresource.lua
*Role:* Shared. Generated description based on file name.

### fsn_admin/server.lua
*Role:* Server. Generated description based on file name.

### fsn_admin/server/server.lua
*Role:* Server. Generated description based on file name.

### fsn_admin/server_announce.lua
*Role:* Server. Generated description based on file name.


## fsn_apartments
Resource providing game feature.
### fsn_apartments/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_apartments/cl_instancing.lua
*Role:* Shared. Generated description based on file name.

### fsn_apartments/client.lua
*Role:* Client. Generated description based on file name.

### fsn_apartments/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_apartments/gui/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_apartments/gui/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_apartments/gui/ui.js
*Role:* NUI. Generated description based on file name.

### fsn_apartments/server.lua
*Role:* Server. Generated description based on file name.

### fsn_apartments/sv_instancing.lua
*Role:* Shared. Generated description based on file name.


## fsn_bank
Resource providing game feature.
### fsn_bank/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_bank/client.lua
*Role:* Client. Generated description based on file name.

### fsn_bank/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_bank/gui/atm_button_sound.mp3
*Role:* NUI. Generated description based on file name.

### fsn_bank/gui/atm_logo.png
*Role:* NUI. Generated description based on file name.

### fsn_bank/gui/index.css
*Role:* NUI. Generated description based on file name.

### fsn_bank/gui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_bank/gui/index.js
*Role:* NUI. Generated description based on file name.

### fsn_bank/server.lua
*Role:* Server. Generated description based on file name.


## fsn_bankrobbery
Resource providing game feature.
### fsn_bankrobbery/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_bankrobbery/cl_frontdesks.lua
*Role:* Shared. Generated description based on file name.

### fsn_bankrobbery/cl_safeanim.lua
*Role:* Shared. Generated description based on file name.

### fsn_bankrobbery/client.lua
*Role:* Client. Generated description based on file name.

### fsn_bankrobbery/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_bankrobbery/server.lua
*Role:* Server. Generated description based on file name.

### fsn_bankrobbery/sv_frontdesks.lua
*Role:* Shared. Generated description based on file name.

### fsn_bankrobbery/trucks.lua
*Role:* Shared. Generated description based on file name.


## fsn_bennys
Resource providing game feature.
### fsn_bennys/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_bennys/cl_bennys.lua
*Role:* Shared. Generated description based on file name.

### fsn_bennys/cl_config.lua
*Role:* Shared. Generated description based on file name.

### fsn_bennys/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_bennys/menu.lua
*Role:* Shared. Generated description based on file name.


## fsn_bikerental
Resource providing game feature.
### fsn_bikerental/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_bikerental/client.lua
*Role:* Client. Generated description based on file name.

### fsn_bikerental/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_bikerental/html/cursor.png
*Role:* NUI. Generated description based on file name.

### fsn_bikerental/html/index.html
*Role:* NUI. Generated description based on file name.

### fsn_bikerental/html/script.js
*Role:* NUI. Generated description based on file name.

### fsn_bikerental/html/style.css
*Role:* NUI. Generated description based on file name.


## fsn_boatshop
Resource providing game feature.
### fsn_boatshop/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_boatshop/cl_boatshop.lua
*Role:* Shared. Generated description based on file name.

### fsn_boatshop/cl_menu.lua
*Role:* Shared. Generated description based on file name.

### fsn_boatshop/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_boatshop/sv_boatshop.lua
*Role:* Shared. Generated description based on file name.


## fsn_builders
Resource providing game feature.
### fsn_builders/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_builders/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_builders/handling_builder.lua
*Role:* Shared. Generated description based on file name.

### fsn_builders/schema.lua
*Role:* Shared. Generated description based on file name.

### fsn_builders/schemas/cbikehandlingdata.lua
*Role:* Shared. Generated description based on file name.

### fsn_builders/schemas/ccarhandlingdata.lua
*Role:* Shared. Generated description based on file name.

### fsn_builders/schemas/chandlingdata.lua
*Role:* Shared. Generated description based on file name.

### fsn_builders/xml.lua
*Role:* Shared. Generated description based on file name.


## fsn_cargarage
Resource providing game feature.
### fsn_cargarage/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_cargarage/client.lua
*Role:* Client. Generated description based on file name.

### fsn_cargarage/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_cargarage/gui/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_cargarage/gui/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_cargarage/gui/ui.js
*Role:* NUI. Generated description based on file name.

### fsn_cargarage/server.lua
*Role:* Server. Generated description based on file name.


## fsn_carstore
Resource providing game feature.
### fsn_carstore/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_carstore/cl_carstore.lua
*Role:* Shared. Generated description based on file name.

### fsn_carstore/cl_menu.lua
*Role:* Shared. Generated description based on file name.

### fsn_carstore/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_carstore/gui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_carstore/sv_carstore.lua
*Role:* Shared. Generated description based on file name.

### fsn_carstore/vehshop_server.lua
*Role:* Server. Generated description based on file name.


## fsn_characterdetails
Resource providing game feature.
### fsn_characterdetails/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_characterdetails/facial/client.lua
*Role:* Client. Generated description based on file name.

### fsn_characterdetails/facial/server.lua
*Role:* Server. Generated description based on file name.

### fsn_characterdetails/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_characterdetails/gui/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_characterdetails/gui/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_characterdetails/gui/ui.js
*Role:* NUI. Generated description based on file name.

### fsn_characterdetails/gui_manager.lua
*Role:* Shared. Generated description based on file name.

### fsn_characterdetails/tattoos/client.lua
*Role:* Client. Generated description based on file name.

### fsn_characterdetails/tattoos/config.lua
*Role:* Shared. Generated description based on file name.

### fsn_characterdetails/tattoos/server.lua
*Role:* Server. Generated description based on file name.

### fsn_characterdetails/tattoos/server.zip
*Role:* Shared. Generated description based on file name.


## fsn_clothing
Resource providing game feature.
### fsn_clothing/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_clothing/client.lua
*Role:* Client. Generated description based on file name.

### fsn_clothing/config.lua
*Role:* Shared. Generated description based on file name.

### fsn_clothing/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_clothing/gui.lua
*Role:* Shared. Generated description based on file name.

### fsn_clothing/models.txt
*Role:* Shared. Generated description based on file name.

### fsn_clothing/server.lua
*Role:* Server. Generated description based on file name.


## fsn_commands
Resource providing game feature.
### fsn_commands/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_commands/client.lua
*Role:* Client. Generated description based on file name.

### fsn_commands/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_commands/server.lua
*Role:* Server. Generated description based on file name.


## fsn_crafting
Resource providing game feature.
### fsn_crafting/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_crafting/client.lua
*Role:* Client. Generated description based on file name.

### fsn_crafting/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_crafting/nui/index.css
*Role:* NUI. Generated description based on file name.

### fsn_crafting/nui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_crafting/nui/index.js
*Role:* NUI. Generated description based on file name.

### fsn_crafting/server.lua
*Role:* Server. Generated description based on file name.


## fsn_criminalmisc
Resource providing game feature.
### fsn_criminalmisc/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_criminalmisc/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/drugs/_effects/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/drugs/_streetselling/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/drugs/_streetselling/server.lua
*Role:* Server. Generated description based on file name.

### fsn_criminalmisc/drugs/_weedprocess/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/drugs/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_criminalmisc/handcuffs/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/handcuffs/server.lua
*Role:* Server. Generated description based on file name.

### fsn_criminalmisc/lockpicking/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/pawnstore/cl_pawnstore.lua
*Role:* Shared. Generated description based on file name.

### fsn_criminalmisc/remapping/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/remapping/server.lua
*Role:* Server. Generated description based on file name.

### fsn_criminalmisc/robbing/cl_houses-build.lua
*Role:* Shared. Generated description based on file name.

### fsn_criminalmisc/robbing/cl_houses-config.lua
*Role:* Shared. Generated description based on file name.

### fsn_criminalmisc/robbing/cl_houses.lua
*Role:* Shared. Generated description based on file name.

### fsn_criminalmisc/robbing/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/streetracing/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/streetracing/server.lua
*Role:* Server. Generated description based on file name.

### fsn_criminalmisc/weaponinfo/client.lua
*Role:* Client. Generated description based on file name.

### fsn_criminalmisc/weaponinfo/server.lua
*Role:* Server. Generated description based on file name.

### fsn_criminalmisc/weaponinfo/weapon_list.lua
*Role:* Shared. Generated description based on file name.


## fsn_customanimations
Resource providing game feature.
### fsn_customanimations/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_customanimations/client.lua
*Role:* Client. Generated description based on file name.

### fsn_customanimations/fxmanifest.lua
*Role:* Shared. Generated description based on file name.


## fsn_customs
Resource providing game feature.
### fsn_customs/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_customs/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_customs/lscustoms.lua
*Role:* Shared. Generated description based on file name.


## fsn_dev
Resource providing game feature.
### fsn_dev/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_dev/client/cl_noclip.lua
*Role:* Shared. Generated description based on file name.

### fsn_dev/client/client.lua
*Role:* Client. Generated description based on file name.

### fsn_dev/config.lua
*Role:* Shared. Generated description based on file name.

### fsn_dev/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_dev/oldresource.lua
*Role:* Shared. Generated description based on file name.

### fsn_dev/server/server.lua
*Role:* Server. Generated description based on file name.


## fsn_doj
Resource providing game feature.
### fsn_doj/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_doj/attorneys/client.lua
*Role:* Client. Generated description based on file name.

### fsn_doj/attorneys/server.lua
*Role:* Server. Generated description based on file name.

### fsn_doj/client.lua
*Role:* Client. Generated description based on file name.

### fsn_doj/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_doj/judges/client.lua
*Role:* Client. Generated description based on file name.

### fsn_doj/judges/server.lua
*Role:* Server. Generated description based on file name.


## fsn_doormanager
Resource providing game feature.
### fsn_doormanager/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_doormanager/cl_doors.lua
*Role:* Shared. Generated description based on file name.

### fsn_doormanager/client.lua
*Role:* Client. Generated description based on file name.

### fsn_doormanager/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_doormanager/server.lua
*Role:* Server. Generated description based on file name.

### fsn_doormanager/sv_doors.lua
*Role:* Shared. Generated description based on file name.


## fsn_emotecontrol
Resource providing game feature.
### fsn_emotecontrol/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_emotecontrol/client.lua
*Role:* Client. Generated description based on file name.

### fsn_emotecontrol/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_emotecontrol/walktypes/client.lua
*Role:* Client. Generated description based on file name.


## fsn_ems
Resource providing game feature.
### fsn_ems/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_ems/beds/client.lua
*Role:* Client. Generated description based on file name.

### fsn_ems/beds/server.lua
*Role:* Server. Generated description based on file name.

### fsn_ems/blip.lua
*Role:* Shared. Generated description based on file name.

### fsn_ems/cl_advanceddamage.lua
*Role:* Shared. Generated description based on file name.

### fsn_ems/cl_carrydead.lua
*Role:* Shared. Generated description based on file name.

### fsn_ems/cl_volunteering.lua
*Role:* Shared. Generated description based on file name.

### fsn_ems/client.lua
*Role:* Client. Generated description based on file name.

### fsn_ems/debug_kng.lua
*Role:* Shared. Generated description based on file name.

### fsn_ems/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_ems/info.txt
*Role:* Shared. Generated description based on file name.

### fsn_ems/server.lua
*Role:* Server. Generated description based on file name.

### fsn_ems/sv_carrydead.lua
*Role:* Shared. Generated description based on file name.


## fsn_entfinder
Resource providing game feature.
### fsn_entfinder/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_entfinder/client.lua
*Role:* Client. Generated description based on file name.

### fsn_entfinder/fxmanifest.lua
*Role:* Shared. Generated description based on file name.


## fsn_errorcontrol
Resource providing game feature.
### fsn_errorcontrol/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_errorcontrol/client.lua
*Role:* Client. Generated description based on file name.

### fsn_errorcontrol/fxmanifest.lua
*Role:* Shared. Generated description based on file name.


## fsn_evidence
Resource providing game feature.
### fsn_evidence/__descriptions-carpaint.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/__descriptions-female.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/__descriptions-male.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/__descriptions.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_evidence/casings/cl_casings.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/cl_evidence.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/ped/cl_ped.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/ped/sv_ped.lua
*Role:* Shared. Generated description based on file name.

### fsn_evidence/sv_evidence.lua
*Role:* Shared. Generated description based on file name.


## fsn_gangs
Resource providing game feature.
### fsn_gangs/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_gangs/cl_gangs.lua
*Role:* Shared. Generated description based on file name.

### fsn_gangs/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_gangs/sv_gangs.lua
*Role:* Shared. Generated description based on file name.


## fsn_handling
Resource providing game feature.
### fsn_handling/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_handling/data/handling.meta
*Role:* Shared. Generated description based on file name.

### fsn_handling/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/compact.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/coupes.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/government.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/motorcycles.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/muscle.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/offroad.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/schafter.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/sedans.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/sports.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/sportsclassics.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/super.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/suvs.lua
*Role:* Shared. Generated description based on file name.

### fsn_handling/src/vans.lua
*Role:* Shared. Generated description based on file name.


## fsn_inventory
Resource providing game feature.
### fsn_inventory/_item_misc/binoculars.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/_item_misc/burger_store.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/_item_misc/cl_breather.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/_item_misc/dm_laundering.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/_old/_item_misc/_drug_selling.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/_old/client.lua
*Role:* Client. Generated description based on file name.

### fsn_inventory/_old/items.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/_old/pedfinder.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/_old/server.lua
*Role:* Server. Generated description based on file name.

### fsn_inventory/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_inventory/cl_inventory.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/cl_presets.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/cl_uses.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/cl_vehicles.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/html/css/jquery-ui.css
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/css/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/bullet.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/2g_weed.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_ADVANCEDRIFLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_APPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_ASSAULTSHOTGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_ASSAULTSMG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_AUTOSHOTGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_BALL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_BAT.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_BATTLEAXE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_BOTTLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_BULLPUPSHOTGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_CARBINERIFLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_CARBINERIFLE_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_COMBATMG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_COMBATMG_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_COMBATPDW.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_COMBATPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_COMPACTLAUNCHER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_COMPACTRIFLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_CROWBAR.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_DAGGER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_DBSHOTGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_DOUBLEACTION.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_FIREEXTINGUISHER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_FIREWORK.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_FLARE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_FLAREGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_FLASHLIGHT.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_GOLFCLUB.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_GRENADE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_GRENADELAUNCHER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_GUSENBERG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_HAMMER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_HATCHET.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_HEAVYPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_HEAVYSHOTGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_HOMINGLAUNCHER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_KNIFE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_KNUCKLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MACHETE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MACHINEPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MARKSMANPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MICROSMG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MINIGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MINISMG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MOLOTOV.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_MUSKET.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_NIGHTSTICK.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PETROLCAN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PIPEBOMB.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PISTOL50.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PISTOL_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_POOLCUE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PROXMINE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_RAILGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_RAYCARBINE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_RAYMINIGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_RAYPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_REVOLVER.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_REVOLVER_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_RPG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SAWNOFFSHOTGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SMG.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SMG_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SMOKEGRENADE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SNIPERRIFLE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SNOWBALL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SNSPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SNSPISTOL_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE_MK2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_STICKYBOMB.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_STONE_HATCHET.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_STUNGUN.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_SWITCHBLADE.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_VINTAGEPISTOL.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/WEAPON_WRENCH.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/acetone.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_mg.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_mg_large.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_pistol.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_pistol_large.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_rifle.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_rifle_large.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_shotgun.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_shotgun_large.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_smg.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_smg_large.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_sniper.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ammo_sniper_large.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/armor.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/bandage.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/beef_jerky.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/binoculars.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/burger.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/burger_bun.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/cigarette.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/coffee.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/cooked_burger.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/cooked_meat.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/cupcake.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/dirty_money.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/drill.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/ecola.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/empty_canister.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/evidence.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/fries.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/frozen_burger.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/frozen_fries.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/gas_canister.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/id.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/joint.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/keycard.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/lockpick.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/meth_rocks.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/microwave_burrito.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/minced_meat.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/modified_drillbit.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/morphine.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/packaged_cocaine.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/painkillers.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/panini.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/pepsi.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/pepsi_max.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/phone.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/phosphorus.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/radio_receiver.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/repair_kit.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/tuner_chip.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/uncooked_meat.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/vpn1.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/vpn2.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/water.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/img/items/zipties.png
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/js/config.js
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/js/inventory.js
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/locales/cs.js
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/locales/en.js
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/locales/fr.js
*Role:* NUI. Generated description based on file name.

### fsn_inventory/html/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_inventory/pd_locker/cl_locker.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/pd_locker/datastore.txt
*Role:* Shared. Generated description based on file name.

### fsn_inventory/pd_locker/sv_locker.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/sv_inventory.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/sv_presets.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory/sv_vehicles.lua
*Role:* Shared. Generated description based on file name.


## fsn_inventory_dropping
Resource providing game feature.
### fsn_inventory_dropping/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_inventory_dropping/cl_dropping.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory_dropping/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_inventory_dropping/sv_dropping.lua
*Role:* Shared. Generated description based on file name.


## fsn_jail
Resource providing game feature.
### fsn_jail/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_jail/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jail/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_jail/server.lua
*Role:* Server. Generated description based on file name.


## fsn_jewellerystore
Resource providing game feature.
### fsn_jewellerystore/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_jewellerystore/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jewellerystore/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_jewellerystore/server.lua
*Role:* Server. Generated description based on file name.


## fsn_jobs
Resource providing game feature.
### fsn_jobs/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_jobs/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/delivery/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/farming/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_jobs/garbage/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/hunting/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/mechanic/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/mechanic/mechmenu.lua
*Role:* Shared. Generated description based on file name.

### fsn_jobs/mechanic/server.lua
*Role:* Server. Generated description based on file name.

### fsn_jobs/news/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/repo/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/repo/server.lua
*Role:* Server. Generated description based on file name.

### fsn_jobs/scrap/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/server.lua
*Role:* Server. Generated description based on file name.

### fsn_jobs/taxi/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/taxi/server.lua
*Role:* Server. Generated description based on file name.

### fsn_jobs/tow/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/tow/server.lua
*Role:* Server. Generated description based on file name.

### fsn_jobs/trucker/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/whitelists/client.lua
*Role:* Client. Generated description based on file name.

### fsn_jobs/whitelists/server.lua
*Role:* Server. Generated description based on file name.


## fsn_licenses
Resource providing game feature.
### fsn_licenses/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_licenses/cl_desk.lua
*Role:* Shared. Generated description based on file name.

### fsn_licenses/client.lua
*Role:* Client. Generated description based on file name.

### fsn_licenses/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_licenses/server.lua
*Role:* Server. Generated description based on file name.

### fsn_licenses/sv_desk.lua
*Role:* Shared. Generated description based on file name.


## fsn_loadingscreen
Resource providing game feature.
### fsn_loadingscreen/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_loadingscreen/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_loadingscreen/index.html
*Role:* NUI. Generated description based on file name.


## fsn_main
Resource providing game feature.
### fsn_main/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_main/banmanager/sv_bans.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/cl_utils.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/debug/cl_subframetime.js
*Role:* NUI. Generated description based on file name.

### fsn_main/debug/sh_debug.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/debug/sh_scheduler.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/gui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_main/gui/index.js
*Role:* NUI. Generated description based on file name.

### fsn_main/gui/logo_new.png
*Role:* NUI. Generated description based on file name.

### fsn_main/gui/logo_old.png
*Role:* NUI. Generated description based on file name.

### fsn_main/gui/logos/discord.png
*Role:* NUI. Generated description based on file name.

### fsn_main/gui/logos/discord.psd
*Role:* Shared. Generated description based on file name.

### fsn_main/gui/logos/logo.png
*Role:* NUI. Generated description based on file name.

### fsn_main/gui/logos/main.psd
*Role:* Shared. Generated description based on file name.

### fsn_main/gui/motd.txt
*Role:* Shared. Generated description based on file name.

### fsn_main/gui/pdown.ttf
*Role:* Shared. Generated description based on file name.

### fsn_main/hud/client.lua
*Role:* Client. Generated description based on file name.

### fsn_main/initial/client.lua
*Role:* Client. Generated description based on file name.

### fsn_main/initial/desc.txt
*Role:* Shared. Generated description based on file name.

### fsn_main/initial/server.lua
*Role:* Server. Generated description based on file name.

### fsn_main/misc/db.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/misc/logging.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/misc/servername.lua
*Role:* Server. Generated description based on file name.

### fsn_main/misc/shitlordjumping.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/misc/timer.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/misc/version.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/money/client.lua
*Role:* Client. Generated description based on file name.

### fsn_main/money/server.lua
*Role:* Server. Generated description based on file name.

### fsn_main/playermanager/client.lua
*Role:* Client. Generated description based on file name.

### fsn_main/playermanager/server.lua
*Role:* Server. Generated description based on file name.

### fsn_main/server_settings/sh_settings.lua
*Role:* Shared. Generated description based on file name.

### fsn_main/sv_utils.lua
*Role:* Shared. Generated description based on file name.


## fsn_menu
Resource providing game feature.
### fsn_menu/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_menu/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_menu/gui/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_menu/gui/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_menu/gui/ui.js
*Role:* NUI. Generated description based on file name.

### fsn_menu/main_client.lua
*Role:* Client. Generated description based on file name.

### fsn_menu/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_menu/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_menu/ui.js
*Role:* NUI. Generated description based on file name.


## fsn_needs
Resource providing game feature.
### fsn_needs/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_needs/client.lua
*Role:* Client. Generated description based on file name.

### fsn_needs/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_needs/hud.lua
*Role:* Shared. Generated description based on file name.

### fsn_needs/vending.lua
*Role:* Shared. Generated description based on file name.


## fsn_newchat
Resource providing game feature.
### fsn_newchat/README.md
*Role:* Shared. Generated description based on file name.

### fsn_newchat/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_newchat/cl_chat.lua
*Role:* Shared. Generated description based on file name.

### fsn_newchat/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_newchat/html/App.js
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/Message.js
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/Suggestions.js
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/config.default.js
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/index.css
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/index.html
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/vendor/animate.3.5.2.min.css
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/vendor/fonts/LatoBold.woff2
*Role:* Shared. Generated description based on file name.

### fsn_newchat/html/vendor/fonts/LatoBold2.woff2
*Role:* Shared. Generated description based on file name.

### fsn_newchat/html/vendor/fonts/LatoLight.woff2
*Role:* Shared. Generated description based on file name.

### fsn_newchat/html/vendor/fonts/LatoLight2.woff2
*Role:* Shared. Generated description based on file name.

### fsn_newchat/html/vendor/fonts/LatoRegular.woff2
*Role:* Shared. Generated description based on file name.

### fsn_newchat/html/vendor/fonts/LatoRegular2.woff2
*Role:* Shared. Generated description based on file name.

### fsn_newchat/html/vendor/latofonts.css
*Role:* NUI. Generated description based on file name.

### fsn_newchat/html/vendor/vue.2.3.3.min.js
*Role:* NUI. Generated description based on file name.

### fsn_newchat/sv_chat.lua
*Role:* Shared. Generated description based on file name.


## fsn_notify
Resource providing game feature.
### fsn_notify/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_notify/cl_notify.lua
*Role:* Shared. Generated description based on file name.

### fsn_notify/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_notify/html/index.html
*Role:* NUI. Generated description based on file name.

### fsn_notify/html/noty.css
*Role:* NUI. Generated description based on file name.

### fsn_notify/html/noty.js
*Role:* NUI. Generated description based on file name.

### fsn_notify/html/noty_license.txt
*Role:* Shared. Generated description based on file name.

### fsn_notify/html/pNotify.js
*Role:* NUI. Generated description based on file name.

### fsn_notify/html/themes.css
*Role:* NUI. Generated description based on file name.

### fsn_notify/server.lua
*Role:* Server. Generated description based on file name.


## fsn_phones
Resource providing game feature.
### fsn_phones/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_phones/cl_phone.lua
*Role:* Shared. Generated description based on file name.

### fsn_phones/darkweb/cl_order.lua
*Role:* Shared. Generated description based on file name.

### fsn_phones/datastore/contacts/sample.txt
*Role:* Shared. Generated description based on file name.

### fsn_phones/datastore/messages/sample.txt
*Role:* Shared. Generated description based on file name.

### fsn_phones/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_phones/html/img/Apple/Ads.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Banner/Adverts.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Banner/Grey.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Banner/Yellow.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Banner/fleeca.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Banner/log-inBackground.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Contact.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Fleeca.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Frame.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Garage.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Lock icon.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Mail.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Messages.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Noti.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Phone.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Twitter.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Wallet.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/Whitelist.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/adverts.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/call.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/contacts.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/fleeca.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/garage.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/mail.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/messages.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/twitter.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/wallet.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/banner_icons/wl.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/battery.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/call-in.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/call-out.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/darkweb.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/default-avatar.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/feedgrey.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/fleeca-bg.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/missed-in.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/missed-out.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/node_other_server__1247323.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/signal.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/wallpaper.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/Apple/wifi.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/img/cursor.png
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/index.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/index.html
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/index.html.old
*Role:* Shared. Generated description based on file name.

### fsn_phones/html/index.js
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/adverts.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/call.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/contacts.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/darkweb.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/email.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/fleeca.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/garage.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/home.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/main.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/messages.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/pay.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/phone.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/twitter.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/iphone/whitelists.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/adverts.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/call.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/contacts.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/email.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/fleeca.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/home.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/main.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/messages.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/pay.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/phone.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/twitter.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/html/pages_css/samsung/whitelists.css
*Role:* NUI. Generated description based on file name.

### fsn_phones/sv_phone.lua
*Role:* Shared. Generated description based on file name.


## fsn_playerlist
Resource providing game feature.
### fsn_playerlist/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_playerlist/client.lua
*Role:* Client. Generated description based on file name.

### fsn_playerlist/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_playerlist/gui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_playerlist/gui/index.js
*Role:* NUI. Generated description based on file name.


## fsn_police
Resource providing game feature.
### fsn_police/K9/client.lua
*Role:* Client. Generated description based on file name.

### fsn_police/K9/server.lua
*Role:* Server. Generated description based on file name.

### fsn_police/MDT/gui/images/background.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/images/base_pc.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/images/icons/booking.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/images/icons/cpic.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/images/icons/dmv.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/images/icons/warrants.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/images/pwr_icon.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/images/win_icon.png
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/index.css
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/gui/index.js
*Role:* NUI. Generated description based on file name.

### fsn_police/MDT/mdt_client.lua
*Role:* Client. Generated description based on file name.

### fsn_police/MDT/mdt_server.lua
*Role:* Server. Generated description based on file name.

### fsn_police/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_police/armory/cl_armory.lua
*Role:* Shared. Generated description based on file name.

### fsn_police/armory/sv_armory.lua
*Role:* Shared. Generated description based on file name.

### fsn_police/client.lua
*Role:* Client. Generated description based on file name.

### fsn_police/dispatch.lua
*Role:* Shared. Generated description based on file name.

### fsn_police/dispatch/client.lua
*Role:* Client. Generated description based on file name.

### fsn_police/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_police/pedmanagement/client.lua
*Role:* Client. Generated description based on file name.

### fsn_police/pedmanagement/server.lua
*Role:* Server. Generated description based on file name.

### fsn_police/radar/client.lua
*Role:* Client. Generated description based on file name.

### fsn_police/server.lua
*Role:* Server. Generated description based on file name.

### fsn_police/tackle/client.lua
*Role:* Client. Generated description based on file name.

### fsn_police/tackle/server.lua
*Role:* Server. Generated description based on file name.


## fsn_priority
Resource providing game feature.
### fsn_priority/administration.lua
*Role:* Shared. Generated description based on file name.

### fsn_priority/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_priority/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_priority/server.lua
*Role:* Server. Generated description based on file name.


## fsn_progress
Resource providing game feature.
### fsn_progress/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_progress/client.lua
*Role:* Client. Generated description based on file name.

### fsn_progress/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_progress/gui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_progress/gui/index.js
*Role:* NUI. Generated description based on file name.


## fsn_properties
Resource providing game feature.
### fsn_properties/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_properties/cl_manage.lua
*Role:* Shared. Generated description based on file name.

### fsn_properties/cl_properties.lua
*Role:* Shared. Generated description based on file name.

### fsn_properties/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_properties/nui/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_properties/nui/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_properties/nui/ui.js
*Role:* NUI. Generated description based on file name.

### fsn_properties/sv_conversion.lua
*Role:* Shared. Generated description based on file name.

### fsn_properties/sv_properties.lua
*Role:* Shared. Generated description based on file name.


## fsn_shootingrange
Resource providing game feature.
### fsn_shootingrange/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_shootingrange/client.lua
*Role:* Client. Generated description based on file name.

### fsn_shootingrange/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_shootingrange/server.lua
*Role:* Server. Generated description based on file name.


## fsn_spawnmanager
Resource providing game feature.
### fsn_spawnmanager/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_spawnmanager/client.lua
*Role:* Client. Generated description based on file name.

### fsn_spawnmanager/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_spawnmanager/nui/index.css
*Role:* NUI. Generated description based on file name.

### fsn_spawnmanager/nui/index.html
*Role:* NUI. Generated description based on file name.

### fsn_spawnmanager/nui/index.js
*Role:* NUI. Generated description based on file name.


## fsn_steamlogin
Resource providing game feature.
### fsn_steamlogin/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_steamlogin/client.lua
*Role:* Client. Generated description based on file name.

### fsn_steamlogin/fxmanifest.lua
*Role:* Shared. Generated description based on file name.


## fsn_storagelockers
Resource providing game feature.
### fsn_storagelockers/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_storagelockers/client.lua
*Role:* Client. Generated description based on file name.

### fsn_storagelockers/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_storagelockers/nui/ui.css
*Role:* NUI. Generated description based on file name.

### fsn_storagelockers/nui/ui.html
*Role:* NUI. Generated description based on file name.

### fsn_storagelockers/nui/ui.js
*Role:* NUI. Generated description based on file name.

### fsn_storagelockers/server.lua
*Role:* Server. Generated description based on file name.


## fsn_store
Resource providing game feature.
### fsn_store/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_store/client.lua
*Role:* Client. Generated description based on file name.

### fsn_store/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_store/server.lua
*Role:* Server. Generated description based on file name.


## fsn_store_guns
Resource providing game feature.
### fsn_store_guns/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_store_guns/client.lua
*Role:* Client. Generated description based on file name.

### fsn_store_guns/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_store_guns/server.lua
*Role:* Server. Generated description based on file name.


## fsn_stripclub
Resource providing game feature.
### fsn_stripclub/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_stripclub/client.lua
*Role:* Client. Generated description based on file name.

### fsn_stripclub/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_stripclub/server.lua
*Role:* Server. Generated description based on file name.


## fsn_teleporters
Resource providing game feature.
### fsn_teleporters/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_teleporters/client.lua
*Role:* Client. Generated description based on file name.

### fsn_teleporters/fxmanifest.lua
*Role:* Shared. Generated description based on file name.


## fsn_timeandweather
Resource providing game feature.
### fsn_timeandweather/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/client.lua
*Role:* Client. Generated description based on file name.

### fsn_timeandweather/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/server.lua
*Role:* Server. Generated description based on file name.

### fsn_timeandweather/timecycle_mods_4.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_blizzard.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_clear.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_clearing.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_clouds.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_extrasunny.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_foggy.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_neutral.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_overcast.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_rain.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_smog.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_snow.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_snowlight.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_thunder.xml
*Role:* Shared. Generated description based on file name.

### fsn_timeandweather/w_xmas.xml
*Role:* Shared. Generated description based on file name.


## fsn_vehiclecontrol
Resource providing game feature.
### fsn_vehiclecontrol/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/aircontrol/aircontrol.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/carhud/carhud.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/carwash/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/compass/compass.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/compass/essentials.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/compass/streetname.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/damage/cl_crashes.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/damage/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/damage/config.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/engine/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/fuel/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/fuel/server.lua
*Role:* Server. Generated description based on file name.

### fsn_vehiclecontrol/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_vehiclecontrol/holdup/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/inventory/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/inventory/server.lua
*Role:* Server. Generated description based on file name.

### fsn_vehiclecontrol/keys/server.lua
*Role:* Server. Generated description based on file name.

### fsn_vehiclecontrol/odometer/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/odometer/server.lua
*Role:* Server. Generated description based on file name.

### fsn_vehiclecontrol/speedcameras/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/trunk/client.lua
*Role:* Client. Generated description based on file name.

### fsn_vehiclecontrol/trunk/server.lua
*Role:* Server. Generated description based on file name.


## fsn_voicecontrol
Resource providing game feature.
### fsn_voicecontrol/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_voicecontrol/client.lua
*Role:* Client. Generated description based on file name.

### fsn_voicecontrol/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_voicecontrol/server.lua
*Role:* Server. Generated description based on file name.


## fsn_weaponcontrol
Resource providing game feature.
### fsn_weaponcontrol/agents.md
*Role:* Shared. Generated description based on file name.

### fsn_weaponcontrol/client.lua
*Role:* Client. Generated description based on file name.

### fsn_weaponcontrol/fxmanifest.lua
*Role:* Shared. Generated description based on file name.

### fsn_weaponcontrol/server.lua
*Role:* Server. Generated description based on file name.


## Cross-Indexes
### Events
- 321236ce-42a6-43d8-af3d-e0e30c9e66b7
- 394084c7-ac07-424a-982b-ab2267d8d55f
- AnimSet:Alien
- AnimSet:Brave
- AnimSet:Business
- AnimSet:ChiChi
- AnimSet:Hobo
- AnimSet:Hurry
- AnimSet:Injured
- AnimSet:Joy
- AnimSet:ManEater
- AnimSet:Money
- AnimSet:Moon
- AnimSet:NonChalant
- AnimSet:Posh
- AnimSet:Sad
- AnimSet:Sassy
- AnimSet:Sexy
- AnimSet:Shady
- AnimSet:Swagger
- AnimSet:Tipsy
- AnimSet:Tired
- AnimSet:ToughGuy
- AnimSet:default
- Cam:ToggleCam
- EngineToggle:Engine
- EngineToggle:RPDamage
- Mic:ToggleMic
- Tackle:Client:TacklePlayer
- __cfx_internal:serverPrint
- _chat:messageEntered
- binoculars:Activate
- camera:Activate
- chat:addMessage
- chat:addSuggestion
- chat:addSuggestions
- chat:addTemplate
- chat:clear
- chat:removeSuggestion
- chatMessage
- clothes:spawn
- fsn:playerReady
- fsn_admin:FreezeMe
- fsn_admin:enableAdminCommands
- fsn_admin:enableModeratorCommands
- fsn_admin:fix
- fsn_admin:recieveXYZ
- fsn_admin:requestXYZ
- fsn_admin:spawnCar
- fsn_admin:spawnVehicle
- fsn_apartments:characterCreation
- fsn_apartments:instance:debug
- fsn_apartments:instance:join
- fsn_apartments:instance:leave
- fsn_apartments:instance:update
- fsn_apartments:inv:update
- fsn_apartments:outfit:add
- fsn_apartments:outfit:list
- fsn_apartments:outfit:remove
- fsn_apartments:outfit:use
- fsn_apartments:sendApartment
- fsn_apartments:stash:add
- fsn_apartments:stash:take
- fsn_bank:change:bankAdd
- fsn_bank:change:bankMinus
- fsn_bank:change:bankandwallet
- fsn_bank:change:walletAdd
- fsn_bank:change:walletMinus
- fsn_bank:request:both
- fsn_bank:update:both
- fsn_bankrobbery:LostMC:spawn
- fsn_bankrobbery:closeDoor
- fsn_bankrobbery:desks:receive
- fsn_bankrobbery:init
- fsn_bankrobbery:openDoor
- fsn_bankrobbery:timer
- fsn_boatshop:floor:Update
- fsn_boatshop:floor:Updateboat
- fsn_boatshop:floor:color:One
- fsn_boatshop:floor:color:Two
- fsn_boatshop:floor:commission
- fsn_cargarage:checkStatus
- fsn_cargarage:makeMine
- fsn_cargarage:receiveVehicles
- fsn_cargarage:vehicleStatus
- fsn_carstore:floor:Update
- fsn_carstore:floor:UpdateCar
- fsn_carstore:floor:color:One
- fsn_carstore:floor:color:Two
- fsn_carstore:floor:commission
- fsn_characterdetails:recievetattoos
- fsn_clothing:menu
- fsn_commands:airlift
- fsn_commands:clothing:glasses
- fsn_commands:clothing:hat
- fsn_commands:clothing:mask
- fsn_commands:dev:fix
- fsn_commands:dev:spawnCar
- fsn_commands:dev:weapon
- fsn_commands:dropweapon
- fsn_commands:getHDC
- fsn_commands:hc:takephone
- fsn_commands:me
- fsn_commands:me:3d
- fsn_commands:police:boot
- fsn_commands:police:car
- fsn_commands:police:cpic:trigger
- fsn_commands:police:extra
- fsn_commands:police:extras
- fsn_commands:police:fix
- fsn_commands:police:gsrMe
- fsn_commands:police:impound
- fsn_commands:police:impound2
- fsn_commands:police:livery
- fsn_commands:police:lock
- fsn_commands:police:pedcarry
- fsn_commands:police:pedrevive
- fsn_commands:police:rifle
- fsn_commands:police:shotgun
- fsn_commands:police:towMark
- fsn_commands:police:unboot
- fsn_commands:police:updateBoot
- fsn_commands:sendxyz
- fsn_commands:service:pingAccept
- fsn_commands:service:pingStart
- fsn_commands:service:request
- fsn_commands:vehdoor:close
- fsn_commands:vehdoor:open
- fsn_commands:walk:set
- fsn_commands:window
- fsn_criminalmisc:drugs:effects:cocaine
- fsn_criminalmisc:drugs:effects:meth
- fsn_criminalmisc:drugs:effects:smokeCigarette
- fsn_criminalmisc:drugs:effects:weed
- fsn_criminalmisc:drugs:streetselling:request
- fsn_criminalmisc:drugs:streetselling:send
- fsn_criminalmisc:handcuffs:startCuffed
- fsn_criminalmisc:handcuffs:startCuffing
- fsn_criminalmisc:handcuffs:startunCuffed
- fsn_criminalmisc:handcuffs:startunCuffing
- fsn_criminalmisc:houserobbery:try
- fsn_criminalmisc:lockpicking
- fsn_criminalmisc:racing:createRace
- fsn_criminalmisc:racing:putmeinrace
- fsn_criminalmisc:racing:update
- fsn_criminalmisc:robbing:startRobbing
- fsn_criminalmisc:toggleDrag
- fsn_criminalmisc:weapons:add
- fsn_criminalmisc:weapons:add:police
- fsn_criminalmisc:weapons:add:tbl
- fsn_criminalmisc:weapons:add:unknown
- fsn_criminalmisc:weapons:destroy
- fsn_criminalmisc:weapons:drop
- fsn_criminalmisc:weapons:equip
- fsn_criminalmisc:weapons:info
- fsn_criminalmisc:weapons:pickup
- fsn_criminalmisc:weapons:updateDropped
- fsn_dev:debug
- fsn_developer:deleteVehicle
- fsn_developer:enableDeveloperCommands
- fsn_developer:fixVehicle
- fsn_developer:getKeys
- fsn_developer:noClip:enabled
- fsn_developer:sendXYZ
- fsn_developer:spawnVehicle
- fsn_doj:court:remandMe
- fsn_doj:judge:spawnCar
- fsn_doj:judge:toggleLock
- fsn_doormanager:doorLocked
- fsn_doormanager:doorUnlocked
- fsn_doormanager:request
- fsn_doormanager:sendDoors
- fsn_emotecontrol:dice:roll
- fsn_emotecontrol:phone:call1
- fsn_emotecontrol:play
- fsn_emotecontrol:police:tablet
- fsn_emotecontrol:police:ticket
- fsn_ems:911
- fsn_ems:911r
- fsn_ems:ad:stopBleeding
- fsn_ems:adamage:request
- fsn_ems:bed:health
- fsn_ems:bed:leave
- fsn_ems:bed:occupy
- fsn_ems:bed:restraintoggle
- fsn_ems:bed:update
- fsn_ems:carried:end
- fsn_ems:carried:start
- fsn_ems:carry:end
- fsn_ems:carry:start
- fsn_ems:killMe
- fsn_ems:reviveMe
- fsn_ems:reviveMe:force
- fsn_ems:set:WalkType
- fsn_ems:update
- fsn_ems:updateLevel
- fsn_evidence:display
- fsn_evidence:ped:addState
- fsn_evidence:ped:update
- fsn_evidence:ped:updateDamage
- fsn_evidence:receive
- fsn_evidence:weaponInfo
- fsn_fuel:set
- fsn_fuel:update
- fsn_gangs:hideout:enter
- fsn_gangs:hideout:leave
- fsn_gangs:recieve
- fsn_hungerandthirst:pause
- fsn_hungerandthirst:unpause
- fsn_inventory:apt:recieve
- fsn_inventory:buyItem
- fsn_inventory:drops:collect
- fsn_inventory:drops:drop
- fsn_inventory:drops:request
- fsn_inventory:drops:send
- fsn_inventory:empty
- fsn_inventory:floor:update
- fsn_inventory:gui:display
- fsn_inventory:init
- fsn_inventory:initChar
- fsn_inventory:item:add
- fsn_inventory:item:drop
- fsn_inventory:item:give
- fsn_inventory:item:take
- fsn_inventory:item:use
- fsn_inventory:itemhasdropped
- fsn_inventory:items:add
- fsn_inventory:items:addPreset
- fsn_inventory:items:emptyinv
- fsn_inventory:me:update
- fsn_inventory:pd_locker:recieve
- fsn_inventory:ply:done
- fsn_inventory:ply:recieve
- fsn_inventory:ply:request
- fsn_inventory:police_armory:recieve
- fsn_inventory:prebuy
- fsn_inventory:prop:recieve
- fsn_inventory:rebreather:use
- fsn_inventory:recieveItems
- fsn_inventory:removedropped
- fsn_inventory:sendItemsToArmory
- fsn_inventory:sendItemsToStore
- fsn_inventory:store:recieve
- fsn_inventory:store_gun:recieve
- fsn_inventory:update
- fsn_inventory:use:drink
- fsn_inventory:use:food
- fsn_inventory:useAmmo
- fsn_inventory:useArmor
- fsn_inventory:veh:glovebox
- fsn_inventory:veh:glovebox:recieve
- fsn_inventory:veh:trunk:recieve
- fsn_jail:init
- fsn_jail:releaseme
- fsn_jail:sendme
- fsn_jail:spawn:recieve
- fsn_jewellerystore:case:startrob
- fsn_jewellerystore:cases:update
- fsn_jewellerystore:doors:State
- fsn_jewellerystore:gasDoor:toggle
- fsn_jobs:ems:request
- fsn_jobs:mechanic:toggleduty
- fsn_jobs:news:role:Set
- fsn_jobs:paycheck
- fsn_jobs:quit
- fsn_jobs:taxi:accepted
- fsn_jobs:taxi:request
- fsn_jobs:tow:marked
- fsn_jobs:tow:request
- fsn_jobs:whitelist:clock:in
- fsn_jobs:whitelist:clock:out
- fsn_jobs:whitelist:update
- fsn_licenses:display
- fsn_licenses:giveID
- fsn_licenses:infraction
- fsn_licenses:police:give
- fsn_licenses:setinfractions
- fsn_licenses:showid
- fsn_licenses:update
- fsn_main:blip:add
- fsn_main:blip:clear
- fsn_main:charMenu
- fsn_main:character
- fsn_main:characterSaving
- fsn_main:displayBankandMoney
- fsn_main:gui:bank:change
- fsn_main:gui:both:display
- fsn_main:gui:money:change
- fsn_main:initiateCharacter
- fsn_main:money:initChar
- fsn_main:money:update
- fsn_main:money:updateSilent
- fsn_main:sendCharacters
- fsn_main:updateCharacters
- fsn_menu:requestInventory
- fsn_needs:stress:add
- fsn_needs:stress:remove
- fsn_notify:displayNotification
- fsn_phones:GUI:notification
- fsn_phones:SYS:addCall
- fsn_phones:SYS:addTransaction
- fsn_phones:SYS:receiveGarage
- fsn_phones:SYS:recieve:details
- fsn_phones:SYS:updateAdverts
- fsn_phones:SYS:updateNumber
- fsn_phones:USE:Email
- fsn_phones:USE:Message
- fsn_phones:USE:Phone
- fsn_phones:USE:Tweet
- fsn_phones:USE:darkweb:order
- fsn_phones:UTIL:displayNumber
- fsn_police:911
- fsn_police:911r
- fsn_police:GetInVehicle
- fsn_police:MDT:receivewarrants
- fsn_police:MDT:toggle
- fsn_police:MDT:vehicledetails
- fsn_police:Sit
- fsn_police:ToggleK9
- fsn_police:armory:recieveItemsForArmory
- fsn_police:armory:request
- fsn_police:command:duty
- fsn_police:cuffs:startCuffed
- fsn_police:cuffs:startCuffing
- fsn_police:cuffs:startunCuffed
- fsn_police:cuffs:startunCuffing
- fsn_police:cuffs:toggleHard
- fsn_police:database:CPIC:search:result
- fsn_police:dispatch:toggle
- fsn_police:dispatchcall
- fsn_police:init
- fsn_police:k9:search:person:finish
- fsn_police:k9:search:person:me
- fsn_police:pd:toggleDrag
- fsn_police:ply:toggleDrag
- fsn_police:putMeInVeh
- fsn_police:radar:toggle
- fsn_police:runplate:target
- fsn_police:search:start:inventory
- fsn_police:search:start:money
- fsn_police:search:start:weapons
- fsn_police:search:strip
- fsn_police:update
- fsn_police:updateLevel
- fsn_properties:access
- fsn_properties:buy
- fsn_properties:inv:closed
- fsn_properties:inv:update
- fsn_properties:keys:give
- fsn_properties:menu:access:allow
- fsn_properties:menu:access:revoke
- fsn_properties:menu:access:view
- fsn_properties:menu:inventory:deposit
- fsn_properties:menu:inventory:take
- fsn_properties:menu:money:deposit
- fsn_properties:menu:money:withdraw
- fsn_properties:menu:police:breach
- fsn_properties:menu:police:empty
- fsn_properties:menu:police:search
- fsn_properties:menu:police:seize
- fsn_properties:menu:rent:check
- fsn_properties:menu:rent:pay
- fsn_properties:menu:robbery
- fsn_properties:menu:weapon:deposit
- fsn_properties:menu:weapon:take
- fsn_properties:updateXYZ
- fsn_spawnmanager:start
- fsn_store:recieveItemsForStore
- fsn_stripclub:client:update
- fsn_teleporters:teleport:coordinates
- fsn_teleporters:teleport:waypoint
- fsn_timeandweather:notify
- fsn_timeandweather:updateTime
- fsn_timeandweather:updateWeather
- fsn_vehiclecontrol:damage:repair
- fsn_vehiclecontrol:damage:repairkit
- fsn_vehiclecontrol:flagged:add
- fsn_vehiclecontrol:getKeys
- fsn_vehiclecontrol:giveKeys
- fsn_vehiclecontrol:keys:carjack
- fsn_vehiclecontrol:trunk:forceIn
- fsn_vehiclecontrol:trunk:forceOut
- fsn_voicecontrol:call:ring
- fsn_yoga:checkStress
- jTow:afford
- jTow:mark
- mythic_hospital:client:FieldTreatBleed
- mythic_hospital:client:FieldTreatLimbs
- mythic_hospital:client:ReduceBleed
- mythic_hospital:client:RemoveBleed
- mythic_hospital:client:ResetLimbs
- mythic_hospital:client:SyncBleed
- mythic_hospital:client:UseAdrenaline
- mythic_hospital:client:UsePainKiller
- pNotify:SendNotification
- pNotify:SetQueueMax
- safecracking:loop
- safecracking:start
- spawnme
- tow:CAD:tow

### Commands
- addmoney
- adminmenu
- amenu
- announce
- ban
- blackout
- bring
- carryplayer
- ce
- debug
- dv
- evening
- evi_clothing
- fixveh
- freeze
- freezetime
- freezeweather
- fsn_debug
- getkeys
- giveitem
- goto
- insidedebug
- inv
- kick
- kill
- mdt
- morning
- night
- noclip
- noon
- pdduty
- revive
- reviveplayer
- say
- sc
- setinfractions
- softlog
- spawnveh
- testanimation
- time
- tpc
- tpm
- tuner
- vehinspect
- vehrepair
- weather
- xyz

### Exports
- DoCustomHudText
- DoHudText
- EnterMyApartment
- GetOutfit
- GetWeapons
- HoldingWeapon
- IsDoorLocked
- SetFuel
- addToWhitelist
- carryingWho
- fsn_Airlift
- fsn_CanAfford
- fsn_CanCarry
- fsn_CharID
- fsn_EMSDuty
- fsn_FindNearbyPed
- fsn_FindPedNearbyCoords
- fsn_GetBank
- fsn_GetCharacterInfo
- fsn_GetItemAmount
- fsn_GetItemDetails
- fsn_GetJob
- fsn_GetPlayerFromPhoneNumber
- fsn_GetTime
- fsn_GetVehicleVehIDP
- fsn_GetWallet
- fsn_HasItem
- fsn_IsDead
- fsn_IsVehicleOwner
- fsn_IsVehicleOwnerP
- fsn_PDDuty
- fsn_ProgressBar
- fsn_SetJob
- fsn_SpawnVehicle
- fsn_getCopAmt
- fsn_getEMSLevel
- fsn_getPDLevel
- fsn_hasLicense
- fsn_hunger
- fsn_stress
- fsn_thirst
- getCarDetails
- getPedNearCoords
- getPeds
- getTime
- getVehicles
- getWhitelistDetails
- inAnyWhitelist
- inInstance
- isClothingOpen
- isCrouching
- isNearStorage
- isPlayerClockedInWhitelist
- isWhitelistClockedIn
- removeBar
- sub_frame_time
- toggleWhitelistClock
- weaponInfo

### NUI Callbacks
- booking-submit-now
- booking-submit-warrant
- camToLoc
- chatResult
- closeMDT
- createCharacter
- depositMoney
- dropSlot
- escape
- loaded
- mdt-remove-warrant
- mdt-request-warrants
- messageactive
- messageinactive
- rentBike
- setWaypoint
- spawnAtLoc
- spawnCharacter
- toggleGUI
- transferMoney
- useSlot
- withdrawMoney

### Database Tables
- fsn_apartments
- fsn_characters
- fsn_properties
- fsn_tickets
- fsn_users
- fsn_vehicles
- fsn_warrants
- fsn_whitelists

## Gaps & Inferences
- Many descriptions are inferred from file and folder names without deeper context (Inferred: Low).
- Payload structures for events and callbacks are not specified; inference would require reading callsites.

DOCS COMPLETE
