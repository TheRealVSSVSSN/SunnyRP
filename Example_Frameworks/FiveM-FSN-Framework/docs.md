# FiveM-FSN-Framework Documentation

## Overview
The FiveM-FSN-Framework resource bundles multiple gameplay modules for SunnyRP. Each sub-resource delivers a specific feature such as housing, banking, policing, vehicle systems, and miscellaneous utilities. The framework mixes client Lua scripts, server logic, and browser-based NUI components. This documentation inventories all files, network interfaces, and integration points discovered through static analysis.

## Table of Contents
- [File Inventory](#file-inventory)
- [Events](#events)
- [Commands](#commands)
- [Exports](#exports)
- [NUI Callbacks](#nui-callbacks)
- [Database Tables](#database-tables)
- [Gaps & Inferences](#gaps--inferences)

## File Inventory
- `./fsn_activities/fishing/client.lua` — client — fsn_activities client script (Inferred: Low)
- `./fsn_activities/fxmanifest.lua` — shared — fsn_activities shared script (Inferred: Low)
- `./fsn_activities/hunting/client.lua` — client — fsn_activities client script (Inferred: Low)
- `./fsn_activities/yoga/client.lua` — client — fsn_activities client script (Inferred: Low)
- `./fsn_admin/client.lua` — client — fsn_admin client script (Inferred: Low)
- `./fsn_admin/client/client.lua` — client — fsn_admin client script (Inferred: Low)
- `./fsn_admin/config.lua` — shared — fsn_admin shared script (Inferred: Low)
- `./fsn_admin/fxmanifest.lua` — shared — fsn_admin shared script (Inferred: Low)
- `./fsn_admin/oldresource.lua` — shared — fsn_admin shared script (Inferred: Low)
- `./fsn_admin/server.lua` — server — fsn_admin server script (Inferred: Low)
- `./fsn_admin/server/server.lua` — server — fsn_admin server script (Inferred: Low)
- `./fsn_admin/server_announce.lua` — server — fsn_admin server script (Inferred: Low)
- `./fsn_apartments/cl_instancing.lua` — client — fsn_apartments client script (Inferred: Low)
- `./fsn_apartments/client.lua` — client — fsn_apartments client script (Inferred: Low)
- `./fsn_apartments/fxmanifest.lua` — shared — fsn_apartments shared script (Inferred: Low)
- `./fsn_apartments/gui/ui.css` — NUI — fsn_apartments NUI asset (Inferred: Low)
- `./fsn_apartments/gui/ui.html` — NUI — fsn_apartments NUI asset (Inferred: Low)
- `./fsn_apartments/gui/ui.js` — NUI — fsn_apartments NUI asset (Inferred: Low)
- `./fsn_apartments/server.lua` — server — fsn_apartments server script (Inferred: Low)
- `./fsn_apartments/sv_instancing.lua` — server — fsn_apartments server script (Inferred: Low)
- `./fsn_bank/client.lua` — client — fsn_bank client script (Inferred: Low)
- `./fsn_bank/fxmanifest.lua` — shared — fsn_bank shared script (Inferred: Low)
- `./fsn_bank/gui/index.css` — NUI — fsn_bank NUI asset (Inferred: Low)
- `./fsn_bank/gui/index.html` — NUI — fsn_bank NUI asset (Inferred: Low)
- `./fsn_bank/gui/index.js` — NUI — fsn_bank NUI asset (Inferred: Low)
- `./fsn_bank/server.lua` — server — fsn_bank server script (Inferred: Low)
- `./fsn_bankrobbery/cl_frontdesks.lua` — client — fsn_bankrobbery client script (Inferred: Low)
- `./fsn_bankrobbery/cl_safeanim.lua` — client — fsn_bankrobbery client script (Inferred: Low)
- `./fsn_bankrobbery/client.lua` — client — fsn_bankrobbery client script (Inferred: Low)
- `./fsn_bankrobbery/fxmanifest.lua` — shared — fsn_bankrobbery shared script (Inferred: Low)
- `./fsn_bankrobbery/server.lua` — server — fsn_bankrobbery server script (Inferred: Low)
- `./fsn_bankrobbery/sv_frontdesks.lua` — server — fsn_bankrobbery server script (Inferred: Low)
- `./fsn_bankrobbery/trucks.lua` — shared — fsn_bankrobbery shared script (Inferred: Low)
- `./fsn_bennys/cl_bennys.lua` — client — fsn_bennys client script (Inferred: Low)
- `./fsn_bennys/cl_config.lua` — client — fsn_bennys client script (Inferred: Low)
- `./fsn_bennys/fxmanifest.lua` — shared — fsn_bennys shared script (Inferred: Low)
- `./fsn_bennys/menu.lua` — shared — fsn_bennys shared script (Inferred: Low)
- `./fsn_bikerental/client.lua` — client — fsn_bikerental client script (Inferred: Low)
- `./fsn_bikerental/fxmanifest.lua` — shared — fsn_bikerental shared script (Inferred: Low)
- `./fsn_bikerental/html/index.html` — NUI — fsn_bikerental NUI asset (Inferred: Low)
- `./fsn_bikerental/html/script.js` — NUI — fsn_bikerental NUI asset (Inferred: Low)
- `./fsn_bikerental/html/style.css` — NUI — fsn_bikerental NUI asset (Inferred: Low)
- `./fsn_boatshop/cl_boatshop.lua` — client — fsn_boatshop client script (Inferred: Low)
- `./fsn_boatshop/cl_menu.lua` — client — fsn_boatshop client script (Inferred: Low)
- `./fsn_boatshop/fxmanifest.lua` — shared — fsn_boatshop shared script (Inferred: Low)
- `./fsn_boatshop/sv_boatshop.lua` — server — fsn_boatshop server script (Inferred: Low)
- `./fsn_builders/fxmanifest.lua` — shared — fsn_builders shared script (Inferred: Low)
- `./fsn_builders/handling_builder.lua` — shared — fsn_builders shared script (Inferred: Low)
- `./fsn_builders/schema.lua` — shared — fsn_builders shared script (Inferred: Low)
- `./fsn_builders/schemas/cbikehandlingdata.lua` — shared — fsn_builders shared script (Inferred: Low)
- `./fsn_builders/schemas/ccarhandlingdata.lua` — shared — fsn_builders shared script (Inferred: Low)
- `./fsn_builders/schemas/chandlingdata.lua` — shared — fsn_builders shared script (Inferred: Low)
- `./fsn_builders/xml.lua` — shared — fsn_builders shared script (Inferred: Low)
- `./fsn_cargarage/client.lua` — client — fsn_cargarage client script (Inferred: Low)
- `./fsn_cargarage/fxmanifest.lua` — shared — fsn_cargarage shared script (Inferred: Low)
- `./fsn_cargarage/gui/ui.css` — NUI — fsn_cargarage NUI asset (Inferred: Low)
- `./fsn_cargarage/gui/ui.html` — NUI — fsn_cargarage NUI asset (Inferred: Low)
- `./fsn_cargarage/gui/ui.js` — NUI — fsn_cargarage NUI asset (Inferred: Low)
- `./fsn_cargarage/server.lua` — server — fsn_cargarage server script (Inferred: Low)
- `./fsn_carstore/cl_carstore.lua` — client — fsn_carstore client script (Inferred: Low)
- `./fsn_carstore/cl_menu.lua` — client — fsn_carstore client script (Inferred: Low)
- `./fsn_carstore/fxmanifest.lua` — shared — fsn_carstore shared script (Inferred: Low)
- `./fsn_carstore/gui/index.html` — NUI — fsn_carstore NUI asset (Inferred: Low)
- `./fsn_carstore/sv_carstore.lua` — server — fsn_carstore server script (Inferred: Low)
- `./fsn_carstore/vehshop_server.lua` — server — fsn_carstore server script (Inferred: Low)
- `./fsn_characterdetails/facial/client.lua` — client — fsn_characterdetails client script (Inferred: Low)
- `./fsn_characterdetails/facial/server.lua` — server — fsn_characterdetails server script (Inferred: Low)
- `./fsn_characterdetails/fxmanifest.lua` — shared — fsn_characterdetails shared script (Inferred: Low)
- `./fsn_characterdetails/gui/ui.css` — NUI — fsn_characterdetails NUI asset (Inferred: Low)
- `./fsn_characterdetails/gui/ui.html` — NUI — fsn_characterdetails NUI asset (Inferred: Low)
- `./fsn_characterdetails/gui/ui.js` — NUI — fsn_characterdetails NUI asset (Inferred: Low)
- `./fsn_characterdetails/gui_manager.lua` — NUI — fsn_characterdetails NUI asset (Inferred: Low)
- `./fsn_characterdetails/tattoos/client.lua` — client — fsn_characterdetails client script (Inferred: Low)
- `./fsn_characterdetails/tattoos/config.lua` — shared — fsn_characterdetails shared script (Inferred: Low)
- `./fsn_characterdetails/tattoos/server.lua` — server — fsn_characterdetails server script (Inferred: Low)
- `./fsn_clothing/client.lua` — client — fsn_clothing client script (Inferred: Low)
- `./fsn_clothing/config.lua` — shared — fsn_clothing shared script (Inferred: Low)
- `./fsn_clothing/fxmanifest.lua` — shared — fsn_clothing shared script (Inferred: Low)
- `./fsn_clothing/gui.lua` — NUI — fsn_clothing NUI asset (Inferred: Low)
- `./fsn_clothing/server.lua` — server — fsn_clothing server script (Inferred: Low)
- `./fsn_commands/client.lua` — client — fsn_commands client script (Inferred: Low)
- `./fsn_commands/fxmanifest.lua` — shared — fsn_commands shared script (Inferred: Low)
- `./fsn_commands/server.lua` — server — fsn_commands server script (Inferred: Low)
- `./fsn_crafting/client.lua` — client — fsn_crafting client script (Inferred: Low)
- `./fsn_crafting/fxmanifest.lua` — shared — fsn_crafting shared script (Inferred: Low)
- `./fsn_crafting/nui/index.css` — NUI — fsn_crafting NUI asset (Inferred: Low)
- `./fsn_crafting/nui/index.html` — NUI — fsn_crafting NUI asset (Inferred: Low)
- `./fsn_crafting/nui/index.js` — NUI — fsn_crafting NUI asset (Inferred: Low)
- `./fsn_crafting/server.lua` — server — fsn_crafting server script (Inferred: Low)
- `./fsn_criminalmisc/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/drugs/_effects/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/drugs/_streetselling/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/drugs/_streetselling/server.lua` — server — fsn_criminalmisc server script (Inferred: Low)
- `./fsn_criminalmisc/drugs/_weedprocess/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/drugs/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/fxmanifest.lua` — shared — fsn_criminalmisc shared script (Inferred: Low)
- `./fsn_criminalmisc/handcuffs/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/handcuffs/server.lua` — server — fsn_criminalmisc server script (Inferred: Low)
- `./fsn_criminalmisc/lockpicking/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/pawnstore/cl_pawnstore.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/remapping/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/remapping/server.lua` — server — fsn_criminalmisc server script (Inferred: Low)
- `./fsn_criminalmisc/robbing/cl_houses-build.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/robbing/cl_houses-config.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/robbing/cl_houses.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/robbing/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/streetracing/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/streetracing/server.lua` — server — fsn_criminalmisc server script (Inferred: Low)
- `./fsn_criminalmisc/weaponinfo/client.lua` — client — fsn_criminalmisc client script (Inferred: Low)
- `./fsn_criminalmisc/weaponinfo/server.lua` — server — fsn_criminalmisc server script (Inferred: Low)
- `./fsn_criminalmisc/weaponinfo/weapon_list.lua` — shared — fsn_criminalmisc shared script (Inferred: Low)
- `./fsn_customanimations/client.lua` — client — fsn_customanimations client script (Inferred: Low)
- `./fsn_customanimations/fxmanifest.lua` — shared — fsn_customanimations shared script (Inferred: Low)
- `./fsn_customs/fxmanifest.lua` — shared — fsn_customs shared script (Inferred: Low)
- `./fsn_customs/lscustoms.lua` — shared — fsn_customs shared script (Inferred: Low)
- `./fsn_dev/client/cl_noclip.lua` — client — fsn_dev client script (Inferred: Low)
- `./fsn_dev/client/client.lua` — client — fsn_dev client script (Inferred: Low)
- `./fsn_dev/config.lua` — shared — fsn_dev shared script (Inferred: Low)
- `./fsn_dev/fxmanifest.lua` — shared — fsn_dev shared script (Inferred: Low)
- `./fsn_dev/oldresource.lua` — shared — fsn_dev shared script (Inferred: Low)
- `./fsn_dev/server/server.lua` — server — fsn_dev server script (Inferred: Low)
- `./fsn_doj/attorneys/client.lua` — client — fsn_doj client script (Inferred: Low)
- `./fsn_doj/attorneys/server.lua` — server — fsn_doj server script (Inferred: Low)
- `./fsn_doj/client.lua` — client — fsn_doj client script (Inferred: Low)
- `./fsn_doj/fxmanifest.lua` — shared — fsn_doj shared script (Inferred: Low)
- `./fsn_doj/judges/client.lua` — client — fsn_doj client script (Inferred: Low)
- `./fsn_doj/judges/server.lua` — server — fsn_doj server script (Inferred: Low)
- `./fsn_doormanager/cl_doors.lua` — client — fsn_doormanager client script (Inferred: Low)
- `./fsn_doormanager/client.lua` — client — fsn_doormanager client script (Inferred: Low)
- `./fsn_doormanager/fxmanifest.lua` — shared — fsn_doormanager shared script (Inferred: Low)
- `./fsn_doormanager/server.lua` — server — fsn_doormanager server script (Inferred: Low)
- `./fsn_doormanager/sv_doors.lua` — server — fsn_doormanager server script (Inferred: Low)
- `./fsn_emotecontrol/client.lua` — client — fsn_emotecontrol client script (Inferred: Low)
- `./fsn_emotecontrol/fxmanifest.lua` — shared — fsn_emotecontrol shared script (Inferred: Low)
- `./fsn_emotecontrol/walktypes/client.lua` — client — fsn_emotecontrol client script (Inferred: Low)
- `./fsn_ems/beds/client.lua` — client — fsn_ems client script (Inferred: Low)
- `./fsn_ems/beds/server.lua` — server — fsn_ems server script (Inferred: Low)
- `./fsn_ems/blip.lua` — shared — fsn_ems shared script (Inferred: Low)
- `./fsn_ems/cl_advanceddamage.lua` — client — fsn_ems client script (Inferred: Low)
- `./fsn_ems/cl_carrydead.lua` — client — fsn_ems client script (Inferred: Low)
- `./fsn_ems/cl_volunteering.lua` — client — fsn_ems client script (Inferred: Low)
- `./fsn_ems/client.lua` — client — fsn_ems client script (Inferred: Low)
- `./fsn_ems/debug_kng.lua` — shared — fsn_ems shared script (Inferred: Low)
- `./fsn_ems/fxmanifest.lua` — shared — fsn_ems shared script (Inferred: Low)
- `./fsn_ems/server.lua` — server — fsn_ems server script (Inferred: Low)
- `./fsn_ems/sv_carrydead.lua` — server — fsn_ems server script (Inferred: Low)
- `./fsn_entfinder/client.lua` — client — fsn_entfinder client script (Inferred: Low)
- `./fsn_entfinder/fxmanifest.lua` — shared — fsn_entfinder shared script (Inferred: Low)
- `./fsn_errorcontrol/client.lua` — client — fsn_errorcontrol client script (Inferred: Low)
- `./fsn_errorcontrol/fxmanifest.lua` — shared — fsn_errorcontrol shared script (Inferred: Low)
- `./fsn_evidence/__descriptions-carpaint.lua` — shared — fsn_evidence shared script (Inferred: Low)
- `./fsn_evidence/__descriptions-female.lua` — shared — fsn_evidence shared script (Inferred: Low)
- `./fsn_evidence/__descriptions-male.lua` — shared — fsn_evidence shared script (Inferred: Low)
- `./fsn_evidence/__descriptions.lua` — shared — fsn_evidence shared script (Inferred: Low)
- `./fsn_evidence/casings/cl_casings.lua` — client — fsn_evidence client script (Inferred: Low)
- `./fsn_evidence/cl_evidence.lua` — client — fsn_evidence client script (Inferred: Low)
- `./fsn_evidence/fxmanifest.lua` — shared — fsn_evidence shared script (Inferred: Low)
- `./fsn_evidence/ped/cl_ped.lua` — client — fsn_evidence client script (Inferred: Low)
- `./fsn_evidence/ped/sv_ped.lua` — server — fsn_evidence server script (Inferred: Low)
- `./fsn_evidence/sv_evidence.lua` — server — fsn_evidence server script (Inferred: Low)
- `./fsn_gangs/cl_gangs.lua` — client — fsn_gangs client script (Inferred: Low)
- `./fsn_gangs/fxmanifest.lua` — shared — fsn_gangs shared script (Inferred: Low)
- `./fsn_gangs/sv_gangs.lua` — server — fsn_gangs server script (Inferred: Low)
- `./fsn_handling/fxmanifest.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/compact.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/coupes.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/government.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/motorcycles.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/muscle.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/offroad.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/schafter.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/sedans.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/sports.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/sportsclassics.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/super.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/suvs.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_handling/src/vans.lua` — shared — fsn_handling shared script (Inferred: Low)
- `./fsn_inventory/_item_misc/binoculars.lua` — shared — fsn_inventory shared script (Inferred: Low)
- `./fsn_inventory/_item_misc/burger_store.lua` — shared — fsn_inventory shared script (Inferred: Low)
- `./fsn_inventory/_item_misc/cl_breather.lua` — client — fsn_inventory client script (Inferred: Low)
- `./fsn_inventory/_item_misc/dm_laundering.lua` — shared — fsn_inventory shared script (Inferred: Low)
- `./fsn_inventory/_old/_item_misc/_drug_selling.lua` — shared — fsn_inventory shared script (Inferred: Low)
- `./fsn_inventory/_old/client.lua` — client — fsn_inventory client script (Inferred: Low)
- `./fsn_inventory/_old/items.lua` — shared — fsn_inventory shared script (Inferred: Low)
- `./fsn_inventory/_old/pedfinder.lua` — shared — fsn_inventory shared script (Inferred: Low)
- `./fsn_inventory/_old/server.lua` — server — fsn_inventory server script (Inferred: Low)
- `./fsn_inventory/cl_inventory.lua` — client — fsn_inventory client script (Inferred: Low)
- `./fsn_inventory/cl_presets.lua` — client — fsn_inventory client script (Inferred: Low)
- `./fsn_inventory/cl_uses.lua` — client — fsn_inventory client script (Inferred: Low)
- `./fsn_inventory/cl_vehicles.lua` — client — fsn_inventory client script (Inferred: Low)
- `./fsn_inventory/fxmanifest.lua` — shared — fsn_inventory shared script (Inferred: Low)
- `./fsn_inventory/html/css/jquery-ui.css` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/html/css/ui.css` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/html/js/config.js` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/html/js/inventory.js` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/html/locales/cs.js` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/html/locales/en.js` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/html/locales/fr.js` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/html/ui.html` — NUI — fsn_inventory NUI asset (Inferred: Low)
- `./fsn_inventory/pd_locker/cl_locker.lua` — client — fsn_inventory client script (Inferred: Low)
- `./fsn_inventory/pd_locker/sv_locker.lua` — server — fsn_inventory server script (Inferred: Low)
- `./fsn_inventory/sv_inventory.lua` — server — fsn_inventory server script (Inferred: Low)
- `./fsn_inventory/sv_presets.lua` — server — fsn_inventory server script (Inferred: Low)
- `./fsn_inventory/sv_vehicles.lua` — server — fsn_inventory server script (Inferred: Low)
- `./fsn_inventory_dropping/cl_dropping.lua` — client — fsn_inventory_dropping client script (Inferred: Low)
- `./fsn_inventory_dropping/fxmanifest.lua` — shared — fsn_inventory_dropping shared script (Inferred: Low)
- `./fsn_inventory_dropping/sv_dropping.lua` — server — fsn_inventory_dropping server script (Inferred: Low)
- `./fsn_jail/client.lua` — client — fsn_jail client script (Inferred: Low)
- `./fsn_jail/fxmanifest.lua` — shared — fsn_jail shared script (Inferred: Low)
- `./fsn_jail/server.lua` — server — fsn_jail server script (Inferred: Low)
- `./fsn_jewellerystore/client.lua` — client — fsn_jewellerystore client script (Inferred: Low)
- `./fsn_jewellerystore/fxmanifest.lua` — shared — fsn_jewellerystore shared script (Inferred: Low)
- `./fsn_jewellerystore/server.lua` — server — fsn_jewellerystore server script (Inferred: Low)
- `./fsn_jobs/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/delivery/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/farming/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/fxmanifest.lua` — shared — fsn_jobs shared script (Inferred: Low)
- `./fsn_jobs/garbage/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/hunting/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/mechanic/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/mechanic/mechmenu.lua` — shared — fsn_jobs shared script (Inferred: Low)
- `./fsn_jobs/mechanic/server.lua` — server — fsn_jobs server script (Inferred: Low)
- `./fsn_jobs/news/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/repo/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/repo/server.lua` — server — fsn_jobs server script (Inferred: Low)
- `./fsn_jobs/scrap/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/server.lua` — server — fsn_jobs server script (Inferred: Low)
- `./fsn_jobs/taxi/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/taxi/server.lua` — server — fsn_jobs server script (Inferred: Low)
- `./fsn_jobs/tow/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/tow/server.lua` — server — fsn_jobs server script (Inferred: Low)
- `./fsn_jobs/trucker/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/whitelists/client.lua` — client — fsn_jobs client script (Inferred: Low)
- `./fsn_jobs/whitelists/server.lua` — server — fsn_jobs server script (Inferred: Low)
- `./fsn_licenses/cl_desk.lua` — client — fsn_licenses client script (Inferred: Low)
- `./fsn_licenses/client.lua` — client — fsn_licenses client script (Inferred: Low)
- `./fsn_licenses/fxmanifest.lua` — shared — fsn_licenses shared script (Inferred: Low)
- `./fsn_licenses/server.lua` — server — fsn_licenses server script (Inferred: Low)
- `./fsn_licenses/sv_desk.lua` — server — fsn_licenses server script (Inferred: Low)
- `./fsn_loadingscreen/fxmanifest.lua` — shared — fsn_loadingscreen shared script (Inferred: Low)
- `./fsn_loadingscreen/index.html` — NUI — fsn_loadingscreen NUI asset (Inferred: Low)
- `./fsn_main/banmanager/sv_bans.lua` — server — fsn_main server script (Inferred: Low)
- `./fsn_main/cl_utils.lua` — client — fsn_main client script (Inferred: Low)
- `./fsn_main/debug/cl_subframetime.js` — client — fsn_main client script (Inferred: Low)
- `./fsn_main/debug/sh_debug.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/debug/sh_scheduler.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/fxmanifest.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/gui/index.html` — NUI — fsn_main NUI asset (Inferred: Low)
- `./fsn_main/gui/index.js` — NUI — fsn_main NUI asset (Inferred: Low)
- `./fsn_main/hud/client.lua` — client — fsn_main client script (Inferred: Low)
- `./fsn_main/initial/client.lua` — client — fsn_main client script (Inferred: Low)
- `./fsn_main/initial/server.lua` — server — fsn_main server script (Inferred: Low)
- `./fsn_main/misc/db.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/misc/logging.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/misc/servername.lua` — server — fsn_main server script (Inferred: Low)
- `./fsn_main/misc/shitlordjumping.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/misc/timer.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/misc/version.lua` — shared — fsn_main shared script (Inferred: Low)
- `./fsn_main/money/client.lua` — client — fsn_main client script (Inferred: Low)
- `./fsn_main/money/server.lua` — server — fsn_main server script (Inferred: Low)
- `./fsn_main/playermanager/client.lua` — client — fsn_main client script (Inferred: Low)
- `./fsn_main/playermanager/server.lua` — server — fsn_main server script (Inferred: Low)
- `./fsn_main/server_settings/sh_settings.lua` — server — fsn_main server script (Inferred: Low)
- `./fsn_main/sv_utils.lua` — server — fsn_main server script (Inferred: Low)
- `./fsn_menu/fxmanifest.lua` — shared — fsn_menu shared script (Inferred: Low)
- `./fsn_menu/gui/ui.css` — NUI — fsn_menu NUI asset (Inferred: Low)
- `./fsn_menu/gui/ui.html` — NUI — fsn_menu NUI asset (Inferred: Low)
- `./fsn_menu/gui/ui.js` — NUI — fsn_menu NUI asset (Inferred: Low)
- `./fsn_menu/main_client.lua` — client — fsn_menu client script (Inferred: Low)
- `./fsn_menu/ui.css` — NUI — fsn_menu NUI asset (Inferred: Low)
- `./fsn_menu/ui.html` — NUI — fsn_menu NUI asset (Inferred: Low)
- `./fsn_menu/ui.js` — shared — fsn_menu shared script (Inferred: Low)
- `./fsn_needs/client.lua` — client — fsn_needs client script (Inferred: Low)
- `./fsn_needs/fxmanifest.lua` — shared — fsn_needs shared script (Inferred: Low)
- `./fsn_needs/hud.lua` — shared — fsn_needs shared script (Inferred: Low)
- `./fsn_needs/vending.lua` — shared — fsn_needs shared script (Inferred: Low)
- `./fsn_newchat/cl_chat.lua` — client — fsn_newchat client script (Inferred: Low)
- `./fsn_newchat/fxmanifest.lua` — shared — fsn_newchat shared script (Inferred: Low)
- `./fsn_newchat/html/App.js` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/Message.js` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/Suggestions.js` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/config.default.js` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/index.css` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/index.html` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/vendor/animate.3.5.2.min.css` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/vendor/latofonts.css` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/html/vendor/vue.2.3.3.min.js` — NUI — fsn_newchat NUI asset (Inferred: Low)
- `./fsn_newchat/sv_chat.lua` — server — fsn_newchat server script (Inferred: Low)
- `./fsn_notify/cl_notify.lua` — client — fsn_notify client script (Inferred: Low)
- `./fsn_notify/fxmanifest.lua` — shared — fsn_notify shared script (Inferred: Low)
- `./fsn_notify/html/index.html` — NUI — fsn_notify NUI asset (Inferred: Low)
- `./fsn_notify/html/noty.css` — NUI — fsn_notify NUI asset (Inferred: Low)
- `./fsn_notify/html/noty.js` — NUI — fsn_notify NUI asset (Inferred: Low)
- `./fsn_notify/html/pNotify.js` — NUI — fsn_notify NUI asset (Inferred: Low)
- `./fsn_notify/html/themes.css` — NUI — fsn_notify NUI asset (Inferred: Low)
- `./fsn_notify/server.lua` — server — fsn_notify server script (Inferred: Low)
- `./fsn_phones/cl_phone.lua` — client — fsn_phones client script (Inferred: Low)
- `./fsn_phones/darkweb/cl_order.lua` — client — fsn_phones client script (Inferred: Low)
- `./fsn_phones/fxmanifest.lua` — shared — fsn_phones shared script (Inferred: Low)
- `./fsn_phones/html/index.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/index.html` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/index.js` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/adverts.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/call.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/contacts.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/darkweb.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/email.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/fleeca.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/garage.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/home.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/main.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/messages.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/pay.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/phone.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/twitter.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/iphone/whitelists.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/adverts.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/call.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/contacts.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/email.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/fleeca.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/home.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/main.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/messages.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/pay.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/phone.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/twitter.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/html/pages_css/samsung/whitelists.css` — NUI — fsn_phones NUI asset (Inferred: Low)
- `./fsn_phones/sv_phone.lua` — server — fsn_phones server script (Inferred: Low)
- `./fsn_playerlist/client.lua` — client — fsn_playerlist client script (Inferred: Low)
- `./fsn_playerlist/fxmanifest.lua` — shared — fsn_playerlist shared script (Inferred: Low)
- `./fsn_playerlist/gui/index.html` — NUI — fsn_playerlist NUI asset (Inferred: Low)
- `./fsn_playerlist/gui/index.js` — NUI — fsn_playerlist NUI asset (Inferred: Low)
- `./fsn_police/K9/client.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/K9/server.lua` — server — fsn_police server script (Inferred: Low)
- `./fsn_police/MDT/gui/index.css` — NUI — fsn_police NUI asset (Inferred: Low)
- `./fsn_police/MDT/gui/index.html` — NUI — fsn_police NUI asset (Inferred: Low)
- `./fsn_police/MDT/gui/index.js` — NUI — fsn_police NUI asset (Inferred: Low)
- `./fsn_police/MDT/mdt_client.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/MDT/mdt_server.lua` — server — fsn_police server script (Inferred: Low)
- `./fsn_police/armory/cl_armory.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/armory/sv_armory.lua` — server — fsn_police server script (Inferred: Low)
- `./fsn_police/client.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/dispatch.lua` — shared — fsn_police shared script (Inferred: Low)
- `./fsn_police/dispatch/client.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/fxmanifest.lua` — shared — fsn_police shared script (Inferred: Low)
- `./fsn_police/pedmanagement/client.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/pedmanagement/server.lua` — server — fsn_police server script (Inferred: Low)
- `./fsn_police/radar/client.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/server.lua` — server — fsn_police server script (Inferred: Low)
- `./fsn_police/tackle/client.lua` — client — fsn_police client script (Inferred: Low)
- `./fsn_police/tackle/server.lua` — server — fsn_police server script (Inferred: Low)
- `./fsn_priority/administration.lua` — shared — fsn_priority shared script (Inferred: Low)
- `./fsn_priority/fxmanifest.lua` — shared — fsn_priority shared script (Inferred: Low)
- `./fsn_priority/server.lua` — server — fsn_priority server script (Inferred: Low)
- `./fsn_progress/client.lua` — client — fsn_progress client script (Inferred: Low)
- `./fsn_progress/fxmanifest.lua` — shared — fsn_progress shared script (Inferred: Low)
- `./fsn_progress/gui/index.html` — NUI — fsn_progress NUI asset (Inferred: Low)
- `./fsn_progress/gui/index.js` — NUI — fsn_progress NUI asset (Inferred: Low)
- `./fsn_properties/cl_manage.lua` — client — fsn_properties client script (Inferred: Low)
- `./fsn_properties/cl_properties.lua` — client — fsn_properties client script (Inferred: Low)
- `./fsn_properties/fxmanifest.lua` — shared — fsn_properties shared script (Inferred: Low)
- `./fsn_properties/nui/ui.css` — NUI — fsn_properties NUI asset (Inferred: Low)
- `./fsn_properties/nui/ui.html` — NUI — fsn_properties NUI asset (Inferred: Low)
- `./fsn_properties/nui/ui.js` — NUI — fsn_properties NUI asset (Inferred: Low)
- `./fsn_properties/sv_conversion.lua` — server — fsn_properties server script (Inferred: Low)
- `./fsn_properties/sv_properties.lua` — server — fsn_properties server script (Inferred: Low)
- `./fsn_shootingrange/client.lua` — client — fsn_shootingrange client script (Inferred: Low)
- `./fsn_shootingrange/fxmanifest.lua` — shared — fsn_shootingrange shared script (Inferred: Low)
- `./fsn_shootingrange/server.lua` — server — fsn_shootingrange server script (Inferred: Low)
- `./fsn_spawnmanager/client.lua` — client — fsn_spawnmanager client script (Inferred: Low)
- `./fsn_spawnmanager/fxmanifest.lua` — shared — fsn_spawnmanager shared script (Inferred: Low)
- `./fsn_spawnmanager/nui/index.css` — NUI — fsn_spawnmanager NUI asset (Inferred: Low)
- `./fsn_spawnmanager/nui/index.html` — NUI — fsn_spawnmanager NUI asset (Inferred: Low)
- `./fsn_spawnmanager/nui/index.js` — NUI — fsn_spawnmanager NUI asset (Inferred: Low)
- `./fsn_steamlogin/client.lua` — client — fsn_steamlogin client script (Inferred: Low)
- `./fsn_steamlogin/fxmanifest.lua` — shared — fsn_steamlogin shared script (Inferred: Low)
- `./fsn_storagelockers/client.lua` — client — fsn_storagelockers client script (Inferred: Low)
- `./fsn_storagelockers/fxmanifest.lua` — shared — fsn_storagelockers shared script (Inferred: Low)
- `./fsn_storagelockers/nui/ui.css` — NUI — fsn_storagelockers NUI asset (Inferred: Low)
- `./fsn_storagelockers/nui/ui.html` — NUI — fsn_storagelockers NUI asset (Inferred: Low)
- `./fsn_storagelockers/nui/ui.js` — NUI — fsn_storagelockers NUI asset (Inferred: Low)
- `./fsn_storagelockers/server.lua` — server — fsn_storagelockers server script (Inferred: Low)
- `./fsn_store/client.lua` — client — fsn_store client script (Inferred: Low)
- `./fsn_store/fxmanifest.lua` — shared — fsn_store shared script (Inferred: Low)
- `./fsn_store/server.lua` — server — fsn_store server script (Inferred: Low)
- `./fsn_store_guns/client.lua` — client — fsn_store_guns client script (Inferred: Low)
- `./fsn_store_guns/fxmanifest.lua` — shared — fsn_store_guns shared script (Inferred: Low)
- `./fsn_store_guns/server.lua` — server — fsn_store_guns server script (Inferred: Low)
- `./fsn_stripclub/client.lua` — client — fsn_stripclub client script (Inferred: Low)
- `./fsn_stripclub/fxmanifest.lua` — shared — fsn_stripclub shared script (Inferred: Low)
- `./fsn_stripclub/server.lua` — server — fsn_stripclub server script (Inferred: Low)
- `./fsn_teleporters/client.lua` — client — fsn_teleporters client script (Inferred: Low)
- `./fsn_teleporters/fxmanifest.lua` — shared — fsn_teleporters shared script (Inferred: Low)
- `./fsn_timeandweather/client.lua` — client — fsn_timeandweather client script (Inferred: Low)
- `./fsn_timeandweather/fxmanifest.lua` — shared — fsn_timeandweather shared script (Inferred: Low)
- `./fsn_timeandweather/server.lua` — server — fsn_timeandweather server script (Inferred: Low)
- `./fsn_vehiclecontrol/aircontrol/aircontrol.lua` — shared — fsn_vehiclecontrol shared script (Inferred: Low)
- `./fsn_vehiclecontrol/carhud/carhud.lua` — shared — fsn_vehiclecontrol shared script (Inferred: Low)
- `./fsn_vehiclecontrol/carwash/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/compass/compass.lua` — shared — fsn_vehiclecontrol shared script (Inferred: Low)
- `./fsn_vehiclecontrol/compass/essentials.lua` — shared — fsn_vehiclecontrol shared script (Inferred: Low)
- `./fsn_vehiclecontrol/compass/streetname.lua` — shared — fsn_vehiclecontrol shared script (Inferred: Low)
- `./fsn_vehiclecontrol/damage/cl_crashes.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/damage/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/damage/config.lua` — shared — fsn_vehiclecontrol shared script (Inferred: Low)
- `./fsn_vehiclecontrol/engine/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/fuel/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/fuel/server.lua` — server — fsn_vehiclecontrol server script (Inferred: Low)
- `./fsn_vehiclecontrol/fxmanifest.lua` — shared — fsn_vehiclecontrol shared script (Inferred: Low)
- `./fsn_vehiclecontrol/holdup/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/inventory/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/inventory/server.lua` — server — fsn_vehiclecontrol server script (Inferred: Low)
- `./fsn_vehiclecontrol/keys/server.lua` — server — fsn_vehiclecontrol server script (Inferred: Low)
- `./fsn_vehiclecontrol/odometer/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/odometer/server.lua` — server — fsn_vehiclecontrol server script (Inferred: Low)
- `./fsn_vehiclecontrol/speedcameras/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/trunk/client.lua` — client — fsn_vehiclecontrol client script (Inferred: Low)
- `./fsn_vehiclecontrol/trunk/server.lua` — server — fsn_vehiclecontrol server script (Inferred: Low)
- `./fsn_voicecontrol/client.lua` — client — fsn_voicecontrol client script (Inferred: Low)
- `./fsn_voicecontrol/fxmanifest.lua` — shared — fsn_voicecontrol shared script (Inferred: Low)
- `./fsn_voicecontrol/server.lua` — server — fsn_voicecontrol server script (Inferred: Low)
- `./fsn_weaponcontrol/client.lua` — client — fsn_weaponcontrol client script (Inferred: Low)
- `./fsn_weaponcontrol/fxmanifest.lua` — shared — fsn_weaponcontrol shared script (Inferred: Low)
- `./fsn_weaponcontrol/server.lua` — server — fsn_weaponcontrol server script (Inferred: Low)
- `./pipeline.yml` — shared — pipeline.yml shared script (Inferred: Low)

## Events
321236ce-42a6-43d8-af3d-e0e30c9e66b7
394084c7-ac07-424a-982b-ab2267d8d55f
AnimSet:Alien
AnimSet:Brave
AnimSet:Business
AnimSet:ChiChi
AnimSet:Hobo
AnimSet:Hurry
AnimSet:Injured
AnimSet:Joy
AnimSet:ManEater
AnimSet:Money
AnimSet:Moon
AnimSet:NonChalant
AnimSet:Posh
AnimSet:Sad
AnimSet:Sassy
AnimSet:Sexy
AnimSet:Shady
AnimSet:Swagger
AnimSet:Tipsy
AnimSet:Tired
AnimSet:ToughGuy
AnimSet:default
Cam:ToggleCam
EngineToggle:Engine
EngineToggle:RPDamage
Mic:ToggleMic
Tackle:Client:TacklePlayer
Tackle:Server:TacklePlayer
__cfx_internal:commandFallback
__cfx_internal:serverPrint
_chat:messageEntered
binoculars:Activate
camera:Activate
chat:addMessage
chat:addSuggestion
chat:addSuggestions
chat:addTemplate
chat:clear
chat:init
chat:removeSuggestion
chatMessage
clothes:firstspawn
clothes:spawn
fsn:playerReady
fsn_admin:FreezeMe
fsn_admin:enableAdminCommands
fsn_admin:enableModeratorCommands
fsn_admin:fix
fsn_admin:recieveXYZ
fsn_admin:requestXYZ
fsn_admin:sendXYZ
fsn_admin:spawnCar
fsn_admin:spawnVehicle
fsn_apartments:characterCreation
fsn_apartments:createApartment
fsn_apartments:getApartment
fsn_apartments:instance:debug
fsn_apartments:instance:join
fsn_apartments:instance:leave
fsn_apartments:instance:new
fsn_apartments:instance:update
fsn_apartments:inv:update
fsn_apartments:outfit:add
fsn_apartments:outfit:list
fsn_apartments:outfit:remove
fsn_apartments:outfit:use
fsn_apartments:saveApartment
fsn_apartments:sendApartment
fsn_apartments:stash:add
fsn_apartments:stash:take
fsn_bank:change:bankAdd
fsn_bank:change:bankMinus
fsn_bank:change:bankandwallet
fsn_bank:change:walletAdd
fsn_bank:change:walletMinus
fsn_bank:database:update
fsn_bank:request:both
fsn_bank:transfer
fsn_bank:update:both
fsn_bankrobbery:LostMC:spawn
fsn_bankrobbery:closeDoor
fsn_bankrobbery:desks:doorUnlock
fsn_bankrobbery:desks:endHack
fsn_bankrobbery:desks:receive
fsn_bankrobbery:desks:request
fsn_bankrobbery:desks:startHack
fsn_bankrobbery:init
fsn_bankrobbery:openDoor
fsn_bankrobbery:payout
fsn_bankrobbery:start
fsn_bankrobbery:timer
fsn_bankrobbery:vault:close
fsn_bankrobbery:vault:open
fsn_boatshop:floor:ChangeBoat
fsn_boatshop:floor:Request
fsn_boatshop:floor:Update
fsn_boatshop:floor:Updateboat
fsn_boatshop:floor:color:One
fsn_boatshop:floor:color:Two
fsn_boatshop:floor:commission
fsn_cargarage:buyVehicle
fsn_cargarage:checkStatus
fsn_cargarage:impound
fsn_cargarage:makeMine
fsn_cargarage:receiveVehicles
fsn_cargarage:requestVehicles
fsn_cargarage:reset
fsn_cargarage:updateVehicle
fsn_cargarage:vehicle:toggleStatus
fsn_cargarage:vehicleStatus
fsn_carstore:floor:ChangeCar
fsn_carstore:floor:Request
fsn_carstore:floor:Update
fsn_carstore:floor:UpdateCar
fsn_carstore:floor:color:One
fsn_carstore:floor:color:Two
fsn_carstore:floor:commission
fsn_characterdetails:recievetattoos
fsn_clothing:menu
fsn_clothing:requestDefault
fsn_clothing:save
fsn_commands:airlift
fsn_commands:clothing:glasses
fsn_commands:clothing:hat
fsn_commands:clothing:mask
fsn_commands:dev:fix
fsn_commands:dev:spawnCar
fsn_commands:dev:weapon
fsn_commands:dropweapon
fsn_commands:ems:adamage:inspect
fsn_commands:getHDC
fsn_commands:hc:takephone
fsn_commands:me
fsn_commands:me:3d
fsn_commands:police:boot
fsn_commands:police:booted
fsn_commands:police:car
fsn_commands:police:cpic:trigger
fsn_commands:police:extra
fsn_commands:police:extras
fsn_commands:police:fix
fsn_commands:police:gsrMe
fsn_commands:police:gsrResult
fsn_commands:police:impound
fsn_commands:police:impound2
fsn_commands:police:livery
fsn_commands:police:lock
fsn_commands:police:pedcarry
fsn_commands:police:pedrevive
fsn_commands:police:rifle
fsn_commands:police:shotgun
fsn_commands:police:towMark
fsn_commands:police:unboot
fsn_commands:police:unbooted
fsn_commands:police:updateBoot
fsn_commands:printxyz
fsn_commands:requestHDC
fsn_commands:sendxyz
fsn_commands:service:addPing
fsn_commands:service:pingAccept
fsn_commands:service:pingStart
fsn_commands:service:request
fsn_commands:service:sendrequest
fsn_commands:vehdoor:close
fsn_commands:vehdoor:open
fsn_commands:walk:set
fsn_commands:window
fsn_criminalmisc:drugs:effects:cocaine
fsn_criminalmisc:drugs:effects:meth
fsn_criminalmisc:drugs:effects:smokeCigarette
fsn_criminalmisc:drugs:effects:weed
fsn_criminalmisc:drugs:streetselling:radio
fsn_criminalmisc:drugs:streetselling:request
fsn_criminalmisc:drugs:streetselling:send
fsn_criminalmisc:handcuffs:requestCuff
fsn_criminalmisc:handcuffs:requestunCuff
fsn_criminalmisc:handcuffs:startCuffed
fsn_criminalmisc:handcuffs:startCuffing
fsn_criminalmisc:handcuffs:startunCuffed
fsn_criminalmisc:handcuffs:startunCuffing
fsn_criminalmisc:handcuffs:toggleEscort
fsn_criminalmisc:houserobbery:try
fsn_criminalmisc:lockpicking
fsn_criminalmisc:racing:createRace
fsn_criminalmisc:racing:joinRace
fsn_criminalmisc:racing:newRace
fsn_criminalmisc:racing:putmeinrace
fsn_criminalmisc:racing:update
fsn_criminalmisc:racing:win
fsn_criminalmisc:robbing:startRobbing
fsn_criminalmisc:toggleDrag
fsn_criminalmisc:weapons:add
fsn_criminalmisc:weapons:add:police
fsn_criminalmisc:weapons:add:tbl
fsn_criminalmisc:weapons:add:unknown
fsn_criminalmisc:weapons:addDrop
fsn_criminalmisc:weapons:destroy
fsn_criminalmisc:weapons:drop
fsn_criminalmisc:weapons:equip
fsn_criminalmisc:weapons:info
fsn_criminalmisc:weapons:pickup
fsn_criminalmisc:weapons:updateDropped
fsn_dev:debug
fsn_developer:deleteVehicle
fsn_developer:enableDeveloperCommands
fsn_developer:fixVehicle
fsn_developer:getKeys
fsn_developer:noClip:enabled
fsn_developer:printXYZ
fsn_developer:sendXYZ
fsn_developer:spawnVehicle
fsn_doj:court:remandMe
fsn_doj:judge:spawnCar
fsn_doj:judge:toggleLock
fsn_doormanager:doorLocked
fsn_doormanager:doorUnlocked
fsn_doormanager:lockDoor
fsn_doormanager:request
fsn_doormanager:requestDoors
fsn_doormanager:sendDoors
fsn_doormanager:toggle
fsn_doormanager:unlockDoor
fsn_emotecontrol:dice:roll
fsn_emotecontrol:phone:call1
fsn_emotecontrol:play
fsn_emotecontrol:police:tablet
fsn_emotecontrol:police:ticket
fsn_ems:911
fsn_ems:911r
fsn_ems:ad:stopBleeding
fsn_ems:adamage:request
fsn_ems:bed:health
fsn_ems:bed:leave
fsn_ems:bed:occupy
fsn_ems:bed:restraintoggle
fsn_ems:bed:update
fsn_ems:carried:end
fsn_ems:carried:start
fsn_ems:carry:end
fsn_ems:carry:start
fsn_ems:killMe
fsn_ems:offDuty
fsn_ems:onDuty
fsn_ems:requestUpdate
fsn_ems:reviveMe
fsn_ems:reviveMe:force
fsn_ems:set:WalkType
fsn_ems:update
fsn_ems:updateLevel
fsn_evidence:collect
fsn_evidence:destroy
fsn_evidence:display
fsn_evidence:drop:blood
fsn_evidence:drop:casing
fsn_evidence:ped:addState
fsn_evidence:ped:update
fsn_evidence:ped:updateDamage
fsn_evidence:receive
fsn_evidence:request
fsn_evidence:weaponInfo
fsn_fuel:set
fsn_fuel:update
fsn_gangs:garage:enter
fsn_gangs:hideout:enter
fsn_gangs:hideout:leave
fsn_gangs:inventory:request
fsn_gangs:recieve
fsn_gangs:request
fsn_gangs:tryTakeOver
fsn_garages:vehicle:update
fsn_hungerandthirst:pause
fsn_hungerandthirst:unpause
fsn_inventory:apt:recieve
fsn_inventory:buyItem
fsn_inventory:database:update
fsn_inventory:drops:collect
fsn_inventory:drops:drop
fsn_inventory:drops:request
fsn_inventory:drops:send
fsn_inventory:empty
fsn_inventory:floor:update
fsn_inventory:gasDoorunlock
fsn_inventory:gui:display
fsn_inventory:init
fsn_inventory:initChar
fsn_inventory:item:add
fsn_inventory:item:drop
fsn_inventory:item:dropped
fsn_inventory:item:give
fsn_inventory:item:take
fsn_inventory:item:use
fsn_inventory:itemhasdropped
fsn_inventory:itempickup
fsn_inventory:items:add
fsn_inventory:items:addPreset
fsn_inventory:items:emptyinv
fsn_inventory:locker:empty
fsn_inventory:locker:request
fsn_inventory:locker:save
fsn_inventory:me:update
fsn_inventory:pd_locker:recieve
fsn_inventory:ply:done
fsn_inventory:ply:finished
fsn_inventory:ply:recieve
fsn_inventory:ply:request
fsn_inventory:ply:update
fsn_inventory:police_armory:recieve
fsn_inventory:prebuy
fsn_inventory:prop:recieve
fsn_inventory:rebreather:use
fsn_inventory:recieveItems
fsn_inventory:removedropped
fsn_inventory:sendItems
fsn_inventory:sendItemsToArmory
fsn_inventory:sendItemsToStore
fsn_inventory:store:recieve
fsn_inventory:store_gun:recieve
fsn_inventory:sys:request
fsn_inventory:sys:send
fsn_inventory:update
fsn_inventory:use:drink
fsn_inventory:use:food
fsn_inventory:useAmmo
fsn_inventory:useArmor
fsn_inventory:veh:finished
fsn_inventory:veh:glovebox
fsn_inventory:veh:glovebox:recieve
fsn_inventory:veh:request
fsn_inventory:veh:trunk:recieve
fsn_inventory:veh:update
fsn_jail:init
fsn_jail:releaseme
fsn_jail:sendme
fsn_jail:sendsuspect
fsn_jail:spawn
fsn_jail:spawn:recieve
fsn_jail:update:database
fsn_jewellerystore:case:rob
fsn_jewellerystore:case:startrob
fsn_jewellerystore:cases:request
fsn_jewellerystore:cases:update
fsn_jewellerystore:doors:Lock
fsn_jewellerystore:doors:State
fsn_jewellerystore:gasDoor:toggle
fsn_jobs:ems:request
fsn_jobs:mechanic:toggle
fsn_jobs:mechanic:toggleduty
fsn_jobs:news:role:Set
fsn_jobs:paycheck
fsn_jobs:quit
fsn_jobs:taxi:accepted
fsn_jobs:taxi:request
fsn_jobs:tow:mark
fsn_jobs:tow:marked
fsn_jobs:tow:request
fsn_jobs:whitelist:access:add
fsn_jobs:whitelist:add
fsn_jobs:whitelist:clock:in
fsn_jobs:whitelist:clock:out
fsn_jobs:whitelist:remove
fsn_jobs:whitelist:request
fsn_jobs:whitelist:update
fsn_licenses:chat
fsn_licenses:check
fsn_licenses:display
fsn_licenses:giveID
fsn_licenses:id:display
fsn_licenses:id:request
fsn_licenses:infraction
fsn_licenses:police:give
fsn_licenses:setinfractions
fsn_licenses:showid
fsn_licenses:update
fsn_main:blip:add
fsn_main:blip:clear
fsn_main:charMenu
fsn_main:character
fsn_main:characterSaving
fsn_main:createCharacter
fsn_main:displayBankandMoney
fsn_main:getCharacter
fsn_main:gui:bank:change
fsn_main:gui:both:display
fsn_main:gui:money:change
fsn_main:initiateCharacter
fsn_main:logging:addLog
fsn_main:money:bank:Add
fsn_main:money:bank:Minus
fsn_main:money:bank:Set
fsn_main:money:initChar
fsn_main:money:update
fsn_main:money:updateSilent
fsn_main:money:wallet:Add
fsn_main:money:wallet:GiveCash
fsn_main:money:wallet:Minus
fsn_main:money:wallet:Set
fsn_main:requestCharacters
fsn_main:saveCharacter
fsn_main:sendCharacters
fsn_main:update:myCharacter
fsn_main:updateCharNumber
fsn_main:updateCharacters
fsn_main:validatePlayer
fsn_menu:requestInventory
fsn_needs:stress:add
fsn_needs:stress:remove
fsn_notify:displayNotification
fsn_odometer:addMileage
fsn_odometer:getMileage
fsn_odometer:resetMileage
fsn_odometer:setMileage
fsn_phones:GUI:notification
fsn_phones:SYS:addCall
fsn_phones:SYS:addTransaction
fsn_phones:SYS:newNumber
fsn_phones:SYS:receiveGarage
fsn_phones:SYS:recieve:details
fsn_phones:SYS:request:details
fsn_phones:SYS:requestGarage
fsn_phones:SYS:sendTweet
fsn_phones:SYS:set:details
fsn_phones:SYS:updateAdverts
fsn_phones:SYS:updateNumber
fsn_phones:USE:Email
fsn_phones:USE:Message
fsn_phones:USE:Phone
fsn_phones:USE:Tweet
fsn_phones:USE:darkweb:order
fsn_phones:USE:requestAdverts
fsn_phones:USE:sendAdvert
fsn_phones:USE:sendMessage
fsn_phones:UTIL:chat
fsn_phones:UTIL:displayNumber
fsn_police:911
fsn_police:911r
fsn_police:GetInVehicle
fsn_police:MDT:receivewarrants
fsn_police:MDT:requestwarrants
fsn_police:MDT:toggle
fsn_police:MDT:vehicledetails
fsn_police:MDT:warrant
fsn_police:MDTremovewarrant
fsn_police:Sit
fsn_police:ToggleK9
fsn_police:armory:boughtOne
fsn_police:armory:closedArmory
fsn_police:armory:recieveItemsForArmory
fsn_police:armory:request
fsn_police:chat:ticket
fsn_police:command:duty
fsn_police:cuffs:requestCuff
fsn_police:cuffs:requestunCuff
fsn_police:cuffs:startCuffed
fsn_police:cuffs:startCuffing
fsn_police:cuffs:startunCuffed
fsn_police:cuffs:startunCuffing
fsn_police:cuffs:toggleEscort
fsn_police:cuffs:toggleHard
fsn_police:database:CPIC
fsn_police:database:CPIC:search
fsn_police:database:CPIC:search:result
fsn_police:dispatch
fsn_police:dispatch:toggle
fsn_police:dispatchcall
fsn_police:init
fsn_police:k9:search:person:end
fsn_police:k9:search:person:finish
fsn_police:k9:search:person:me
fsn_police:offDuty
fsn_police:onDuty
fsn_police:pd:toggleDrag
fsn_police:ply:toggleDrag
fsn_police:putMeInVeh
fsn_police:radar:toggle
fsn_police:requestUpdate
fsn_police:runplate
fsn_police:runplate::target
fsn_police:runplate:target
fsn_police:search:end:inventory
fsn_police:search:end:money
fsn_police:search:end:weapons
fsn_police:search:start:inventory
fsn_police:search:start:money
fsn_police:search:start:weapons
fsn_police:search:strip
fsn_police:ticket
fsn_police:toggleHandcuffs
fsn_police:update
fsn_police:updateLevel
fsn_properties:access
fsn_properties:buy
fsn_properties:inv:closed
fsn_properties:inv:update
fsn_properties:keys:give
fsn_properties:leave
fsn_properties:menu:access:allow
fsn_properties:menu:access:revoke
fsn_properties:menu:access:view
fsn_properties:menu:inventory:deposit
fsn_properties:menu:inventory:take
fsn_properties:menu:money:deposit
fsn_properties:menu:money:withdraw
fsn_properties:menu:police:breach
fsn_properties:menu:police:empty
fsn_properties:menu:police:search
fsn_properties:menu:police:seize
fsn_properties:menu:rent:check
fsn_properties:menu:rent:pay
fsn_properties:menu:robbery
fsn_properties:menu:weapon:deposit
fsn_properties:menu:weapon:take
fsn_properties:realator:clock
fsn_properties:rent:check
fsn_properties:rent:pay
fsn_properties:request
fsn_properties:updateXYZ
fsn_spawnmanager:start
fsn_store:boughtOne
fsn_store:closedStore
fsn_store:recieveItemsForStore
fsn_store:request
fsn_store_guns:boughtOne
fsn_store_guns:closedStore
fsn_store_guns:request
fsn_stripclub:client:update
fsn_teleporters:teleport:coordinates
fsn_teleporters:teleport:waypoint
fsn_timeandweather:notify
fsn_timeandweather:requestSync
fsn_timeandweather:updateTime
fsn_timeandweather:updateWeather
fsn_vehiclecontrol:damage:repair
fsn_vehiclecontrol:damage:repairkit
fsn_vehiclecontrol:flagged:add
fsn_vehiclecontrol:getKeys
fsn_vehiclecontrol:giveKeys
fsn_vehiclecontrol:givekeys
fsn_vehiclecontrol:keys:carjack
fsn_vehiclecontrol:trunk:forceIn
fsn_vehiclecontrol:trunk:forceOut
fsn_voicecontrol:call:answer
fsn_voicecontrol:call:decline
fsn_voicecontrol:call:end
fsn_voicecontrol:call:hold
fsn_voicecontrol:call:ring
fsn_voicecontrol:call:unhold
fsn_yoga:checkStress
jTow:afford
jTow:mark
mythic_hospital:client:FieldTreatBleed
mythic_hospital:client:FieldTreatLimbs
mythic_hospital:client:ReduceBleed
mythic_hospital:client:RemoveBleed
mythic_hospital:client:ResetLimbs
mythic_hospital:client:SyncBleed
mythic_hospital:client:UseAdrenaline
mythic_hospital:client:UsePainKiller
pNotify:SendNotification
pNotify:SetQueueMax
safecracking:loop
safecracking:start
spawnme
tow:CAD:tow
## Commands
addmoney
adminmenu
amenu
announce
ban
blackout
bring
carryplayer
ce
debug
dv
evening
evi_clothing
fixveh
freeze
freezetime
freezeweather
fsn_debug
getkeys
giveitem
goto
insidedebug
inv
kick
kill
mdt
morning
night
noclip
noon
pdduty
revive
reviveplayer
say
sc
setinfractions
softlog
spawnveh
testanimation
time
tpc
tpm
tuner
vehinspect
vehrepair
weather
xyz
## Exports
EnumerateObjects
GetVehicleInventory
IsDoorLocked
SendNotification
SetQueueMax
carryingWho
ems_isBleeding
fsn_Airlift
fsn_CanCarry
fsn_CharID
fsn_EMSDuty
fsn_GetBank
fsn_GetCharacterInfo
fsn_GetItemAmount
fsn_GetItemDetails
fsn_GetPlayerFromCharacterId
fsn_GetPlayerFromPhoneNumber
fsn_GetPlayerPhoneNumber
fsn_GetWallet
fsn_HasItem
fsn_IsDead
fsn_PDDuty
fsn_getCopAmt
fsn_getEMSLevel
fsn_getIllegalItems
fsn_getLicensePoints
fsn_getPDLevel
fsn_hasLicense
fsn_itemStock
getJacket
getObjects
getPants
getPedNearCoords
getPeds
getPickups
getSex
getTime
getTop
getVehicles
isCrouching
isPlayerClockedInWhitelist
sub_frame_time
## NUI Callbacks
ButtonClick
booking-submit-now
booking-submit-warrant
callContact
camToLoc
chatResult
closeGUI
closeMDT
closePhone
createCharacter
depositMoney
dragToSlot
dropSlot
escape
loaded
mdt-remove-warrant
mdt-request-warrants
messageactive
messageinactive
removeContact
rentBike
sendToServer
setWaypoint
spawnAtLoc
spawnCharacter
toggleGUI
toggleWhitelist
transferMoney
updateAddContact
useSlot
viewData
weaponEquip
weaponInfo
whitelistUser
withdrawMoney
## Database Tables
fsn_apartments
fsn_characters
fsn_properties
fsn_tickets
fsn_users
fsn_vehicles
fsn_warrants
fsn_whitelists

## Gaps & Inferences
- File descriptions rely on directory and filename context; function-level behavior requires deeper review (Inferred: Low).
- Event payloads, permissions, and flows could not be conclusively derived without tracing callsites. Additional runtime observation is recommended (TODO).
- Database schema details and constraints are inferred from table names only; structure not verified (Inferred: Low).

DOCS COMPLETE
