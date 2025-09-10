# FiveM-FSN-Framework Documentation

This document provides an overview of the FSN framework resources bundled in this package. It catalogs client, server, shared and NUI scripts, their interactions through events, commands, and database calls.

## Table of Contents

- [README.md](#readme-md)
- [fsn_activities/fishing/client.lua](#fsn-activities-fishing-client-lua)
- [fsn_activities/fxmanifest.lua](#fsn-activities-fxmanifest-lua)
- [fsn_activities/hunting/client.lua](#fsn-activities-hunting-client-lua)
- [fsn_activities/yoga/client.lua](#fsn-activities-yoga-client-lua)
- [fsn_admin/client.lua](#fsn-admin-client-lua)
- [fsn_admin/client/client.lua](#fsn-admin-client-client-lua)
- [fsn_admin/config.lua](#fsn-admin-config-lua)
- [fsn_admin/fxmanifest.lua](#fsn-admin-fxmanifest-lua)
- [fsn_admin/oldresource.lua](#fsn-admin-oldresource-lua)
- [fsn_admin/server.lua](#fsn-admin-server-lua)
- [fsn_admin/server/server.lua](#fsn-admin-server-server-lua)
- [fsn_admin/server_announce.lua](#fsn-admin-server-announce-lua)
- [fsn_apartments/cl_instancing.lua](#fsn-apartments-cl-instancing-lua)
- [fsn_apartments/client.lua](#fsn-apartments-client-lua)
- [fsn_apartments/fxmanifest.lua](#fsn-apartments-fxmanifest-lua)
- [fsn_apartments/gui/ui.css](#fsn-apartments-gui-ui-css)
- [fsn_apartments/gui/ui.html](#fsn-apartments-gui-ui-html)
- [fsn_apartments/gui/ui.js](#fsn-apartments-gui-ui-js)
- [fsn_apartments/server.lua](#fsn-apartments-server-lua)
- [fsn_apartments/sv_instancing.lua](#fsn-apartments-sv-instancing-lua)
- [fsn_bank/client.lua](#fsn-bank-client-lua)
- [fsn_bank/fxmanifest.lua](#fsn-bank-fxmanifest-lua)
- [fsn_bank/gui/atm_button_sound.mp3](#fsn-bank-gui-atm-button-sound-mp3)
- [fsn_bank/gui/atm_logo.png](#fsn-bank-gui-atm-logo-png)
- [fsn_bank/gui/index.css](#fsn-bank-gui-index-css)
- [fsn_bank/gui/index.html](#fsn-bank-gui-index-html)
- [fsn_bank/gui/index.js](#fsn-bank-gui-index-js)
- [fsn_bank/server.lua](#fsn-bank-server-lua)
- [fsn_bankrobbery/cl_frontdesks.lua](#fsn-bankrobbery-cl-frontdesks-lua)
- [fsn_bankrobbery/cl_safeanim.lua](#fsn-bankrobbery-cl-safeanim-lua)
- [fsn_bankrobbery/client.lua](#fsn-bankrobbery-client-lua)
- [fsn_bankrobbery/fxmanifest.lua](#fsn-bankrobbery-fxmanifest-lua)
- [fsn_bankrobbery/server.lua](#fsn-bankrobbery-server-lua)
- [fsn_bankrobbery/sv_frontdesks.lua](#fsn-bankrobbery-sv-frontdesks-lua)
- [fsn_bankrobbery/trucks.lua](#fsn-bankrobbery-trucks-lua)
- [fsn_bennys/cl_bennys.lua](#fsn-bennys-cl-bennys-lua)
- [fsn_bennys/cl_config.lua](#fsn-bennys-cl-config-lua)
- [fsn_bennys/fxmanifest.lua](#fsn-bennys-fxmanifest-lua)
- [fsn_bennys/menu.lua](#fsn-bennys-menu-lua)
- [fsn_bikerental/client.lua](#fsn-bikerental-client-lua)
- [fsn_bikerental/fxmanifest.lua](#fsn-bikerental-fxmanifest-lua)
- [fsn_bikerental/html/cursor.png](#fsn-bikerental-html-cursor-png)
- [fsn_bikerental/html/index.html](#fsn-bikerental-html-index-html)
- [fsn_bikerental/html/script.js](#fsn-bikerental-html-script-js)
- [fsn_bikerental/html/style.css](#fsn-bikerental-html-style-css)
- [fsn_boatshop/cl_boatshop.lua](#fsn-boatshop-cl-boatshop-lua)
- [fsn_boatshop/cl_menu.lua](#fsn-boatshop-cl-menu-lua)
- [fsn_boatshop/fxmanifest.lua](#fsn-boatshop-fxmanifest-lua)
- [fsn_boatshop/sv_boatshop.lua](#fsn-boatshop-sv-boatshop-lua)
- [fsn_builders/fxmanifest.lua](#fsn-builders-fxmanifest-lua)
- [fsn_builders/handling_builder.lua](#fsn-builders-handling-builder-lua)
- [fsn_builders/schema.lua](#fsn-builders-schema-lua)
- [fsn_builders/schemas/cbikehandlingdata.lua](#fsn-builders-schemas-cbikehandlingdata-lua)
- [fsn_builders/schemas/ccarhandlingdata.lua](#fsn-builders-schemas-ccarhandlingdata-lua)
- [fsn_builders/schemas/chandlingdata.lua](#fsn-builders-schemas-chandlingdata-lua)
- [fsn_builders/xml.lua](#fsn-builders-xml-lua)
- [fsn_cargarage/client.lua](#fsn-cargarage-client-lua)
- [fsn_cargarage/fxmanifest.lua](#fsn-cargarage-fxmanifest-lua)
- [fsn_cargarage/gui/ui.css](#fsn-cargarage-gui-ui-css)
- [fsn_cargarage/gui/ui.html](#fsn-cargarage-gui-ui-html)
- [fsn_cargarage/gui/ui.js](#fsn-cargarage-gui-ui-js)
- [fsn_cargarage/server.lua](#fsn-cargarage-server-lua)
- [fsn_carstore/cl_carstore.lua](#fsn-carstore-cl-carstore-lua)
- [fsn_carstore/cl_menu.lua](#fsn-carstore-cl-menu-lua)
- [fsn_carstore/fxmanifest.lua](#fsn-carstore-fxmanifest-lua)
- [fsn_carstore/gui/index.html](#fsn-carstore-gui-index-html)
- [fsn_carstore/sv_carstore.lua](#fsn-carstore-sv-carstore-lua)
- [fsn_carstore/vehshop_server.lua](#fsn-carstore-vehshop-server-lua)
- [fsn_characterdetails/facial/client.lua](#fsn-characterdetails-facial-client-lua)
- [fsn_characterdetails/facial/server.lua](#fsn-characterdetails-facial-server-lua)
- [fsn_characterdetails/fxmanifest.lua](#fsn-characterdetails-fxmanifest-lua)
- [fsn_characterdetails/gui/ui.css](#fsn-characterdetails-gui-ui-css)
- [fsn_characterdetails/gui/ui.html](#fsn-characterdetails-gui-ui-html)
- [fsn_characterdetails/gui/ui.js](#fsn-characterdetails-gui-ui-js)
- [fsn_characterdetails/gui_manager.lua](#fsn-characterdetails-gui-manager-lua)
- [fsn_characterdetails/tattoos/client.lua](#fsn-characterdetails-tattoos-client-lua)
- [fsn_characterdetails/tattoos/config.lua](#fsn-characterdetails-tattoos-config-lua)
- [fsn_characterdetails/tattoos/server.lua](#fsn-characterdetails-tattoos-server-lua)
- [fsn_characterdetails/tattoos/server.zip](#fsn-characterdetails-tattoos-server-zip)
- [fsn_clothing/client.lua](#fsn-clothing-client-lua)
- [fsn_clothing/config.lua](#fsn-clothing-config-lua)
- [fsn_clothing/fxmanifest.lua](#fsn-clothing-fxmanifest-lua)
- [fsn_clothing/gui.lua](#fsn-clothing-gui-lua)
- [fsn_clothing/models.txt](#fsn-clothing-models-txt)
- [fsn_clothing/server.lua](#fsn-clothing-server-lua)
- [fsn_commands/client.lua](#fsn-commands-client-lua)
- [fsn_commands/fxmanifest.lua](#fsn-commands-fxmanifest-lua)
- [fsn_commands/server.lua](#fsn-commands-server-lua)
- [fsn_crafting/client.lua](#fsn-crafting-client-lua)
- [fsn_crafting/fxmanifest.lua](#fsn-crafting-fxmanifest-lua)
- [fsn_crafting/nui/index.css](#fsn-crafting-nui-index-css)
- [fsn_crafting/nui/index.html](#fsn-crafting-nui-index-html)
- [fsn_crafting/nui/index.js](#fsn-crafting-nui-index-js)
- [fsn_crafting/server.lua](#fsn-crafting-server-lua)
- [fsn_criminalmisc/client.lua](#fsn-criminalmisc-client-lua)
- [fsn_criminalmisc/drugs/_effects/client.lua](#fsn-criminalmisc-drugs-effects-client-lua)
- [fsn_criminalmisc/drugs/_streetselling/client.lua](#fsn-criminalmisc-drugs-streetselling-client-lua)
- [fsn_criminalmisc/drugs/_streetselling/server.lua](#fsn-criminalmisc-drugs-streetselling-server-lua)
- [fsn_criminalmisc/drugs/_weedprocess/client.lua](#fsn-criminalmisc-drugs-weedprocess-client-lua)
- [fsn_criminalmisc/drugs/client.lua](#fsn-criminalmisc-drugs-client-lua)
- [fsn_criminalmisc/fxmanifest.lua](#fsn-criminalmisc-fxmanifest-lua)
- [fsn_criminalmisc/handcuffs/client.lua](#fsn-criminalmisc-handcuffs-client-lua)
- [fsn_criminalmisc/handcuffs/server.lua](#fsn-criminalmisc-handcuffs-server-lua)
- [fsn_criminalmisc/lockpicking/client.lua](#fsn-criminalmisc-lockpicking-client-lua)
- [fsn_criminalmisc/pawnstore/cl_pawnstore.lua](#fsn-criminalmisc-pawnstore-cl-pawnstore-lua)
- [fsn_criminalmisc/remapping/client.lua](#fsn-criminalmisc-remapping-client-lua)
- [fsn_criminalmisc/remapping/server.lua](#fsn-criminalmisc-remapping-server-lua)
- [fsn_criminalmisc/robbing/cl_houses-build.lua](#fsn-criminalmisc-robbing-cl-houses-build-lua)
- [fsn_criminalmisc/robbing/cl_houses-config.lua](#fsn-criminalmisc-robbing-cl-houses-config-lua)
- [fsn_criminalmisc/robbing/cl_houses.lua](#fsn-criminalmisc-robbing-cl-houses-lua)
- [fsn_criminalmisc/robbing/client.lua](#fsn-criminalmisc-robbing-client-lua)
- [fsn_criminalmisc/streetracing/client.lua](#fsn-criminalmisc-streetracing-client-lua)
- [fsn_criminalmisc/streetracing/server.lua](#fsn-criminalmisc-streetracing-server-lua)
- [fsn_criminalmisc/weaponinfo/client.lua](#fsn-criminalmisc-weaponinfo-client-lua)
- [fsn_criminalmisc/weaponinfo/server.lua](#fsn-criminalmisc-weaponinfo-server-lua)
- [fsn_criminalmisc/weaponinfo/weapon_list.lua](#fsn-criminalmisc-weaponinfo-weapon-list-lua)
- [fsn_customanimations/client.lua](#fsn-customanimations-client-lua)
- [fsn_customanimations/fxmanifest.lua](#fsn-customanimations-fxmanifest-lua)
- [fsn_customs/fxmanifest.lua](#fsn-customs-fxmanifest-lua)
- [fsn_customs/lscustoms.lua](#fsn-customs-lscustoms-lua)
- [fsn_dev/client/cl_noclip.lua](#fsn-dev-client-cl-noclip-lua)
- [fsn_dev/client/client.lua](#fsn-dev-client-client-lua)
- [fsn_dev/config.lua](#fsn-dev-config-lua)
- [fsn_dev/fxmanifest.lua](#fsn-dev-fxmanifest-lua)
- [fsn_dev/oldresource.lua](#fsn-dev-oldresource-lua)
- [fsn_dev/server/server.lua](#fsn-dev-server-server-lua)
- [fsn_doj/attorneys/client.lua](#fsn-doj-attorneys-client-lua)
- [fsn_doj/attorneys/server.lua](#fsn-doj-attorneys-server-lua)
- [fsn_doj/client.lua](#fsn-doj-client-lua)
- [fsn_doj/fxmanifest.lua](#fsn-doj-fxmanifest-lua)
- [fsn_doj/judges/client.lua](#fsn-doj-judges-client-lua)
- [fsn_doj/judges/server.lua](#fsn-doj-judges-server-lua)
- [fsn_doormanager/cl_doors.lua](#fsn-doormanager-cl-doors-lua)
- [fsn_doormanager/client.lua](#fsn-doormanager-client-lua)
- [fsn_doormanager/fxmanifest.lua](#fsn-doormanager-fxmanifest-lua)
- [fsn_doormanager/server.lua](#fsn-doormanager-server-lua)
- [fsn_doormanager/sv_doors.lua](#fsn-doormanager-sv-doors-lua)
- [fsn_emotecontrol/client.lua](#fsn-emotecontrol-client-lua)
- [fsn_emotecontrol/fxmanifest.lua](#fsn-emotecontrol-fxmanifest-lua)
- [fsn_emotecontrol/walktypes/client.lua](#fsn-emotecontrol-walktypes-client-lua)
- [fsn_ems/beds/client.lua](#fsn-ems-beds-client-lua)
- [fsn_ems/beds/server.lua](#fsn-ems-beds-server-lua)
- [fsn_ems/blip.lua](#fsn-ems-blip-lua)
- [fsn_ems/cl_advanceddamage.lua](#fsn-ems-cl-advanceddamage-lua)
- [fsn_ems/cl_carrydead.lua](#fsn-ems-cl-carrydead-lua)
- [fsn_ems/cl_volunteering.lua](#fsn-ems-cl-volunteering-lua)
- [fsn_ems/client.lua](#fsn-ems-client-lua)
- [fsn_ems/debug_kng.lua](#fsn-ems-debug-kng-lua)
- [fsn_ems/fxmanifest.lua](#fsn-ems-fxmanifest-lua)
- [fsn_ems/info.txt](#fsn-ems-info-txt)
- [fsn_ems/server.lua](#fsn-ems-server-lua)
- [fsn_ems/sv_carrydead.lua](#fsn-ems-sv-carrydead-lua)
- [fsn_entfinder/client.lua](#fsn-entfinder-client-lua)
- [fsn_entfinder/fxmanifest.lua](#fsn-entfinder-fxmanifest-lua)
- [fsn_errorcontrol/client.lua](#fsn-errorcontrol-client-lua)
- [fsn_errorcontrol/fxmanifest.lua](#fsn-errorcontrol-fxmanifest-lua)
- [fsn_evidence/__descriptions-carpaint.lua](#fsn-evidence-descriptions-carpaint-lua)
- [fsn_evidence/__descriptions-female.lua](#fsn-evidence-descriptions-female-lua)
- [fsn_evidence/__descriptions-male.lua](#fsn-evidence-descriptions-male-lua)
- [fsn_evidence/__descriptions.lua](#fsn-evidence-descriptions-lua)
- [fsn_evidence/casings/cl_casings.lua](#fsn-evidence-casings-cl-casings-lua)
- [fsn_evidence/cl_evidence.lua](#fsn-evidence-cl-evidence-lua)
- [fsn_evidence/fxmanifest.lua](#fsn-evidence-fxmanifest-lua)
- [fsn_evidence/ped/cl_ped.lua](#fsn-evidence-ped-cl-ped-lua)
- [fsn_evidence/ped/sv_ped.lua](#fsn-evidence-ped-sv-ped-lua)
- [fsn_evidence/sv_evidence.lua](#fsn-evidence-sv-evidence-lua)
- [fsn_gangs/cl_gangs.lua](#fsn-gangs-cl-gangs-lua)
- [fsn_gangs/fxmanifest.lua](#fsn-gangs-fxmanifest-lua)
- [fsn_gangs/sv_gangs.lua](#fsn-gangs-sv-gangs-lua)
- [fsn_handling/data/handling.meta](#fsn-handling-data-handling-meta)
- [fsn_handling/fxmanifest.lua](#fsn-handling-fxmanifest-lua)
- [fsn_handling/src/compact.lua](#fsn-handling-src-compact-lua)
- [fsn_handling/src/coupes.lua](#fsn-handling-src-coupes-lua)
- [fsn_handling/src/government.lua](#fsn-handling-src-government-lua)
- [fsn_handling/src/motorcycles.lua](#fsn-handling-src-motorcycles-lua)
- [fsn_handling/src/muscle.lua](#fsn-handling-src-muscle-lua)
- [fsn_handling/src/offroad.lua](#fsn-handling-src-offroad-lua)
- [fsn_handling/src/schafter.lua](#fsn-handling-src-schafter-lua)
- [fsn_handling/src/sedans.lua](#fsn-handling-src-sedans-lua)
- [fsn_handling/src/sports.lua](#fsn-handling-src-sports-lua)
- [fsn_handling/src/sportsclassics.lua](#fsn-handling-src-sportsclassics-lua)
- [fsn_handling/src/super.lua](#fsn-handling-src-super-lua)
- [fsn_handling/src/suvs.lua](#fsn-handling-src-suvs-lua)
- [fsn_handling/src/vans.lua](#fsn-handling-src-vans-lua)
- [fsn_inventory/_item_misc/binoculars.lua](#fsn-inventory-item-misc-binoculars-lua)
- [fsn_inventory/_item_misc/burger_store.lua](#fsn-inventory-item-misc-burger-store-lua)
- [fsn_inventory/_item_misc/cl_breather.lua](#fsn-inventory-item-misc-cl-breather-lua)
- [fsn_inventory/_item_misc/dm_laundering.lua](#fsn-inventory-item-misc-dm-laundering-lua)
- [fsn_inventory/_old/_item_misc/_drug_selling.lua](#fsn-inventory-old-item-misc-drug-selling-lua)
- [fsn_inventory/_old/client.lua](#fsn-inventory-old-client-lua)
- [fsn_inventory/_old/items.lua](#fsn-inventory-old-items-lua)
- [fsn_inventory/_old/pedfinder.lua](#fsn-inventory-old-pedfinder-lua)
- [fsn_inventory/_old/server.lua](#fsn-inventory-old-server-lua)
- [fsn_inventory/cl_inventory.lua](#fsn-inventory-cl-inventory-lua)
- [fsn_inventory/cl_presets.lua](#fsn-inventory-cl-presets-lua)
- [fsn_inventory/cl_uses.lua](#fsn-inventory-cl-uses-lua)
- [fsn_inventory/cl_vehicles.lua](#fsn-inventory-cl-vehicles-lua)
- [fsn_inventory/fxmanifest.lua](#fsn-inventory-fxmanifest-lua)
- [fsn_inventory/html/css/jquery-ui.css](#fsn-inventory-html-css-jquery-ui-css)
- [fsn_inventory/html/css/ui.css](#fsn-inventory-html-css-ui-css)
- [fsn_inventory/html/img/bullet.png](#fsn-inventory-html-img-bullet-png)
- [fsn_inventory/html/img/items/2g_weed.png](#fsn-inventory-html-img-items-2g-weed-png)
- [fsn_inventory/html/img/items/WEAPON_ADVANCEDRIFLE.png](#fsn-inventory-html-img-items-weapon-advancedrifle-png)
- [fsn_inventory/html/img/items/WEAPON_APPISTOL.png](#fsn-inventory-html-img-items-weapon-appistol-png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE.png](#fsn-inventory-html-img-items-weapon-assaultrifle-png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE_MK2.png](#fsn-inventory-html-img-items-weapon-assaultrifle-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTSHOTGUN.png](#fsn-inventory-html-img-items-weapon-assaultshotgun-png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTSMG.png](#fsn-inventory-html-img-items-weapon-assaultsmg-png)
- [fsn_inventory/html/img/items/WEAPON_AUTOSHOTGUN.png](#fsn-inventory-html-img-items-weapon-autoshotgun-png)
- [fsn_inventory/html/img/items/WEAPON_BALL.png](#fsn-inventory-html-img-items-weapon-ball-png)
- [fsn_inventory/html/img/items/WEAPON_BAT.png](#fsn-inventory-html-img-items-weapon-bat-png)
- [fsn_inventory/html/img/items/WEAPON_BATTLEAXE.png](#fsn-inventory-html-img-items-weapon-battleaxe-png)
- [fsn_inventory/html/img/items/WEAPON_BOTTLE.png](#fsn-inventory-html-img-items-weapon-bottle-png)
- [fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE.png](#fsn-inventory-html-img-items-weapon-bullpuprifle-png)
- [fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE_MK2.png](#fsn-inventory-html-img-items-weapon-bullpuprifle-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_BULLPUPSHOTGUN.png](#fsn-inventory-html-img-items-weapon-bullpupshotgun-png)
- [fsn_inventory/html/img/items/WEAPON_CARBINERIFLE.png](#fsn-inventory-html-img-items-weapon-carbinerifle-png)
- [fsn_inventory/html/img/items/WEAPON_CARBINERIFLE_MK2.png](#fsn-inventory-html-img-items-weapon-carbinerifle-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_COMBATMG.png](#fsn-inventory-html-img-items-weapon-combatmg-png)
- [fsn_inventory/html/img/items/WEAPON_COMBATMG_MK2.png](#fsn-inventory-html-img-items-weapon-combatmg-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_COMBATPDW.png](#fsn-inventory-html-img-items-weapon-combatpdw-png)
- [fsn_inventory/html/img/items/WEAPON_COMBATPISTOL.png](#fsn-inventory-html-img-items-weapon-combatpistol-png)
- [fsn_inventory/html/img/items/WEAPON_COMPACTLAUNCHER.png](#fsn-inventory-html-img-items-weapon-compactlauncher-png)
- [fsn_inventory/html/img/items/WEAPON_COMPACTRIFLE.png](#fsn-inventory-html-img-items-weapon-compactrifle-png)
- [fsn_inventory/html/img/items/WEAPON_CROWBAR.png](#fsn-inventory-html-img-items-weapon-crowbar-png)
- [fsn_inventory/html/img/items/WEAPON_DAGGER.png](#fsn-inventory-html-img-items-weapon-dagger-png)
- [fsn_inventory/html/img/items/WEAPON_DBSHOTGUN.png](#fsn-inventory-html-img-items-weapon-dbshotgun-png)
- [fsn_inventory/html/img/items/WEAPON_DOUBLEACTION.png](#fsn-inventory-html-img-items-weapon-doubleaction-png)
- [fsn_inventory/html/img/items/WEAPON_FIREEXTINGUISHER.png](#fsn-inventory-html-img-items-weapon-fireextinguisher-png)
- [fsn_inventory/html/img/items/WEAPON_FIREWORK.png](#fsn-inventory-html-img-items-weapon-firework-png)
- [fsn_inventory/html/img/items/WEAPON_FLARE.png](#fsn-inventory-html-img-items-weapon-flare-png)
- [fsn_inventory/html/img/items/WEAPON_FLAREGUN.png](#fsn-inventory-html-img-items-weapon-flaregun-png)
- [fsn_inventory/html/img/items/WEAPON_FLASHLIGHT.png](#fsn-inventory-html-img-items-weapon-flashlight-png)
- [fsn_inventory/html/img/items/WEAPON_GOLFCLUB.png](#fsn-inventory-html-img-items-weapon-golfclub-png)
- [fsn_inventory/html/img/items/WEAPON_GRENADE.png](#fsn-inventory-html-img-items-weapon-grenade-png)
- [fsn_inventory/html/img/items/WEAPON_GRENADELAUNCHER.png](#fsn-inventory-html-img-items-weapon-grenadelauncher-png)
- [fsn_inventory/html/img/items/WEAPON_GUSENBERG.png](#fsn-inventory-html-img-items-weapon-gusenberg-png)
- [fsn_inventory/html/img/items/WEAPON_HAMMER.png](#fsn-inventory-html-img-items-weapon-hammer-png)
- [fsn_inventory/html/img/items/WEAPON_HATCHET.png](#fsn-inventory-html-img-items-weapon-hatchet-png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYPISTOL.png](#fsn-inventory-html-img-items-weapon-heavypistol-png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYSHOTGUN.png](#fsn-inventory-html-img-items-weapon-heavyshotgun-png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER.png](#fsn-inventory-html-img-items-weapon-heavysniper-png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER_MK2.png](#fsn-inventory-html-img-items-weapon-heavysniper-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_HOMINGLAUNCHER.png](#fsn-inventory-html-img-items-weapon-hominglauncher-png)
- [fsn_inventory/html/img/items/WEAPON_KNIFE.png](#fsn-inventory-html-img-items-weapon-knife-png)
- [fsn_inventory/html/img/items/WEAPON_KNUCKLE.png](#fsn-inventory-html-img-items-weapon-knuckle-png)
- [fsn_inventory/html/img/items/WEAPON_MACHETE.png](#fsn-inventory-html-img-items-weapon-machete-png)
- [fsn_inventory/html/img/items/WEAPON_MACHINEPISTOL.png](#fsn-inventory-html-img-items-weapon-machinepistol-png)
- [fsn_inventory/html/img/items/WEAPON_MARKSMANPISTOL.png](#fsn-inventory-html-img-items-weapon-marksmanpistol-png)
- [fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE.png](#fsn-inventory-html-img-items-weapon-marksmanrifle-png)
- [fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE_MK2.png](#fsn-inventory-html-img-items-weapon-marksmanrifle-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_MG.png](#fsn-inventory-html-img-items-weapon-mg-png)
- [fsn_inventory/html/img/items/WEAPON_MICROSMG.png](#fsn-inventory-html-img-items-weapon-microsmg-png)
- [fsn_inventory/html/img/items/WEAPON_MINIGUN.png](#fsn-inventory-html-img-items-weapon-minigun-png)
- [fsn_inventory/html/img/items/WEAPON_MINISMG.png](#fsn-inventory-html-img-items-weapon-minismg-png)
- [fsn_inventory/html/img/items/WEAPON_MOLOTOV.png](#fsn-inventory-html-img-items-weapon-molotov-png)
- [fsn_inventory/html/img/items/WEAPON_MUSKET.png](#fsn-inventory-html-img-items-weapon-musket-png)
- [fsn_inventory/html/img/items/WEAPON_NIGHTSTICK.png](#fsn-inventory-html-img-items-weapon-nightstick-png)
- [fsn_inventory/html/img/items/WEAPON_PETROLCAN.png](#fsn-inventory-html-img-items-weapon-petrolcan-png)
- [fsn_inventory/html/img/items/WEAPON_PIPEBOMB.png](#fsn-inventory-html-img-items-weapon-pipebomb-png)
- [fsn_inventory/html/img/items/WEAPON_PISTOL.png](#fsn-inventory-html-img-items-weapon-pistol-png)
- [fsn_inventory/html/img/items/WEAPON_PISTOL50.png](#fsn-inventory-html-img-items-weapon-pistol50-png)
- [fsn_inventory/html/img/items/WEAPON_PISTOL_MK2.png](#fsn-inventory-html-img-items-weapon-pistol-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_POOLCUE.png](#fsn-inventory-html-img-items-weapon-poolcue-png)
- [fsn_inventory/html/img/items/WEAPON_PROXMINE.png](#fsn-inventory-html-img-items-weapon-proxmine-png)
- [fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN.png](#fsn-inventory-html-img-items-weapon-pumpshotgun-png)
- [fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN_MK2.png](#fsn-inventory-html-img-items-weapon-pumpshotgun-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_RAILGUN.png](#fsn-inventory-html-img-items-weapon-railgun-png)
- [fsn_inventory/html/img/items/WEAPON_RAYCARBINE.png](#fsn-inventory-html-img-items-weapon-raycarbine-png)
- [fsn_inventory/html/img/items/WEAPON_RAYMINIGUN.png](#fsn-inventory-html-img-items-weapon-rayminigun-png)
- [fsn_inventory/html/img/items/WEAPON_RAYPISTOL.png](#fsn-inventory-html-img-items-weapon-raypistol-png)
- [fsn_inventory/html/img/items/WEAPON_REVOLVER.png](#fsn-inventory-html-img-items-weapon-revolver-png)
- [fsn_inventory/html/img/items/WEAPON_REVOLVER_MK2.png](#fsn-inventory-html-img-items-weapon-revolver-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_RPG.png](#fsn-inventory-html-img-items-weapon-rpg-png)
- [fsn_inventory/html/img/items/WEAPON_SAWNOFFSHOTGUN.png](#fsn-inventory-html-img-items-weapon-sawnoffshotgun-png)
- [fsn_inventory/html/img/items/WEAPON_SMG.png](#fsn-inventory-html-img-items-weapon-smg-png)
- [fsn_inventory/html/img/items/WEAPON_SMG_MK2.png](#fsn-inventory-html-img-items-weapon-smg-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_SMOKEGRENADE.png](#fsn-inventory-html-img-items-weapon-smokegrenade-png)
- [fsn_inventory/html/img/items/WEAPON_SNIPERRIFLE.png](#fsn-inventory-html-img-items-weapon-sniperrifle-png)
- [fsn_inventory/html/img/items/WEAPON_SNOWBALL.png](#fsn-inventory-html-img-items-weapon-snowball-png)
- [fsn_inventory/html/img/items/WEAPON_SNSPISTOL.png](#fsn-inventory-html-img-items-weapon-snspistol-png)
- [fsn_inventory/html/img/items/WEAPON_SNSPISTOL_MK2.png](#fsn-inventory-html-img-items-weapon-snspistol-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE.png](#fsn-inventory-html-img-items-weapon-specialcarbine-png)
- [fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE_MK2.png](#fsn-inventory-html-img-items-weapon-specialcarbine-mk2-png)
- [fsn_inventory/html/img/items/WEAPON_STICKYBOMB.png](#fsn-inventory-html-img-items-weapon-stickybomb-png)
- [fsn_inventory/html/img/items/WEAPON_STONE_HATCHET.png](#fsn-inventory-html-img-items-weapon-stone-hatchet-png)
- [fsn_inventory/html/img/items/WEAPON_STUNGUN.png](#fsn-inventory-html-img-items-weapon-stungun-png)
- [fsn_inventory/html/img/items/WEAPON_SWITCHBLADE.png](#fsn-inventory-html-img-items-weapon-switchblade-png)
- [fsn_inventory/html/img/items/WEAPON_VINTAGEPISTOL.png](#fsn-inventory-html-img-items-weapon-vintagepistol-png)
- [fsn_inventory/html/img/items/WEAPON_WRENCH.png](#fsn-inventory-html-img-items-weapon-wrench-png)
- [fsn_inventory/html/img/items/acetone.png](#fsn-inventory-html-img-items-acetone-png)
- [fsn_inventory/html/img/items/ammo_mg.png](#fsn-inventory-html-img-items-ammo-mg-png)
- [fsn_inventory/html/img/items/ammo_mg_large.png](#fsn-inventory-html-img-items-ammo-mg-large-png)
- [fsn_inventory/html/img/items/ammo_pistol.png](#fsn-inventory-html-img-items-ammo-pistol-png)
- [fsn_inventory/html/img/items/ammo_pistol_large.png](#fsn-inventory-html-img-items-ammo-pistol-large-png)
- [fsn_inventory/html/img/items/ammo_rifle.png](#fsn-inventory-html-img-items-ammo-rifle-png)
- [fsn_inventory/html/img/items/ammo_rifle_large.png](#fsn-inventory-html-img-items-ammo-rifle-large-png)
- [fsn_inventory/html/img/items/ammo_shotgun.png](#fsn-inventory-html-img-items-ammo-shotgun-png)
- [fsn_inventory/html/img/items/ammo_shotgun_large.png](#fsn-inventory-html-img-items-ammo-shotgun-large-png)
- [fsn_inventory/html/img/items/ammo_smg.png](#fsn-inventory-html-img-items-ammo-smg-png)
- [fsn_inventory/html/img/items/ammo_smg_large.png](#fsn-inventory-html-img-items-ammo-smg-large-png)
- [fsn_inventory/html/img/items/ammo_sniper.png](#fsn-inventory-html-img-items-ammo-sniper-png)
- [fsn_inventory/html/img/items/ammo_sniper_large.png](#fsn-inventory-html-img-items-ammo-sniper-large-png)
- [fsn_inventory/html/img/items/armor.png](#fsn-inventory-html-img-items-armor-png)
- [fsn_inventory/html/img/items/bandage.png](#fsn-inventory-html-img-items-bandage-png)
- [fsn_inventory/html/img/items/beef_jerky.png](#fsn-inventory-html-img-items-beef-jerky-png)
- [fsn_inventory/html/img/items/binoculars.png](#fsn-inventory-html-img-items-binoculars-png)
- [fsn_inventory/html/img/items/burger.png](#fsn-inventory-html-img-items-burger-png)
- [fsn_inventory/html/img/items/burger_bun.png](#fsn-inventory-html-img-items-burger-bun-png)
- [fsn_inventory/html/img/items/cigarette.png](#fsn-inventory-html-img-items-cigarette-png)
- [fsn_inventory/html/img/items/coffee.png](#fsn-inventory-html-img-items-coffee-png)
- [fsn_inventory/html/img/items/cooked_burger.png](#fsn-inventory-html-img-items-cooked-burger-png)
- [fsn_inventory/html/img/items/cooked_meat.png](#fsn-inventory-html-img-items-cooked-meat-png)
- [fsn_inventory/html/img/items/cupcake.png](#fsn-inventory-html-img-items-cupcake-png)
- [fsn_inventory/html/img/items/dirty_money.png](#fsn-inventory-html-img-items-dirty-money-png)
- [fsn_inventory/html/img/items/drill.png](#fsn-inventory-html-img-items-drill-png)
- [fsn_inventory/html/img/items/ecola.png](#fsn-inventory-html-img-items-ecola-png)
- [fsn_inventory/html/img/items/empty_canister.png](#fsn-inventory-html-img-items-empty-canister-png)
- [fsn_inventory/html/img/items/evidence.png](#fsn-inventory-html-img-items-evidence-png)
- [fsn_inventory/html/img/items/fries.png](#fsn-inventory-html-img-items-fries-png)
- [fsn_inventory/html/img/items/frozen_burger.png](#fsn-inventory-html-img-items-frozen-burger-png)
- [fsn_inventory/html/img/items/frozen_fries.png](#fsn-inventory-html-img-items-frozen-fries-png)
- [fsn_inventory/html/img/items/gas_canister.png](#fsn-inventory-html-img-items-gas-canister-png)
- [fsn_inventory/html/img/items/id.png](#fsn-inventory-html-img-items-id-png)
- [fsn_inventory/html/img/items/joint.png](#fsn-inventory-html-img-items-joint-png)
- [fsn_inventory/html/img/items/keycard.png](#fsn-inventory-html-img-items-keycard-png)
- [fsn_inventory/html/img/items/lockpick.png](#fsn-inventory-html-img-items-lockpick-png)
- [fsn_inventory/html/img/items/meth_rocks.png](#fsn-inventory-html-img-items-meth-rocks-png)
- [fsn_inventory/html/img/items/microwave_burrito.png](#fsn-inventory-html-img-items-microwave-burrito-png)
- [fsn_inventory/html/img/items/minced_meat.png](#fsn-inventory-html-img-items-minced-meat-png)
- [fsn_inventory/html/img/items/modified_drillbit.png](#fsn-inventory-html-img-items-modified-drillbit-png)
- [fsn_inventory/html/img/items/morphine.png](#fsn-inventory-html-img-items-morphine-png)
- [fsn_inventory/html/img/items/packaged_cocaine.png](#fsn-inventory-html-img-items-packaged-cocaine-png)
- [fsn_inventory/html/img/items/painkillers.png](#fsn-inventory-html-img-items-painkillers-png)
- [fsn_inventory/html/img/items/panini.png](#fsn-inventory-html-img-items-panini-png)
- [fsn_inventory/html/img/items/pepsi.png](#fsn-inventory-html-img-items-pepsi-png)
- [fsn_inventory/html/img/items/pepsi_max.png](#fsn-inventory-html-img-items-pepsi-max-png)
- [fsn_inventory/html/img/items/phone.png](#fsn-inventory-html-img-items-phone-png)
- [fsn_inventory/html/img/items/phosphorus.png](#fsn-inventory-html-img-items-phosphorus-png)
- [fsn_inventory/html/img/items/radio_receiver.png](#fsn-inventory-html-img-items-radio-receiver-png)
- [fsn_inventory/html/img/items/repair_kit.png](#fsn-inventory-html-img-items-repair-kit-png)
- [fsn_inventory/html/img/items/tuner_chip.png](#fsn-inventory-html-img-items-tuner-chip-png)
- [fsn_inventory/html/img/items/uncooked_meat.png](#fsn-inventory-html-img-items-uncooked-meat-png)
- [fsn_inventory/html/img/items/vpn1.png](#fsn-inventory-html-img-items-vpn1-png)
- [fsn_inventory/html/img/items/vpn2.png](#fsn-inventory-html-img-items-vpn2-png)
- [fsn_inventory/html/img/items/water.png](#fsn-inventory-html-img-items-water-png)
- [fsn_inventory/html/img/items/zipties.png](#fsn-inventory-html-img-items-zipties-png)
- [fsn_inventory/html/js/config.js](#fsn-inventory-html-js-config-js)
- [fsn_inventory/html/js/inventory.js](#fsn-inventory-html-js-inventory-js)
- [fsn_inventory/html/locales/cs.js](#fsn-inventory-html-locales-cs-js)
- [fsn_inventory/html/locales/en.js](#fsn-inventory-html-locales-en-js)
- [fsn_inventory/html/locales/fr.js](#fsn-inventory-html-locales-fr-js)
- [fsn_inventory/html/ui.html](#fsn-inventory-html-ui-html)
- [fsn_inventory/pd_locker/cl_locker.lua](#fsn-inventory-pd-locker-cl-locker-lua)
- [fsn_inventory/pd_locker/datastore.txt](#fsn-inventory-pd-locker-datastore-txt)
- [fsn_inventory/pd_locker/sv_locker.lua](#fsn-inventory-pd-locker-sv-locker-lua)
- [fsn_inventory/sv_inventory.lua](#fsn-inventory-sv-inventory-lua)
- [fsn_inventory/sv_presets.lua](#fsn-inventory-sv-presets-lua)
- [fsn_inventory/sv_vehicles.lua](#fsn-inventory-sv-vehicles-lua)
- [fsn_inventory_dropping/cl_dropping.lua](#fsn-inventory-dropping-cl-dropping-lua)
- [fsn_inventory_dropping/fxmanifest.lua](#fsn-inventory-dropping-fxmanifest-lua)
- [fsn_inventory_dropping/sv_dropping.lua](#fsn-inventory-dropping-sv-dropping-lua)
- [fsn_jail/client.lua](#fsn-jail-client-lua)
- [fsn_jail/fxmanifest.lua](#fsn-jail-fxmanifest-lua)
- [fsn_jail/server.lua](#fsn-jail-server-lua)
- [fsn_jewellerystore/client.lua](#fsn-jewellerystore-client-lua)
- [fsn_jewellerystore/fxmanifest.lua](#fsn-jewellerystore-fxmanifest-lua)
- [fsn_jewellerystore/server.lua](#fsn-jewellerystore-server-lua)
- [fsn_jobs/client.lua](#fsn-jobs-client-lua)
- [fsn_jobs/delivery/client.lua](#fsn-jobs-delivery-client-lua)
- [fsn_jobs/farming/client.lua](#fsn-jobs-farming-client-lua)
- [fsn_jobs/fxmanifest.lua](#fsn-jobs-fxmanifest-lua)
- [fsn_jobs/garbage/client.lua](#fsn-jobs-garbage-client-lua)
- [fsn_jobs/hunting/client.lua](#fsn-jobs-hunting-client-lua)
- [fsn_jobs/mechanic/client.lua](#fsn-jobs-mechanic-client-lua)
- [fsn_jobs/mechanic/mechmenu.lua](#fsn-jobs-mechanic-mechmenu-lua)
- [fsn_jobs/mechanic/server.lua](#fsn-jobs-mechanic-server-lua)
- [fsn_jobs/news/client.lua](#fsn-jobs-news-client-lua)
- [fsn_jobs/repo/client.lua](#fsn-jobs-repo-client-lua)
- [fsn_jobs/repo/server.lua](#fsn-jobs-repo-server-lua)
- [fsn_jobs/scrap/client.lua](#fsn-jobs-scrap-client-lua)
- [fsn_jobs/server.lua](#fsn-jobs-server-lua)
- [fsn_jobs/taxi/client.lua](#fsn-jobs-taxi-client-lua)
- [fsn_jobs/taxi/server.lua](#fsn-jobs-taxi-server-lua)
- [fsn_jobs/tow/client.lua](#fsn-jobs-tow-client-lua)
- [fsn_jobs/tow/server.lua](#fsn-jobs-tow-server-lua)
- [fsn_jobs/trucker/client.lua](#fsn-jobs-trucker-client-lua)
- [fsn_jobs/whitelists/client.lua](#fsn-jobs-whitelists-client-lua)
- [fsn_jobs/whitelists/server.lua](#fsn-jobs-whitelists-server-lua)
- [fsn_licenses/cl_desk.lua](#fsn-licenses-cl-desk-lua)
- [fsn_licenses/client.lua](#fsn-licenses-client-lua)
- [fsn_licenses/fxmanifest.lua](#fsn-licenses-fxmanifest-lua)
- [fsn_licenses/server.lua](#fsn-licenses-server-lua)
- [fsn_licenses/sv_desk.lua](#fsn-licenses-sv-desk-lua)
- [fsn_loadingscreen/fxmanifest.lua](#fsn-loadingscreen-fxmanifest-lua)
- [fsn_loadingscreen/index.html](#fsn-loadingscreen-index-html)
- [fsn_main/banmanager/sv_bans.lua](#fsn-main-banmanager-sv-bans-lua)
- [fsn_main/cl_utils.lua](#fsn-main-cl-utils-lua)
- [fsn_main/debug/cl_subframetime.js](#fsn-main-debug-cl-subframetime-js)
- [fsn_main/debug/sh_debug.lua](#fsn-main-debug-sh-debug-lua)
- [fsn_main/debug/sh_scheduler.lua](#fsn-main-debug-sh-scheduler-lua)
- [fsn_main/fxmanifest.lua](#fsn-main-fxmanifest-lua)
- [fsn_main/gui/index.html](#fsn-main-gui-index-html)
- [fsn_main/gui/index.js](#fsn-main-gui-index-js)
- [fsn_main/gui/logo_new.png](#fsn-main-gui-logo-new-png)
- [fsn_main/gui/logo_old.png](#fsn-main-gui-logo-old-png)
- [fsn_main/gui/logos/discord.png](#fsn-main-gui-logos-discord-png)
- [fsn_main/gui/logos/discord.psd](#fsn-main-gui-logos-discord-psd)
- [fsn_main/gui/logos/logo.png](#fsn-main-gui-logos-logo-png)
- [fsn_main/gui/logos/main.psd](#fsn-main-gui-logos-main-psd)
- [fsn_main/gui/motd.txt](#fsn-main-gui-motd-txt)
- [fsn_main/gui/pdown.ttf](#fsn-main-gui-pdown-ttf)
- [fsn_main/hud/client.lua](#fsn-main-hud-client-lua)
- [fsn_main/initial/client.lua](#fsn-main-initial-client-lua)
- [fsn_main/initial/desc.txt](#fsn-main-initial-desc-txt)
- [fsn_main/initial/server.lua](#fsn-main-initial-server-lua)
- [fsn_main/misc/db.lua](#fsn-main-misc-db-lua)
- [fsn_main/misc/logging.lua](#fsn-main-misc-logging-lua)
- [fsn_main/misc/servername.lua](#fsn-main-misc-servername-lua)
- [fsn_main/misc/shitlordjumping.lua](#fsn-main-misc-shitlordjumping-lua)
- [fsn_main/misc/timer.lua](#fsn-main-misc-timer-lua)
- [fsn_main/misc/version.lua](#fsn-main-misc-version-lua)
- [fsn_main/money/client.lua](#fsn-main-money-client-lua)
- [fsn_main/money/server.lua](#fsn-main-money-server-lua)
- [fsn_main/playermanager/client.lua](#fsn-main-playermanager-client-lua)
- [fsn_main/playermanager/server.lua](#fsn-main-playermanager-server-lua)
- [fsn_main/server_settings/sh_settings.lua](#fsn-main-server-settings-sh-settings-lua)
- [fsn_main/sv_utils.lua](#fsn-main-sv-utils-lua)
- [fsn_menu/fxmanifest.lua](#fsn-menu-fxmanifest-lua)
- [fsn_menu/gui/ui.css](#fsn-menu-gui-ui-css)
- [fsn_menu/gui/ui.html](#fsn-menu-gui-ui-html)
- [fsn_menu/gui/ui.js](#fsn-menu-gui-ui-js)
- [fsn_menu/main_client.lua](#fsn-menu-main-client-lua)
- [fsn_menu/ui.css](#fsn-menu-ui-css)
- [fsn_menu/ui.html](#fsn-menu-ui-html)
- [fsn_menu/ui.js](#fsn-menu-ui-js)
- [fsn_needs/client.lua](#fsn-needs-client-lua)
- [fsn_needs/fxmanifest.lua](#fsn-needs-fxmanifest-lua)
- [fsn_needs/hud.lua](#fsn-needs-hud-lua)
- [fsn_needs/vending.lua](#fsn-needs-vending-lua)
- [fsn_newchat/README.md](#fsn-newchat-readme-md)
- [fsn_newchat/cl_chat.lua](#fsn-newchat-cl-chat-lua)
- [fsn_newchat/fxmanifest.lua](#fsn-newchat-fxmanifest-lua)
- [fsn_newchat/html/App.js](#fsn-newchat-html-app-js)
- [fsn_newchat/html/Message.js](#fsn-newchat-html-message-js)
- [fsn_newchat/html/Suggestions.js](#fsn-newchat-html-suggestions-js)
- [fsn_newchat/html/config.default.js](#fsn-newchat-html-config-default-js)
- [fsn_newchat/html/index.css](#fsn-newchat-html-index-css)
- [fsn_newchat/html/index.html](#fsn-newchat-html-index-html)
- [fsn_newchat/html/vendor/animate.3.5.2.min.css](#fsn-newchat-html-vendor-animate-3-5-2-min-css)
- [fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css](#fsn-newchat-html-vendor-flexboxgrid-6-3-1-min-css)
- [fsn_newchat/html/vendor/fonts/LatoBold.woff2](#fsn-newchat-html-vendor-fonts-latobold-woff2)
- [fsn_newchat/html/vendor/fonts/LatoBold2.woff2](#fsn-newchat-html-vendor-fonts-latobold2-woff2)
- [fsn_newchat/html/vendor/fonts/LatoLight.woff2](#fsn-newchat-html-vendor-fonts-latolight-woff2)
- [fsn_newchat/html/vendor/fonts/LatoLight2.woff2](#fsn-newchat-html-vendor-fonts-latolight2-woff2)
- [fsn_newchat/html/vendor/fonts/LatoRegular.woff2](#fsn-newchat-html-vendor-fonts-latoregular-woff2)
- [fsn_newchat/html/vendor/fonts/LatoRegular2.woff2](#fsn-newchat-html-vendor-fonts-latoregular2-woff2)
- [fsn_newchat/html/vendor/latofonts.css](#fsn-newchat-html-vendor-latofonts-css)
- [fsn_newchat/html/vendor/vue.2.3.3.min.js](#fsn-newchat-html-vendor-vue-2-3-3-min-js)
- [fsn_newchat/sv_chat.lua](#fsn-newchat-sv-chat-lua)
- [fsn_notify/cl_notify.lua](#fsn-notify-cl-notify-lua)
- [fsn_notify/fxmanifest.lua](#fsn-notify-fxmanifest-lua)
- [fsn_notify/html/index.html](#fsn-notify-html-index-html)
- [fsn_notify/html/noty.css](#fsn-notify-html-noty-css)
- [fsn_notify/html/noty.js](#fsn-notify-html-noty-js)
- [fsn_notify/html/noty_license.txt](#fsn-notify-html-noty-license-txt)
- [fsn_notify/html/pNotify.js](#fsn-notify-html-pnotify-js)
- [fsn_notify/html/themes.css](#fsn-notify-html-themes-css)
- [fsn_notify/server.lua](#fsn-notify-server-lua)
- [fsn_phones/cl_phone.lua](#fsn-phones-cl-phone-lua)
- [fsn_phones/darkweb/cl_order.lua](#fsn-phones-darkweb-cl-order-lua)
- [fsn_phones/datastore/contacts/sample.txt](#fsn-phones-datastore-contacts-sample-txt)
- [fsn_phones/datastore/messages/sample.txt](#fsn-phones-datastore-messages-sample-txt)
- [fsn_phones/fxmanifest.lua](#fsn-phones-fxmanifest-lua)
- [fsn_phones/html/img/Apple/Ads.png](#fsn-phones-html-img-apple-ads-png)
- [fsn_phones/html/img/Apple/Banner/Adverts.png](#fsn-phones-html-img-apple-banner-adverts-png)
- [fsn_phones/html/img/Apple/Banner/Grey.png](#fsn-phones-html-img-apple-banner-grey-png)
- [fsn_phones/html/img/Apple/Banner/Yellow.png](#fsn-phones-html-img-apple-banner-yellow-png)
- [fsn_phones/html/img/Apple/Banner/fleeca.png](#fsn-phones-html-img-apple-banner-fleeca-png)
- [fsn_phones/html/img/Apple/Banner/log-inBackground.png](#fsn-phones-html-img-apple-banner-log-inbackground-png)
- [fsn_phones/html/img/Apple/Contact.png](#fsn-phones-html-img-apple-contact-png)
- [fsn_phones/html/img/Apple/Fleeca.png](#fsn-phones-html-img-apple-fleeca-png)
- [fsn_phones/html/img/Apple/Frame.png](#fsn-phones-html-img-apple-frame-png)
- [fsn_phones/html/img/Apple/Garage.png](#fsn-phones-html-img-apple-garage-png)
- [fsn_phones/html/img/Apple/Lock icon.png](#fsn-phones-html-img-apple-lock-icon-png)
- [fsn_phones/html/img/Apple/Mail.png](#fsn-phones-html-img-apple-mail-png)
- [fsn_phones/html/img/Apple/Messages.png](#fsn-phones-html-img-apple-messages-png)
- [fsn_phones/html/img/Apple/Noti.png](#fsn-phones-html-img-apple-noti-png)
- [fsn_phones/html/img/Apple/Phone.png](#fsn-phones-html-img-apple-phone-png)
- [fsn_phones/html/img/Apple/Twitter.png](#fsn-phones-html-img-apple-twitter-png)
- [fsn_phones/html/img/Apple/Wallet.png](#fsn-phones-html-img-apple-wallet-png)
- [fsn_phones/html/img/Apple/Whitelist.png](#fsn-phones-html-img-apple-whitelist-png)
- [fsn_phones/html/img/Apple/banner_icons/adverts.png](#fsn-phones-html-img-apple-banner-icons-adverts-png)
- [fsn_phones/html/img/Apple/banner_icons/call.png](#fsn-phones-html-img-apple-banner-icons-call-png)
- [fsn_phones/html/img/Apple/banner_icons/contacts.png](#fsn-phones-html-img-apple-banner-icons-contacts-png)
- [fsn_phones/html/img/Apple/banner_icons/fleeca.png](#fsn-phones-html-img-apple-banner-icons-fleeca-png)
- [fsn_phones/html/img/Apple/banner_icons/garage.png](#fsn-phones-html-img-apple-banner-icons-garage-png)
- [fsn_phones/html/img/Apple/banner_icons/mail.png](#fsn-phones-html-img-apple-banner-icons-mail-png)
- [fsn_phones/html/img/Apple/banner_icons/messages.png](#fsn-phones-html-img-apple-banner-icons-messages-png)
- [fsn_phones/html/img/Apple/banner_icons/twitter.png](#fsn-phones-html-img-apple-banner-icons-twitter-png)
- [fsn_phones/html/img/Apple/banner_icons/wallet.png](#fsn-phones-html-img-apple-banner-icons-wallet-png)
- [fsn_phones/html/img/Apple/banner_icons/wl.png](#fsn-phones-html-img-apple-banner-icons-wl-png)
- [fsn_phones/html/img/Apple/battery.png](#fsn-phones-html-img-apple-battery-png)
- [fsn_phones/html/img/Apple/call-in.png](#fsn-phones-html-img-apple-call-in-png)
- [fsn_phones/html/img/Apple/call-out.png](#fsn-phones-html-img-apple-call-out-png)
- [fsn_phones/html/img/Apple/darkweb.png](#fsn-phones-html-img-apple-darkweb-png)
- [fsn_phones/html/img/Apple/default-avatar.png](#fsn-phones-html-img-apple-default-avatar-png)
- [fsn_phones/html/img/Apple/feedgrey.png](#fsn-phones-html-img-apple-feedgrey-png)
- [fsn_phones/html/img/Apple/fleeca-bg.png](#fsn-phones-html-img-apple-fleeca-bg-png)
- [fsn_phones/html/img/Apple/missed-in.png](#fsn-phones-html-img-apple-missed-in-png)
- [fsn_phones/html/img/Apple/missed-out.png](#fsn-phones-html-img-apple-missed-out-png)
- [fsn_phones/html/img/Apple/node_other_server__1247323.png](#fsn-phones-html-img-apple-node-other-server-1247323-png)
- [fsn_phones/html/img/Apple/signal.png](#fsn-phones-html-img-apple-signal-png)
- [fsn_phones/html/img/Apple/wallpaper.png](#fsn-phones-html-img-apple-wallpaper-png)
- [fsn_phones/html/img/Apple/wifi.png](#fsn-phones-html-img-apple-wifi-png)
- [fsn_phones/html/img/cursor.png](#fsn-phones-html-img-cursor-png)
- [fsn_phones/html/index.css](#fsn-phones-html-index-css)
- [fsn_phones/html/index.html](#fsn-phones-html-index-html)
- [fsn_phones/html/index.html.old](#fsn-phones-html-index-html-old)
- [fsn_phones/html/index.js](#fsn-phones-html-index-js)
- [fsn_phones/html/pages_css/iphone/adverts.css](#fsn-phones-html-pages-css-iphone-adverts-css)
- [fsn_phones/html/pages_css/iphone/call.css](#fsn-phones-html-pages-css-iphone-call-css)
- [fsn_phones/html/pages_css/iphone/contacts.css](#fsn-phones-html-pages-css-iphone-contacts-css)
- [fsn_phones/html/pages_css/iphone/darkweb.css](#fsn-phones-html-pages-css-iphone-darkweb-css)
- [fsn_phones/html/pages_css/iphone/email.css](#fsn-phones-html-pages-css-iphone-email-css)
- [fsn_phones/html/pages_css/iphone/fleeca.css](#fsn-phones-html-pages-css-iphone-fleeca-css)
- [fsn_phones/html/pages_css/iphone/garage.css](#fsn-phones-html-pages-css-iphone-garage-css)
- [fsn_phones/html/pages_css/iphone/home.css](#fsn-phones-html-pages-css-iphone-home-css)
- [fsn_phones/html/pages_css/iphone/main.css](#fsn-phones-html-pages-css-iphone-main-css)
- [fsn_phones/html/pages_css/iphone/messages.css](#fsn-phones-html-pages-css-iphone-messages-css)
- [fsn_phones/html/pages_css/iphone/pay.css](#fsn-phones-html-pages-css-iphone-pay-css)
- [fsn_phones/html/pages_css/iphone/phone.css](#fsn-phones-html-pages-css-iphone-phone-css)
- [fsn_phones/html/pages_css/iphone/twitter.css](#fsn-phones-html-pages-css-iphone-twitter-css)
- [fsn_phones/html/pages_css/iphone/whitelists.css](#fsn-phones-html-pages-css-iphone-whitelists-css)
- [fsn_phones/html/pages_css/samsung/adverts.css](#fsn-phones-html-pages-css-samsung-adverts-css)
- [fsn_phones/html/pages_css/samsung/call.css](#fsn-phones-html-pages-css-samsung-call-css)
- [fsn_phones/html/pages_css/samsung/contacts.css](#fsn-phones-html-pages-css-samsung-contacts-css)
- [fsn_phones/html/pages_css/samsung/email.css](#fsn-phones-html-pages-css-samsung-email-css)
- [fsn_phones/html/pages_css/samsung/fleeca.css](#fsn-phones-html-pages-css-samsung-fleeca-css)
- [fsn_phones/html/pages_css/samsung/home.css](#fsn-phones-html-pages-css-samsung-home-css)
- [fsn_phones/html/pages_css/samsung/main.css](#fsn-phones-html-pages-css-samsung-main-css)
- [fsn_phones/html/pages_css/samsung/messages.css](#fsn-phones-html-pages-css-samsung-messages-css)
- [fsn_phones/html/pages_css/samsung/pay.css](#fsn-phones-html-pages-css-samsung-pay-css)
- [fsn_phones/html/pages_css/samsung/phone.css](#fsn-phones-html-pages-css-samsung-phone-css)
- [fsn_phones/html/pages_css/samsung/twitter.css](#fsn-phones-html-pages-css-samsung-twitter-css)
- [fsn_phones/html/pages_css/samsung/whitelists.css](#fsn-phones-html-pages-css-samsung-whitelists-css)
- [fsn_phones/sv_phone.lua](#fsn-phones-sv-phone-lua)
- [fsn_playerlist/client.lua](#fsn-playerlist-client-lua)
- [fsn_playerlist/fxmanifest.lua](#fsn-playerlist-fxmanifest-lua)
- [fsn_playerlist/gui/index.html](#fsn-playerlist-gui-index-html)
- [fsn_playerlist/gui/index.js](#fsn-playerlist-gui-index-js)
- [fsn_police/K9/client.lua](#fsn-police-k9-client-lua)
- [fsn_police/K9/server.lua](#fsn-police-k9-server-lua)
- [fsn_police/MDT/gui/images/background.png](#fsn-police-mdt-gui-images-background-png)
- [fsn_police/MDT/gui/images/base_pc.png](#fsn-police-mdt-gui-images-base-pc-png)
- [fsn_police/MDT/gui/images/icons/booking.png](#fsn-police-mdt-gui-images-icons-booking-png)
- [fsn_police/MDT/gui/images/icons/cpic.png](#fsn-police-mdt-gui-images-icons-cpic-png)
- [fsn_police/MDT/gui/images/icons/dmv.png](#fsn-police-mdt-gui-images-icons-dmv-png)
- [fsn_police/MDT/gui/images/icons/warrants.png](#fsn-police-mdt-gui-images-icons-warrants-png)
- [fsn_police/MDT/gui/images/pwr_icon.png](#fsn-police-mdt-gui-images-pwr-icon-png)
- [fsn_police/MDT/gui/images/win_icon.png](#fsn-police-mdt-gui-images-win-icon-png)
- [fsn_police/MDT/gui/index.css](#fsn-police-mdt-gui-index-css)
- [fsn_police/MDT/gui/index.html](#fsn-police-mdt-gui-index-html)
- [fsn_police/MDT/gui/index.js](#fsn-police-mdt-gui-index-js)
- [fsn_police/MDT/mdt_client.lua](#fsn-police-mdt-mdt-client-lua)
- [fsn_police/MDT/mdt_server.lua](#fsn-police-mdt-mdt-server-lua)
- [fsn_police/armory/cl_armory.lua](#fsn-police-armory-cl-armory-lua)
- [fsn_police/armory/sv_armory.lua](#fsn-police-armory-sv-armory-lua)
- [fsn_police/client.lua](#fsn-police-client-lua)
- [fsn_police/dispatch.lua](#fsn-police-dispatch-lua)
- [fsn_police/dispatch/client.lua](#fsn-police-dispatch-client-lua)
- [fsn_police/fxmanifest.lua](#fsn-police-fxmanifest-lua)
- [fsn_police/pedmanagement/client.lua](#fsn-police-pedmanagement-client-lua)
- [fsn_police/pedmanagement/server.lua](#fsn-police-pedmanagement-server-lua)
- [fsn_police/radar/client.lua](#fsn-police-radar-client-lua)
- [fsn_police/server.lua](#fsn-police-server-lua)
- [fsn_police/tackle/client.lua](#fsn-police-tackle-client-lua)
- [fsn_police/tackle/server.lua](#fsn-police-tackle-server-lua)
- [fsn_priority/administration.lua](#fsn-priority-administration-lua)
- [fsn_priority/fxmanifest.lua](#fsn-priority-fxmanifest-lua)
- [fsn_priority/server.lua](#fsn-priority-server-lua)
- [fsn_progress/client.lua](#fsn-progress-client-lua)
- [fsn_progress/fxmanifest.lua](#fsn-progress-fxmanifest-lua)
- [fsn_progress/gui/index.html](#fsn-progress-gui-index-html)
- [fsn_progress/gui/index.js](#fsn-progress-gui-index-js)
- [fsn_properties/cl_manage.lua](#fsn-properties-cl-manage-lua)
- [fsn_properties/cl_properties.lua](#fsn-properties-cl-properties-lua)
- [fsn_properties/fxmanifest.lua](#fsn-properties-fxmanifest-lua)
- [fsn_properties/nui/ui.css](#fsn-properties-nui-ui-css)
- [fsn_properties/nui/ui.html](#fsn-properties-nui-ui-html)
- [fsn_properties/nui/ui.js](#fsn-properties-nui-ui-js)
- [fsn_properties/sv_conversion.lua](#fsn-properties-sv-conversion-lua)
- [fsn_properties/sv_properties.lua](#fsn-properties-sv-properties-lua)
- [fsn_shootingrange/client.lua](#fsn-shootingrange-client-lua)
- [fsn_shootingrange/fxmanifest.lua](#fsn-shootingrange-fxmanifest-lua)
- [fsn_shootingrange/server.lua](#fsn-shootingrange-server-lua)
- [fsn_spawnmanager/client.lua](#fsn-spawnmanager-client-lua)
- [fsn_spawnmanager/fxmanifest.lua](#fsn-spawnmanager-fxmanifest-lua)
- [fsn_spawnmanager/nui/index.css](#fsn-spawnmanager-nui-index-css)
- [fsn_spawnmanager/nui/index.html](#fsn-spawnmanager-nui-index-html)
- [fsn_spawnmanager/nui/index.js](#fsn-spawnmanager-nui-index-js)
- [fsn_steamlogin/client.lua](#fsn-steamlogin-client-lua)
- [fsn_steamlogin/fxmanifest.lua](#fsn-steamlogin-fxmanifest-lua)
- [fsn_storagelockers/client.lua](#fsn-storagelockers-client-lua)
- [fsn_storagelockers/fxmanifest.lua](#fsn-storagelockers-fxmanifest-lua)
- [fsn_storagelockers/nui/ui.css](#fsn-storagelockers-nui-ui-css)
- [fsn_storagelockers/nui/ui.html](#fsn-storagelockers-nui-ui-html)
- [fsn_storagelockers/nui/ui.js](#fsn-storagelockers-nui-ui-js)
- [fsn_storagelockers/server.lua](#fsn-storagelockers-server-lua)
- [fsn_store/client.lua](#fsn-store-client-lua)
- [fsn_store/fxmanifest.lua](#fsn-store-fxmanifest-lua)
- [fsn_store/server.lua](#fsn-store-server-lua)
- [fsn_store_guns/client.lua](#fsn-store-guns-client-lua)
- [fsn_store_guns/fxmanifest.lua](#fsn-store-guns-fxmanifest-lua)
- [fsn_store_guns/server.lua](#fsn-store-guns-server-lua)
- [fsn_stripclub/client.lua](#fsn-stripclub-client-lua)
- [fsn_stripclub/fxmanifest.lua](#fsn-stripclub-fxmanifest-lua)
- [fsn_stripclub/server.lua](#fsn-stripclub-server-lua)
- [fsn_teleporters/client.lua](#fsn-teleporters-client-lua)
- [fsn_teleporters/fxmanifest.lua](#fsn-teleporters-fxmanifest-lua)
- [fsn_timeandweather/client.lua](#fsn-timeandweather-client-lua)
- [fsn_timeandweather/fxmanifest.lua](#fsn-timeandweather-fxmanifest-lua)
- [fsn_timeandweather/server.lua](#fsn-timeandweather-server-lua)
- [fsn_timeandweather/timecycle_mods_4.xml](#fsn-timeandweather-timecycle-mods-4-xml)
- [fsn_timeandweather/w_blizzard.xml](#fsn-timeandweather-w-blizzard-xml)
- [fsn_timeandweather/w_clear.xml](#fsn-timeandweather-w-clear-xml)
- [fsn_timeandweather/w_clearing.xml](#fsn-timeandweather-w-clearing-xml)
- [fsn_timeandweather/w_clouds.xml](#fsn-timeandweather-w-clouds-xml)
- [fsn_timeandweather/w_extrasunny.xml](#fsn-timeandweather-w-extrasunny-xml)
- [fsn_timeandweather/w_foggy.xml](#fsn-timeandweather-w-foggy-xml)
- [fsn_timeandweather/w_neutral.xml](#fsn-timeandweather-w-neutral-xml)
- [fsn_timeandweather/w_overcast.xml](#fsn-timeandweather-w-overcast-xml)
- [fsn_timeandweather/w_rain.xml](#fsn-timeandweather-w-rain-xml)
- [fsn_timeandweather/w_smog.xml](#fsn-timeandweather-w-smog-xml)
- [fsn_timeandweather/w_snow.xml](#fsn-timeandweather-w-snow-xml)
- [fsn_timeandweather/w_snowlight.xml](#fsn-timeandweather-w-snowlight-xml)
- [fsn_timeandweather/w_thunder.xml](#fsn-timeandweather-w-thunder-xml)
- [fsn_timeandweather/w_xmas.xml](#fsn-timeandweather-w-xmas-xml)
- [fsn_vehiclecontrol/aircontrol/aircontrol.lua](#fsn-vehiclecontrol-aircontrol-aircontrol-lua)
- [fsn_vehiclecontrol/carhud/carhud.lua](#fsn-vehiclecontrol-carhud-carhud-lua)
- [fsn_vehiclecontrol/carwash/client.lua](#fsn-vehiclecontrol-carwash-client-lua)
- [fsn_vehiclecontrol/client.lua](#fsn-vehiclecontrol-client-lua)
- [fsn_vehiclecontrol/compass/compass.lua](#fsn-vehiclecontrol-compass-compass-lua)
- [fsn_vehiclecontrol/compass/essentials.lua](#fsn-vehiclecontrol-compass-essentials-lua)
- [fsn_vehiclecontrol/compass/streetname.lua](#fsn-vehiclecontrol-compass-streetname-lua)
- [fsn_vehiclecontrol/damage/cl_crashes.lua](#fsn-vehiclecontrol-damage-cl-crashes-lua)
- [fsn_vehiclecontrol/damage/client.lua](#fsn-vehiclecontrol-damage-client-lua)
- [fsn_vehiclecontrol/damage/config.lua](#fsn-vehiclecontrol-damage-config-lua)
- [fsn_vehiclecontrol/engine/client.lua](#fsn-vehiclecontrol-engine-client-lua)
- [fsn_vehiclecontrol/fuel/client.lua](#fsn-vehiclecontrol-fuel-client-lua)
- [fsn_vehiclecontrol/fuel/server.lua](#fsn-vehiclecontrol-fuel-server-lua)
- [fsn_vehiclecontrol/fxmanifest.lua](#fsn-vehiclecontrol-fxmanifest-lua)
- [fsn_vehiclecontrol/holdup/client.lua](#fsn-vehiclecontrol-holdup-client-lua)
- [fsn_vehiclecontrol/inventory/client.lua](#fsn-vehiclecontrol-inventory-client-lua)
- [fsn_vehiclecontrol/inventory/server.lua](#fsn-vehiclecontrol-inventory-server-lua)
- [fsn_vehiclecontrol/keys/server.lua](#fsn-vehiclecontrol-keys-server-lua)
- [fsn_vehiclecontrol/odometer/client.lua](#fsn-vehiclecontrol-odometer-client-lua)
- [fsn_vehiclecontrol/odometer/server.lua](#fsn-vehiclecontrol-odometer-server-lua)
- [fsn_vehiclecontrol/speedcameras/client.lua](#fsn-vehiclecontrol-speedcameras-client-lua)
- [fsn_vehiclecontrol/trunk/client.lua](#fsn-vehiclecontrol-trunk-client-lua)
- [fsn_vehiclecontrol/trunk/server.lua](#fsn-vehiclecontrol-trunk-server-lua)
- [fsn_voicecontrol/client.lua](#fsn-voicecontrol-client-lua)
- [fsn_voicecontrol/fxmanifest.lua](#fsn-voicecontrol-fxmanifest-lua)
- [fsn_voicecontrol/server.lua](#fsn-voicecontrol-server-lua)
- [fsn_weaponcontrol/client.lua](#fsn-weaponcontrol-client-lua)
- [fsn_weaponcontrol/fxmanifest.lua](#fsn-weaponcontrol-fxmanifest-lua)
- [fsn_weaponcontrol/server.lua](#fsn-weaponcontrol-server-lua)
- [pipeline.yml](#pipeline-yml)

## README.md

*Role:* shared
*DB Calls:* - Local/Remote MySQL database server, - MySQL Server

## fsn_activities/fishing/client.lua

*Role:* client

## fsn_activities/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_activities/hunting/client.lua

*Role:* client

## fsn_activities/yoga/client.lua

*Role:* client
*Events:* register: fsn_yoga:checkStress, handler: fsn_yoga:checkStress, trigger: fsn_needs:stress:remove, fsn_yoga:checkStress
*Exports:* mythic_notify

## fsn_admin/client.lua

*Role:* client
*Events:* register: fsn_admin:FreezeMe, fsn_admin:recieveXYZ, fsn_admin:requestXYZ, handler: fsn_admin:FreezeMe, fsn_admin:recieveXYZ, fsn_admin:requestXYZ, trigger: chatMessage, fsn_admin:sendXYZ

## fsn_admin/client/client.lua

*Role:* client
*Events:* register: fsn_admin:FreezeMe, fsn_admin:recieveXYZ, fsn_admin:requestXYZ, fsn_admin:spawnVehicle, handler: fsn_admin:FreezeMe, fsn_admin:recieveXYZ, fsn_admin:requestXYZ, fsn_admin:spawnVehicle, trigger: chat:addMessage, fsn_admin:sendXYZ, fsn_cargarage:makeMine, fsn_notify:displayNotification
*Exports:* LegacyFuel

## fsn_admin/config.lua

*Role:* shared

## fsn_admin/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua',

## fsn_admin/oldresource.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_admin/server.lua

*Role:* server
*Events:* register: fsn_admin:fix, fsn_admin:sendXYZ, fsn_admin:spawnCar, handler: chatMessage, fsn_admin:fix, fsn_admin:sendXYZ, fsn_admin:spawnCar, trigger: chatMessage, fsn_admin:FreezeMe, fsn_admin:menu:toggle, fsn_admin:recieveXYZ, fsn_admin:requestXYZ, fsn_cargarage:makeMine, fsn_notify:displayNotification
*DB Calls:* MySQL.Async.execute('UPDATE `fsn_users` SET `banned` = @unban, `banned_r` = @reason WHERE `steamid` = @steamid', {['@unban']=unbantime, ['@reason']=reason, ['@steamid']=steamid}, function(rowsChanged)end)

## fsn_admin/server/server.lua

*Role:* server
*Events:* register: fsn:playerReady, fsn_admin:enableAdminCommands, fsn_admin:enableModeratorCommands, handler: fsn:playerReady, fsn_admin:enableAdminCommands, fsn_admin:enableModeratorCommands, onResourceStart, trigger: chat:addMessage, chat:addSuggestion, fsn:getFsnObject, fsn_admin:FreezeMe, fsn_admin:enableAdminCommands, fsn_admin:enableModeratorCommands, fsn_admin:requestXYZ
*Commands:* adminmenu, amenu, announce, ban, bring, freeze, goto, kick, sc
*DB Calls:* MySQL.Async.execute('UPDATE fsn_users SET banned = @unban, banned_r = @reason, WHERE steamid = @steamId', {

## fsn_admin/server_announce.lua

*Role:* server
*Events:* trigger: chatMessage

## fsn_apartments/cl_instancing.lua

*Role:* client
*Events:* register: fsn_apartments:instance:debug, fsn_apartments:instance:join, fsn_apartments:instance:leave, fsn_apartments:instance:update, handler: fsn_apartments:instance:debug, fsn_apartments:instance:join, fsn_apartments:instance:leave, fsn_apartments:instance:update

## fsn_apartments/client.lua

*Role:* client
*Events:* register: fsn_apartments:characterCreation, fsn_apartments:inv:update, fsn_apartments:outfit:add, fsn_apartments:outfit:list, fsn_apartments:outfit:remove, fsn_apartments:outfit:use, fsn_apartments:sendApartment, fsn_apartments:stash:add, fsn_apartments:stash:take, handler: fsn_apartments:characterCreation, fsn_apartments:inv:update, fsn_apartments:outfit:add, fsn_apartments:outfit:list, fsn_apartments:outfit:remove, fsn_apartments:outfit:use, fsn_apartments:sendApartment, fsn_apartments:stash:add, fsn_apartments:stash:take, trigger: chatMessage, clothes:spawn, fsn_apartments:createApartment, fsn_apartments:instance:leave, fsn_apartments:instance:new, fsn_apartments:saveApartment, fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_clothing:menu, fsn_criminalmisc:weapons:add:tbl, fsn_criminalmisc:weapons:destroy, fsn_inventory:apt:recieve, fsn_notify:displayNotification, fsn_spawnmanager:start
*Exports:* fsn_clothing, fsn_criminalmisc, fsn_inventory, fsn_main, mythic_notify
*NUI Callbacks:* escape
*NUI Messages:* SendNUIMessage

## fsn_apartments/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_apartments/gui/ui.css

*Role:* NUI

## fsn_apartments/gui/ui.html

*Role:* NUI

## fsn_apartments/gui/ui.js

*Role:* NUI

## fsn_apartments/server.lua

*Role:* server
*Events:* register: fsn_apartments:createApartment, fsn_apartments:getApartment, fsn_apartments:saveApartment, handler: chatMessage, fsn_apartments:createApartment, fsn_apartments:getApartment, fsn_apartments:saveApartment, playerDropped, trigger: chatMessage, fsn_apartments:characterCreation, fsn_apartments:outfit:add, fsn_apartments:outfit:list, fsn_apartments:outfit:remove, fsn_apartments:outfit:use, fsn_apartments:sendApartment, fsn_apartments:stash:add, fsn_apartments:stash:take
*DB Calls:* MySQL.Sync.execute("UPDATE `fsn_apartments` SET `apt_inventory` = @inv, `apt_cash` = @cash, `apt_outfits` = @outfits, `apt_utils` = @utils WHERE `fsn_apartments`.`apt_id` = @id;", {, MySQL.Sync.execute(SQL), local appt = MySQL.Sync.fetchAll("SELECT * FROM `fsn_apartments` WHERE `apt_owner` = '"..char_id.."'")

## fsn_apartments/sv_instancing.lua

*Role:* server
*Events:* register: fsn_apartments:instance, fsn_apartments:instance:join, fsn_apartments:instance:leave, fsn_apartments:instance:new, handler: fsn_apartments:instance:join, fsn_apartments:instance:leave, fsn_apartments:instance:new, trigger: chatMessage, fsn_apartments:instance:join, fsn_apartments:instance:leave, fsn_apartments:instance:update

## fsn_bank/client.lua

*Role:* client
*Events:* register: fsn_bank:change:bankandwallet, fsn_bank:request:both, fsn_bank:update:both, handler: fsn_bank:update:both, trigger: fsn_bank:change:bankandwallet, fsn_bank:request:both, fsn_bank:transfer, fsn_main:displayBankandMoney, fsn_main:logging:addLog, fsn_notify:displayNotification, fsn_phones:SYS:addTransaction
*Exports:* fsn_main
*NUI Callbacks:* depositMoney, toggleGUI, transferMoney, withdrawMoney
*NUI Messages:* SendNUIMessage

## fsn_bank/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_bank/gui/atm_button_sound.mp3

*Role:* shared

## fsn_bank/gui/atm_logo.png

*Role:* shared

## fsn_bank/gui/index.css

*Role:* NUI

## fsn_bank/gui/index.html

*Role:* NUI

## fsn_bank/gui/index.js

*Role:* NUI

## fsn_bank/server.lua

*Role:* server
*Events:* register: fsn_bank:database:update, fsn_bank:transfer, handler: fsn_bank:database:update, fsn_bank:transfer, trigger: fsn_bank:change:bankAdd, fsn_bank:change:bankMinus, fsn_notify:displayNotification
*DB Calls:* --  MySQL.Sync.execute("UPDATE fsn_characters SET char_money=@wallet, char_bank=@bank WHERE char_id=@char_id", {['@char_id'] = charid, ['@wallet'] = wallet, ['@bank'] = bank}), MySQL.Sync.execute("UPDATE fsn_characters SET char_bank=@bank WHERE char_id=@char_id", {['@char_id'] = charid, ['@bank'] = bank}), MySQL.Sync.execute("UPDATE fsn_characters SET char_money=@wallet WHERE char_id=@char_id", {['@char_id'] = charid, ['@wallet'] = wallet})

## fsn_bankrobbery/cl_frontdesks.lua

*Role:* client
*Events:* register: fsn_bankrobbery:desks:receive, handler: fsn_bankrobbery:desks:receive, trigger: fsn_bankrobbery:desks:endHack, fsn_bankrobbery:desks:request, fsn_bankrobbery:desks:startHack, fsn_needs:stress:add, mhacking:hide, mhacking:show, mhacking:start

## fsn_bankrobbery/cl_safeanim.lua

*Role:* client
*Events:* register: safecracking:loop, safecracking:start, handler: safecracking:loop, safecracking:start, trigger: DoLongHudText, safe:success, safecracking:loop, safecracking:start

## fsn_bankrobbery/client.lua

*Role:* client
*Events:* register: fsn_bankrobbery:LostMC:spawn, fsn_bankrobbery:closeDoor, fsn_bankrobbery:init, fsn_bankrobbery:openDoor, fsn_bankrobbery:timer, handler: fsn_bankrobbery:LostMC:spawn, fsn_bankrobbery:closeDoor, fsn_bankrobbery:init, fsn_bankrobbery:openDoor, fsn_bankrobbery:timer, fsn_main:character, trigger: chatMessage, fsn_bankrobbery:closeDoor, fsn_bankrobbery:init, fsn_bankrobbery:openDoor, fsn_bankrobbery:payout, fsn_bankrobbery:start, fsn_bankrobbery:vault:close, fsn_bankrobbery:vault:open, fsn_inventory:item:add, fsn_inventory:item:take, fsn_notify:displayNotification, fsn_police:dispatch
*Exports:* fsn_entfinder, fsn_inventory, fsn_police

## fsn_bankrobbery/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_bankrobbery/server.lua

*Role:* server
*Events:* register: fsn_bankrobbery:init, fsn_bankrobbery:payout, fsn_bankrobbery:start, fsn_bankrobbery:vault:close, fsn_bankrobbery:vault:open, handler: fsn_bankrobbery:init, fsn_bankrobbery:payout, fsn_bankrobbery:start, fsn_bankrobbery:vault:close, fsn_bankrobbery:vault:open, fsn_main:money:bank:Add, fsn_main:money:bank:Minus, trigger: fsn_bankrobbery:closeDoor, fsn_bankrobbery:init, fsn_bankrobbery:openDoor, fsn_bankrobbery:timer, fsn_inventory:item:add, fsn_needs:stress:add, fsn_notify:displayNotification

## fsn_bankrobbery/sv_frontdesks.lua

*Role:* server
*Events:* register: fsn_bankrobbery:desks:doorUnlock, fsn_bankrobbery:desks:endHack, fsn_bankrobbery:desks:request, fsn_bankrobbery:desks:startHack, handler: fsn_bankrobbery:desks:doorUnlock, fsn_bankrobbery:desks:endHack, fsn_bankrobbery:desks:request, fsn_bankrobbery:desks:startHack, trigger: fsn_bank:change:bankAdd, fsn_bankrobbery:desks:receive, mythic_notify:client:SendAlert

## fsn_bankrobbery/trucks.lua

*Role:* shared
*Events:* trigger: fs_freemode:displaytext, fs_freemode:missionComplete, fs_freemode:notify, fsn_inventory:item:add, fsn_notify:displayNotification, fsn_phone:recieveMessage
*Exports:* fsn_inventory

## fsn_bennys/cl_bennys.lua

*Role:* client
*Exports:* fsn_main, mythic_notify

## fsn_bennys/cl_config.lua

*Role:* client

## fsn_bennys/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_bennys/menu.lua

*Role:* shared

## fsn_bikerental/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletMinus, fsn_notify:displayNotification
*Exports:* fsn_main
*NUI Callbacks:* escape, rentBike
*NUI Messages:* SendNUIMessage

## fsn_bikerental/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_bikerental/html/cursor.png

*Role:* shared

## fsn_bikerental/html/index.html

*Role:* NUI

## fsn_bikerental/html/script.js

*Role:* NUI

## fsn_bikerental/html/style.css

*Role:* NUI

## fsn_boatshop/cl_boatshop.lua

*Role:* client
*Events:* register: fsn_boatshop:floor:Update, fsn_boatshop:floor:Updateboat, fsn_boatshop:floor:color:One, fsn_boatshop:floor:color:Two, fsn_boatshop:floor:commission, handler: fsn_boatshop:floor:Update, fsn_boatshop:floor:Updateboat, fsn_boatshop:floor:color:One, fsn_boatshop:floor:color:Two, fsn_boatshop:floor:commission, trigger: fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_boatshop:floor:Request, fsn_boatshop:floor:color:One, fsn_boatshop:floor:color:Two, fsn_boatshop:floor:commission, fsn_cargarage:buyVehicle, fsn_cargarage:makeMine
*Exports:* fsn_jobs, fsn_main, mythic_notify

## fsn_boatshop/cl_menu.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletMinus, fsn_boatshop:floor:ChangeBoat, fsn_notify:displayNotification

## fsn_boatshop/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_boatshop/sv_boatshop.lua

*Role:* server
*Events:* register: fsn_boatshop:floor:ChangeBoat, fsn_boatshop:floor:Request, fsn_boatshop:floor:color:One, fsn_boatshop:floor:color:Two, fsn_boatshop:floor:commission, handler: chatMessage, fsn_boatshop:floor:ChangeBoat, fsn_boatshop:floor:Request, fsn_boatshop:floor:color:One, fsn_boatshop:floor:color:Two, fsn_boatshop:floor:commission, trigger: fsn_boatshop:floor:Update, fsn_boatshop:floor:Updateboat, fsn_boatshop:floor:color:One, fsn_boatshop:floor:color:Two, fsn_boatshop:floor:commission, fsn_boatshop:testdrive:end, fsn_boatshop:testdrive:start, mythic_notify:client:SendAlert
*Exports:* fsn_jobs

## fsn_builders/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_builders/handling_builder.lua

*Role:* shared

## fsn_builders/schema.lua

*Role:* shared

## fsn_builders/schemas/cbikehandlingdata.lua

*Role:* shared

## fsn_builders/schemas/ccarhandlingdata.lua

*Role:* shared

## fsn_builders/schemas/chandlingdata.lua

*Role:* shared

## fsn_builders/xml.lua

*Role:* shared

## fsn_cargarage/client.lua

*Role:* client
*Events:* register: fsn_cargarage:checkStatus, fsn_cargarage:makeMine, fsn_cargarage:receiveVehicles, fsn_cargarage:vehicleStatus, handler: fsn_cargarage:checkStatus, fsn_cargarage:makeMine, fsn_cargarage:receiveVehicles, fsn_cargarage:vehicleStatus, fsn_main:character, trigger: fsn_bank:change:walletMinus, fsn_cargarage:requestVehicles, fsn_cargarage:reset, fsn_cargarage:vehicle:toggleStatus, fsn_garages:vehicle:update, fsn_notify:displayNotification, fsn_vehiclecontrol:keys:carjack
*NUI Messages:* SendNUIMessage

## fsn_cargarage/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_cargarage/gui/ui.css

*Role:* NUI

## fsn_cargarage/gui/ui.html

*Role:* NUI

## fsn_cargarage/gui/ui.js

*Role:* NUI

## fsn_cargarage/server.lua

*Role:* server
*Events:* register: fsn_cargarage:impound, fsn_cargarage:requestVehicles, fsn_cargarage:reset, fsn_cargarage:updateVehicle, fsn_cargarage:vehicle:toggleStatus, fsn_garages:vehicle:update, handler: fsn_cargarage:impound, fsn_cargarage:requestVehicles, fsn_cargarage:reset, fsn_cargarage:updateVehicle, fsn_cargarage:vehicle:toggleStatus, fsn_garages:vehicle:update, trigger: fsn_cargarage:impound, fsn_cargarage:receiveVehicles, fsn_cargarage:updateVehicle, fsn_cargarage:vehicleStatus, fsn_notify:displayNotification
*DB Calls:* MySQL.Async.execute('UPDATE `fsn_vehicles` SET `veh_status` = @status WHERE `veh_plate` = @plate', {['@plate'] = plate, ['@status'] = status}, function() end), MySQL.Async.execute('UPDATE `fsn_vehicles` SET `veh_status` = @status, `veh_garage` = @garage WHERE `veh_plate` = @plate', {['@plate'] = plate, ['@status'] = status, ['@garage'] = grg}, function() end), MySQL.Async.fetchAll('SELECT * FROM `fsn_vehicles` WHERE `char_id` = @char_id AND `veh_type` = "a"', {['@char_id'] = charid}, function(vehicles), MySQL.Async.fetchAll('SELECT * FROM `fsn_vehicles` WHERE `char_id` = @char_id AND `veh_type` = "b"', {['@char_id'] = charid}, function(vehicles), MySQL.Async.fetchAll('SELECT * FROM `fsn_vehicles` WHERE `char_id` = @char_id AND `veh_type` = "c"', {['@char_id'] = charid}, function(vehicles), MySQL.Sync.execute("UPDATE `fsn_vehicles` SET `veh_details` = @details WHERE `veh_plate` = @plate", {, MySQL.Sync.execute('UPDATE `fsn_vehicles` SET `veh_status` = 0 WHERE `veh_status` = 1 AND `char_id` = @charid', {['@charid'] = charid})

## fsn_carstore/cl_carstore.lua

*Role:* client
*Events:* register: fsn_carstore:floor:Update, fsn_carstore:floor:UpdateCar, fsn_carstore:floor:color:One, fsn_carstore:floor:color:Two, fsn_carstore:floor:commission, handler: fsn_carstore:floor:Update, fsn_carstore:floor:UpdateCar, fsn_carstore:floor:color:One, fsn_carstore:floor:color:Two, fsn_carstore:floor:commission, trigger: fsn_bank:change:walletMinus, fsn_cargarage:buyVehicle, fsn_cargarage:makeMine, fsn_carstore:floor:Request, fsn_carstore:floor:color:One, fsn_carstore:floor:color:Two, fsn_carstore:floor:commission
*Exports:* fsn_jobs, fsn_main, mythic_notify

## fsn_carstore/cl_menu.lua

*Role:* client
*Events:* handler: playerSpawned, trigger: fsn_bank:change:walletMinus, fsn_carstore:floor:ChangeCar, fsn_notify:displayNotification

## fsn_carstore/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_carstore/gui/index.html

*Role:* NUI

## fsn_carstore/sv_carstore.lua

*Role:* server
*Events:* register: fsn_carstore:floor:ChangeCar, fsn_carstore:floor:Request, fsn_carstore:floor:color:One, fsn_carstore:floor:color:Two, fsn_carstore:floor:commission, handler: chatMessage, fsn_carstore:floor:ChangeCar, fsn_carstore:floor:Request, fsn_carstore:floor:color:One, fsn_carstore:floor:color:Two, fsn_carstore:floor:commission, trigger: fsn_carstore:floor:Update, fsn_carstore:floor:UpdateCar, fsn_carstore:floor:color:One, fsn_carstore:floor:color:Two, fsn_carstore:floor:commission, fsn_carstore:testdrive:end, fsn_carstore:testdrive:start, mythic_notify:client:SendAlert
*Exports:* fsn_jobs

## fsn_carstore/vehshop_server.lua

*Role:* server

## fsn_characterdetails/facial/client.lua

*Role:* client

## fsn_characterdetails/facial/server.lua

*Role:* server

## fsn_characterdetails/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_characterdetails/gui/ui.css

*Role:* NUI

## fsn_characterdetails/gui/ui.html

*Role:* NUI

## fsn_characterdetails/gui/ui.js

*Role:* NUI

## fsn_characterdetails/gui_manager.lua

*Role:* shared
*NUI Messages:* SendNUIMessage

## fsn_characterdetails/tattoos/client.lua

*Role:* client
*Events:* register: fsn_characterdetails:recievetattoos, handler: fsn_characterdetails:recievetattoos, trigger: fsn_main:saveCharacter

## fsn_characterdetails/tattoos/config.lua

*Role:* shared

## fsn_characterdetails/tattoos/server.lua

*Role:* server

## fsn_characterdetails/tattoos/server.zip

*Role:* server

## fsn_clothing/client.lua

*Role:* client
*Events:* register: clothes:spawn, fsn_clothing:menu, handler: clothes:changemodel, clothes:setComponents, clothes:spawn, fsn_clothing:menu, trigger: clothes:changemodel, clothes:firstspawn, clothes:loaded, clothes:save, clothes:setComponents, fsn_criminalmisc:weapons:equip

## fsn_clothing/config.lua

*Role:* shared
*Events:* trigger: fsn_bank:change:walletMinus

## fsn_clothing/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_clothing/gui.lua

*Role:* shared

## fsn_clothing/models.txt

*Role:* shared

## fsn_clothing/server.lua

*Role:* server
*Events:* register: clothes:firstspawn, fsn_clothing:requestDefault, fsn_clothing:save, handler: clothes:firstspawn, fsn_clothing:requestDefault, fsn_clothing:save, trigger: clothes:spawn, fsn_clothing:change

## fsn_commands/client.lua

*Role:* client
*Events:* register: fsn_commands:airlift, fsn_commands:clothing:glasses, fsn_commands:clothing:hat, fsn_commands:clothing:mask, fsn_commands:dev:fix, fsn_commands:dev:spawnCar, fsn_commands:dev:weapon, fsn_commands:dropweapon, fsn_commands:getHDC, fsn_commands:hc:takephone, fsn_commands:me, fsn_commands:me:3d, fsn_commands:police:boot, fsn_commands:police:car, fsn_commands:police:cpic:trigger, fsn_commands:police:extra, fsn_commands:police:extras, fsn_commands:police:fix, fsn_commands:police:impound, fsn_commands:police:impound2, fsn_commands:police:livery, fsn_commands:police:pedcarry, fsn_commands:police:pedrevive, fsn_commands:police:rifle, fsn_commands:police:shotgun, fsn_commands:police:towMark, fsn_commands:police:unboot, fsn_commands:police:updateBoot, fsn_commands:sendxyz, fsn_commands:service:pingAccept, fsn_commands:service:pingStart, fsn_commands:service:request, fsn_commands:vehdoor:close, fsn_commands:vehdoor:open, fsn_commands:walk:set, fsn_commands:window, fsn_police:runplate:target, handler: fsn_commands:airlift, fsn_commands:clothing:glasses, fsn_commands:clothing:hat, fsn_commands:clothing:mask, fsn_commands:dev:fix, fsn_commands:dev:spawnCar, fsn_commands:dev:weapon, fsn_commands:dropweapon, fsn_commands:getHDC, fsn_commands:hc:takephone, fsn_commands:me, fsn_commands:me:3d, fsn_commands:police:boot, fsn_commands:police:car, fsn_commands:police:cpic:trigger, fsn_commands:police:extra, fsn_commands:police:extras, fsn_commands:police:fix, fsn_commands:police:impound, fsn_commands:police:impound2, fsn_commands:police:livery, fsn_commands:police:pedcarry, fsn_commands:police:pedrevive, fsn_commands:police:rifle, fsn_commands:police:shotgun, fsn_commands:police:towMark, fsn_commands:police:unboot, fsn_commands:police:updateBoot, fsn_commands:sendxyz, fsn_commands:service:pingAccept, fsn_commands:service:pingStart, fsn_commands:service:request, fsn_commands:vehdoor:close, fsn_commands:vehdoor:open, fsn_commands:walk:set, fsn_commands:window, fsn_main:character, fsn_police:runplate:target, trigger: chatMessage, fsn_cargarage:impound, fsn_cargarage:makeMine, fsn_commands:me, fsn_commands:police:booted, fsn_commands:police:unbooted, fsn_commands:printxyz, fsn_commands:requestHDC, fsn_commands:service:addPing, fsn_commands:service:sendrequest, fsn_criminalmisc:weapons:add:police, fsn_criminalmisc:weapons:add:unknown, fsn_fuel:set, fsn_fuel:update, fsn_inventory:item:take, fsn_inventory:items:add, fsn_notify:displayNotification, fsn_police:database:CPIC:search, fsn_police:runplate::target
*Exports:* fsn_main, fsn_progress, mythic_notify

## fsn_commands/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_commands/server.lua

*Role:* server
*Events:* register: fsn_commands:ems:adamage:inspect, fsn_commands:me, fsn_commands:police:booted, fsn_commands:police:gsrResult, fsn_commands:police:unbooted, fsn_commands:printxyz, fsn_commands:requestHDC, fsn_commands:service:addPing, fsn_commands:service:sendrequest, handler: chatMessage, fsn_commands:ems:adamage:inspect, fsn_commands:me, fsn_commands:police:booted, fsn_commands:police:gsrResult, fsn_commands:police:unbooted, fsn_commands:printxyz, fsn_commands:requestHDC, fsn_commands:service:addPing, fsn_commands:service:sendrequest, fsn_ems:update, fsn_main:money:wallet:Set, fsn_main:updateCharacters, fsn_police:update, trigger: chatMessage, fsn_apartments:instance:debug, fsn_bank:change:walletAdd, fsn_commands:airlift, fsn_commands:clothing:glasses, fsn_commands:clothing:hat, fsn_commands:clothing:mask, fsn_commands:dev:fix, fsn_commands:dev:spawnCar, fsn_commands:dev:weapon, fsn_commands:getHDC, fsn_commands:hc:rob, fsn_commands:hc:takephone, fsn_commands:me, fsn_commands:me:3d, fsn_commands:police:boot, fsn_commands:police:car, fsn_commands:police:cpic:trigger, fsn_commands:police:extra, fsn_commands:police:extras, fsn_commands:police:fix, fsn_commands:police:gsrMe, fsn_commands:police:impound, fsn_commands:police:impound2, fsn_commands:police:livery, fsn_commands:police:pedcarry, fsn_commands:police:pedrevive, fsn_commands:police:rifle, fsn_commands:police:shotgun, fsn_commands:police:towMark, fsn_commands:police:unboot, fsn_commands:police:updateBoot, fsn_commands:sendxyz, fsn_commands:service:pingAccept, fsn_commands:service:pingStart, fsn_commands:service:request, fsn_commands:vehdoor:close, fsn_commands:vehdoor:open, fsn_commands:window, fsn_criminalmisc:weapons:destroy, fsn_criminalmisc:weapons:drop, fsn_criminalmisc:weapons:info, fsn_dev:debug, fsn_dev:noClip:enabled, fsn_emotecontrol:dice:roll, fsn_emotecontrol:phone:call1, fsn_emotecontrol:play, fsn_emotecontrol:police:tablet, fsn_emotecontrol:police:ticket, fsn_emotecontrol:sit, fsn_ems:911, fsn_ems:911r, fsn_ems:adamage:request, fsn_ems:killMe, fsn_ems:reviveMe, fsn_ems:reviveMe:force, fsn_ems:set:WalkType, fsn_ems:updateLevel, fsn_inventory:item:add, fsn_inventory:ply:request, fsn_inventory:veh:glovebox, fsn_jail:sendsuspect, fsn_jobs:ems:request, fsn_jobs:news:role:Set, fsn_jobs:news:role:Toggle, fsn_jobs:quit, fsn_jobs:taxi:request, fsn_jobs:tow:mark, fsn_jobs:tow:request, fsn_licenses:display, fsn_licenses:infraction, fsn_licenses:police:give, fsn_licenses:setinfractions, fsn_main:blip:clear, fsn_main:charMenu, fsn_main:characterSaving, fsn_main:displayBankandMoney, fsn_main:logging:addLog, fsn_main:money:wallet:GiveCash, fsn_notify:displayNotification, fsn_phone:displayNumber, fsn_phone:togglePhone, fsn_phones:USE:Phone, fsn_phones:UTIL:displayNumber, fsn_police:911, fsn_police:911r, fsn_police:MDT:toggle, fsn_police:command:duty, fsn_police:dispatch:toggle, fsn_police:handcuffs:hard, fsn_police:handcuffs:soft, fsn_police:k9:search:person:me, fsn_police:putMeInVeh, fsn_police:radar:toggle, fsn_police:runplate, fsn_police:runplate:target, fsn_police:search:start:inventory, fsn_police:search:start:money, fsn_police:search:start:weapons, fsn_police:search:strip, fsn_police:ticket, fsn_police:toggleDrag, fsn_police:updateLevel, fsn_teleporters:teleport:coordinates, fsn_teleporters:teleport:waypoint, fsn_vehiclecontrol:damage:repair, mythic_notify:client:SendAlert, xgc-tuner:openTuner
*DB Calls:* MySQL.Sync.execute("UPDATE `fsn_characters` SET `char_ems` = @popo WHERE `char_id` = @id", {['@id'] = exports.fsn_main:fsn_CharID(tonumber(split[4])), ['@popo'] = tonumber(split[5])}), MySQL.Sync.execute("UPDATE `fsn_characters` SET `char_police` = @popo WHERE `char_id` = @id", {['@id'] = exports.fsn_main:fsn_CharID(tonumber(split[4])), ['@popo'] = tonumber(split[5])})

## fsn_crafting/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletMinus, fsn_evidence:ped:addState, fsn_inventory:item:add, fsn_inventory:item:take, fsn_notify:displayNotification

## fsn_crafting/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_crafting/nui/index.css

*Role:* NUI

## fsn_crafting/nui/index.html

*Role:* NUI

## fsn_crafting/nui/index.js

*Role:* NUI

## fsn_crafting/server.lua

*Role:* server

## fsn_criminalmisc/client.lua

*Role:* client
*Exports:* fsn_inventory

## fsn_criminalmisc/drugs/_effects/client.lua

*Role:* client
*Events:* register: fsn_criminalmisc:drugs:effects:cocaine, fsn_criminalmisc:drugs:effects:meth, fsn_criminalmisc:drugs:effects:smokeCigarette, fsn_criminalmisc:drugs:effects:weed, handler: fsn_criminalmisc:drugs:effects:cocaine, fsn_criminalmisc:drugs:effects:meth, fsn_criminalmisc:drugs:effects:smokeCigarette, fsn_criminalmisc:drugs:effects:weed, trigger: fsn_needs:stress:remove

## fsn_criminalmisc/drugs/_streetselling/client.lua

*Role:* client
*Events:* register: fsn_criminalmisc:drugs:streetselling:send, handler: fsn_criminalmisc:drugs:streetselling:send, trigger: chatMessage, fsn_criminalmisc:drugs:streetselling:radio, fsn_criminalmisc:drugs:streetselling:request, fsn_evidence:ped:addState, fsn_inventory:item:add, fsn_inventory:item:take, fsn_needs:stress:add, fsn_notify:displayNotification, fsn_phone:recieveMessage, fsn_phones:USE:Email, fsn_police:dispatch
*Exports:* fsn_inventory, fsn_police

## fsn_criminalmisc/drugs/_streetselling/server.lua

*Role:* server
*Events:* register: fsn_criminalmisc:drugs:streetselling:radio, fsn_criminalmisc:drugs:streetselling:request, handler: fsn_criminalmisc:drugs:streetselling:radio, fsn_criminalmisc:drugs:streetselling:request, trigger: fsn_criminalmisc:drugs:streetselling:send, fsn_inventory:item:add, fsn_notify:displayNotification

## fsn_criminalmisc/drugs/_weedprocess/client.lua

*Role:* client

## fsn_criminalmisc/drugs/client.lua

*Role:* client

## fsn_criminalmisc/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_criminalmisc/handcuffs/client.lua

*Role:* client
*Events:* register: fsn_criminalmisc:handcuffs:startCuffed, fsn_criminalmisc:handcuffs:startCuffing, fsn_criminalmisc:handcuffs:startunCuffed, fsn_criminalmisc:handcuffs:startunCuffing, fsn_criminalmisc:toggleDrag, handler: fsn_criminalmisc:handcuffs:startCuffed, fsn_criminalmisc:handcuffs:startCuffing, fsn_criminalmisc:handcuffs:startunCuffed, fsn_criminalmisc:handcuffs:startunCuffing, fsn_criminalmisc:toggleDrag, trigger: fsn_criminalmisc:handcuffs:requestCuff, fsn_criminalmisc:handcuffs:requestunCuff, fsn_criminalmisc:handcuffs:toggleEscort, fsn_criminalmisc:robbing:requesRob, fsn_criminalmisc:robbing:startRobbing, fsn_notify:displayNotification
*Exports:* fsn_apartments, fsn_ems

## fsn_criminalmisc/handcuffs/server.lua

*Role:* server
*Events:* register: fsn_criminalmisc:handcuffs:requestCuff, fsn_criminalmisc:handcuffs:requestunCuff, fsn_criminalmisc:handcuffs:toggleEscort, handler: fsn_criminalmisc:handcuffs:requestCuff, fsn_criminalmisc:handcuffs:requestunCuff, fsn_criminalmisc:handcuffs:toggleEscort, trigger: fsn_criminalmisc:handcuffs:startCuffed, fsn_criminalmisc:handcuffs:startCuffing, fsn_criminalmisc:handcuffs:startunCuffed, fsn_criminalmisc:handcuffs:startunCuffing, fsn_criminalmisc:toggleDrag

## fsn_criminalmisc/lockpicking/client.lua

*Role:* client
*Events:* register: fsn_bankrobbery:desks:receive, fsn_criminalmisc:lockpicking, handler: fsn_bankrobbery:desks:receive, fsn_criminalmisc:lockpicking, trigger: fsn_bankrobbery:LostMC:spawn, fsn_bankrobbery:desks:doorUnlock, fsn_commands:me, fsn_inventory:item:add, fsn_inventory:item:take, fsn_notify:displayNotification, fsn_police:dispatch, fsn_vehiclecontrol:keys:carjack
*Exports:* fsn_main, fsn_police, fsn_progress

## fsn_criminalmisc/pawnstore/cl_pawnstore.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletAdd, fsn_inventory:item:take
*Exports:* fsn_inventory, fsn_timeandweather

## fsn_criminalmisc/remapping/client.lua

*Role:* client

## fsn_criminalmisc/remapping/server.lua

*Role:* server

## fsn_criminalmisc/robbing/cl_houses-build.lua

*Role:* client

## fsn_criminalmisc/robbing/cl_houses-config.lua

*Role:* client

## fsn_criminalmisc/robbing/cl_houses.lua

*Role:* client
*Events:* register: fsn_criminalmisc:houserobbery:try, handler: fsn_criminalmisc:houserobbery:try, trigger: fsn_apartments:instance:leave, fsn_apartments:instance:new, fsn_bank:change:walletAdd, fsn_inventory:item:take, fsn_inventory:items:add, fsn_inventory:items:addPreset, fsn_needs:stress:add, fsn_police:dispatch
*Exports:* fsn_inventory, fsn_police, fsn_progress, fsn_timeandweather, mythic_notify

## fsn_criminalmisc/robbing/client.lua

*Role:* client
*Events:* register: fsn_criminalmisc:robbing:startRobbing, handler: fsn_criminalmisc:robbing:startRobbing, trigger: fsn_inventory:sys:request
*Exports:* mythic_notify

## fsn_criminalmisc/streetracing/client.lua

*Role:* client
*Events:* register: fsn_criminalmisc:racing:createRace, fsn_criminalmisc:racing:putmeinrace, fsn_criminalmisc:racing:update, handler: fsn_criminalmisc:racing:createRace, fsn_criminalmisc:racing:putmeinrace, fsn_criminalmisc:racing:update, trigger: fsn_criminalmisc:racing:joinRace, fsn_criminalmisc:racing:newRace, fsn_criminalmisc:racing:win, fsn_notify:displayNotification
*Exports:* fsn_main

## fsn_criminalmisc/streetracing/server.lua

*Role:* server
*Events:* register: fsn_criminalmisc:racing:joinRace, fsn_criminalmisc:racing:newRace, fsn_criminalmisc:racing:win, handler: fsn_criminalmisc:racing:joinRace, fsn_criminalmisc:racing:newRace, fsn_criminalmisc:racing:win, trigger: fsn_bank:change:walletAdd, fsn_criminalmisc:racing:putmeinrace, fsn_criminalmisc:racing:update, fsn_notify:displayNotification, mythic_notify:client:SendAlert

## fsn_criminalmisc/weaponinfo/client.lua

*Role:* client
*Events:* register: fsn_criminalmisc:weapons:add, fsn_criminalmisc:weapons:add:police, fsn_criminalmisc:weapons:add:tbl, fsn_criminalmisc:weapons:add:unknown, fsn_criminalmisc:weapons:destroy, fsn_criminalmisc:weapons:drop, fsn_criminalmisc:weapons:equip, fsn_criminalmisc:weapons:info, fsn_criminalmisc:weapons:pickup, fsn_criminalmisc:weapons:updateDropped, fsn_police:search:start:weapons, fsn_police:search:strip, handler: fsn_criminalmisc:weapons:add, fsn_criminalmisc:weapons:add:police, fsn_criminalmisc:weapons:add:tbl, fsn_criminalmisc:weapons:add:unknown, fsn_criminalmisc:weapons:destroy, fsn_criminalmisc:weapons:drop, fsn_criminalmisc:weapons:equip, fsn_criminalmisc:weapons:info, fsn_criminalmisc:weapons:pickup, fsn_criminalmisc:weapons:updateDropped, fsn_main:character, fsn_police:search:start:weapons, fsn_police:search:strip, trigger: chatMessage, fsn_bank:change:bankandwallet, fsn_criminalmisc:weapons:addDrop, fsn_criminalmisc:weapons:equip, fsn_criminalmisc:weapons:pickup, fsn_inventory:empty, fsn_inventory:item:take, fsn_main:characterSaving, fsn_notify:displayNotification, fsn_police:search:end:weapons
*Exports:* fsn_inventory

## fsn_criminalmisc/weaponinfo/server.lua

*Role:* server
*Events:* register: fsn_criminalmisc:weapons:addDrop, fsn_criminalmisc:weapons:pickup, handler: fsn_criminalmisc:weapons:addDrop, fsn_criminalmisc:weapons:pickup, trigger: fsn_criminalmisc:weapons:pickup, fsn_criminalmisc:weapons:updateDropped, fsn_main:logging:addLog, fsn_notify:displayNotification

## fsn_criminalmisc/weaponinfo/weapon_list.lua

*Role:* shared

## fsn_customanimations/client.lua

*Role:* client
*Events:* register: 321236ce-42a6-43d8-af3d-e0e30c9e66b7, 394084c7-ac07-424a-982b-ab2267d8d55f, handler: 321236ce-42a6-43d8-af3d-e0e30c9e66b7, 394084c7-ac07-424a-982b-ab2267d8d55f, onResourceStop, trigger: 1a4d29ac-5c1a-427e-ab18-461ae6b76e8b, chat:addSuggestion, chat:removeSuggestion, chatMessage
*Commands:* ce, testanimation

## fsn_customanimations/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_customs/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_customs/lscustoms.lua

*Role:* shared
*Events:* handler: onClientResourceStart, trigger: fsn_bank:change:walletMinus, fsn_cargarage:updateVehicle, fsn_notify:displayNotification
*Exports:* fsn_cargarage

## fsn_dev/client/cl_noclip.lua

*Role:* client
*Events:* register: fsn_developer:noClip:enabled, handler: freecam:onTick, fsn_developer:noClip:enabled
*Exports:* freecam

## fsn_dev/client/client.lua

*Role:* client
*Events:* register: fsn_developer:deleteVehicle, fsn_developer:fixVehicle, fsn_developer:getKeys, fsn_developer:sendXYZ, fsn_developer:spawnVehicle, handler: fsn_developer:deleteVehicle, fsn_developer:fixVehicle, fsn_developer:getKeys, fsn_developer:sendXYZ, fsn_developer:spawnVehicle, trigger: fsn_cargarage:makeMine, fsn_developer:printXYZ, fsn_fuel:update, fsn_notify:displayNotification
*Exports:* LegacyFuel

## fsn_dev/config.lua

*Role:* shared

## fsn_dev/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua',

## fsn_dev/oldresource.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_dev/server/server.lua

*Role:* server
*Events:* register: fsn:playerReady, fsn_developer:enableDeveloperCommands, fsn_developer:printXYZ, handler: fsn:playerReady, fsn_developer:enableDeveloperCommands, fsn_developer:printXYZ, trigger: chat:addMessage, chat:addSuggestion, fsn:getFsnObject, fsn_apartments:instance:debug, fsn_bank:change:walletAdd, fsn_commands:police:pedcarry, fsn_commands:police:pedrevive, fsn_developer:deleteVehicle, fsn_developer:enableDeveloperCommands, fsn_developer:fixVehicle, fsn_developer:getKeys, fsn_developer:noClip:enabled, fsn_developer:sendXYZ, fsn_developer:spawnVehicle, fsn_ems:killMe, fsn_ems:reviveMe:force, fsn_inventory:item:add, fsn_inventory:ply:request, fsn_licenses:setInfractions, fsn_main:charMenu, fsn_notify:displayNotification, fsn_police:MDT:toggle, fsn_police:command:duty, fsn_teleporters:teleport:coordinates, fsn_teleporters:teleport:waypoint, xgc-tuner:openTuner
*Commands:* addmoney, carryplayer, debug, dv, fixveh, getkeys, giveitem, insidedebug, inv, kill, mdt, noclip, pdduty, revive, reviveplayer, setinfractions, softlog, spawnveh, tpc, tpm, tuner, xyz

## fsn_doj/attorneys/client.lua

*Role:* client

## fsn_doj/attorneys/server.lua

*Role:* server

## fsn_doj/client.lua

*Role:* client

## fsn_doj/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_doj/judges/client.lua

*Role:* client
*Events:* register: fsn_doj:court:remandMe, fsn_doj:judge:spawnCar, handler: fsn_doj:court:remandMe, fsn_doj:judge:spawnCar, trigger: fsn_cargarage:makeMine, fsn_notify:displayNotification

## fsn_doj/judges/server.lua

*Role:* server
*Events:* handler: chatMessage, trigger: chatMessage, fsn_bank:change:walletAdd, fsn_doj:court:remandMe, fsn_doj:judge:spawnCar, fsn_doj:judge:toggleLock, fsn_jail:sendsuspect, fsn_licenses:setinfractions, fsn_notify:displayNotification, fsn_police:database:CPIC:search:result, fsn_police:ticket
*DB Calls:* MySQL.Async.fetchAll('SELECT * FROM `fsn_tickets` WHERE `receiver_id` = @id', {['@id'] = idee}, function(results)

## fsn_doormanager/cl_doors.lua

*Role:* client
*Events:* register: fsn_doormanager:request, handler: fsn_doormanager:request, fsn_police:init, fsn_police:update, trigger: InteractSound_SV:PlayWithinDistance, fsn_doormanager:request, fsn_doormanager:toggle

## fsn_doormanager/client.lua

*Role:* client
*Events:* register: fsn_doormanager:doorLocked, fsn_doormanager:doorUnlocked, fsn_doormanager:sendDoors, handler: fsn_doormanager:doorLocked, fsn_doormanager:doorUnlocked, fsn_doormanager:sendDoors, fsn_police:init, trigger: fsn_doormanager:lockDoor, fsn_doormanager:requestDoors, fsn_doormanager:unlockDoor

## fsn_doormanager/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_doormanager/server.lua

*Role:* server
*Events:* register: fsn_doormanager:lockDoor, fsn_doormanager:requestDoors, fsn_doormanager:unlockDoor, handler: fsn_doormanager:lockDoor, fsn_doormanager:requestDoors, fsn_doormanager:unlockDoor, trigger: fsn_doormanager:doorLocked, fsn_doormanager:doorUnlocked, fsn_doormanager:sendDoors

## fsn_doormanager/sv_doors.lua

*Role:* server
*Events:* register: fsn_doormanager:request, fsn_doormanager:toggle, handler: fsn_doormanager:request, fsn_doormanager:toggle, trigger: fsn_doormanager:request

## fsn_emotecontrol/client.lua

*Role:* client
*Events:* register: fsn_emotecontrol:dice:roll, fsn_emotecontrol:phone:call1, fsn_emotecontrol:play, fsn_emotecontrol:police:tablet, fsn_emotecontrol:police:ticket, handler: fsn_emotecontrol:dice:roll, fsn_emotecontrol:phone:call1, fsn_emotecontrol:play, fsn_emotecontrol:police:tablet, fsn_emotecontrol:police:ticket, trigger: chatMessage, fsn_commands:me

## fsn_emotecontrol/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_emotecontrol/walktypes/client.lua

*Role:* client
*Events:* register: AnimSet:Alien, AnimSet:Brave, AnimSet:Business, AnimSet:ChiChi, AnimSet:Hobo, AnimSet:Hurry, AnimSet:Injured, AnimSet:Joy, AnimSet:ManEater, AnimSet:Money, AnimSet:Moon, AnimSet:NonChalant, AnimSet:Posh, AnimSet:Sad, AnimSet:Sassy, AnimSet:Sexy, AnimSet:Shady, AnimSet:Swagger, AnimSet:Tipsy, AnimSet:Tired, AnimSet:ToughGuy, AnimSet:default, handler: AnimSet:Alien, AnimSet:Brave, AnimSet:Business, AnimSet:ChiChi, AnimSet:Hobo, AnimSet:Hurry, AnimSet:Injured, AnimSet:Joy, AnimSet:ManEater, AnimSet:Money, AnimSet:Moon, AnimSet:NonChalant, AnimSet:Posh, AnimSet:Sad, AnimSet:Sassy, AnimSet:Sexy, AnimSet:Shady, AnimSet:Swagger, AnimSet:Tipsy, AnimSet:Tired, AnimSet:ToughGuy, AnimSet:default, trigger: police:setAnimData

## fsn_ems/beds/client.lua

*Role:* client
*Events:* register: fsn_ems:bed:update, handler: fsn_ems:bed:update, trigger: fsn_ems:bed:health, fsn_ems:bed:occupy, fsn_ems:bed:restraintoggle, fsn_ems:reviveMe, fsn_notify:displayNotification, mythic_hospital:client:RemoveBleed, mythic_hospital:client:ResetLimbs
*Exports:* fsn_police

## fsn_ems/beds/server.lua

*Role:* server
*Events:* register: fsn_ems:bed:health, fsn_ems:bed:leave, fsn_ems:bed:occupy, fsn_ems:bed:restraintoggle, handler: fsn_ems:bed:health, fsn_ems:bed:leave, fsn_ems:bed:occupy, fsn_ems:bed:restraintoggle, trigger: fsn_ems:bed:update

## fsn_ems/blip.lua

*Role:* shared

## fsn_ems/cl_advanceddamage.lua

*Role:* client
*Events:* register: fsn_ems:ad:stopBleeding, fsn_ems:adamage:request, fsn_ems:set:WalkType, mythic_hospital:client:FieldTreatBleed, mythic_hospital:client:FieldTreatLimbs, mythic_hospital:client:ReduceBleed, mythic_hospital:client:RemoveBleed, mythic_hospital:client:ResetLimbs, mythic_hospital:client:SyncBleed, mythic_hospital:client:UseAdrenaline, mythic_hospital:client:UsePainKiller, handler: fsn_ems:ad:stopBleeding, fsn_ems:adamage:request, fsn_ems:set:WalkType, mythic_hospital:client:FieldTreatBleed, mythic_hospital:client:FieldTreatLimbs, mythic_hospital:client:ReduceBleed, mythic_hospital:client:RemoveBleed, mythic_hospital:client:ResetLimbs, mythic_hospital:client:SyncBleed, mythic_hospital:client:UseAdrenaline, mythic_hospital:client:UsePainKiller, trigger: fsn_commands:ems:adamage:inspect, fsn_evidence:drop:blood, fsn_evidence:ped:updateDamage, mythic_hospital:server:SyncInjuries
*Exports:* fsn_main, mythic_notify

## fsn_ems/cl_carrydead.lua

*Role:* client
*Events:* register: fsn_ems:carried:end, fsn_ems:carried:start, fsn_ems:carry:end, fsn_ems:carry:start, handler: fsn_ems:carried:end, fsn_ems:carried:start, fsn_ems:carry:end, fsn_ems:carry:start, trigger: fsn_criminalmisc:robbing:startRobbing, fsn_ems:carry:end, fsn_ems:carry:start, fsn_vehiclecontrol:trunk:forceOut

## fsn_ems/cl_volunteering.lua

*Role:* client

## fsn_ems/client.lua

*Role:* client
*Events:* register: fsn_ems:911, fsn_ems:911r, fsn_ems:killMe, fsn_ems:reviveMe, fsn_ems:reviveMe:force, fsn_ems:update, fsn_ems:updateLevel, fsn_jobs:ems:request, handler: fsn_ems:911, fsn_ems:911r, fsn_ems:killMe, fsn_ems:reviveMe, fsn_ems:reviveMe:force, fsn_ems:update, fsn_ems:updateLevel, fsn_jobs:ems:request, fsn_main:character, trigger: chatMessage, fsn_bank:change:bankMinus, fsn_bank:change:bankandwallet, fsn_ems:CAD:10-43, fsn_ems:killMe, fsn_ems:offDuty, fsn_ems:onDuty, fsn_ems:requestUpdate, fsn_ems:reviveMe, fsn_inventory:items:emptyinv, fsn_inventory:use:drink, fsn_inventory:use:food, fsn_main:blip:add, fsn_needs:stress:remove, fsn_notify:displayNotification, fsn_police:CAD:10-43, fsn_police:dispatch, fsn_police:dispatchcall, mythic_hospital:client:RemoveBleed, mythic_hospital:client:ResetLimbs, pNotify:SendNotification

## fsn_ems/debug_kng.lua

*Role:* shared

## fsn_ems/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_ems/info.txt

*Role:* shared

## fsn_ems/server.lua

*Role:* server
*Events:* register: fsn_ems:offDuty, fsn_ems:onDuty, fsn_ems:requestUpdate, fsn_ems:update, handler: fsn_ems:offDuty, fsn_ems:onDuty, fsn_ems:requestUpdate, playerDropped, trigger: fsn_ems:update

## fsn_ems/sv_carrydead.lua

*Role:* server
*Events:* register: fsn_ems:carry:end, fsn_ems:carry:start, handler: fsn_ems:carry:end, fsn_ems:carry:start, trigger: fsn_ems:carried:end, fsn_ems:carried:start, fsn_ems:carry:end, fsn_ems:carry:start

## fsn_entfinder/client.lua

*Role:* client

## fsn_entfinder/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_errorcontrol/client.lua

*Role:* client
*Events:* trigger: fsn_main:logging:addLog

## fsn_errorcontrol/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_evidence/__descriptions-carpaint.lua

*Role:* shared

## fsn_evidence/__descriptions-female.lua

*Role:* shared

## fsn_evidence/__descriptions-male.lua

*Role:* shared

## fsn_evidence/__descriptions.lua

*Role:* shared
*Commands:* evi_clothing

## fsn_evidence/casings/cl_casings.lua

*Role:* client
*Events:* register: fsn_evidence:weaponInfo, handler: fsn_evidence:weaponInfo, trigger: fsn_evidence:drop:casing
*Exports:* fsn_criminalmisc, fsn_police

## fsn_evidence/cl_evidence.lua

*Role:* client
*Events:* register: fsn_evidence:display, fsn_evidence:receive, handler: fsn_evidence:display, fsn_evidence:receive, trigger: fsn_evidence:collect, fsn_evidence:destroy, fsn_evidence:request
*Exports:* fsn_ems, fsn_police

## fsn_evidence/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_evidence/ped/cl_ped.lua

*Role:* client
*Events:* register: fsn_evidence:ped:addState, fsn_evidence:ped:update, fsn_evidence:ped:updateDamage, handler: fsn_evidence:ped:addState, fsn_evidence:ped:update, fsn_evidence:ped:updateDamage, trigger: fsn_evidence:ped:addState, fsn_evidence:ped:update

## fsn_evidence/ped/sv_ped.lua

*Role:* server
*Events:* register: fsn_evidence:ped:update, handler: fsn_evidence:ped:update, trigger: fsn_evidence:ped:update

## fsn_evidence/sv_evidence.lua

*Role:* server
*Events:* register: fsn_evidence:collect, fsn_evidence:destroy, fsn_evidence:drop:blood, fsn_evidence:drop:casing, fsn_evidence:request, handler: fsn_evidence:collect, fsn_evidence:destroy, fsn_evidence:drop:blood, fsn_evidence:drop:casing, fsn_evidence:request, trigger: fsn_evidence:display, fsn_evidence:receive, mythic_notify:client:SendAlert

## fsn_gangs/cl_gangs.lua

*Role:* client
*Events:* register: fsn_gangs:hideout:enter, fsn_gangs:hideout:leave, fsn_gangs:recieve, handler: fsn_gangs:hideout:enter, fsn_gangs:hideout:leave, fsn_gangs:recieve, trigger: fsn_gangs:garage:enter, fsn_gangs:hideout:enter, fsn_gangs:hideout:leave, fsn_gangs:request, fsn_gangs:tryTakeOver, mythic_notify:client:SendAlert
*Exports:* fsn_cargarage, fsn_ems, fsn_main

## fsn_gangs/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_gangs/sv_gangs.lua

*Role:* server
*Events:* register: fsn_gangs:garage:enter, fsn_gangs:hideout:enter, fsn_gangs:hideout:leave, fsn_gangs:inventory:request, fsn_gangs:request, fsn_gangs:tryTakeOver, handler: fsn_gangs:garage:enter, fsn_gangs:hideout:enter, fsn_gangs:hideout:leave, fsn_gangs:inventory:request, fsn_gangs:request, fsn_gangs:tryTakeOver, trigger: fsn_gangs:hideout:enter, fsn_gangs:hideout:leave, fsn_gangs:recieve, mythic_notify:client:SendAlert

## fsn_handling/data/handling.meta

*Role:* shared

## fsn_handling/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_handling/src/compact.lua

*Role:* shared

## fsn_handling/src/coupes.lua

*Role:* shared

## fsn_handling/src/government.lua

*Role:* shared

## fsn_handling/src/motorcycles.lua

*Role:* shared

## fsn_handling/src/muscle.lua

*Role:* shared

## fsn_handling/src/offroad.lua

*Role:* shared

## fsn_handling/src/schafter.lua

*Role:* shared

## fsn_handling/src/sedans.lua

*Role:* shared

## fsn_handling/src/sports.lua

*Role:* shared

## fsn_handling/src/sportsclassics.lua

*Role:* shared

## fsn_handling/src/super.lua

*Role:* shared

## fsn_handling/src/suvs.lua

*Role:* shared

## fsn_handling/src/vans.lua

*Role:* shared

## fsn_inventory/_item_misc/binoculars.lua

*Role:* shared
*Events:* register: binoculars:Activate, handler: binoculars:Activate

## fsn_inventory/_item_misc/burger_store.lua

*Role:* shared
*Events:* trigger: fsn_bank:change:walletAdd, fsn_inventory:item:add, fsn_inventory:item:take, fsn_notify:displayNotification

## fsn_inventory/_item_misc/cl_breather.lua

*Role:* client
*Events:* register: fsn_inventory:rebreather:use, handler: fsn_inventory:rebreather:use, trigger: fsn_bank:change:walletMinus, fsn_inventory:items:add
*Exports:* fsn_main, mythic_notify

## fsn_inventory/_item_misc/dm_laundering.lua

*Role:* shared
*Events:* trigger: chatMessage, fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_cargarage:makeMine, fsn_inventory:item:take, fsn_notify:displayNotification, pNotify:SendNotification

## fsn_inventory/_old/_item_misc/_drug_selling.lua

*Role:* shared
*Events:* trigger: fsn_inventory:item:add, fsn_inventory:item:take, fsn_notify:displayNotification, fsn_police:dispatch
*Exports:* fsn_main

## fsn_inventory/_old/client.lua

*Role:* client
*Events:* register: fsn_dev:debug, fsn_inventory:buyItem, fsn_inventory:empty, fsn_inventory:floor:update, fsn_inventory:init, fsn_inventory:initChar, fsn_inventory:item:add, fsn_inventory:item:drop, fsn_inventory:item:give, fsn_inventory:item:take, fsn_inventory:item:use, fsn_inventory:itemhasdropped, fsn_inventory:prebuy, fsn_inventory:removedropped, fsn_inventory:update, fsn_menu:requestInventory, fsn_police:search:start:inventory, handler: fsn_dev:debug, fsn_inventory:empty, fsn_inventory:floor:update, fsn_inventory:initChar, fsn_inventory:item:add, fsn_inventory:item:drop, fsn_inventory:item:give, fsn_inventory:item:take, fsn_inventory:item:use, fsn_inventory:itemhasdropped, fsn_inventory:prebuy, fsn_inventory:removedropped, fsn_menu:requestInventory, fsn_police:search:start:inventory, trigger: chatMessage, fsn_commands:me, fsn_inventory:buyItem, fsn_inventory:database:update, fsn_inventory:init, fsn_inventory:item:add, fsn_inventory:item:dropped, fsn_inventory:item:take, fsn_inventory:itempickup, fsn_inventory:update, fsn_notify:displayNotification, fsn_police:search:end:inventory

## fsn_inventory/_old/items.lua

*Role:* shared
*Events:* trigger: binoculars:Activate, fsn_criminalmisc:drugs:effects:cocaine, fsn_criminalmisc:drugs:effects:meth, fsn_criminalmisc:drugs:effects:weed, fsn_criminalmisc:drugs:streetselling:area, fsn_criminalmisc:lockpicking, fsn_ems:ad:stopBleeding, fsn_evidence:ped:addState, fsn_inventory:item:add, fsn_inventory:item:take, fsn_inventory:use:drink, fsn_inventory:use:food, fsn_notify:displayNotification, fsn_phone:togglePhone, fsn_vehiclecontrol:damage:repairkit, mythic_hospital:client:RemoveBleed, mythic_hospital:client:UseAdrenaline, mythic_hospital:client:UsePainKiller

## fsn_inventory/_old/pedfinder.lua

*Role:* shared

## fsn_inventory/_old/server.lua

*Role:* server
*Events:* register: fsn_inventory:item:dropped, fsn_inventory:itempickup, handler: fsn_inventory:item:dropped, fsn_inventory:itempickup, trigger: fsn_inventory:floor:update, fsn_inventory:item:add, fsn_inventory:itemhasdropped, fsn_inventory:removedropped, fsn_main:logging:addLog, fsn_notify:displayNotification

## fsn_inventory/cl_inventory.lua

*Role:* client
*Events:* register: fsn_inventory:apt:recieve, fsn_inventory:gui:display, fsn_inventory:item:add, fsn_inventory:item:take, fsn_inventory:items:add, fsn_inventory:items:addPreset, fsn_inventory:items:emptyinv, fsn_inventory:me:update, fsn_inventory:pd_locker:recieve, fsn_inventory:ply:done, fsn_inventory:ply:recieve, fsn_inventory:ply:request, fsn_inventory:police_armory:recieve, fsn_inventory:prop:recieve, fsn_inventory:store:recieve, fsn_inventory:store_gun:recieve, fsn_inventory:useAmmo, fsn_inventory:veh:glovebox:recieve, fsn_inventory:veh:trunk:recieve, fsn_main:characterSaving, handler: fsn_inventory:apt:recieve, fsn_inventory:gui:display, fsn_inventory:item:add, fsn_inventory:item:take, fsn_inventory:items:add, fsn_inventory:items:addPreset, fsn_inventory:items:emptyinv, fsn_inventory:me:update, fsn_inventory:pd_locker:recieve, fsn_inventory:ply:done, fsn_inventory:ply:recieve, fsn_inventory:ply:request, fsn_inventory:police_armory:recieve, fsn_inventory:prop:recieve, fsn_inventory:store:recieve, fsn_inventory:store_gun:recieve, fsn_inventory:useAmmo, fsn_inventory:veh:glovebox:recieve, fsn_inventory:veh:trunk:recieve, fsn_main:character, fsn_main:characterSaving, trigger: fsn_apartments:inv:update, fsn_bank:change:walletMinus, fsn_evidence:weaponInfo, fsn_inventory:database:update, fsn_inventory:drops:drop, fsn_inventory:item:take, fsn_inventory:items:add, fsn_inventory:items:addPreset, fsn_inventory:locker:save, fsn_inventory:ply:finished, fsn_inventory:ply:update, fsn_inventory:sys:send, fsn_inventory:veh:finished, fsn_inventory:veh:update, fsn_licenses:giveID, fsn_main:characterSaving, fsn_main:logging:addLog, fsn_police:armory:boughtOne, fsn_police:armory:closedArmory, fsn_police:armory:request, fsn_properties:inv:closed, fsn_properties:inv:update, fsn_store:boughtOne, fsn_store:closedStore, fsn_store:request
*Exports:* fsn_main, fsn_police, mythic_notify
*NUI Callbacks:* dropSlot, useSlot
*NUI Messages:* SendNUIMessage

## fsn_inventory/cl_presets.lua

*Role:* client
*Events:* register: fsn_inventory:recieveItems, handler: fsn_inventory:recieveItems, trigger: fsn_inventory:sendItems

## fsn_inventory/cl_uses.lua

*Role:* client
*Events:* trigger: binoculars:Activate, fsn_criminalmisc:drugs:effects:cocaine, fsn_criminalmisc:drugs:effects:meth, fsn_criminalmisc:drugs:effects:smokeCigarette, fsn_criminalmisc:drugs:effects:weed, fsn_criminalmisc:houserobbery:try, fsn_criminalmisc:lockpicking, fsn_ems:ad:stopBleeding, fsn_evidence:ped:addState, fsn_inventory:item:add, fsn_inventory:item:take, fsn_inventory:rebreather:use, fsn_inventory:use:drink, fsn_inventory:use:food, fsn_inventory:useAmmo, fsn_inventory:useArmor, fsn_licenses:id:display, fsn_notify:displayNotification, fsn_vehiclecontrol:damage:repairkit, mythic_hospital:client:RemoveBleed, mythic_hospital:client:UseAdrenaline, mythic_hospital:client:UsePainKiller, xgc-tuner:openTuner

## fsn_inventory/cl_vehicles.lua

*Role:* client
*Events:* register: fsn_inventory:veh:glovebox, handler: fsn_inventory:veh:glovebox, trigger: fsn_inventory:veh:request
*Exports:* mythic_notify

## fsn_inventory/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_inventory/html/css/jquery-ui.css

*Role:* NUI

## fsn_inventory/html/css/ui.css

*Role:* NUI

## fsn_inventory/html/img/bullet.png

*Role:* shared

## fsn_inventory/html/img/items/2g_weed.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_ADVANCEDRIFLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_APPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_ASSAULTSHOTGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_ASSAULTSMG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_AUTOSHOTGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_BALL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_BAT.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_BATTLEAXE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_BOTTLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_BULLPUPSHOTGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_CARBINERIFLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_CARBINERIFLE_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_COMBATMG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_COMBATMG_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_COMBATPDW.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_COMBATPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_COMPACTLAUNCHER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_COMPACTRIFLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_CROWBAR.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_DAGGER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_DBSHOTGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_DOUBLEACTION.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_FIREEXTINGUISHER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_FIREWORK.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_FLARE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_FLAREGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_FLASHLIGHT.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_GOLFCLUB.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_GRENADE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_GRENADELAUNCHER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_GUSENBERG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_HAMMER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_HATCHET.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_HEAVYPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_HEAVYSHOTGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_HOMINGLAUNCHER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_KNIFE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_KNUCKLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MACHETE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MACHINEPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MARKSMANPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MICROSMG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MINIGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MINISMG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MOLOTOV.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_MUSKET.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_NIGHTSTICK.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PETROLCAN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PIPEBOMB.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PISTOL50.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PISTOL_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_POOLCUE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PROXMINE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_RAILGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_RAYCARBINE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_RAYMINIGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_RAYPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_REVOLVER.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_REVOLVER_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_RPG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SAWNOFFSHOTGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SMG.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SMG_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SMOKEGRENADE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SNIPERRIFLE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SNOWBALL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SNSPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SNSPISTOL_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE_MK2.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_STICKYBOMB.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_STONE_HATCHET.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_STUNGUN.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_SWITCHBLADE.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_VINTAGEPISTOL.png

*Role:* shared

## fsn_inventory/html/img/items/WEAPON_WRENCH.png

*Role:* shared

## fsn_inventory/html/img/items/acetone.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_mg.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_mg_large.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_pistol.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_pistol_large.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_rifle.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_rifle_large.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_shotgun.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_shotgun_large.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_smg.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_smg_large.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_sniper.png

*Role:* shared

## fsn_inventory/html/img/items/ammo_sniper_large.png

*Role:* shared

## fsn_inventory/html/img/items/armor.png

*Role:* shared

## fsn_inventory/html/img/items/bandage.png

*Role:* shared

## fsn_inventory/html/img/items/beef_jerky.png

*Role:* shared

## fsn_inventory/html/img/items/binoculars.png

*Role:* shared

## fsn_inventory/html/img/items/burger.png

*Role:* shared

## fsn_inventory/html/img/items/burger_bun.png

*Role:* shared

## fsn_inventory/html/img/items/cigarette.png

*Role:* shared

## fsn_inventory/html/img/items/coffee.png

*Role:* shared

## fsn_inventory/html/img/items/cooked_burger.png

*Role:* shared

## fsn_inventory/html/img/items/cooked_meat.png

*Role:* shared

## fsn_inventory/html/img/items/cupcake.png

*Role:* shared

## fsn_inventory/html/img/items/dirty_money.png

*Role:* shared

## fsn_inventory/html/img/items/drill.png

*Role:* shared

## fsn_inventory/html/img/items/ecola.png

*Role:* shared

## fsn_inventory/html/img/items/empty_canister.png

*Role:* shared

## fsn_inventory/html/img/items/evidence.png

*Role:* shared

## fsn_inventory/html/img/items/fries.png

*Role:* shared

## fsn_inventory/html/img/items/frozen_burger.png

*Role:* shared

## fsn_inventory/html/img/items/frozen_fries.png

*Role:* shared

## fsn_inventory/html/img/items/gas_canister.png

*Role:* shared

## fsn_inventory/html/img/items/id.png

*Role:* shared

## fsn_inventory/html/img/items/joint.png

*Role:* shared

## fsn_inventory/html/img/items/keycard.png

*Role:* shared

## fsn_inventory/html/img/items/lockpick.png

*Role:* shared

## fsn_inventory/html/img/items/meth_rocks.png

*Role:* shared

## fsn_inventory/html/img/items/microwave_burrito.png

*Role:* shared

## fsn_inventory/html/img/items/minced_meat.png

*Role:* shared

## fsn_inventory/html/img/items/modified_drillbit.png

*Role:* shared

## fsn_inventory/html/img/items/morphine.png

*Role:* shared

## fsn_inventory/html/img/items/packaged_cocaine.png

*Role:* shared

## fsn_inventory/html/img/items/painkillers.png

*Role:* shared

## fsn_inventory/html/img/items/panini.png

*Role:* shared

## fsn_inventory/html/img/items/pepsi.png

*Role:* shared

## fsn_inventory/html/img/items/pepsi_max.png

*Role:* shared

## fsn_inventory/html/img/items/phone.png

*Role:* shared

## fsn_inventory/html/img/items/phosphorus.png

*Role:* shared

## fsn_inventory/html/img/items/radio_receiver.png

*Role:* shared

## fsn_inventory/html/img/items/repair_kit.png

*Role:* shared

## fsn_inventory/html/img/items/tuner_chip.png

*Role:* shared

## fsn_inventory/html/img/items/uncooked_meat.png

*Role:* shared

## fsn_inventory/html/img/items/vpn1.png

*Role:* shared

## fsn_inventory/html/img/items/vpn2.png

*Role:* shared

## fsn_inventory/html/img/items/water.png

*Role:* shared

## fsn_inventory/html/img/items/zipties.png

*Role:* shared

## fsn_inventory/html/js/config.js

*Role:* NUI

## fsn_inventory/html/js/inventory.js

*Role:* NUI

## fsn_inventory/html/locales/cs.js

*Role:* NUI

## fsn_inventory/html/locales/en.js

*Role:* NUI

## fsn_inventory/html/locales/fr.js

*Role:* NUI

## fsn_inventory/html/ui.html

*Role:* NUI

## fsn_inventory/pd_locker/cl_locker.lua

*Role:* client
*Events:* trigger: fsn_inventory:locker:empty, fsn_inventory:locker:request
*Exports:* fsn_doormanager, fsn_police

## fsn_inventory/pd_locker/datastore.txt

*Role:* shared

## fsn_inventory/pd_locker/sv_locker.lua

*Role:* server
*Events:* register: fsn_inventory:locker:empty, fsn_inventory:locker:request, fsn_inventory:locker:save, handler: fsn_inventory:locker:empty, fsn_inventory:locker:request, fsn_inventory:locker:save, trigger: fsn_inventory:pd_locker:recieve, mythic_notify:client:SendAlert

## fsn_inventory/sv_inventory.lua

*Role:* server
*Events:* register: fsn_inventory:item:add, fsn_inventory:ply:finished, fsn_inventory:ply:update, fsn_inventory:sys:request, fsn_inventory:sys:send, fsn_licenses:id:display, handler: chatMessage, fsn_inventory:item:add, fsn_inventory:ply:finished, fsn_inventory:ply:update, fsn_inventory:sys:request, fsn_inventory:sys:send, fsn_licenses:id:display, trigger: chatMessage, fsn_inventory:gui:display, fsn_inventory:items:add, fsn_inventory:me:update, fsn_inventory:ply:done, fsn_inventory:ply:recieve, fsn_inventory:ply:request, mythic_notify:SendAlert
*Exports:* fsn_main

## fsn_inventory/sv_presets.lua

*Role:* server
*Events:* register: fsn_inventory:sendItems, fsn_inventory:sendItemsToArmory, fsn_inventory:sendItemsToStore, handler: fsn_inventory:sendItems, fsn_inventory:sendItemsToArmory, fsn_inventory:sendItemsToStore, onResourceStart, trigger: fsn_inventory:recieveItems, fsn_inventory:sendItems, fsn_police:armory:recieveItemsForArmory, fsn_store:recieveItemsForStore

## fsn_inventory/sv_vehicles.lua

*Role:* server
*Events:* register: fsn_inventory:veh:finished, fsn_inventory:veh:request, fsn_inventory:veh:update, handler: fsn_inventory:veh:finished, fsn_inventory:veh:request, fsn_inventory:veh:update, trigger: fsn_inventory:veh:, mythic_notify:client:SendAlert

## fsn_inventory_dropping/cl_dropping.lua

*Role:* client
*Events:* register: fsn_inventory:drops:send, handler: fsn_inventory:drops:send, trigger: fsn_inventory:drops:collect, fsn_inventory:drops:request, fsn_notify:displayNotification
*Exports:* fsn_inventory

## fsn_inventory_dropping/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_inventory_dropping/sv_dropping.lua

*Role:* server
*Events:* register: fsn_inventory:drops:collect, fsn_inventory:drops:drop, fsn_inventory:drops:request, handler: fsn_inventory:drops:collect, fsn_inventory:drops:drop, fsn_inventory:drops:request, trigger: fsn_inventory:drops:send, fsn_inventory:items:add, mythic_notify:client:SendAlert

## fsn_jail/client.lua

*Role:* client
*Events:* register: fsn_jail:init, fsn_jail:releaseme, fsn_jail:sendme, fsn_jail:spawn:recieve, handler: fsn_jail:init, fsn_jail:releaseme, fsn_jail:sendme, fsn_jail:spawn:recieve, trigger: fsn_hungerandthirst:pause, fsn_hungerandthirst:unpause, fsn_jail:releaseme, fsn_jail:sendme, fsn_jail:spawn, fsn_jail:update:database, fsn_notify:displayNotification, pNotify:SendNotification

## fsn_jail/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_jail/server.lua

*Role:* server
*Events:* register: fsn_jail:sendsuspect, fsn_jail:spawn, fsn_jail:update:database, handler: fsn_jail:sendsuspect, fsn_jail:spawn, fsn_jail:update:database, fsn_main:updateCharacters, trigger: fsn_jail:spawn:recieve, pNotify:SendNotification
*DB Calls:* MySQL.Async.execute("UPDATE `fsn_characters` SET `char_jailtime` = '"..time.."' WHERE `char_id` = '"..char_id.."';", {}), MySQL.Async.execute("UPDATE `fsn_characters` SET `char_jailtime` = '"..time.."' WHERE `char_id` = '"..character.."';", {}), MySQL.Async.fetchAll("SELECT * FROM `fsn_characters` WHERE char_id = @id", { ['@id'] = char_id}, function (result)

## fsn_jewellerystore/client.lua

*Role:* client
*Events:* register: fsn_commands:police:lock, fsn_jewellerystore:case:startrob, fsn_jewellerystore:cases:update, fsn_jewellerystore:doors:State, fsn_jewellerystore:gasDoor:toggle, handler: fsn_commands:police:lock, fsn_jewellerystore:case:startrob, fsn_jewellerystore:cases:update, fsn_jewellerystore:doors:State, fsn_jewellerystore:gasDoor:toggle, trigger: fsn_inventory:gasDoorunlock, fsn_inventory:item:add, fsn_jewellerystore:case:rob, fsn_jewellerystore:doors:toggle, fsn_police:dispatch
*Exports:* fsn_entfinder, fsn_inventory, fsn_police, mythic_notify

## fsn_jewellerystore/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_jewellerystore/server.lua

*Role:* server
*Events:* register: fsn_inventory:gasDoorunlock, fsn_jewellerystore:case:rob, fsn_jewellerystore:cases:request, fsn_jewellerystore:doors:Lock, handler: fsn_inventory:gasDoorunlock, fsn_jewellerystore:case:rob, fsn_jewellerystore:cases:request, fsn_jewellerystore:doors:Lock, trigger: fsn_jewellerystore:case:startrob, fsn_jewellerystore:cases:update, fsn_jewellerystore:doors:State, fsn_jewellerystore:gasDoor:toggle, fsn_notify:displayNotification, fsn_police:911

## fsn_jobs/client.lua

*Role:* client
*Events:* register: fsn_jobs:paycheck, fsn_jobs:quit, handler: fsn_jobs:paycheck, fsn_jobs:quit, trigger: fsn_bank:change:bankAdd, fsn_notify:displayNotification

## fsn_jobs/delivery/client.lua

*Role:* client
*Events:* trigger: fsn_cargarage:makeMine, fsn_fuel:update, fsn_notify:displayNotification
*Exports:* fsn_licenses

## fsn_jobs/farming/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletAdd, fsn_cargarage:makeMine, jFarm:payme, pNotify:SendNotification

## fsn_jobs/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_jobs/garbage/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:bankAdd, fsn_bank:change:bankMinus, fsn_cargarage:makeMine, fsn_fuel:update, fsn_notify:displayNotification

## fsn_jobs/hunting/client.lua

*Role:* client
*Events:* trigger: chatMessage, fsn_inventory:item:add, fsn_inventory:item:take, fsn_notify:displayNotification

## fsn_jobs/mechanic/client.lua

*Role:* client
*Events:* register: fsn_jobs:mechanic:toggleduty, handler: fsn_jobs:mechanic:toggleduty, onClientResourceStart, trigger: chatMessage, fsn_fuel:update, fsn_jobs:mechanic:toggle, fsn_notify:displayNotification
*Commands:* vehinspect, vehrepair
*Exports:* fsn_progress, mythic_notify

## fsn_jobs/mechanic/mechmenu.lua

*Role:* shared
*Events:* trigger: fsn_bank:change:walletMinus, fsn_cargarage:updateVehicle, fsn_notify:displayNotification
*Exports:* fsn_cargarage

## fsn_jobs/mechanic/server.lua

*Role:* server
*Events:* register: fsn_jobs:mechanic:toggle, handler: fsn_jobs:mechanic:toggle, trigger: fsn_jobs:mechanic:toggleduty, fsn_notify:displayNotification

## fsn_jobs/news/client.lua

*Role:* client
*Events:* register: Cam:ToggleCam, Mic:ToggleMic, camera:Activate, fsn_jobs:news:role:Set, handler: Cam:ToggleCam, Mic:ToggleMic, camera:Activate, fsn_jobs:news:role:Set, trigger: Cam:ToggleCam, Mic:ToggleMic, fsn_notify:displayNotification

## fsn_jobs/repo/client.lua

*Role:* client

## fsn_jobs/repo/server.lua

*Role:* server

## fsn_jobs/scrap/client.lua

*Role:* client
*Events:* trigger: chatMessage, fsn_inventory:item:add, fsn_inventory:items:add
*Exports:* fsn_cargarage, fsn_entfinder

## fsn_jobs/server.lua

*Role:* server
*Events:* trigger: fsn_jobs:paycheck

## fsn_jobs/taxi/client.lua

*Role:* client
*Events:* register: fsn_jobs:taxi:accepted, fsn_jobs:taxi:request, handler: fsn_jobs:taxi:accepted, fsn_jobs:taxi:request, fsn_main:character, trigger: fsn_bank:change:bankAdd, fsn_bank:change:bankMinus, fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_cargarage:makeMine, fsn_fuel:update, fsn_notify:displayNotification

## fsn_jobs/taxi/server.lua

*Role:* server

## fsn_jobs/tow/client.lua

*Role:* client
*Events:* register: fsn_jobs:tow:marked, fsn_jobs:tow:request, jTow:afford, jTow:mark, tow:CAD:tow, handler: fsn_jobs:tow:marked, fsn_jobs:tow:request, jTow:afford, jTow:mark, tow:CAD:tow, trigger: fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_cargarage:makeMine, fsn_fuel:update, fsn_main:blip:add, jCAD:tow, jTow:return, jTow:spawn, jTow:success, pNotify:SendNotification

## fsn_jobs/tow/server.lua

*Role:* server
*Events:* register: fsn_jobs:tow:mark, handler: fsn_jobs:tow:mark, trigger: fsn_jobs:tow:marked

## fsn_jobs/trucker/client.lua

*Role:* client
*Events:* trigger: chatMessage, fsn_bank:change:bankMinus, fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_cargarage:makeMine, fsn_fuel:update, fsn_notify:displayNotification

## fsn_jobs/whitelists/client.lua

*Role:* client
*Events:* register: fsn_jobs:whitelist:clock:in, fsn_jobs:whitelist:clock:out, fsn_jobs:whitelist:update, handler: fsn_jobs:whitelist:clock:in, fsn_jobs:whitelist:clock:out, fsn_jobs:whitelist:update, trigger: fsn_jobs:whitelist:add, fsn_jobs:whitelist:clock:in, fsn_jobs:whitelist:clock:out, fsn_jobs:whitelist:remove, fsn_jobs:whitelist:request
*Exports:* fsn_main, mythic_notify

## fsn_jobs/whitelists/server.lua

*Role:* server
*Events:* register: fsn_jobs:whitelist:access:add, fsn_jobs:whitelist:add, fsn_jobs:whitelist:clock:in, fsn_jobs:whitelist:clock:out, fsn_jobs:whitelist:remove, fsn_jobs:whitelist:request, handler: fsn_jobs:whitelist:access:add, fsn_jobs:whitelist:add, fsn_jobs:whitelist:clock:in, fsn_jobs:whitelist:clock:out, fsn_jobs:whitelist:remove, fsn_jobs:whitelist:request, trigger: fsn_jobs:whitelist:clock:in, fsn_jobs:whitelist:clock:out, fsn_jobs:whitelist:update, fsn_notify:displayNotification
*Exports:* fsn_main
*DB Calls:* MySQL.Async.execute('UPDATE `fsn_whitelists` SET `wl_owner` = @owner, `wl_access` = @access WHERE `wl_id` = @id;', {['@id'] = k, ['@owner'] = wl.owner, ['@access'] = json.encode(wl.access)}, function(rowsChanged) end), MySQL.Async.fetchAll('SELECT * FROM `fsn_whitelists`', {}, function(res), MySQL.ready(function()

## fsn_licenses/cl_desk.lua

*Role:* client
*Events:* register: fsn_licenses:giveID, handler: fsn_licenses:giveID, fsn_main:character, trigger: fsn_licenses:id:request

## fsn_licenses/client.lua

*Role:* client
*Events:* register: fsn_licenses:display, fsn_licenses:infraction, fsn_licenses:police:give, fsn_licenses:setinfractions, fsn_licenses:showid, fsn_licenses:update, handler: fsn_licenses:display, fsn_licenses:infraction, fsn_licenses:police:give, fsn_licenses:setinfractions, fsn_licenses:showid, fsn_licenses:update, fsn_main:character, trigger: fsn_bank:change:walletMinus, fsn_licenses:chat, fsn_licenses:check, fsn_licenses:update, fsn_notify:displayNotification

## fsn_licenses/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_licenses/server.lua

*Role:* server
*Events:* register: fsn_licenses:chat, fsn_licenses:check, fsn_licenses:update, handler: fsn_licenses:chat, fsn_licenses:check, fsn_licenses:update, trigger: chatMessage, fsn_licenses:update
*DB Calls:* MySQL.Async.execute('UPDATE `fsn_characters` SET `char_licenses` = @licenses WHERE `char_id` = @charid', {

## fsn_licenses/sv_desk.lua

*Role:* server
*Events:* register: fsn_licenses:id:request, handler: fsn_licenses:id:request, trigger: fsn_inventory:items:add

## fsn_loadingscreen/fxmanifest.lua

*Role:* shared

## fsn_loadingscreen/index.html

*Role:* NUI

## fsn_main/banmanager/sv_bans.lua

*Role:* server
*Events:* handler: playerConnecting
*DB Calls:* MySQL.Sync.execute("UPDATE `fsn_users` SET `identifiers` = '"..update.."' WHERE `user_id` = "..sql[1]['user_id']..";"), local check = MySQL.Sync.fetchAll(sql), local sql = MySQL.Sync.fetchAll("SELECT * FROM `fsn_users` WHERE `steamid` = '"..steamid.."'")

## fsn_main/cl_utils.lua

*Role:* client
*Exports:* fsn_main

## fsn_main/debug/cl_subframetime.js

*Role:* client

## fsn_main/debug/sh_debug.lua

*Role:* shared
*Events:* handler: fsn_main:debug_toggle, trigger: fsn_main:debug_toggle
*Commands:* fsn_debug

## fsn_main/debug/sh_scheduler.lua

*Role:* shared
*Events:* handler: fsn_main:debug_toggle
*Exports:* fsn_main

## fsn_main/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_main/gui/index.html

*Role:* NUI

## fsn_main/gui/index.js

*Role:* NUI

## fsn_main/gui/logo_new.png

*Role:* shared

## fsn_main/gui/logo_old.png

*Role:* shared

## fsn_main/gui/logos/discord.png

*Role:* shared

## fsn_main/gui/logos/discord.psd

*Role:* shared

## fsn_main/gui/logos/logo.png

*Role:* shared

## fsn_main/gui/logos/main.psd

*Role:* shared

## fsn_main/gui/motd.txt

*Role:* shared

## fsn_main/gui/pdown.ttf

*Role:* shared

## fsn_main/hud/client.lua

*Role:* client
*Events:* register: fsn_main:gui:bank:change, fsn_main:gui:both:display, fsn_main:gui:money:change, handler: fsn_main:gui:bank:change, fsn_main:gui:both:display, fsn_main:gui:money:change
*NUI Messages:* SendNUIMessage

## fsn_main/initial/client.lua

*Role:* client
*Events:* register: fsn_main:charMenu, fsn_main:character, fsn_main:characterSaving, fsn_main:initiateCharacter, fsn_main:sendCharacters, spawnme, handler: fsn_inventory:buyItem, fsn_main:charMenu, fsn_main:characterSaving, fsn_main:initiateCharacter, fsn_main:sendCharacters, spawnme, trigger: PlayerSpawned, fsn:playerReady, fsn_bank:change:walletMinus, fsn_inventory:item:add, fsn_main:charMenu, fsn_main:createCharacter, fsn_main:getCharacter, fsn_main:requestCharacters, fsn_main:saveCharacter, fsn_notify:displayNotification, fsn_spawnmanager:start
*Exports:* fsn_clothing, fsn_criminalmisc
*NUI Callbacks:* createCharacter, spawnCharacter
*NUI Messages:* SendNUIMessage
*DB Calls:* char = char[1] -- lol MySQL shit

## fsn_main/initial/desc.txt

*Role:* shared

## fsn_main/initial/server.lua

*Role:* server
*Events:* register: fsn_cargarage:buyVehicle, fsn_inventory:database:update, fsn_main:createCharacter, fsn_main:getCharacter, fsn_main:requestCharacters, fsn_main:saveCharacter, fsn_main:update:myCharacter, fsn_main:updateCharNumber, fsn_main:updateCharacters, fsn_police:chat:ticket, handler: fsn_cargarage:buyVehicle, fsn_inventory:database:update, fsn_main:createCharacter, fsn_main:getCharacter, fsn_main:requestCharacters, fsn_main:saveCharacter, fsn_main:update:myCharacter, fsn_main:updateCharNumber, fsn_main:updateCharacters, fsn_main:validatePlayer, fsn_police:chat:ticket, playerDropped, trigger: chatMessage, fsn_main:characterSaving, fsn_main:initiateCharacter, fsn_main:money:initChar, fsn_main:sendCharacters, fsn_main:updateCharacters
*DB Calls:* -- TODO: Investigate if the steamid check can be put into the MySQL query, MySQL.Async.execute("INSERT INTO `fsn_vehicles` (`veh_id`, `char_id`, `veh_displayname`, `veh_spawnname`, `veh_plate`, `veh_inventory`, `veh_details`, `veh_finance`, `veh_type`, `veh_status`, `veh_garage`) VALUES (NULL, @charid, @displayname, @spawnname, @plate, '{}', @details, @finance, @vehtype, @status, 0);", {, MySQL.Sync.execute("INSERT INTO `fsn_characters` (`char_id`, `steamid`, `char_fname`, `char_lname`, `char_dob`, `char_desc`, `char_licenses`, `char_contacts`, `char_money`, `char_bank`, `char_model`, `mdl_extras`, `char_inventory`, `char_weapons`, `char_police`, `char_ems`) VALUES (NULL, @steamid, @char_fname, @char_lname, @char_dob, @char_desc, '{}', '{}', '500', '5000', '{}', '[]', '[]', '[]', '0', '0')", {['@steamid'] = steamid, ['@char_fname'] = data.char_fname, ['@char_lname'] = data.char_lname, ['@char_dob'] = data.char_dob, ['@char_desc'] = data.char_desc }), MySQL.Sync.execute("UPDATE `fsn_characters` SET `char_inventory` = @inventory WHERE `fsn_characters`.`char_id` = @id", {['@id'] = charid, ['@inventory'] = inv}), MySQL.Sync.execute("UPDATE `fsn_characters` SET `char_model` = @model, `mdl_extras` = '"..vars.."', `char_weapons` = @weapons WHERE `fsn_characters`.`char_id` = @id", {['@id'] = charid, ['@model'] = model, ['@weapons'] = weapons}), local char = MySQL.Sync.fetchAll("SELECT * FROM `fsn_characters` WHERE `char_id` = '"..char_id.."'"), local characters = MySQL.Sync.fetchAll("SELECT * FROM `fsn_characters` WHERE `steamid` = '"..steamid.."'")

## fsn_main/misc/db.lua

*Role:* shared
*DB Calls:* MySQL.Async.execute(sql, {}, function(rc), MySQL.ready(function ()

## fsn_main/misc/logging.lua

*Role:* shared
*Events:* register: fsn_main:logging:addLog, handler: fsn_main:logging:addLog

## fsn_main/misc/servername.lua

*Role:* server

## fsn_main/misc/shitlordjumping.lua

*Role:* shared

## fsn_main/misc/timer.lua

*Role:* shared

## fsn_main/misc/version.lua

*Role:* shared
*Events:* handler: onResourceStart, playerConnecting, trigger: fsn_main:version

## fsn_main/money/client.lua

*Role:* client
*Events:* register: fsn_bank:change:bankAdd, fsn_bank:change:bankMinus, fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_main:displayBankandMoney, fsn_main:money:update, fsn_main:money:updateSilent, fsn_police:search:start:money, handler: fsn_bank:change:bankAdd, fsn_bank:change:bankMinus, fsn_bank:change:bankandwallet, fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_bank:request:both, fsn_lscustoms:check, fsn_lscustoms:check2, fsn_lscustoms:check3, fsn_main:displayBankandMoney, fsn_main:money:update, fsn_main:money:updateSilent, fsn_police:search:start:money, trigger: fsn_bank:change:walletMinus, fsn_bank:update:both, fsn_lscustoms:receive, fsn_lscustoms:receive2, fsn_lscustoms:receive3, fsn_main:gui:bank:change, fsn_main:gui:both:display, fsn_main:gui:money:change, fsn_main:money:bank:Add, fsn_main:money:bank:Minus, fsn_main:money:bank:Set, fsn_main:money:wallet:Add, fsn_main:money:wallet:Minus, fsn_main:money:wallet:Set, fsn_notify:displayNotification, fsn_police:search:end:money

## fsn_main/money/server.lua

*Role:* server
*Events:* register: fsn_main:money:bank:Add, fsn_main:money:bank:Minus, fsn_main:money:bank:Set, fsn_main:money:initChar, fsn_main:money:wallet:Add, fsn_main:money:wallet:GiveCash, fsn_main:money:wallet:Minus, fsn_main:money:wallet:Set, handler: fsn_main:money:bank:Add, fsn_main:money:bank:Minus, fsn_main:money:bank:Set, fsn_main:money:initChar, fsn_main:money:wallet:Add, fsn_main:money:wallet:GiveCash, fsn_main:money:wallet:Minus, fsn_main:money:wallet:Set, trigger: fsn_main:gui:bank:addMoney, fsn_main:gui:bank:changeAmount, fsn_main:gui:bank:minusMoney, fsn_main:gui:minusMoney, fsn_main:gui:money:addMoney, fsn_main:gui:money:changeAmount, fsn_main:logging:addLog, fsn_main:money:update, fsn_main:money:updateSilent, fsn_main:updateMoneyStore, fsn_notify:displayNotification, fsn_phones:SYS:addTransaction
*DB Calls:* MySQL.Sync.execute("UPDATE `fsn_characters` SET `char_bank` = @money WHERE `char_id` = @id", {['@id'] = v.char_id, ['@money'] = v.bank}), MySQL.Sync.execute("UPDATE `fsn_characters` SET `char_money` = @money WHERE `char_id` = @id", {['@id'] = v.char_id, ['@money'] = v.wallet})

## fsn_main/playermanager/client.lua

*Role:* client
*Events:* handler: playerSpawned, trigger: fsn_main:charMenu

## fsn_main/playermanager/server.lua

*Role:* server
*Events:* register: fsn_main:validatePlayer, handler: fsn_main:validatePlayer, playerConnecting, playerDropped, trigger: chatMessage, fsn_main:characterSaving
*DB Calls:* MySQL.Async.execute('UPDATE `fsn_vehicles` SET `veh_status` = 0 WHERE `veh_status` = 1', {}, function() end), MySQL.Async.fetchAll("SELECT * FROM fsn_users WHERE steamid = '"..identity[1].."'", {}, function(user), MySQL.Sync.execute("INSERT INTO `fsn_users` (`name`, `steamid`, `connections`, `banned`, `banned_r`) VALUES ('"..playername.."', '"..identity[1].."', '1', '0', '')"), MySQL.Sync.execute("UPDATE `fsn_users` SET `connections` = '"..connections.."' WHERE `fsn_users`.`steamid` = '"..identity[1].."';"), MySQL.ready(function()

## fsn_main/server_settings/sh_settings.lua

*Role:* server

## fsn_main/sv_utils.lua

*Role:* server
*Events:* handler: fsn:getFsnObject, fsn_main:updateCharacters, fsn_main:updateMoneyStore, playerDropped

## fsn_menu/fxmanifest.lua

*Role:* shared

## fsn_menu/gui/ui.css

*Role:* NUI

## fsn_menu/gui/ui.html

*Role:* NUI

## fsn_menu/gui/ui.js

*Role:* NUI

## fsn_menu/main_client.lua

*Role:* client
*Events:* register: fsn_commands:getHDC, handler: fsn_commands:getHDC, trigger: EngineToggle:Engine, chatMessage, fsn_commands:me, fsn_criminalmisc:racing:createRace, fsn_licenses:display, fsn_licenses:showid, fsn_notify:displayNotification, fsn_police:GetInVehicle, fsn_police:Sit, fsn_police:ToggleFollow, fsn_police:ToggleK9, fsn_vehiclecontrol:giveKeys
*Exports:* fsn_apartments
*NUI Callbacks:* escape
*NUI Messages:* SendNUIMessage

## fsn_menu/ui.css

*Role:* NUI

## fsn_menu/ui.html

*Role:* NUI

## fsn_menu/ui.js

*Role:* NUI

## fsn_needs/client.lua

*Role:* client
*Events:* register: fsn_ems:reviveMe, fsn_hungerandthirst:pause, fsn_hungerandthirst:unpause, fsn_inventory:use:drink, fsn_inventory:use:food, fsn_needs:stress:add, fsn_needs:stress:remove, handler: fsn_ems:reviveMe, fsn_hungerandthirst:pause, fsn_hungerandthirst:unpause, fsn_inventory:initChar, fsn_inventory:use:drink, fsn_inventory:use:food, fsn_needs:stress:add, fsn_needs:stress:remove, trigger: fsn_ems:killMe, fsn_needs:stress:add, fsn_notify:displayNotification

## fsn_needs/fxmanifest.lua

*Role:* shared

## fsn_needs/hud.lua

*Role:* shared
*Events:* register: fsn_inventory:useArmor, handler: fsn_inventory:useArmor, trigger: fsn_inventory:item:take
*Exports:* fsn_needs, fsn_progress, mythic_notify

## fsn_needs/vending.lua

*Role:* shared
*Events:* trigger: fsn_bank:change:walletMinus, fsn_inventory:use:drink

## fsn_newchat/README.md

*Role:* shared

## fsn_newchat/cl_chat.lua

*Role:* client
*Events:* register: __cfx_internal:serverPrint, _chat:messageEntered, chat:addMessage, chat:addSuggestion, chat:addSuggestions, chat:addTemplate, chat:clear, chat:removeSuggestion, chatMessage, handler: __cfx_internal:serverPrint, chat:addMessage, chat:addSuggestion, chat:addSuggestions, chat:addTemplate, chat:clear, chat:removeSuggestion, chatMessage, onClientResourceStart, trigger: _chat:messageEntered, chat:addSuggestions, chat:init, chatMessage
*NUI Callbacks:* chatResult, loaded
*NUI Messages:* SendNUIMessage

## fsn_newchat/fxmanifest.lua

*Role:* shared

## fsn_newchat/html/App.js

*Role:* NUI

## fsn_newchat/html/Message.js

*Role:* NUI

## fsn_newchat/html/Suggestions.js

*Role:* NUI

## fsn_newchat/html/config.default.js

*Role:* NUI

## fsn_newchat/html/index.css

*Role:* NUI

## fsn_newchat/html/index.html

*Role:* NUI

## fsn_newchat/html/vendor/animate.3.5.2.min.css

*Role:* NUI

## fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css

*Role:* NUI

## fsn_newchat/html/vendor/fonts/LatoBold.woff2

*Role:* shared

## fsn_newchat/html/vendor/fonts/LatoBold2.woff2

*Role:* shared

## fsn_newchat/html/vendor/fonts/LatoLight.woff2

*Role:* shared

## fsn_newchat/html/vendor/fonts/LatoLight2.woff2

*Role:* shared

## fsn_newchat/html/vendor/fonts/LatoRegular.woff2

*Role:* shared

## fsn_newchat/html/vendor/fonts/LatoRegular2.woff2

*Role:* shared

## fsn_newchat/html/vendor/latofonts.css

*Role:* NUI

## fsn_newchat/html/vendor/vue.2.3.3.min.js

*Role:* NUI

## fsn_newchat/sv_chat.lua

*Role:* server
*Events:* register: __cfx_internal:commandFallback, _chat:messageEntered, chat:addMessage, chat:addSuggestion, chat:addTemplate, chat:clear, chat:init, chat:removeSuggestion, handler: __cfx_internal:commandFallback, _chat:messageEntered, chat:init, onServerResourceStart, playerDropped, trigger: chat:addSuggestions, chatMessage, fsn_main:logging:addLog
*Commands:* say

## fsn_notify/cl_notify.lua

*Role:* client
*Events:* register: chatMessage, fsn_notify:displayNotification, pNotify:SendNotification, pNotify:SetQueueMax, handler: chatMessage, fsn_notify:displayNotification, pNotify:SendNotification, pNotify:SetQueueMax, trigger: pNotify:SendNotification
*NUI Messages:* SendNUIMessage

## fsn_notify/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_notify/html/index.html

*Role:* NUI

## fsn_notify/html/noty.css

*Role:* NUI

## fsn_notify/html/noty.js

*Role:* NUI
*Exports:* Noty, default

## fsn_notify/html/noty_license.txt

*Role:* shared

## fsn_notify/html/pNotify.js

*Role:* NUI

## fsn_notify/html/themes.css

*Role:* NUI

## fsn_notify/server.lua

*Role:* server
*Events:* register: fsn_notify:displayNotification, handler: fsn_notify:displayNotification, trigger: pNotify:SendNotification

## fsn_phones/cl_phone.lua

*Role:* client
*Events:* register: fsn_phones:GUI:notification, fsn_phones:SYS:addCall, fsn_phones:SYS:addTransaction, fsn_phones:SYS:receiveGarage, fsn_phones:SYS:recieve:details, fsn_phones:SYS:updateAdverts, fsn_phones:SYS:updateNumber, fsn_phones:USE:Email, fsn_phones:USE:Message, fsn_phones:USE:Phone, fsn_phones:USE:Tweet, fsn_phones:UTIL:displayNumber, handler: fsn_main:character, fsn_phones:GUI:notification, fsn_phones:SYS:addTransaction, fsn_phones:SYS:receiveGarage, fsn_phones:SYS:recieve:details, fsn_phones:SYS:updateAdverts, fsn_phones:SYS:updateNumber, fsn_phones:USE:Email, fsn_phones:USE:Message, fsn_phones:USE:Phone, fsn_phones:USE:Tweet, fsn_phones:UTIL:displayNumber, trigger: InteractSound_SV:PlayWithinDistance, chatMessage, fsn_notify:displayNotification, fsn_phones:GUI:notification, fsn_phones:SYS:newNumber, fsn_phones:SYS:request:details, fsn_phones:SYS:requestGarage, fsn_phones:SYS:sendTweet, fsn_phones:SYS:set:details, fsn_phones:SYS:updateAdverts, fsn_phones:USE:sendAdvert, fsn_phones:USE:sendMessage, fsn_phones:UTIL:chat
*Exports:* fsn_inventory, fsn_jobs, fsn_main, mythic_notify
*NUI Callbacks:* messageactive, messageinactive
*NUI Messages:* SendNUIMessage

## fsn_phones/darkweb/cl_order.lua

*Role:* client
*Events:* register: fsn_phones:USE:darkweb:order, handler: fsn_phones:USE:darkweb:order, trigger: fsn_notify:displayNotification

## fsn_phones/datastore/contacts/sample.txt

*Role:* shared

## fsn_phones/datastore/messages/sample.txt

*Role:* shared

## fsn_phones/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_phones/html/img/Apple/Ads.png

*Role:* shared

## fsn_phones/html/img/Apple/Banner/Adverts.png

*Role:* shared

## fsn_phones/html/img/Apple/Banner/Grey.png

*Role:* shared

## fsn_phones/html/img/Apple/Banner/Yellow.png

*Role:* shared

## fsn_phones/html/img/Apple/Banner/fleeca.png

*Role:* shared

## fsn_phones/html/img/Apple/Banner/log-inBackground.png

*Role:* shared

## fsn_phones/html/img/Apple/Contact.png

*Role:* shared

## fsn_phones/html/img/Apple/Fleeca.png

*Role:* shared

## fsn_phones/html/img/Apple/Frame.png

*Role:* shared

## fsn_phones/html/img/Apple/Garage.png

*Role:* shared

## fsn_phones/html/img/Apple/Lock icon.png

*Role:* shared

## fsn_phones/html/img/Apple/Mail.png

*Role:* shared

## fsn_phones/html/img/Apple/Messages.png

*Role:* shared

## fsn_phones/html/img/Apple/Noti.png

*Role:* shared

## fsn_phones/html/img/Apple/Phone.png

*Role:* shared

## fsn_phones/html/img/Apple/Twitter.png

*Role:* shared

## fsn_phones/html/img/Apple/Wallet.png

*Role:* shared

## fsn_phones/html/img/Apple/Whitelist.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/adverts.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/call.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/contacts.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/fleeca.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/garage.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/mail.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/messages.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/twitter.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/wallet.png

*Role:* shared

## fsn_phones/html/img/Apple/banner_icons/wl.png

*Role:* shared

## fsn_phones/html/img/Apple/battery.png

*Role:* shared

## fsn_phones/html/img/Apple/call-in.png

*Role:* shared

## fsn_phones/html/img/Apple/call-out.png

*Role:* shared

## fsn_phones/html/img/Apple/darkweb.png

*Role:* shared

## fsn_phones/html/img/Apple/default-avatar.png

*Role:* shared

## fsn_phones/html/img/Apple/feedgrey.png

*Role:* shared

## fsn_phones/html/img/Apple/fleeca-bg.png

*Role:* shared

## fsn_phones/html/img/Apple/missed-in.png

*Role:* shared

## fsn_phones/html/img/Apple/missed-out.png

*Role:* shared

## fsn_phones/html/img/Apple/node_other_server__1247323.png

*Role:* server

## fsn_phones/html/img/Apple/signal.png

*Role:* shared

## fsn_phones/html/img/Apple/wallpaper.png

*Role:* shared

## fsn_phones/html/img/Apple/wifi.png

*Role:* shared

## fsn_phones/html/img/cursor.png

*Role:* shared

## fsn_phones/html/index.css

*Role:* NUI

## fsn_phones/html/index.html

*Role:* NUI

## fsn_phones/html/index.html.old

*Role:* shared

## fsn_phones/html/index.js

*Role:* NUI

## fsn_phones/html/pages_css/iphone/adverts.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/call.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/contacts.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/darkweb.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/email.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/fleeca.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/garage.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/home.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/main.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/messages.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/pay.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/phone.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/twitter.css

*Role:* NUI

## fsn_phones/html/pages_css/iphone/whitelists.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/adverts.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/call.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/contacts.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/email.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/fleeca.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/home.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/main.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/messages.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/pay.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/phone.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/twitter.css

*Role:* NUI

## fsn_phones/html/pages_css/samsung/whitelists.css

*Role:* NUI

## fsn_phones/sv_phone.lua

*Role:* server
*Events:* register: fsn_phones:SYS:newNumber, fsn_phones:SYS:request:details, fsn_phones:SYS:requestGarage, fsn_phones:SYS:sendTweet, fsn_phones:SYS:set:details, fsn_phones:USE:requestAdverts, fsn_phones:USE:sendAdvert, fsn_phones:USE:sendMessage, fsn_phones:UTIL:chat, handler: c, fsn_phones:SYS:newNumber, fsn_phones:SYS:request:details, fsn_phones:SYS:requestGarage, fsn_phones:SYS:sendTweet, fsn_phones:SYS:set:details, fsn_phones:USE:sendAdvert, fsn_phones:USE:sendMessage, fsn_phones:UTIL:chat, playerDropped, trigger: chatMessage, fsn_main:updateCharNumber, fsn_phones:GUI:notification, fsn_phones:SYS:receiveGarage, fsn_phones:SYS:recieve:details, fsn_phones:SYS:set:details, fsn_phones:SYS:updateAdverts, fsn_phones:SYS:updateNumber, fsn_phones:USE:Email, fsn_phones:USE:Message, fsn_phones:USE:Tweet
*Exports:* fsn_main
*DB Calls:* MySQL.Async.execute('UPDATE `fsn_characters` SET `char_phone` = @number WHERE `fsn_characters`.`char_id` = @charid;', {['@charid'] = charid, ['@number'] = number}, function(rowsChanged), MySQL.Async.fetchAll("SELECT * FROM fsn_vehicles where char_id = @charid", {['@charid'] = char_id }, function(tbl)

## fsn_playerlist/client.lua

*Role:* client
*Events:* register: fsn_main:updateCharacters, handler: fsn_main:updateCharacters, trigger: chatMessage
*NUI Messages:* SendNUIMessage

## fsn_playerlist/fxmanifest.lua

*Role:* shared

## fsn_playerlist/gui/index.html

*Role:* NUI

## fsn_playerlist/gui/index.js

*Role:* NUI

## fsn_police/K9/client.lua

*Role:* client
*Events:* register: fsn_police:GetInVehicle, fsn_police:Sit, fsn_police:ToggleK9, fsn_police:k9:search:person:finish, fsn_police:k9:search:person:me, handler: fsn_police:GetInVehicle, fsn_police:Sit, fsn_police:ToggleK9, fsn_police:k9:search:person:finish, fsn_police:k9:search:person:me, trigger: fsn_notify:displayNotification, fsn_police:k9:search:person:end
*Exports:* fsn_inventory

## fsn_police/K9/server.lua

*Role:* server
*Events:* register: fsn_police:k9:search:person:end, handler: fsn_police:k9:search:person:end, trigger: fsn_police:k9:search:person:finish

## fsn_police/MDT/gui/images/background.png

*Role:* shared

## fsn_police/MDT/gui/images/base_pc.png

*Role:* shared

## fsn_police/MDT/gui/images/icons/booking.png

*Role:* shared

## fsn_police/MDT/gui/images/icons/cpic.png

*Role:* shared

## fsn_police/MDT/gui/images/icons/dmv.png

*Role:* shared

## fsn_police/MDT/gui/images/icons/warrants.png

*Role:* shared

## fsn_police/MDT/gui/images/pwr_icon.png

*Role:* shared

## fsn_police/MDT/gui/images/win_icon.png

*Role:* shared

## fsn_police/MDT/gui/index.css

*Role:* NUI

## fsn_police/MDT/gui/index.html

*Role:* NUI

## fsn_police/MDT/gui/index.js

*Role:* NUI

## fsn_police/MDT/mdt_client.lua

*Role:* client
*Events:* register: fsn_police:MDT:receivewarrants, fsn_police:MDT:toggle, fsn_police:database:CPIC:search:result, handler: fsn_police:MDT:receivewarrants, fsn_police:MDT:toggle, fsn_police:database:CPIC:search:result, trigger: chatMessage, fsn_commands:me, fsn_emotecontrol:police:tablet, fsn_jail:sendsuspect, fsn_notify:displayNotification, fsn_police:MDT:requestwarrants, fsn_police:MDT:toggle, fsn_police:MDT:warrant, fsn_police:MDTremovewarrant, fsn_police:chat:ticket, fsn_police:database:CPIC, fsn_police:ticket
*NUI Callbacks:* booking-submit-now, booking-submit-warrant, closeMDT, mdt-remove-warrant, mdt-request-warrants, setWaypoint
*NUI Messages:* SendNUIMessage

## fsn_police/MDT/mdt_server.lua

*Role:* server
*Events:* register: fsn_police:MDT:requestwarrants, fsn_police:MDT:warrant, fsn_police:MDTremovewarrant, fsn_police:database:CPIC, fsn_police:database:CPIC:search, handler: fsn_police:MDT:requestwarrants, fsn_police:MDT:warrant, fsn_police:MDTremovewarrant, fsn_police:database:CPIC, fsn_police:database:CPIC:search, trigger: chatMessage, fsn_police:911, fsn_police:MDT:receivewarrants, fsn_police:database:CPIC:search:result
*DB Calls:* MySQL.Async.execute('DELETE FROM `fsn_warrants` WHERE `fsn_warrants`.`war_id` = @id', {['@id'] = id}), MySQL.Async.execute('INSERT INTO `fsn_tickets` (`ticket_id`, `officer_id`, `officer_name`, `receiver_id`, `ticket_amount`, `ticket_jailtime`, `ticket_charges`, `ticket_date`) VALUES (NULL, @officer_id, @officer_name, @receiver_id, @ticket_amount, @ticket_jailtime, @ticket_charges, @ticket_time)', {, MySQL.Async.execute('INSERT INTO `fsn_warrants` (`war_id`, `suspect_name`, `officer_name`, `war_charges`, `war_times`, `war_fine`, `war_desc`, `war_status`, `war_date`) VALUES (NULL, @suspect_name, @officer_name, @war_charges, @war_times, @war_fine, @war_desc, @war_status, @war_time)', {, MySQL.Async.fetchAll('SELECT * FROM `fsn_tickets` WHERE `receiver_id` = @id', {['@id'] = idee}, function(results), MySQL.Async.fetchAll('SELECT * FROM `fsn_warrants` WHERE `suspect_name` LIKE @name AND `war_status` = "ACTIVE"', {['@name'] = name}, function(results), MySQL.Async.fetchAll('SELECT * FROM `fsn_warrants` WHERE `war_status` = "ACTIVE"', {['@name'] = name}, function(results)

## fsn_police/armory/cl_armory.lua

*Role:* client
*Events:* register: fsn_police:armory:request, handler: fsn_police:armory:request, trigger: fsn_police:armory:request

## fsn_police/armory/sv_armory.lua

*Role:* server
*Events:* register: fsn_police:armory:boughtOne, fsn_police:armory:closedArmory, fsn_police:armory:recieveItemsForArmory, fsn_police:armory:request, handler: fsn_police:armory:boughtOne, fsn_police:armory:closedArmory, fsn_police:armory:recieveItemsForArmory, fsn_police:armory:request, onResourceStart, playerDropped, trigger: fsn_inventory:police_armory:recieve, fsn_inventory:sendItemsToArmory, fsn_main:logging:addLog, fsn_notify:displayNotification

## fsn_police/client.lua

*Role:* client
*Events:* register: fsn_police:911, fsn_police:911r, fsn_police:MDT:vehicledetails, fsn_police:command:duty, fsn_police:cuffs:startCuffed, fsn_police:cuffs:startCuffing, fsn_police:cuffs:startunCuffed, fsn_police:cuffs:startunCuffing, fsn_police:cuffs:toggleHard, fsn_police:init, fsn_police:pd:toggleDrag, fsn_police:ply:toggleDrag, fsn_police:putMeInVeh, fsn_police:update, fsn_police:updateLevel, handler: fsn_police:911, fsn_police:911r, fsn_police:MDT:vehicledetails, fsn_police:command:duty, fsn_police:cuffs:startCuffed, fsn_police:cuffs:startCuffing, fsn_police:cuffs:startunCuffed, fsn_police:cuffs:startunCuffing, fsn_police:cuffs:toggleHard, fsn_police:init, fsn_police:pd:toggleDrag, fsn_police:ply:toggleDrag, fsn_police:putMeInVeh, fsn_police:update, fsn_police:updateLevel, trigger: InteractSound_SV:PlayWithinDistance, chatMessage, fsn_criminalmisc:weapons:add:police, fsn_inventory:items:add, fsn_notify:displayNotification, fsn_police:cuffs:requestCuff, fsn_police:cuffs:requestunCuff, fsn_police:cuffs:toggleEscort, fsn_police:cuffs:toggleHard, fsn_police:offDuty, fsn_police:onDuty, fsn_police:requestUpdate

## fsn_police/dispatch.lua

*Role:* shared
*Events:* register: fsn_commands:police:gsrMe, fsn_police:dispatch:toggle, fsn_police:dispatchcall, handler: fsn_commands:police:gsrMe, fsn_police:dispatch:toggle, fsn_police:dispatchcall, trigger: chatMessage, fsn_commands:police:gsrResult, fsn_evidence:ped:addState, fsn_main:blip:add, fsn_notify:displayNotification, fsn_police:dispatch
*Exports:* fsn_criminalmisc
*NUI Messages:* SendNUIMessage

## fsn_police/dispatch/client.lua

*Role:* client
*Events:* register: fsn_main:blip:add, fsn_main:blip:clear, handler: fsn_main:blip:add, fsn_main:blip:clear, trigger: fsn_notify:displayNotification
*Exports:* fsn_ems, fsn_jobs, fsn_police

## fsn_police/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_police/pedmanagement/client.lua

*Role:* client

## fsn_police/pedmanagement/server.lua

*Role:* server

## fsn_police/radar/client.lua

*Role:* client
*Events:* register: fsn_police:radar:toggle, handler: fsn_police:radar:toggle, trigger: chatMessage

## fsn_police/server.lua

*Role:* server
*Events:* register: fsn_police:cuffs:requestCuff, fsn_police:cuffs:requestunCuff, fsn_police:cuffs:toggleEscort, fsn_police:cuffs:toggleHard, fsn_police:dispatch, fsn_police:offDuty, fsn_police:onDuty, fsn_police:requestUpdate, fsn_police:runplate, fsn_police:runplate::target, fsn_police:search:end:inventory, fsn_police:search:end:money, fsn_police:search:end:weapons, fsn_police:ticket, fsn_police:toggleHandcuffs, fsn_police:update, handler: fsn_police:cuffs:requestCuff, fsn_police:cuffs:requestunCuff, fsn_police:cuffs:toggleEscort, fsn_police:cuffs:toggleHard, fsn_police:dispatch, fsn_police:offDuty, fsn_police:onDuty, fsn_police:requestUpdate, fsn_police:runplate, fsn_police:runplate::target, fsn_police:search:end:inventory, fsn_police:search:end:money, fsn_police:search:end:weapons, fsn_police:ticket, fsn_police:toggleHandcuffs, playerDropped, trigger: chatMessage, fsn_bank:change:bankMinus, fsn_notify:displayNotification, fsn_police:MDT:vehicledetails, fsn_police:cuffs:startCuffed, fsn_police:cuffs:startCuffing, fsn_police:cuffs:startunCuffed, fsn_police:cuffs:startunCuffing, fsn_police:cuffs:toggleHard, fsn_police:dispatchcall, fsn_police:handcuffs:toggle, fsn_police:pd:toggleDrag, fsn_police:ply:toggleDrag, fsn_police:runplate, fsn_police:update
*DB Calls:* MySQL.Async.fetchAll('SELECT * FROM `fsn_characters` WHERE `char_id` = @charid', {['@charid'] = vehicle[1].char_id}, function(char), MySQL.Async.fetchAll('SELECT * FROM `fsn_vehicles` WHERE `veh_plate` = @plate', {['@plate'] = plate}, function(vehicle), MySQL.Async.fetchAll('SELECT * FROM `fsn_warrants` WHERE `suspect_name` LIKE @name AND `war_status` = "active"', {['@name'] = char[1].char_fname..' '..char[1].char_lname}, function(warrants)

## fsn_police/tackle/client.lua

*Role:* client
*Events:* register: Tackle:Client:TacklePlayer, handler: Tackle:Client:TacklePlayer, trigger: Tackle:Server:TacklePlayer, chatMessage

## fsn_police/tackle/server.lua

*Role:* server
*Events:* register: Tackle:Server:TacklePlayer, handler: Tackle:Server:TacklePlayer, trigger: Tackle:Client:TacklePlayer

## fsn_priority/administration.lua

*Role:* shared
*Events:* handler: chatMessage, trigger: chatMessage
*DB Calls:* MySQL.Async.fetchAll('SELECT * FROM `fsn_users` WHERE `steamid` = @steamid', {['@steamid'] = steamid}, function(res), MySQL.Sync.execute("UPDATE `fsn_users` SET `priority` = 0 WHERE `steamid` = @steamid", {['@steamid'] = steamid}), MySQL.Sync.execute("UPDATE `fsn_users` SET `priority` = @prio WHERE `steamid` = @steamid", {['@prio'] = split[5], ['@steamid'] = steamid})

## fsn_priority/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_priority/server.lua

*Role:* server
*DB Calls:* MySQL.Async.fetchAll('SELECT * FROM `fsn_users` WHERE `priority` != 0', {}, function(res), MySQL.ready(function()

## fsn_progress/client.lua

*Role:* client
*Exports:* fsn_main

## fsn_progress/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_progress/gui/index.html

*Role:* NUI

## fsn_progress/gui/index.js

*Role:* NUI

## fsn_properties/cl_manage.lua

*Role:* client
*Events:* register: fsn_properties:keys:give, handler: fsn_properties:keys:give

## fsn_properties/cl_properties.lua

*Role:* client
*Events:* register: fsn_properties:access, fsn_properties:inv:closed, fsn_properties:inv:update, fsn_properties:updateXYZ, handler: fsn_main:character, fsn_properties:access, fsn_properties:inv:closed, fsn_properties:inv:update, fsn_properties:updateXYZ, trigger: chatMessage, fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_criminalmisc:weapons:add:tbl, fsn_criminalmisc:weapons:destroy, fsn_inventory:prop:recieve, fsn_properties:access, fsn_properties:buy, fsn_properties:leave, fsn_properties:rent:check, fsn_properties:rent:pay, fsn_properties:request, fsn_properties:requestKeys
*Exports:* fsn_criminalmisc, fsn_main, fsn_police, mythic_notify
*NUI Messages:* SendNUIMessage

## fsn_properties/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_properties/nui/ui.css

*Role:* NUI

## fsn_properties/nui/ui.html

*Role:* NUI

## fsn_properties/nui/ui.js

*Role:* NUI

## fsn_properties/sv_conversion.lua

*Role:* server

## fsn_properties/sv_properties.lua

*Role:* server
*Events:* register: fsn_properties:access, fsn_properties:buy, fsn_properties:leave, fsn_properties:realator:clock, fsn_properties:rent:check, fsn_properties:rent:pay, fsn_properties:request, handler: fsn_properties:access, fsn_properties:buy, fsn_properties:leave, fsn_properties:realator:clock, fsn_properties:rent:check, fsn_properties:rent:pay, fsn_properties:request, trigger: chatMessage, fsn_bank:change:walletMinus, fsn_properties:access, fsn_properties:updateXYZ, mythic_notify:client:SendAlert
*Exports:* fsn_main
*DB Calls:* MySQL.Async.fetchAll('SELECT * FROM `fsn_properties`', {}, function(res), MySQL.Sync.execute("UPDATE `fsn_properties` SET `property_owner` = @owner, `property_coowners` = @keys, `property_inventory` = @inv, `property_weapons` = @weps, `property_money` = @money, `property_expiry` = @rent WHERE `property_id` = @id;",  {, MySQL.ready(function()

## fsn_shootingrange/client.lua

*Role:* client
*Events:* trigger: fsn_notify:displayNotification

## fsn_shootingrange/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_shootingrange/server.lua

*Role:* server

## fsn_spawnmanager/client.lua

*Role:* client
*Events:* register: fsn_spawnmanager:start, handler: fsn_spawnmanager:start, trigger: clothes:spawn, fsn->esx:clothing:spawn, fsn_apartments:getApartment, fsn_bank:change:bankAdd, fsn_ems:reviveMe:force, fsn_inventory:initChar, fsn_jail:init, fsn_main:character, fsn_police:init, fsn_spawnmanager:start, mythic_notify:client:SendAlert, spawnme
*Exports:* fsn_apartments
*NUI Callbacks:* camToLoc, spawnAtLoc
*NUI Messages:* SendNUIMessage

## fsn_spawnmanager/fxmanifest.lua

*Role:* shared
*DB Calls:* '@mysql-async/lib/MySQL.lua'

## fsn_spawnmanager/nui/index.css

*Role:* NUI

## fsn_spawnmanager/nui/index.html

*Role:* NUI

## fsn_spawnmanager/nui/index.js

*Role:* NUI

## fsn_steamlogin/client.lua

*Role:* client

## fsn_steamlogin/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_storagelockers/client.lua

*Role:* client
*Events:* register: fsn_properties:buy, fsn_properties:menu:access:allow, fsn_properties:menu:access:revoke, fsn_properties:menu:access:view, fsn_properties:menu:inventory:deposit, fsn_properties:menu:inventory:take, fsn_properties:menu:money:deposit, fsn_properties:menu:money:withdraw, fsn_properties:menu:police:breach, fsn_properties:menu:police:empty, fsn_properties:menu:police:search, fsn_properties:menu:police:seize, fsn_properties:menu:rent:check, fsn_properties:menu:rent:pay, fsn_properties:menu:robbery, fsn_properties:menu:weapon:deposit, fsn_properties:menu:weapon:take, trigger: fsn_properties:buy, fsn_properties:menu:access:allow, fsn_properties:menu:access:revoke, fsn_properties:menu:access:view, fsn_properties:menu:inventory:deposit, fsn_properties:menu:inventory:take, fsn_properties:menu:money:deposit, fsn_properties:menu:money:withdraw, fsn_properties:menu:police:breach, fsn_properties:menu:police:empty, fsn_properties:menu:police:search, fsn_properties:menu:police:seize, fsn_properties:menu:rent:check, fsn_properties:menu:rent:pay, fsn_properties:menu:robbery, fsn_properties:menu:weapon:deposit, fsn_properties:menu:weapon:take
*NUI Messages:* SendNUIMessage

## fsn_storagelockers/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_storagelockers/nui/ui.css

*Role:* NUI

## fsn_storagelockers/nui/ui.html

*Role:* NUI

## fsn_storagelockers/nui/ui.js

*Role:* NUI

## fsn_storagelockers/server.lua

*Role:* server
*DB Calls:* MySQL.Async.fetchAll('SELECT * FROM `fsn_properties`', {}, function(res), MySQL.ready(function()

## fsn_store/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletAdd, fsn_bank:change:walletMinus, fsn_inventory:item:add, fsn_licenses:police:give, fsn_notify:displayNotification, fsn_police:dispatch, fsn_store:request
*Exports:* fsn_entfinder, fsn_licenses, fsn_main, fsn_progress, mythic_notify

## fsn_store/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_store/server.lua

*Role:* server
*Events:* register: fsn_store:boughtOne, fsn_store:closedStore, fsn_store:recieveItemsForStore, fsn_store:request, handler: fsn_store:boughtOne, fsn_store:closedStore, fsn_store:recieveItemsForStore, fsn_store:request, onResourceStart, playerDropped, trigger: fsn_inventory:sendItemsToStore, fsn_inventory:store:recieve, fsn_main:logging:addLog, fsn_notify:displayNotification

## fsn_store_guns/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletMinus, fsn_licenses:police:give, fsn_notify:displayNotification, fsn_store_guns:request
*Exports:* fsn_licenses, mythic_notify

## fsn_store_guns/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_store_guns/server.lua

*Role:* server
*Events:* register: fsn_store_guns:boughtOne, fsn_store_guns:closedStore, fsn_store_guns:request, handler: fsn_store_guns:boughtOne, fsn_store_guns:closedStore, fsn_store_guns:request, playerDropped, trigger: fsn_inventory:store_gun:recieve, fsn_main:logging:addLog, fsn_notify:displayNotification

## fsn_stripclub/client.lua

*Role:* client
*Events:* register: fsn_stripclub:client:update, handler: fsn_stripclub:client:update, trigger: fsn_emotecontrol:play, fsn_notify:displayNotification, fsn_stripclub:server:claimBooth

## fsn_stripclub/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_stripclub/server.lua

*Role:* server

## fsn_teleporters/client.lua

*Role:* client
*Events:* register: fsn_doj:judge:toggleLock, fsn_teleporters:teleport:coordinates, fsn_teleporters:teleport:waypoint, handler: fsn_doj:judge:toggleLock, fsn_teleporters:teleport:coordinates, fsn_teleporters:teleport:waypoint, trigger: fsn_notify:displayNotification
*Exports:* fsn_police

## fsn_teleporters/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_timeandweather/client.lua

*Role:* client
*Events:* register: fsn_timeandweather:notify, fsn_timeandweather:updateTime, fsn_timeandweather:updateWeather, handler: fsn_timeandweather:notify, fsn_timeandweather:updateTime, fsn_timeandweather:updateWeather, playerSpawned, trigger: fsn_timeandweather:requestSync

## fsn_timeandweather/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_timeandweather/server.lua

*Role:* server
*Events:* register: fsn_timeandweather:requestSync, handler: fsn_timeandweather:requestSync, trigger: chatMessage, fsn_timeandweather:notify, fsn_timeandweather:requestSync, fsn_timeandweather:updateTime, fsn_timeandweather:updateWeather
*Commands:* blackout, evening, freezetime, freezeweather, morning, night, noon, time, weather

## fsn_timeandweather/timecycle_mods_4.xml

*Role:* shared

## fsn_timeandweather/w_blizzard.xml

*Role:* shared

## fsn_timeandweather/w_clear.xml

*Role:* shared

## fsn_timeandweather/w_clearing.xml

*Role:* shared

## fsn_timeandweather/w_clouds.xml

*Role:* shared

## fsn_timeandweather/w_extrasunny.xml

*Role:* shared

## fsn_timeandweather/w_foggy.xml

*Role:* shared

## fsn_timeandweather/w_neutral.xml

*Role:* shared

## fsn_timeandweather/w_overcast.xml

*Role:* shared

## fsn_timeandweather/w_rain.xml

*Role:* shared

## fsn_timeandweather/w_smog.xml

*Role:* shared

## fsn_timeandweather/w_snow.xml

*Role:* shared

## fsn_timeandweather/w_snowlight.xml

*Role:* shared

## fsn_timeandweather/w_thunder.xml

*Role:* shared

## fsn_timeandweather/w_xmas.xml

*Role:* shared

## fsn_vehiclecontrol/aircontrol/aircontrol.lua

*Role:* shared

## fsn_vehiclecontrol/carhud/carhud.lua

*Role:* shared

## fsn_vehiclecontrol/carwash/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletMinus, fsn_notify:displayNotification

## fsn_vehiclecontrol/client.lua

*Role:* client
*Events:* trigger: fsn_commands:me, fsn_notify:displayNotification, fsn_police:dispatch
*Exports:* fsn_police

## fsn_vehiclecontrol/compass/compass.lua

*Role:* shared

## fsn_vehiclecontrol/compass/essentials.lua

*Role:* shared

## fsn_vehiclecontrol/compass/streetname.lua

*Role:* shared

## fsn_vehiclecontrol/damage/cl_crashes.lua

*Role:* client
*Events:* trigger: fsn_police:dispatch

## fsn_vehiclecontrol/damage/client.lua

*Role:* client
*Events:* register: fsn_vehiclecontrol:damage:repair, fsn_vehiclecontrol:damage:repairkit, handler: fsn_vehiclecontrol:damage:repair, fsn_vehiclecontrol:damage:repairkit, trigger: fsn_inventory:item:take, fsn_notify:displayNotification
*Exports:* fsn_progress

## fsn_vehiclecontrol/damage/config.lua

*Role:* shared

## fsn_vehiclecontrol/engine/client.lua

*Role:* client
*Events:* register: EngineToggle:Engine, EngineToggle:RPDamage, fsn_vehiclecontrol:getKeys, fsn_vehiclecontrol:giveKeys, fsn_vehiclecontrol:keys:carjack, handler: EngineToggle:Engine, EngineToggle:RPDamage, fsn_vehiclecontrol:getKeys, fsn_vehiclecontrol:giveKeys, fsn_vehiclecontrol:keys:carjack, trigger: EngineToggle:Engine, fsn_commands:me, fsn_notify:displayNotification, fsn_vehiclecontrol:givekeys
*Exports:* fsn_licenses

## fsn_vehiclecontrol/fuel/client.lua

*Role:* client
*Events:* register: fsn_fuel:set, fsn_fuel:update, handler: fsn_fuel:set, fsn_fuel:update, trigger: fsn_bank:change:walletMinus, fsn_fuel:update, fsn_notify:displayNotification

## fsn_vehiclecontrol/fuel/server.lua

*Role:* server
*Events:* register: fsn_fuel:update, handler: fsn_fuel:update, trigger: fsn_fuel:update

## fsn_vehiclecontrol/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_vehiclecontrol/holdup/client.lua

*Role:* client
*Events:* trigger: fsn_bank:change:walletAdd, fsn_inventory:item:add, fsn_notify:displayNotification, fsn_police:dispatch
*Exports:* fsn_criminalmisc, fsn_police, fsn_progress

## fsn_vehiclecontrol/inventory/client.lua

*Role:* client

## fsn_vehiclecontrol/inventory/server.lua

*Role:* server

## fsn_vehiclecontrol/keys/server.lua

*Role:* server
*Events:* register: fsn_vehiclecontrol:givekeys, handler: fsn_vehiclecontrol:givekeys, trigger: fsn_vehiclecontrol:getKeys

## fsn_vehiclecontrol/odometer/client.lua

*Role:* client
*Events:* trigger: fsn_odometer:addMileage

## fsn_vehiclecontrol/odometer/server.lua

*Role:* server
*Events:* register: fsn_odometer:addMileage, fsn_odometer:getMileage, fsn_odometer:resetMileage, fsn_odometer:setMileage, handler: fsn_odometer:addMileage, fsn_odometer:getMileage, fsn_odometer:resetMileage, fsn_odometer:setMileage, trigger: fsn_odometer:setMileage
*DB Calls:* MySQL.Async.fetchScalar('SELECT `odometer` FROM `fsn_vehicles` WHERE `veh_plate` = @plate', { ['@plate'] = plate, }, function(result), MySQL.Async.insert('UPDATE `fsn_vehicles` SET `odometer` = @mileage WHERE `veh_plate` = @plate', { ['@plate'] = plate, ['@mileage'] = mileage, },, MySQL.Async.insert('UPDATE `fsn_vehicles` SET `odometer` = odometer + @mileage WHERE `veh_plate` = @plate', { ['@plate'] = plate, ['@mileage'] = mileage, },, MySQL.ready(function()

## fsn_vehiclecontrol/speedcameras/client.lua

*Role:* client
*Events:* register: fsn_vehiclecontrol:flagged:add, handler: fsn_vehiclecontrol:flagged:add, trigger: fsn_police:dispatch

## fsn_vehiclecontrol/trunk/client.lua

*Role:* client
*Events:* register: fsn_vehiclecontrol:trunk:forceIn, fsn_vehiclecontrol:trunk:forceOut, handler: fsn_vehiclecontrol:trunk:forceIn, fsn_vehiclecontrol:trunk:forceOut, trigger: fsn_ems:carry:end, fsn_inventory:veh:request, fsn_vehiclecontrol:trunk:forceIn
*Exports:* fsn_ems

## fsn_vehiclecontrol/trunk/server.lua

*Role:* server
*Events:* register: fsn_vehiclecontrol:trunk:forceIn, handler: fsn_vehiclecontrol:trunk:forceIn, trigger: fsn_vehiclecontrol:trunk:forceIn

## fsn_voicecontrol/client.lua

*Role:* client
*Events:* register: fsn_voicecontrol:call:ring, handler: fsn_voicecontrol:call:ring, trigger: InteractSound_SV:PlayWithinDistance, fsn_voicecontrol:call:answer, fsn_voicecontrol:call:end, fsn_voicecontrol:call:hold, fsn_voicecontrol:call:unhold

## fsn_voicecontrol/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_voicecontrol/server.lua

*Role:* server
*Events:* register: fsn_voicecontrol:call:answer, fsn_voicecontrol:call:decline, fsn_voicecontrol:call:end, fsn_voicecontrol:call:hold, fsn_voicecontrol:call:ring, fsn_voicecontrol:call:unhold, handler: fsn_voicecontrol:call:answer, fsn_voicecontrol:call:decline, fsn_voicecontrol:call:end, fsn_voicecontrol:call:hold, fsn_voicecontrol:call:ring, fsn_voicecontrol:call:unhold, trigger: fsn_notify:displayNotification, fsn_voicecontrol:call:end, fsn_voicecontrol:call:hold, fsn_voicecontrol:call:ring, fsn_voicecontrol:call:start, fsn_voicecontrol:call:unhold

## fsn_weaponcontrol/client.lua

*Role:* client
*Events:* trigger: fsn_notify:displayNotification

## fsn_weaponcontrol/fxmanifest.lua

*Role:* shared
*DB Calls:* server_script '@mysql-async/lib/MySQL.lua'

## fsn_weaponcontrol/server.lua

*Role:* server

## pipeline.yml

*Role:* shared

## Cross-Index

### Events (register)

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
- Tackle:Server:TacklePlayer
- __cfx_internal:commandFallback
- __cfx_internal:serverPrint
- _chat:messageEntered
- binoculars:Activate
- camera:Activate
- chat:addMessage
- chat:addSuggestion
- chat:addSuggestions
- chat:addTemplate
- chat:clear
- chat:init
- chat:removeSuggestion
- chatMessage
- clothes:firstspawn
- clothes:spawn
- fsn:playerReady
- fsn_admin:FreezeMe
- fsn_admin:enableAdminCommands
- fsn_admin:enableModeratorCommands
- fsn_admin:fix
- fsn_admin:recieveXYZ
- fsn_admin:requestXYZ
- fsn_admin:sendXYZ
- fsn_admin:spawnCar
- fsn_admin:spawnVehicle
- fsn_apartments:characterCreation
- fsn_apartments:createApartment
- fsn_apartments:getApartment
- fsn_apartments:instance
- fsn_apartments:instance:debug
- fsn_apartments:instance:join
- fsn_apartments:instance:leave
- fsn_apartments:instance:new
- fsn_apartments:instance:update
- fsn_apartments:inv:update
- fsn_apartments:outfit:add
- fsn_apartments:outfit:list
- fsn_apartments:outfit:remove
- fsn_apartments:outfit:use
- fsn_apartments:saveApartment
- fsn_apartments:sendApartment
- fsn_apartments:stash:add
- fsn_apartments:stash:take
- fsn_bank:change:bankAdd
- fsn_bank:change:bankMinus
- fsn_bank:change:bankandwallet
- fsn_bank:change:walletAdd
- fsn_bank:change:walletMinus
- fsn_bank:database:update
- fsn_bank:request:both
- fsn_bank:transfer
- fsn_bank:update:both
- fsn_bankrobbery:LostMC:spawn
- fsn_bankrobbery:closeDoor
- fsn_bankrobbery:desks:doorUnlock
- fsn_bankrobbery:desks:endHack
- fsn_bankrobbery:desks:receive
- fsn_bankrobbery:desks:request
- fsn_bankrobbery:desks:startHack
- fsn_bankrobbery:init
- fsn_bankrobbery:openDoor
- fsn_bankrobbery:payout
- fsn_bankrobbery:start
- fsn_bankrobbery:timer
- fsn_bankrobbery:vault:close
- fsn_bankrobbery:vault:open
- fsn_boatshop:floor:ChangeBoat
- fsn_boatshop:floor:Request
- fsn_boatshop:floor:Update
- fsn_boatshop:floor:Updateboat
- fsn_boatshop:floor:color:One
- fsn_boatshop:floor:color:Two
- fsn_boatshop:floor:commission
- fsn_cargarage:buyVehicle
- fsn_cargarage:checkStatus
- fsn_cargarage:impound
- fsn_cargarage:makeMine
- fsn_cargarage:receiveVehicles
- fsn_cargarage:requestVehicles
- fsn_cargarage:reset
- fsn_cargarage:updateVehicle
- fsn_cargarage:vehicle:toggleStatus
- fsn_cargarage:vehicleStatus
- fsn_carstore:floor:ChangeCar
- fsn_carstore:floor:Request
- fsn_carstore:floor:Update
- fsn_carstore:floor:UpdateCar
- fsn_carstore:floor:color:One
- fsn_carstore:floor:color:Two
- fsn_carstore:floor:commission
- fsn_characterdetails:recievetattoos
- fsn_clothing:menu
- fsn_clothing:requestDefault
- fsn_clothing:save
- fsn_commands:airlift
- fsn_commands:clothing:glasses
- fsn_commands:clothing:hat
- fsn_commands:clothing:mask
- fsn_commands:dev:fix
- fsn_commands:dev:spawnCar
- fsn_commands:dev:weapon
- fsn_commands:dropweapon
- fsn_commands:ems:adamage:inspect
- fsn_commands:getHDC
- fsn_commands:hc:takephone
- fsn_commands:me
- fsn_commands:me:3d
- fsn_commands:police:boot
- fsn_commands:police:booted
- fsn_commands:police:car
- fsn_commands:police:cpic:trigger
- fsn_commands:police:extra
- fsn_commands:police:extras
- fsn_commands:police:fix
- fsn_commands:police:gsrMe
- fsn_commands:police:gsrResult
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
- fsn_commands:police:unbooted
- fsn_commands:police:updateBoot
- fsn_commands:printxyz
- fsn_commands:requestHDC
- fsn_commands:sendxyz
- fsn_commands:service:addPing
- fsn_commands:service:pingAccept
- fsn_commands:service:pingStart
- fsn_commands:service:request
- fsn_commands:service:sendrequest
- fsn_commands:vehdoor:close
- fsn_commands:vehdoor:open
- fsn_commands:walk:set
- fsn_commands:window
- fsn_criminalmisc:drugs:effects:cocaine
- fsn_criminalmisc:drugs:effects:meth
- fsn_criminalmisc:drugs:effects:smokeCigarette
- fsn_criminalmisc:drugs:effects:weed
- fsn_criminalmisc:drugs:streetselling:radio
- fsn_criminalmisc:drugs:streetselling:request
- fsn_criminalmisc:drugs:streetselling:send
- fsn_criminalmisc:handcuffs:requestCuff
- fsn_criminalmisc:handcuffs:requestunCuff
- fsn_criminalmisc:handcuffs:startCuffed
- fsn_criminalmisc:handcuffs:startCuffing
- fsn_criminalmisc:handcuffs:startunCuffed
- fsn_criminalmisc:handcuffs:startunCuffing
- fsn_criminalmisc:handcuffs:toggleEscort
- fsn_criminalmisc:houserobbery:try
- fsn_criminalmisc:lockpicking
- fsn_criminalmisc:racing:createRace
- fsn_criminalmisc:racing:joinRace
- fsn_criminalmisc:racing:newRace
- fsn_criminalmisc:racing:putmeinrace
- fsn_criminalmisc:racing:update
- fsn_criminalmisc:racing:win
- fsn_criminalmisc:robbing:startRobbing
- fsn_criminalmisc:toggleDrag
- fsn_criminalmisc:weapons:add
- fsn_criminalmisc:weapons:add:police
- fsn_criminalmisc:weapons:add:tbl
- fsn_criminalmisc:weapons:add:unknown
- fsn_criminalmisc:weapons:addDrop
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
- fsn_developer:printXYZ
- fsn_developer:sendXYZ
- fsn_developer:spawnVehicle
- fsn_doj:court:remandMe
- fsn_doj:judge:spawnCar
- fsn_doj:judge:toggleLock
- fsn_doormanager:doorLocked
- fsn_doormanager:doorUnlocked
- fsn_doormanager:lockDoor
- fsn_doormanager:request
- fsn_doormanager:requestDoors
- fsn_doormanager:sendDoors
- fsn_doormanager:toggle
- fsn_doormanager:unlockDoor
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
- fsn_ems:offDuty
- fsn_ems:onDuty
- fsn_ems:requestUpdate
- fsn_ems:reviveMe
- fsn_ems:reviveMe:force
- fsn_ems:set:WalkType
- fsn_ems:update
- fsn_ems:updateLevel
- fsn_evidence:collect
- fsn_evidence:destroy
- fsn_evidence:display
- fsn_evidence:drop:blood
- fsn_evidence:drop:casing
- fsn_evidence:ped:addState
- fsn_evidence:ped:update
- fsn_evidence:ped:updateDamage
- fsn_evidence:receive
- fsn_evidence:request
- fsn_evidence:weaponInfo
- fsn_fuel:set
- fsn_fuel:update
- fsn_gangs:garage:enter
- fsn_gangs:hideout:enter
- fsn_gangs:hideout:leave
- fsn_gangs:inventory:request
- fsn_gangs:recieve
- fsn_gangs:request
- fsn_gangs:tryTakeOver
- fsn_garages:vehicle:update
- fsn_hungerandthirst:pause
- fsn_hungerandthirst:unpause
- fsn_inventory:apt:recieve
- fsn_inventory:buyItem
- fsn_inventory:database:update
- fsn_inventory:drops:collect
- fsn_inventory:drops:drop
- fsn_inventory:drops:request
- fsn_inventory:drops:send
- fsn_inventory:empty
- fsn_inventory:floor:update
- fsn_inventory:gasDoorunlock
- fsn_inventory:gui:display
- fsn_inventory:init
- fsn_inventory:initChar
- fsn_inventory:item:add
- fsn_inventory:item:drop
- fsn_inventory:item:dropped
- fsn_inventory:item:give
- fsn_inventory:item:take
- fsn_inventory:item:use
- fsn_inventory:itemhasdropped
- fsn_inventory:itempickup
- fsn_inventory:items:add
- fsn_inventory:items:addPreset
- fsn_inventory:items:emptyinv
- fsn_inventory:locker:empty
- fsn_inventory:locker:request
- fsn_inventory:locker:save
- fsn_inventory:me:update
- fsn_inventory:pd_locker:recieve
- fsn_inventory:ply:done
- fsn_inventory:ply:finished
- fsn_inventory:ply:recieve
- fsn_inventory:ply:request
- fsn_inventory:ply:update
- fsn_inventory:police_armory:recieve
- fsn_inventory:prebuy
- fsn_inventory:prop:recieve
- fsn_inventory:rebreather:use
- fsn_inventory:recieveItems
- fsn_inventory:removedropped
- fsn_inventory:sendItems
- fsn_inventory:sendItemsToArmory
- fsn_inventory:sendItemsToStore
- fsn_inventory:store:recieve
- fsn_inventory:store_gun:recieve
- fsn_inventory:sys:request
- fsn_inventory:sys:send
- fsn_inventory:update
- fsn_inventory:use:drink
- fsn_inventory:use:food
- fsn_inventory:useAmmo
- fsn_inventory:useArmor
- fsn_inventory:veh:finished
- fsn_inventory:veh:glovebox
- fsn_inventory:veh:glovebox:recieve
- fsn_inventory:veh:request
- fsn_inventory:veh:trunk:recieve
- fsn_inventory:veh:update
- fsn_jail:init
- fsn_jail:releaseme
- fsn_jail:sendme
- fsn_jail:sendsuspect
- fsn_jail:spawn
- fsn_jail:spawn:recieve
- fsn_jail:update:database
- fsn_jewellerystore:case:rob
- fsn_jewellerystore:case:startrob
- fsn_jewellerystore:cases:request
- fsn_jewellerystore:cases:update
- fsn_jewellerystore:doors:Lock
- fsn_jewellerystore:doors:State
- fsn_jewellerystore:gasDoor:toggle
- fsn_jobs:ems:request
- fsn_jobs:mechanic:toggle
- fsn_jobs:mechanic:toggleduty
- fsn_jobs:news:role:Set
- fsn_jobs:paycheck
- fsn_jobs:quit
- fsn_jobs:taxi:accepted
- fsn_jobs:taxi:request
- fsn_jobs:tow:mark
- fsn_jobs:tow:marked
- fsn_jobs:tow:request
- fsn_jobs:whitelist:access:add
- fsn_jobs:whitelist:add
- fsn_jobs:whitelist:clock:in
- fsn_jobs:whitelist:clock:out
- fsn_jobs:whitelist:remove
- fsn_jobs:whitelist:request
- fsn_jobs:whitelist:update
- fsn_licenses:chat
- fsn_licenses:check
- fsn_licenses:display
- fsn_licenses:giveID
- fsn_licenses:id:display
- fsn_licenses:id:request
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
- fsn_main:createCharacter
- fsn_main:displayBankandMoney
- fsn_main:getCharacter
- fsn_main:gui:bank:change
- fsn_main:gui:both:display
- fsn_main:gui:money:change
- fsn_main:initiateCharacter
- fsn_main:logging:addLog
- fsn_main:money:bank:Add
- fsn_main:money:bank:Minus
- fsn_main:money:bank:Set
- fsn_main:money:initChar
- fsn_main:money:update
- fsn_main:money:updateSilent
- fsn_main:money:wallet:Add
- fsn_main:money:wallet:GiveCash
- fsn_main:money:wallet:Minus
- fsn_main:money:wallet:Set
- fsn_main:requestCharacters
- fsn_main:saveCharacter
- fsn_main:sendCharacters
- fsn_main:update:myCharacter
- fsn_main:updateCharNumber
- fsn_main:updateCharacters
- fsn_main:validatePlayer
- fsn_menu:requestInventory
- fsn_needs:stress:add
- fsn_needs:stress:remove
- fsn_notify:displayNotification
- fsn_odometer:addMileage
- fsn_odometer:getMileage
- fsn_odometer:resetMileage
- fsn_odometer:setMileage
- fsn_phones:GUI:notification
- fsn_phones:SYS:addCall
- fsn_phones:SYS:addTransaction
- fsn_phones:SYS:newNumber
- fsn_phones:SYS:receiveGarage
- fsn_phones:SYS:recieve:details
- fsn_phones:SYS:request:details
- fsn_phones:SYS:requestGarage
- fsn_phones:SYS:sendTweet
- fsn_phones:SYS:set:details
- fsn_phones:SYS:updateAdverts
- fsn_phones:SYS:updateNumber
- fsn_phones:USE:Email
- fsn_phones:USE:Message
- fsn_phones:USE:Phone
- fsn_phones:USE:Tweet
- fsn_phones:USE:darkweb:order
- fsn_phones:USE:requestAdverts
- fsn_phones:USE:sendAdvert
- fsn_phones:USE:sendMessage
- fsn_phones:UTIL:chat
- fsn_phones:UTIL:displayNumber
- fsn_police:911
- fsn_police:911r
- fsn_police:GetInVehicle
- fsn_police:MDT:receivewarrants
- fsn_police:MDT:requestwarrants
- fsn_police:MDT:toggle
- fsn_police:MDT:vehicledetails
- fsn_police:MDT:warrant
- fsn_police:MDTremovewarrant
- fsn_police:Sit
- fsn_police:ToggleK9
- fsn_police:armory:boughtOne
- fsn_police:armory:closedArmory
- fsn_police:armory:recieveItemsForArmory
- fsn_police:armory:request
- fsn_police:chat:ticket
- fsn_police:command:duty
- fsn_police:cuffs:requestCuff
- fsn_police:cuffs:requestunCuff
- fsn_police:cuffs:startCuffed
- fsn_police:cuffs:startCuffing
- fsn_police:cuffs:startunCuffed
- fsn_police:cuffs:startunCuffing
- fsn_police:cuffs:toggleEscort
- fsn_police:cuffs:toggleHard
- fsn_police:database:CPIC
- fsn_police:database:CPIC:search
- fsn_police:database:CPIC:search:result
- fsn_police:dispatch
- fsn_police:dispatch:toggle
- fsn_police:dispatchcall
- fsn_police:init
- fsn_police:k9:search:person:end
- fsn_police:k9:search:person:finish
- fsn_police:k9:search:person:me
- fsn_police:offDuty
- fsn_police:onDuty
- fsn_police:pd:toggleDrag
- fsn_police:ply:toggleDrag
- fsn_police:putMeInVeh
- fsn_police:radar:toggle
- fsn_police:requestUpdate
- fsn_police:runplate
- fsn_police:runplate::target
- fsn_police:runplate:target
- fsn_police:search:end:inventory
- fsn_police:search:end:money
- fsn_police:search:end:weapons
- fsn_police:search:start:inventory
- fsn_police:search:start:money
- fsn_police:search:start:weapons
- fsn_police:search:strip
- fsn_police:ticket
- fsn_police:toggleHandcuffs
- fsn_police:update
- fsn_police:updateLevel
- fsn_properties:access
- fsn_properties:buy
- fsn_properties:inv:closed
- fsn_properties:inv:update
- fsn_properties:keys:give
- fsn_properties:leave
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
- fsn_properties:realator:clock
- fsn_properties:rent:check
- fsn_properties:rent:pay
- fsn_properties:request
- fsn_properties:updateXYZ
- fsn_spawnmanager:start
- fsn_store:boughtOne
- fsn_store:closedStore
- fsn_store:recieveItemsForStore
- fsn_store:request
- fsn_store_guns:boughtOne
- fsn_store_guns:closedStore
- fsn_store_guns:request
- fsn_stripclub:client:update
- fsn_teleporters:teleport:coordinates
- fsn_teleporters:teleport:waypoint
- fsn_timeandweather:notify
- fsn_timeandweather:requestSync
- fsn_timeandweather:updateTime
- fsn_timeandweather:updateWeather
- fsn_vehiclecontrol:damage:repair
- fsn_vehiclecontrol:damage:repairkit
- fsn_vehiclecontrol:flagged:add
- fsn_vehiclecontrol:getKeys
- fsn_vehiclecontrol:giveKeys
- fsn_vehiclecontrol:givekeys
- fsn_vehiclecontrol:keys:carjack
- fsn_vehiclecontrol:trunk:forceIn
- fsn_vehiclecontrol:trunk:forceOut
- fsn_voicecontrol:call:answer
- fsn_voicecontrol:call:decline
- fsn_voicecontrol:call:end
- fsn_voicecontrol:call:hold
- fsn_voicecontrol:call:ring
- fsn_voicecontrol:call:unhold
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

### Events (handler)

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
- Tackle:Server:TacklePlayer
- __cfx_internal:commandFallback
- __cfx_internal:serverPrint
- _chat:messageEntered
- binoculars:Activate
- c
- camera:Activate
- chat:addMessage
- chat:addSuggestion
- chat:addSuggestions
- chat:addTemplate
- chat:clear
- chat:init
- chat:removeSuggestion
- chatMessage
- clothes:changemodel
- clothes:firstspawn
- clothes:setComponents
- clothes:spawn
- freecam:onTick
- fsn:getFsnObject
- fsn:playerReady
- fsn_admin:FreezeMe
- fsn_admin:enableAdminCommands
- fsn_admin:enableModeratorCommands
- fsn_admin:fix
- fsn_admin:recieveXYZ
- fsn_admin:requestXYZ
- fsn_admin:sendXYZ
- fsn_admin:spawnCar
- fsn_admin:spawnVehicle
- fsn_apartments:characterCreation
- fsn_apartments:createApartment
- fsn_apartments:getApartment
- fsn_apartments:instance:debug
- fsn_apartments:instance:join
- fsn_apartments:instance:leave
- fsn_apartments:instance:new
- fsn_apartments:instance:update
- fsn_apartments:inv:update
- fsn_apartments:outfit:add
- fsn_apartments:outfit:list
- fsn_apartments:outfit:remove
- fsn_apartments:outfit:use
- fsn_apartments:saveApartment
- fsn_apartments:sendApartment
- fsn_apartments:stash:add
- fsn_apartments:stash:take
- fsn_bank:change:bankAdd
- fsn_bank:change:bankMinus
- fsn_bank:change:bankandwallet
- fsn_bank:change:walletAdd
- fsn_bank:change:walletMinus
- fsn_bank:database:update
- fsn_bank:request:both
- fsn_bank:transfer
- fsn_bank:update:both
- fsn_bankrobbery:LostMC:spawn
- fsn_bankrobbery:closeDoor
- fsn_bankrobbery:desks:doorUnlock
- fsn_bankrobbery:desks:endHack
- fsn_bankrobbery:desks:receive
- fsn_bankrobbery:desks:request
- fsn_bankrobbery:desks:startHack
- fsn_bankrobbery:init
- fsn_bankrobbery:openDoor
- fsn_bankrobbery:payout
- fsn_bankrobbery:start
- fsn_bankrobbery:timer
- fsn_bankrobbery:vault:close
- fsn_bankrobbery:vault:open
- fsn_boatshop:floor:ChangeBoat
- fsn_boatshop:floor:Request
- fsn_boatshop:floor:Update
- fsn_boatshop:floor:Updateboat
- fsn_boatshop:floor:color:One
- fsn_boatshop:floor:color:Two
- fsn_boatshop:floor:commission
- fsn_cargarage:buyVehicle
- fsn_cargarage:checkStatus
- fsn_cargarage:impound
- fsn_cargarage:makeMine
- fsn_cargarage:receiveVehicles
- fsn_cargarage:requestVehicles
- fsn_cargarage:reset
- fsn_cargarage:updateVehicle
- fsn_cargarage:vehicle:toggleStatus
- fsn_cargarage:vehicleStatus
- fsn_carstore:floor:ChangeCar
- fsn_carstore:floor:Request
- fsn_carstore:floor:Update
- fsn_carstore:floor:UpdateCar
- fsn_carstore:floor:color:One
- fsn_carstore:floor:color:Two
- fsn_carstore:floor:commission
- fsn_characterdetails:recievetattoos
- fsn_clothing:menu
- fsn_clothing:requestDefault
- fsn_clothing:save
- fsn_commands:airlift
- fsn_commands:clothing:glasses
- fsn_commands:clothing:hat
- fsn_commands:clothing:mask
- fsn_commands:dev:fix
- fsn_commands:dev:spawnCar
- fsn_commands:dev:weapon
- fsn_commands:dropweapon
- fsn_commands:ems:adamage:inspect
- fsn_commands:getHDC
- fsn_commands:hc:takephone
- fsn_commands:me
- fsn_commands:me:3d
- fsn_commands:police:boot
- fsn_commands:police:booted
- fsn_commands:police:car
- fsn_commands:police:cpic:trigger
- fsn_commands:police:extra
- fsn_commands:police:extras
- fsn_commands:police:fix
- fsn_commands:police:gsrMe
- fsn_commands:police:gsrResult
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
- fsn_commands:police:unbooted
- fsn_commands:police:updateBoot
- fsn_commands:printxyz
- fsn_commands:requestHDC
- fsn_commands:sendxyz
- fsn_commands:service:addPing
- fsn_commands:service:pingAccept
- fsn_commands:service:pingStart
- fsn_commands:service:request
- fsn_commands:service:sendrequest
- fsn_commands:vehdoor:close
- fsn_commands:vehdoor:open
- fsn_commands:walk:set
- fsn_commands:window
- fsn_criminalmisc:drugs:effects:cocaine
- fsn_criminalmisc:drugs:effects:meth
- fsn_criminalmisc:drugs:effects:smokeCigarette
- fsn_criminalmisc:drugs:effects:weed
- fsn_criminalmisc:drugs:streetselling:radio
- fsn_criminalmisc:drugs:streetselling:request
- fsn_criminalmisc:drugs:streetselling:send
- fsn_criminalmisc:handcuffs:requestCuff
- fsn_criminalmisc:handcuffs:requestunCuff
- fsn_criminalmisc:handcuffs:startCuffed
- fsn_criminalmisc:handcuffs:startCuffing
- fsn_criminalmisc:handcuffs:startunCuffed
- fsn_criminalmisc:handcuffs:startunCuffing
- fsn_criminalmisc:handcuffs:toggleEscort
- fsn_criminalmisc:houserobbery:try
- fsn_criminalmisc:lockpicking
- fsn_criminalmisc:racing:createRace
- fsn_criminalmisc:racing:joinRace
- fsn_criminalmisc:racing:newRace
- fsn_criminalmisc:racing:putmeinrace
- fsn_criminalmisc:racing:update
- fsn_criminalmisc:racing:win
- fsn_criminalmisc:robbing:startRobbing
- fsn_criminalmisc:toggleDrag
- fsn_criminalmisc:weapons:add
- fsn_criminalmisc:weapons:add:police
- fsn_criminalmisc:weapons:add:tbl
- fsn_criminalmisc:weapons:add:unknown
- fsn_criminalmisc:weapons:addDrop
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
- fsn_developer:printXYZ
- fsn_developer:sendXYZ
- fsn_developer:spawnVehicle
- fsn_doj:court:remandMe
- fsn_doj:judge:spawnCar
- fsn_doj:judge:toggleLock
- fsn_doormanager:doorLocked
- fsn_doormanager:doorUnlocked
- fsn_doormanager:lockDoor
- fsn_doormanager:request
- fsn_doormanager:requestDoors
- fsn_doormanager:sendDoors
- fsn_doormanager:toggle
- fsn_doormanager:unlockDoor
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
- fsn_ems:offDuty
- fsn_ems:onDuty
- fsn_ems:requestUpdate
- fsn_ems:reviveMe
- fsn_ems:reviveMe:force
- fsn_ems:set:WalkType
- fsn_ems:update
- fsn_ems:updateLevel
- fsn_evidence:collect
- fsn_evidence:destroy
- fsn_evidence:display
- fsn_evidence:drop:blood
- fsn_evidence:drop:casing
- fsn_evidence:ped:addState
- fsn_evidence:ped:update
- fsn_evidence:ped:updateDamage
- fsn_evidence:receive
- fsn_evidence:request
- fsn_evidence:weaponInfo
- fsn_fuel:set
- fsn_fuel:update
- fsn_gangs:garage:enter
- fsn_gangs:hideout:enter
- fsn_gangs:hideout:leave
- fsn_gangs:inventory:request
- fsn_gangs:recieve
- fsn_gangs:request
- fsn_gangs:tryTakeOver
- fsn_garages:vehicle:update
- fsn_hungerandthirst:pause
- fsn_hungerandthirst:unpause
- fsn_inventory:apt:recieve
- fsn_inventory:buyItem
- fsn_inventory:database:update
- fsn_inventory:drops:collect
- fsn_inventory:drops:drop
- fsn_inventory:drops:request
- fsn_inventory:drops:send
- fsn_inventory:empty
- fsn_inventory:floor:update
- fsn_inventory:gasDoorunlock
- fsn_inventory:gui:display
- fsn_inventory:initChar
- fsn_inventory:item:add
- fsn_inventory:item:drop
- fsn_inventory:item:dropped
- fsn_inventory:item:give
- fsn_inventory:item:take
- fsn_inventory:item:use
- fsn_inventory:itemhasdropped
- fsn_inventory:itempickup
- fsn_inventory:items:add
- fsn_inventory:items:addPreset
- fsn_inventory:items:emptyinv
- fsn_inventory:locker:empty
- fsn_inventory:locker:request
- fsn_inventory:locker:save
- fsn_inventory:me:update
- fsn_inventory:pd_locker:recieve
- fsn_inventory:ply:done
- fsn_inventory:ply:finished
- fsn_inventory:ply:recieve
- fsn_inventory:ply:request
- fsn_inventory:ply:update
- fsn_inventory:police_armory:recieve
- fsn_inventory:prebuy
- fsn_inventory:prop:recieve
- fsn_inventory:rebreather:use
- fsn_inventory:recieveItems
- fsn_inventory:removedropped
- fsn_inventory:sendItems
- fsn_inventory:sendItemsToArmory
- fsn_inventory:sendItemsToStore
- fsn_inventory:store:recieve
- fsn_inventory:store_gun:recieve
- fsn_inventory:sys:request
- fsn_inventory:sys:send
- fsn_inventory:use:drink
- fsn_inventory:use:food
- fsn_inventory:useAmmo
- fsn_inventory:useArmor
- fsn_inventory:veh:finished
- fsn_inventory:veh:glovebox
- fsn_inventory:veh:glovebox:recieve
- fsn_inventory:veh:request
- fsn_inventory:veh:trunk:recieve
- fsn_inventory:veh:update
- fsn_jail:init
- fsn_jail:releaseme
- fsn_jail:sendme
- fsn_jail:sendsuspect
- fsn_jail:spawn
- fsn_jail:spawn:recieve
- fsn_jail:update:database
- fsn_jewellerystore:case:rob
- fsn_jewellerystore:case:startrob
- fsn_jewellerystore:cases:request
- fsn_jewellerystore:cases:update
- fsn_jewellerystore:doors:Lock
- fsn_jewellerystore:doors:State
- fsn_jewellerystore:gasDoor:toggle
- fsn_jobs:ems:request
- fsn_jobs:mechanic:toggle
- fsn_jobs:mechanic:toggleduty
- fsn_jobs:news:role:Set
- fsn_jobs:paycheck
- fsn_jobs:quit
- fsn_jobs:taxi:accepted
- fsn_jobs:taxi:request
- fsn_jobs:tow:mark
- fsn_jobs:tow:marked
- fsn_jobs:tow:request
- fsn_jobs:whitelist:access:add
- fsn_jobs:whitelist:add
- fsn_jobs:whitelist:clock:in
- fsn_jobs:whitelist:clock:out
- fsn_jobs:whitelist:remove
- fsn_jobs:whitelist:request
- fsn_jobs:whitelist:update
- fsn_licenses:chat
- fsn_licenses:check
- fsn_licenses:display
- fsn_licenses:giveID
- fsn_licenses:id:display
- fsn_licenses:id:request
- fsn_licenses:infraction
- fsn_licenses:police:give
- fsn_licenses:setinfractions
- fsn_licenses:showid
- fsn_licenses:update
- fsn_lscustoms:check
- fsn_lscustoms:check2
- fsn_lscustoms:check3
- fsn_main:blip:add
- fsn_main:blip:clear
- fsn_main:charMenu
- fsn_main:character
- fsn_main:characterSaving
- fsn_main:createCharacter
- fsn_main:debug_toggle
- fsn_main:displayBankandMoney
- fsn_main:getCharacter
- fsn_main:gui:bank:change
- fsn_main:gui:both:display
- fsn_main:gui:money:change
- fsn_main:initiateCharacter
- fsn_main:logging:addLog
- fsn_main:money:bank:Add
- fsn_main:money:bank:Minus
- fsn_main:money:bank:Set
- fsn_main:money:initChar
- fsn_main:money:update
- fsn_main:money:updateSilent
- fsn_main:money:wallet:Add
- fsn_main:money:wallet:GiveCash
- fsn_main:money:wallet:Minus
- fsn_main:money:wallet:Set
- fsn_main:requestCharacters
- fsn_main:saveCharacter
- fsn_main:sendCharacters
- fsn_main:update:myCharacter
- fsn_main:updateCharNumber
- fsn_main:updateCharacters
- fsn_main:updateMoneyStore
- fsn_main:validatePlayer
- fsn_menu:requestInventory
- fsn_needs:stress:add
- fsn_needs:stress:remove
- fsn_notify:displayNotification
- fsn_odometer:addMileage
- fsn_odometer:getMileage
- fsn_odometer:resetMileage
- fsn_odometer:setMileage
- fsn_phones:GUI:notification
- fsn_phones:SYS:addTransaction
- fsn_phones:SYS:newNumber
- fsn_phones:SYS:receiveGarage
- fsn_phones:SYS:recieve:details
- fsn_phones:SYS:request:details
- fsn_phones:SYS:requestGarage
- fsn_phones:SYS:sendTweet
- fsn_phones:SYS:set:details
- fsn_phones:SYS:updateAdverts
- fsn_phones:SYS:updateNumber
- fsn_phones:USE:Email
- fsn_phones:USE:Message
- fsn_phones:USE:Phone
- fsn_phones:USE:Tweet
- fsn_phones:USE:darkweb:order
- fsn_phones:USE:sendAdvert
- fsn_phones:USE:sendMessage
- fsn_phones:UTIL:chat
- fsn_phones:UTIL:displayNumber
- fsn_police:911
- fsn_police:911r
- fsn_police:GetInVehicle
- fsn_police:MDT:receivewarrants
- fsn_police:MDT:requestwarrants
- fsn_police:MDT:toggle
- fsn_police:MDT:vehicledetails
- fsn_police:MDT:warrant
- fsn_police:MDTremovewarrant
- fsn_police:Sit
- fsn_police:ToggleK9
- fsn_police:armory:boughtOne
- fsn_police:armory:closedArmory
- fsn_police:armory:recieveItemsForArmory
- fsn_police:armory:request
- fsn_police:chat:ticket
- fsn_police:command:duty
- fsn_police:cuffs:requestCuff
- fsn_police:cuffs:requestunCuff
- fsn_police:cuffs:startCuffed
- fsn_police:cuffs:startCuffing
- fsn_police:cuffs:startunCuffed
- fsn_police:cuffs:startunCuffing
- fsn_police:cuffs:toggleEscort
- fsn_police:cuffs:toggleHard
- fsn_police:database:CPIC
- fsn_police:database:CPIC:search
- fsn_police:database:CPIC:search:result
- fsn_police:dispatch
- fsn_police:dispatch:toggle
- fsn_police:dispatchcall
- fsn_police:init
- fsn_police:k9:search:person:end
- fsn_police:k9:search:person:finish
- fsn_police:k9:search:person:me
- fsn_police:offDuty
- fsn_police:onDuty
- fsn_police:pd:toggleDrag
- fsn_police:ply:toggleDrag
- fsn_police:putMeInVeh
- fsn_police:radar:toggle
- fsn_police:requestUpdate
- fsn_police:runplate
- fsn_police:runplate::target
- fsn_police:runplate:target
- fsn_police:search:end:inventory
- fsn_police:search:end:money
- fsn_police:search:end:weapons
- fsn_police:search:start:inventory
- fsn_police:search:start:money
- fsn_police:search:start:weapons
- fsn_police:search:strip
- fsn_police:ticket
- fsn_police:toggleHandcuffs
- fsn_police:update
- fsn_police:updateLevel
- fsn_properties:access
- fsn_properties:buy
- fsn_properties:inv:closed
- fsn_properties:inv:update
- fsn_properties:keys:give
- fsn_properties:leave
- fsn_properties:realator:clock
- fsn_properties:rent:check
- fsn_properties:rent:pay
- fsn_properties:request
- fsn_properties:updateXYZ
- fsn_spawnmanager:start
- fsn_store:boughtOne
- fsn_store:closedStore
- fsn_store:recieveItemsForStore
- fsn_store:request
- fsn_store_guns:boughtOne
- fsn_store_guns:closedStore
- fsn_store_guns:request
- fsn_stripclub:client:update
- fsn_teleporters:teleport:coordinates
- fsn_teleporters:teleport:waypoint
- fsn_timeandweather:notify
- fsn_timeandweather:requestSync
- fsn_timeandweather:updateTime
- fsn_timeandweather:updateWeather
- fsn_vehiclecontrol:damage:repair
- fsn_vehiclecontrol:damage:repairkit
- fsn_vehiclecontrol:flagged:add
- fsn_vehiclecontrol:getKeys
- fsn_vehiclecontrol:giveKeys
- fsn_vehiclecontrol:givekeys
- fsn_vehiclecontrol:keys:carjack
- fsn_vehiclecontrol:trunk:forceIn
- fsn_vehiclecontrol:trunk:forceOut
- fsn_voicecontrol:call:answer
- fsn_voicecontrol:call:decline
- fsn_voicecontrol:call:end
- fsn_voicecontrol:call:hold
- fsn_voicecontrol:call:ring
- fsn_voicecontrol:call:unhold
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
- onClientResourceStart
- onResourceStart
- onResourceStop
- onServerResourceStart
- pNotify:SendNotification
- pNotify:SetQueueMax
- playerConnecting
- playerDropped
- playerSpawned
- safecracking:loop
- safecracking:start
- spawnme
- tow:CAD:tow

### Events (trigger)

- 1a4d29ac-5c1a-427e-ab18-461ae6b76e8b
- Cam:ToggleCam
- DoLongHudText
- EngineToggle:Engine
- InteractSound_SV:PlayWithinDistance
- Mic:ToggleMic
- PlayerSpawned
- Tackle:Client:TacklePlayer
- Tackle:Server:TacklePlayer
- _chat:messageEntered
- binoculars:Activate
- chat:addMessage
- chat:addSuggestion
- chat:addSuggestions
- chat:init
- chat:removeSuggestion
- chatMessage
- clothes:changemodel
- clothes:firstspawn
- clothes:loaded
- clothes:save
- clothes:setComponents
- clothes:spawn
- fs_freemode:displaytext
- fs_freemode:missionComplete
- fs_freemode:notify
- fsn->esx:clothing:spawn
- fsn:getFsnObject
- fsn:playerReady
- fsn_admin:FreezeMe
- fsn_admin:enableAdminCommands
- fsn_admin:enableModeratorCommands
- fsn_admin:menu:toggle
- fsn_admin:recieveXYZ
- fsn_admin:requestXYZ
- fsn_admin:sendXYZ
- fsn_apartments:characterCreation
- fsn_apartments:createApartment
- fsn_apartments:getApartment
- fsn_apartments:instance:debug
- fsn_apartments:instance:join
- fsn_apartments:instance:leave
- fsn_apartments:instance:new
- fsn_apartments:instance:update
- fsn_apartments:inv:update
- fsn_apartments:outfit:add
- fsn_apartments:outfit:list
- fsn_apartments:outfit:remove
- fsn_apartments:outfit:use
- fsn_apartments:saveApartment
- fsn_apartments:sendApartment
- fsn_apartments:stash:add
- fsn_apartments:stash:take
- fsn_bank:change:bankAdd
- fsn_bank:change:bankMinus
- fsn_bank:change:bankandwallet
- fsn_bank:change:walletAdd
- fsn_bank:change:walletMinus
- fsn_bank:request:both
- fsn_bank:transfer
- fsn_bank:update:both
- fsn_bankrobbery:LostMC:spawn
- fsn_bankrobbery:closeDoor
- fsn_bankrobbery:desks:doorUnlock
- fsn_bankrobbery:desks:endHack
- fsn_bankrobbery:desks:receive
- fsn_bankrobbery:desks:request
- fsn_bankrobbery:desks:startHack
- fsn_bankrobbery:init
- fsn_bankrobbery:openDoor
- fsn_bankrobbery:payout
- fsn_bankrobbery:start
- fsn_bankrobbery:timer
- fsn_bankrobbery:vault:close
- fsn_bankrobbery:vault:open
- fsn_boatshop:floor:ChangeBoat
- fsn_boatshop:floor:Request
- fsn_boatshop:floor:Update
- fsn_boatshop:floor:Updateboat
- fsn_boatshop:floor:color:One
- fsn_boatshop:floor:color:Two
- fsn_boatshop:floor:commission
- fsn_boatshop:testdrive:end
- fsn_boatshop:testdrive:start
- fsn_cargarage:buyVehicle
- fsn_cargarage:impound
- fsn_cargarage:makeMine
- fsn_cargarage:receiveVehicles
- fsn_cargarage:requestVehicles
- fsn_cargarage:reset
- fsn_cargarage:updateVehicle
- fsn_cargarage:vehicle:toggleStatus
- fsn_cargarage:vehicleStatus
- fsn_carstore:floor:ChangeCar
- fsn_carstore:floor:Request
- fsn_carstore:floor:Update
- fsn_carstore:floor:UpdateCar
- fsn_carstore:floor:color:One
- fsn_carstore:floor:color:Two
- fsn_carstore:floor:commission
- fsn_carstore:testdrive:end
- fsn_carstore:testdrive:start
- fsn_clothing:change
- fsn_clothing:menu
- fsn_commands:airlift
- fsn_commands:clothing:glasses
- fsn_commands:clothing:hat
- fsn_commands:clothing:mask
- fsn_commands:dev:fix
- fsn_commands:dev:spawnCar
- fsn_commands:dev:weapon
- fsn_commands:ems:adamage:inspect
- fsn_commands:getHDC
- fsn_commands:hc:rob
- fsn_commands:hc:takephone
- fsn_commands:me
- fsn_commands:me:3d
- fsn_commands:police:boot
- fsn_commands:police:booted
- fsn_commands:police:car
- fsn_commands:police:cpic:trigger
- fsn_commands:police:extra
- fsn_commands:police:extras
- fsn_commands:police:fix
- fsn_commands:police:gsrMe
- fsn_commands:police:gsrResult
- fsn_commands:police:impound
- fsn_commands:police:impound2
- fsn_commands:police:livery
- fsn_commands:police:pedcarry
- fsn_commands:police:pedrevive
- fsn_commands:police:rifle
- fsn_commands:police:shotgun
- fsn_commands:police:towMark
- fsn_commands:police:unboot
- fsn_commands:police:unbooted
- fsn_commands:police:updateBoot
- fsn_commands:printxyz
- fsn_commands:requestHDC
- fsn_commands:sendxyz
- fsn_commands:service:addPing
- fsn_commands:service:pingAccept
- fsn_commands:service:pingStart
- fsn_commands:service:request
- fsn_commands:service:sendrequest
- fsn_commands:vehdoor:close
- fsn_commands:vehdoor:open
- fsn_commands:window
- fsn_criminalmisc:drugs:effects:cocaine
- fsn_criminalmisc:drugs:effects:meth
- fsn_criminalmisc:drugs:effects:smokeCigarette
- fsn_criminalmisc:drugs:effects:weed
- fsn_criminalmisc:drugs:streetselling:area
- fsn_criminalmisc:drugs:streetselling:radio
- fsn_criminalmisc:drugs:streetselling:request
- fsn_criminalmisc:drugs:streetselling:send
- fsn_criminalmisc:handcuffs:requestCuff
- fsn_criminalmisc:handcuffs:requestunCuff
- fsn_criminalmisc:handcuffs:startCuffed
- fsn_criminalmisc:handcuffs:startCuffing
- fsn_criminalmisc:handcuffs:startunCuffed
- fsn_criminalmisc:handcuffs:startunCuffing
- fsn_criminalmisc:handcuffs:toggleEscort
- fsn_criminalmisc:houserobbery:try
- fsn_criminalmisc:lockpicking
- fsn_criminalmisc:racing:createRace
- fsn_criminalmisc:racing:joinRace
- fsn_criminalmisc:racing:newRace
- fsn_criminalmisc:racing:putmeinrace
- fsn_criminalmisc:racing:update
- fsn_criminalmisc:racing:win
- fsn_criminalmisc:robbing:requesRob
- fsn_criminalmisc:robbing:startRobbing
- fsn_criminalmisc:toggleDrag
- fsn_criminalmisc:weapons:add:police
- fsn_criminalmisc:weapons:add:tbl
- fsn_criminalmisc:weapons:add:unknown
- fsn_criminalmisc:weapons:addDrop
- fsn_criminalmisc:weapons:destroy
- fsn_criminalmisc:weapons:drop
- fsn_criminalmisc:weapons:equip
- fsn_criminalmisc:weapons:info
- fsn_criminalmisc:weapons:pickup
- fsn_criminalmisc:weapons:updateDropped
- fsn_dev:debug
- fsn_dev:noClip:enabled
- fsn_developer:deleteVehicle
- fsn_developer:enableDeveloperCommands
- fsn_developer:fixVehicle
- fsn_developer:getKeys
- fsn_developer:noClip:enabled
- fsn_developer:printXYZ
- fsn_developer:sendXYZ
- fsn_developer:spawnVehicle
- fsn_doj:court:remandMe
- fsn_doj:judge:spawnCar
- fsn_doj:judge:toggleLock
- fsn_doormanager:doorLocked
- fsn_doormanager:doorUnlocked
- fsn_doormanager:lockDoor
- fsn_doormanager:request
- fsn_doormanager:requestDoors
- fsn_doormanager:sendDoors
- fsn_doormanager:toggle
- fsn_doormanager:unlockDoor
- fsn_emotecontrol:dice:roll
- fsn_emotecontrol:phone:call1
- fsn_emotecontrol:play
- fsn_emotecontrol:police:tablet
- fsn_emotecontrol:police:ticket
- fsn_emotecontrol:sit
- fsn_ems:911
- fsn_ems:911r
- fsn_ems:CAD:10-43
- fsn_ems:ad:stopBleeding
- fsn_ems:adamage:request
- fsn_ems:bed:health
- fsn_ems:bed:occupy
- fsn_ems:bed:restraintoggle
- fsn_ems:bed:update
- fsn_ems:carried:end
- fsn_ems:carried:start
- fsn_ems:carry:end
- fsn_ems:carry:start
- fsn_ems:killMe
- fsn_ems:offDuty
- fsn_ems:onDuty
- fsn_ems:requestUpdate
- fsn_ems:reviveMe
- fsn_ems:reviveMe:force
- fsn_ems:set:WalkType
- fsn_ems:update
- fsn_ems:updateLevel
- fsn_evidence:collect
- fsn_evidence:destroy
- fsn_evidence:display
- fsn_evidence:drop:blood
- fsn_evidence:drop:casing
- fsn_evidence:ped:addState
- fsn_evidence:ped:update
- fsn_evidence:ped:updateDamage
- fsn_evidence:receive
- fsn_evidence:request
- fsn_evidence:weaponInfo
- fsn_fuel:set
- fsn_fuel:update
- fsn_gangs:garage:enter
- fsn_gangs:hideout:enter
- fsn_gangs:hideout:leave
- fsn_gangs:recieve
- fsn_gangs:request
- fsn_gangs:tryTakeOver
- fsn_garages:vehicle:update
- fsn_hungerandthirst:pause
- fsn_hungerandthirst:unpause
- fsn_inventory:apt:recieve
- fsn_inventory:buyItem
- fsn_inventory:database:update
- fsn_inventory:drops:collect
- fsn_inventory:drops:drop
- fsn_inventory:drops:request
- fsn_inventory:drops:send
- fsn_inventory:empty
- fsn_inventory:floor:update
- fsn_inventory:gasDoorunlock
- fsn_inventory:gui:display
- fsn_inventory:init
- fsn_inventory:initChar
- fsn_inventory:item:add
- fsn_inventory:item:dropped
- fsn_inventory:item:take
- fsn_inventory:itemhasdropped
- fsn_inventory:itempickup
- fsn_inventory:items:add
- fsn_inventory:items:addPreset
- fsn_inventory:items:emptyinv
- fsn_inventory:locker:empty
- fsn_inventory:locker:request
- fsn_inventory:locker:save
- fsn_inventory:me:update
- fsn_inventory:pd_locker:recieve
- fsn_inventory:ply:done
- fsn_inventory:ply:finished
- fsn_inventory:ply:recieve
- fsn_inventory:ply:request
- fsn_inventory:ply:update
- fsn_inventory:police_armory:recieve
- fsn_inventory:prop:recieve
- fsn_inventory:rebreather:use
- fsn_inventory:recieveItems
- fsn_inventory:removedropped
- fsn_inventory:sendItems
- fsn_inventory:sendItemsToArmory
- fsn_inventory:sendItemsToStore
- fsn_inventory:store:recieve
- fsn_inventory:store_gun:recieve
- fsn_inventory:sys:request
- fsn_inventory:sys:send
- fsn_inventory:update
- fsn_inventory:use:drink
- fsn_inventory:use:food
- fsn_inventory:useAmmo
- fsn_inventory:useArmor
- fsn_inventory:veh:
- fsn_inventory:veh:finished
- fsn_inventory:veh:glovebox
- fsn_inventory:veh:request
- fsn_inventory:veh:update
- fsn_jail:init
- fsn_jail:releaseme
- fsn_jail:sendme
- fsn_jail:sendsuspect
- fsn_jail:spawn
- fsn_jail:spawn:recieve
- fsn_jail:update:database
- fsn_jewellerystore:case:rob
- fsn_jewellerystore:case:startrob
- fsn_jewellerystore:cases:update
- fsn_jewellerystore:doors:State
- fsn_jewellerystore:doors:toggle
- fsn_jewellerystore:gasDoor:toggle
- fsn_jobs:ems:request
- fsn_jobs:mechanic:toggle
- fsn_jobs:mechanic:toggleduty
- fsn_jobs:news:role:Set
- fsn_jobs:news:role:Toggle
- fsn_jobs:paycheck
- fsn_jobs:quit
- fsn_jobs:taxi:request
- fsn_jobs:tow:mark
- fsn_jobs:tow:marked
- fsn_jobs:tow:request
- fsn_jobs:whitelist:add
- fsn_jobs:whitelist:clock:in
- fsn_jobs:whitelist:clock:out
- fsn_jobs:whitelist:remove
- fsn_jobs:whitelist:request
- fsn_jobs:whitelist:update
- fsn_licenses:chat
- fsn_licenses:check
- fsn_licenses:display
- fsn_licenses:giveID
- fsn_licenses:id:display
- fsn_licenses:id:request
- fsn_licenses:infraction
- fsn_licenses:police:give
- fsn_licenses:setInfractions
- fsn_licenses:setinfractions
- fsn_licenses:showid
- fsn_licenses:update
- fsn_lscustoms:receive
- fsn_lscustoms:receive2
- fsn_lscustoms:receive3
- fsn_main:blip:add
- fsn_main:blip:clear
- fsn_main:charMenu
- fsn_main:character
- fsn_main:characterSaving
- fsn_main:createCharacter
- fsn_main:debug_toggle
- fsn_main:displayBankandMoney
- fsn_main:getCharacter
- fsn_main:gui:bank:addMoney
- fsn_main:gui:bank:change
- fsn_main:gui:bank:changeAmount
- fsn_main:gui:bank:minusMoney
- fsn_main:gui:both:display
- fsn_main:gui:minusMoney
- fsn_main:gui:money:addMoney
- fsn_main:gui:money:change
- fsn_main:gui:money:changeAmount
- fsn_main:initiateCharacter
- fsn_main:logging:addLog
- fsn_main:money:bank:Add
- fsn_main:money:bank:Minus
- fsn_main:money:bank:Set
- fsn_main:money:initChar
- fsn_main:money:update
- fsn_main:money:updateSilent
- fsn_main:money:wallet:Add
- fsn_main:money:wallet:GiveCash
- fsn_main:money:wallet:Minus
- fsn_main:money:wallet:Set
- fsn_main:requestCharacters
- fsn_main:saveCharacter
- fsn_main:sendCharacters
- fsn_main:updateCharNumber
- fsn_main:updateCharacters
- fsn_main:updateMoneyStore
- fsn_main:version
- fsn_needs:stress:add
- fsn_needs:stress:remove
- fsn_notify:displayNotification
- fsn_odometer:addMileage
- fsn_odometer:setMileage
- fsn_phone:displayNumber
- fsn_phone:recieveMessage
- fsn_phone:togglePhone
- fsn_phones:GUI:notification
- fsn_phones:SYS:addTransaction
- fsn_phones:SYS:newNumber
- fsn_phones:SYS:receiveGarage
- fsn_phones:SYS:recieve:details
- fsn_phones:SYS:request:details
- fsn_phones:SYS:requestGarage
- fsn_phones:SYS:sendTweet
- fsn_phones:SYS:set:details
- fsn_phones:SYS:updateAdverts
- fsn_phones:SYS:updateNumber
- fsn_phones:USE:Email
- fsn_phones:USE:Message
- fsn_phones:USE:Phone
- fsn_phones:USE:Tweet
- fsn_phones:USE:sendAdvert
- fsn_phones:USE:sendMessage
- fsn_phones:UTIL:chat
- fsn_phones:UTIL:displayNumber
- fsn_police:911
- fsn_police:911r
- fsn_police:CAD:10-43
- fsn_police:GetInVehicle
- fsn_police:MDT:receivewarrants
- fsn_police:MDT:requestwarrants
- fsn_police:MDT:toggle
- fsn_police:MDT:vehicledetails
- fsn_police:MDT:warrant
- fsn_police:MDTremovewarrant
- fsn_police:Sit
- fsn_police:ToggleFollow
- fsn_police:ToggleK9
- fsn_police:armory:boughtOne
- fsn_police:armory:closedArmory
- fsn_police:armory:recieveItemsForArmory
- fsn_police:armory:request
- fsn_police:chat:ticket
- fsn_police:command:duty
- fsn_police:cuffs:requestCuff
- fsn_police:cuffs:requestunCuff
- fsn_police:cuffs:startCuffed
- fsn_police:cuffs:startCuffing
- fsn_police:cuffs:startunCuffed
- fsn_police:cuffs:startunCuffing
- fsn_police:cuffs:toggleEscort
- fsn_police:cuffs:toggleHard
- fsn_police:database:CPIC
- fsn_police:database:CPIC:search
- fsn_police:database:CPIC:search:result
- fsn_police:dispatch
- fsn_police:dispatch:toggle
- fsn_police:dispatchcall
- fsn_police:handcuffs:hard
- fsn_police:handcuffs:soft
- fsn_police:handcuffs:toggle
- fsn_police:init
- fsn_police:k9:search:person:end
- fsn_police:k9:search:person:finish
- fsn_police:k9:search:person:me
- fsn_police:offDuty
- fsn_police:onDuty
- fsn_police:pd:toggleDrag
- fsn_police:ply:toggleDrag
- fsn_police:putMeInVeh
- fsn_police:radar:toggle
- fsn_police:requestUpdate
- fsn_police:runplate
- fsn_police:runplate::target
- fsn_police:runplate:target
- fsn_police:search:end:inventory
- fsn_police:search:end:money
- fsn_police:search:end:weapons
- fsn_police:search:start:inventory
- fsn_police:search:start:money
- fsn_police:search:start:weapons
- fsn_police:search:strip
- fsn_police:ticket
- fsn_police:toggleDrag
- fsn_police:update
- fsn_police:updateLevel
- fsn_properties:access
- fsn_properties:buy
- fsn_properties:inv:closed
- fsn_properties:inv:update
- fsn_properties:leave
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
- fsn_properties:rent:check
- fsn_properties:rent:pay
- fsn_properties:request
- fsn_properties:requestKeys
- fsn_properties:updateXYZ
- fsn_spawnmanager:start
- fsn_store:boughtOne
- fsn_store:closedStore
- fsn_store:recieveItemsForStore
- fsn_store:request
- fsn_store_guns:request
- fsn_stripclub:server:claimBooth
- fsn_teleporters:teleport:coordinates
- fsn_teleporters:teleport:waypoint
- fsn_timeandweather:notify
- fsn_timeandweather:requestSync
- fsn_timeandweather:updateTime
- fsn_timeandweather:updateWeather
- fsn_vehiclecontrol:damage:repair
- fsn_vehiclecontrol:damage:repairkit
- fsn_vehiclecontrol:getKeys
- fsn_vehiclecontrol:giveKeys
- fsn_vehiclecontrol:givekeys
- fsn_vehiclecontrol:keys:carjack
- fsn_vehiclecontrol:trunk:forceIn
- fsn_vehiclecontrol:trunk:forceOut
- fsn_voicecontrol:call:answer
- fsn_voicecontrol:call:end
- fsn_voicecontrol:call:hold
- fsn_voicecontrol:call:ring
- fsn_voicecontrol:call:start
- fsn_voicecontrol:call:unhold
- fsn_yoga:checkStress
- jCAD:tow
- jFarm:payme
- jTow:return
- jTow:spawn
- jTow:success
- mhacking:hide
- mhacking:show
- mhacking:start
- mythic_hospital:client:RemoveBleed
- mythic_hospital:client:ResetLimbs
- mythic_hospital:client:UseAdrenaline
- mythic_hospital:client:UsePainKiller
- mythic_hospital:server:SyncInjuries
- mythic_notify:SendAlert
- mythic_notify:client:SendAlert
- pNotify:SendNotification
- police:setAnimData
- safe:success
- safecracking:loop
- safecracking:start
- spawnme
- xgc-tuner:openTuner

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

- LegacyFuel
- Noty
- default
- freecam
- fsn_apartments
- fsn_cargarage
- fsn_clothing
- fsn_criminalmisc
- fsn_doormanager
- fsn_ems
- fsn_entfinder
- fsn_inventory
- fsn_jobs
- fsn_licenses
- fsn_main
- fsn_needs
- fsn_police
- fsn_progress
- fsn_timeandweather
- mythic_notify

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
