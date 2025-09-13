# Example_Frameworks Documentation

This document indexes the Example_Frameworks/ directory to guide development of a new FiveM framework. It is updated incrementally with directory structure, functions, events, and native currency checks.

## Scan Stamp & Inventory Overview

TREE-SCAN-STAMP — 2025-09-13T00:25:12+00:00 — dirs:783 files:14434

| Folder | Resources | Files | Server Files | Client Files | Shared Files |
| --- | --- | --- | --- | --- | --- |
| FiveM-FSN-Framework | 58 | 723 | 75 | 124 | 3 |
| ND_Core-main | 1 | 43 | 8 | 11 | 1 |
| NoPixelServer | 192 | 13412 | 111 | 290 | 13 |
| cfx-server-data | 24 | 117 | 11 | 12 | 2 |
| es_extended | 1 | 50 | 6 | 8 | 0 |
| essentialmode | 2 | 20 | 7 | 2 | 0 |
| qb-core | 1 | 84 | 7 | 5 | 8 |
| vRP | 1 | 179 | 0 | 18 | 0 |
| vorp_core-lua | 1 | 65 | 20 | 17 | 0 |

## FULL DIRECTORY TREE

### FiveM-FSN-Framework

```
Example_Frameworks/FiveM-FSN-Framework
Example_Frameworks/FiveM-FSN-Framework/.gitignore
Example_Frameworks/FiveM-FSN-Framework/README.md
Example_Frameworks/FiveM-FSN-Framework/agents.md
Example_Frameworks/FiveM-FSN-Framework/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_activities
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga
Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_activities_docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_admin
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server
Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.html
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/gui/ui.js
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bank
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/gui/atm_button_sound.mp3
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/gui/atm_logo.png
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/gui/index.css
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/gui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/gui/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_bank/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/cl_frontdesks.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/cl_safeanim.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/sv_frontdesks.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bankrobbery/trucks.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bennys
Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_bennys.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/cl_config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bennys/menu.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/cursor.png
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/script.js
Example_Frameworks/FiveM-FSN-Framework/fsn_bikerental/html/style.css
Example_Frameworks/FiveM-FSN-Framework/fsn_boatshop
Example_Frameworks/FiveM-FSN-Framework/fsn_boatshop/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_boatshop/cl_boatshop.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_boatshop/config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_boatshop/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_boatshop/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_boatshop/sv_boatshop.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_builders
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/docs.md
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/handling_builder.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/schema.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/schemas
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/schemas/cbikehandlingdata.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/schemas/ccarhandlingdata.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/schemas/chandlingdata.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_builders/xml.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/gui/ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/gui/ui.html
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/gui/ui.js
Example_Frameworks/FiveM-FSN-Framework/fsn_cargarage/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/cl_carstore.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/cl_menu.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/gui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/sv_carstore.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_carstore/vehshop_server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/gui/ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/gui/ui.html
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/gui/ui.js
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/gui_manager.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/tattoos
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/tattoos/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_characterdetails/tattoos/config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing/config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing/gui.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing/models.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_clothing/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_commands
Example_Frameworks/FiveM-FSN-Framework/fsn_commands/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_commands/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_commands/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_commands/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/nui
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/nui/index.css
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/nui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/nui/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_crafting/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/drugs
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/drugs/_effects
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/drugs/_effects/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/drugs/_streetselling
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/drugs/_streetselling/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/drugs/_streetselling/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/handcuffs
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/handcuffs/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/handcuffs/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/lockpicking
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/lockpicking/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/pawnstore
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/pawnstore/cl_pawnstore.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/remapping
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/remapping/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/remapping/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/robbing
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/robbing/cl_houses-build.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/robbing/cl_houses-config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/robbing/cl_houses.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/robbing/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/streetracing
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/streetracing/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/streetracing/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/weaponinfo
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/weaponinfo/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/weaponinfo/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_criminalmisc/weaponinfo/weapon_list.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_customanimations
Example_Frameworks/FiveM-FSN-Framework/fsn_customanimations/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_customanimations/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_customanimations/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_customs
Example_Frameworks/FiveM-FSN-Framework/fsn_customs/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_customs/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_customs/lscustoms.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_dev
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/client
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/client/cl_noclip.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/client/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/server
Example_Frameworks/FiveM-FSN-Framework/fsn_dev/server/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doj
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/attorneys
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/attorneys/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/attorneys/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/judges
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/judges/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doj/judges/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doormanager
Example_Frameworks/FiveM-FSN-Framework/fsn_doormanager/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_doormanager/cl_doors.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doormanager/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_doormanager/sv_doors.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_emotecontrol
Example_Frameworks/FiveM-FSN-Framework/fsn_emotecontrol/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_emotecontrol/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_emotecontrol/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_emotecontrol/walktypes
Example_Frameworks/FiveM-FSN-Framework/fsn_emotecontrol/walktypes/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/beds
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/beds/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/beds/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/blip.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/cl_advanceddamage.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/cl_carrydead.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/cl_volunteering.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/debug_kng.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/info.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_ems/sv_carrydead.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_entfinder
Example_Frameworks/FiveM-FSN-Framework/fsn_entfinder/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_entfinder/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_entfinder/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_errorcontrol
Example_Frameworks/FiveM-FSN-Framework/fsn_errorcontrol/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_errorcontrol/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_errorcontrol/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/__descriptions-carpaint.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/__descriptions-female.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/__descriptions-male.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/__descriptions.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/casings
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/casings/cl_casings.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/cl_evidence.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/ped
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/ped/cl_ped.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/ped/sv_ped.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_evidence/sv_evidence.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_gangs
Example_Frameworks/FiveM-FSN-Framework/fsn_gangs/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_gangs/cl_gangs.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_gangs/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_gangs/sv_gangs.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/data
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/data/handling.meta
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/compact.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/coupes.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/government.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/motorcycles.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/muscle.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/offroad.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/schafter.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/sedans.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/sports.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/sportsclassics.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/super.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/suvs.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_handling/src/vans.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_item_misc
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_item_misc/binoculars.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_item_misc/burger_store.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_item_misc/cl_breather.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_item_misc/dm_laundering.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_old
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_old/_item_misc
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_old/_item_misc/_drug_selling.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_old/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_old/items.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_old/pedfinder.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/_old/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/cl_inventory.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/cl_presets.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/cl_uses.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/cl_vehicles.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/css
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/css/jquery-ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/css/ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/bullet.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/2g_weed.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_ADVANCEDRIFLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_APPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_ASSAULTSHOTGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_ASSAULTSMG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_AUTOSHOTGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_BALL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_BAT.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_BATTLEAXE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_BOTTLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_BULLPUPSHOTGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_CARBINERIFLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_CARBINERIFLE_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_COMBATMG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_COMBATMG_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_COMBATPDW.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_COMBATPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_COMPACTLAUNCHER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_COMPACTRIFLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_CROWBAR.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_DAGGER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_DBSHOTGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_DOUBLEACTION.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_FIREEXTINGUISHER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_FIREWORK.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_FLARE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_FLAREGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_FLASHLIGHT.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_GOLFCLUB.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_GRENADE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_GRENADELAUNCHER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_GUSENBERG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_HAMMER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_HATCHET.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_HEAVYPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_HEAVYSHOTGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_HOMINGLAUNCHER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_KNIFE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_KNUCKLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MACHETE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MACHINEPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MARKSMANPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MICROSMG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MINIGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MINISMG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MOLOTOV.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_MUSKET.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_NIGHTSTICK.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PETROLCAN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PIPEBOMB.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PISTOL50.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PISTOL_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_POOLCUE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PROXMINE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_RAILGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_RAYCARBINE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_RAYMINIGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_RAYPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_REVOLVER.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_REVOLVER_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_RPG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SAWNOFFSHOTGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SMG.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SMG_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SMOKEGRENADE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SNIPERRIFLE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SNOWBALL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SNSPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SNSPISTOL_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE_MK2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_STICKYBOMB.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_STONE_HATCHET.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_STUNGUN.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_SWITCHBLADE.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_VINTAGEPISTOL.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/WEAPON_WRENCH.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/acetone.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_mg.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_mg_large.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_pistol.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_pistol_large.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_rifle.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_rifle_large.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_shotgun.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_shotgun_large.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_smg.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_smg_large.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_sniper.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ammo_sniper_large.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/armor.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/bandage.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/beef_jerky.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/binoculars.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/burger.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/burger_bun.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/cigarette.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/coffee.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/cooked_burger.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/cooked_meat.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/cupcake.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/dirty_money.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/drill.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/ecola.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/empty_canister.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/evidence.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/fries.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/frozen_burger.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/frozen_fries.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/gas_canister.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/id.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/joint.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/keycard.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/lockpick.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/meth_rocks.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/microwave_burrito.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/minced_meat.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/modified_drillbit.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/morphine.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/packaged_cocaine.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/painkillers.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/panini.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/pepsi.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/pepsi_max.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/phone.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/phosphorus.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/radio_receiver.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/repair_kit.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/tuner_chip.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/uncooked_meat.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/vpn1.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/vpn2.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/water.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/img/items/zipties.png
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/js
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/js/config.js
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/js/inventory.js
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/locales
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/locales/cs.js
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/locales/en.js
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/locales/fr.js
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/html/ui.html
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/pd_locker
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/pd_locker/cl_locker.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/pd_locker/datastore.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/pd_locker/sv_locker.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/sv_inventory.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/sv_presets.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory/sv_vehicles.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory_dropping
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory_dropping/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory_dropping/cl_dropping.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory_dropping/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_inventory_dropping/sv_dropping.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jail
Example_Frameworks/FiveM-FSN-Framework/fsn_jail/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_jail/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jail/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jail/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jewellerystore
Example_Frameworks/FiveM-FSN-Framework/fsn_jewellerystore/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_jewellerystore/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jewellerystore/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jewellerystore/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/delivery
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/delivery/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/farming
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/farming/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/garbage
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/garbage/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/hunting
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/hunting/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/mechanic
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/mechanic/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/mechanic/mechmenu.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/mechanic/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/news
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/news/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/repo
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/repo/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/repo/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/scrap
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/scrap/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/taxi
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/taxi/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/taxi/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/tow
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/tow/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/tow/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/trucker
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/trucker/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/whitelists
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/whitelists/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_jobs/whitelists/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_licenses
Example_Frameworks/FiveM-FSN-Framework/fsn_licenses/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_licenses/cl_desk.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_licenses/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_licenses/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_licenses/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_licenses/sv_desk.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_loadingscreen
Example_Frameworks/FiveM-FSN-Framework/fsn_loadingscreen/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_loadingscreen/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_loadingscreen/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_main
Example_Frameworks/FiveM-FSN-Framework/fsn_main/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_main/banmanager
Example_Frameworks/FiveM-FSN-Framework/fsn_main/banmanager/sv_bans.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/cl_utils.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/debug
Example_Frameworks/FiveM-FSN-Framework/fsn_main/debug/cl_subframetime.js
Example_Frameworks/FiveM-FSN-Framework/fsn_main/debug/sh_debug.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/debug/sh_scheduler.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/logo_new.png
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/logo_old.png
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/logos
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/logos/discord.png
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/logos/discord.psd
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/logos/logo.png
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/logos/main.psd
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/motd.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_main/gui/pdown.ttf
Example_Frameworks/FiveM-FSN-Framework/fsn_main/hud
Example_Frameworks/FiveM-FSN-Framework/fsn_main/hud/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/initial
Example_Frameworks/FiveM-FSN-Framework/fsn_main/initial/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/initial/desc.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_main/initial/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/misc
Example_Frameworks/FiveM-FSN-Framework/fsn_main/misc/db.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/misc/logging.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/misc/servername.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/misc/shitlordjumping.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/misc/timer.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/misc/version.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/money
Example_Frameworks/FiveM-FSN-Framework/fsn_main/money/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/money/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/playermanager
Example_Frameworks/FiveM-FSN-Framework/fsn_main/playermanager/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/playermanager/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/server_settings
Example_Frameworks/FiveM-FSN-Framework/fsn_main/server_settings/sh_settings.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_main/sv_utils.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_menu
Example_Frameworks/FiveM-FSN-Framework/fsn_menu/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_menu/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_menu/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_menu/gui/ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_menu/gui/ui.html
Example_Frameworks/FiveM-FSN-Framework/fsn_menu/gui/ui.js
Example_Frameworks/FiveM-FSN-Framework/fsn_menu/main_client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_needs
Example_Frameworks/FiveM-FSN-Framework/fsn_needs/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_needs/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_needs/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_needs/hud.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_needs/vending.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/README.md
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/cl_chat.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/App.js
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/config.default.js
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/config.js
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/index.css
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/animate.3.5.2.min.css
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/fonts
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/fonts/LatoBold.woff2
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/fonts/LatoBold2.woff2
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/fonts/LatoLight.woff2
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/fonts/LatoLight2.woff2
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/fonts/LatoRegular.woff2
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/fonts/LatoRegular2.woff2
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/html/vendor/latofonts.css
Example_Frameworks/FiveM-FSN-Framework/fsn_newchat/sv_chat.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_notify
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/cl_notify.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/html
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/html/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/html/noty.css
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/html/noty.js
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/html/noty_license.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/html/pNotify.js
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/html/themes.css
Example_Frameworks/FiveM-FSN-Framework/fsn_notify/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_phones
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/cl_phone.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/darkweb
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/darkweb/cl_order.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/datastore
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/datastore/contacts
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/datastore/contacts/sample.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/datastore/messages
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/datastore/messages/sample.txt
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Ads.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Banner
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Banner/Adverts.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Banner/Grey.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Banner/Yellow.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Banner/fleeca.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Banner/log-inBackground.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Contact.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Fleeca.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Frame.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Garage.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Lock icon.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Mail.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Messages.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Noti.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Phone.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Twitter.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Wallet.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/Whitelist.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/adverts.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/call.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/contacts.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/fleeca.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/garage.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/mail.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/messages.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/twitter.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/wallet.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/banner_icons/wl.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/battery.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/call-in.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/call-out.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/darkweb.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/default-avatar.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/feedgrey.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/fleeca-bg.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/missed-in.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/missed-out.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/node_other_server__1247323.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/signal.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/wallpaper.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/Apple/wifi.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/img/cursor.png
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/index.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/index.html.old
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/adverts.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/call.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/contacts.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/darkweb.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/email.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/fleeca.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/garage.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/home.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/main.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/messages.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/pay.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/phone.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/twitter.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/iphone/whitelists.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/adverts.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/call.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/contacts.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/email.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/fleeca.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/home.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/main.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/messages.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/pay.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/phone.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/twitter.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/html/pages_css/samsung/whitelists.css
Example_Frameworks/FiveM-FSN-Framework/fsn_phones/sv_phone.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_playerlist
Example_Frameworks/FiveM-FSN-Framework/fsn_playerlist/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_playerlist/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_playerlist/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_playerlist/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_playerlist/gui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_playerlist/gui/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_police
Example_Frameworks/FiveM-FSN-Framework/fsn_police/K9
Example_Frameworks/FiveM-FSN-Framework/fsn_police/K9/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/K9/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/background.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/base_pc.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/icons
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/icons/booking.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/icons/cpic.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/icons/dmv.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/icons/warrants.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/pwr_icon.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/images/win_icon.png
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/index.css
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/gui/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/mdt_client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/MDT/mdt_server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_police/armory
Example_Frameworks/FiveM-FSN-Framework/fsn_police/armory/cl_armory.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/armory/sv_armory.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/dispatch
Example_Frameworks/FiveM-FSN-Framework/fsn_police/dispatch.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/dispatch/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/pedmanagement
Example_Frameworks/FiveM-FSN-Framework/fsn_police/pedmanagement/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/pedmanagement/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/radar
Example_Frameworks/FiveM-FSN-Framework/fsn_police/radar/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/tackle
Example_Frameworks/FiveM-FSN-Framework/fsn_police/tackle/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_police/tackle/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_priority
Example_Frameworks/FiveM-FSN-Framework/fsn_priority/administration.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_priority/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_priority/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_priority/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_progress
Example_Frameworks/FiveM-FSN-Framework/fsn_progress/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_progress/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_progress/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_progress/gui
Example_Frameworks/FiveM-FSN-Framework/fsn_progress/gui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_progress/gui/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_properties
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/cl_manage.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/cl_properties.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/nui
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/nui/ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/nui/ui.html
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/nui/ui.js
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/sv_conversion.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_properties/sv_properties.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_shootingrange
Example_Frameworks/FiveM-FSN-Framework/fsn_shootingrange/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_shootingrange/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_shootingrange/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_shootingrange/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager/nui
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager/nui/index.css
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager/nui/index.html
Example_Frameworks/FiveM-FSN-Framework/fsn_spawnmanager/nui/index.js
Example_Frameworks/FiveM-FSN-Framework/fsn_steamlogin
Example_Frameworks/FiveM-FSN-Framework/fsn_steamlogin/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_steamlogin/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_steamlogin/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_steamlogin/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/nui
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/nui/ui.css
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/nui/ui.html
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/nui/ui.js
Example_Frameworks/FiveM-FSN-Framework/fsn_storagelockers/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_store
Example_Frameworks/FiveM-FSN-Framework/fsn_store/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_store/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_store/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_store/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_store_guns
Example_Frameworks/FiveM-FSN-Framework/fsn_store_guns/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_store_guns/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_store_guns/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_store_guns/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_stripclub
Example_Frameworks/FiveM-FSN-Framework/fsn_stripclub/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_stripclub/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_stripclub/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_stripclub/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_teleporters
Example_Frameworks/FiveM-FSN-Framework/fsn_teleporters/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_teleporters/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_teleporters/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/timecycle_mods_4.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_blizzard.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_clear.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_clearing.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_clouds.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_extrasunny.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_foggy.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_neutral.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_overcast.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_rain.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_smog.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_snow.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_snowlight.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_thunder.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_timeandweather/w_xmas.xml
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/aircontrol
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/aircontrol/aircontrol.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/carhud
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/carhud/carhud.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/carwash
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/carwash/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/compass
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/compass/compass.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/compass/essentials.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/compass/streetname.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/damage
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/damage/cl_crashes.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/damage/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/damage/config.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/engine
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/engine/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/fuel
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/fuel/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/fuel/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/holdup
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/holdup/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/inventory
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/inventory/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/inventory/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/keys
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/keys/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/odometer
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/odometer/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/odometer/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/speedcameras
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/speedcameras/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/trunk
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/trunk/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_vehiclecontrol/trunk/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_voicecontrol
Example_Frameworks/FiveM-FSN-Framework/fsn_voicecontrol/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_voicecontrol/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_voicecontrol/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_voicecontrol/server.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_weaponcontrol
Example_Frameworks/FiveM-FSN-Framework/fsn_weaponcontrol/agents.md
Example_Frameworks/FiveM-FSN-Framework/fsn_weaponcontrol/client.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_weaponcontrol/fxmanifest.lua
Example_Frameworks/FiveM-FSN-Framework/fsn_weaponcontrol/server.lua
Example_Frameworks/FiveM-FSN-Framework/pipeline.yml
```

## Processing Ledger

| Scope | Total | Done | Remaining | Last Updated |
| --- | --- | --- | --- | --- |
| File Enumeration | 14434 | 735 | 13699 | 2025-09-13 |
| Function Extraction | 28 | 28 | 0 | 2025-09-13 |
| Event Extraction | 28 | 28 | 0 | 2025-09-13 |
| Native Currency Checks | 86 | 86 | 0 | 2025-09-13 |
| Similarity Merges | 2 | 2 | 0 | 2025-09-13 |

## Function & Event Registry

### 5.1 Methodology & Classification
- Classification derives from `fxmanifest.lua` declarations and file path conventions (e.g., `client/`, `server/`, `shared/`).
- Events detected via patterns like `RegisterNetEvent`, `AddEventHandler`, `TriggerClientEvent`, and `TriggerServerEvent`.

### 5.2 Consolidated Index

#### Functions
- [cancelFishing](#cancelfishing)
- [cancelHunt](#cancelhunt)
- [cancelYoga](#cancelyoga)
- [createBlips](#createblips)
- [getAdminName](#getadminname)
- [EnterMyApartment](#entermyapartment)
- [EnterRoom](#enterroom)
- [fsn_closeATM](#fsn_closeatm)
- [fsn_drawText3D](#fsn_drawtext3d)
- [getAvailableAppt](#getavailableappt)
- [getModeratorName](#getmoderatorname)
- [getNearestSpot](#getnearestspot)
- [getSteamIdentifier](#getsteamidentifier)
- [inInstance](#ininstance)
- [isAdmin](#isadmin)
- [isModerator](#ismoderator)
- [isNearStorage](#isnearstorage)
- [nearPos](#nearpos)
- [registerAdminCommands](#registeradmincommands)
- [registerAdminSuggestions](#registeradminsuggestions)
- [registerModeratorCommands](#registermoderatorcommands)
- [registerModeratorSuggestions](#registermoderatorsuggestions)
- [saveApartment](#saveapartment)
- [spawnAnimal](#spawnanimal)
- [startFishing](#startfishing)
- [startHunt](#starthunt)
- [startYoga](#startyoga)
- [table.contains](#tablecontains)
- [ToggleActionMenu](#toggleactionmenu)

#### Events
- [chat:addMessage](#chataddmessage)
- [depositMoney](#depositmoney)
- [fsn_admin:FreezeMe](#fsn_adminfreezeme)
- [fsn_admin:enableAdminCommands](#fsn_adminenableadmincommands)
- [fsn_admin:enableModeratorCommands](#fsn_adminenablemoderatorcommands)
- [fsn_admin:receiveXYZ](#fsn_adminreceivexyz)
- [fsn_admin:requestXYZ](#fsn_adminrequestxyz)
- [fsn_admin:sendXYZ](#fsn_adminsendxyz)
- [fsn_admin:spawnVehicle](#fsn_adminspawnvehicle)
- [fsn_apartments:characterCreation](#fsn_apartmentscharactercreation)
- [fsn_apartments:instance:debug](#fsn_apartmentsinstancedebug)
- [fsn_apartments:instance:join](#fsn_apartmentsinstancejoin)
- [fsn_apartments:instance:leave](#fsn_apartmentsinstanceleave)
- [fsn_apartments:instance:update](#fsn_apartmentsinstanceupdate)
- [fsn_apartments:inv:update](#fsn_apartmentsinvupdate)
- [fsn_apartments:outfit:add](#fsn_apartmentsoutfitadd)
- [fsn_apartments:sendApartment](#fsn_apartmentssendapartment)
- [fsn_apartments:stash:add](#fsn_apartmentsstashadd)
- [fsn_apartments:stash:take](#fsn_apartmentsstashtake)
- [fsn_bank:change:bankAdd](#fsn_bankchangebankadd)
- [fsn_bank:change:bankMinus](#fsn_bankchangebankminus)
- [fsn_bank:update:both](#fsn_bankupdateboth)
- [fsn_cargarage:makeMine](#fsn_cargaragemakemine)
- [fsn_needs:stress:remove](#fsn_needsstressremove)
- [fsn_notify:displayNotification](#fsn_notifydisplaynotification)
- [fsn_yoga:checkStress](#fsn_yogacheckstress)
- [fsn:playerReady](#fsnplayerready)

### 5.3 Functions — Detailed Entries

#### createBlips
- **Name**: createBlips
- **Type**: Client
- **Defined In**:
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (47-60)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (46-59)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (48-61)
- **Signature(s)**: `createBlips()`
- **Purpose**: Generates map blips for activity locations.
- **Key Flows**:
  - Loops configured blip table and sets properties.
- **Natives Used**:
  - AddBlipForCoord — OK
  - SetBlipHighDetail — OK
  - SetBlipSprite — OK
  - SetBlipDisplay — OK
  - SetBlipScale — OK
  - SetBlipColour — OK
  - SetBlipAsShortRange — OK
  - BeginTextCommandSetBlipName — OK
  - AddTextComponentString — OK
  - EndTextCommandSetBlipName — OK
- **OneSync / Networking Notes**: Client-only blip creation; purely visual.
- **Examples**:
```lua
-- Create activity blips on resource start
CreateThread(function()
    createBlips()
end)
```
- **Security / Anti-Abuse**: Static data; no inputs.
- **References**:
  - https://docs.fivem.net/natives/

#### getNearestSpot
- **Name**: getNearestSpot
- **Type**: Client
- **Defined In**:
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (69-79)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (70-80)
- **Signature(s)**: `getNearestSpot(playerPos)`
- **Purpose**: Returns closest predefined activity position.
- **Key Flows**:
  - Iterates configured vectors; tracks nearest.
- **Natives Used**: none.
- **OneSync / Networking Notes**: Local computation only.
- **Examples**:
```lua
local dist, pos = getNearestSpot(GetEntityCoords(PlayerPedId()))
```
- **Security / Anti-Abuse**: relies on trusted client data.
- **References**:
  - https://docs.fivem.net/docs/

#### cancelFishing
- **Name**: cancelFishing
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (88-95)
- **Signature(s)**: `cancelFishing(ped)`
- **Purpose**: Stops fishing scenario and resets state.
- **Key Flows**:
  - Sends HUD note, clears ped tasks, resets flags.
- **Natives Used**:
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Client-only; no server notification.
- **Examples**:
```lua
if IsControlJustPressed(0, fishEndKey) then
    cancelFishing(PlayerPedId())
end
```
- **Security / Anti-Abuse**: none; affects local ped.
- **References**:
  - https://docs.fivem.net/natives/

#### startFishing
- **Name**: startFishing
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (104-112)
- **Signature(s)**: `startFishing(ped)`
- **Purpose**: Plays fishing scenario and rewards fish.
- **Key Flows**:
  - Notifies user, starts scenario, waits random time, clears tasks.
- **Natives Used**:
  - TaskStartScenarioInPlace — OK
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Outcome not synced; server unaware.
- **Examples**:
```lua
fishing = true
startFishing(PlayerPedId())
fishing = false
```
- **Security / Anti-Abuse**: Local-only reward; vulnerable to client manipulation.
- **References**:
  - https://docs.fivem.net/natives/

#### spawnAnimal
- **Name**: spawnAnimal
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (68-76)
- **Signature(s)**: `spawnAnimal(ped)`
- **Purpose**: Spawns roaming deer ahead of player.
- **Key Flows**:
  - Requests model, waits for load, creates ped, sets wander behavior.
- **Natives Used**:
  - GetHashKey — OK
  - RequestModel — OK
  - HasModelLoaded — OK
  - GetOffsetFromEntityInWorldCoords — OK
  - CreatePed — OK
  - TaskWanderStandard — OK
  - SetEntityAsMissionEntity — OK
- **OneSync / Networking Notes**: Spawned entity exists only client-side.
- **Examples**:
```lua
spawnAnimal(PlayerPedId())
```
- **Security / Anti-Abuse**: Clients can spawn peds freely; no validation.
- **References**:
  - https://docs.fivem.net/natives/

#### cancelHunt
- **Name**: cancelHunt
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (85-91)
- **Signature(s)**: `cancelHunt()`
- **Purpose**: Cancels hunting session and removes animal.
- **Key Flows**:
  - Sends HUD note, deletes spawned entity.
- **Natives Used**:
  - DoesEntityExist — OK
  - DeleteEntity — OK
- **OneSync / Networking Notes**: Local cleanup; server not informed.
- **Examples**:
```lua
if IsControlJustPressed(0, huntEndKey) then
    cancelHunt()
end
```
- **Security / Anti-Abuse**: Local-only; no safeguards.
- **References**:
  - https://docs.fivem.net/natives/

#### startHunt
- **Name**: startHunt
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (100-104)
- **Signature(s)**: `startHunt(ped)`
- **Purpose**: Begins hunt by spawning target and setting state.
- **Key Flows**:
  - Notifies user and calls `spawnAnimal`.
- **Natives Used**: none.
- **OneSync / Networking Notes**: No server sync; purely client.
- **Examples**:
```lua
if IsControlJustPressed(0, huntStartKey) then
    startHunt(PlayerPedId())
end
```
- **Security / Anti-Abuse**: No validation; client decides start.
- **References**:
  - https://docs.fivem.net/docs/

#### cancelYoga
- **Name**: cancelYoga
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (89-93)
- **Signature(s)**: `cancelYoga(ped)`
- **Purpose**: Aborts yoga scenario.
- **Key Flows**:
  - Notifies user, clears ped task, resets flag.
- **Natives Used**:
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Local only.
- **Examples**:
```lua
cancelYoga(PlayerPedId())
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/natives/

#### startYoga
- **Name**: startYoga
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (102-109)
- **Signature(s)**: `startYoga(ped)`
- **Purpose**: Runs yoga scenario and triggers stress relief.
- **Key Flows**:
  - Shows message, waits, starts scenario, after 15s triggers `fsn_yoga:checkStress` and clears task.
- **Natives Used**:
  - TaskStartScenarioInPlace — OK
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Stress removal performed client-side; not validated server-side.
- **Examples**:
```lua
doingYoga = true
startYoga(PlayerPedId())
```
- **Security / Anti-Abuse**: Client can fake completion; no server check.
- **References**:
  - https://docs.fivem.net/natives/

#### getSteamIdentifier
- **Name**: getSteamIdentifier
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (32-38)
- **Signature(s)**: `getSteamIdentifier(src)`
- **Purpose**: Returns the Steam identifier for a player.
- **Key Flows**:
  - Iterates identifiers from `GetPlayerIdentifiers` and selects the `steam:` entry.
- **Natives Used**:
  - GetPlayerIdentifiers — OK
- **OneSync / Networking Notes**: depends on identifiers provided at connect time.
- **Examples**:
```lua
local steam = getSteamIdentifier(source)
```
- **Security / Anti-Abuse**: returns `nil` if no Steam identifier is present.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayeridentifiers

#### isModerator
- **Name**: isModerator
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (41-50)
- **Signature(s)**: `isModerator(src)`
- **Purpose**: Checks if a player's Steam ID is in the moderator list.
- **Key Flows**:
  - Uses `getSteamIdentifier` to resolve Steam ID.
- **Natives Used**: none
- **OneSync / Networking Notes**: relies on client identifiers; spoofing requires Steam override.
- **Examples**:
```lua
if isModerator(source) then
  -- allow staff action
end
```
- **Security / Anti-Abuse**: list is static; ensure Config.Moderators is secure.
- **References**:
  - https://docs.fivem.net/docs/

#### isAdmin
- **Name**: isAdmin
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (52-60)
- **Signature(s)**: `isAdmin(src)`
- **Purpose**: Validates if a player is an administrator.
- **Key Flows**:
  - Compares Steam ID against `Config.Admins`.
- **Natives Used**: none
- **OneSync / Networking Notes**: same trust considerations as `isModerator`.
- **Examples**:
```lua
if isAdmin(source) then
  registerAdminCommands()
end
```
- **Security / Anti-Abuse**: ensure Config.Admins is restricted.
- **References**:
  - https://docs.fivem.net/docs/

#### getModeratorName
- **Name**: getModeratorName
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (63-65)
- **Signature(s)**: `getModeratorName(src)`
- **Purpose**: Retrieves a moderator's display name.
- **Key Flows**:
  - Wrapper around `GetPlayerName`.
- **Natives Used**:
  - GetPlayerName — OK
- **OneSync / Networking Notes**: name reflects current session.
- **Examples**:
```lua
local name = getModeratorName(source)
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayername

#### getAdminName
- **Name**: getAdminName
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (67-69)
- **Signature(s)**: `getAdminName(src)`
- **Purpose**: Retrieves an administrator's display name.
- **Key Flows**:
  - Calls `GetPlayerName` directly.
- **Natives Used**:
  - GetPlayerName — OK
- **OneSync / Networking Notes**: name is session-scoped.
- **Examples**:
```lua
local admin = getAdminName(source)
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayername

#### registerModeratorCommands
- **Name**: registerModeratorCommands
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (71-85)
- **Signature(s)**: `registerModeratorCommands()`
- **Purpose**: Registers staff chat for moderators.
- **Key Flows**:
  - Adds `/sc` command that broadcasts to other moderators.
- **Natives Used**:
  - RegisterCommand — OK
  - GetPlayers — OK
  - TriggerClientEvent — OK
- **OneSync / Networking Notes**: uses server command routing; messages only sent to moderators.
- **Examples**:
```lua
registerModeratorCommands()
```
- **Security / Anti-Abuse**: command validates caller is moderator.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#registercommand
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayers
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### registerAdminCommands
- **Name**: registerAdminCommands
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (87-255)
- **Signature(s)**: `registerAdminCommands()`
- **Purpose**: Registers administrative commands (chat, menus, teleport, moderation).
- **Key Flows**:
  - Adds `/sc`, `/adminmenu`, `/amenu`, `/freeze`, `/announce`, `/goto`, `/bring`, `/kick`, and `/ban`.
- **Natives Used**:
  - RegisterCommand — OK
  - GetPlayers — OK
  - TriggerClientEvent — OK
  - DropPlayer — OK
- **OneSync / Networking Notes**: commands perform server authority actions like teleporting and kicking.
- **Examples**:
```lua
registerAdminCommands()
```
- **Security / Anti-Abuse**: every command checks `isAdmin` and validates inputs.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#registercommand
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#dropplayer

#### registerModeratorSuggestions
- **Name**: registerModeratorSuggestions
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (258-264)
- **Signature(s)**: `registerModeratorSuggestions(source)`
- **Purpose**: Adds chat suggestions for moderator commands.
- **Key Flows**:
  - Sends `chat:addSuggestion` for `/sc`.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Networking Notes**: suggestion sent only if caller is moderator.
- **Examples**:
```lua
registerModeratorSuggestions(source)
```
- **Security / Anti-Abuse**: verifies `isModerator` before sending.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### registerAdminSuggestions
- **Name**: registerAdminSuggestions
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (266-292)
- **Signature(s)**: `registerAdminSuggestions(source)`
- **Purpose**: Adds chat suggestions for admin commands.
- **Key Flows**:
  - Provides `/sc`, `/adminmenu`, `/amenu`, `/freeze`, `/goto`, `/bring`, `/kick`, `/ban` suggestions.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Networking Notes**: suggestions only sent to admins.
- **Examples**:
```lua
registerAdminSuggestions(source)
```
- **Security / Anti-Abuse**: validates admin status before sending.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### inInstance
- **Name**: inInstance
- **Type**: Client (Export)
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (8-10)
- **Signature(s)**: `inInstance()`
- **Purpose**: Indicates whether the player is inside an apartment instance.
- **Key Flows**:
  - Returns boolean `instanced` flag.
- **Natives Used**: none
- **OneSync / Networking Notes**: state managed locally; exported for other resources.
- **Examples**:
```lua
if inInstance() then
  -- restrict interactions
end
```
- **Security / Anti-Abuse**: client-controlled; trust cautiously.
- **References**:
  - https://docs.fivem.net/docs/

#### table.contains
- **Name**: table.contains
- **Type**: Shared
- **Defined In**:
  - Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (73-79)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua (64-71)
- **Signature(s)**: `table.contains(tbl, element)`
- **Purpose**: Utility to check if a table contains a value.
- **Key Flows**:
  - Iterates pairs and compares values.
- **Natives Used**: none
- **OneSync / Networking Notes**: none.
- **Examples**:
```lua
if table.contains(myinstance.players, id) then
  -- player is in instance
end
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_drawText3D
- **Name**: fsn_drawText3D
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (4-20)
- **Signature(s)**: `fsn_drawText3D(x, y, z, text)`
- **Purpose**: Renders 3D world text at the given position.
- **Key Flows**:
  - Projects world coordinates to screen space and draws styled text.
- **Natives Used**:
  - World3dToScreen2d — OK
  - SetTextScale — OK
  - SetTextFont — OK
  - SetTextProportional — OK
  - SetTextColour — OK
  - SetTextDropshadow — OK
  - SetTextEdge — OK
  - SetTextDropShadow — OK
  - SetTextOutline — OK
  - SetTextEntry — OK
  - SetTextCentre — OK
  - AddTextComponentString — OK
  - DrawText — OK
- **OneSync / Networking Notes**: client-only rendering.
- **Examples**:
```lua
fsn_drawText3D(storage.x, storage.y, storage.z, 'Storage')
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/natives/

#### nearPos
- **Name**: nearPos
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (26-27)
- **Signature(s)**: `nearPos(pos, radius)`
- **Purpose**: Checks player distance from a coordinate.
- **Key Flows**:
  - Compares `GetEntityCoords(PlayerPedId())` with target position.
- **Natives Used**:
  - GetEntityCoords — OK
- **OneSync / Networking Notes**: client spatial check.
- **Examples**:
```lua
if nearPos(storage, 0.5) then
  -- interact
end
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/natives/?_0x3FEF770D40960D5A

#### EnterMyApartment
- **Name**: EnterMyApartment
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (68-70)
- **Signature(s)**: `EnterMyApartment()`
- **Purpose**: Enters the player into their assigned apartment.
- **Key Flows**:
  - Calls `EnterRoom` with the saved room number.
- **Natives Used**: none
- **OneSync / Networking Notes**: relies on local room state.
- **Examples**:
```lua
EnterMyApartment()
```
- **Security / Anti-Abuse**: ensure room number validated by server.
- **References**:
  - https://docs.fivem.net/docs/

#### EnterRoom
- **Name**: EnterRoom
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (432-442)
- **Signature(s)**: `EnterRoom(id)`
- **Purpose**: Teleports player to the apartment interior and creates an instance.
- **Key Flows**:
  - Fades screen, sets coordinates, triggers server instance creation.
- **Natives Used**:
  - DoScreenFadeOut — OK
  - SetEntityCoords — OK
  - DoScreenFadeIn — OK
  - TriggerServerEvent — OK
  - FreezeEntityPosition — OK
- **OneSync / Networking Notes**: server instance ownership assigned after teleport.
- **Examples**:
```lua
EnterRoom(5)
```
- **Security / Anti-Abuse**: validate `id` before teleport.
- **References**:
  - https://docs.fivem.net/natives/

#### ToggleActionMenu
- **Name**: ToggleActionMenu
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (265-288)
- **Signature(s)**: `ToggleActionMenu()`
- **Purpose**: Opens or closes the apartment storage menu.
- **Key Flows**:
  - Initializes inventory tables and toggles NUI focus.
- **Natives Used**:
  - SetNuiFocus — OK
  - SendNUIMessage — OK
- **OneSync / Networking Notes**: local UI only.
- **Examples**:
```lua
if nearPos(storage,0.5) then ToggleActionMenu() end
```
- **Security / Anti-Abuse**: restrict usage to apartment context.
- **References**:
  - https://docs.fivem.net/docs/

#### isNearStorage
- **Name**: isNearStorage
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (346-347)
- **Signature(s)**: `isNearStorage()`
- **Purpose**: Returns if player is near the apartment storage spot.
- **Key Flows**:
  - Exposes `instorage` state for other resources.
- **Natives Used**: none
- **OneSync / Networking Notes**: state local to client.
- **Examples**:
```lua
if isNearStorage() then ... end
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/

#### saveApartment
- **Name**: saveApartment
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (480-482)
- **Signature(s)**: `saveApartment()`
- **Purpose**: Persists apartment state to the server.
- **Key Flows**:
  - Triggers server save with current apartment details.
- **Natives Used**:
  - TriggerServerEvent — OK
- **OneSync / Networking Notes**: relies on server authority.
- **Examples**:
```lua
saveApartment()
```
- **Security / Anti-Abuse**: server validates data.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_closeATM
- **Name**: fsn_closeATM
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (166-178)
- **Signature(s)**: `fsn_closeATM()`
- **Purpose**: Resets player state after leaving ATM UI.
- **Key Flows**:
  - Unfreezes player, removes focus, hides NUI.
- **Natives Used**:
  - FreezeEntityPosition — OK
  - SetEntityCollision — OK
  - ClearPedTasks — OK
  - SetNuiFocus — OK
  - SendNUIMessage — OK
- **OneSync / Networking Notes**: client local.
- **Examples**:
```lua
fsn_closeATM()
```
- **Security / Anti-Abuse**: prevents stuck state.
- **References**:
  - https://docs.fivem.net/natives/

#### getAvailableAppt
- **Name**: getAvailableAppt
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua (55-67)
- **Signature(s)**: `getAvailableAppt(src)`
- **Purpose**: Finds or assigns an unoccupied apartment slot.
- **Key Flows**:
  - Iterates apartment list; marks slot occupied by `src`.
- **Natives Used**: none
- **OneSync / Networking Notes**: server-only logic.
- **Examples**:
```lua
local id = getAvailableAppt(source)
```
- **Security / Anti-Abuse**: ensures one apartment per source.
- **References**:
  - https://docs.fivem.net/docs/

### 5.4 Events — Detailed Entries

#### chat:addMessage
- **Event**: chat:addMessage
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (78-88)
- **Payload**:
  - template:string
  - args:table
- **Typical Callers / Listeners**: called from admin freeze handler; handled by default chat resource.
- **Natives Used**: none
- **OneSync / Replication Notes**: local UI update only.
- **Examples**:
```lua
TriggerEvent('chat:addMessage', {template = 'Message', args = {}})
```
- **Security / Anti-Abuse**: relies on client; no rate limiting.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_admin:FreezeMe
- **Event**: fsn_admin:FreezeMe
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (74-93)
- **Payload**:
  - adminName:string
- **Typical Callers / Listeners**: Triggered by admin commands; listened by client to toggle freeze.
- **Natives Used**:
  - FreezeEntityPosition — OK
- **OneSync / Replication Notes**: freeze state is client-side; may desync without server checks.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:FreezeMe', targetId, 'Admin')
```
- **Security / Anti-Abuse**: requires server-side permission checks.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_admin:receiveXYZ
- **Event**: fsn_admin:receiveXYZ
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (69-72)
- **Payload**:
  - coords:vector3
- **Typical Callers / Listeners**: server sends coordinates; client teleports.
- **Natives Used**:
  - SetEntityCoords — OK
- **OneSync / Replication Notes**: teleport not validated server-side.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:receiveXYZ', player, GetEntityCoords(PlayerPedId()))
```
- **Security / Anti-Abuse**: ensure server validates sender.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_admin:requestXYZ
- **Event**: fsn_admin:requestXYZ
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (63-67)
- **Payload**:
  - sendto:number
- **Typical Callers / Listeners**: server requests coordinates; client responds via `fsn_admin:sendXYZ`.
- **Natives Used**:
  - GetEntityCoords — OK
- **OneSync / Replication Notes**: coordinate data sent without verification.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:requestXYZ', player, adminId)
```
- **Security / Anti-Abuse**: ensure only authorized admins invoke.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_admin:sendXYZ
- **Event**: fsn_admin:sendXYZ
- **Direction**: Client→Server
- **Type**: NetEvent
 - **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (66); Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (302-305)
- **Payload**:
  - sendto:number
  - coords:vector3
- **Typical Callers / Listeners**: client sends position to server; server teleports or relays.
- **Natives Used**: none
- **OneSync / Replication Notes**: trust boundary from client to server.
- **Examples**:
```lua
TriggerServerEvent('fsn_admin:sendXYZ', target, GetEntityCoords(PlayerPedId()))
```
- **Security / Anti-Abuse**: server must sanitize coordinates and source.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_admin:spawnVehicle
- **Event**: fsn_admin:spawnVehicle
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (39-61)
- **Payload**:
  - vehmodel:string
- **Typical Callers / Listeners**: admin command on server triggers; client spawns and owns vehicle.
- **Natives Used**:
  - PlayerPedId — OK
  - GetEntityCoords — OK
  - GetEntityHeading — OK
  - SetVehicleOnGroundProperly — OK
  - SetVehicleNumberPlateTextIndex — OK
  - SetPedIntoVehicle — OK
  - GetDisplayNameFromVehicleModel — OK
  - GetEntityModel — OK
  - GetVehicleNumberPlateText — OK
- **OneSync / Replication Notes**: vehicle ownership handled via subsequent events.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:spawnVehicle', player, 'adder')
```
- **Security / Anti-Abuse**: ensure server restricts usage to admins.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_cargarage:makeMine
- **Event**: fsn_cargarage:makeMine
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (56)
- **Payload**:
  - vehicle:entity
  - name:string
  - plate:string
- **Typical Callers / Listeners**: triggered after vehicle spawn to transfer ownership; listener in cargarage resource.
- **Natives Used**:
  - GetDisplayNameFromVehicleModel — OK
  - GetEntityModel — OK
  - GetVehicleNumberPlateText — OK
- **OneSync / Replication Notes**: relies on client to inform garage.
- **Examples**:
```lua
TriggerEvent('fsn_cargarage:makeMine', veh, model, plate)
```
- **Security / Anti-Abuse**: susceptible to spoofing; validate server-side.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_needs:stress:remove
- **Event**: fsn_needs:stress:remove
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (148)
- **Payload**:
  - amount:number
- **Typical Callers / Listeners**: triggered after yoga to reduce stress; handled by needs system.
- **Natives Used**: none
- **OneSync / Replication Notes**: client-side stat change; vulnerable to manipulation.
- **Examples**:
```lua
TriggerEvent('fsn_needs:stress:remove', 10)
```
- **Security / Anti-Abuse**: server should validate stress removal.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_notify:displayNotification
- **Event**: fsn_notify:displayNotification
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (58-59)
- **Payload**:
  - message:string
  - position:string
  - duration:number
  - style:string
- **Typical Callers / Listeners**: used to show HUD notifications; listener in notify resource.
- **Natives Used**: none
- **OneSync / Replication Notes**: UI only.
- **Examples**:
```lua
TriggerEvent('fsn_notify:displayNotification', 'Hello', 'centerLeft', 2000, 'info')
```
- **Security / Anti-Abuse**: spam risk; rate limit recommended.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_yoga:checkStress
- **Event**: fsn_yoga:checkStress
- **Direction**: Intra-Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (145-153)
- **Payload**: none
- **Typical Callers / Listeners**: triggered after yoga; listener removes stress.
- **Natives Used**: none
- **OneSync / Replication Notes**: not validated server-side.
- **Examples**:
```lua
TriggerEvent('fsn_yoga:checkStress')
```
- **Security / Anti-Abuse**: susceptible to manual triggering.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_admin:enableAdminCommands
- **Event**: fsn_admin:enableAdminCommands
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (307-310)
- **Payload**: `source:number`
- **Typical Callers / Listeners**: triggered when player is ready to provide admin chat suggestions.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Replication Notes**: suggestions sent to a single player.
- **Examples**:
```lua
TriggerEvent('fsn_admin:enableAdminCommands', playerId)
```
- **Security / Anti-Abuse**: only invoke for verified admins.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### fsn_admin:enableModeratorCommands
- **Event**: fsn_admin:enableModeratorCommands
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (312-315)
- **Payload**: `source:number`
- **Typical Callers / Listeners**: enables moderator command suggestions.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Replication Notes**: single-target suggestion dispatch.
- **Examples**:
```lua
TriggerEvent('fsn_admin:enableModeratorCommands', playerId)
```
- **Security / Anti-Abuse**: verify moderator status before calling.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### fsn:playerReady
- **Event**: fsn:playerReady
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (317-327)
- **Payload**: none
- **Typical Callers / Listeners**: client notifies server on spawn; server assigns command suggestions.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: depends on source id; processed after brief delay.
- **Examples**:
```lua
TriggerServerEvent('fsn:playerReady')
```
- **Security / Anti-Abuse**: ensure server checks permissions after trigger.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerevent

#### fsn_apartments:instance:join
- **Event**: fsn_apartments:instance:join
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (51-55)
- **Payload**: `inst:table`
- **Typical Callers / Listeners**: server assigns player to an instance; client sets state.
- **Natives Used**: none
- **OneSync / Replication Notes**: affects local visibility.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:instance:join', function(inst) ... end)
```
- **Security / Anti-Abuse**: server controls membership to prevent spoofing.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:instance:update
- **Event**: fsn_apartments:instance:update
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (57-60)
- **Payload**: `inst:table`
- **Typical Callers / Listeners**: server updates instance player list.
- **Natives Used**: none
- **OneSync / Replication Notes**: provides synchronized instance data.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:instance:update', function(inst) ... end)
```
- **Security / Anti-Abuse**: rely on server authority.
- **References**:
  - https://docs.fivem.net/docs/

#### depositMoney
- **Event**: depositMoney
- **Direction**: NUI→Client
- **Type**: NUI
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (179-213)
- **Payload**: `tbl` {deposit:number, atbank:boolean}
- **Typical Callers / Listeners**: ATM UI posts form data; client validates and updates wallet/bank.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: balance changes synced via follow-up events.
- **Examples**:
```lua
RegisterNUICallback('depositMoney', function(data) ... end)
```
- **Security / Anti-Abuse**: amount capped at $500k and requires bank context.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:characterCreation
- **Event**: fsn_apartments:characterCreation
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (447-469)
- **Payload**: none
- **Typical Callers / Listeners**: server instructs client to begin character creation flow.
- **Natives Used**:
  - TriggerServerEvent — OK
  - SetEntityCoords — OK
- **OneSync / Replication Notes**: player frozen during creation; instance created server-side.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:characterCreation', function() ... end)
```
- **Security / Anti-Abuse**: restricted to new characters.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:inv:update
- **Event**: fsn_apartments:inv:update
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (292-295)
- **Payload**: `tbl:table`
- **Typical Callers / Listeners**: inventory resource sends updated apartment inventory.
- **Natives Used**: none
- **OneSync / Replication Notes**: client-side cache refresh only.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:inv:update', function(t) ... end)
```
- **Security / Anti-Abuse**: trust source resource.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:outfit:add
- **Event**: fsn_apartments:outfit:add (Aliases: fsn_apartments:outfit:use, fsn_apartments:outfit:remove, fsn_apartments:outfit:list)
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (141-190)
- **Payload**: varies (`key:string` or none)
- **Typical Callers / Listeners**: server relays outfit management commands; client updates wardrobe.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: wardrobe state synchronized through server saves.
- **Examples**:
```lua
TriggerEvent('fsn_apartments:outfit:add', 'casual')
```
- **Security / Anti-Abuse**: requires proximity to wardrobe.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:sendApartment
- **Event**: fsn_apartments:sendApartment
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (72-139)
- **Payload**: `tbl` {number:int, apptinfo:table}
- **Typical Callers / Listeners**: server provides apartment data to player after login.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: sets local apartment state.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:sendApartment', function(data) ... end)
```
- **Security / Anti-Abuse**: server validates ownership before send.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:stash:add
- **Event**: fsn_apartments:stash:add
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (30-49)
- **Payload**: `amt:number`
- **Typical Callers / Listeners**: server command deposits cash into apartment stash.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: server persists stash after client update.
- **Examples**:
```lua
TriggerClientEvent('fsn_apartments:stash:add', src, 1000)
```
- **Security / Anti-Abuse**: enforces 150k stash limit and affordability.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:stash:take
- **Event**: fsn_apartments:stash:take
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (51-66)
- **Payload**: `amt:number`
- **Typical Callers / Listeners**: server command withdraws cash from stash.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: stash balance synchronized after withdrawal.
- **Examples**:
```lua
TriggerClientEvent('fsn_apartments:stash:take', src, 500)
```
- **Security / Anti-Abuse**: ensures player has sufficient stash funds.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:update:both
- **Event**: fsn_bank:update:both
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (90-99)
- **Payload**: `wallet:number`, `bank:number`
- **Typical Callers / Listeners**: server sends wallet and bank balances.
- **Natives Used**:
  - SendNUIMessage — OK
- **OneSync / Replication Notes**: keeps client HUD in sync.
- **Examples**:
```lua
TriggerClientEvent('fsn_bank:update:both', src, wallet, bank)
```
- **Security / Anti-Abuse**: values sourced from server database.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:change:bankAdd
- **Event**: fsn_bank:change:bankAdd
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (101-109)
- **Payload**: `amount:number`
- **Typical Callers / Listeners**: server notifies client of bank deposit.
- **Natives Used**:
  - SendNUIMessage — OK
- **OneSync / Replication Notes**: HUD update only.
- **Examples**:
```lua
TriggerClientEvent('fsn_bank:change:bankAdd', src, 200)
```
- **Security / Anti-Abuse**: amounts validated server-side.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:change:bankMinus
- **Event**: fsn_bank:change:bankMinus
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (111-119)
- **Payload**: `amount:number`
- **Typical Callers / Listeners**: server notifies client of bank withdrawal.
- **Natives Used**:
  - SendNUIMessage — OK
- **OneSync / Replication Notes**: HUD update only.
- **Examples**:
```lua
TriggerClientEvent('fsn_bank:change:bankMinus', src, 200)
```
- **Security / Anti-Abuse**: amounts validated server-side.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:instance:leave
- **Event**: fsn_apartments:instance:leave
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (62-66)
- **Payload**: none
- **Typical Callers / Listeners**: server removes player from instance and resets state.
- **Natives Used**: none
- **OneSync / Replication Notes**: resets density multipliers client-side.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:instance:leave', function() instanced=false end)
```
- **Security / Anti-Abuse**: server should validate requester is member.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:instance:debug
- **Event**: fsn_apartments:instance:debug
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (68-70)
- **Payload**: none
- **Typical Callers / Listeners**: toggles instance debug overlay.
- **Natives Used**: none
- **OneSync / Replication Notes**: local visualization only.
- **Examples**:
```lua
TriggerEvent('fsn_apartments:instance:debug')
```
- **Security / Anti-Abuse**: restrict to developers to avoid spam.
- **References**:
  - https://docs.fivem.net/docs/

## Similarity Merge Report
- Canonicalized identical helper functions.
- Merged `createBlips` definitions (fishing, hunting, yoga).
- Merged `getNearestSpot` definitions (fishing, yoga).
- Grouped outfit management events under `fsn_apartments:outfit:add`.
- TODO(next-run): review other activity helpers for consolidation.
- TODO(next-run): reconcile duplicated instance events across client/server.

## Troubleshooting & Profiling Hooks
- TODO(next-run): document recommended debug commands and profiling tools.

## References
- https://docs.fivem.net/docs/
- https://docs.fivem.net/natives/

## PROGRESS MARKERS (EOF)

CONTINUE-HERE — 2025-09-13T00:25:12+00:00 — next: FiveM-FSN-Framework/fsn_apartments/docs.md @ line 1
MERGE-QUEUE — 2025-09-13T00:25:12+00:00 — remaining: 0 (top 5: n/a)
