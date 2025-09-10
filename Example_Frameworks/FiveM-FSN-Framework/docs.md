# FiveM-FSN-Framework Documentation

## Overview
Comprehensive auto-generated documentation for the FSN framework resources.

## Table of Contents
- [.gitignore](#.gitignore)
- [agents.md](#agents.md)
- [pipeline.yml](#pipeline.yml)
- [README.md](#README.md)
- [fsn_stripclub/agents.md](#fsn_stripclubagents.md)
- [fsn_stripclub/client.lua](#fsn_stripclubclient.lua)
- [fsn_stripclub/server.lua](#fsn_stripclubserver.lua)
- [fsn_stripclub/fxmanifest.lua](#fsn_stripclubfxmanifest.lua)
- [fsn_doormanager/agents.md](#fsn_doormanageragents.md)
- [fsn_doormanager/client.lua](#fsn_doormanagerclient.lua)
- [fsn_doormanager/sv_doors.lua](#fsn_doormanagersv_doors.lua)
- [fsn_doormanager/server.lua](#fsn_doormanagerserver.lua)
- [fsn_doormanager/fxmanifest.lua](#fsn_doormanagerfxmanifest.lua)
- [fsn_doormanager/cl_doors.lua](#fsn_doormanagercl_doors.lua)
- [fsn_entfinder/agents.md](#fsn_entfinderagents.md)
- [fsn_entfinder/client.lua](#fsn_entfinderclient.lua)
- [fsn_entfinder/fxmanifest.lua](#fsn_entfinderfxmanifest.lua)
- [fsn_inventory/cl_vehicles.lua](#fsn_inventorycl_vehicles.lua)
- [fsn_inventory/agents.md](#fsn_inventoryagents.md)
- [fsn_inventory/cl_inventory.lua](#fsn_inventorycl_inventory.lua)
- [fsn_inventory/sv_inventory.lua](#fsn_inventorysv_inventory.lua)
- [fsn_inventory/sv_vehicles.lua](#fsn_inventorysv_vehicles.lua)
- [fsn_inventory/fxmanifest.lua](#fsn_inventoryfxmanifest.lua)
- [fsn_inventory/sv_presets.lua](#fsn_inventorysv_presets.lua)
- [fsn_inventory/cl_uses.lua](#fsn_inventorycl_uses.lua)
- [fsn_inventory/cl_presets.lua](#fsn_inventorycl_presets.lua)
- [fsn_inventory/pd_locker/sv_locker.lua](#fsn_inventorypd_lockersv_locker.lua)
- [fsn_inventory/pd_locker/datastore.txt](#fsn_inventorypd_lockerdatastore.txt)
- [fsn_inventory/pd_locker/cl_locker.lua](#fsn_inventorypd_lockercl_locker.lua)
- [fsn_inventory/html/ui.html](#fsn_inventoryhtmlui.html)
- [fsn_inventory/html/js/inventory.js](#fsn_inventoryhtmljsinventory.js)
- [fsn_inventory/html/js/config.js](#fsn_inventoryhtmljsconfig.js)
- [fsn_inventory/html/css/jquery-ui.css](#fsn_inventoryhtmlcssjquery-ui.css)
- [fsn_inventory/html/css/ui.css](#fsn_inventoryhtmlcssui.css)
- [fsn_inventory/html/img/bullet.png](#fsn_inventoryhtmlimgbullet.png)
- [fsn_inventory/html/img/items/radio_receiver.png](#fsn_inventoryhtmlimgitemsradio_receiver.png)
- [fsn_inventory/html/img/items/WEAPON_COMBATPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_COMBATPISTOL.png)
- [fsn_inventory/html/img/items/WEAPON_SNIPERRIFLE.png](#fsn_inventoryhtmlimgitemsWEAPON_SNIPERRIFLE.png)
- [fsn_inventory/html/img/items/WEAPON_NIGHTSTICK.png](#fsn_inventoryhtmlimgitemsWEAPON_NIGHTSTICK.png)
- [fsn_inventory/html/img/items/WEAPON_SMG_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_SMG_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_HAMMER.png](#fsn_inventoryhtmlimgitemsWEAPON_HAMMER.png)
- [fsn_inventory/html/img/items/WEAPON_COMBATPDW.png](#fsn_inventoryhtmlimgitemsWEAPON_COMBATPDW.png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE.png](#fsn_inventoryhtmlimgitemsWEAPON_ASSAULTRIFLE.png)
- [fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE.png](#fsn_inventoryhtmlimgitemsWEAPON_SPECIALCARBINE.png)
- [fsn_inventory/html/img/items/WEAPON_DOUBLEACTION.png](#fsn_inventoryhtmlimgitemsWEAPON_DOUBLEACTION.png)
- [fsn_inventory/html/img/items/WEAPON_MOLOTOV.png](#fsn_inventoryhtmlimgitemsWEAPON_MOLOTOV.png)
- [fsn_inventory/html/img/items/ammo_mg_large.png](#fsn_inventoryhtmlimgitemsammo_mg_large.png)
- [fsn_inventory/html/img/items/WEAPON_KNIFE.png](#fsn_inventoryhtmlimgitemsWEAPON_KNIFE.png)
- [fsn_inventory/html/img/items/WEAPON_SMOKEGRENADE.png](#fsn_inventoryhtmlimgitemsWEAPON_SMOKEGRENADE.png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_HEAVYSNIPER_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_REVOLVER.png](#fsn_inventoryhtmlimgitemsWEAPON_REVOLVER.png)
- [fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_BULLPUPRIFLE_MK2.png)
- [fsn_inventory/html/img/items/ammo_mg.png](#fsn_inventoryhtmlimgitemsammo_mg.png)
- [fsn_inventory/html/img/items/WEAPON_COMPACTRIFLE.png](#fsn_inventoryhtmlimgitemsWEAPON_COMPACTRIFLE.png)
- [fsn_inventory/html/img/items/WEAPON_PIPEBOMB.png](#fsn_inventoryhtmlimgitemsWEAPON_PIPEBOMB.png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_HEAVYPISTOL.png)
- [fsn_inventory/html/img/items/WEAPON_RAYCARBINE.png](#fsn_inventoryhtmlimgitemsWEAPON_RAYCARBINE.png)
- [fsn_inventory/html/img/items/burger.png](#fsn_inventoryhtmlimgitemsburger.png)
- [fsn_inventory/html/img/items/ammo_smg_large.png](#fsn_inventoryhtmlimgitemsammo_smg_large.png)
- [fsn_inventory/html/img/items/WEAPON_WRENCH.png](#fsn_inventoryhtmlimgitemsWEAPON_WRENCH.png)
- [fsn_inventory/html/img/items/WEAPON_PROXMINE.png](#fsn_inventoryhtmlimgitemsWEAPON_PROXMINE.png)
- [fsn_inventory/html/img/items/minced_meat.png](#fsn_inventoryhtmlimgitemsminced_meat.png)
- [fsn_inventory/html/img/items/beef_jerky.png](#fsn_inventoryhtmlimgitemsbeef_jerky.png)
- [fsn_inventory/html/img/items/microwave_burrito.png](#fsn_inventoryhtmlimgitemsmicrowave_burrito.png)
- [fsn_inventory/html/img/items/cupcake.png](#fsn_inventoryhtmlimgitemscupcake.png)
- [fsn_inventory/html/img/items/WEAPON_BALL.png](#fsn_inventoryhtmlimgitemsWEAPON_BALL.png)
- [fsn_inventory/html/img/items/packaged_cocaine.png](#fsn_inventoryhtmlimgitemspackaged_cocaine.png)
- [fsn_inventory/html/img/items/frozen_fries.png](#fsn_inventoryhtmlimgitemsfrozen_fries.png)
- [fsn_inventory/html/img/items/WEAPON_PETROLCAN.png](#fsn_inventoryhtmlimgitemsWEAPON_PETROLCAN.png)
- [fsn_inventory/html/img/items/WEAPON_GUSENBERG.png](#fsn_inventoryhtmlimgitemsWEAPON_GUSENBERG.png)
- [fsn_inventory/html/img/items/WEAPON_HATCHET.png](#fsn_inventoryhtmlimgitemsWEAPON_HATCHET.png)
- [fsn_inventory/html/img/items/zipties.png](#fsn_inventoryhtmlimgitemszipties.png)
- [fsn_inventory/html/img/items/WEAPON_SMG.png](#fsn_inventoryhtmlimgitemsWEAPON_SMG.png)
- [fsn_inventory/html/img/items/2g_weed.png](#fsn_inventoryhtmlimgitems2g_weed.png)
- [fsn_inventory/html/img/items/WEAPON_ADVANCEDRIFLE.png](#fsn_inventoryhtmlimgitemsWEAPON_ADVANCEDRIFLE.png)
- [fsn_inventory/html/img/items/WEAPON_STONE_HATCHET.png](#fsn_inventoryhtmlimgitemsWEAPON_STONE_HATCHET.png)
- [fsn_inventory/html/img/items/bandage.png](#fsn_inventoryhtmlimgitemsbandage.png)
- [fsn_inventory/html/img/items/modified_drillbit.png](#fsn_inventoryhtmlimgitemsmodified_drillbit.png)
- [fsn_inventory/html/img/items/cooked_burger.png](#fsn_inventoryhtmlimgitemscooked_burger.png)
- [fsn_inventory/html/img/items/uncooked_meat.png](#fsn_inventoryhtmlimgitemsuncooked_meat.png)
- [fsn_inventory/html/img/items/WEAPON_VINTAGEPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_VINTAGEPISTOL.png)
- [fsn_inventory/html/img/items/ammo_pistol.png](#fsn_inventoryhtmlimgitemsammo_pistol.png)
- [fsn_inventory/html/img/items/ammo_rifle_large.png](#fsn_inventoryhtmlimgitemsammo_rifle_large.png)
- [fsn_inventory/html/img/items/WEAPON_REVOLVER_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_REVOLVER_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_MARKSMANPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_MARKSMANPISTOL.png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYSHOTGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_HEAVYSHOTGUN.png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_ASSAULTRIFLE_MK2.png)
- [fsn_inventory/html/img/items/ammo_sniper_large.png](#fsn_inventoryhtmlimgitemsammo_sniper_large.png)
- [fsn_inventory/html/img/items/WEAPON_SNOWBALL.png](#fsn_inventoryhtmlimgitemsWEAPON_SNOWBALL.png)
- [fsn_inventory/html/img/items/WEAPON_CARBINERIFLE_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_CARBINERIFLE_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_MICROSMG.png](#fsn_inventoryhtmlimgitemsWEAPON_MICROSMG.png)
- [fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE.png](#fsn_inventoryhtmlimgitemsWEAPON_BULLPUPRIFLE.png)
- [fsn_inventory/html/img/items/WEAPON_BOTTLE.png](#fsn_inventoryhtmlimgitemsWEAPON_BOTTLE.png)
- [fsn_inventory/html/img/items/WEAPON_CARBINERIFLE.png](#fsn_inventoryhtmlimgitemsWEAPON_CARBINERIFLE.png)
- [fsn_inventory/html/img/items/WEAPON_SNSPISTOL_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_SNSPISTOL_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_HOMINGLAUNCHER.png](#fsn_inventoryhtmlimgitemsWEAPON_HOMINGLAUNCHER.png)
- [fsn_inventory/html/img/items/phone.png](#fsn_inventoryhtmlimgitemsphone.png)
- [fsn_inventory/html/img/items/burger_bun.png](#fsn_inventoryhtmlimgitemsburger_bun.png)
- [fsn_inventory/html/img/items/panini.png](#fsn_inventoryhtmlimgitemspanini.png)
- [fsn_inventory/html/img/items/vpn1.png](#fsn_inventoryhtmlimgitemsvpn1.png)
- [fsn_inventory/html/img/items/WEAPON_MINISMG.png](#fsn_inventoryhtmlimgitemsWEAPON_MINISMG.png)
- [fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE.png](#fsn_inventoryhtmlimgitemsWEAPON_MARKSMANRIFLE.png)
- [fsn_inventory/html/img/items/WEAPON_COMPACTLAUNCHER.png](#fsn_inventoryhtmlimgitemsWEAPON_COMPACTLAUNCHER.png)
- [fsn_inventory/html/img/items/WEAPON_SNSPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_SNSPISTOL.png)
- [fsn_inventory/html/img/items/gas_canister.png](#fsn_inventoryhtmlimgitemsgas_canister.png)
- [fsn_inventory/html/img/items/WEAPON_RAILGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_RAILGUN.png)
- [fsn_inventory/html/img/items/phosphorus.png](#fsn_inventoryhtmlimgitemsphosphorus.png)
- [fsn_inventory/html/img/items/empty_canister.png](#fsn_inventoryhtmlimgitemsempty_canister.png)
- [fsn_inventory/html/img/items/WEAPON_RAYMINIGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_RAYMINIGUN.png)
- [fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER.png](#fsn_inventoryhtmlimgitemsWEAPON_HEAVYSNIPER.png)
- [fsn_inventory/html/img/items/WEAPON_MACHETE.png](#fsn_inventoryhtmlimgitemsWEAPON_MACHETE.png)
- [fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_PUMPSHOTGUN.png)
- [fsn_inventory/html/img/items/ammo_shotgun_large.png](#fsn_inventoryhtmlimgitemsammo_shotgun_large.png)
- [fsn_inventory/html/img/items/lockpick.png](#fsn_inventoryhtmlimgitemslockpick.png)
- [fsn_inventory/html/img/items/WEAPON_PISTOL50.png](#fsn_inventoryhtmlimgitemsWEAPON_PISTOL50.png)
- [fsn_inventory/html/img/items/WEAPON_RPG.png](#fsn_inventoryhtmlimgitemsWEAPON_RPG.png)
- [fsn_inventory/html/img/items/WEAPON_DAGGER.png](#fsn_inventoryhtmlimgitemsWEAPON_DAGGER.png)
- [fsn_inventory/html/img/items/WEAPON_PISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_PISTOL.png)
- [fsn_inventory/html/img/items/WEAPON_FIREEXTINGUISHER.png](#fsn_inventoryhtmlimgitemsWEAPON_FIREEXTINGUISHER.png)
- [fsn_inventory/html/img/items/WEAPON_KNUCKLE.png](#fsn_inventoryhtmlimgitemsWEAPON_KNUCKLE.png)
- [fsn_inventory/html/img/items/ammo_shotgun.png](#fsn_inventoryhtmlimgitemsammo_shotgun.png)
- [fsn_inventory/html/img/items/WEAPON_STUNGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_STUNGUN.png)
- [fsn_inventory/html/img/items/ammo_rifle.png](#fsn_inventoryhtmlimgitemsammo_rifle.png)
- [fsn_inventory/html/img/items/WEAPON_DBSHOTGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_DBSHOTGUN.png)
- [fsn_inventory/html/img/items/keycard.png](#fsn_inventoryhtmlimgitemskeycard.png)
- [fsn_inventory/html/img/items/WEAPON_MG.png](#fsn_inventoryhtmlimgitemsWEAPON_MG.png)
- [fsn_inventory/html/img/items/tuner_chip.png](#fsn_inventoryhtmlimgitemstuner_chip.png)
- [fsn_inventory/html/img/items/WEAPON_GOLFCLUB.png](#fsn_inventoryhtmlimgitemsWEAPON_GOLFCLUB.png)
- [fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_SPECIALCARBINE_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_BAT.png](#fsn_inventoryhtmlimgitemsWEAPON_BAT.png)
- [fsn_inventory/html/img/items/WEAPON_AUTOSHOTGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_AUTOSHOTGUN.png)
- [fsn_inventory/html/img/items/ammo_pistol_large.png](#fsn_inventoryhtmlimgitemsammo_pistol_large.png)
- [fsn_inventory/html/img/items/morphine.png](#fsn_inventoryhtmlimgitemsmorphine.png)
- [fsn_inventory/html/img/items/WEAPON_BATTLEAXE.png](#fsn_inventoryhtmlimgitemsWEAPON_BATTLEAXE.png)
- [fsn_inventory/html/img/items/WEAPON_COMBATMG.png](#fsn_inventoryhtmlimgitemsWEAPON_COMBATMG.png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTSHOTGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_ASSAULTSHOTGUN.png)
- [fsn_inventory/html/img/items/WEAPON_POOLCUE.png](#fsn_inventoryhtmlimgitemsWEAPON_POOLCUE.png)
- [fsn_inventory/html/img/items/painkillers.png](#fsn_inventoryhtmlimgitemspainkillers.png)
- [fsn_inventory/html/img/items/WEAPON_FIREWORK.png](#fsn_inventoryhtmlimgitemsWEAPON_FIREWORK.png)
- [fsn_inventory/html/img/items/joint.png](#fsn_inventoryhtmlimgitemsjoint.png)
- [fsn_inventory/html/img/items/WEAPON_SAWNOFFSHOTGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_SAWNOFFSHOTGUN.png)
- [fsn_inventory/html/img/items/cigarette.png](#fsn_inventoryhtmlimgitemscigarette.png)
- [fsn_inventory/html/img/items/frozen_burger.png](#fsn_inventoryhtmlimgitemsfrozen_burger.png)
- [fsn_inventory/html/img/items/WEAPON_GRENADELAUNCHER.png](#fsn_inventoryhtmlimgitemsWEAPON_GRENADELAUNCHER.png)
- [fsn_inventory/html/img/items/drill.png](#fsn_inventoryhtmlimgitemsdrill.png)
- [fsn_inventory/html/img/items/WEAPON_PISTOL_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_PISTOL_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_RAYPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_RAYPISTOL.png)
- [fsn_inventory/html/img/items/WEAPON_APPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_APPISTOL.png)
- [fsn_inventory/html/img/items/ecola.png](#fsn_inventoryhtmlimgitemsecola.png)
- [fsn_inventory/html/img/items/WEAPON_FLARE.png](#fsn_inventoryhtmlimgitemsWEAPON_FLARE.png)
- [fsn_inventory/html/img/items/evidence.png](#fsn_inventoryhtmlimgitemsevidence.png)
- [fsn_inventory/html/img/items/armor.png](#fsn_inventoryhtmlimgitemsarmor.png)
- [fsn_inventory/html/img/items/WEAPON_STICKYBOMB.png](#fsn_inventoryhtmlimgitemsWEAPON_STICKYBOMB.png)
- [fsn_inventory/html/img/items/meth_rocks.png](#fsn_inventoryhtmlimgitemsmeth_rocks.png)
- [fsn_inventory/html/img/items/dirty_money.png](#fsn_inventoryhtmlimgitemsdirty_money.png)
- [fsn_inventory/html/img/items/water.png](#fsn_inventoryhtmlimgitemswater.png)
- [fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_PUMPSHOTGUN_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_ASSAULTSMG.png](#fsn_inventoryhtmlimgitemsWEAPON_ASSAULTSMG.png)
- [fsn_inventory/html/img/items/WEAPON_BULLPUPSHOTGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_BULLPUPSHOTGUN.png)
- [fsn_inventory/html/img/items/cooked_meat.png](#fsn_inventoryhtmlimgitemscooked_meat.png)
- [fsn_inventory/html/img/items/ammo_sniper.png](#fsn_inventoryhtmlimgitemsammo_sniper.png)
- [fsn_inventory/html/img/items/WEAPON_GRENADE.png](#fsn_inventoryhtmlimgitemsWEAPON_GRENADE.png)
- [fsn_inventory/html/img/items/ammo_smg.png](#fsn_inventoryhtmlimgitemsammo_smg.png)
- [fsn_inventory/html/img/items/fries.png](#fsn_inventoryhtmlimgitemsfries.png)
- [fsn_inventory/html/img/items/WEAPON_MACHINEPISTOL.png](#fsn_inventoryhtmlimgitemsWEAPON_MACHINEPISTOL.png)
- [fsn_inventory/html/img/items/id.png](#fsn_inventoryhtmlimgitemsid.png)
- [fsn_inventory/html/img/items/coffee.png](#fsn_inventoryhtmlimgitemscoffee.png)
- [fsn_inventory/html/img/items/WEAPON_SWITCHBLADE.png](#fsn_inventoryhtmlimgitemsWEAPON_SWITCHBLADE.png)
- [fsn_inventory/html/img/items/WEAPON_FLASHLIGHT.png](#fsn_inventoryhtmlimgitemsWEAPON_FLASHLIGHT.png)
- [fsn_inventory/html/img/items/WEAPON_CROWBAR.png](#fsn_inventoryhtmlimgitemsWEAPON_CROWBAR.png)
- [fsn_inventory/html/img/items/WEAPON_COMBATMG_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_COMBATMG_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_MINIGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_MINIGUN.png)
- [fsn_inventory/html/img/items/pepsi_max.png](#fsn_inventoryhtmlimgitemspepsi_max.png)
- [fsn_inventory/html/img/items/repair_kit.png](#fsn_inventoryhtmlimgitemsrepair_kit.png)
- [fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE_MK2.png](#fsn_inventoryhtmlimgitemsWEAPON_MARKSMANRIFLE_MK2.png)
- [fsn_inventory/html/img/items/WEAPON_FLAREGUN.png](#fsn_inventoryhtmlimgitemsWEAPON_FLAREGUN.png)
- [fsn_inventory/html/img/items/pepsi.png](#fsn_inventoryhtmlimgitemspepsi.png)
- [fsn_inventory/html/img/items/vpn2.png](#fsn_inventoryhtmlimgitemsvpn2.png)
- [fsn_inventory/html/img/items/binoculars.png](#fsn_inventoryhtmlimgitemsbinoculars.png)
- [fsn_inventory/html/img/items/acetone.png](#fsn_inventoryhtmlimgitemsacetone.png)
- [fsn_inventory/html/img/items/WEAPON_MUSKET.png](#fsn_inventoryhtmlimgitemsWEAPON_MUSKET.png)
- [fsn_inventory/html/locales/en.js](#fsn_inventoryhtmllocalesen.js)
- [fsn_inventory/html/locales/fr.js](#fsn_inventoryhtmllocalesfr.js)
- [fsn_inventory/html/locales/cs.js](#fsn_inventoryhtmllocalescs.js)
- [fsn_inventory/_old/client.lua](#fsn_inventory_oldclient.lua)
- [fsn_inventory/_old/server.lua](#fsn_inventory_oldserver.lua)
- [fsn_inventory/_old/pedfinder.lua](#fsn_inventory_oldpedfinder.lua)
- [fsn_inventory/_old/items.lua](#fsn_inventory_olditems.lua)
- [fsn_inventory/_old/_item_misc/_drug_selling.lua](#fsn_inventory_old_item_misc_drug_selling.lua)
- [fsn_inventory/_item_misc/cl_breather.lua](#fsn_inventory_item_misccl_breather.lua)
- [fsn_inventory/_item_misc/burger_store.lua](#fsn_inventory_item_miscburger_store.lua)
- [fsn_inventory/_item_misc/dm_laundering.lua](#fsn_inventory_item_miscdm_laundering.lua)
- [fsn_inventory/_item_misc/binoculars.lua](#fsn_inventory_item_miscbinoculars.lua)
- [fsn_progress/agents.md](#fsn_progressagents.md)
- [fsn_progress/client.lua](#fsn_progressclient.lua)
- [fsn_progress/fxmanifest.lua](#fsn_progressfxmanifest.lua)
- [fsn_progress/gui/index.html](#fsn_progressguiindex.html)
- [fsn_progress/gui/index.js](#fsn_progressguiindex.js)
- [fsn_bennys/agents.md](#fsn_bennysagents.md)
- [fsn_bennys/fxmanifest.lua](#fsn_bennysfxmanifest.lua)
- [fsn_bennys/menu.lua](#fsn_bennysmenu.lua)
- [fsn_bennys/cl_config.lua](#fsn_bennyscl_config.lua)
- [fsn_bennys/cl_bennys.lua](#fsn_bennyscl_bennys.lua)
- [fsn_bank/agents.md](#fsn_bankagents.md)
- [fsn_bank/client.lua](#fsn_bankclient.lua)
- [fsn_bank/server.lua](#fsn_bankserver.lua)
- [fsn_bank/fxmanifest.lua](#fsn_bankfxmanifest.lua)
- [fsn_bank/gui/atm_button_sound.mp3](#fsn_bankguiatm_button_sound.mp3)
- [fsn_bank/gui/index.html](#fsn_bankguiindex.html)
- [fsn_bank/gui/index.css](#fsn_bankguiindex.css)
- [fsn_bank/gui/atm_logo.png](#fsn_bankguiatm_logo.png)
- [fsn_bank/gui/index.js](#fsn_bankguiindex.js)
- [fsn_customs/lscustoms.lua](#fsn_customslscustoms.lua)
- [fsn_customs/agents.md](#fsn_customsagents.md)
- [fsn_customs/fxmanifest.lua](#fsn_customsfxmanifest.lua)
- [fsn_dev/config.lua](#fsn_devconfig.lua)
- [fsn_dev/agents.md](#fsn_devagents.md)
- [fsn_dev/fxmanifest.lua](#fsn_devfxmanifest.lua)
- [fsn_dev/oldresource.lua](#fsn_devoldresource.lua)
- [fsn_dev/client/client.lua](#fsn_devclientclient.lua)
- [fsn_dev/client/cl_noclip.lua](#fsn_devclientcl_noclip.lua)
- [fsn_dev/server/server.lua](#fsn_devserverserver.lua)
- [fsn_loadingscreen/agents.md](#fsn_loadingscreenagents.md)
- [fsn_loadingscreen/fxmanifest.lua](#fsn_loadingscreenfxmanifest.lua)
- [fsn_loadingscreen/index.html](#fsn_loadingscreenindex.html)
- [fsn_steamlogin/agents.md](#fsn_steamloginagents.md)
- [fsn_steamlogin/client.lua](#fsn_steamloginclient.lua)
- [fsn_steamlogin/fxmanifest.lua](#fsn_steamloginfxmanifest.lua)
- [fsn_jail/agents.md](#fsn_jailagents.md)
- [fsn_jail/client.lua](#fsn_jailclient.lua)
- [fsn_jail/server.lua](#fsn_jailserver.lua)
- [fsn_jail/fxmanifest.lua](#fsn_jailfxmanifest.lua)
- [fsn_bankrobbery/agents.md](#fsn_bankrobberyagents.md)
- [fsn_bankrobbery/trucks.lua](#fsn_bankrobberytrucks.lua)
- [fsn_bankrobbery/client.lua](#fsn_bankrobberyclient.lua)
- [fsn_bankrobbery/cl_safeanim.lua](#fsn_bankrobberycl_safeanim.lua)
- [fsn_bankrobbery/server.lua](#fsn_bankrobberyserver.lua)
- [fsn_bankrobbery/cl_frontdesks.lua](#fsn_bankrobberycl_frontdesks.lua)
- [fsn_bankrobbery/sv_frontdesks.lua](#fsn_bankrobberysv_frontdesks.lua)
- [fsn_bankrobbery/fxmanifest.lua](#fsn_bankrobberyfxmanifest.lua)
- [fsn_jewellerystore/agents.md](#fsn_jewellerystoreagents.md)
- [fsn_jewellerystore/client.lua](#fsn_jewellerystoreclient.lua)
- [fsn_jewellerystore/server.lua](#fsn_jewellerystoreserver.lua)
- [fsn_jewellerystore/fxmanifest.lua](#fsn_jewellerystorefxmanifest.lua)
- [fsn_gangs/agents.md](#fsn_gangsagents.md)
- [fsn_gangs/fxmanifest.lua](#fsn_gangsfxmanifest.lua)
- [fsn_gangs/cl_gangs.lua](#fsn_gangscl_gangs.lua)
- [fsn_gangs/sv_gangs.lua](#fsn_gangssv_gangs.lua)
- [fsn_weaponcontrol/agents.md](#fsn_weaponcontrolagents.md)
- [fsn_weaponcontrol/client.lua](#fsn_weaponcontrolclient.lua)
- [fsn_weaponcontrol/server.lua](#fsn_weaponcontrolserver.lua)
- [fsn_weaponcontrol/fxmanifest.lua](#fsn_weaponcontrolfxmanifest.lua)
- [fsn_properties/agents.md](#fsn_propertiesagents.md)
- [fsn_properties/cl_manage.lua](#fsn_propertiescl_manage.lua)
- [fsn_properties/cl_properties.lua](#fsn_propertiescl_properties.lua)
- [fsn_properties/fxmanifest.lua](#fsn_propertiesfxmanifest.lua)
- [fsn_properties/sv_properties.lua](#fsn_propertiessv_properties.lua)
- [fsn_properties/sv_conversion.lua](#fsn_propertiessv_conversion.lua)
- [fsn_properties/nui/ui.html](#fsn_propertiesnuiui.html)
- [fsn_properties/nui/ui.js](#fsn_propertiesnuiui.js)
- [fsn_properties/nui/ui.css](#fsn_propertiesnuiui.css)
- [fsn_activities/agents.md](#fsn_activitiesagents.md)
- [fsn_activities/fxmanifest.lua](#fsn_activitiesfxmanifest.lua)
- [fsn_activities/fishing/client.lua](#fsn_activitiesfishingclient.lua)
- [fsn_activities/hunting/client.lua](#fsn_activitieshuntingclient.lua)
- [fsn_activities/yoga/client.lua](#fsn_activitiesyogaclient.lua)
- [fsn_vehiclecontrol/agents.md](#fsn_vehiclecontrolagents.md)
- [fsn_vehiclecontrol/client.lua](#fsn_vehiclecontrolclient.lua)
- [fsn_vehiclecontrol/fxmanifest.lua](#fsn_vehiclecontrolfxmanifest.lua)
- [fsn_vehiclecontrol/aircontrol/aircontrol.lua](#fsn_vehiclecontrolaircontrolaircontrol.lua)
- [fsn_vehiclecontrol/speedcameras/client.lua](#fsn_vehiclecontrolspeedcamerasclient.lua)
- [fsn_vehiclecontrol/carwash/client.lua](#fsn_vehiclecontrolcarwashclient.lua)
- [fsn_vehiclecontrol/holdup/client.lua](#fsn_vehiclecontrolholdupclient.lua)
- [fsn_vehiclecontrol/keys/server.lua](#fsn_vehiclecontrolkeysserver.lua)
- [fsn_vehiclecontrol/inventory/client.lua](#fsn_vehiclecontrolinventoryclient.lua)
- [fsn_vehiclecontrol/inventory/server.lua](#fsn_vehiclecontrolinventoryserver.lua)
- [fsn_vehiclecontrol/fuel/client.lua](#fsn_vehiclecontrolfuelclient.lua)
- [fsn_vehiclecontrol/fuel/server.lua](#fsn_vehiclecontrolfuelserver.lua)
- [fsn_vehiclecontrol/engine/client.lua](#fsn_vehiclecontrolengineclient.lua)
- [fsn_vehiclecontrol/odometer/client.lua](#fsn_vehiclecontrolodometerclient.lua)
- [fsn_vehiclecontrol/odometer/server.lua](#fsn_vehiclecontrolodometerserver.lua)
- [fsn_vehiclecontrol/trunk/client.lua](#fsn_vehiclecontroltrunkclient.lua)
- [fsn_vehiclecontrol/trunk/server.lua](#fsn_vehiclecontroltrunkserver.lua)
- [fsn_vehiclecontrol/damage/config.lua](#fsn_vehiclecontroldamageconfig.lua)
- [fsn_vehiclecontrol/damage/client.lua](#fsn_vehiclecontroldamageclient.lua)
- [fsn_vehiclecontrol/damage/cl_crashes.lua](#fsn_vehiclecontroldamagecl_crashes.lua)
- [fsn_vehiclecontrol/compass/streetname.lua](#fsn_vehiclecontrolcompassstreetname.lua)
- [fsn_vehiclecontrol/compass/essentials.lua](#fsn_vehiclecontrolcompassessentials.lua)
- [fsn_vehiclecontrol/compass/compass.lua](#fsn_vehiclecontrolcompasscompass.lua)
- [fsn_vehiclecontrol/carhud/carhud.lua](#fsn_vehiclecontrolcarhudcarhud.lua)
- [fsn_needs/agents.md](#fsn_needsagents.md)
- [fsn_needs/client.lua](#fsn_needsclient.lua)
- [fsn_needs/vending.lua](#fsn_needsvending.lua)
- [fsn_needs/fxmanifest.lua](#fsn_needsfxmanifest.lua)
- [fsn_needs/hud.lua](#fsn_needshud.lua)
- [fsn_ems/debug_kng.lua](#fsn_emsdebug_kng.lua)
- [fsn_ems/agents.md](#fsn_emsagents.md)
- [fsn_ems/client.lua](#fsn_emsclient.lua)
- [fsn_ems/server.lua](#fsn_emsserver.lua)
- [fsn_ems/blip.lua](#fsn_emsblip.lua)
- [fsn_ems/sv_carrydead.lua](#fsn_emssv_carrydead.lua)
- [fsn_ems/fxmanifest.lua](#fsn_emsfxmanifest.lua)
- [fsn_ems/cl_advanceddamage.lua](#fsn_emscl_advanceddamage.lua)
- [fsn_ems/cl_carrydead.lua](#fsn_emscl_carrydead.lua)
- [fsn_ems/info.txt](#fsn_emsinfo.txt)
- [fsn_ems/cl_volunteering.lua](#fsn_emscl_volunteering.lua)
- [fsn_ems/beds/client.lua](#fsn_emsbedsclient.lua)
- [fsn_ems/beds/server.lua](#fsn_emsbedsserver.lua)
- [fsn_emotecontrol/agents.md](#fsn_emotecontrolagents.md)
- [fsn_emotecontrol/client.lua](#fsn_emotecontrolclient.lua)
- [fsn_emotecontrol/fxmanifest.lua](#fsn_emotecontrolfxmanifest.lua)
- [fsn_emotecontrol/walktypes/client.lua](#fsn_emotecontrolwalktypesclient.lua)
- [fsn_newchat/agents.md](#fsn_newchatagents.md)
- [fsn_newchat/sv_chat.lua](#fsn_newchatsv_chat.lua)
- [fsn_newchat/fxmanifest.lua](#fsn_newchatfxmanifest.lua)
- [fsn_newchat/README.md](#fsn_newchatREADME.md)
- [fsn_newchat/cl_chat.lua](#fsn_newchatcl_chat.lua)
- [fsn_newchat/html/Suggestions.js](#fsn_newchathtmlSuggestions.js)
- [fsn_newchat/html/Message.js](#fsn_newchathtmlMessage.js)
- [fsn_newchat/html/index.html](#fsn_newchathtmlindex.html)
- [fsn_newchat/html/App.js](#fsn_newchathtmlApp.js)
- [fsn_newchat/html/config.default.js](#fsn_newchathtmlconfig.default.js)
- [fsn_newchat/html/index.css](#fsn_newchathtmlindex.css)
- [fsn_newchat/html/vendor/animate.3.5.2.min.css](#fsn_newchathtmlvendoranimate.3.5.2.min.css)
- [fsn_newchat/html/vendor/vue.2.3.3.min.js](#fsn_newchathtmlvendorvue.2.3.3.min.js)
- [fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css](#fsn_newchathtmlvendorflexboxgrid.6.3.1.min.css)
- [fsn_newchat/html/vendor/latofonts.css](#fsn_newchathtmlvendorlatofonts.css)
- [fsn_newchat/html/vendor/fonts/LatoRegular.woff2](#fsn_newchathtmlvendorfontsLatoRegular.woff2)
- [fsn_newchat/html/vendor/fonts/LatoBold2.woff2](#fsn_newchathtmlvendorfontsLatoBold2.woff2)
- [fsn_newchat/html/vendor/fonts/LatoLight.woff2](#fsn_newchathtmlvendorfontsLatoLight.woff2)
- [fsn_newchat/html/vendor/fonts/LatoRegular2.woff2](#fsn_newchathtmlvendorfontsLatoRegular2.woff2)
- [fsn_newchat/html/vendor/fonts/LatoLight2.woff2](#fsn_newchathtmlvendorfontsLatoLight2.woff2)
- [fsn_newchat/html/vendor/fonts/LatoBold.woff2](#fsn_newchathtmlvendorfontsLatoBold.woff2)
- [fsn_cargarage/agents.md](#fsn_cargarageagents.md)
- [fsn_cargarage/client.lua](#fsn_cargarageclient.lua)
- [fsn_cargarage/server.lua](#fsn_cargarageserver.lua)
- [fsn_cargarage/fxmanifest.lua](#fsn_cargaragefxmanifest.lua)
- [fsn_cargarage/gui/ui.html](#fsn_cargarageguiui.html)
- [fsn_cargarage/gui/ui.js](#fsn_cargarageguiui.js)
- [fsn_cargarage/gui/ui.css](#fsn_cargarageguiui.css)
- [fsn_boatshop/agents.md](#fsn_boatshopagents.md)
- [fsn_boatshop/cl_boatshop.lua](#fsn_boatshopcl_boatshop.lua)
- [fsn_boatshop/fxmanifest.lua](#fsn_boatshopfxmanifest.lua)
- [fsn_boatshop/cl_menu.lua](#fsn_boatshopcl_menu.lua)
- [fsn_boatshop/sv_boatshop.lua](#fsn_boatshopsv_boatshop.lua)
- [fsn_bikerental/agents.md](#fsn_bikerentalagents.md)
- [fsn_bikerental/client.lua](#fsn_bikerentalclient.lua)
- [fsn_bikerental/fxmanifest.lua](#fsn_bikerentalfxmanifest.lua)
- [fsn_bikerental/html/script.js](#fsn_bikerentalhtmlscript.js)
- [fsn_bikerental/html/index.html](#fsn_bikerentalhtmlindex.html)
- [fsn_bikerental/html/cursor.png](#fsn_bikerentalhtmlcursor.png)
- [fsn_bikerental/html/style.css](#fsn_bikerentalhtmlstyle.css)
- [fsn_store/agents.md](#fsn_storeagents.md)
- [fsn_store/client.lua](#fsn_storeclient.lua)
- [fsn_store/server.lua](#fsn_storeserver.lua)
- [fsn_store/fxmanifest.lua](#fsn_storefxmanifest.lua)
- [fsn_admin/config.lua](#fsn_adminconfig.lua)
- [fsn_admin/agents.md](#fsn_adminagents.md)
- [fsn_admin/client.lua](#fsn_adminclient.lua)
- [fsn_admin/server.lua](#fsn_adminserver.lua)
- [fsn_admin/fxmanifest.lua](#fsn_adminfxmanifest.lua)
- [fsn_admin/oldresource.lua](#fsn_adminoldresource.lua)
- [fsn_admin/server_announce.lua](#fsn_adminserver_announce.lua)
- [fsn_admin/client/client.lua](#fsn_adminclientclient.lua)
- [fsn_admin/server/server.lua](#fsn_adminserverserver.lua)
- [fsn_teleporters/agents.md](#fsn_teleportersagents.md)
- [fsn_teleporters/client.lua](#fsn_teleportersclient.lua)
- [fsn_teleporters/fxmanifest.lua](#fsn_teleportersfxmanifest.lua)
- [fsn_store_guns/agents.md](#fsn_store_gunsagents.md)
- [fsn_store_guns/client.lua](#fsn_store_gunsclient.lua)
- [fsn_store_guns/server.lua](#fsn_store_gunsserver.lua)
- [fsn_store_guns/fxmanifest.lua](#fsn_store_gunsfxmanifest.lua)
- [fsn_notify/agents.md](#fsn_notifyagents.md)
- [fsn_notify/server.lua](#fsn_notifyserver.lua)
- [fsn_notify/fxmanifest.lua](#fsn_notifyfxmanifest.lua)
- [fsn_notify/cl_notify.lua](#fsn_notifycl_notify.lua)
- [fsn_notify/html/noty.css](#fsn_notifyhtmlnoty.css)
- [fsn_notify/html/themes.css](#fsn_notifyhtmlthemes.css)
- [fsn_notify/html/pNotify.js](#fsn_notifyhtmlpNotify.js)
- [fsn_notify/html/index.html](#fsn_notifyhtmlindex.html)
- [fsn_notify/html/noty_license.txt](#fsn_notifyhtmlnoty_license.txt)
- [fsn_notify/html/noty.js](#fsn_notifyhtmlnoty.js)
- [fsn_characterdetails/agents.md](#fsn_characterdetailsagents.md)
- [fsn_characterdetails/fxmanifest.lua](#fsn_characterdetailsfxmanifest.lua)
- [fsn_characterdetails/gui_manager.lua](#fsn_characterdetailsgui_manager.lua)
- [fsn_characterdetails/facial/client.lua](#fsn_characterdetailsfacialclient.lua)
- [fsn_characterdetails/facial/server.lua](#fsn_characterdetailsfacialserver.lua)
- [fsn_characterdetails/tattoos/config.lua](#fsn_characterdetailstattoosconfig.lua)
- [fsn_characterdetails/tattoos/client.lua](#fsn_characterdetailstattoosclient.lua)
- [fsn_characterdetails/tattoos/server.lua](#fsn_characterdetailstattoosserver.lua)
- [fsn_characterdetails/tattoos/server.zip](#fsn_characterdetailstattoosserver.zip)
- [fsn_characterdetails/gui/ui.html](#fsn_characterdetailsguiui.html)
- [fsn_characterdetails/gui/ui.js](#fsn_characterdetailsguiui.js)
- [fsn_characterdetails/gui/ui.css](#fsn_characterdetailsguiui.css)
- [fsn_main/agents.md](#fsn_mainagents.md)
- [fsn_main/cl_utils.lua](#fsn_maincl_utils.lua)
- [fsn_main/fxmanifest.lua](#fsn_mainfxmanifest.lua)
- [fsn_main/sv_utils.lua](#fsn_mainsv_utils.lua)
- [fsn_main/server_settings/sh_settings.lua](#fsn_mainserver_settingssh_settings.lua)
- [fsn_main/money/client.lua](#fsn_mainmoneyclient.lua)
- [fsn_main/money/server.lua](#fsn_mainmoneyserver.lua)
- [fsn_main/gui/motd.txt](#fsn_mainguimotd.txt)
- [fsn_main/gui/pdown.ttf](#fsn_mainguipdown.ttf)
- [fsn_main/gui/index.html](#fsn_mainguiindex.html)
- [fsn_main/gui/logo_old.png](#fsn_mainguilogo_old.png)
- [fsn_main/gui/logo_new.png](#fsn_mainguilogo_new.png)
- [fsn_main/gui/index.js](#fsn_mainguiindex.js)
- [fsn_main/gui/logos/discord.png](#fsn_mainguilogosdiscord.png)
- [fsn_main/gui/logos/logo.png](#fsn_mainguilogoslogo.png)
- [fsn_main/gui/logos/main.psd](#fsn_mainguilogosmain.psd)
- [fsn_main/gui/logos/discord.psd](#fsn_mainguilogosdiscord.psd)
- [fsn_main/misc/logging.lua](#fsn_mainmisclogging.lua)
- [fsn_main/misc/shitlordjumping.lua](#fsn_mainmiscshitlordjumping.lua)
- [fsn_main/misc/version.lua](#fsn_mainmiscversion.lua)
- [fsn_main/misc/timer.lua](#fsn_mainmisctimer.lua)
- [fsn_main/misc/db.lua](#fsn_mainmiscdb.lua)
- [fsn_main/misc/servername.lua](#fsn_mainmiscservername.lua)
- [fsn_main/playermanager/client.lua](#fsn_mainplayermanagerclient.lua)
- [fsn_main/playermanager/server.lua](#fsn_mainplayermanagerserver.lua)
- [fsn_main/banmanager/sv_bans.lua](#fsn_mainbanmanagersv_bans.lua)
- [fsn_main/initial/client.lua](#fsn_maininitialclient.lua)
- [fsn_main/initial/server.lua](#fsn_maininitialserver.lua)
- [fsn_main/initial/desc.txt](#fsn_maininitialdesc.txt)
- [fsn_main/debug/sh_debug.lua](#fsn_maindebugsh_debug.lua)
- [fsn_main/debug/cl_subframetime.js](#fsn_maindebugcl_subframetime.js)
- [fsn_main/debug/sh_scheduler.lua](#fsn_maindebugsh_scheduler.lua)
- [fsn_main/hud/client.lua](#fsn_mainhudclient.lua)
- [fsn_shootingrange/agents.md](#fsn_shootingrangeagents.md)
- [fsn_shootingrange/client.lua](#fsn_shootingrangeclient.lua)
- [fsn_shootingrange/server.lua](#fsn_shootingrangeserver.lua)
- [fsn_shootingrange/fxmanifest.lua](#fsn_shootingrangefxmanifest.lua)
- [fsn_police/agents.md](#fsn_policeagents.md)
- [fsn_police/client.lua](#fsn_policeclient.lua)
- [fsn_police/server.lua](#fsn_policeserver.lua)
- [fsn_police/dispatch.lua](#fsn_policedispatch.lua)
- [fsn_police/fxmanifest.lua](#fsn_policefxmanifest.lua)
- [fsn_police/tackle/client.lua](#fsn_policetackleclient.lua)
- [fsn_police/tackle/server.lua](#fsn_policetackleserver.lua)
- [fsn_police/dispatch/client.lua](#fsn_policedispatchclient.lua)
- [fsn_police/armory/cl_armory.lua](#fsn_policearmorycl_armory.lua)
- [fsn_police/armory/sv_armory.lua](#fsn_policearmorysv_armory.lua)
- [fsn_police/MDT/mdt_server.lua](#fsn_policeMDTmdt_server.lua)
- [fsn_police/MDT/mdt_client.lua](#fsn_policeMDTmdt_client.lua)
- [fsn_police/MDT/gui/index.html](#fsn_policeMDTguiindex.html)
- [fsn_police/MDT/gui/index.css](#fsn_policeMDTguiindex.css)
- [fsn_police/MDT/gui/index.js](#fsn_policeMDTguiindex.js)
- [fsn_police/MDT/gui/images/win_icon.png](#fsn_policeMDTguiimageswin_icon.png)
- [fsn_police/MDT/gui/images/background.png](#fsn_policeMDTguiimagesbackground.png)
- [fsn_police/MDT/gui/images/base_pc.png](#fsn_policeMDTguiimagesbase_pc.png)
- [fsn_police/MDT/gui/images/pwr_icon.png](#fsn_policeMDTguiimagespwr_icon.png)
- [fsn_police/MDT/gui/images/icons/cpic.png](#fsn_policeMDTguiimagesiconscpic.png)
- [fsn_police/MDT/gui/images/icons/dmv.png](#fsn_policeMDTguiimagesiconsdmv.png)
- [fsn_police/MDT/gui/images/icons/warrants.png](#fsn_policeMDTguiimagesiconswarrants.png)
- [fsn_police/MDT/gui/images/icons/booking.png](#fsn_policeMDTguiimagesiconsbooking.png)
- [fsn_police/K9/client.lua](#fsn_policeK9client.lua)
- [fsn_police/K9/server.lua](#fsn_policeK9server.lua)
- [fsn_police/pedmanagement/client.lua](#fsn_policepedmanagementclient.lua)
- [fsn_police/pedmanagement/server.lua](#fsn_policepedmanagementserver.lua)
- [fsn_police/radar/client.lua](#fsn_policeradarclient.lua)
- [fsn_storagelockers/agents.md](#fsn_storagelockersagents.md)
- [fsn_storagelockers/client.lua](#fsn_storagelockersclient.lua)
- [fsn_storagelockers/server.lua](#fsn_storagelockersserver.lua)
- [fsn_storagelockers/fxmanifest.lua](#fsn_storagelockersfxmanifest.lua)
- [fsn_storagelockers/nui/ui.html](#fsn_storagelockersnuiui.html)
- [fsn_storagelockers/nui/ui.js](#fsn_storagelockersnuiui.js)
- [fsn_storagelockers/nui/ui.css](#fsn_storagelockersnuiui.css)
- [fsn_criminalmisc/agents.md](#fsn_criminalmiscagents.md)
- [fsn_criminalmisc/client.lua](#fsn_criminalmiscclient.lua)
- [fsn_criminalmisc/fxmanifest.lua](#fsn_criminalmiscfxmanifest.lua)
- [fsn_criminalmisc/pawnstore/cl_pawnstore.lua](#fsn_criminalmiscpawnstorecl_pawnstore.lua)
- [fsn_criminalmisc/handcuffs/client.lua](#fsn_criminalmischandcuffsclient.lua)
- [fsn_criminalmisc/handcuffs/server.lua](#fsn_criminalmischandcuffsserver.lua)
- [fsn_criminalmisc/lockpicking/client.lua](#fsn_criminalmisclockpickingclient.lua)
- [fsn_criminalmisc/drugs/client.lua](#fsn_criminalmiscdrugsclient.lua)
- [fsn_criminalmisc/drugs/_weedprocess/client.lua](#fsn_criminalmiscdrugs_weedprocessclient.lua)
- [fsn_criminalmisc/drugs/_effects/client.lua](#fsn_criminalmiscdrugs_effectsclient.lua)
- [fsn_criminalmisc/drugs/_streetselling/client.lua](#fsn_criminalmiscdrugs_streetsellingclient.lua)
- [fsn_criminalmisc/drugs/_streetselling/server.lua](#fsn_criminalmiscdrugs_streetsellingserver.lua)
- [fsn_criminalmisc/remapping/client.lua](#fsn_criminalmiscremappingclient.lua)
- [fsn_criminalmisc/remapping/server.lua](#fsn_criminalmiscremappingserver.lua)
- [fsn_criminalmisc/weaponinfo/client.lua](#fsn_criminalmiscweaponinfoclient.lua)
- [fsn_criminalmisc/weaponinfo/server.lua](#fsn_criminalmiscweaponinfoserver.lua)
- [fsn_criminalmisc/weaponinfo/weapon_list.lua](#fsn_criminalmiscweaponinfoweapon_list.lua)
- [fsn_criminalmisc/streetracing/client.lua](#fsn_criminalmiscstreetracingclient.lua)
- [fsn_criminalmisc/streetracing/server.lua](#fsn_criminalmiscstreetracingserver.lua)
- [fsn_criminalmisc/robbing/cl_houses-config.lua](#fsn_criminalmiscrobbingcl_houses-config.lua)
- [fsn_criminalmisc/robbing/client.lua](#fsn_criminalmiscrobbingclient.lua)
- [fsn_criminalmisc/robbing/cl_houses-build.lua](#fsn_criminalmiscrobbingcl_houses-build.lua)
- [fsn_criminalmisc/robbing/cl_houses.lua](#fsn_criminalmiscrobbingcl_houses.lua)
- [fsn_spawnmanager/agents.md](#fsn_spawnmanageragents.md)
- [fsn_spawnmanager/client.lua](#fsn_spawnmanagerclient.lua)
- [fsn_spawnmanager/fxmanifest.lua](#fsn_spawnmanagerfxmanifest.lua)
- [fsn_spawnmanager/nui/index.html](#fsn_spawnmanagernuiindex.html)
- [fsn_spawnmanager/nui/index.css](#fsn_spawnmanagernuiindex.css)
- [fsn_spawnmanager/nui/index.js](#fsn_spawnmanagernuiindex.js)
- [fsn_clothing/config.lua](#fsn_clothingconfig.lua)
- [fsn_clothing/agents.md](#fsn_clothingagents.md)
- [fsn_clothing/client.lua](#fsn_clothingclient.lua)
- [fsn_clothing/server.lua](#fsn_clothingserver.lua)
- [fsn_clothing/fxmanifest.lua](#fsn_clothingfxmanifest.lua)
- [fsn_clothing/models.txt](#fsn_clothingmodels.txt)
- [fsn_clothing/gui.lua](#fsn_clothinggui.lua)
- [fsn_priority/agents.md](#fsn_priorityagents.md)
- [fsn_priority/server.lua](#fsn_priorityserver.lua)
- [fsn_priority/fxmanifest.lua](#fsn_priorityfxmanifest.lua)
- [fsn_priority/administration.lua](#fsn_priorityadministration.lua)
- [fsn_customanimations/agents.md](#fsn_customanimationsagents.md)
- [fsn_customanimations/client.lua](#fsn_customanimationsclient.lua)
- [fsn_customanimations/fxmanifest.lua](#fsn_customanimationsfxmanifest.lua)
- [fsn_timeandweather/w_clearing.xml](#fsn_timeandweatherw_clearing.xml)
- [fsn_timeandweather/agents.md](#fsn_timeandweatheragents.md)
- [fsn_timeandweather/w_xmas.xml](#fsn_timeandweatherw_xmas.xml)
- [fsn_timeandweather/w_clouds.xml](#fsn_timeandweatherw_clouds.xml)
- [fsn_timeandweather/client.lua](#fsn_timeandweatherclient.lua)
- [fsn_timeandweather/w_thunder.xml](#fsn_timeandweatherw_thunder.xml)
- [fsn_timeandweather/server.lua](#fsn_timeandweatherserver.lua)
- [fsn_timeandweather/w_overcast.xml](#fsn_timeandweatherw_overcast.xml)
- [fsn_timeandweather/w_rain.xml](#fsn_timeandweatherw_rain.xml)
- [fsn_timeandweather/fxmanifest.lua](#fsn_timeandweatherfxmanifest.lua)
- [fsn_timeandweather/w_neutral.xml](#fsn_timeandweatherw_neutral.xml)
- [fsn_timeandweather/w_clear.xml](#fsn_timeandweatherw_clear.xml)
- [fsn_timeandweather/w_snow.xml](#fsn_timeandweatherw_snow.xml)
- [fsn_timeandweather/w_snowlight.xml](#fsn_timeandweatherw_snowlight.xml)
- [fsn_timeandweather/w_blizzard.xml](#fsn_timeandweatherw_blizzard.xml)
- [fsn_timeandweather/w_smog.xml](#fsn_timeandweatherw_smog.xml)
- [fsn_timeandweather/w_extrasunny.xml](#fsn_timeandweatherw_extrasunny.xml)
- [fsn_timeandweather/timecycle_mods_4.xml](#fsn_timeandweathertimecycle_mods_4.xml)
- [fsn_timeandweather/w_foggy.xml](#fsn_timeandweatherw_foggy.xml)
- [fsn_crafting/agents.md](#fsn_craftingagents.md)
- [fsn_crafting/client.lua](#fsn_craftingclient.lua)
- [fsn_crafting/server.lua](#fsn_craftingserver.lua)
- [fsn_crafting/fxmanifest.lua](#fsn_craftingfxmanifest.lua)
- [fsn_crafting/nui/index.html](#fsn_craftingnuiindex.html)
- [fsn_crafting/nui/index.css](#fsn_craftingnuiindex.css)
- [fsn_crafting/nui/index.js](#fsn_craftingnuiindex.js)
- [fsn_voicecontrol/agents.md](#fsn_voicecontrolagents.md)
- [fsn_voicecontrol/client.lua](#fsn_voicecontrolclient.lua)
- [fsn_voicecontrol/server.lua](#fsn_voicecontrolserver.lua)
- [fsn_voicecontrol/fxmanifest.lua](#fsn_voicecontrolfxmanifest.lua)
- [fsn_inventory_dropping/agents.md](#fsn_inventory_droppingagents.md)
- [fsn_inventory_dropping/fxmanifest.lua](#fsn_inventory_droppingfxmanifest.lua)
- [fsn_inventory_dropping/sv_dropping.lua](#fsn_inventory_droppingsv_dropping.lua)
- [fsn_inventory_dropping/cl_dropping.lua](#fsn_inventory_droppingcl_dropping.lua)
- [fsn_phones/agents.md](#fsn_phonesagents.md)
- [fsn_phones/fxmanifest.lua](#fsn_phonesfxmanifest.lua)
- [fsn_phones/sv_phone.lua](#fsn_phonessv_phone.lua)
- [fsn_phones/cl_phone.lua](#fsn_phonescl_phone.lua)
- [fsn_phones/html/index.html.old](#fsn_phoneshtmlindex.html.old)
- [fsn_phones/html/index.html](#fsn_phoneshtmlindex.html)
- [fsn_phones/html/index.css](#fsn_phoneshtmlindex.css)
- [fsn_phones/html/index.js](#fsn_phoneshtmlindex.js)
- [fsn_phones/html/pages_css/iphone/garage.css](#fsn_phoneshtmlpages_cssiphonegarage.css)
- [fsn_phones/html/pages_css/iphone/whitelists.css](#fsn_phoneshtmlpages_cssiphonewhitelists.css)
- [fsn_phones/html/pages_css/iphone/adverts.css](#fsn_phoneshtmlpages_cssiphoneadverts.css)
- [fsn_phones/html/pages_css/iphone/call.css](#fsn_phoneshtmlpages_cssiphonecall.css)
- [fsn_phones/html/pages_css/iphone/phone.css](#fsn_phoneshtmlpages_cssiphonephone.css)
- [fsn_phones/html/pages_css/iphone/darkweb.css](#fsn_phoneshtmlpages_cssiphonedarkweb.css)
- [fsn_phones/html/pages_css/iphone/main.css](#fsn_phoneshtmlpages_cssiphonemain.css)
- [fsn_phones/html/pages_css/iphone/pay.css](#fsn_phoneshtmlpages_cssiphonepay.css)
- [fsn_phones/html/pages_css/iphone/email.css](#fsn_phoneshtmlpages_cssiphoneemail.css)
- [fsn_phones/html/pages_css/iphone/home.css](#fsn_phoneshtmlpages_cssiphonehome.css)
- [fsn_phones/html/pages_css/iphone/twitter.css](#fsn_phoneshtmlpages_cssiphonetwitter.css)
- [fsn_phones/html/pages_css/iphone/contacts.css](#fsn_phoneshtmlpages_cssiphonecontacts.css)
- [fsn_phones/html/pages_css/iphone/messages.css](#fsn_phoneshtmlpages_cssiphonemessages.css)
- [fsn_phones/html/pages_css/iphone/fleeca.css](#fsn_phoneshtmlpages_cssiphonefleeca.css)
- [fsn_phones/html/pages_css/samsung/whitelists.css](#fsn_phoneshtmlpages_csssamsungwhitelists.css)
- [fsn_phones/html/pages_css/samsung/adverts.css](#fsn_phoneshtmlpages_csssamsungadverts.css)
- [fsn_phones/html/pages_css/samsung/call.css](#fsn_phoneshtmlpages_csssamsungcall.css)
- [fsn_phones/html/pages_css/samsung/phone.css](#fsn_phoneshtmlpages_csssamsungphone.css)
- [fsn_phones/html/pages_css/samsung/main.css](#fsn_phoneshtmlpages_csssamsungmain.css)
- [fsn_phones/html/pages_css/samsung/pay.css](#fsn_phoneshtmlpages_csssamsungpay.css)
- [fsn_phones/html/pages_css/samsung/email.css](#fsn_phoneshtmlpages_csssamsungemail.css)
- [fsn_phones/html/pages_css/samsung/home.css](#fsn_phoneshtmlpages_csssamsunghome.css)
- [fsn_phones/html/pages_css/samsung/twitter.css](#fsn_phoneshtmlpages_csssamsungtwitter.css)
- [fsn_phones/html/pages_css/samsung/contacts.css](#fsn_phoneshtmlpages_csssamsungcontacts.css)
- [fsn_phones/html/pages_css/samsung/messages.css](#fsn_phoneshtmlpages_csssamsungmessages.css)
- [fsn_phones/html/pages_css/samsung/fleeca.css](#fsn_phoneshtmlpages_csssamsungfleeca.css)
- [fsn_phones/html/img/cursor.png](#fsn_phoneshtmlimgcursor.png)
- [fsn_phones/html/img/Apple/Twitter.png](#fsn_phoneshtmlimgAppleTwitter.png)
- [fsn_phones/html/img/Apple/node_other_server__1247323.png](#fsn_phoneshtmlimgApplenode_other_server__1247323.png)
- [fsn_phones/html/img/Apple/Ads.png](#fsn_phoneshtmlimgAppleAds.png)
- [fsn_phones/html/img/Apple/wallpaper.png](#fsn_phoneshtmlimgApplewallpaper.png)
- [fsn_phones/html/img/Apple/Mail.png](#fsn_phoneshtmlimgAppleMail.png)
- [fsn_phones/html/img/Apple/Whitelist.png](#fsn_phoneshtmlimgAppleWhitelist.png)
- [fsn_phones/html/img/Apple/darkweb.png](#fsn_phoneshtmlimgAppledarkweb.png)
- [fsn_phones/html/img/Apple/Noti.png](#fsn_phoneshtmlimgAppleNoti.png)
- [fsn_phones/html/img/Apple/Frame.png](#fsn_phoneshtmlimgAppleFrame.png)
- [fsn_phones/html/img/Apple/wifi.png](#fsn_phoneshtmlimgApplewifi.png)
- [fsn_phones/html/img/Apple/default-avatar.png](#fsn_phoneshtmlimgAppledefault-avatar.png)
- [fsn_phones/html/img/Apple/Wallet.png](#fsn_phoneshtmlimgAppleWallet.png)
- [fsn_phones/html/img/Apple/signal.png](#fsn_phoneshtmlimgApplesignal.png)
- [fsn_phones/html/img/Apple/battery.png](#fsn_phoneshtmlimgApplebattery.png)
- [fsn_phones/html/img/Apple/missed-out.png](#fsn_phoneshtmlimgApplemissed-out.png)
- [fsn_phones/html/img/Apple/Fleeca.png](#fsn_phoneshtmlimgAppleFleeca.png)
- [fsn_phones/html/img/Apple/feedgrey.png](#fsn_phoneshtmlimgApplefeedgrey.png)
- [fsn_phones/html/img/Apple/Messages.png](#fsn_phoneshtmlimgAppleMessages.png)
- [fsn_phones/html/img/Apple/Phone.png](#fsn_phoneshtmlimgApplePhone.png)
- [fsn_phones/html/img/Apple/call-out.png](#fsn_phoneshtmlimgApplecall-out.png)
- [fsn_phones/html/img/Apple/call-in.png](#fsn_phoneshtmlimgApplecall-in.png)
- [fsn_phones/html/img/Apple/missed-in.png](#fsn_phoneshtmlimgApplemissed-in.png)
- [fsn_phones/html/img/Apple/Lock icon.png](#fsn_phoneshtmlimgAppleLock icon.png)
- [fsn_phones/html/img/Apple/Contact.png](#fsn_phoneshtmlimgAppleContact.png)
- [fsn_phones/html/img/Apple/fleeca-bg.png](#fsn_phoneshtmlimgApplefleeca-bg.png)
- [fsn_phones/html/img/Apple/Garage.png](#fsn_phoneshtmlimgAppleGarage.png)
- [fsn_phones/html/img/Apple/banner_icons/garage.png](#fsn_phoneshtmlimgApplebanner_iconsgarage.png)
- [fsn_phones/html/img/Apple/banner_icons/call.png](#fsn_phoneshtmlimgApplebanner_iconscall.png)
- [fsn_phones/html/img/Apple/banner_icons/contacts.png](#fsn_phoneshtmlimgApplebanner_iconscontacts.png)
- [fsn_phones/html/img/Apple/banner_icons/adverts.png](#fsn_phoneshtmlimgApplebanner_iconsadverts.png)
- [fsn_phones/html/img/Apple/banner_icons/wallet.png](#fsn_phoneshtmlimgApplebanner_iconswallet.png)
- [fsn_phones/html/img/Apple/banner_icons/fleeca.png](#fsn_phoneshtmlimgApplebanner_iconsfleeca.png)
- [fsn_phones/html/img/Apple/banner_icons/wl.png](#fsn_phoneshtmlimgApplebanner_iconswl.png)
- [fsn_phones/html/img/Apple/banner_icons/messages.png](#fsn_phoneshtmlimgApplebanner_iconsmessages.png)
- [fsn_phones/html/img/Apple/banner_icons/mail.png](#fsn_phoneshtmlimgApplebanner_iconsmail.png)
- [fsn_phones/html/img/Apple/banner_icons/twitter.png](#fsn_phoneshtmlimgApplebanner_iconstwitter.png)
- [fsn_phones/html/img/Apple/Banner/log-inBackground.png](#fsn_phoneshtmlimgAppleBannerlog-inBackground.png)
- [fsn_phones/html/img/Apple/Banner/fleeca.png](#fsn_phoneshtmlimgAppleBannerfleeca.png)
- [fsn_phones/html/img/Apple/Banner/Yellow.png](#fsn_phoneshtmlimgAppleBannerYellow.png)
- [fsn_phones/html/img/Apple/Banner/Adverts.png](#fsn_phoneshtmlimgAppleBannerAdverts.png)
- [fsn_phones/html/img/Apple/Banner/Grey.png](#fsn_phoneshtmlimgAppleBannerGrey.png)
- [fsn_phones/darkweb/cl_order.lua](#fsn_phonesdarkwebcl_order.lua)
- [fsn_phones/datastore/messages/sample.txt](#fsn_phonesdatastoremessagessample.txt)
- [fsn_phones/datastore/contacts/sample.txt](#fsn_phonesdatastorecontactssample.txt)
- [fsn_licenses/agents.md](#fsn_licensesagents.md)
- [fsn_licenses/sv_desk.lua](#fsn_licensessv_desk.lua)
- [fsn_licenses/client.lua](#fsn_licensesclient.lua)
- [fsn_licenses/server.lua](#fsn_licensesserver.lua)
- [fsn_licenses/cl_desk.lua](#fsn_licensescl_desk.lua)
- [fsn_licenses/fxmanifest.lua](#fsn_licensesfxmanifest.lua)
- [fsn_menu/ui.html](#fsn_menuui.html)
- [fsn_menu/agents.md](#fsn_menuagents.md)
- [fsn_menu/fxmanifest.lua](#fsn_menufxmanifest.lua)
- [fsn_menu/main_client.lua](#fsn_menumain_client.lua)
- [fsn_menu/ui.js](#fsn_menuui.js)
- [fsn_menu/ui.css](#fsn_menuui.css)
- [fsn_menu/gui/ui.html](#fsn_menuguiui.html)
- [fsn_menu/gui/ui.js](#fsn_menuguiui.js)
- [fsn_menu/gui/ui.css](#fsn_menuguiui.css)
- [fsn_errorcontrol/agents.md](#fsn_errorcontrolagents.md)
- [fsn_errorcontrol/client.lua](#fsn_errorcontrolclient.lua)
- [fsn_errorcontrol/fxmanifest.lua](#fsn_errorcontrolfxmanifest.lua)
- [fsn_handling/agents.md](#fsn_handlingagents.md)
- [fsn_handling/fxmanifest.lua](#fsn_handlingfxmanifest.lua)
- [fsn_handling/src/coupes.lua](#fsn_handlingsrccoupes.lua)
- [fsn_handling/src/schafter.lua](#fsn_handlingsrcschafter.lua)
- [fsn_handling/src/sedans.lua](#fsn_handlingsrcsedans.lua)
- [fsn_handling/src/offroad.lua](#fsn_handlingsrcoffroad.lua)
- [fsn_handling/src/sportsclassics.lua](#fsn_handlingsrcsportsclassics.lua)
- [fsn_handling/src/compact.lua](#fsn_handlingsrccompact.lua)
- [fsn_handling/src/muscle.lua](#fsn_handlingsrcmuscle.lua)
- [fsn_handling/src/government.lua](#fsn_handlingsrcgovernment.lua)
- [fsn_handling/src/motorcycles.lua](#fsn_handlingsrcmotorcycles.lua)
- [fsn_handling/src/super.lua](#fsn_handlingsrcsuper.lua)
- [fsn_handling/src/suvs.lua](#fsn_handlingsrcsuvs.lua)
- [fsn_handling/src/sports.lua](#fsn_handlingsrcsports.lua)
- [fsn_handling/src/vans.lua](#fsn_handlingsrcvans.lua)
- [fsn_handling/data/handling.meta](#fsn_handlingdatahandling.meta)
- [fsn_commands/agents.md](#fsn_commandsagents.md)
- [fsn_commands/client.lua](#fsn_commandsclient.lua)
- [fsn_commands/server.lua](#fsn_commandsserver.lua)
- [fsn_commands/fxmanifest.lua](#fsn_commandsfxmanifest.lua)
- [fsn_playerlist/agents.md](#fsn_playerlistagents.md)
- [fsn_playerlist/client.lua](#fsn_playerlistclient.lua)
- [fsn_playerlist/fxmanifest.lua](#fsn_playerlistfxmanifest.lua)
- [fsn_playerlist/gui/index.html](#fsn_playerlistguiindex.html)
- [fsn_playerlist/gui/index.js](#fsn_playerlistguiindex.js)
- [fsn_builders/agents.md](#fsn_buildersagents.md)
- [fsn_builders/fxmanifest.lua](#fsn_buildersfxmanifest.lua)
- [fsn_builders/xml.lua](#fsn_buildersxml.lua)
- [fsn_builders/schema.lua](#fsn_buildersschema.lua)
- [fsn_builders/handling_builder.lua](#fsn_buildershandling_builder.lua)
- [fsn_builders/schemas/cbikehandlingdata.lua](#fsn_buildersschemascbikehandlingdata.lua)
- [fsn_builders/schemas/chandlingdata.lua](#fsn_buildersschemaschandlingdata.lua)
- [fsn_builders/schemas/ccarhandlingdata.lua](#fsn_buildersschemasccarhandlingdata.lua)
- [fsn_carstore/agents.md](#fsn_carstoreagents.md)
- [fsn_carstore/sv_carstore.lua](#fsn_carstoresv_carstore.lua)
- [fsn_carstore/fxmanifest.lua](#fsn_carstorefxmanifest.lua)
- [fsn_carstore/cl_menu.lua](#fsn_carstorecl_menu.lua)
- [fsn_carstore/cl_carstore.lua](#fsn_carstorecl_carstore.lua)
- [fsn_carstore/vehshop_server.lua](#fsn_carstorevehshop_server.lua)
- [fsn_carstore/gui/index.html](#fsn_carstoreguiindex.html)
- [fsn_evidence/agents.md](#fsn_evidenceagents.md)
- [fsn_evidence/__descriptions-male.lua](#fsn_evidence__descriptions-male.lua)
- [fsn_evidence/fxmanifest.lua](#fsn_evidencefxmanifest.lua)
- [fsn_evidence/sv_evidence.lua](#fsn_evidencesv_evidence.lua)
- [fsn_evidence/cl_evidence.lua](#fsn_evidencecl_evidence.lua)
- [fsn_evidence/__descriptions-carpaint.lua](#fsn_evidence__descriptions-carpaint.lua)
- [fsn_evidence/__descriptions-female.lua](#fsn_evidence__descriptions-female.lua)
- [fsn_evidence/__descriptions.lua](#fsn_evidence__descriptions.lua)
- [fsn_evidence/ped/sv_ped.lua](#fsn_evidencepedsv_ped.lua)
- [fsn_evidence/ped/cl_ped.lua](#fsn_evidencepedcl_ped.lua)
- [fsn_evidence/casings/cl_casings.lua](#fsn_evidencecasingscl_casings.lua)
- [fsn_jobs/agents.md](#fsn_jobsagents.md)
- [fsn_jobs/client.lua](#fsn_jobsclient.lua)
- [fsn_jobs/server.lua](#fsn_jobsserver.lua)
- [fsn_jobs/fxmanifest.lua](#fsn_jobsfxmanifest.lua)
- [fsn_jobs/hunting/client.lua](#fsn_jobshuntingclient.lua)
- [fsn_jobs/mechanic/client.lua](#fsn_jobsmechanicclient.lua)
- [fsn_jobs/mechanic/server.lua](#fsn_jobsmechanicserver.lua)
- [fsn_jobs/mechanic/mechmenu.lua](#fsn_jobsmechanicmechmenu.lua)
- [fsn_jobs/whitelists/client.lua](#fsn_jobswhitelistsclient.lua)
- [fsn_jobs/whitelists/server.lua](#fsn_jobswhitelistsserver.lua)
- [fsn_jobs/taxi/client.lua](#fsn_jobstaxiclient.lua)
- [fsn_jobs/taxi/server.lua](#fsn_jobstaxiserver.lua)
- [fsn_jobs/trucker/client.lua](#fsn_jobstruckerclient.lua)
- [fsn_jobs/tow/client.lua](#fsn_jobstowclient.lua)
- [fsn_jobs/tow/server.lua](#fsn_jobstowserver.lua)
- [fsn_jobs/farming/client.lua](#fsn_jobsfarmingclient.lua)
- [fsn_jobs/scrap/client.lua](#fsn_jobsscrapclient.lua)
- [fsn_jobs/news/client.lua](#fsn_jobsnewsclient.lua)
- [fsn_jobs/delivery/client.lua](#fsn_jobsdeliveryclient.lua)
- [fsn_jobs/garbage/client.lua](#fsn_jobsgarbageclient.lua)
- [fsn_jobs/repo/client.lua](#fsn_jobsrepoclient.lua)
- [fsn_jobs/repo/server.lua](#fsn_jobsreposerver.lua)
- [fsn_doj/agents.md](#fsn_dojagents.md)
- [fsn_doj/client.lua](#fsn_dojclient.lua)
- [fsn_doj/fxmanifest.lua](#fsn_dojfxmanifest.lua)
- [fsn_doj/attorneys/client.lua](#fsn_dojattorneysclient.lua)
- [fsn_doj/attorneys/server.lua](#fsn_dojattorneysserver.lua)
- [fsn_doj/judges/client.lua](#fsn_dojjudgesclient.lua)
- [fsn_doj/judges/server.lua](#fsn_dojjudgesserver.lua)
- [fsn_apartments/agents.md](#fsn_apartmentsagents.md)
- [fsn_apartments/client.lua](#fsn_apartmentsclient.lua)
- [fsn_apartments/server.lua](#fsn_apartmentsserver.lua)
- [fsn_apartments/fxmanifest.lua](#fsn_apartmentsfxmanifest.lua)
- [fsn_apartments/sv_instancing.lua](#fsn_apartmentssv_instancing.lua)
- [fsn_apartments/cl_instancing.lua](#fsn_apartmentscl_instancing.lua)
- [fsn_apartments/gui/ui.html](#fsn_apartmentsguiui.html)
- [fsn_apartments/gui/ui.js](#fsn_apartmentsguiui.js)
- [fsn_apartments/gui/ui.css](#fsn_apartmentsguiui.css)

### .gitignore
*Role:* shared

### agents.md
*Role:* shared
*Description:* AGENTS.md

### pipeline.yml
*Role:* shared

### README.md
*Role:* shared
*Description:* FiveM-FSN-Framework

### fsn_stripclub/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_stripclub/client.lua
*Role:* client
*Events:* register:fsn_stripclub:client:update, handler:fsn_stripclub:client:update, trigger:fsn_notify:displayNotification, trigger:fsn_stripclub:server:claimBooth, trigger:fsn_emotecontrol:play

### fsn_stripclub/server.lua
*Role:* server

### fsn_stripclub/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_doormanager/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_doormanager/client.lua
*Role:* client
*Events:* register:fsn_doormanager:doorLocked, register:fsn_doormanager:doorUnlocked, register:fsn_doormanager:sendDoors, handler:fsn_doormanager:doorLocked, handler:fsn_doormanager:doorUnlocked, handler:fsn_doormanager:sendDoors, handler:fsn_police:init, trigger:fsn_doormanager:requestDoors, trigger:fsn_doormanager:requestDoors, trigger:fsn_doormanager:unlockDoor, trigger:fsn_doormanager:lockDoor

### fsn_doormanager/sv_doors.lua
*Role:* server
*Events:* handler:fsn_doormanager:request, handler:fsn_doormanager:toggle, trigger:fsn_doormanager:request, trigger:fsn_doormanager:request

### fsn_doormanager/server.lua
*Role:* server
*Events:* handler:fsn_doormanager:unlockDoor, handler:fsn_doormanager:lockDoor, handler:fsn_doormanager:requestDoors, trigger:fsn_doormanager:doorUnlocked, trigger:fsn_doormanager:doorLocked, trigger:fsn_doormanager:sendDoors

### fsn_doormanager/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_doormanager/cl_doors.lua
*Role:* client
*Events:* register:fsn_doormanager:request, handler:fsn_doormanager:request, handler:fsn_police:init, handler:fsn_police:update, trigger:fsn_doormanager:request, trigger:fsn_doormanager:request, trigger:InteractSound_SV:PlayWithinDistance, trigger:fsn_doormanager:toggle

### fsn_entfinder/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_entfinder/client.lua
*Role:* client
*Description:* system

### fsn_entfinder/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_inventory/cl_vehicles.lua
*Role:* client
*Events:* register:fsn_inventory:veh:glovebox, handler:fsn_inventory:veh:glovebox, trigger:fsn_inventory:veh:request

### fsn_inventory/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_inventory/cl_inventory.lua
*Role:* client
*Events:* register:fsn_inventory:gui:display, register:fsn_inventory:me:update, register:fsn_inventory:ply:request, register:fsn_inventory:ply:done, register:fsn_inventory:ply:recieve, register:fsn_inventory:veh:trunk:recieve, register:fsn_inventory:veh:glovebox:recieve, register:fsn_inventory:apt:recieve, register:fsn_inventory:prop:recieve, register:fsn_inventory:pd_locker:recieve, register:fsn_inventory:store_gun:recieve, register:fsn_inventory:store:recieve, register:fsn_inventory:police_armory:recieve, register:fsn_inventory:item:take, register:fsn_inventory:items:add, register:fsn_inventory:items:addPreset, register:fsn_inventory:item:add, register:fsn_inventory:items:emptyinv, register:fsn_main:characterSaving, register:fsn_inventory:useAmmo, handler:fsn_main:character, handler:fsn_inventory:gui:display, handler:fsn_inventory:me:update, handler:fsn_inventory:ply:request, handler:fsn_inventory:ply:done, handler:fsn_inventory:ply:recieve, handler:fsn_inventory:veh:trunk:recieve, handler:fsn_inventory:veh:glovebox:recieve, handler:fsn_inventory:apt:recieve, handler:fsn_inventory:prop:recieve, handler:fsn_inventory:pd_locker:recieve, handler:fsn_inventory:store_gun:recieve, handler:fsn_inventory:store:recieve, handler:fsn_inventory:police_armory:recieve, handler:fsn_inventory:item:take, handler:fsn_inventory:items:add, handler:fsn_inventory:items:addPreset, handler:fsn_inventory:item:add, handler:fsn_inventory:items:emptyinv, handler:fsn_main:character, handler:fsn_main:characterSaving, handler:fsn_inventory:useAmmo, trigger:fsn_bank:change:walletMinus, trigger:fsn_store:boughtOne, trigger:fsn_main:characterSaving, trigger:fsn_bank:change:walletMinus, trigger:fsn_store:boughtOne, trigger:fsn_store:closedStore, trigger:fsn_store:request, trigger:fsn_main:characterSaving, trigger:fsn_bank:change:walletMinus, trigger:fsn_police:armory:boughtOne, trigger:fsn_police:armory:closedArmory, trigger:fsn_police:armory:request, trigger:fsn_main:characterSaving, trigger:fsn_inventory:ply:update, trigger:fsn_inventory:veh:update, trigger:fsn_apartments:inv:update, trigger:fsn_properties:inv:update, trigger:fsn_inventory:drops:drop, trigger:fsn_inventory:drops:drop, trigger:fsn_inventory:ply:finished, trigger:fsn_inventory:veh:finished, trigger:fsn_properties:inv:closed, trigger:fsn_inventory:locker:save, trigger:fsn_store:closedStore, trigger:fsn_police:armory:closedArmory, trigger:fsn_store:closedStore, trigger:fsn_inventory:sys:send, trigger:fsn_inventory:drops:drop, trigger:fsn_inventory:items:add, trigger:fsn_inventory:items:add, trigger:fsn_inventory:items:addPreset, trigger:fsn_licenses:giveID, trigger:fsn_inventory:database:update, trigger:fsn_main:logging:addLog, trigger:fsn_evidence:weaponInfo, trigger:fsn_main:logging:addLog, trigger:fsn_inventory:item:take
*NUI Callbacks:* dropSlot, useSlot
*NUI Messages:* SendNUIMessage

### fsn_inventory/sv_inventory.lua
*Role:* server
*Events:* handler:chatMessage, handler:fsn_inventory:sys:request, handler:fsn_inventory:sys:send, handler:fsn_inventory:ply:update, handler:fsn_inventory:ply:finished, handler:fsn_licenses:id:display, handler:fsn_inventory:item:add, trigger:fsn_inventory:ply:request, trigger:fsn_inventory:gui:display, trigger:fsn_inventory:ply:request, trigger:fsn_inventory:ply:recieve, trigger:fsn_inventory:me:update, trigger:fsn_inventory:ply:done, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_inventory:items:add, trigger:fsn_inventory:items:add, trigger:mythic_notify:SendAlert

### fsn_inventory/sv_vehicles.lua
*Role:* server
*Events:* handler:fsn_inventory:veh:request, handler:fsn_inventory:veh:finished, handler:fsn_inventory:veh:update, trigger:fsn_inventory:veh:, trigger:mythic_notify:client:SendAlert, trigger:fsn_inventory:veh:

### fsn_inventory/fxmanifest.lua
*Role:* shared
*Description:* [[/ :FSN: \]]--
*DB Calls:* MySQL.lua

### fsn_inventory/sv_presets.lua
*Role:* server
*Description:* [[
*Events:* register:fsn_inventory:sendItemsToStore, register:fsn_inventory:sendItemsToArmory, handler:fsn_inventory:sendItems, handler:fsn_inventory:sendItemsToStore, handler:fsn_inventory:sendItemsToArmory, handler:onResourceStart, trigger:fsn_inventory:recieveItems, trigger:fsn_store:recieveItemsForStore, trigger:fsn_police:armory:recieveItemsForArmory, trigger:fsn_inventory:sendItems

### fsn_inventory/cl_uses.lua
*Role:* client
*Events:* trigger:fsn_criminalmisc:houserobbery:try, trigger:fsn_inventory:rebreather:use, trigger:fsn_licenses:id:display, trigger:mythic_hospital:client:UsePainKiller, trigger:mythic_hospital:client:UsePainKiller, trigger:mythic_hospital:client:RemoveBleed, trigger:fsn_ems:ad:stopBleeding, trigger:fsn_evidence:ped:addState, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_vehiclecontrol:damage:repairkit, trigger:fsn_inventory:use:food, trigger:fsn_inventory:use:food, trigger:fsn_inventory:use:food, trigger:fsn_evidence:ped:addState, trigger:xgc-tuner:openTuner, trigger:fsn_inventory:use:food, trigger:fsn_inventory:use:food, trigger:fsn_inventory:use:food, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:use:drink, trigger:fsn_criminalmisc:lockpicking, trigger:fsn_criminalmisc:drugs:effects:weed, trigger:fsn_evidence:ped:addState, trigger:fsn_criminalmisc:drugs:effects:meth, trigger:fsn_evidence:ped:addState, trigger:mythic_hospital:client:UseAdrenaline, trigger:fsn_criminalmisc:drugs:effects:cocaine, trigger:fsn_evidence:ped:addState, trigger:fsn_criminalmisc:drugs:effects:smokeCigarette, trigger:binoculars:Activate, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:item:take, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useAmmo, trigger:fsn_inventory:useArmor

### fsn_inventory/cl_presets.lua
*Role:* client
*Events:* register:fsn_inventory:recieveItems, handler:fsn_inventory:recieveItems, trigger:fsn_inventory:sendItems

### fsn_inventory/pd_locker/sv_locker.lua
*Role:* server
*Description:* path for live server
*Events:* handler:fsn_inventory:locker:request, handler:fsn_inventory:locker:save, handler:fsn_inventory:locker:empty, trigger:mythic_notify:client:SendAlert, trigger:fsn_inventory:pd_locker:recieve, trigger:mythic_notify:client:SendAlert

### fsn_inventory/pd_locker/datastore.txt
*Role:* shared

### fsn_inventory/pd_locker/cl_locker.lua
*Role:* client
*Events:* trigger:fsn_inventory:locker:request, trigger:fsn_inventory:locker:empty

### fsn_inventory/html/ui.html
*Role:* NUI

### fsn_inventory/html/js/inventory.js
*Role:* NUI

### fsn_inventory/html/js/config.js
*Role:* NUI

### fsn_inventory/html/css/jquery-ui.css
*Role:* NUI

### fsn_inventory/html/css/ui.css
*Role:* NUI

### fsn_inventory/html/img/bullet.png
*Role:* NUI

### fsn_inventory/html/img/items/radio_receiver.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_COMBATPISTOL.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_SNIPERRIFLE.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_NIGHTSTICK.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_SMG_MK2.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_HAMMER.png

### fsn_inventory/html/img/items/WEAPON_COMBATPDW.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE.png
### fsn_inventory/html/img/items/WEAPON_DOUBLEACTION.png

### fsn_inventory/html/img/items/WEAPON_MOLOTOV.png
*Role:* NUI
### fsn_inventory/html/img/items/ammo_mg_large.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_KNIFE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_SMOKEGRENADE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER_MK2.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_REVOLVER.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE_MK2.png
*Role:* NUI
### fsn_inventory/html/img/items/ammo_mg.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_COMPACTRIFLE.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_PIPEBOMB.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_HEAVYPISTOL.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_RAYCARBINE.png
*Role:* NUI
### fsn_inventory/html/img/items/burger.png
*Role:* NUI

### fsn_inventory/html/img/items/ammo_smg_large.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_WRENCH.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_PROXMINE.png
*Role:* NUI
### fsn_inventory/html/img/items/minced_meat.png
*Role:* NUI
### fsn_inventory/html/img/items/beef_jerky.png
*Role:* NUI
### fsn_inventory/html/img/items/microwave_burrito.png
*Role:* NUI
### fsn_inventory/html/img/items/cupcake.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_BALL.png
*Role:* NUI
### fsn_inventory/html/img/items/packaged_cocaine.png
*Role:* NUI
### fsn_inventory/html/img/items/frozen_fries.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_PETROLCAN.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_GUSENBERG.png
### fsn_inventory/html/img/items/WEAPON_HATCHET.png
*Role:* NUI

### fsn_inventory/html/img/items/zipties.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_SMG.png
*Role:* NUI
### fsn_inventory/html/img/items/2g_weed.png
### fsn_inventory/html/img/items/WEAPON_ADVANCEDRIFLE.png
### fsn_inventory/html/img/items/WEAPON_STONE_HATCHET.png
### fsn_inventory/html/img/items/bandage.png
### fsn_inventory/html/img/items/modified_drillbit.png
*Role:* NUI
### fsn_inventory/html/img/items/cooked_burger.png
*Role:* NUI

### fsn_inventory/html/img/items/uncooked_meat.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_VINTAGEPISTOL.png
*Role:* NUI
### fsn_inventory/html/img/items/ammo_pistol.png
*Role:* NUI

### fsn_inventory/html/img/items/ammo_rifle_large.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_REVOLVER_MK2.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_MARKSMANPISTOL.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_HEAVYSHOTGUN.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_ASSAULTRIFLE_MK2.png
*Role:* NUI
### fsn_inventory/html/img/items/ammo_sniper_large.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_SNOWBALL.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_CARBINERIFLE_MK2.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_MICROSMG.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_BULLPUPRIFLE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_BOTTLE.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_CARBINERIFLE.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_SNSPISTOL_MK2.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_HOMINGLAUNCHER.png
*Role:* NUI

### fsn_inventory/html/img/items/phone.png
*Role:* NUI
### fsn_inventory/html/img/items/burger_bun.png
*Role:* NUI
### fsn_inventory/html/img/items/panini.png
*Role:* NUI

### fsn_inventory/html/img/items/vpn1.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_MINISMG.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_COMPACTLAUNCHER.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_SNSPISTOL.png
*Role:* NUI
### fsn_inventory/html/img/items/gas_canister.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_RAILGUN.png
*Role:* NUI
### fsn_inventory/html/img/items/phosphorus.png
*Role:* NUI
### fsn_inventory/html/img/items/empty_canister.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_RAYMINIGUN.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_HEAVYSNIPER.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_MACHETE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN.png
*Role:* NUI
### fsn_inventory/html/img/items/ammo_shotgun_large.png
*Role:* NUI
### fsn_inventory/html/img/items/lockpick.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_PISTOL50.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_RPG.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_DAGGER.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_PISTOL.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_FIREEXTINGUISHER.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_KNUCKLE.png
*Role:* NUI

### fsn_inventory/html/img/items/ammo_shotgun.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_STUNGUN.png
*Role:* NUI

### fsn_inventory/html/img/items/ammo_rifle.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_DBSHOTGUN.png
*Role:* NUI
### fsn_inventory/html/img/items/keycard.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_MG.png
*Role:* NUI
### fsn_inventory/html/img/items/tuner_chip.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_GOLFCLUB.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_SPECIALCARBINE_MK2.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_BAT.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_AUTOSHOTGUN.png
*Role:* NUI

### fsn_inventory/html/img/items/ammo_pistol_large.png
*Role:* NUI

### fsn_inventory/html/img/items/morphine.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_BATTLEAXE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_COMBATMG.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_ASSAULTSHOTGUN.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_POOLCUE.png
*Role:* NUI
### fsn_inventory/html/img/items/painkillers.png

### fsn_inventory/html/img/items/WEAPON_FIREWORK.png
### fsn_inventory/html/img/items/joint.png
### fsn_inventory/html/img/items/WEAPON_SAWNOFFSHOTGUN.png

### fsn_inventory/html/img/items/cigarette.png
### fsn_inventory/html/img/items/frozen_burger.png
### fsn_inventory/html/img/items/WEAPON_GRENADELAUNCHER.png

### fsn_inventory/html/img/items/drill.png
### fsn_inventory/html/img/items/WEAPON_PISTOL_MK2.png
### fsn_inventory/html/img/items/WEAPON_RAYPISTOL.png
### fsn_inventory/html/img/items/WEAPON_APPISTOL.png
*Role:* NUI
### fsn_inventory/html/img/items/ecola.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_FLARE.png
### fsn_inventory/html/img/items/evidence.png
*Role:* NUI
### fsn_inventory/html/img/items/armor.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_STICKYBOMB.png
*Role:* NUI
### fsn_inventory/html/img/items/meth_rocks.png
*Role:* NUI
### fsn_inventory/html/img/items/dirty_money.png
*Role:* NUI
### fsn_inventory/html/img/items/water.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_PUMPSHOTGUN_MK2.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_ASSAULTSMG.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_BULLPUPSHOTGUN.png
*Role:* NUI
### fsn_inventory/html/img/items/cooked_meat.png
*Role:* NUI
### fsn_inventory/html/img/items/ammo_sniper.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_GRENADE.png
*Role:* NUI
### fsn_inventory/html/img/items/ammo_smg.png
*Role:* NUI
### fsn_inventory/html/img/items/fries.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_MACHINEPISTOL.png
*Role:* NUI

### fsn_inventory/html/img/items/id.png
*Role:* NUI
### fsn_inventory/html/img/items/coffee.png
*Role:* NUI

### fsn_inventory/html/img/items/WEAPON_SWITCHBLADE.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_FLASHLIGHT.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_CROWBAR.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_COMBATMG_MK2.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_MINIGUN.png
*Role:* NUI

### fsn_inventory/html/img/items/pepsi_max.png
### fsn_inventory/html/img/items/repair_kit.png
### fsn_inventory/html/img/items/WEAPON_MARKSMANRIFLE_MK2.png
### fsn_inventory/html/img/items/WEAPON_FLAREGUN.png
### fsn_inventory/html/img/items/pepsi.png
### fsn_inventory/html/img/items/vpn2.png
### fsn_inventory/html/img/items/binoculars.png

### fsn_inventory/html/img/items/acetone.png
*Role:* NUI
### fsn_inventory/html/img/items/WEAPON_MUSKET.png

### fsn_inventory/html/locales/en.js
### fsn_inventory/html/locales/fr.js

### fsn_inventory/html/locales/cs.js
*Role:* NUI
### fsn_inventory/_old/client.lua
*Description:* [[The MIT License (MIT)
*Events:* register:fsn_dev:debug, register:fsn_police:search:start:inventory, register:fsn_inventory:empty, register:fsn_inventory:floor:update, register:fsn_inventory:itemhasdropped, register:fsn_inventory:removedropped, register:fsn_inventory:item:drop, register:fsn_inventory:item:give, register:fsn_inventory:item:use, register:fsn_inventory:item:add, register:fsn_inventory:item:take, register:fsn_inventory:initChar, register:fsn_inventory:init, register:fsn_menu:requestInventory, register:fsn_inventory:update, register:fsn_inventory:prebuy, register:fsn_inventory:buyItem, handler:fsn_dev:debug, handler:fsn_police:search:start:inventory, handler:fsn_inventory:empty, handler:fsn_inventory:floor:update, handler:fsn_inventory:itemhasdropped, handler:fsn_inventory:removedropped, handler:fsn_inventory:item:drop, handler:fsn_inventory:item:give, handler:fsn_inventory:item:use, handler:fsn_inventory:item:add, handler:fsn_inventory:item:take, handler:fsn_inventory:initChar, handler:fsn_menu:requestInventory, handler:fsn_inventory:prebuy, trigger:fsn_police:search:end:inventory, trigger:fsn_inventory:database:update, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:itempickup, trigger:fsn_inventory:item:add, trigger:fsn_inventory:itempickup, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_commands:me, trigger:fsn_inventory:item:dropped, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:database:update, trigger:fsn_inventory:database:update, trigger:chatMessage, trigger:fsn_inventory:init, trigger:fsn_inventory:update, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:buyItem
### fsn_inventory/_old/server.lua
*Events:* handler:fsn_inventory:item:dropped, handler:fsn_inventory:itempickup, trigger:fsn_main:logging:addLog, trigger:fsn_inventory:floor:update, trigger:fsn_inventory:itemhasdropped, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:removedropped, trigger:fsn_inventory:item:add, trigger:fsn_main:logging:addLog, trigger:fsn_inventory:floor:update, trigger:fsn_inventory:floor:update, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification
### fsn_inventory/_old/pedfinder.lua
*Role:* shared
### fsn_inventory/_old/items.lua
*Events:* trigger:mythic_hospital:client:UsePainKiller, trigger:mythic_hospital:client:UsePainKiller, trigger:fsn_inventory:item:take, trigger:mythic_hospital:client:UsePainKiller, trigger:fsn_inventory:item:take, trigger:mythic_hospital:client:RemoveBleed, trigger:fsn_ems:ad:stopBleeding, trigger:fsn_evidence:ped:addState, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:drugs:streetselling:area, trigger:fsn_vehiclecontrol:damage:repairkit, trigger:fsn_inventory:use:food, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:food, trigger:fsn_inventory:item:take, trigger:fsn_evidence:ped:addState, trigger:fsn_inventory:use:food, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:food, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:food, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:item:take, trigger:fsn_criminalmisc:lockpicking, trigger:fsn_phone:togglePhone, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:drugs:effects:weed, trigger:fsn_evidence:ped:addState, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:drugs:effects:meth, trigger:fsn_inventory:item:take, trigger:fsn_evidence:ped:addState, trigger:mythic_hospital:client:UseAdrenaline, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:drugs:effects:cocaine, trigger:fsn_evidence:ped:addState, trigger:fsn_inventory:item:take, trigger:binoculars:Activate, trigger:fsn_inventory:use:food, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:food, trigger:fsn_inventory:item:take, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:item:take, trigger:fsn_inventory:item:take, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_inventory/_old/_item_misc/_drug_selling.lua
*Description:* Drug stuffs
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification
### fsn_inventory/_item_misc/cl_breather.lua
*Events:* register:fsn_inventory:rebreather:use, handler:fsn_inventory:rebreather:use, trigger:fsn_bank:change:walletMinus, trigger:fsn_inventory:items:add
### fsn_inventory/_item_misc/burger_store.lua
*Events:* trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletAdd, trigger:fsn_bank:change:walletAdd, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification
### fsn_inventory/_item_misc/dm_laundering.lua
*Role:* shared
*Description:* LAUNDERING
*Events:* trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletAdd, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_inventory:item:take, trigger:fsn_bank:change:walletMinus, trigger:chatMessage, trigger:chatMessage, trigger:pNotify:SendNotification

### fsn_inventory/_item_misc/binoculars.lua
*Role:* shared
*Description:* CONFIG--
*Events:* register:binoculars:Activate, handler:binoculars:Activate

### fsn_progress/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_progress/client.lua
### fsn_progress/fxmanifest.lua
### fsn_progress/gui/index.html
### fsn_progress/gui/index.js
*Role:* shared
### fsn_bennys/agents.md
*Role:* shared
### fsn_bennys/fxmanifest.lua
*Role:* shared
*DB Calls:* MySQL.lua
### fsn_bennys/menu.lua
*Description:* [[
### fsn_bennys/cl_config.lua
*Role:* client

### fsn_bennys/cl_bennys.lua
*Role:* client

### fsn_bank/agents.md
### fsn_bank/client.lua
*Role:* client
*Events:* register:fsn_bank:change:bankandwallet, register:fsn_bank:request:both, register:fsn_bank:update:both, handler:fsn_bank:update:both, trigger:fsn_bank:request:both, trigger:fsn_main:displayBankandMoney, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_phones:SYS:addTransaction, trigger:fsn_bank:change:bankandwallet, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_phones:SYS:addTransaction, trigger:fsn_bank:change:bankandwallet, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:transfer, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification
*NUI Callbacks:* depositMoney, withdrawMoney, transferMoney, toggleGUI
*NUI Messages:* SendNUIMessage

### fsn_bank/server.lua
*Events:* handler:fsn_bank:database:update, handler:fsn_bank:transfer, trigger:fsn_bank:change:bankAdd, trigger:fsn_bank:change:bankMinus, trigger:fsn_notify:displayNotification
*DB Calls:* MySQL.Sync
### fsn_bank/fxmanifest.lua
### fsn_bank/gui/atm_button_sound.mp3
### fsn_bank/gui/index.html
*Role:* NUI
### fsn_bank/gui/index.css
*Role:* NUI
### fsn_bank/gui/atm_logo.png

### fsn_bank/gui/index.js
*Role:* shared
### fsn_customs/lscustoms.lua
*Role:* shared
*Events:* handler:onClientResourceStart, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:updateVehicle, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus
### fsn_customs/agents.md
### fsn_customs/fxmanifest.lua
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_dev/config.lua
### fsn_dev/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_dev/fxmanifest.lua
*Role:* shared
*DB Calls:* MySQL.lua
### fsn_dev/oldresource.lua
### fsn_dev/client/client.lua
*Role:* client
*Events:* register:fsn_developer:deleteVehicle, register:fsn_developer:spawnVehicle, register:fsn_developer:fixVehicle, register:fsn_developer:getKeys, register:fsn_developer:sendXYZ, handler:fsn_developer:deleteVehicle, handler:fsn_developer:spawnVehicle, handler:fsn_developer:fixVehicle, handler:fsn_developer:getKeys, handler:fsn_developer:sendXYZ, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_fuel:update, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_developer:printXYZ
### fsn_dev/client/cl_noclip.lua
*Role:* client
*Description:* https://github.com/blattersturm/expeditious-execution/blob/master/resources/%5Bexpeditious%5D/execution-noclip/execution-noclip.js
*Events:* register:fsn_developer:noClip:enabled, handler:freecam:onTick, handler:fsn_developer:noClip:enabled
### fsn_dev/server/server.lua
*Events:* register:fsn_developer:enableDeveloperCommands, register:fsn:playerReady, handler:fsn_developer:printXYZ, handler:fsn_developer:enableDeveloperCommands, handler:fsn:playerReady, trigger:fsn:getFsnObject, trigger:xgc-tuner:openTuner, trigger:fsn_inventory:ply:request, trigger:chat:addMessage, trigger:fsn_main:charMenu, trigger:fsn_commands:police:pedrevive, trigger:fsn_commands:police:pedcarry, trigger:fsn_bank:change:walletAdd, trigger:fsn_bank:change:walletAdd, trigger:chat:addMessage, trigger:chat:addMessage, trigger:fsn_police:command:duty, trigger:chat:addMessage, trigger:fsn_licenses:setInfractions, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:fsn_apartments:instance:debug, trigger:fsn_police:MDT:toggle, trigger:fsn_ems:reviveMe:force, trigger:fsn_developer:sendXYZ, trigger:fsn_developer:spawnVehicle, trigger:chat:addMessage, trigger:fsn_developer:getKeys, trigger:fsn_developer:fixVehicle, trigger:fsn_developer:deleteVehicle, trigger:fsn_inventory:item:add, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:fsn_ems:killMe, trigger:chat:addMessage, trigger:fsn_teleporters:teleport:waypoint, trigger:fsn_teleporters:teleport:coordinates, trigger:fsn_developer:noClip:enabled, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:fsn_developer:enableDeveloperCommands
*Commands:* tuner, inv, softlog, reviveplayer, carryplayer, addmoney, pdduty, setinfractions, debug, insidedebug, mdt, revive, xyz, spawnveh, getkeys, fixveh, dv, giveitem, kill, tpm, tpc, noclip
### fsn_loadingscreen/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_loadingscreen/fxmanifest.lua
*Role:* shared
### fsn_loadingscreen/index.html
*Role:* NUI

### fsn_steamlogin/agents.md
### fsn_steamlogin/client.lua
### fsn_steamlogin/fxmanifest.lua
### fsn_jail/agents.md

### fsn_jail/client.lua
*Role:* client
*Events:* register:fsn_jail:spawn:recieve, register:fsn_jail:sendme, register:fsn_jail:releaseme, register:fsn_jail:init, handler:fsn_jail:spawn:recieve, handler:fsn_jail:sendme, handler:fsn_jail:releaseme, handler:fsn_jail:init, trigger:fsn_jail:sendme, trigger:fsn_jail:update:database, trigger:pNotify:SendNotification, trigger:fsn_hungerandthirst:pause, trigger:fsn_jail:update:database, trigger:pNotify:SendNotification, trigger:fsn_hungerandthirst:unpause, trigger:fsn_jail:spawn, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_jail:releaseme, trigger:fsn_jail:update:database
### fsn_jail/server.lua
*Events:* handler:fsn_main:updateCharacters, handler:fsn_jail:spawn, handler:fsn_jail:sendsuspect, handler:fsn_jail:update:database, trigger:fsn_jail:spawn:recieve, trigger:pNotify:SendNotification, trigger:fsn_jail:spawn:recieve, trigger:pNotify:SendNotification
*DB Calls:* MySQL.Async
### fsn_jail/fxmanifest.lua

### fsn_bankrobbery/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_bankrobbery/trucks.lua
*Role:* shared
*Events:* trigger:fs_freemode:displaytext, trigger:fsn_notify:displayNotification, trigger:fs_freemode:missionComplete, trigger:fsn_inventory:item:add, trigger:fsn_phone:recieveMessage, trigger:fs_freemode:notify

### fsn_bankrobbery/client.lua
*Role:* client
*Events:* register:fsn_bankrobbery:timer, register:fsn_bankrobbery:init, register:fsn_bankrobbery:openDoor, register:fsn_bankrobbery:closeDoor, register:fsn_bankrobbery:LostMC:spawn, handler:fsn_bankrobbery:timer, handler:fsn_main:character, handler:fsn_bankrobbery:init, handler:fsn_bankrobbery:openDoor, handler:fsn_bankrobbery:closeDoor, handler:fsn_bankrobbery:LostMC:spawn, trigger:fsn_bankrobbery:init, trigger:fsn_bankrobbery:openDoor, trigger:fsn_bankrobbery:closeDoor, trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch, trigger:fsn_bankrobbery:payout, trigger:fsn_inventory:item:take, trigger:chatMessage, trigger:chatMessage, trigger:fsn_inventory:item:take, trigger:chatMessage, trigger:fsn_bankrobbery:payout, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bankrobbery:vault:close, trigger:fsn_bankrobbery:vault:close, trigger:fsn_bankrobbery:vault:open, trigger:fsn_police:dispatch, trigger:fsn_police:dispatch, trigger:fsn_bankrobbery:start, trigger:fsn_bankrobbery:start, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add
### fsn_bankrobbery/cl_safeanim.lua
*Role:* client
*Events:* register:safecracking:start, register:safecracking:loop, handler:safecracking:start, handler:safecracking:loop, trigger:DoLongHudText, trigger:safecracking:loop, trigger:safe:success, trigger:safecracking:start
### fsn_bankrobbery/server.lua
*Events:* handler:fsn_main:money:bank:Add, handler:fsn_main:money:bank:Minus, handler:fsn_bankrobbery:vault:open, handler:fsn_bankrobbery:start, handler:fsn_bankrobbery:vault:close, handler:fsn_bankrobbery:init, handler:fsn_bankrobbery:payout, trigger:fsn_bankrobbery:timer, trigger:fsn_bankrobbery:timer, trigger:fsn_bankrobbery:openDoor, trigger:fsn_bankrobbery:closeDoor, trigger:fsn_bankrobbery:init, trigger:fsn_bankrobbery:timer, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_needs:stress:add, trigger:fsn_notify:displayNotification

### fsn_bankrobbery/cl_frontdesks.lua
*Events:* register:fsn_bankrobbery:desks:receive, handler:fsn_bankrobbery:desks:receive, trigger:fsn_bankrobbery:desks:request, trigger:fsn_bankrobbery:desks:startHack, trigger:fsn_bankrobbery:desks:endHack, trigger:fsn_needs:stress:add, trigger:mhacking:hide, trigger:fsn_bankrobbery:desks:endHack, trigger:fsn_needs:stress:add, trigger:mhacking:hide, trigger:mhacking:show, trigger:mhacking:start

### fsn_bankrobbery/sv_frontdesks.lua
*Role:* server
*Events:* handler:fsn_bankrobbery:desks:doorUnlock, handler:fsn_bankrobbery:desks:request, handler:fsn_bankrobbery:desks:startHack, handler:fsn_bankrobbery:desks:endHack, trigger:fsn_bankrobbery:desks:receive, trigger:fsn_bankrobbery:desks:receive, trigger:fsn_bankrobbery:desks:receive, trigger:fsn_bank:change:bankAdd, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_bankrobbery:desks:receive

### fsn_bankrobbery/fxmanifest.lua
### fsn_jewellerystore/agents.md
### fsn_jewellerystore/client.lua
*Role:* client
*Events:* register:fsn_commands:police:lock, register:fsn_jewellerystore:doors:State, register:fsn_jewellerystore:gasDoor:toggle, register:fsn_jewellerystore:cases:update, register:fsn_jewellerystore:case:startrob, handler:fsn_commands:police:lock, handler:fsn_jewellerystore:doors:State, handler:fsn_jewellerystore:gasDoor:toggle, handler:fsn_jewellerystore:cases:update, handler:fsn_jewellerystore:case:startrob, trigger:fsn_jewellerystore:doors:toggle, trigger:fsn_police:dispatch, trigger:fsn_inventory:item:add, trigger:fsn_police:dispatch, trigger:fsn_inventory:gasDoorunlock, trigger:fsn_inventory:item:add, trigger:fsn_jewellerystore:case:rob

### fsn_jewellerystore/server.lua
*Role:* server
*Events:* handler:fsn_jewellerystore:doors:Lock, handler:fsn_inventory:gasDoorunlock, handler:fsn_jewellerystore:case:rob, handler:fsn_jewellerystore:cases:request, trigger:fsn_jewellerystore:doors:State, trigger:fsn_jewellerystore:doors:State, trigger:fsn_jewellerystore:gasDoor:toggle, trigger:fsn_police:911, trigger:fsn_jewellerystore:gasDoor:toggle, trigger:fsn_notify:displayNotification, trigger:fsn_jewellerystore:case:startrob, trigger:fsn_jewellerystore:cases:update, trigger:fsn_jewellerystore:cases:update, trigger:fsn_notify:displayNotification, trigger:fsn_jewellerystore:cases:update

### fsn_jewellerystore/fxmanifest.lua

### fsn_gangs/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_gangs/fxmanifest.lua
### fsn_gangs/cl_gangs.lua
*Events:* register:fsn_gangs:recieve, register:fsn_gangs:hideout:enter, register:fsn_gangs:hideout:leave, handler:fsn_gangs:recieve, handler:fsn_gangs:hideout:enter, handler:fsn_gangs:hideout:leave, trigger:fsn_gangs:tryTakeOver, trigger:fsn_gangs:tryTakeOver, trigger:fsn_gangs:hideout:leave, trigger:fsn_gangs:hideout:leave, trigger:fsn_gangs:hideout:enter, trigger:fsn_gangs:garage:enter, trigger:mythic_notify:client:SendAlert, trigger:fsn_gangs:request

### fsn_gangs/sv_gangs.lua
*Role:* server
*Events:* handler:fsn_gangs:request, handler:fsn_gangs:inventory:request, handler:fsn_gangs:tryTakeOver, handler:fsn_gangs:garage:enter, handler:fsn_gangs:hideout:enter, handler:fsn_gangs:hideout:leave, trigger:fsn_gangs:recieve, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_gangs:hideout:enter, trigger:mythic_notify:client:SendAlert, trigger:fsn_gangs:hideout:enter, trigger:mythic_notify:client:SendAlert, trigger:fsn_gangs:hideout:leave, trigger:fsn_gangs:hideout:leave
### fsn_weaponcontrol/agents.md
### fsn_weaponcontrol/client.lua
*Events:* trigger:fsn_notify:displayNotification

### fsn_weaponcontrol/server.lua
*Role:* server

### fsn_weaponcontrol/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_properties/agents.md
### fsn_properties/cl_manage.lua
*Events:* register:fsn_properties:keys:give, handler:fsn_properties:keys:give
### fsn_properties/cl_properties.lua
*Role:* client
*Events:* register:fsn_properties:updateXYZ, register:fsn_properties:access, register:fsn_properties:inv:update, register:fsn_properties:inv:closed, handler:fsn_main:character, handler:fsn_properties:updateXYZ, handler:fsn_properties:access, handler:fsn_properties:inv:update, handler:fsn_properties:inv:closed, trigger:fsn_properties:request, trigger:fsn_properties:requestKeys, trigger:fsn_properties:access, trigger:fsn_criminalmisc:weapons:destroy, trigger:fsn_criminalmisc:weapons:add:tbl, trigger:fsn_properties:rent:check, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletAdd, trigger:fsn_properties:leave, trigger:chatMessage, trigger:fsn_properties:rent:pay, trigger:fsn_properties:buy, trigger:fsn_inventory:prop:recieve
*NUI Messages:* SendNUIMessage

### fsn_properties/fxmanifest.lua

### fsn_properties/sv_properties.lua
*Role:* server
*Events:* handler:fsn_properties:request, handler:fsn_properties:access, handler:fsn_properties:leave, handler:fsn_properties:rent:check, handler:fsn_properties:rent:pay, handler:fsn_properties:buy, handler:fsn_properties:realator:clock, trigger:fsn_properties:updateXYZ, trigger:fsn_properties:updateXYZ, trigger:mythic_notify:client:SendAlert, trigger:fsn_properties:access, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:chatMessage, trigger:chatMessage, trigger:fsn_bank:change:walletMinus, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_properties:updateXYZ, trigger:fsn_bank:change:walletMinus, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert
*DB Calls:* MySQL.Async, MySQL.Sync, MySQL.ready
### fsn_properties/sv_conversion.lua
### fsn_properties/nui/ui.html
*Role:* NUI
### fsn_properties/nui/ui.js
*Role:* shared
### fsn_properties/nui/ui.css
*Role:* NUI

### fsn_activities/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_activities/fxmanifest.lua
*DB Calls:* MySQL.lua

### fsn_activities/fishing/client.lua
*Role:* client
*Description:* To do - Crutchie
### fsn_activities/hunting/client.lua
*Description:* to do I noticed on in fsn_jobs but might move hunting to activities instead. still debating -Crutchie
### fsn_activities/yoga/client.lua
*Role:* client
*Events:* register:fsn_yoga:checkStress, handler:fsn_yoga:checkStress, trigger:fsn_yoga:checkStress, trigger:fsn_needs:stress:remove
### fsn_vehiclecontrol/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_vehiclecontrol/client.lua
*Role:* client
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch

### fsn_vehiclecontrol/fxmanifest.lua
### fsn_vehiclecontrol/aircontrol/aircontrol.lua
*Description:* Vehicles to enable/disable air control
### fsn_vehiclecontrol/speedcameras/client.lua
*Events:* register:fsn_vehiclecontrol:flagged:add, handler:fsn_vehiclecontrol:flagged:add, trigger:fsn_police:dispatch, trigger:fsn_police:dispatch
### fsn_vehiclecontrol/carwash/client.lua
*Description:* fsn_GetWallet
*Events:* trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification
### fsn_vehiclecontrol/holdup/client.lua
*Role:* client
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletAdd, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch
### fsn_vehiclecontrol/keys/server.lua
*Events:* handler:fsn_vehiclecontrol:givekeys, trigger:fsn_vehiclecontrol:getKeys
### fsn_vehiclecontrol/inventory/client.lua
### fsn_vehiclecontrol/inventory/server.lua
*Role:* server
### fsn_vehiclecontrol/fuel/client.lua
*Role:* client
*Events:* register:fsn_fuel:set, register:fsn_fuel:update, handler:fsn_fuel:set, handler:fsn_fuel:update, trigger:fsn_fuel:update, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus
### fsn_vehiclecontrol/fuel/server.lua
*Role:* server
*Events:* handler:fsn_fuel:update, trigger:fsn_fuel:update
### fsn_vehiclecontrol/engine/client.lua
*Role:* client
*Events:* register:fsn_vehiclecontrol:getKeys, register:fsn_vehiclecontrol:giveKeys, register:EngineToggle:Engine, register:EngineToggle:RPDamage, register:fsn_vehiclecontrol:keys:carjack, handler:fsn_vehiclecontrol:getKeys, handler:fsn_vehiclecontrol:giveKeys, handler:fsn_vehiclecontrol:keys:carjack, handler:EngineToggle:Engine, handler:EngineToggle:RPDamage, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_vehiclecontrol:givekeys, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:EngineToggle:Engine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_commands:me
### fsn_vehiclecontrol/odometer/client.lua
*Role:* client
*Events:* trigger:fsn_odometer:addMileage, trigger:fsn_odometer:addMileage
### fsn_vehiclecontrol/odometer/server.lua
*Role:* server
*Events:* handler:fsn_odometer:getMileage, handler:fsn_odometer:addMileage, handler:fsn_odometer:setMileage, handler:fsn_odometer:resetMileage, trigger:fsn_odometer:setMileage
*DB Calls:* MySQL.Async, MySQL.ready
### fsn_vehiclecontrol/trunk/client.lua
*Role:* client
*Events:* register:fsn_vehiclecontrol:trunk:forceIn, register:fsn_vehiclecontrol:trunk:forceOut, handler:fsn_vehiclecontrol:trunk:forceIn, handler:fsn_vehiclecontrol:trunk:forceOut, trigger:fsn_ems:carry:end, trigger:fsn_vehiclecontrol:trunk:forceIn, trigger:fsn_inventory:veh:request
### fsn_vehiclecontrol/trunk/server.lua
*Role:* server
*Events:* handler:fsn_vehiclecontrol:trunk:forceIn, trigger:fsn_vehiclecontrol:trunk:forceIn

### fsn_vehiclecontrol/damage/config.lua
*Role:* shared
### fsn_vehiclecontrol/damage/client.lua
*Role:* client
*Events:* register:fsn_vehiclecontrol:damage:repair, register:fsn_vehiclecontrol:damage:repairkit, handler:fsn_vehiclecontrol:damage:repair, handler:fsn_vehiclecontrol:damage:repairkit, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_vehiclecontrol/damage/cl_crashes.lua
*Role:* client
*Events:* trigger:fsn_police:dispatch
### fsn_vehiclecontrol/compass/streetname.lua
*Role:* shared
### fsn_vehiclecontrol/compass/essentials.lua
*Role:* shared
*Description:* DrawText method wrapper, draws text to the screen.
### fsn_vehiclecontrol/compass/compass.lua
*Role:* shared
### fsn_vehiclecontrol/carhud/carhud.lua
*Role:* shared
### fsn_needs/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_needs/client.lua
*Role:* client
*Events:* register:fsn_hungerandthirst:pause, register:fsn_hungerandthirst:unpause, register:fsn_ems:reviveMe, register:fsn_inventory:use:food, register:fsn_inventory:use:drink, register:fsn_needs:stress:add, register:fsn_needs:stress:remove, handler:fsn_inventory:initChar, handler:fsn_hungerandthirst:pause, handler:fsn_hungerandthirst:unpause, handler:fsn_ems:reviveMe, handler:fsn_inventory:use:food, handler:fsn_inventory:use:drink, handler:fsn_needs:stress:add, handler:fsn_needs:stress:remove, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_ems:killMe, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_ems:killMe, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_needs:stress:add, trigger:fsn_needs:stress:add
### fsn_needs/vending.lua
*Role:* shared
*Events:* trigger:fsn_inventory:use:drink, trigger:fsn_bank:change:walletMinus, trigger:fsn_inventory:use:drink, trigger:fsn_bank:change:walletMinus
### fsn_needs/fxmanifest.lua
*Role:* shared
### fsn_needs/hud.lua
*Role:* shared
*Events:* register:fsn_inventory:useArmor, handler:fsn_inventory:useArmor, trigger:fsn_inventory:item:take

### fsn_ems/debug_kng.lua
*Role:* shared
### fsn_ems/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_ems/client.lua
*Role:* client
*Events:* register:fsn_ems:update, register:fsn_ems:reviveMe:force, register:fsn_ems:reviveMe, register:fsn_ems:killMe, register:fsn_ems:911r, register:fsn_ems:911, register:fsn_ems:updateLevel, register:fsn_jobs:ems:request, handler:fsn_ems:update, handler:fsn_ems:reviveMe:force, handler:fsn_ems:reviveMe, handler:fsn_ems:killMe, handler:fsn_ems:911r, handler:fsn_ems:911, handler:fsn_main:character, handler:fsn_ems:updateLevel, handler:fsn_jobs:ems:request, trigger:fsn_ems:killMe, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:use:food, trigger:fsn_needs:stress:remove, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:use:food, trigger:fsn_needs:stress:remove, trigger:fsn_police:dispatch, trigger:fsn_police:CAD:10-43, trigger:fsn_ems:CAD:10-43, trigger:fsn_bank:change:bankandwallet, trigger:fsn_inventory:items:emptyinv, trigger:fsn_inventory:use:drink, trigger:fsn_inventory:use:food, trigger:fsn_needs:stress:remove, trigger:mythic_hospital:client:ResetLimbs, trigger:mythic_hospital:client:RemoveBleed, trigger:fsn_bank:change:bankMinus, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:chatMessage, trigger:chatMessage, trigger:fsn_ems:requestUpdate, trigger:fsn_ems:requestUpdate, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_ems:offDuty, trigger:fsn_notify:displayNotification, trigger:fsn_ems:onDuty, trigger:fsn_police:dispatchcall, trigger:chatMessage, trigger:chatMessage, trigger:fsn_main:blip:add, trigger:fsn_notify:displayNotification, trigger:fsn_ems:reviveMe, trigger:fsn_notify:displayNotification, trigger:fsn_ems:reviveMe, trigger:fsn_bank:change:bankMinus
### fsn_ems/server.lua
*Role:* server
*Events:* handler:fsn_ems:onDuty, handler:fsn_ems:offDuty, handler:playerDropped, handler:fsn_ems:requestUpdate, trigger:fsn_ems:update, trigger:fsn_ems:update, trigger:fsn_ems:update, trigger:fsn_ems:update, trigger:fsn_ems:update, trigger:fsn_ems:update

### fsn_ems/blip.lua
*Role:* shared
### fsn_ems/sv_carrydead.lua
*Role:* server
*Events:* handler:fsn_ems:carry:start, handler:fsn_ems:carry:end, trigger:fsn_ems:carry:start, trigger:fsn_ems:carried:start, trigger:fsn_ems:carry:end, trigger:fsn_ems:carried:end
### fsn_ems/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_ems/cl_advanceddamage.lua
*Role:* client
*Events:* register:fsn_ems:ad:stopBleeding, register:fsn_ems:adamage:request, register:fsn_ems:set:WalkType, register:mythic_hospital:client:SyncBleed, register:mythic_hospital:client:FieldTreatLimbs, register:mythic_hospital:client:ResetLimbs, register:mythic_hospital:client:FieldTreatBleed, register:mythic_hospital:client:ReduceBleed, register:mythic_hospital:client:RemoveBleed, register:mythic_hospital:client:UsePainKiller, register:mythic_hospital:client:UseAdrenaline, handler:fsn_ems:ad:stopBleeding, handler:fsn_ems:adamage:request, handler:fsn_ems:set:WalkType, handler:mythic_hospital:client:SyncBleed, handler:mythic_hospital:client:FieldTreatLimbs, handler:mythic_hospital:client:ResetLimbs, handler:mythic_hospital:client:FieldTreatBleed, handler:mythic_hospital:client:ReduceBleed, handler:mythic_hospital:client:RemoveBleed, handler:mythic_hospital:client:UsePainKiller, handler:mythic_hospital:client:UseAdrenaline, trigger:fsn_commands:ems:adamage:inspect, trigger:fsn_evidence:ped:updateDamage, trigger:mythic_hospital:server:SyncInjuries, trigger:mythic_hospital:server:SyncInjuries, trigger:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:drop:blood

### fsn_ems/cl_carrydead.lua
*Role:* client
*Description:* carry dead people not escort
*Events:* register:fsn_ems:carried:start, register:fsn_ems:carry:start, register:fsn_ems:carried:end, register:fsn_ems:carry:end, handler:fsn_ems:carried:start, handler:fsn_ems:carry:start, handler:fsn_ems:carried:end, handler:fsn_ems:carry:end, trigger:fsn_vehiclecontrol:trunk:forceOut, trigger:fsn_ems:carry:start, trigger:fsn_criminalmisc:robbing:startRobbing, trigger:fsn_ems:carry:end

### fsn_ems/info.txt
*Role:* shared
### fsn_ems/cl_volunteering.lua
*Role:* client

### fsn_ems/beds/client.lua
*Role:* client
*Events:* register:fsn_ems:bed:update, handler:fsn_ems:bed:update, trigger:fsn_notify:displayNotification, trigger:mythic_hospital:client:ResetLimbs, trigger:mythic_hospital:client:RemoveBleed, trigger:fsn_notify:displayNotification, trigger:fsn_ems:bed:health, trigger:fsn_ems:bed:occupy, trigger:fsn_ems:bed:occupy, trigger:fsn_ems:reviveMe, trigger:fsn_notify:displayNotification, trigger:fsn_ems:bed:restraintoggle, trigger:fsn_ems:bed:restraintoggle, trigger:fsn_ems:bed:occupy, trigger:fsn_ems:reviveMe
### fsn_ems/beds/server.lua
*Role:* server
*Events:* register:fsn_ems:bed:occupy, register:fsn_ems:bed:leave, register:fsn_ems:bed:restraintoggle, register:fsn_ems:bed:health, handler:fsn_ems:bed:health, handler:fsn_ems:bed:restraintoggle, handler:fsn_ems:bed:occupy, handler:fsn_ems:bed:leave, trigger:fsn_ems:bed:update, trigger:fsn_ems:bed:update, trigger:fsn_ems:bed:update, trigger:fsn_ems:bed:update

### fsn_emotecontrol/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_emotecontrol/client.lua
*Role:* client
*Events:* register:fsn_emotecontrol:play, register:fsn_emotecontrol:phone:call1, register:fsn_emotecontrol:dice:roll, register:fsn_emotecontrol:police:ticket, register:fsn_emotecontrol:police:tablet, handler:fsn_emotecontrol:play, handler:fsn_emotecontrol:phone:call1, handler:fsn_emotecontrol:dice:roll, handler:fsn_emotecontrol:police:ticket, handler:fsn_emotecontrol:police:tablet, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:me

### fsn_emotecontrol/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_emotecontrol/walktypes/client.lua
*Role:* client
*Events:* register:AnimSet:default, register:AnimSet:Hurry, register:AnimSet:Business, register:AnimSet:Brave, register:AnimSet:Tipsy, register:AnimSet:Injured, register:AnimSet:ToughGuy, register:AnimSet:Sassy, register:AnimSet:Sad, register:AnimSet:Posh, register:AnimSet:Alien, register:AnimSet:NonChalant, register:AnimSet:Hobo, register:AnimSet:Money, register:AnimSet:Swagger, register:AnimSet:Joy, register:AnimSet:Moon, register:AnimSet:Shady, register:AnimSet:Tired, register:AnimSet:Sexy, register:AnimSet:ManEater, register:AnimSet:ChiChi, handler:AnimSet:default, handler:AnimSet:Hurry, handler:AnimSet:Business, handler:AnimSet:Brave, handler:AnimSet:Tipsy, handler:AnimSet:Injured, handler:AnimSet:ToughGuy, handler:AnimSet:Sassy, handler:AnimSet:Sad, handler:AnimSet:Posh, handler:AnimSet:Alien, handler:AnimSet:NonChalant, handler:AnimSet:Hobo, handler:AnimSet:Money, handler:AnimSet:Swagger, handler:AnimSet:Joy, handler:AnimSet:Moon, handler:AnimSet:Shady, handler:AnimSet:Tired, handler:AnimSet:Sexy, handler:AnimSet:ManEater, handler:AnimSet:ChiChi, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData, trigger:police:setAnimData
### fsn_newchat/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_newchat/sv_chat.lua
*Role:* server
*Events:* handler:_chat:messageEntered, handler:__cfx_internal:commandFallback, handler:chat:init, handler:playerDropped, handler:chat:init, handler:onServerResourceStart, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_main:logging:addLog, trigger:chatMessage, trigger:fsn_main:logging:addLog, trigger:chatMessage, trigger:chat:addSuggestions
*Commands:* say
### fsn_newchat/fxmanifest.lua
*Role:* shared
### fsn_newchat/README.md
*Role:* shared
*Description:* Chat
### fsn_newchat/cl_chat.lua
*Role:* client
*Events:* register:chatMessage, register:chat:addTemplate, register:chat:addMessage, register:chat:addSuggestion, register:chat:addSuggestions, register:chat:removeSuggestion, register:chat:clear, register:__cfx_internal:serverPrint, register:_chat:messageEntered, handler:chatMessage, handler:__cfx_internal:serverPrint, handler:chat:addMessage, handler:chat:addSuggestion, handler:chat:addSuggestions, handler:chat:removeSuggestion, handler:chat:addTemplate, handler:chat:clear, handler:onClientResourceStart, trigger:chatMessage, trigger:_chat:messageEntered, trigger:chat:addSuggestions, trigger:chat:init
*NUI Callbacks:* chatResult, loaded
*NUI Messages:* SendNUIMessage
### fsn_newchat/html/Suggestions.js
### fsn_newchat/html/Message.js
### fsn_newchat/html/index.html
### fsn_newchat/html/App.js

### fsn_newchat/html/config.default.js
*Description:* DO NOT EDIT THIS FILE
### fsn_newchat/html/index.css
### fsn_newchat/html/vendor/animate.3.5.2.min.css

### fsn_newchat/html/vendor/vue.2.3.3.min.js
### fsn_newchat/html/vendor/flexboxgrid.6.3.1.min.css
### fsn_newchat/html/vendor/latofonts.css
### fsn_newchat/html/vendor/fonts/LatoRegular.woff2
### fsn_newchat/html/vendor/fonts/LatoBold2.woff2

### fsn_newchat/html/vendor/fonts/LatoLight.woff2
### fsn_newchat/html/vendor/fonts/LatoRegular2.woff2
### fsn_newchat/html/vendor/fonts/LatoLight2.woff2
*Role:* NUI
### fsn_newchat/html/vendor/fonts/LatoBold.woff2
*Role:* NUI

### fsn_cargarage/agents.md
*Role:* shared

### fsn_cargarage/client.lua
*Role:* client
*Events:* register:fsn_cargarage:makeMine, register:fsn_cargarage:checkStatus, register:fsn_cargarage:vehicleStatus, register:fsn_cargarage:receiveVehicles, handler:fsn_main:character, handler:fsn_cargarage:makeMine, handler:fsn_cargarage:checkStatus, handler:fsn_cargarage:vehicleStatus, handler:fsn_cargarage:receiveVehicles, trigger:fsn_cargarage:reset, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:vehicle:toggleStatus, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_vehiclecontrol:keys:carjack, trigger:fsn_cargarage:vehicle:toggleStatus, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_garages:vehicle:update, trigger:fsn_cargarage:vehicle:toggleStatus, trigger:fsn_cargarage:requestVehicles, trigger:fsn_garages:vehicle:update
*NUI Messages:* SendNUIMessage
### fsn_cargarage/server.lua
*Role:* server
*Description:* TriggerServerEvent("fsn_cargarage:updateVehicle", plate, table.tostring(vehiclecol), table.tostring(extracol), table.tostring(neoncolor), plateindex, table.tostring(mods), GetVehicleNumberPlateTextIndex(veh), wheeltype);
*Events:* handler:fsn_cargarage:updateVehicle, handler:fsn_cargarage:reset, handler:fsn_cargarage:requestVehicles, handler:fsn_cargarage:impound, handler:fsn_cargarage:vehicle:toggleStatus, handler:fsn_garages:vehicle:update, trigger:fsn_cargarage:updateVehicle, trigger:fsn_cargarage:receiveVehicles, trigger:fsn_cargarage:receiveVehicles, trigger:fsn_cargarage:receiveVehicles, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:impound, trigger:fsn_cargarage:vehicleStatus, trigger:fsn_cargarage:updateVehicle
*DB Calls:* MySQL.Async, MySQL.Sync

### fsn_cargarage/fxmanifest.lua
*Role:* shared
### fsn_cargarage/gui/ui.html
*Role:* NUI
### fsn_cargarage/gui/ui.js
*Role:* shared
### fsn_cargarage/gui/ui.css
*Role:* NUI

### fsn_boatshop/agents.md
*Role:* shared

### fsn_boatshop/cl_boatshop.lua
*Events:* register:fsn_boatshop:floor:Update, register:fsn_boatshop:floor:Updateboat, register:fsn_boatshop:floor:commission, register:fsn_boatshop:floor:color:One, register:fsn_boatshop:floor:color:Two, handler:fsn_boatshop:floor:Update, handler:fsn_boatshop:floor:Updateboat, handler:fsn_boatshop:floor:commission, handler:fsn_boatshop:floor:color:One, handler:fsn_boatshop:floor:color:Two, trigger:fsn_cargarage:buyVehicle, trigger:fsn_bank:change:walletMinus, trigger:fsn_cargarage:makeMine, trigger:fsn_bank:change:walletMinus, trigger:fsn_cargarage:makeMine, trigger:fsn_boatshop:floor:Request, trigger:fsn_boatshop:floor:commission, trigger:fsn_boatshop:floor:color:One, trigger:fsn_boatshop:floor:color:Two, trigger:fsn_bank:change:walletAdd
### fsn_boatshop/fxmanifest.lua
*Role:* shared
*Description:* [[/   :FIVEM MANIFEST SHIT:	\]]--
### fsn_boatshop/cl_menu.lua
*Events:* trigger:fsn_boatshop:floor:ChangeBoat, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification

### fsn_boatshop/sv_boatshop.lua
*Events:* handler:fsn_boatshop:floor:Request, handler:chatMessage, handler:fsn_boatshop:floor:color:One, handler:fsn_boatshop:floor:color:Two, handler:fsn_boatshop:floor:commission, handler:fsn_boatshop:floor:ChangeBoat, trigger:fsn_boatshop:floor:Update, trigger:fsn_boatshop:floor:commission, trigger:mythic_notify:client:SendAlert, trigger:fsn_boatshop:floor:color:One, trigger:mythic_notify:client:SendAlert, trigger:fsn_boatshop:floor:color:Two, trigger:mythic_notify:client:SendAlert, trigger:fsn_boatshop:testdrive:end, trigger:fsn_boatshop:testdrive:start, trigger:fsn_boatshop:floor:Updateboat, trigger:fsn_boatshop:floor:Updateboat, trigger:fsn_boatshop:floor:Updateboat, trigger:fsn_boatshop:floor:Updateboat, trigger:mythic_notify:client:SendAlert
### fsn_bikerental/agents.md

### fsn_bikerental/client.lua
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification
*NUI Callbacks:* escape, rentBike
*NUI Messages:* SendNUIMessage
### fsn_bikerental/fxmanifest.lua
*DB Calls:* MySQL.lua

### fsn_bikerental/html/script.js
### fsn_bikerental/html/index.html
### fsn_bikerental/html/cursor.png
### fsn_bikerental/html/style.css
*Role:* NUI

### fsn_store/agents.md
*Description:* AGENTS.md

### fsn_store/client.lua
*Events:* trigger:fsn_store:request, trigger:fsn_notify:displayNotification, trigger:fsn_store:request, trigger:fsn_bank:change:walletAdd, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch, trigger:fsn_police:dispatch, trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:police:give, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification

### fsn_store/server.lua
*Role:* server
*Description:* These will restock every restart, unless you make something so it doesn't.
*Events:* register:fsn_store:recieveItemsForStore, handler:fsn_store:request, handler:fsn_store:boughtOne, handler:fsn_store:closedStore, handler:fsn_store:recieveItemsForStore, handler:playerDropped, handler:onResourceStart, trigger:fsn_inventory:store:recieve, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:sendItemsToStore
### fsn_store/fxmanifest.lua
*Role:* shared
### fsn_admin/config.lua
### fsn_admin/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_admin/client.lua
*Events:* register:fsn_admin:requestXYZ, register:fsn_admin:recieveXYZ, register:fsn_admin:FreezeMe, handler:fsn_admin:requestXYZ, handler:fsn_admin:recieveXYZ, handler:fsn_admin:FreezeMe, trigger:fsn_admin:sendXYZ, trigger:chatMessage, trigger:chatMessage
### fsn_admin/server.lua
*Events:* register:fsn_admin:spawnCar, register:fsn_admin:fix, handler:chatMessage, handler:fsn_admin:sendXYZ, handler:fsn_admin:spawnCar, handler:fsn_admin:fix, trigger:chatMessage, trigger:fsn_admin:menu:toggle, trigger:fsn_admin:FreezeMe, trigger:chatMessage, trigger:fsn_admin:menu:toggle, trigger:chatMessage, trigger:fsn_admin:requestXYZ, trigger:chatMessage, trigger:chatMessage, trigger:fsn_admin:requestXYZ, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_admin:recieveXYZ, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification
*DB Calls:* MySQL.Async

### fsn_admin/fxmanifest.lua
*DB Calls:* MySQL.lua
### fsn_admin/oldresource.lua
### fsn_admin/server_announce.lua
*Description:* [[ local restarts = {};
*Events:* trigger:chatMessage, trigger:chatMessage

### fsn_admin/client/client.lua
*Events:* register:fsn_admin:spawnVehicle, register:fsn_admin:requestXYZ, register:fsn_admin:recieveXYZ, register:fsn_admin:FreezeMe, handler:fsn_admin:spawnVehicle, handler:fsn_admin:requestXYZ, handler:fsn_admin:recieveXYZ, handler:fsn_admin:FreezeMe, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_admin:sendXYZ, trigger:chat:addMessage, trigger:chat:addMessage
### fsn_admin/server/server.lua
*Events:* register:fsn_admin:enableAdminCommands, register:fsn_admin:enableModeratorCommands, register:fsn:playerReady, handler:fsn_admin:enableAdminCommands, handler:fsn_admin:enableModeratorCommands, handler:fsn:playerReady, handler:onResourceStart, trigger:fsn:getFsnObject, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:fsn_admin:FreezeMe, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:fsn_admin:requestXYZ, trigger:chat:addMessage, trigger:chat:addMessage, trigger:fsn_admin:requestXYZ, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addMessage, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:chat:addSuggestion, trigger:fsn_admin:enableAdminCommands, trigger:fsn_admin:enableModeratorCommands
*Commands:* sc, sc, adminmenu, amenu, freeze, announce, goto, bring, kick, ban
*DB Calls:* MySQL.Async
### fsn_teleporters/agents.md
*Description:* AGENTS.md
### fsn_teleporters/client.lua
*Role:* client
*Events:* register:fsn_doj:judge:toggleLock, register:fsn_teleporters:teleport:waypoint, register:fsn_teleporters:teleport:coordinates, handler:fsn_doj:judge:toggleLock, handler:fsn_teleporters:teleport:waypoint, handler:fsn_teleporters:teleport:coordinates, trigger:fsn_notify:displayNotification
### fsn_teleporters/fxmanifest.lua
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_store_guns/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_store_guns/client.lua
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_store_guns:request, trigger:fsn_licenses:police:give, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification

### fsn_store_guns/server.lua
*Description:* These will restock every restart, unless you make something so it doesn't.
*Events:* handler:fsn_store_guns:request, handler:fsn_store_guns:boughtOne, handler:fsn_store_guns:closedStore, handler:playerDropped, trigger:fsn_inventory:store_gun:recieve, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification
### fsn_store_guns/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
*Events:* register:fsn_notify:displayNotification, handler:fsn_notify:displayNotification, trigger:pNotify:SendNotification

### fsn_notify/cl_notify.lua
*Role:* client
*Events:* register:fsn_notify:displayNotification, register:chatMessage, register:pNotify:SendNotification, register:pNotify:SetQueueMax, register:chatMessage, handler:fsn_notify:displayNotification, handler:chatMessage, handler:pNotify:SendNotification, handler:pNotify:SetQueueMax, handler:chatMessage, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification
*NUI Messages:* SendNUIMessage

*Role:* NUI

### fsn_notify/html/pNotify.js
*Role:* NUI

### fsn_notify/html/index.html
*Role:* NUI

### fsn_notify/html/noty_license.txt
*Role:* NUI

### fsn_characterdetails/agents.md

### fsn_characterdetails/fxmanifest.lua
*DB Calls:* MySQL.lua

### fsn_characterdetails/gui_manager.lua
*NUI Messages:* SendNUIMessage
### fsn_characterdetails/facial/client.lua
*Role:* client

### fsn_characterdetails/facial/server.lua
*Role:* server

### fsn_characterdetails/tattoos/config.lua

### fsn_characterdetails/tattoos/client.lua
*Role:* client
*Events:* register:fsn_characterdetails:recievetattoos, handler:fsn_characterdetails:recievetattoos, trigger:fsn_main:saveCharacter

### fsn_characterdetails/tattoos/server.lua
### fsn_characterdetails/tattoos/server.zip

### fsn_characterdetails/gui/ui.html
*Role:* NUI
### fsn_characterdetails/gui/ui.js
### fsn_characterdetails/gui/ui.css
*Role:* NUI
### fsn_main/agents.md

### fsn_main/cl_utils.lua
*Role:* client

### fsn_main/fxmanifest.lua
*Role:* shared
*DB Calls:* MySQL.lua

### fsn_main/sv_utils.lua
*Description:* New Util shit to pass the functions easier and similar to how ESX does it
*Events:* handler:fsn:getFsnObject, handler:fsn_main:updateCharacters, handler:fsn_main:updateMoneyStore, handler:playerDropped
### fsn_main/server_settings/sh_settings.lua
*Role:* server

### fsn_main/money/client.lua
*Events:* register:fsn_main:money:updateSilent, register:fsn_main:money:update, register:fsn_main:displayBankandMoney, register:fsn_police:search:start:money, register:fsn_bank:change:walletAdd, register:fsn_bank:change:walletMinus, register:fsn_bank:change:bankAdd, register:fsn_bank:change:bankMinus, handler:fsn_main:money:updateSilent, handler:fsn_main:money:update, handler:fsn_bank:request:both, handler:fsn_main:displayBankandMoney, handler:fsn_police:search:start:money, handler:fsn_bank:change:bankandwallet, handler:fsn_bank:change:walletAdd, handler:fsn_bank:change:walletMinus, handler:fsn_bank:change:bankAdd, handler:fsn_bank:change:bankMinus, handler:fsn_lscustoms:check, handler:fsn_lscustoms:check2, handler:fsn_lscustoms:check3, trigger:fsn_main:gui:both:display, trigger:fsn_bank:update:both, trigger:fsn_main:gui:both:display, trigger:fsn_police:search:end:money, trigger:fsn_main:money:wallet:Set, trigger:fsn_main:money:wallet:Set, trigger:fsn_main:money:bank:Set, trigger:fsn_main:money:bank:Set, trigger:fsn_main:money:wallet:Add, trigger:fsn_main:money:wallet:Add, trigger:fsn_main:money:wallet:Add, trigger:fsn_main:gui:money:change, trigger:fsn_main:money:wallet:Minus, trigger:fsn_main:gui:money:change, trigger:fsn_main:money:bank:Add, trigger:fsn_main:gui:bank:change, trigger:fsn_main:money:bank:Minus, trigger:fsn_main:gui:bank:change, trigger:fsn_lscustoms:receive, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:fsn_lscustoms:receive2, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:fsn_lscustoms:receive3, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification
### fsn_main/money/server.lua
*Role:* server
*Events:* register:fsn_main:money:initChar, handler:fsn_main:money:initChar, handler:fsn_main:money:wallet:GiveCash, handler:fsn_main:money:wallet:Set, handler:fsn_main:money:bank:Set, handler:fsn_main:money:wallet:Add, handler:fsn_main:money:bank:Add, handler:fsn_main:money:wallet:Minus, handler:fsn_main:money:bank:Minus, trigger:fsn_main:money:update, trigger:fsn_main:updateMoneyStore, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_main:money:updateSilent, trigger:fsn_notify:displayNotification, trigger:fsn_main:gui:money:addMoney, trigger:fsn_main:money:updateSilent, trigger:fsn_notify:displayNotification, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_main:money:updateSilent, trigger:fsn_main:gui:money:changeAmount, trigger:fsn_main:money:updateSilent, trigger:fsn_main:gui:bank:changeAmount, trigger:fsn_main:money:updateSilent, trigger:fsn_main:gui:money:addMoney, trigger:fsn_main:logging:addLog, trigger:fsn_main:money:updateSilent, trigger:fsn_main:gui:bank:addMoney, trigger:fsn_main:logging:addLog, trigger:fsn_main:money:updateSilent, trigger:fsn_main:gui:minusMoney, trigger:fsn_phones:SYS:addTransaction, trigger:fsn_main:logging:addLog, trigger:fsn_main:money:updateSilent, trigger:fsn_main:gui:bank:minusMoney, trigger:fsn_phones:SYS:addTransaction, trigger:fsn_main:logging:addLog
*DB Calls:* MySQL.Sync

### fsn_main/gui/motd.txt
### fsn_main/gui/pdown.ttf
*Role:* shared
### fsn_main/gui/index.html
### fsn_main/gui/logo_old.png
*Role:* shared
### fsn_main/gui/logo_new.png
### fsn_main/gui/index.js
*Role:* shared
### fsn_main/gui/logos/discord.png
*Role:* shared
### fsn_main/gui/logos/logo.png
*Role:* shared

### fsn_main/gui/logos/main.psd
*Role:* shared
### fsn_main/gui/logos/discord.psd
*Role:* shared
### fsn_main/misc/logging.lua
*Role:* shared
*Description:* External logging system shit
*Events:* handler:fsn_main:logging:addLog

### fsn_main/misc/shitlordjumping.lua
*Description:* TODO: Merge "threads"
### fsn_main/misc/version.lua
*Events:* handler:onResourceStart, handler:playerConnecting, trigger:fsn_main:version

### fsn_main/misc/timer.lua
*Description:* Investigate viability of https://runtime.fivem.net/doc/natives/#_0x9CD27B0045628463
### fsn_main/misc/db.lua
*Role:* shared
*DB Calls:* MySQL.Async, MySQL.ready

### fsn_main/misc/servername.lua
*Role:* server
*Description:* TODO: Use https://runtime.fivem.net/doc/natives/#_0x32CA01C3 instead

### fsn_main/playermanager/client.lua
*Events:* handler:playerSpawned, trigger:fsn_main:charMenu
### fsn_main/playermanager/server.lua
*Events:* handler:playerConnecting, handler:playerDropped, handler:fsn_main:validatePlayer, trigger:fsn_main:characterSaving, trigger:chatMessage
*DB Calls:* MySQL.Async, MySQL.Sync, MySQL.ready
### fsn_main/banmanager/sv_bans.lua
*Role:* server
*Events:* handler:playerConnecting
*DB Calls:* MySQL.Sync

### fsn_main/initial/client.lua
*Events:* register:spawnme, register:fsn_main:charMenu, register:fsn_main:character, register:fsn_main:initiateCharacter, register:fsn_main:sendCharacters, register:fsn_main:characterSaving, handler:spawnme, handler:fsn_main:charMenu, handler:fsn_main:initiateCharacter, handler:fsn_main:sendCharacters, handler:fsn_inventory:buyItem, handler:fsn_main:characterSaving, trigger:PlayerSpawned, trigger:fsn_main:requestCharacters, trigger:fsn_spawnmanager:start, trigger:fsn_main:getCharacter, trigger:fsn:playerReady, trigger:fsn_main:createCharacter, trigger:fsn_inventory:item:add, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:fsn_main:saveCharacter, trigger:fsn_main:charMenu, trigger:fsn_main:charMenu, trigger:fsn_notify:displayNotification
*NUI Callbacks:* spawnCharacter, createCharacter
*NUI Messages:* SendNUIMessage
### fsn_main/initial/server.lua
*Role:* server
*Events:* handler:fsn_main:validatePlayer, handler:playerDropped, handler:fsn_main:createCharacter, handler:playerDropped, handler:fsn_main:requestCharacters, handler:fsn_main:update:myCharacter, handler:fsn_main:getCharacter, handler:fsn_main:updateCharacters, handler:fsn_main:updateCharNumber, handler:fsn_inventory:database:update, handler:fsn_cargarage:buyVehicle, handler:fsn_main:saveCharacter, handler:fsn_police:chat:ticket, trigger:fsn_main:sendCharacters, trigger:fsn_main:updateCharacters, trigger:fsn_main:sendCharacters, trigger:fsn_main:initiateCharacter, trigger:fsn_main:money:initChar, trigger:fsn_main:updateCharacters, trigger:fsn_main:updateCharacters, trigger:fsn_main:characterSaving, trigger:chatMessage, trigger:chatMessage
*DB Calls:* MySQL.Async, MySQL.Sync

### fsn_main/initial/desc.txt
### fsn_main/debug/sh_debug.lua
*Events:* handler:fsn_main:debug_toggle, trigger:fsn_main:debug_toggle
*Commands:* fsn_debug
### fsn_main/debug/cl_subframetime.js
*Role:* client
*Exports:* sub_frame_time

### fsn_main/debug/sh_scheduler.lua
*Description:* TODO: Fix RPC __call and InvokeRpcEvent relying curThread
*Events:* handler:fsn_main:debug_toggle

### fsn_main/hud/client.lua
*Role:* client
*Events:* register:fsn_main:gui:both:display, register:fsn_main:gui:money:change, register:fsn_main:gui:bank:change, handler:fsn_main:gui:both:display, handler:fsn_main:gui:money:change, handler:fsn_main:gui:bank:change
*NUI Messages:* SendNUIMessage
### fsn_shootingrange/client.lua
*Role:* client
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_shootingrange/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_police/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_police/client.lua
*Events:* register:fsn_police:911r, register:fsn_police:911, register:fsn_police:putMeInVeh, register:fsn_police:MDT:vehicledetails, register:fsn_police:init, register:fsn_police:updateLevel, register:fsn_police:update, register:fsn_police:command:duty, register:fsn_police:cuffs:startCuffed, register:fsn_police:cuffs:startunCuffed, register:fsn_police:cuffs:startCuffing, register:fsn_police:cuffs:startunCuffing, register:fsn_police:cuffs:toggleHard, register:fsn_police:pd:toggleDrag, register:fsn_police:ply:toggleDrag, handler:fsn_police:911r, handler:fsn_police:911, handler:fsn_police:putMeInVeh, handler:fsn_police:MDT:vehicledetails, handler:fsn_police:init, handler:fsn_police:updateLevel, handler:fsn_police:update, handler:fsn_police:command:duty, handler:fsn_police:cuffs:startCuffed, handler:fsn_police:cuffs:startunCuffed, handler:fsn_police:cuffs:startCuffing, handler:fsn_police:cuffs:startunCuffing, handler:fsn_police:cuffs:toggleHard, handler:fsn_police:pd:toggleDrag, handler:fsn_police:ply:toggleDrag, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:requestUpdate, trigger:fsn_police:requestUpdate, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_police:offDuty, trigger:fsn_notify:displayNotification, trigger:fsn_police:onDuty, trigger:fsn_criminalmisc:weapons:add:police, trigger:fsn_inventory:items:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_police:offDuty, trigger:fsn_notify:displayNotification, trigger:fsn_police:onDuty, trigger:fsn_notify:displayNotification, trigger:InteractSound_SV:PlayWithinDistance, trigger:fsn_police:cuffs:toggleHard, trigger:fsn_police:cuffs:toggleEscort, trigger:fsn_police:cuffs:requestunCuff, trigger:fsn_police:cuffs:requestCuff

### fsn_police/server.lua
*Role:* server
*Events:* handler:fsn_police:dispatch, handler:fsn_police:runplate::target, handler:fsn_police:runplate, handler:fsn_police:toggleHandcuffs, handler:fsn_police:ticket, handler:fsn_police:onDuty, handler:fsn_police:offDuty, handler:playerDropped, handler:fsn_police:requestUpdate, handler:fsn_police:search:end:inventory, handler:fsn_police:search:end:weapons, handler:fsn_police:search:end:money, handler:fsn_police:cuffs:toggleEscort, handler:fsn_police:cuffs:requestCuff, handler:fsn_police:cuffs:requestunCuff, handler:fsn_police:cuffs:toggleHard, trigger:fsn_police:dispatchcall, trigger:fsn_police:runplate, trigger:fsn_police:MDT:vehicledetails, trigger:fsn_police:MDT:vehicledetails, trigger:fsn_police:MDT:vehicledetails, trigger:fsn_police:handcuffs:toggle, trigger:fsn_bank:change:bankMinus, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_police:update, trigger:fsn_police:update, trigger:fsn_police:update, trigger:fsn_police:update, trigger:fsn_police:update, trigger:fsn_police:update, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:ply:toggleDrag, trigger:fsn_police:pd:toggleDrag, trigger:fsn_police:cuffs:startCuffing, trigger:fsn_police:cuffs:startCuffed, trigger:fsn_police:cuffs:startunCuffing, trigger:fsn_police:cuffs:startunCuffed, trigger:fsn_police:cuffs:toggleHard
*DB Calls:* MySQL.Async

### fsn_police/dispatch.lua
*Role:* shared
*Events:* register:fsn_police:dispatch:toggle, register:fsn_police:dispatchcall, register:fsn_commands:police:gsrMe, handler:fsn_police:dispatch:toggle, handler:fsn_police:dispatchcall, handler:fsn_commands:police:gsrMe, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_main:blip:add, trigger:fsn_evidence:ped:addState, trigger:fsn_police:dispatch, trigger:fsn_commands:police:gsrResult, trigger:fsn_police:dispatch
*NUI Messages:* SendNUIMessage

### fsn_police/fxmanifest.lua
*Role:* shared
*Description:* [[/ :FSN: \]]--
*DB Calls:* MySQL.lua

### fsn_police/tackle/client.lua
*Role:* client
*Events:* register:Tackle:Client:TacklePlayer, handler:Tackle:Client:TacklePlayer, trigger:chatMessage, trigger:Tackle:Server:TacklePlayer, trigger:chatMessage

### fsn_police/tackle/server.lua
*Role:* server
*Events:* handler:Tackle:Server:TacklePlayer, trigger:Tackle:Client:TacklePlayer

### fsn_police/dispatch/client.lua
*Role:* client
*Events:* register:fsn_main:blip:add, register:fsn_main:blip:clear, handler:fsn_main:blip:add, handler:fsn_main:blip:clear, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_police/armory/cl_armory.lua
*Role:* client
*Events:* register:fsn_police:armory:request, handler:fsn_police:armory:request, trigger:fsn_police:armory:request, trigger:fsn_police:armory:request

### fsn_police/armory/sv_armory.lua
*Role:* server
*Events:* register:fsn_police:armory:request, register:fsn_police:armory:recieveItemsForArmory, handler:fsn_police:armory:request, handler:fsn_police:armory:boughtOne, handler:fsn_police:armory:closedArmory, handler:fsn_police:armory:recieveItemsForArmory, handler:playerDropped, handler:onResourceStart, trigger:fsn_inventory:police_armory:recieve, trigger:fsn_inventory:police_armory:recieve, trigger:fsn_inventory:police_armory:recieve, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:sendItemsToArmory

### fsn_police/MDT/mdt_server.lua
*Role:* server
*Events:* handler:fsn_police:database:CPIC, handler:fsn_police:database:CPIC:search, handler:fsn_police:MDT:warrant, handler:fsn_police:MDT:requestwarrants, handler:fsn_police:MDTremovewarrant, trigger:fsn_police:database:CPIC:search:result, trigger:chatMessage, trigger:fsn_police:911, trigger:fsn_police:MDT:receivewarrants, trigger:fsn_police:MDT:receivewarrants
*DB Calls:* MySQL.Async

### fsn_police/MDT/mdt_client.lua
*Role:* client
*Events:* register:fsn_police:MDT:toggle, register:fsn_police:database:CPIC:search:result, register:fsn_police:MDT:receivewarrants, handler:fsn_police:MDT:toggle, handler:fsn_police:database:CPIC:search:result, handler:fsn_police:MDT:receivewarrants, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:MDT:toggle, trigger:fsn_police:database:CPIC, trigger:fsn_police:chat:ticket, trigger:fsn_police:ticket, trigger:fsn_jail:sendsuspect, trigger:fsn_notify:displayNotification, trigger:fsn_police:MDT:toggle, trigger:chatMessage, trigger:fsn_police:MDT:warrant, trigger:fsn_police:MDTremovewarrant, trigger:fsn_police:MDT:requestwarrants, trigger:fsn_police:MDT:requestwarrants, trigger:fsn_police:MDT:toggle, trigger:fsn_emotecontrol:police:tablet, trigger:fsn_notify:displayNotification, trigger:fsn_police:MDT:toggle, trigger:fsn_commands:me, trigger:fsn_police:MDT:toggle
*NUI Callbacks:* booking-submit-now, booking-submit-warrant, mdt-remove-warrant, mdt-request-warrants, closeMDT, setWaypoint
*NUI Messages:* SendNUIMessage

### fsn_police/MDT/gui/index.html
*Role:* NUI
### fsn_police/MDT/gui/index.css
*Role:* NUI

### fsn_police/MDT/gui/index.js
### fsn_police/MDT/gui/images/win_icon.png
### fsn_police/MDT/gui/images/background.png

### fsn_police/MDT/gui/images/base_pc.png

### fsn_police/MDT/gui/images/pwr_icon.png

### fsn_police/MDT/gui/images/icons/cpic.png
### fsn_police/MDT/gui/images/icons/dmv.png
### fsn_police/MDT/gui/images/icons/warrants.png
### fsn_police/MDT/gui/images/icons/booking.png
*Role:* shared

### fsn_police/K9/client.lua
*Role:* client
*Events:* register:fsn_police:ToggleK9, register:fsn_police:Sit, register:fsn_police:GetInVehicle, register:fsn_police:k9:search:person:me, register:fsn_police:k9:search:person:finish, handler:fsn_police:ToggleK9, handler:fsn_police:Sit, handler:fsn_police:GetInVehicle, handler:fsn_police:k9:search:person:me, handler:fsn_police:k9:search:person:finish, trigger:fsn_police:k9:search:person:end, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification
### fsn_police/K9/server.lua
*Role:* server
*Events:* handler:fsn_police:k9:search:person:end, trigger:fsn_police:k9:search:person:finish
### fsn_police/pedmanagement/client.lua
### fsn_police/pedmanagement/server.lua
### fsn_police/radar/client.lua
*Role:* client
*Events:* register:fsn_police:radar:toggle, handler:fsn_police:radar:toggle, trigger:chatMessage

### fsn_storagelockers/agents.md
### fsn_storagelockers/client.lua
*Description:* shared functions
*Events:* register:fsn_properties:buy, register:fsn_properties:menu:access:allow, register:fsn_properties:menu:access:view, register:fsn_properties:menu:access:revoke, register:fsn_properties:menu:inventory:deposit, register:fsn_properties:menu:inventory:take, register:fsn_properties:menu:weapon:deposit, register:fsn_properties:menu:weapon:take, register:fsn_properties:menu:money:withdraw, register:fsn_properties:menu:money:deposit, register:fsn_properties:menu:police:search, register:fsn_properties:menu:police:seize, register:fsn_properties:menu:police:empty, register:fsn_properties:menu:police:breach, register:fsn_properties:menu:rent:check, register:fsn_properties:menu:rent:pay, register:fsn_properties:menu:robbery, trigger:fsn_properties:buy, trigger:fsn_properties:menu:robbery, trigger:fsn_properties:menu:access:allow, trigger:fsn_properties:menu:access:view, trigger:fsn_properties:menu:access:revoke, trigger:fsn_properties:menu:inventory:deposit, trigger:fsn_properties:menu:inventory:take, trigger:fsn_properties:menu:weapon:deposit, trigger:fsn_properties:menu:weapon:take, trigger:fsn_properties:menu:money:withdraw, trigger:fsn_properties:menu:money:deposit, trigger:fsn_properties:menu:police:search, trigger:fsn_properties:menu:police:seize, trigger:fsn_properties:menu:police:empty, trigger:fsn_properties:menu:police:breach, trigger:fsn_properties:menu:rent:check, trigger:fsn_properties:menu:rent:pay
*NUI Messages:* SendNUIMessage
### fsn_storagelockers/server.lua
*Role:* server
*DB Calls:* MySQL.Async, MySQL.ready

### fsn_storagelockers/fxmanifest.lua
*Role:* shared
### fsn_storagelockers/nui/ui.html

### fsn_storagelockers/nui/ui.js
*Role:* shared
### fsn_storagelockers/nui/ui.css

### fsn_criminalmisc/agents.md
### fsn_criminalmisc/client.lua
### fsn_criminalmisc/fxmanifest.lua
*Role:* shared
### fsn_criminalmisc/pawnstore/cl_pawnstore.lua
*Role:* client
*Events:* trigger:fsn_inventory:item:take, trigger:fsn_bank:change:walletAdd
### fsn_criminalmisc/handcuffs/client.lua
*Role:* client
*Description:* me handcuff
*Events:* register:fsn_criminalmisc:toggleDrag, register:fsn_criminalmisc:handcuffs:startCuffed, register:fsn_criminalmisc:handcuffs:startunCuffed, register:fsn_criminalmisc:handcuffs:startCuffing, register:fsn_criminalmisc:handcuffs:startunCuffing, handler:fsn_criminalmisc:toggleDrag, handler:fsn_criminalmisc:handcuffs:startCuffed, handler:fsn_criminalmisc:handcuffs:startunCuffed, handler:fsn_criminalmisc:handcuffs:startCuffing, handler:fsn_criminalmisc:handcuffs:startunCuffing, trigger:fsn_criminalmisc:handcuffs:requestunCuff, trigger:fsn_criminalmisc:handcuffs:toggleEscort, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:robbing:requesRob, trigger:fsn_criminalmisc:robbing:startRobbing, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:handcuffs:requestCuff

### fsn_criminalmisc/handcuffs/server.lua
*Role:* server
*Events:* handler:fsn_criminalmisc:handcuffs:requestCuff, handler:fsn_criminalmisc:handcuffs:requestunCuff, handler:fsn_criminalmisc:handcuffs:toggleEscort, trigger:fsn_criminalmisc:handcuffs:startCuffing, trigger:fsn_criminalmisc:handcuffs:startCuffed, trigger:fsn_criminalmisc:handcuffs:startunCuffing, trigger:fsn_criminalmisc:handcuffs:startunCuffed, trigger:fsn_criminalmisc:toggleDrag
### fsn_criminalmisc/lockpicking/client.lua
*Role:* client
*Events:* register:fsn_bankrobbery:desks:receive, register:fsn_criminalmisc:lockpicking, handler:fsn_bankrobbery:desks:receive, handler:fsn_criminalmisc:lockpicking, trigger:fsn_commands:me, trigger:fsn_bankrobbery:desks:doorUnlock, trigger:fsn_police:dispatch, trigger:fsn_commands:me, trigger:fsn_bankrobbery:LostMC:spawn, trigger:fsn_notify:displayNotification, trigger:fsn_bankrobbery:LostMC:spawn, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_bankrobbery:LostMC:spawn, trigger:fsn_police:dispatch, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_commands:me, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_vehiclecontrol:keys:carjack, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_police:dispatch
### fsn_criminalmisc/drugs/client.lua
*Role:* client

### fsn_criminalmisc/drugs/_weedprocess/client.lua
*Role:* client
### fsn_criminalmisc/drugs/_effects/client.lua
*Role:* client
*Events:* register:fsn_criminalmisc:drugs:effects:weed, register:fsn_criminalmisc:drugs:effects:meth, register:fsn_criminalmisc:drugs:effects:cocaine, register:fsn_criminalmisc:drugs:effects:smokeCigarette, handler:fsn_criminalmisc:drugs:effects:weed, handler:fsn_criminalmisc:drugs:effects:meth, handler:fsn_criminalmisc:drugs:effects:cocaine, handler:fsn_criminalmisc:drugs:effects:smokeCigarette, trigger:fsn_needs:stress:remove, trigger:fsn_needs:stress:remove

### fsn_criminalmisc/drugs/_streetselling/client.lua
*Events:* register:fsn_criminalmisc:drugs:streetselling:send, handler:fsn_criminalmisc:drugs:streetselling:send, trigger:fsn_phone:recieveMessage, trigger:fsn_phones:USE:Email, trigger:fsn_criminalmisc:drugs:streetselling:request, trigger:fsn_criminalmisc:drugs:streetselling:radio, trigger:fsn_police:dispatch, trigger:fsn_phone:recieveMessage, trigger:fsn_notify:displayNotification, trigger:fsn_needs:stress:add, trigger:chatMessage, trigger:fsn_evidence:ped:addState, trigger:fsn_evidence:ped:addState, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:take, trigger:fsn_needs:stress:add, trigger:fsn_notify:displayNotification

### fsn_criminalmisc/drugs/_streetselling/server.lua
*Role:* server
*Events:* register:fsn_criminalmisc:drugs:streetselling:request, handler:fsn_criminalmisc:drugs:streetselling:request, handler:fsn_criminalmisc:drugs:streetselling:radio, trigger:fsn_criminalmisc:drugs:streetselling:send, trigger:fsn_criminalmisc:drugs:streetselling:send, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_criminalmisc/remapping/client.lua
*Role:* client
### fsn_criminalmisc/remapping/server.lua
*Role:* server
### fsn_criminalmisc/weaponinfo/client.lua
*Role:* client
*Events:* register:fsn_criminalmisc:weapons:add, register:fsn_criminalmisc:weapons:add:police, register:fsn_criminalmisc:weapons:add:unknown, register:fsn_criminalmisc:weapons:add:tbl, register:fsn_criminalmisc:weapons:pickup, register:fsn_criminalmisc:weapons:info, register:fsn_criminalmisc:weapons:equip, register:fsn_criminalmisc:weapons:drop, register:fsn_criminalmisc:weapons:destroy, register:fsn_criminalmisc:weapons:updateDropped, register:fsn_police:search:strip, register:fsn_police:search:start:weapons, handler:fsn_criminalmisc:weapons:add, handler:fsn_criminalmisc:weapons:add:police, handler:fsn_criminalmisc:weapons:add:unknown, handler:fsn_criminalmisc:weapons:add:tbl, handler:fsn_criminalmisc:weapons:pickup, handler:fsn_criminalmisc:weapons:info, handler:fsn_criminalmisc:weapons:equip, handler:fsn_criminalmisc:weapons:drop, handler:fsn_criminalmisc:weapons:destroy, handler:fsn_criminalmisc:weapons:updateDropped, handler:fsn_main:character, handler:fsn_police:search:strip, handler:fsn_police:search:start:weapons, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:equip, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:equip, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:equip, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:equip, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:equip, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:addDrop, trigger:fsn_main:characterSaving, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:addDrop, trigger:fsn_main:characterSaving, trigger:fsn_criminalmisc:weapons:equip, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:pickup, trigger:fsn_inventory:empty, trigger:fsn_bank:change:bankandwallet, trigger:fsn_police:search:end:weapons
### fsn_criminalmisc/weaponinfo/server.lua
*Events:* handler:fsn_criminalmisc:weapons:addDrop, handler:fsn_criminalmisc:weapons:pickup, trigger:fsn_criminalmisc:weapons:updateDropped, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:pickup, trigger:fsn_main:logging:addLog, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:updateDropped, trigger:fsn_notify:displayNotification

### fsn_criminalmisc/weaponinfo/weapon_list.lua
### fsn_criminalmisc/streetracing/client.lua
*Events:* register:fsn_criminalmisc:racing:createRace, register:fsn_criminalmisc:racing:update, register:fsn_criminalmisc:racing:putmeinrace, handler:fsn_criminalmisc:racing:createRace, handler:fsn_criminalmisc:racing:update, handler:fsn_criminalmisc:racing:putmeinrace, trigger:fsn_criminalmisc:racing:newRace, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:racing:joinRace, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:racing:win

### fsn_criminalmisc/streetracing/server.lua
*Events:* handler:fsn_criminalmisc:racing:newRace, handler:fsn_criminalmisc:racing:joinRace, handler:fsn_criminalmisc:racing:win, trigger:fsn_criminalmisc:racing:update, trigger:fsn_criminalmisc:racing:putmeinrace, trigger:fsn_notify:displayNotification, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_bank:change:walletAdd, trigger:fsn_criminalmisc:racing:update, trigger:fsn_criminalmisc:racing:update, trigger:fsn_criminalmisc:racing:update, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_bank:change:walletAdd, trigger:fsn_criminalmisc:racing:update, trigger:fsn_criminalmisc:racing:update, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_criminalmisc:racing:update

### fsn_criminalmisc/robbing/cl_houses-config.lua
*Role:* client
### fsn_criminalmisc/robbing/client.lua
*Role:* client
*Events:* register:fsn_criminalmisc:robbing:startRobbing, handler:fsn_criminalmisc:robbing:startRobbing, trigger:fsn_inventory:sys:request
### fsn_criminalmisc/robbing/cl_houses-build.lua
*Role:* client

### fsn_criminalmisc/robbing/cl_houses.lua
*Role:* client
*Events:* register:fsn_criminalmisc:houserobbery:try, handler:fsn_criminalmisc:houserobbery:try, trigger:fsn_inventory:items:add, trigger:fsn_inventory:item:take, trigger:fsn_inventory:item:take, trigger:fsn_inventory:items:add, trigger:fsn_inventory:items:add, trigger:fsn_inventory:items:add, trigger:fsn_police:dispatch, trigger:fsn_apartments:instance:new, trigger:fsn_apartments:instance:leave, trigger:fsn_apartments:instance:leave, trigger:fsn_needs:stress:add, trigger:fsn_bank:change:walletAdd, trigger:fsn_inventory:items:addPreset, trigger:fsn_inventory:items:add
### fsn_spawnmanager/agents.md
### fsn_spawnmanager/client.lua
*Events:* register:fsn_spawnmanager:start, handler:fsn_spawnmanager:start, trigger:clothes:spawn, trigger:clothes:spawn, trigger:mythic_notify:client:SendAlert, trigger:fsn_main:character, trigger:fsn_police:init, trigger:fsn_jail:init, trigger:fsn_inventory:initChar, trigger:fsn_bank:change:bankAdd, trigger:fsn_ems:reviveMe:force, trigger:mythic_notify:client:SendAlert, trigger:fsn_apartments:getApartment, trigger:fsn->esx:clothing:spawn, trigger:clothes:spawn, trigger:spawnme, trigger:clothes:spawn, trigger:spawnme, trigger:clothes:spawn, trigger:fsn_spawnmanager:start
*NUI Callbacks:* camToLoc, spawnAtLoc
*NUI Messages:* SendNUIMessage
### fsn_spawnmanager/fxmanifest.lua
*DB Calls:* MySQL.lua

### fsn_spawnmanager/nui/index.html
### fsn_spawnmanager/nui/index.css

### fsn_spawnmanager/nui/index.js
### fsn_clothing/config.lua
*Role:* shared
*Events:* trigger:fsn_bank:change:walletMinus
### fsn_clothing/agents.md

### fsn_clothing/client.lua
*Events:* register:fsn_clothing:menu, register:clothes:spawn, handler:fsn_clothing:menu, handler:clothes:changemodel, handler:clothes:spawn, handler:clothes:setComponents, trigger:clothes:changemodel, trigger:clothes:save, trigger:fsn_criminalmisc:weapons:equip, trigger:clothes:setComponents, trigger:clothes:loaded, trigger:clothes:firstspawn, trigger:fsn_criminalmisc:weapons:equip, trigger:clothes:loaded
### fsn_clothing/server.lua
*Role:* server
*Events:* handler:clothes:firstspawn, handler:fsn_clothing:requestDefault, handler:fsn_clothing:save, trigger:clothes:spawn, trigger:fsn_clothing:change

### fsn_clothing/fxmanifest.lua
### fsn_clothing/models.txt
### fsn_clothing/gui.lua
### fsn_priority/agents.md
### fsn_priority/server.lua
*DB Calls:* MySQL.Async, MySQL.ready

### fsn_priority/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--

### fsn_priority/administration.lua
*Role:* shared
*Description:* stuff to administrate prio
*Events:* handler:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage
*DB Calls:* MySQL.Async, MySQL.Sync
### fsn_customanimations/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_customanimations/client.lua
*Description:* New custom animations based off DavesEmotes from @davewazere
*Events:* register:321236ce-42a6-43d8-af3d-e0e30c9e66b7, register:394084c7-ac07-424a-982b-ab2267d8d55f, handler:321236ce-42a6-43d8-af3d-e0e30c9e66b7, handler:394084c7-ac07-424a-982b-ab2267d8d55f, handler:onResourceStop, trigger:1a4d29ac-5c1a-427e-ab18-461ae6b76e8b, trigger:chatMessage, trigger:chatMessage, trigger:chat:addSuggestion, trigger:chat:removeSuggestion
*Commands:* ce, testanimation
### fsn_customanimations/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_timeandweather/w_clearing.xml
*Role:* shared

### fsn_timeandweather/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_timeandweather/w_xmas.xml
*Role:* shared

### fsn_timeandweather/w_clouds.xml
*Role:* shared
### fsn_timeandweather/client.lua
*Role:* client
*Events:* register:fsn_timeandweather:updateWeather, register:fsn_timeandweather:updateTime, register:fsn_timeandweather:notify, register:fsn_timeandweather:updateWeather, register:fsn_timeandweather:updateTime, register:fsn_timeandweather:notify, handler:fsn_timeandweather:updateWeather, handler:fsn_timeandweather:updateTime, handler:playerSpawned, handler:fsn_timeandweather:notify, handler:fsn_timeandweather:updateWeather, handler:fsn_timeandweather:updateTime, handler:playerSpawned, handler:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:requestSync
### fsn_timeandweather/w_thunder.xml
*Role:* shared
### fsn_timeandweather/server.lua
*Role:* server
*Description:* change this -------------------
*Events:* handler:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:updateWeather, trigger:fsn_timeandweather:updateTime, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:notify, trigger:chatMessage, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:notify, trigger:chatMessage, trigger:fsn_timeandweather:requestSync, trigger:chatMessage, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:chatMessage, trigger:chatMessage, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:requestSync, trigger:fsn_timeandweather:notify, trigger:fsn_timeandweather:requestSync, trigger:chatMessage, trigger:chatMessage, trigger:fsn_timeandweather:updateTime, trigger:fsn_timeandweather:updateWeather, trigger:fsn_timeandweather:requestSync
*Commands:* freezetime, freezeweather, weather, blackout, morning, noon, evening, night, time

### fsn_timeandweather/w_overcast.xml
*Role:* shared
### fsn_timeandweather/w_rain.xml
*Role:* shared

### fsn_timeandweather/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_timeandweather/w_neutral.xml
*Role:* shared

### fsn_timeandweather/w_clear.xml
*Role:* shared
### fsn_timeandweather/w_snow.xml
*Role:* shared
### fsn_timeandweather/w_snowlight.xml
*Role:* shared
### fsn_timeandweather/w_blizzard.xml
*Role:* shared
### fsn_timeandweather/w_smog.xml
*Role:* shared
### fsn_timeandweather/w_extrasunny.xml
*Role:* shared

### fsn_timeandweather/timecycle_mods_4.xml
*Role:* shared

### fsn_timeandweather/w_foggy.xml
*Role:* shared
### fsn_crafting/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_crafting/client.lua
*Role:* client
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_evidence:ped:addState, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus, trigger:fsn_inventory:item:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_crafting/server.lua
*Role:* server

### fsn_crafting/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_crafting/nui/index.html
*Role:* NUI
### fsn_crafting/nui/index.css

### fsn_crafting/nui/index.js
*Role:* shared
### fsn_voicecontrol/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_voicecontrol/client.lua
*Role:* client
*Events:* register:fsn_voicecontrol:call:ring, handler:fsn_voicecontrol:call:ring, trigger:fsn_voicecontrol:call:end, trigger:fsn_voicecontrol:call:unhold, trigger:fsn_voicecontrol:call:end, trigger:fsn_voicecontrol:call:hold, trigger:fsn_voicecontrol:call:end, trigger:fsn_voicecontrol:call:answer, trigger:InteractSound_SV:PlayWithinDistance
### fsn_voicecontrol/server.lua
*Role:* server
*Events:* handler:fsn_voicecontrol:call:ring, handler:fsn_voicecontrol:call:answer, handler:fsn_voicecontrol:call:decline, handler:fsn_voicecontrol:call:hold, handler:fsn_voicecontrol:call:unhold, handler:fsn_voicecontrol:call:end, trigger:fsn_voicecontrol:call:ring, trigger:fsn_notify:displayNotification, trigger:fsn_voicecontrol:call:end, trigger:fsn_notify:displayNotification, trigger:fsn_voicecontrol:call:start, trigger:fsn_voicecontrol:call:start, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_voicecontrol:call:end, trigger:fsn_voicecontrol:call:end, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_voicecontrol:call:hold, trigger:fsn_voicecontrol:call:hold, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_voicecontrol:call:unhold, trigger:fsn_voicecontrol:call:unhold, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_voicecontrol:call:end, trigger:fsn_voicecontrol:call:end, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification
### fsn_voicecontrol/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_inventory_dropping/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_inventory_dropping/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_inventory_dropping/sv_dropping.lua
*Role:* server
*Events:* register:fsn_inventory:drops:request, register:fsn_inventory:drops:collect, register:fsn_inventory:drops:drop, handler:fsn_inventory:drops:request, handler:fsn_inventory:drops:collect, handler:fsn_inventory:drops:drop, trigger:fsn_inventory:drops:send, trigger:mythic_notify:client:SendAlert, trigger:fsn_inventory:items:add, trigger:mythic_notify:client:SendAlert, trigger:fsn_inventory:drops:send, trigger:mythic_notify:client:SendAlert, trigger:fsn_inventory:drops:send
### fsn_inventory_dropping/cl_dropping.lua
*Role:* client
*Events:* register:fsn_inventory:drops:send, handler:fsn_inventory:drops:send, trigger:fsn_inventory:drops:collect, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:drops:request

### fsn_phones/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_phones/fxmanifest.lua
*Role:* shared
*Description:* [[/   :FIVEM MANIFEST SHIT:	\]]--
*DB Calls:* MySQL.lua
### fsn_phones/sv_phone.lua
*Role:* server
*Description:* path for live server
*Events:* handler:fsn_phones:SYS:request:details, handler:fsn_phones:SYS:set:details, handler:fsn_phones:SYS:requestGarage, handler:fsn_phones:SYS:newNumber, handler:fsn_phones:UTIL:chat, handler:fsn_phones:USE:sendMessage, handler:fsn_phones:SYS:sendTweet, handler:c, handler:fsn_phones:USE:sendAdvert, handler:playerDropped, trigger:fsn_phones:SYS:recieve:details, trigger:fsn_phones:GUI:notification, trigger:fsn_phones:SYS:receiveGarage, trigger:fsn_phones:SYS:set:details, trigger:fsn_phones:SYS:updateNumber, trigger:fsn_main:updateCharNumber, trigger:fsn_phones:GUI:notification, trigger:fsn_phones:USE:Email, trigger:chatMessage, trigger:fsn_phones:USE:Message, trigger:fsn_phones:USE:Tweet, trigger:fsn_phones:SYS:updateAdverts, trigger:fsn_phones:SYS:updateAdverts, trigger:fsn_phones:SYS:updateAdverts
*DB Calls:* MySQL.Async

### fsn_phones/cl_phone.lua
*Role:* client
*Description:* datastores
*Events:* register:fsn_phones:SYS:updateNumber, register:fsn_phones:UTIL:displayNumber, register:fsn_phones:SYS:receiveGarage, register:fsn_phones:GUI:notification, register:fsn_phones:USE:Phone, register:fsn_phones:USE:Email, register:fsn_phones:USE:Message, register:fsn_phones:USE:Tweet, register:fsn_phones:SYS:updateAdverts, register:fsn_phones:SYS:recieve:details, register:fsn_phones:SYS:addTransaction, register:fsn_phones:SYS:addCall, register:fsn_phones:SYS:addCall, handler:fsn_phones:SYS:updateNumber, handler:fsn_phones:UTIL:displayNumber, handler:fsn_phones:SYS:receiveGarage, handler:fsn_phones:GUI:notification, handler:fsn_phones:USE:Phone, handler:fsn_phones:USE:Email, handler:fsn_phones:USE:Message, handler:fsn_phones:USE:Tweet, handler:fsn_phones:SYS:updateAdverts, handler:fsn_phones:SYS:recieve:details, handler:fsn_phones:SYS:addTransaction, handler:fsn_main:character, trigger:fsn_phones:UTIL:chat, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_phones:SYS:requestGarage, trigger:fsn_phones:SYS:set:details, trigger:fsn_phones:SYS:set:details, trigger:fsn_phones:SYS:sendTweet, trigger:fsn_phones:USE:sendMessage, trigger:fsn_phones:SYS:set:details, trigger:fsn_phones:USE:sendAdvert, trigger:InteractSound_SV:PlayWithinDistance, trigger:fsn_phones:GUI:notification, trigger:fsn_phones:GUI:notification, trigger:fsn_phones:SYS:set:details, trigger:fsn_phones:GUI:notification, trigger:fsn_phones:GUI:notification, trigger:chatMessage, trigger:fsn_phones:SYS:request:details, trigger:fsn_phones:SYS:request:details, trigger:fsn_phones:SYS:updateAdverts, trigger:fsn_phones:SYS:newNumber
*NUI Callbacks:* messageactive, messageinactive
*NUI Messages:* SendNUIMessage

### fsn_phones/html/index.html.old
### fsn_phones/html/index.html
### fsn_phones/html/index.css
### fsn_phones/html/index.js

### fsn_phones/html/pages_css/iphone/garage.css
### fsn_phones/html/pages_css/iphone/whitelists.css
### fsn_phones/html/pages_css/iphone/adverts.css

### fsn_phones/html/pages_css/iphone/call.css
### fsn_phones/html/pages_css/iphone/phone.css
### fsn_phones/html/pages_css/iphone/darkweb.css
### fsn_phones/html/pages_css/iphone/main.css
*Description:* phone-iphone {

### fsn_phones/html/pages_css/iphone/pay.css
### fsn_phones/html/pages_css/iphone/email.css
### fsn_phones/html/pages_css/iphone/home.css
*Description:* page-iphone-home {
### fsn_phones/html/pages_css/iphone/twitter.css

### fsn_phones/html/pages_css/iphone/contacts.css
### fsn_phones/html/pages_css/iphone/messages.css
### fsn_phones/html/pages_css/iphone/fleeca.css

### fsn_phones/html/pages_css/samsung/whitelists.css
### fsn_phones/html/pages_css/samsung/adverts.css
### fsn_phones/html/pages_css/samsung/call.css

### fsn_phones/html/pages_css/samsung/phone.css
### fsn_phones/html/pages_css/samsung/main.css
### fsn_phones/html/pages_css/samsung/pay.css
### fsn_phones/html/pages_css/samsung/email.css
### fsn_phones/html/pages_css/samsung/home.css

### fsn_phones/html/pages_css/samsung/twitter.css
### fsn_phones/html/pages_css/samsung/contacts.css
### fsn_phones/html/pages_css/samsung/messages.css
### fsn_phones/html/pages_css/samsung/fleeca.css

### fsn_phones/html/img/cursor.png
### fsn_phones/html/img/Apple/Twitter.png
### fsn_phones/html/img/Apple/node_other_server__1247323.png
### fsn_phones/html/img/Apple/Ads.png

### fsn_phones/html/img/Apple/wallpaper.png
*Role:* NUI
### fsn_phones/html/img/Apple/Mail.png

### fsn_phones/html/img/Apple/Whitelist.png
*Role:* NUI
### fsn_phones/html/img/Apple/darkweb.png

### fsn_phones/html/img/Apple/Noti.png
*Role:* NUI
### fsn_phones/html/img/Apple/Frame.png

### fsn_phones/html/img/Apple/wifi.png
### fsn_phones/html/img/Apple/default-avatar.png
### fsn_phones/html/img/Apple/Wallet.png

### fsn_phones/html/img/Apple/signal.png
### fsn_phones/html/img/Apple/battery.png
### fsn_phones/html/img/Apple/missed-out.png

### fsn_phones/html/img/Apple/Fleeca.png
### fsn_phones/html/img/Apple/feedgrey.png
### fsn_phones/html/img/Apple/Messages.png

### fsn_phones/html/img/Apple/Phone.png
### fsn_phones/html/img/Apple/call-out.png

### fsn_phones/html/img/Apple/call-in.png
### fsn_phones/html/img/Apple/missed-in.png
### fsn_phones/html/img/Apple/Lock icon.png
### fsn_phones/html/img/Apple/Contact.png

### fsn_phones/html/img/Apple/fleeca-bg.png
### fsn_phones/html/img/Apple/Garage.png
### fsn_phones/html/img/Apple/banner_icons/garage.png
### fsn_phones/html/img/Apple/banner_icons/call.png

### fsn_phones/html/img/Apple/banner_icons/contacts.png
### fsn_phones/html/img/Apple/banner_icons/adverts.png
### fsn_phones/html/img/Apple/banner_icons/wallet.png
### fsn_phones/html/img/Apple/banner_icons/fleeca.png

### fsn_phones/html/img/Apple/banner_icons/wl.png
### fsn_phones/html/img/Apple/banner_icons/messages.png

### fsn_phones/html/img/Apple/banner_icons/mail.png
### fsn_phones/html/img/Apple/banner_icons/twitter.png
### fsn_phones/html/img/Apple/Banner/log-inBackground.png

### fsn_phones/html/img/Apple/Banner/fleeca.png
### fsn_phones/html/img/Apple/Banner/Yellow.png

### fsn_phones/html/img/Apple/Banner/Adverts.png
### fsn_phones/html/img/Apple/Banner/Grey.png
### fsn_phones/darkweb/cl_order.lua
*Role:* client
*Events:* register:fsn_phones:USE:darkweb:order, handler:fsn_phones:USE:darkweb:order, trigger:fsn_notify:displayNotification

### fsn_phones/datastore/messages/sample.txt
*Role:* shared

### fsn_phones/datastore/contacts/sample.txt
*Role:* shared

### fsn_licenses/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_licenses/sv_desk.lua
*Role:* server
*Events:* handler:fsn_licenses:id:request, trigger:fsn_inventory:items:add

### fsn_licenses/client.lua
*Role:* client
*Events:* register:fsn_licenses:update, register:fsn_licenses:showid, register:fsn_licenses:infraction, register:fsn_licenses:setinfractions, register:fsn_licenses:display, register:fsn_licenses:police:give, handler:fsn_main:character, handler:fsn_licenses:update, handler:fsn_licenses:showid, handler:fsn_licenses:infraction, handler:fsn_licenses:setinfractions, handler:fsn_licenses:display, handler:fsn_licenses:police:give, trigger:fsn_licenses:check, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:update, trigger:fsn_licenses:chat, trigger:fsn_licenses:update, trigger:fsn_licenses:check, trigger:fsn_licenses:update, trigger:fsn_licenses:chat, trigger:fsn_licenses:chat, trigger:fsn_licenses:chat, trigger:fsn_licenses:chat, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:chat, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:chat, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:update, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:update, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_licenses/server.lua
*Role:* server
*Events:* handler:fsn_licenses:chat, handler:fsn_licenses:check, handler:fsn_licenses:update, trigger:chatMessage, trigger:chatMessage, trigger:fsn_licenses:update, trigger:fsn_licenses:update
*DB Calls:* MySQL.Async

### fsn_licenses/cl_desk.lua
*Role:* client
*Events:* register:fsn_licenses:giveID, handler:fsn_main:character, handler:fsn_licenses:giveID, trigger:fsn_licenses:id:request, trigger:fsn_licenses:id:request

### fsn_licenses/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_menu/ui.html
### fsn_menu/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_menu/fxmanifest.lua
*Role:* shared

### fsn_menu/main_client.lua
*Role:* client
*Events:* register:fsn_commands:getHDC, handler:fsn_commands:getHDC, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_police:ToggleK9, trigger:fsn_police:ToggleFollow, trigger:fsn_notify:displayNotification, trigger:fsn_police:Sit, trigger:fsn_police:GetInVehicle, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:showid, trigger:fsn_licenses:display, trigger:fsn_licenses:display, trigger:fsn_licenses:display, trigger:fsn_criminalmisc:racing:createRace, trigger:fsn_vehiclecontrol:giveKeys, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:EngineToggle:Engine, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification
*NUI Callbacks:* escape
*NUI Messages:* SendNUIMessage

### fsn_menu/ui.js
*Role:* shared

### fsn_menu/ui.css

### fsn_menu/gui/ui.html
### fsn_menu/gui/ui.js
*Role:* shared

### fsn_menu/gui/ui.css
### fsn_errorcontrol/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_errorcontrol/client.lua
*Role:* client
*Events:* trigger:fsn_main:logging:addLog

### fsn_errorcontrol/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_handling/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_handling/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_handling/src/coupes.lua
*Role:* shared
*Description:* Coupe Cars

### fsn_handling/src/schafter.lua
*Role:* shared
*Description:* SCHAFTER2, SCHAFTER3, SCHAFTER4

### fsn_handling/src/sedans.lua
*Role:* shared
*Description:* Sedan Cars

### fsn_handling/src/offroad.lua
*Role:* shared
*Description:* Off Road

### fsn_handling/src/sportsclassics.lua
*Role:* shared
*Description:* Sports Classic Cars

### fsn_handling/src/compact.lua
*Role:* shared
*Description:* Compact Cars

### fsn_handling/src/muscle.lua
*Role:* shared
*Description:* Muscle Cars

### fsn_handling/src/government.lua
*Role:* shared
*Description:* Government Vehicle

### fsn_handling/src/motorcycles.lua
*Role:* shared
*Description:* Motorcycles

### fsn_handling/src/super.lua
*Role:* shared
*Description:* Super Cars

### fsn_handling/src/suvs.lua
*Role:* shared
*Description:* SUVs

### fsn_handling/src/sports.lua
*Role:* shared
*Description:* Sports Cars

### fsn_handling/src/vans.lua
*Role:* shared
*Description:* Vans

### fsn_handling/data/handling.meta
*Role:* shared

### fsn_commands/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_commands/client.lua
*Role:* client
*Events:* register:fsn_commands:clothing:mask, register:fsn_commands:clothing:hat, register:fsn_commands:clothing:glasses, register:fsn_commands:service:pingAccept, register:fsn_commands:service:pingStart, register:fsn_commands:service:request, register:fsn_commands:vehdoor:open, register:fsn_commands:vehdoor:close, register:fsn_commands:window, register:fsn_commands:hc:takephone, register:fsn_commands:getHDC, register:fsn_commands:dropweapon, register:fsn_commands:walk:set, register:fsn_commands:me, register:fsn_commands:me:3d, register:fsn_commands:sendxyz, register:fsn_commands:airlift, register:fsn_commands:dev:spawnCar, register:fsn_commands:dev:weapon, register:fsn_commands:dev:fix, register:fsn_commands:police:shotgun, register:fsn_commands:police:rifle, register:fsn_commands:police:towMark, register:fsn_commands:police:pedcarry, register:fsn_commands:police:pedrevive, register:fsn_commands:police:cpic:trigger, register:fsn_commands:police:livery, register:fsn_commands:police:extras, register:fsn_commands:police:extra, register:fsn_commands:police:car, register:fsn_commands:police:fix, register:fsn_commands:police:boot, register:fsn_police:runplate:target, register:fsn_commands:police:unboot, register:fsn_commands:police:updateBoot, register:fsn_commands:police:impound, register:fsn_commands:police:impound2, handler:fsn_commands:clothing:mask, handler:fsn_commands:clothing:hat, handler:fsn_commands:clothing:glasses, handler:fsn_commands:service:pingAccept, handler:fsn_commands:service:pingStart, handler:fsn_commands:service:request, handler:fsn_commands:vehdoor:open, handler:fsn_commands:vehdoor:close, handler:fsn_commands:window, handler:fsn_commands:hc:takephone, handler:fsn_commands:getHDC, handler:fsn_main:character, handler:fsn_commands:dropweapon, handler:fsn_commands:walk:set, handler:fsn_commands:me, handler:fsn_commands:me:3d, handler:fsn_commands:sendxyz, handler:fsn_commands:airlift, handler:fsn_commands:dev:spawnCar, handler:fsn_commands:dev:weapon, handler:fsn_commands:dev:fix, handler:fsn_commands:police:shotgun, handler:fsn_commands:police:rifle, handler:fsn_commands:police:towMark, handler:fsn_commands:police:pedcarry, handler:fsn_commands:police:pedrevive, handler:fsn_commands:police:cpic:trigger, handler:fsn_commands:police:livery, handler:fsn_commands:police:extras, handler:fsn_commands:police:extra, handler:fsn_commands:police:car, handler:fsn_commands:police:fix, handler:fsn_commands:police:boot, handler:fsn_police:runplate:target, handler:fsn_commands:police:unboot, handler:fsn_commands:police:updateBoot, handler:fsn_commands:police:impound, handler:fsn_commands:police:impound2, trigger:fsn_commands:me, trigger:fsn_commands:me, trigger:fsn_commands:me, trigger:fsn_commands:me, trigger:fsn_commands:me, trigger:fsn_commands:me, trigger:fsn_commands:service:addPing, trigger:fsn_commands:service:sendrequest, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_commands:requestHDC, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_commands:printxyz, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:add:unknown, trigger:fsn_fuel:update, trigger:fsn_criminalmisc:weapons:add:police, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:add:police, trigger:fsn_inventory:items:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:add:police, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:add:police, trigger:fsn_inventory:items:add, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_police:database:CPIC:search, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:makeMine, trigger:fsn_fuel:set, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_commands:police:booted, trigger:fsn_notify:displayNotification, trigger:fsn_commands:police:booted, trigger:fsn_police:runplate::target, trigger:fsn_notify:displayNotification, trigger:fsn_commands:police:unbooted, trigger:fsn_notify:displayNotification, trigger:fsn_commands:police:unbooted, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:impound, trigger:fsn_cargarage:impound

### fsn_commands/server.lua
*Role:* server
*Events:* handler:fsn_main:updateCharacters, handler:fsn_police:update, handler:fsn_ems:update, handler:fsn_commands:me, handler:fsn_commands:requestHDC, handler:fsn_commands:service:addPing, handler:chatMessage, handler:fsn_main:money:wallet:Set, handler:fsn_commands:service:sendrequest, handler:fsn_commands:printxyz, handler:fsn_commands:police:booted, handler:fsn_commands:police:unbooted, handler:fsn_commands:police:gsrResult, handler:fsn_commands:ems:adamage:inspect, trigger:fsn_commands:me:3d, trigger:fsn_commands:getHDC, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_main:logging:addLog, trigger:fsn_jobs:news:role:Set, trigger:fsn_jobs:news:role:Toggle, trigger:fsn_main:money:wallet:GiveCash, trigger:fsn_main:logging:addLog, trigger:chatMessage, trigger:fsn_commands:clothing:mask, trigger:fsn_commands:clothing:hat, trigger:fsn_commands:clothing:glasses, trigger:fsn_commands:service:pingAccept, trigger:mythic_notify:client:SendAlert, trigger:chatMessage, trigger:chatMessage, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:service:pingStart, trigger:fsn_commands:me, trigger:chatMessage, trigger:fsn_commands:service:request, trigger:fsn_commands:service:request, trigger:fsn_commands:service:request, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_emotecontrol:phone:call1, trigger:chatMessage, trigger:fsn_police:911, trigger:fsn_ems:911, trigger:chatMessage, trigger:fsn_police:911r, trigger:fsn_ems:911r, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_ems:set:WalkType, trigger:fsn_criminalmisc:weapons:destroy, trigger:fsn_criminalmisc:weapons:drop, trigger:fsn_criminalmisc:weapons:info, trigger:fsn_phone:togglePhone, trigger:fsn_phones:USE:Phone, trigger:fsn_phone:displayNumber, trigger:fsn_phones:UTIL:displayNumber, trigger:fsn_emotecontrol:sit, trigger:fsn_commands:me, trigger:fsn_notify:displayNotification, trigger:fsn_commands:me, trigger:fsn_emotecontrol:dice:roll, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_commands:airlift, trigger:fsn_commands:vehdoor:open, trigger:fsn_commands:vehdoor:open, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:vehdoor:close, trigger:fsn_commands:vehdoor:close, trigger:chatMessage, trigger:fsn_inventory:veh:glovebox, trigger:fsn_commands:window, trigger:fsn_main:blip:clear, trigger:fsn_emotecontrol:play, trigger:fsn_emotecontrol:play, trigger:fsn_emotecontrol:play, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_main:displayBankandMoney, trigger:fsn_jobs:quit, trigger:fsn_notify:displayNotification, trigger:fsn_main:characterSaving, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_vehiclecontrol:damage:repair, trigger:chatMessage, trigger:fsn_police:handcuffs:hard, trigger:fsn_police:toggleDrag, trigger:fsn_police:search:start:inventory, trigger:fsn_police:search:start:weapons, trigger:fsn_police:search:start:money, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_commands:hc:rob, trigger:fsn_commands:hc:takephone, trigger:xgc-tuner:openTuner, trigger:fsn_inventory:ply:request, trigger:fsn_main:charMenu, trigger:fsn_commands:police:pedrevive, trigger:fsn_commands:police:pedcarry, trigger:fsn_bank:change:walletAdd, trigger:fsn_police:command:duty, trigger:fsn_police:command:duty, trigger:fsn_licenses:setinfractions, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_dev:debug, trigger:fsn_apartments:instance:debug, trigger:fsn_police:MDT:toggle, trigger:fsn_ems:reviveMe:force, trigger:fsn_commands:sendxyz, trigger:fsn_commands:dev:spawnCar, trigger:fsn_commands:dev:weapon, trigger:fsn_commands:dev:fix, trigger:fsn_inventory:item:add, trigger:fsn_ems:killMe, trigger:fsn_ems:killMe, trigger:fsn_teleporters:teleport:waypoint, trigger:fsn_teleporters:teleport:coordinates, trigger:fsn_dev:noClip:enabled, trigger:fsn_ems:adamage:request, trigger:chatMessage, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_ems:reviveMe:force, trigger:fsn_commands:police:towMark, trigger:fsn_jobs:tow:mark, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_commands:police:extra, trigger:fsn_commands:police:extra, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:police:livery, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:police:impound, trigger:fsn_commands:police:pedcarry, trigger:fsn_commands:police:pedrevive, trigger:fsn_commands:police:car, trigger:chatMessage, trigger:fsn_ems:updateLevel, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:toggleDrag, trigger:fsn_police:putMeInVeh, trigger:fsn_ems:reviveMe, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:police:rifle, trigger:fsn_commands:police:shotgun, trigger:fsn_ems:adamage:request, trigger:chatMessage, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add, trigger:chatMessage, trigger:fsn_police:ticket, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:MDT:toggle, trigger:fsn_emotecontrol:police:tablet, trigger:fsn_commands:police:gsrMe, trigger:fsn_commands:police:towMark, trigger:fsn_jobs:tow:mark, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_commands:police:pedcarry, trigger:fsn_commands:police:pedrevive, trigger:fsn_police:radar:toggle, trigger:fsn_emotecontrol:police:ticket, trigger:fsn_commands:police:cpic:trigger, trigger:fsn_police:search:start:inventory, trigger:fsn_police:search:start:weapons, trigger:fsn_police:search:start:money, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_police:search:start:inventory, trigger:fsn_inventory:ply:request, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_police:search:start:weapons, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_police:search:start:money, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_police:search:strip, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_police:k9:search:person:me, trigger:fsn_licenses:police:give, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:police:give, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_licenses:police:give, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_police:command:duty, trigger:chatMessage, trigger:fsn_police:updateLevel, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_licenses:infraction, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:chatMessage, trigger:fsn_licenses:display, trigger:chatMessage, trigger:fsn_licenses:display, trigger:chatMessage, trigger:fsn_licenses:display, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:dispatch:toggle, trigger:fsn_police:runplate, trigger:fsn_police:runplate:target, trigger:chatMessage, trigger:fsn_ems:reviveMe, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:handcuffs:soft, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:handcuffs:hard, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:police:livery, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:police:extras, trigger:fsn_commands:police:extra, trigger:fsn_commands:police:extra, trigger:chatMessage, trigger:chatMessage, trigger:fsn_police:toggleDrag, trigger:fsn_commands:police:boot, trigger:fsn_commands:police:unboot, trigger:fsn_police:putMeInVeh, trigger:fsn_commands:police:car, trigger:fsn_commands:police:car, trigger:chatMessage, trigger:chatMessage, trigger:fsn_commands:police:fix, trigger:chatMessage, trigger:fsn_commands:police:impound, trigger:fsn_commands:police:impound2, trigger:chatMessage, trigger:fsn_jail:sendsuspect, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:taxi:request, trigger:fsn_jobs:tow:request, trigger:fsn_jobs:ems:request, trigger:fsn_commands:police:updateBoot, trigger:fsn_commands:police:updateBoot, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage
*DB Calls:* MySQL.Sync

### fsn_commands/fxmanifest.lua
*Role:* shared
*DB Calls:* MySQL.lua

### fsn_playerlist/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_playerlist/client.lua
*Role:* client
*Events:* register:fsn_main:updateCharacters, register:fsn_main:updateCharacters, handler:fsn_main:updateCharacters, handler:fsn_main:updateCharacters, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage
*NUI Messages:* SendNUIMessage

### fsn_playerlist/fxmanifest.lua
*Role:* shared

### fsn_playerlist/gui/index.html

### fsn_playerlist/gui/index.js
*Role:* shared

### fsn_builders/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_builders/fxmanifest.lua
*Role:* shared
*DB Calls:* MySQL.lua

### fsn_builders/xml.lua
*Role:* shared

### fsn_builders/schema.lua
*Role:* shared

### fsn_builders/handling_builder.lua
*Role:* shared
### fsn_builders/schemas/cbikehandlingdata.lua
*Role:* shared

### fsn_builders/schemas/chandlingdata.lua
*Role:* shared
*Description:* Groups from https://gtamods.com/wiki/Handling.meta
### fsn_builders/schemas/ccarhandlingdata.lua
*Role:* shared
### fsn_carstore/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_carstore/sv_carstore.lua
*Role:* server
*Events:* handler:fsn_carstore:floor:Request, handler:chatMessage, handler:fsn_carstore:floor:color:One, handler:fsn_carstore:floor:color:Two, handler:fsn_carstore:floor:commission, handler:fsn_carstore:floor:ChangeCar, trigger:fsn_carstore:floor:Update, trigger:fsn_carstore:floor:commission, trigger:mythic_notify:client:SendAlert, trigger:fsn_carstore:floor:color:One, trigger:mythic_notify:client:SendAlert, trigger:fsn_carstore:floor:color:Two, trigger:mythic_notify:client:SendAlert, trigger:fsn_carstore:testdrive:end, trigger:fsn_carstore:testdrive:start, trigger:fsn_carstore:floor:UpdateCar, trigger:fsn_carstore:floor:UpdateCar, trigger:fsn_carstore:floor:UpdateCar, trigger:fsn_carstore:floor:UpdateCar, trigger:mythic_notify:client:SendAlert

### fsn_carstore/fxmanifest.lua
*Role:* shared
*DB Calls:* MySQL.lua
### fsn_carstore/cl_menu.lua
*Role:* client
*Events:* handler:playerSpawned, trigger:fsn_carstore:floor:ChangeCar, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification

### fsn_carstore/cl_carstore.lua
*Role:* client
*Events:* register:fsn_carstore:floor:Update, register:fsn_carstore:floor:UpdateCar, register:fsn_carstore:floor:commission, register:fsn_carstore:floor:color:One, register:fsn_carstore:floor:color:Two, handler:fsn_carstore:floor:Update, handler:fsn_carstore:floor:UpdateCar, handler:fsn_carstore:floor:commission, handler:fsn_carstore:floor:color:One, handler:fsn_carstore:floor:color:Two, trigger:fsn_cargarage:buyVehicle, trigger:fsn_bank:change:walletMinus, trigger:fsn_cargarage:makeMine, trigger:fsn_carstore:floor:Request, trigger:fsn_carstore:floor:commission, trigger:fsn_carstore:floor:color:One, trigger:fsn_carstore:floor:color:Two, trigger:fsn_cargarage:makeMine
### fsn_carstore/vehshop_server.lua
*Role:* server
### fsn_carstore/gui/index.html
### fsn_evidence/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_evidence/__descriptions-male.lua
*Role:* shared
### fsn_evidence/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_evidence/sv_evidence.lua
*Role:* server
*Events:* handler:fsn_evidence:request, handler:fsn_evidence:collect, handler:fsn_evidence:destroy, handler:fsn_evidence:drop:casing, handler:fsn_evidence:drop:blood, trigger:fsn_evidence:receive, trigger:fsn_evidence:display, trigger:mythic_notify:client:SendAlert, trigger:fsn_evidence:receive, trigger:mythic_notify:client:SendAlert, trigger:mythic_notify:client:SendAlert, trigger:fsn_evidence:receive, trigger:fsn_evidence:receive, trigger:fsn_evidence:receive, trigger:fsn_evidence:receive
### fsn_evidence/cl_evidence.lua
*Role:* client
*Events:* register:fsn_evidence:receive, register:fsn_evidence:display, handler:fsn_evidence:receive, handler:fsn_evidence:display, trigger:fsn_evidence:collect, trigger:fsn_evidence:destroy, trigger:fsn_evidence:request

### fsn_evidence/__descriptions-carpaint.lua
*Role:* shared
### fsn_evidence/__descriptions-female.lua
*Role:* shared
### fsn_evidence/__descriptions.lua
*Role:* shared
*Description:* export for getting description of current clothing!
*Commands:* evi_clothing
### fsn_evidence/ped/sv_ped.lua
*Role:* server
*Events:* handler:fsn_evidence:ped:update, trigger:fsn_evidence:ped:update
### fsn_evidence/ped/cl_ped.lua
*Role:* client
*Description:* GetWorldPositionOfEntityBone
*Events:* register:fsn_evidence:ped:update, register:fsn_evidence:ped:addState, register:fsn_evidence:ped:updateDamage, handler:fsn_evidence:ped:update, handler:fsn_evidence:ped:addState, handler:fsn_evidence:ped:updateDamage, trigger:fsn_evidence:ped:update, trigger:fsn_evidence:ped:addState
### fsn_evidence/casings/cl_casings.lua
*Role:* client
*Events:* register:fsn_evidence:weaponInfo, handler:fsn_evidence:weaponInfo, trigger:fsn_evidence:drop:casing
### fsn_jobs/agents.md
*Role:* shared
*Description:* AGENTS.md
### fsn_jobs/client.lua
*Role:* client
*Events:* register:fsn_jobs:quit, register:fsn_jobs:paycheck, handler:fsn_jobs:quit, handler:fsn_jobs:paycheck, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification

### fsn_jobs/server.lua
*Role:* server
*Events:* trigger:fsn_jobs:paycheck
### fsn_jobs/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua
### fsn_jobs/hunting/client.lua
*Role:* client
*Events:* trigger:fsn_inventory:item:add, trigger:chatMessage, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:add

### fsn_jobs/mechanic/client.lua
*Role:* client
*Events:* register:fsn_jobs:mechanic:toggleduty, handler:fsn_jobs:mechanic:toggleduty, handler:onClientResourceStart, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:fsn_fuel:update, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:mechanic:toggle, trigger:fsn_jobs:mechanic:toggle, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage
*Commands:* vehinspect, vehrepair

### fsn_jobs/mechanic/server.lua
*Role:* server
*Events:* handler:fsn_jobs:mechanic:toggle, trigger:fsn_jobs:mechanic:toggleduty, trigger:fsn_jobs:mechanic:toggleduty, trigger:fsn_notify:displayNotification
### fsn_jobs/mechanic/mechmenu.lua
*Role:* shared
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:updateVehicle, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus, trigger:fsn_bank:change:walletMinus
### fsn_jobs/whitelists/client.lua
*Role:* client
*Events:* register:fsn_jobs:whitelist:clock:in, register:fsn_jobs:whitelist:clock:out, register:fsn_jobs:whitelist:update, handler:fsn_jobs:whitelist:clock:in, handler:fsn_jobs:whitelist:clock:out, handler:fsn_jobs:whitelist:update, trigger:fsn_jobs:whitelist:request, trigger:fsn_jobs:whitelist:add, trigger:fsn_jobs:whitelist:remove, trigger:fsn_jobs:whitelist:clock:in, trigger:fsn_jobs:whitelist:clock:out, trigger:fsn_jobs:whitelist:request
### fsn_jobs/whitelists/server.lua
*Role:* server
*Events:* handler:fsn_jobs:whitelist:request, handler:fsn_jobs:whitelist:add, handler:fsn_jobs:whitelist:remove, handler:fsn_jobs:whitelist:clock:in, handler:fsn_jobs:whitelist:clock:out, handler:fsn_jobs:whitelist:access:add, trigger:fsn_jobs:whitelist:update, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:whitelist:update, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:whitelist:update, trigger:fsn_jobs:whitelist:clock:in, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:whitelist:update, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:whitelist:clock:out, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:whitelist:update, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_jobs:whitelist:update, trigger:fsn_jobs:whitelist:update
*DB Calls:* MySQL.Async, MySQL.ready
### fsn_jobs/taxi/client.lua
*Role:* client
*Events:* register:fsn_jobs:taxi:request, register:fsn_jobs:taxi:accepted, handler:fsn_main:character, handler:fsn_jobs:taxi:request, handler:fsn_jobs:taxi:accepted, trigger:fsn_fuel:update, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:makeMine, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankMinus, trigger:fsn_bank:change:walletAdd
### fsn_jobs/taxi/server.lua
*Role:* server

### fsn_jobs/trucker/client.lua
*Role:* client
*Events:* trigger:fsn_fuel:update, trigger:fsn_cargarage:makeMine, trigger:fsn_bank:change:walletMinus, trigger:chatMessage, trigger:fsn_cargarage:makeMine, trigger:fsn_bank:change:walletMinus, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:chatMessage, trigger:fsn_bank:change:walletAdd, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletAdd, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankMinus
### fsn_jobs/tow/client.lua
*Role:* client
*Events:* register:jTow:mark, register:fsn_jobs:tow:marked, register:tow:CAD:tow, register:jTow:afford, register:fsn_jobs:tow:request, handler:jTow:mark, handler:fsn_jobs:tow:marked, handler:tow:CAD:tow, handler:jTow:afford, handler:fsn_jobs:tow:request, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:jCAD:tow, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:jTow:spawn, trigger:fsn_fuel:update, trigger:fsn_cargarage:makeMine, trigger:jTow:success, trigger:fsn_bank:change:walletAdd, trigger:fsn_bank:change:walletAdd, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:jTow:return, trigger:fsn_bank:change:walletAdd, trigger:fsn_main:blip:add, trigger:fsn_bank:change:walletMinus, trigger:pNotify:SendNotification

### fsn_jobs/tow/server.lua
*Role:* server
*Events:* handler:fsn_jobs:tow:mark, trigger:fsn_jobs:tow:marked
### fsn_jobs/farming/client.lua
*Role:* client
*Events:* trigger:fsn_cargarage:makeMine, trigger:pNotify:SendNotification, trigger:jFarm:payme, trigger:fsn_bank:change:walletAdd, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification, trigger:pNotify:SendNotification

### fsn_jobs/scrap/client.lua
*Role:* client
*Events:* trigger:chatMessage, trigger:fsn_inventory:item:add, trigger:fsn_inventory:items:add, trigger:chatMessage, trigger:chatMessage
### fsn_jobs/news/client.lua
*Role:* client
*Events:* register:fsn_jobs:news:role:Set, register:Cam:ToggleCam, register:camera:Activate, register:Mic:ToggleMic, handler:fsn_jobs:news:role:Set, handler:Cam:ToggleCam, handler:camera:Activate, handler:Mic:ToggleMic, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:Cam:ToggleCam, trigger:Mic:ToggleMic, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_jobs/delivery/client.lua
*Role:* client
*Events:* trigger:fsn_fuel:update, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_jobs/garbage/client.lua
*Role:* client
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankAdd, trigger:fsn_fuel:update, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:bankMinus
### fsn_jobs/repo/client.lua
*Role:* client

### fsn_jobs/repo/server.lua
*Role:* server

### fsn_doj/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_doj/client.lua
### fsn_doj/fxmanifest.lua
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

### fsn_doj/attorneys/client.lua
*Role:* client

### fsn_doj/attorneys/server.lua
### fsn_doj/judges/client.lua
*Description:* Court things
*Events:* register:fsn_doj:court:remandMe, register:fsn_doj:judge:spawnCar, handler:fsn_doj:court:remandMe, handler:fsn_doj:judge:spawnCar, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_cargarage:makeMine, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification

### fsn_doj/judges/server.lua
*Role:* server
*Events:* handler:chatMessage, trigger:fsn_police:database:CPIC:search:result, trigger:chatMessage, trigger:fsn_bank:change:walletAdd, trigger:fsn_police:ticket, trigger:fsn_jail:sendsuspect, trigger:fsn_licenses:setinfractions, trigger:fsn_notify:displayNotification, trigger:fsn_doj:judge:toggleLock, trigger:chatMessage, trigger:fsn_doj:judge:toggleLock, trigger:chatMessage, trigger:chatMessage, trigger:fsn_doj:court:remandMe, trigger:fsn_doj:judge:spawnCar, trigger:chatMessage, trigger:chatMessage
*DB Calls:* MySQL.Async
### fsn_apartments/agents.md
*Description:* AGENTS.md

### fsn_apartments/client.lua
*Role:* client
*Description:* actual system
*Events:* register:fsn_apartments:stash:add, register:fsn_apartments:stash:take, register:fsn_apartments:sendApartment, register:fsn_apartments:outfit:add, register:fsn_apartments:outfit:use, register:fsn_apartments:outfit:remove, register:fsn_apartments:outfit:list, register:fsn_apartments:inv:update, register:fsn_apartments:characterCreation, handler:fsn_apartments:stash:add, handler:fsn_apartments:stash:take, handler:fsn_apartments:sendApartment, handler:fsn_apartments:outfit:add, handler:fsn_apartments:outfit:use, handler:fsn_apartments:outfit:remove, handler:fsn_apartments:outfit:list, handler:fsn_apartments:inv:update, handler:fsn_apartments:characterCreation, trigger:fsn_bank:change:walletMinus, trigger:fsn_apartments:saveApartment, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_bank:change:walletAdd, trigger:fsn_apartments:saveApartment, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_notify:displayNotification, trigger:chatMessage, trigger:fsn_apartments:saveApartment, trigger:chatMessage, trigger:clothes:spawn, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:chatMessage, trigger:fsn_criminalmisc:weapons:add:tbl, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_criminalmisc:weapons:destroy, trigger:fsn_inventory:apt:recieve, trigger:fsn_apartments:instance:leave, trigger:fsn_apartments:instance:leave, trigger:fsn_apartments:instance:new, trigger:fsn_clothing:menu, trigger:fsn_apartments:instance:new, trigger:fsn_apartments:createApartment, trigger:fsn_spawnmanager:start, trigger:fsn_apartments:saveApartment
*NUI Callbacks:* escape
*NUI Messages:* SendNUIMessage

### fsn_apartments/server.lua
*Role:* server
*Events:* handler:fsn_apartments:getApartment, handler:playerDropped, handler:fsn_apartments:createApartment, handler:fsn_apartments:saveApartment, handler:chatMessage, trigger:fsn_apartments:sendApartment, trigger:fsn_apartments:characterCreation, trigger:fsn_apartments:sendApartment, trigger:fsn_apartments:stash:add, trigger:chatMessage, trigger:fsn_apartments:stash:take, trigger:chatMessage, trigger:fsn_apartments:outfit:add, trigger:fsn_apartments:outfit:use, trigger:fsn_apartments:outfit:remove, trigger:fsn_apartments:outfit:list
*DB Calls:* MySQL.Sync

### fsn_apartments/fxmanifest.lua
*Role:* shared
*DB Calls:* MySQL.lua
### fsn_apartments/sv_instancing.lua
*Events:* handler:fsn_apartments:instance:leave, handler:fsn_apartments:instance:new, handler:fsn_apartments:instance:join, trigger:fsn_apartments:instance:leave, trigger:fsn_apartments:instance:update, trigger:chatMessage, trigger:fsn_apartments:instance:join, trigger:chatMessage, trigger:fsn_apartments:instance:update, trigger:fsn_apartments:instance:join, trigger:chatMessage
### fsn_apartments/cl_instancing.lua
*Events:* register:fsn_apartments:instance:join, register:fsn_apartments:instance:update, register:fsn_apartments:instance:leave, register:fsn_apartments:instance:debug, handler:fsn_apartments:instance:join, handler:fsn_apartments:instance:update, handler:fsn_apartments:instance:leave, handler:fsn_apartments:instance:debug
### fsn_apartments/gui/ui.html
*Role:* NUI

### fsn_apartments/gui/ui.js
### fsn_apartments/gui/ui.css
*Role:* NUI

## Cross Indexes

- 1a4d29ac-5c1a-427e-ab18-461ae6b76e8b: trigger@fsn_customanimations/client.lua
- 321236ce-42a6-43d8-af3d-e0e30c9e66b7: register@fsn_customanimations/client.lua; handler@fsn_customanimations/client.lua
- 394084c7-ac07-424a-982b-ab2267d8d55f: register@fsn_customanimations/client.lua; handler@fsn_customanimations/client.lua
- AnimSet:Alien: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Brave: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Business: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:ChiChi: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Hobo: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Hurry: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Injured: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Joy: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:ManEater: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Money: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Moon: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:NonChalant: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Posh: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Sad: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Sassy: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Sexy: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Shady: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Swagger: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Tipsy: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:Tired: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:ToughGuy: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- AnimSet:default: register@fsn_emotecontrol/walktypes/client.lua; handler@fsn_emotecontrol/walktypes/client.lua
- Cam:ToggleCam: register@fsn_jobs/news/client.lua; handler@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua
- DoLongHudText: trigger@fsn_bankrobbery/cl_safeanim.lua
- EngineToggle:Engine: register@fsn_vehiclecontrol/engine/client.lua; handler@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_menu/main_client.lua
- EngineToggle:RPDamage: register@fsn_vehiclecontrol/engine/client.lua; handler@fsn_vehiclecontrol/engine/client.lua
- InteractSound_SV:PlayWithinDistance: trigger@fsn_doormanager/cl_doors.lua; trigger@fsn_police/client.lua; trigger@fsn_voicecontrol/client.lua; trigger@fsn_phones/cl_phone.lua
- Mic:ToggleMic: register@fsn_jobs/news/client.lua; handler@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua
- PlayerSpawned: trigger@fsn_main/initial/client.lua
- Tackle:Client:TacklePlayer: register@fsn_police/tackle/client.lua; handler@fsn_police/tackle/client.lua; trigger@fsn_police/tackle/server.lua
- Tackle:Server:TacklePlayer: trigger@fsn_police/tackle/client.lua; handler@fsn_police/tackle/server.lua
- __cfx_internal:commandFallback: handler@fsn_newchat/sv_chat.lua
- __cfx_internal:serverPrint: register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua
- _chat:messageEntered: handler@fsn_newchat/sv_chat.lua; register@fsn_newchat/cl_chat.lua; trigger@fsn_newchat/cl_chat.lua
- binoculars:Activate: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_inventory/_item_misc/binoculars.lua; handler@fsn_inventory/_item_misc/binoculars.lua
- c: handler@fsn_phones/sv_phone.lua
- camera:Activate: register@fsn_jobs/news/client.lua; handler@fsn_jobs/news/client.lua
- chat:addMessage: trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua; trigger@fsn_admin/client/client.lua; trigger@fsn_admin/client/client.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua
- chat:addSuggestion: trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_customanimations/client.lua
- chat:addSuggestions: trigger@fsn_newchat/sv_chat.lua; register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua; trigger@fsn_newchat/cl_chat.lua
- chat:addTemplate: register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua
- chat:clear: register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua
- chat:init: handler@fsn_newchat/sv_chat.lua; handler@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/cl_chat.lua
- chat:removeSuggestion: register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua; trigger@fsn_customanimations/client.lua
- chatMessage: handler@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_properties/cl_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_emotecontrol/client.lua; trigger@fsn_emotecontrol/client.lua; trigger@fsn_emotecontrol/client.lua; trigger@fsn_emotecontrol/client.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/sv_chat.lua; register@fsn_newchat/cl_chat.lua; handler@fsn_newchat/cl_chat.lua; trigger@fsn_newchat/cl_chat.lua; handler@fsn_boatshop/sv_boatshop.lua; trigger@fsn_admin/client.lua; trigger@fsn_admin/client.lua; handler@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server_announce.lua; trigger@fsn_admin/server_announce.lua; register@fsn_notify/cl_notify.lua; register@fsn_notify/cl_notify.lua; handler@fsn_notify/cl_notify.lua; handler@fsn_notify/cl_notify.lua; trigger@fsn_main/playermanager/server.lua; trigger@fsn_main/initial/server.lua; trigger@fsn_main/initial/server.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_police/tackle/client.lua; trigger@fsn_police/tackle/client.lua; trigger@fsn_police/MDT/mdt_server.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/radar/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_priority/administration.lua; trigger@fsn_customanimations/client.lua; trigger@fsn_customanimations/client.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_licenses/server.lua; trigger@fsn_licenses/server.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_playerlist/client.lua; trigger@fsn_playerlist/client.lua; trigger@fsn_playerlist/client.lua; handler@fsn_carstore/sv_carstore.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/scrap/client.lua; trigger@fsn_jobs/scrap/client.lua; trigger@fsn_jobs/scrap/client.lua; handler@fsn_doj/judges/server.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; handler@fsn_apartments/server.lua; trigger@fsn_apartments/server.lua; trigger@fsn_apartments/server.lua; trigger@fsn_apartments/sv_instancing.lua; trigger@fsn_apartments/sv_instancing.lua; trigger@fsn_apartments/sv_instancing.lua
- clothes:changemodel: handler@fsn_clothing/client.lua; trigger@fsn_clothing/client.lua
- clothes:firstspawn: trigger@fsn_clothing/client.lua; handler@fsn_clothing/server.lua
- clothes:loaded: trigger@fsn_clothing/client.lua; trigger@fsn_clothing/client.lua
- clothes:save: trigger@fsn_clothing/client.lua
- clothes:setComponents: handler@fsn_clothing/client.lua; trigger@fsn_clothing/client.lua
- clothes:spawn: trigger@fsn_spawnmanager/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_spawnmanager/client.lua; register@fsn_clothing/client.lua; handler@fsn_clothing/client.lua; trigger@fsn_clothing/server.lua; trigger@fsn_apartments/client.lua
- freecam:onTick: handler@fsn_dev/client/cl_noclip.lua
- fs_freemode:displaytext: trigger@fsn_bankrobbery/trucks.lua
- fs_freemode:missionComplete: trigger@fsn_bankrobbery/trucks.lua
- fs_freemode:notify: trigger@fsn_bankrobbery/trucks.lua
- fsn->esx:clothing:spawn: trigger@fsn_spawnmanager/client.lua
- fsn:getFsnObject: trigger@fsn_dev/server/server.lua; trigger@fsn_admin/server/server.lua; handler@fsn_main/sv_utils.lua
- fsn:playerReady: register@fsn_dev/server/server.lua; handler@fsn_dev/server/server.lua; register@fsn_admin/server/server.lua; handler@fsn_admin/server/server.lua; trigger@fsn_main/initial/client.lua
- fsn_admin:FreezeMe: register@fsn_admin/client.lua; handler@fsn_admin/client.lua; trigger@fsn_admin/server.lua; register@fsn_admin/client/client.lua; handler@fsn_admin/client/client.lua; trigger@fsn_admin/server/server.lua
- fsn_admin:enableAdminCommands: register@fsn_admin/server/server.lua; handler@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua
- fsn_admin:enableModeratorCommands: register@fsn_admin/server/server.lua; handler@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua
- fsn_admin:fix: register@fsn_admin/server.lua; handler@fsn_admin/server.lua
- fsn_admin:menu:toggle: trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua
- fsn_admin:recieveXYZ: register@fsn_admin/client.lua; handler@fsn_admin/client.lua; trigger@fsn_admin/server.lua; register@fsn_admin/client/client.lua; handler@fsn_admin/client/client.lua
- fsn_admin:requestXYZ: register@fsn_admin/client.lua; handler@fsn_admin/client.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; register@fsn_admin/client/client.lua; handler@fsn_admin/client/client.lua; trigger@fsn_admin/server/server.lua; trigger@fsn_admin/server/server.lua
- fsn_admin:sendXYZ: trigger@fsn_admin/client.lua; handler@fsn_admin/server.lua; trigger@fsn_admin/client/client.lua
- fsn_admin:spawnCar: register@fsn_admin/server.lua; handler@fsn_admin/server.lua
- fsn_admin:spawnVehicle: register@fsn_admin/client/client.lua; handler@fsn_admin/client/client.lua
- fsn_apartments:characterCreation: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua
- fsn_apartments:createApartment: trigger@fsn_apartments/client.lua; handler@fsn_apartments/server.lua
- fsn_apartments:getApartment: trigger@fsn_spawnmanager/client.lua; handler@fsn_apartments/server.lua
- fsn_apartments:instance:debug: trigger@fsn_dev/server/server.lua; trigger@fsn_commands/server.lua; register@fsn_apartments/cl_instancing.lua; handler@fsn_apartments/cl_instancing.lua
- fsn_apartments:instance:join: handler@fsn_apartments/sv_instancing.lua; trigger@fsn_apartments/sv_instancing.lua; trigger@fsn_apartments/sv_instancing.lua; register@fsn_apartments/cl_instancing.lua; handler@fsn_apartments/cl_instancing.lua
- fsn_apartments:instance:leave: trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; handler@fsn_apartments/sv_instancing.lua; trigger@fsn_apartments/sv_instancing.lua; register@fsn_apartments/cl_instancing.lua; handler@fsn_apartments/cl_instancing.lua
- fsn_apartments:instance:new: trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; handler@fsn_apartments/sv_instancing.lua
- fsn_apartments:instance:update: trigger@fsn_apartments/sv_instancing.lua; trigger@fsn_apartments/sv_instancing.lua; register@fsn_apartments/cl_instancing.lua; handler@fsn_apartments/cl_instancing.lua
- fsn_apartments:inv:update: trigger@fsn_inventory/cl_inventory.lua; register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua
- fsn_apartments:outfit:add: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua
- fsn_apartments:outfit:list: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua
- fsn_apartments:outfit:remove: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua
- fsn_apartments:outfit:use: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua
- fsn_apartments:saveApartment: trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; handler@fsn_apartments/server.lua
- fsn_apartments:sendApartment: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua; trigger@fsn_apartments/server.lua
- fsn_apartments:stash:add: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua
- fsn_apartments:stash:take: register@fsn_apartments/client.lua; handler@fsn_apartments/client.lua; trigger@fsn_apartments/server.lua
- fsn_bank:change:bankAdd: trigger@fsn_bank/server.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/garbage/client.lua
- fsn_bank:change:bankMinus: trigger@fsn_bank/server.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_police/server.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/garbage/client.lua
- fsn_bank:change:bankandwallet: register@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_ems/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua
- fsn_bank:change:walletAdd: trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_properties/cl_properties.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_boatshop/cl_boatshop.lua; trigger@fsn_store/client.lua; register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_criminalmisc/pawnstore/cl_pawnstore.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_commands/server.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_apartments/client.lua
- fsn_bank:change:walletMinus: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/_item_misc/cl_breather.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_properties/cl_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_vehiclecontrol/carwash/client.lua; trigger@fsn_vehiclecontrol/fuel/client.lua; trigger@fsn_needs/vending.lua; trigger@fsn_needs/vending.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/cl_menu.lua; trigger@fsn_bikerental/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store_guns/client.lua; register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; trigger@fsn_main/initial/client.lua; trigger@fsn_clothing/config.lua; trigger@fsn_crafting/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_carstore/cl_menu.lua; trigger@fsn_carstore/cl_carstore.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_apartments/client.lua
- fsn_bank:database:update: handler@fsn_bank/server.lua
- fsn_bank:request:both: register@fsn_bank/client.lua; trigger@fsn_bank/client.lua; handler@fsn_main/money/client.lua
- fsn_bank:transfer: trigger@fsn_bank/client.lua; handler@fsn_bank/server.lua
- fsn_bank:update:both: register@fsn_bank/client.lua; handler@fsn_bank/client.lua; trigger@fsn_main/money/client.lua
- fsn_bankrobbery:LostMC:spawn: register@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua
- fsn_bankrobbery:closeDoor: register@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/server.lua
- fsn_bankrobbery:desks:doorUnlock: handler@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_criminalmisc/lockpicking/client.lua
- fsn_bankrobbery:desks:endHack: trigger@fsn_bankrobbery/cl_frontdesks.lua; trigger@fsn_bankrobbery/cl_frontdesks.lua; handler@fsn_bankrobbery/sv_frontdesks.lua
- fsn_bankrobbery:desks:receive: register@fsn_bankrobbery/cl_frontdesks.lua; handler@fsn_bankrobbery/cl_frontdesks.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; register@fsn_criminalmisc/lockpicking/client.lua; handler@fsn_criminalmisc/lockpicking/client.lua
- fsn_bankrobbery:desks:request: trigger@fsn_bankrobbery/cl_frontdesks.lua; handler@fsn_bankrobbery/sv_frontdesks.lua
- fsn_bankrobbery:desks:startHack: trigger@fsn_bankrobbery/cl_frontdesks.lua; handler@fsn_bankrobbery/sv_frontdesks.lua
- fsn_bankrobbery:init: register@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/server.lua; trigger@fsn_bankrobbery/server.lua
- fsn_bankrobbery:openDoor: register@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/server.lua
- fsn_bankrobbery:payout: trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/server.lua
- fsn_bankrobbery:start: trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/server.lua
- fsn_bankrobbery:timer: register@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/server.lua; trigger@fsn_bankrobbery/server.lua; trigger@fsn_bankrobbery/server.lua
- fsn_bankrobbery:vault:close: trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/server.lua
- fsn_bankrobbery:vault:open: trigger@fsn_bankrobbery/client.lua; handler@fsn_bankrobbery/server.lua
- fsn_boatshop:floor:ChangeBoat: trigger@fsn_boatshop/cl_menu.lua; handler@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:Request: trigger@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:Update: register@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:Updateboat: register@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:color:One: register@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:color:Two: register@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:commission: register@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/cl_boatshop.lua; handler@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:testdrive:end: trigger@fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:testdrive:start: trigger@fsn_boatshop/sv_boatshop.lua
- fsn_cargarage:buyVehicle: trigger@fsn_boatshop/cl_boatshop.lua; handler@fsn_main/initial/server.lua; trigger@fsn_carstore/cl_carstore.lua
- fsn_cargarage:checkStatus: register@fsn_cargarage/client.lua; handler@fsn_cargarage/client.lua
- fsn_cargarage:impound: handler@fsn_cargarage/server.lua; trigger@fsn_cargarage/server.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua
- fsn_cargarage:makeMine: trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_dev/client/client.lua; trigger@fsn_dev/client/client.lua; register@fsn_cargarage/client.lua; handler@fsn_cargarage/client.lua; trigger@fsn_boatshop/cl_boatshop.lua; trigger@fsn_boatshop/cl_boatshop.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/client/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_carstore/cl_carstore.lua; trigger@fsn_carstore/cl_carstore.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_jobs/delivery/client.lua; trigger@fsn_jobs/garbage/client.lua; trigger@fsn_doj/judges/client.lua
- fsn_cargarage:receiveVehicles: register@fsn_cargarage/client.lua; handler@fsn_cargarage/client.lua; trigger@fsn_cargarage/server.lua; trigger@fsn_cargarage/server.lua; trigger@fsn_cargarage/server.lua
- fsn_cargarage:requestVehicles: trigger@fsn_cargarage/client.lua; handler@fsn_cargarage/server.lua
- fsn_cargarage:reset: trigger@fsn_cargarage/client.lua; handler@fsn_cargarage/server.lua
- fsn_cargarage:updateVehicle: trigger@fsn_customs/lscustoms.lua; handler@fsn_cargarage/server.lua; trigger@fsn_cargarage/server.lua; trigger@fsn_cargarage/server.lua; trigger@fsn_jobs/mechanic/mechmenu.lua
- fsn_cargarage:vehicle:toggleStatus: trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; handler@fsn_cargarage/server.lua
- fsn_cargarage:vehicleStatus: register@fsn_cargarage/client.lua; handler@fsn_cargarage/client.lua; trigger@fsn_cargarage/server.lua
- fsn_carstore:floor:ChangeCar: handler@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/cl_menu.lua
- fsn_carstore:floor:Request: handler@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/cl_carstore.lua
- fsn_carstore:floor:Update: trigger@fsn_carstore/sv_carstore.lua; register@fsn_carstore/cl_carstore.lua; handler@fsn_carstore/cl_carstore.lua
- fsn_carstore:floor:UpdateCar: trigger@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; register@fsn_carstore/cl_carstore.lua; handler@fsn_carstore/cl_carstore.lua
- fsn_carstore:floor:color:One: handler@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; register@fsn_carstore/cl_carstore.lua; handler@fsn_carstore/cl_carstore.lua; trigger@fsn_carstore/cl_carstore.lua
- fsn_carstore:floor:color:Two: handler@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; register@fsn_carstore/cl_carstore.lua; handler@fsn_carstore/cl_carstore.lua; trigger@fsn_carstore/cl_carstore.lua
- fsn_carstore:floor:commission: handler@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; register@fsn_carstore/cl_carstore.lua; handler@fsn_carstore/cl_carstore.lua; trigger@fsn_carstore/cl_carstore.lua
- fsn_carstore:testdrive:end: trigger@fsn_carstore/sv_carstore.lua
- fsn_carstore:testdrive:start: trigger@fsn_carstore/sv_carstore.lua
- fsn_characterdetails:recievetattoos: register@fsn_characterdetails/tattoos/client.lua; handler@fsn_characterdetails/tattoos/client.lua
- fsn_clothing:change: trigger@fsn_clothing/server.lua
- fsn_clothing:menu: register@fsn_clothing/client.lua; handler@fsn_clothing/client.lua; trigger@fsn_apartments/client.lua
- fsn_clothing:requestDefault: handler@fsn_clothing/server.lua
- fsn_clothing:save: handler@fsn_clothing/server.lua
- fsn_commands:airlift: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:clothing:glasses: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:clothing:hat: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:clothing:mask: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:dev:fix: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:dev:spawnCar: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:dev:weapon: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:dropweapon: register@fsn_commands/client.lua; handler@fsn_commands/client.lua
- fsn_commands:ems:adamage:inspect: trigger@fsn_ems/cl_advanceddamage.lua; handler@fsn_commands/server.lua
- fsn_commands:getHDC: register@fsn_menu/main_client.lua; handler@fsn_menu/main_client.lua; register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:hc:rob: trigger@fsn_commands/server.lua
- fsn_commands:hc:takephone: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:me: trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_vehiclecontrol/client.lua; trigger@fsn_vehiclecontrol/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_emotecontrol/client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:me:3d: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:boot: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:booted: trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua
- fsn_commands:police:car: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:cpic:trigger: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:extra: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:extras: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:fix: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:gsrMe: register@fsn_police/dispatch.lua; handler@fsn_police/dispatch.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:gsrResult: trigger@fsn_police/dispatch.lua; handler@fsn_commands/server.lua
- fsn_commands:police:impound: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:impound2: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:livery: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:lock: register@fsn_jewellerystore/client.lua; handler@fsn_jewellerystore/client.lua
- fsn_commands:police:pedcarry: trigger@fsn_dev/server/server.lua; register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:pedrevive: trigger@fsn_dev/server/server.lua; register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:rifle: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:shotgun: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:towMark: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:unboot: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:police:unbooted: trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua
- fsn_commands:police:updateBoot: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:printxyz: trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua
- fsn_commands:requestHDC: trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua
- fsn_commands:sendxyz: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:service:addPing: trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua
- fsn_commands:service:pingAccept: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:service:pingStart: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_commands:service:request: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:service:sendrequest: trigger@fsn_commands/client.lua; handler@fsn_commands/server.lua
- fsn_commands:vehdoor:close: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:vehdoor:open: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_commands:walk:set: register@fsn_commands/client.lua; handler@fsn_commands/client.lua
- fsn_commands:window: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_criminalmisc:drugs:effects:cocaine: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_criminalmisc/drugs/_effects/client.lua; handler@fsn_criminalmisc/drugs/_effects/client.lua
- fsn_criminalmisc:drugs:effects:meth: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_criminalmisc/drugs/_effects/client.lua; handler@fsn_criminalmisc/drugs/_effects/client.lua
- fsn_criminalmisc:drugs:effects:smokeCigarette: trigger@fsn_inventory/cl_uses.lua; register@fsn_criminalmisc/drugs/_effects/client.lua; handler@fsn_criminalmisc/drugs/_effects/client.lua
- fsn_criminalmisc:drugs:effects:weed: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_criminalmisc/drugs/_effects/client.lua; handler@fsn_criminalmisc/drugs/_effects/client.lua
- fsn_criminalmisc:drugs:streetselling:area: trigger@fsn_inventory/_old/items.lua
- fsn_criminalmisc:drugs:streetselling:radio: trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; handler@fsn_criminalmisc/drugs/_streetselling/server.lua
- fsn_criminalmisc:drugs:streetselling:request: trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; register@fsn_criminalmisc/drugs/_streetselling/server.lua; handler@fsn_criminalmisc/drugs/_streetselling/server.lua
- fsn_criminalmisc:drugs:streetselling:send: register@fsn_criminalmisc/drugs/_streetselling/client.lua; handler@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/server.lua; trigger@fsn_criminalmisc/drugs/_streetselling/server.lua
- fsn_criminalmisc:handcuffs:requestCuff: trigger@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:requestunCuff: trigger@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:startCuffed: register@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/client.lua; trigger@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:startCuffing: register@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/client.lua; trigger@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:startunCuffed: register@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/client.lua; trigger@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:startunCuffing: register@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/client.lua; trigger@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:toggleEscort: trigger@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:houserobbery:try: trigger@fsn_inventory/cl_uses.lua; register@fsn_criminalmisc/robbing/cl_houses.lua; handler@fsn_criminalmisc/robbing/cl_houses.lua
- fsn_criminalmisc:lockpicking: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_criminalmisc/lockpicking/client.lua; handler@fsn_criminalmisc/lockpicking/client.lua
- fsn_criminalmisc:racing:createRace: register@fsn_criminalmisc/streetracing/client.lua; handler@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_menu/main_client.lua
- fsn_criminalmisc:racing:joinRace: trigger@fsn_criminalmisc/streetracing/client.lua; handler@fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:racing:newRace: trigger@fsn_criminalmisc/streetracing/client.lua; handler@fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:racing:putmeinrace: register@fsn_criminalmisc/streetracing/client.lua; handler@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:racing:update: register@fsn_criminalmisc/streetracing/client.lua; handler@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:racing:win: trigger@fsn_criminalmisc/streetracing/client.lua; handler@fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:robbing:requesRob: trigger@fsn_criminalmisc/handcuffs/client.lua
- fsn_criminalmisc:robbing:startRobbing: trigger@fsn_ems/cl_carrydead.lua; trigger@fsn_criminalmisc/handcuffs/client.lua; register@fsn_criminalmisc/robbing/client.lua; handler@fsn_criminalmisc/robbing/client.lua
- fsn_criminalmisc:toggleDrag: register@fsn_criminalmisc/handcuffs/client.lua; handler@fsn_criminalmisc/handcuffs/client.lua; trigger@fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:weapons:add: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua
- fsn_criminalmisc:weapons:add:police: trigger@fsn_police/client.lua; register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua
- fsn_criminalmisc:weapons:add:tbl: trigger@fsn_properties/cl_properties.lua; register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_apartments/client.lua
- fsn_criminalmisc:weapons:add:unknown: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/client.lua
- fsn_criminalmisc:weapons:addDrop: trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/server.lua
- fsn_criminalmisc:weapons:destroy: trigger@fsn_properties/cl_properties.lua; register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_apartments/client.lua
- fsn_criminalmisc:weapons:drop: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/server.lua
- fsn_criminalmisc:weapons:equip: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_clothing/client.lua; trigger@fsn_clothing/client.lua
- fsn_criminalmisc:weapons:info: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/server.lua
- fsn_criminalmisc:weapons:pickup: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/server.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua
- fsn_criminalmisc:weapons:updateDropped: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua
- fsn_dev:debug: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_commands/server.lua
- fsn_dev:noClip:enabled: trigger@fsn_commands/server.lua
- fsn_developer:deleteVehicle: register@fsn_dev/client/client.lua; handler@fsn_dev/client/client.lua; trigger@fsn_dev/server/server.lua
- fsn_developer:enableDeveloperCommands: register@fsn_dev/server/server.lua; handler@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua
- fsn_developer:fixVehicle: register@fsn_dev/client/client.lua; handler@fsn_dev/client/client.lua; trigger@fsn_dev/server/server.lua
- fsn_developer:getKeys: register@fsn_dev/client/client.lua; handler@fsn_dev/client/client.lua; trigger@fsn_dev/server/server.lua
- fsn_developer:noClip:enabled: register@fsn_dev/client/cl_noclip.lua; handler@fsn_dev/client/cl_noclip.lua; trigger@fsn_dev/server/server.lua
- fsn_developer:printXYZ: trigger@fsn_dev/client/client.lua; handler@fsn_dev/server/server.lua
- fsn_developer:sendXYZ: register@fsn_dev/client/client.lua; handler@fsn_dev/client/client.lua; trigger@fsn_dev/server/server.lua
- fsn_developer:spawnVehicle: register@fsn_dev/client/client.lua; handler@fsn_dev/client/client.lua; trigger@fsn_dev/server/server.lua
- fsn_doj:court:remandMe: register@fsn_doj/judges/client.lua; handler@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/server.lua
- fsn_doj:judge:spawnCar: register@fsn_doj/judges/client.lua; handler@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/server.lua
- fsn_doj:judge:toggleLock: register@fsn_teleporters/client.lua; handler@fsn_teleporters/client.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_doj/judges/server.lua
- fsn_doormanager:doorLocked: register@fsn_doormanager/client.lua; handler@fsn_doormanager/client.lua; trigger@fsn_doormanager/server.lua
- fsn_doormanager:doorUnlocked: register@fsn_doormanager/client.lua; handler@fsn_doormanager/client.lua; trigger@fsn_doormanager/server.lua
- fsn_doormanager:lockDoor: trigger@fsn_doormanager/client.lua; handler@fsn_doormanager/server.lua
- fsn_doormanager:request: handler@fsn_doormanager/sv_doors.lua; trigger@fsn_doormanager/sv_doors.lua; trigger@fsn_doormanager/sv_doors.lua; register@fsn_doormanager/cl_doors.lua; handler@fsn_doormanager/cl_doors.lua; trigger@fsn_doormanager/cl_doors.lua; trigger@fsn_doormanager/cl_doors.lua
- fsn_doormanager:requestDoors: trigger@fsn_doormanager/client.lua; trigger@fsn_doormanager/client.lua; handler@fsn_doormanager/server.lua
- fsn_doormanager:sendDoors: register@fsn_doormanager/client.lua; handler@fsn_doormanager/client.lua; trigger@fsn_doormanager/server.lua
- fsn_doormanager:toggle: handler@fsn_doormanager/sv_doors.lua; trigger@fsn_doormanager/cl_doors.lua
- fsn_doormanager:unlockDoor: trigger@fsn_doormanager/client.lua; handler@fsn_doormanager/server.lua
- fsn_emotecontrol:dice:roll: register@fsn_emotecontrol/client.lua; handler@fsn_emotecontrol/client.lua; trigger@fsn_commands/server.lua
- fsn_emotecontrol:phone:call1: register@fsn_emotecontrol/client.lua; handler@fsn_emotecontrol/client.lua; trigger@fsn_commands/server.lua
- fsn_emotecontrol:play: trigger@fsn_stripclub/client.lua; register@fsn_emotecontrol/client.lua; handler@fsn_emotecontrol/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_emotecontrol:police:tablet: register@fsn_emotecontrol/client.lua; handler@fsn_emotecontrol/client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_commands/server.lua
- fsn_emotecontrol:police:ticket: register@fsn_emotecontrol/client.lua; handler@fsn_emotecontrol/client.lua; trigger@fsn_commands/server.lua
- fsn_emotecontrol:sit: trigger@fsn_commands/server.lua
- fsn_ems:911: register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_commands/server.lua
- fsn_ems:911r: register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_commands/server.lua
- fsn_ems:CAD:10-43: trigger@fsn_ems/client.lua
- fsn_ems:ad:stopBleeding: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua
- fsn_ems:adamage:request: register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_ems:bed:health: trigger@fsn_ems/beds/client.lua; register@fsn_ems/beds/server.lua; handler@fsn_ems/beds/server.lua
- fsn_ems:bed:leave: register@fsn_ems/beds/server.lua; handler@fsn_ems/beds/server.lua
- fsn_ems:bed:occupy: trigger@fsn_ems/beds/client.lua; trigger@fsn_ems/beds/client.lua; trigger@fsn_ems/beds/client.lua; register@fsn_ems/beds/server.lua; handler@fsn_ems/beds/server.lua
- fsn_ems:bed:restraintoggle: trigger@fsn_ems/beds/client.lua; trigger@fsn_ems/beds/client.lua; register@fsn_ems/beds/server.lua; handler@fsn_ems/beds/server.lua
- fsn_ems:bed:update: register@fsn_ems/beds/client.lua; handler@fsn_ems/beds/client.lua; trigger@fsn_ems/beds/server.lua; trigger@fsn_ems/beds/server.lua; trigger@fsn_ems/beds/server.lua; trigger@fsn_ems/beds/server.lua
- fsn_ems:carried:end: trigger@fsn_ems/sv_carrydead.lua; register@fsn_ems/cl_carrydead.lua; handler@fsn_ems/cl_carrydead.lua
- fsn_ems:carried:start: trigger@fsn_ems/sv_carrydead.lua; register@fsn_ems/cl_carrydead.lua; handler@fsn_ems/cl_carrydead.lua
- fsn_ems:carry:end: trigger@fsn_vehiclecontrol/trunk/client.lua; handler@fsn_ems/sv_carrydead.lua; trigger@fsn_ems/sv_carrydead.lua; register@fsn_ems/cl_carrydead.lua; handler@fsn_ems/cl_carrydead.lua; trigger@fsn_ems/cl_carrydead.lua
- fsn_ems:carry:start: handler@fsn_ems/sv_carrydead.lua; trigger@fsn_ems/sv_carrydead.lua; register@fsn_ems/cl_carrydead.lua; handler@fsn_ems/cl_carrydead.lua; trigger@fsn_ems/cl_carrydead.lua
- fsn_ems:killMe: trigger@fsn_dev/server/server.lua; trigger@fsn_needs/client.lua; trigger@fsn_needs/client.lua; register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_ems:offDuty: trigger@fsn_ems/client.lua; handler@fsn_ems/server.lua
- fsn_ems:onDuty: trigger@fsn_ems/client.lua; handler@fsn_ems/server.lua
- fsn_ems:requestUpdate: trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; handler@fsn_ems/server.lua
- fsn_ems:reviveMe: register@fsn_needs/client.lua; handler@fsn_needs/client.lua; register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/beds/client.lua; trigger@fsn_ems/beds/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_ems:reviveMe:force: trigger@fsn_dev/server/server.lua; register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_ems:set:WalkType: register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua; trigger@fsn_commands/server.lua
- fsn_ems:update: register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_ems/server.lua; trigger@fsn_ems/server.lua; trigger@fsn_ems/server.lua; trigger@fsn_ems/server.lua; trigger@fsn_ems/server.lua; trigger@fsn_ems/server.lua; handler@fsn_commands/server.lua
- fsn_ems:updateLevel: register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_commands/server.lua
- fsn_evidence:collect: handler@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/cl_evidence.lua
- fsn_evidence:destroy: handler@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/cl_evidence.lua
- fsn_evidence:display: trigger@fsn_evidence/sv_evidence.lua; register@fsn_evidence/cl_evidence.lua; handler@fsn_evidence/cl_evidence.lua
- fsn_evidence:drop:blood: trigger@fsn_ems/cl_advanceddamage.lua; handler@fsn_evidence/sv_evidence.lua
- fsn_evidence:drop:casing: handler@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/casings/cl_casings.lua
- fsn_evidence:ped:addState: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_crafting/client.lua; register@fsn_evidence/ped/cl_ped.lua; handler@fsn_evidence/ped/cl_ped.lua; trigger@fsn_evidence/ped/cl_ped.lua
- fsn_evidence:ped:update: handler@fsn_evidence/ped/sv_ped.lua; trigger@fsn_evidence/ped/sv_ped.lua; register@fsn_evidence/ped/cl_ped.lua; handler@fsn_evidence/ped/cl_ped.lua; trigger@fsn_evidence/ped/cl_ped.lua
- fsn_evidence:ped:updateDamage: trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua; register@fsn_evidence/ped/cl_ped.lua; handler@fsn_evidence/ped/cl_ped.lua
- fsn_evidence:receive: trigger@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/sv_evidence.lua; register@fsn_evidence/cl_evidence.lua; handler@fsn_evidence/cl_evidence.lua
- fsn_evidence:request: handler@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/cl_evidence.lua
- fsn_evidence:weaponInfo: trigger@fsn_inventory/cl_inventory.lua; register@fsn_evidence/casings/cl_casings.lua; handler@fsn_evidence/casings/cl_casings.lua
- fsn_fuel:set: register@fsn_vehiclecontrol/fuel/client.lua; handler@fsn_vehiclecontrol/fuel/client.lua; trigger@fsn_commands/client.lua
- fsn_fuel:update: trigger@fsn_dev/client/client.lua; register@fsn_vehiclecontrol/fuel/client.lua; handler@fsn_vehiclecontrol/fuel/client.lua; trigger@fsn_vehiclecontrol/fuel/client.lua; handler@fsn_vehiclecontrol/fuel/server.lua; trigger@fsn_vehiclecontrol/fuel/server.lua; trigger@fsn_commands/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/delivery/client.lua; trigger@fsn_jobs/garbage/client.lua
- fsn_gangs:garage:enter: trigger@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/sv_gangs.lua
- fsn_gangs:hideout:enter: register@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/cl_gangs.lua; trigger@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/sv_gangs.lua; trigger@fsn_gangs/sv_gangs.lua; trigger@fsn_gangs/sv_gangs.lua
- fsn_gangs:hideout:leave: register@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/cl_gangs.lua; trigger@fsn_gangs/cl_gangs.lua; trigger@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/sv_gangs.lua; trigger@fsn_gangs/sv_gangs.lua; trigger@fsn_gangs/sv_gangs.lua
- fsn_gangs:inventory:request: handler@fsn_gangs/sv_gangs.lua
- fsn_gangs:recieve: register@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/cl_gangs.lua; trigger@fsn_gangs/sv_gangs.lua
- fsn_gangs:request: trigger@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/sv_gangs.lua
- fsn_gangs:tryTakeOver: trigger@fsn_gangs/cl_gangs.lua; trigger@fsn_gangs/cl_gangs.lua; handler@fsn_gangs/sv_gangs.lua
- fsn_garages:vehicle:update: trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; handler@fsn_cargarage/server.lua
- fsn_hungerandthirst:pause: trigger@fsn_jail/client.lua; register@fsn_needs/client.lua; handler@fsn_needs/client.lua
- fsn_hungerandthirst:unpause: trigger@fsn_jail/client.lua; register@fsn_needs/client.lua; handler@fsn_needs/client.lua
- fsn_inventory:apt:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_apartments/client.lua
- fsn_inventory:buyItem: register@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; handler@fsn_main/initial/client.lua
- fsn_inventory:database:update: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; handler@fsn_main/initial/server.lua
- fsn_inventory:drops:collect: register@fsn_inventory_dropping/sv_dropping.lua; handler@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_inventory_dropping/cl_dropping.lua
- fsn_inventory:drops:drop: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; register@fsn_inventory_dropping/sv_dropping.lua; handler@fsn_inventory_dropping/sv_dropping.lua
- fsn_inventory:drops:request: register@fsn_inventory_dropping/sv_dropping.lua; handler@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_inventory_dropping/cl_dropping.lua
- fsn_inventory:drops:send: trigger@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_inventory_dropping/sv_dropping.lua; register@fsn_inventory_dropping/cl_dropping.lua; handler@fsn_inventory_dropping/cl_dropping.lua
- fsn_inventory:empty: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua
- fsn_inventory:floor:update: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_inventory/_old/server.lua
- fsn_inventory:gasDoorunlock: trigger@fsn_jewellerystore/client.lua; handler@fsn_jewellerystore/server.lua
- fsn_inventory:gui:display: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/sv_inventory.lua
- fsn_inventory:init: register@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua
- fsn_inventory:initChar: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; handler@fsn_needs/client.lua; trigger@fsn_spawnmanager/client.lua
- fsn_inventory:item:add: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/cl_uses.lua; register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/_item_misc/_drug_selling.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_bankrobbery/trucks.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/server.lua; trigger@fsn_jewellerystore/client.lua; trigger@fsn_jewellerystore/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_store/client.lua; trigger@fsn_main/initial/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/server.lua; trigger@fsn_crafting/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/scrap/client.lua
- fsn_inventory:item:drop: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua
- fsn_inventory:item:dropped: trigger@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/server.lua
- fsn_inventory:item:give: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua
- fsn_inventory:item:take: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/_item_misc/_drug_selling.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_needs/hud.lua; trigger@fsn_criminalmisc/pawnstore/cl_pawnstore.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_crafting/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/hunting/client.lua
- fsn_inventory:item:use: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua
- fsn_inventory:itemhasdropped: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/server.lua
- fsn_inventory:itempickup: trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/server.lua
- fsn_inventory:items:add: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/_item_misc/cl_breather.lua; trigger@fsn_police/client.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua; trigger@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_licenses/sv_desk.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_jobs/scrap/client.lua
- fsn_inventory:items:addPreset: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua
- fsn_inventory:items:emptyinv: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_ems/client.lua
- fsn_inventory:locker:empty: handler@fsn_inventory/pd_locker/sv_locker.lua; trigger@fsn_inventory/pd_locker/cl_locker.lua
- fsn_inventory:locker:request: handler@fsn_inventory/pd_locker/sv_locker.lua; trigger@fsn_inventory/pd_locker/cl_locker.lua
- fsn_inventory:locker:save: trigger@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/pd_locker/sv_locker.lua
- fsn_inventory:me:update: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/sv_inventory.lua
- fsn_inventory:pd_locker:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/pd_locker/sv_locker.lua
- fsn_inventory:ply:done: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/sv_inventory.lua
- fsn_inventory:ply:finished: trigger@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/sv_inventory.lua
- fsn_inventory:ply:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/sv_inventory.lua
- fsn_inventory:ply:request: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/sv_inventory.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_inventory:ply:update: trigger@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/sv_inventory.lua
- fsn_inventory:police_armory:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_police/armory/sv_armory.lua
- fsn_inventory:prebuy: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua
- fsn_inventory:prop:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_properties/cl_properties.lua
- fsn_inventory:rebreather:use: trigger@fsn_inventory/cl_uses.lua; register@fsn_inventory/_item_misc/cl_breather.lua; handler@fsn_inventory/_item_misc/cl_breather.lua
- fsn_inventory:recieveItems: trigger@fsn_inventory/sv_presets.lua; register@fsn_inventory/cl_presets.lua; handler@fsn_inventory/cl_presets.lua
- fsn_inventory:removedropped: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/server.lua
- fsn_inventory:sendItems: handler@fsn_inventory/sv_presets.lua; trigger@fsn_inventory/sv_presets.lua; trigger@fsn_inventory/cl_presets.lua
- fsn_inventory:sendItemsToArmory: register@fsn_inventory/sv_presets.lua; handler@fsn_inventory/sv_presets.lua; trigger@fsn_police/armory/sv_armory.lua
- fsn_inventory:sendItemsToStore: register@fsn_inventory/sv_presets.lua; handler@fsn_inventory/sv_presets.lua; trigger@fsn_store/server.lua
- fsn_inventory:store:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_store/server.lua
- fsn_inventory:store_gun:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_store_guns/server.lua
- fsn_inventory:sys:request: handler@fsn_inventory/sv_inventory.lua; trigger@fsn_criminalmisc/robbing/client.lua
- fsn_inventory:sys:send: trigger@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/sv_inventory.lua
- fsn_inventory:update: register@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua
- fsn_inventory:use:drink: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_needs/client.lua; handler@fsn_needs/client.lua; trigger@fsn_needs/vending.lua; trigger@fsn_needs/vending.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua
- fsn_inventory:use:food: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_needs/client.lua; handler@fsn_needs/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua
- fsn_inventory:useAmmo: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua
- fsn_inventory:useArmor: trigger@fsn_inventory/cl_uses.lua; register@fsn_needs/hud.lua; handler@fsn_needs/hud.lua
- fsn_inventory:veh:: trigger@fsn_inventory/sv_vehicles.lua; trigger@fsn_inventory/sv_vehicles.lua
- fsn_inventory:veh:finished: trigger@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/sv_vehicles.lua
- fsn_inventory:veh:glovebox: register@fsn_inventory/cl_vehicles.lua; handler@fsn_inventory/cl_vehicles.lua; trigger@fsn_commands/server.lua
- fsn_inventory:veh:glovebox:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua
- fsn_inventory:veh:request: trigger@fsn_inventory/cl_vehicles.lua; handler@fsn_inventory/sv_vehicles.lua; trigger@fsn_vehiclecontrol/trunk/client.lua
- fsn_inventory:veh:trunk:recieve: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua
- fsn_inventory:veh:update: trigger@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/sv_vehicles.lua
- fsn_jail:init: register@fsn_jail/client.lua; handler@fsn_jail/client.lua; trigger@fsn_spawnmanager/client.lua
- fsn_jail:releaseme: register@fsn_jail/client.lua; handler@fsn_jail/client.lua; trigger@fsn_jail/client.lua
- fsn_jail:sendme: register@fsn_jail/client.lua; handler@fsn_jail/client.lua; trigger@fsn_jail/client.lua
- fsn_jail:sendsuspect: handler@fsn_jail/server.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_commands/server.lua; trigger@fsn_doj/judges/server.lua
- fsn_jail:spawn: trigger@fsn_jail/client.lua; handler@fsn_jail/server.lua
- fsn_jail:spawn:recieve: register@fsn_jail/client.lua; handler@fsn_jail/client.lua; trigger@fsn_jail/server.lua; trigger@fsn_jail/server.lua
- fsn_jail:update:database: trigger@fsn_jail/client.lua; trigger@fsn_jail/client.lua; trigger@fsn_jail/client.lua; handler@fsn_jail/server.lua
- fsn_jewellerystore:case:rob: trigger@fsn_jewellerystore/client.lua; handler@fsn_jewellerystore/server.lua
- fsn_jewellerystore:case:startrob: register@fsn_jewellerystore/client.lua; handler@fsn_jewellerystore/client.lua; trigger@fsn_jewellerystore/server.lua
- fsn_jewellerystore:cases:request: handler@fsn_jewellerystore/server.lua
- fsn_jewellerystore:cases:update: register@fsn_jewellerystore/client.lua; handler@fsn_jewellerystore/client.lua; trigger@fsn_jewellerystore/server.lua; trigger@fsn_jewellerystore/server.lua; trigger@fsn_jewellerystore/server.lua
- fsn_jewellerystore:doors:Lock: handler@fsn_jewellerystore/server.lua
- fsn_jewellerystore:doors:State: register@fsn_jewellerystore/client.lua; handler@fsn_jewellerystore/client.lua; trigger@fsn_jewellerystore/server.lua; trigger@fsn_jewellerystore/server.lua
- fsn_jewellerystore:doors:toggle: trigger@fsn_jewellerystore/client.lua
- fsn_jewellerystore:gasDoor:toggle: register@fsn_jewellerystore/client.lua; handler@fsn_jewellerystore/client.lua; trigger@fsn_jewellerystore/server.lua; trigger@fsn_jewellerystore/server.lua
- fsn_jobs:ems:request: register@fsn_ems/client.lua; handler@fsn_ems/client.lua; trigger@fsn_commands/server.lua
- fsn_jobs:mechanic:toggle: trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; handler@fsn_jobs/mechanic/server.lua
- fsn_jobs:mechanic:toggleduty: register@fsn_jobs/mechanic/client.lua; handler@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/server.lua; trigger@fsn_jobs/mechanic/server.lua
- fsn_jobs:news:role:Set: trigger@fsn_commands/server.lua; register@fsn_jobs/news/client.lua; handler@fsn_jobs/news/client.lua
- fsn_jobs:news:role:Toggle: trigger@fsn_commands/server.lua
- fsn_jobs:paycheck: register@fsn_jobs/client.lua; handler@fsn_jobs/client.lua; trigger@fsn_jobs/server.lua
- fsn_jobs:quit: trigger@fsn_commands/server.lua; register@fsn_jobs/client.lua; handler@fsn_jobs/client.lua
- fsn_jobs:taxi:accepted: register@fsn_jobs/taxi/client.lua; handler@fsn_jobs/taxi/client.lua
- fsn_jobs:taxi:request: trigger@fsn_commands/server.lua; register@fsn_jobs/taxi/client.lua; handler@fsn_jobs/taxi/client.lua
- fsn_jobs:tow:mark: trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; handler@fsn_jobs/tow/server.lua
- fsn_jobs:tow:marked: register@fsn_jobs/tow/client.lua; handler@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/server.lua
- fsn_jobs:tow:request: trigger@fsn_commands/server.lua; register@fsn_jobs/tow/client.lua; handler@fsn_jobs/tow/client.lua
- fsn_jobs:whitelist:access:add: handler@fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:add: trigger@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:clock:in: register@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/client.lua; trigger@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:clock:out: register@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/client.lua; trigger@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:remove: trigger@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:request: trigger@fsn_jobs/whitelists/client.lua; trigger@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:update: register@fsn_jobs/whitelists/client.lua; handler@fsn_jobs/whitelists/client.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua
- fsn_licenses:chat: trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; handler@fsn_licenses/server.lua
- fsn_licenses:check: trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; handler@fsn_licenses/server.lua
- fsn_licenses:display: register@fsn_licenses/client.lua; handler@fsn_licenses/client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_licenses:giveID: trigger@fsn_inventory/cl_inventory.lua; register@fsn_licenses/cl_desk.lua; handler@fsn_licenses/cl_desk.lua
- fsn_licenses:id:display: handler@fsn_inventory/sv_inventory.lua; trigger@fsn_inventory/cl_uses.lua
- fsn_licenses:id:request: handler@fsn_licenses/sv_desk.lua; trigger@fsn_licenses/cl_desk.lua; trigger@fsn_licenses/cl_desk.lua
- fsn_licenses:infraction: register@fsn_licenses/client.lua; handler@fsn_licenses/client.lua; trigger@fsn_commands/server.lua
- fsn_licenses:police:give: trigger@fsn_store/client.lua; trigger@fsn_store_guns/client.lua; register@fsn_licenses/client.lua; handler@fsn_licenses/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_licenses:setInfractions: trigger@fsn_dev/server/server.lua
- fsn_licenses:setinfractions: register@fsn_licenses/client.lua; handler@fsn_licenses/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_doj/judges/server.lua
- fsn_licenses:showid: register@fsn_licenses/client.lua; handler@fsn_licenses/client.lua; trigger@fsn_menu/main_client.lua
- fsn_licenses:update: register@fsn_licenses/client.lua; handler@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; handler@fsn_licenses/server.lua; trigger@fsn_licenses/server.lua; trigger@fsn_licenses/server.lua
- fsn_lscustoms:check: handler@fsn_main/money/client.lua
- fsn_lscustoms:check2: handler@fsn_main/money/client.lua
- fsn_lscustoms:check3: handler@fsn_main/money/client.lua
- fsn_lscustoms:receive: trigger@fsn_main/money/client.lua
- fsn_lscustoms:receive2: trigger@fsn_main/money/client.lua
- fsn_lscustoms:receive3: trigger@fsn_main/money/client.lua
- fsn_main:blip:add: trigger@fsn_ems/client.lua; trigger@fsn_police/dispatch.lua; register@fsn_police/dispatch/client.lua; handler@fsn_police/dispatch/client.lua; trigger@fsn_jobs/tow/client.lua
- fsn_main:blip:clear: register@fsn_police/dispatch/client.lua; handler@fsn_police/dispatch/client.lua; trigger@fsn_commands/server.lua
- fsn_main:charMenu: trigger@fsn_dev/server/server.lua; trigger@fsn_main/playermanager/client.lua; register@fsn_main/initial/client.lua; handler@fsn_main/initial/client.lua; trigger@fsn_main/initial/client.lua; trigger@fsn_main/initial/client.lua; trigger@fsn_commands/server.lua
- fsn_main:character: handler@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; handler@fsn_bankrobbery/client.lua; handler@fsn_properties/cl_properties.lua; handler@fsn_ems/client.lua; handler@fsn_cargarage/client.lua; register@fsn_main/initial/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_spawnmanager/client.lua; handler@fsn_phones/cl_phone.lua; handler@fsn_licenses/client.lua; handler@fsn_licenses/cl_desk.lua; handler@fsn_commands/client.lua; handler@fsn_jobs/taxi/client.lua
- fsn_main:characterSaving: register@fsn_inventory/cl_inventory.lua; handler@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_main/playermanager/server.lua; register@fsn_main/initial/client.lua; handler@fsn_main/initial/client.lua; trigger@fsn_main/initial/server.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/server.lua
- fsn_main:createCharacter: trigger@fsn_main/initial/client.lua; handler@fsn_main/initial/server.lua
- fsn_main:debug_toggle: handler@fsn_main/debug/sh_debug.lua; trigger@fsn_main/debug/sh_debug.lua; handler@fsn_main/debug/sh_scheduler.lua
- fsn_main:displayBankandMoney: trigger@fsn_bank/client.lua; register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_commands/server.lua
- fsn_main:getCharacter: trigger@fsn_main/initial/client.lua; handler@fsn_main/initial/server.lua
- fsn_main:gui:bank:addMoney: trigger@fsn_main/money/server.lua
- fsn_main:gui:bank:change: trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; register@fsn_main/hud/client.lua; handler@fsn_main/hud/client.lua
- fsn_main:gui:bank:changeAmount: trigger@fsn_main/money/server.lua
- fsn_main:gui:bank:minusMoney: trigger@fsn_main/money/server.lua
- fsn_main:gui:both:display: trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; register@fsn_main/hud/client.lua; handler@fsn_main/hud/client.lua
- fsn_main:gui:minusMoney: trigger@fsn_main/money/server.lua
- fsn_main:gui:money:addMoney: trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua
- fsn_main:gui:money:change: trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; register@fsn_main/hud/client.lua; handler@fsn_main/hud/client.lua
- fsn_main:gui:money:changeAmount: trigger@fsn_main/money/server.lua
- fsn_main:initiateCharacter: register@fsn_main/initial/client.lua; handler@fsn_main/initial/client.lua; trigger@fsn_main/initial/server.lua
- fsn_main:logging:addLog: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_newchat/sv_chat.lua; trigger@fsn_store/server.lua; trigger@fsn_store_guns/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; handler@fsn_main/misc/logging.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua; trigger@fsn_errorcontrol/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_main:money:bank:Add: handler@fsn_bankrobbery/server.lua; trigger@fsn_main/money/client.lua; handler@fsn_main/money/server.lua
- fsn_main:money:bank:Minus: handler@fsn_bankrobbery/server.lua; trigger@fsn_main/money/client.lua; handler@fsn_main/money/server.lua
- fsn_main:money:bank:Set: trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; handler@fsn_main/money/server.lua
- fsn_main:money:initChar: register@fsn_main/money/server.lua; handler@fsn_main/money/server.lua; trigger@fsn_main/initial/server.lua
- fsn_main:money:update: register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_main/money/server.lua
- fsn_main:money:updateSilent: register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua
- fsn_main:money:wallet:Add: trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; handler@fsn_main/money/server.lua
- fsn_main:money:wallet:GiveCash: handler@fsn_main/money/server.lua; trigger@fsn_commands/server.lua
- fsn_main:money:wallet:Minus: trigger@fsn_main/money/client.lua; handler@fsn_main/money/server.lua
- fsn_main:money:wallet:Set: trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; handler@fsn_main/money/server.lua; handler@fsn_commands/server.lua
- fsn_main:requestCharacters: trigger@fsn_main/initial/client.lua; handler@fsn_main/initial/server.lua
- fsn_main:saveCharacter: trigger@fsn_characterdetails/tattoos/client.lua; trigger@fsn_main/initial/client.lua; handler@fsn_main/initial/server.lua
- fsn_main:sendCharacters: register@fsn_main/initial/client.lua; handler@fsn_main/initial/client.lua; trigger@fsn_main/initial/server.lua; trigger@fsn_main/initial/server.lua
- fsn_main:update:myCharacter: handler@fsn_main/initial/server.lua
- fsn_main:updateCharNumber: handler@fsn_main/initial/server.lua; trigger@fsn_phones/sv_phone.lua
- fsn_main:updateCharacters: handler@fsn_jail/server.lua; handler@fsn_main/sv_utils.lua; handler@fsn_main/initial/server.lua; trigger@fsn_main/initial/server.lua; trigger@fsn_main/initial/server.lua; trigger@fsn_main/initial/server.lua; handler@fsn_commands/server.lua; register@fsn_playerlist/client.lua; register@fsn_playerlist/client.lua; handler@fsn_playerlist/client.lua; handler@fsn_playerlist/client.lua
- fsn_main:updateMoneyStore: handler@fsn_main/sv_utils.lua; trigger@fsn_main/money/server.lua
- fsn_main:validatePlayer: handler@fsn_main/playermanager/server.lua; handler@fsn_main/initial/server.lua
- fsn_main:version: trigger@fsn_main/misc/version.lua
- fsn_menu:requestInventory: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua
- fsn_needs:stress:add: trigger@fsn_bankrobbery/server.lua; trigger@fsn_bankrobbery/cl_frontdesks.lua; trigger@fsn_bankrobbery/cl_frontdesks.lua; register@fsn_needs/client.lua; handler@fsn_needs/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua
- fsn_needs:stress:remove: trigger@fsn_activities/yoga/client.lua; register@fsn_needs/client.lua; handler@fsn_needs/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_criminalmisc/drugs/_effects/client.lua; trigger@fsn_criminalmisc/drugs/_effects/client.lua
- fsn_notify:displayNotification: trigger@fsn_stripclub/client.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/client.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_inventory/_old/server.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/_item_misc/_drug_selling.lua; trigger@fsn_inventory/_old/_item_misc/_drug_selling.lua; trigger@fsn_inventory/_old/_item_misc/_drug_selling.lua; trigger@fsn_inventory/_old/_item_misc/_drug_selling.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/burger_store.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_bank/server.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_customs/lscustoms.lua; trigger@fsn_dev/client/client.lua; trigger@fsn_dev/client/client.lua; trigger@fsn_dev/client/client.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_jail/client.lua; trigger@fsn_jail/client.lua; trigger@fsn_jail/client.lua; trigger@fsn_bankrobbery/trucks.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/server.lua; trigger@fsn_bankrobbery/server.lua; trigger@fsn_jewellerystore/server.lua; trigger@fsn_jewellerystore/server.lua; trigger@fsn_weaponcontrol/client.lua; trigger@fsn_vehiclecontrol/client.lua; trigger@fsn_vehiclecontrol/client.lua; trigger@fsn_vehiclecontrol/client.lua; trigger@fsn_vehiclecontrol/client.lua; trigger@fsn_vehiclecontrol/carwash/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/fuel/client.lua; trigger@fsn_vehiclecontrol/fuel/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_needs/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/beds/client.lua; trigger@fsn_ems/beds/client.lua; trigger@fsn_ems/beds/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_cargarage/server.lua; trigger@fsn_boatshop/cl_menu.lua; trigger@fsn_bikerental/client.lua; trigger@fsn_bikerental/client.lua; trigger@fsn_bikerental/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/server.lua; trigger@fsn_store/server.lua; trigger@fsn_store/server.lua; trigger@fsn_store/server.lua; trigger@fsn_store/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/server.lua; trigger@fsn_admin/client/client.lua; trigger@fsn_admin/client/client.lua; trigger@fsn_teleporters/client.lua; trigger@fsn_store_guns/client.lua; trigger@fsn_store_guns/client.lua; trigger@fsn_store_guns/client.lua; trigger@fsn_store_guns/server.lua; trigger@fsn_store_guns/server.lua; trigger@fsn_store_guns/server.lua; trigger@fsn_store_guns/server.lua; trigger@fsn_store_guns/server.lua; register@fsn_notify/server.lua; handler@fsn_notify/server.lua; register@fsn_notify/cl_notify.lua; handler@fsn_notify/cl_notify.lua; trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; trigger@fsn_main/money/client.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/initial/client.lua; trigger@fsn_main/initial/client.lua; trigger@fsn_shootingrange/client.lua; trigger@fsn_shootingrange/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_police/dispatch/client.lua; trigger@fsn_police/dispatch/client.lua; trigger@fsn_police/dispatch/client.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_police/armory/sv_armory.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/K9/client.lua; trigger@fsn_police/K9/client.lua; trigger@fsn_criminalmisc/handcuffs/client.lua; trigger@fsn_criminalmisc/handcuffs/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/server.lua; trigger@fsn_criminalmisc/drugs/_streetselling/server.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua; trigger@fsn_criminalmisc/weaponinfo/server.lua; trigger@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/client.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_crafting/client.lua; trigger@fsn_crafting/client.lua; trigger@fsn_crafting/client.lua; trigger@fsn_crafting/client.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_inventory_dropping/cl_dropping.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/darkweb/cl_order.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_licenses/client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_menu/main_client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_carstore/cl_menu.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/client.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/hunting/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/client.lua; trigger@fsn_jobs/mechanic/server.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/mechanic/mechmenu.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/whitelists/server.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/taxi/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/trucker/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/news/client.lua; trigger@fsn_jobs/delivery/client.lua; trigger@fsn_jobs/delivery/client.lua; trigger@fsn_jobs/delivery/client.lua; trigger@fsn_jobs/garbage/client.lua; trigger@fsn_jobs/garbage/client.lua; trigger@fsn_jobs/garbage/client.lua; trigger@fsn_jobs/garbage/client.lua; trigger@fsn_jobs/garbage/client.lua; trigger@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/client.lua; trigger@fsn_doj/judges/server.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua; trigger@fsn_apartments/client.lua
- fsn_odometer:addMileage: trigger@fsn_vehiclecontrol/odometer/client.lua; trigger@fsn_vehiclecontrol/odometer/client.lua; handler@fsn_vehiclecontrol/odometer/server.lua
- fsn_odometer:getMileage: handler@fsn_vehiclecontrol/odometer/server.lua
- fsn_odometer:resetMileage: handler@fsn_vehiclecontrol/odometer/server.lua
- fsn_odometer:setMileage: handler@fsn_vehiclecontrol/odometer/server.lua; trigger@fsn_vehiclecontrol/odometer/server.lua
- fsn_phone:displayNumber: trigger@fsn_commands/server.lua
- fsn_phone:recieveMessage: trigger@fsn_bankrobbery/trucks.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua
- fsn_phone:togglePhone: trigger@fsn_inventory/_old/items.lua; trigger@fsn_commands/server.lua
- fsn_phones:GUI:notification: trigger@fsn_phones/sv_phone.lua; trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:SYS:addCall: register@fsn_phones/cl_phone.lua; register@fsn_phones/cl_phone.lua
- fsn_phones:SYS:addTransaction: trigger@fsn_bank/client.lua; trigger@fsn_bank/client.lua; trigger@fsn_main/money/server.lua; trigger@fsn_main/money/server.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua
- fsn_phones:SYS:newNumber: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:SYS:receiveGarage: trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua
- fsn_phones:SYS:recieve:details: trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua
- fsn_phones:SYS:request:details: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:SYS:requestGarage: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:SYS:sendTweet: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:SYS:set:details: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:SYS:updateAdverts: trigger@fsn_phones/sv_phone.lua; trigger@fsn_phones/sv_phone.lua; trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:SYS:updateNumber: trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua
- fsn_phones:USE:Email: trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua
- fsn_phones:USE:Message: trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua
- fsn_phones:USE:Phone: register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua; trigger@fsn_commands/server.lua
- fsn_phones:USE:Tweet: trigger@fsn_phones/sv_phone.lua; register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua
- fsn_phones:USE:darkweb:order: register@fsn_phones/darkweb/cl_order.lua; handler@fsn_phones/darkweb/cl_order.lua
- fsn_phones:USE:sendAdvert: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:USE:sendMessage: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:UTIL:chat: handler@fsn_phones/sv_phone.lua; trigger@fsn_phones/cl_phone.lua
- fsn_phones:UTIL:displayNumber: register@fsn_phones/cl_phone.lua; handler@fsn_phones/cl_phone.lua; trigger@fsn_commands/server.lua
- fsn_police:911: trigger@fsn_jewellerystore/server.lua; register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/MDT/mdt_server.lua; trigger@fsn_commands/server.lua
- fsn_police:911r: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_commands/server.lua
- fsn_police:CAD:10-43: trigger@fsn_ems/client.lua
- fsn_police:GetInVehicle: register@fsn_police/K9/client.lua; handler@fsn_police/K9/client.lua; trigger@fsn_menu/main_client.lua
- fsn_police:MDT:receivewarrants: trigger@fsn_police/MDT/mdt_server.lua; trigger@fsn_police/MDT/mdt_server.lua; register@fsn_police/MDT/mdt_client.lua; handler@fsn_police/MDT/mdt_client.lua
- fsn_police:MDT:requestwarrants: handler@fsn_police/MDT/mdt_server.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua
- fsn_police:MDT:toggle: trigger@fsn_dev/server/server.lua; register@fsn_police/MDT/mdt_client.lua; handler@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:MDT:vehicledetails: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua
- fsn_police:MDT:warrant: handler@fsn_police/MDT/mdt_server.lua; trigger@fsn_police/MDT/mdt_client.lua
- fsn_police:MDTremovewarrant: handler@fsn_police/MDT/mdt_server.lua; trigger@fsn_police/MDT/mdt_client.lua
- fsn_police:Sit: register@fsn_police/K9/client.lua; handler@fsn_police/K9/client.lua; trigger@fsn_menu/main_client.lua
- fsn_police:ToggleFollow: trigger@fsn_menu/main_client.lua
- fsn_police:ToggleK9: register@fsn_police/K9/client.lua; handler@fsn_police/K9/client.lua; trigger@fsn_menu/main_client.lua
- fsn_police:armory:boughtOne: trigger@fsn_inventory/cl_inventory.lua; handler@fsn_police/armory/sv_armory.lua
- fsn_police:armory:closedArmory: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; handler@fsn_police/armory/sv_armory.lua
- fsn_police:armory:recieveItemsForArmory: trigger@fsn_inventory/sv_presets.lua; register@fsn_police/armory/sv_armory.lua; handler@fsn_police/armory/sv_armory.lua
- fsn_police:armory:request: trigger@fsn_inventory/cl_inventory.lua; register@fsn_police/armory/cl_armory.lua; handler@fsn_police/armory/cl_armory.lua; trigger@fsn_police/armory/cl_armory.lua; trigger@fsn_police/armory/cl_armory.lua; register@fsn_police/armory/sv_armory.lua; handler@fsn_police/armory/sv_armory.lua
- fsn_police:chat:ticket: handler@fsn_main/initial/server.lua; trigger@fsn_police/MDT/mdt_client.lua
- fsn_police:command:duty: trigger@fsn_dev/server/server.lua; register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:cuffs:requestCuff: trigger@fsn_police/client.lua; handler@fsn_police/server.lua
- fsn_police:cuffs:requestunCuff: trigger@fsn_police/client.lua; handler@fsn_police/server.lua
- fsn_police:cuffs:startCuffed: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua
- fsn_police:cuffs:startCuffing: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua
- fsn_police:cuffs:startunCuffed: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua
- fsn_police:cuffs:startunCuffing: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua
- fsn_police:cuffs:toggleEscort: trigger@fsn_police/client.lua; handler@fsn_police/server.lua
- fsn_police:cuffs:toggleHard: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/client.lua; handler@fsn_police/server.lua; trigger@fsn_police/server.lua
- fsn_police:database:CPIC: handler@fsn_police/MDT/mdt_server.lua; trigger@fsn_police/MDT/mdt_client.lua
- fsn_police:database:CPIC:search: handler@fsn_police/MDT/mdt_server.lua; trigger@fsn_commands/client.lua
- fsn_police:database:CPIC:search:result: trigger@fsn_police/MDT/mdt_server.lua; register@fsn_police/MDT/mdt_client.lua; handler@fsn_police/MDT/mdt_client.lua; trigger@fsn_doj/judges/server.lua
- fsn_police:dispatch: trigger@fsn_inventory/_old/_item_misc/_drug_selling.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_bankrobbery/client.lua; trigger@fsn_jewellerystore/client.lua; trigger@fsn_jewellerystore/client.lua; trigger@fsn_vehiclecontrol/client.lua; trigger@fsn_vehiclecontrol/speedcameras/client.lua; trigger@fsn_vehiclecontrol/speedcameras/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/holdup/client.lua; trigger@fsn_vehiclecontrol/damage/cl_crashes.lua; trigger@fsn_ems/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; handler@fsn_police/server.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_police/dispatch.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua; trigger@fsn_criminalmisc/drugs/_streetselling/client.lua; trigger@fsn_criminalmisc/robbing/cl_houses.lua
- fsn_police:dispatch:toggle: register@fsn_police/dispatch.lua; handler@fsn_police/dispatch.lua; trigger@fsn_commands/server.lua
- fsn_police:dispatchcall: trigger@fsn_ems/client.lua; trigger@fsn_police/server.lua; register@fsn_police/dispatch.lua; handler@fsn_police/dispatch.lua
- fsn_police:handcuffs:hard: trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:handcuffs:soft: trigger@fsn_commands/server.lua
- fsn_police:handcuffs:toggle: trigger@fsn_police/server.lua
- fsn_police:init: handler@fsn_doormanager/client.lua; handler@fsn_doormanager/cl_doors.lua; register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_spawnmanager/client.lua
- fsn_police:k9:search:person:end: trigger@fsn_police/K9/client.lua; handler@fsn_police/K9/server.lua
- fsn_police:k9:search:person:finish: register@fsn_police/K9/client.lua; handler@fsn_police/K9/client.lua; trigger@fsn_police/K9/server.lua
- fsn_police:k9:search:person:me: register@fsn_police/K9/client.lua; handler@fsn_police/K9/client.lua; trigger@fsn_commands/server.lua
- fsn_police:offDuty: trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; handler@fsn_police/server.lua
- fsn_police:onDuty: trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; handler@fsn_police/server.lua
- fsn_police:pd:toggleDrag: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua
- fsn_police:ply:toggleDrag: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua
- fsn_police:putMeInVeh: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:radar:toggle: register@fsn_police/radar/client.lua; handler@fsn_police/radar/client.lua; trigger@fsn_commands/server.lua
- fsn_police:requestUpdate: trigger@fsn_police/client.lua; trigger@fsn_police/client.lua; handler@fsn_police/server.lua
- fsn_police:runplate: handler@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_commands/server.lua
- fsn_police:runplate::target: handler@fsn_police/server.lua; trigger@fsn_commands/client.lua
- fsn_police:runplate:target: register@fsn_commands/client.lua; handler@fsn_commands/client.lua; trigger@fsn_commands/server.lua
- fsn_police:search:end:inventory: trigger@fsn_inventory/_old/client.lua; handler@fsn_police/server.lua
- fsn_police:search:end:money: trigger@fsn_main/money/client.lua; handler@fsn_police/server.lua
- fsn_police:search:end:weapons: handler@fsn_police/server.lua; trigger@fsn_criminalmisc/weaponinfo/client.lua
- fsn_police:search:start:inventory: register@fsn_inventory/_old/client.lua; handler@fsn_inventory/_old/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:search:start:money: register@fsn_main/money/client.lua; handler@fsn_main/money/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:search:start:weapons: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:search:strip: register@fsn_criminalmisc/weaponinfo/client.lua; handler@fsn_criminalmisc/weaponinfo/client.lua; trigger@fsn_commands/server.lua
- fsn_police:ticket: handler@fsn_police/server.lua; trigger@fsn_police/MDT/mdt_client.lua; trigger@fsn_commands/server.lua; trigger@fsn_doj/judges/server.lua
- fsn_police:toggleDrag: trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua
- fsn_police:toggleHandcuffs: handler@fsn_police/server.lua
- fsn_police:update: handler@fsn_doormanager/cl_doors.lua; register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; trigger@fsn_police/server.lua; handler@fsn_commands/server.lua
- fsn_police:updateLevel: register@fsn_police/client.lua; handler@fsn_police/client.lua; trigger@fsn_commands/server.lua
- fsn_properties:access: register@fsn_properties/cl_properties.lua; handler@fsn_properties/cl_properties.lua; trigger@fsn_properties/cl_properties.lua; handler@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua
- fsn_properties:buy: trigger@fsn_properties/cl_properties.lua; handler@fsn_properties/sv_properties.lua; register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:inv:closed: trigger@fsn_inventory/cl_inventory.lua; register@fsn_properties/cl_properties.lua; handler@fsn_properties/cl_properties.lua
- fsn_properties:inv:update: trigger@fsn_inventory/cl_inventory.lua; register@fsn_properties/cl_properties.lua; handler@fsn_properties/cl_properties.lua
- fsn_properties:keys:give: register@fsn_properties/cl_manage.lua; handler@fsn_properties/cl_manage.lua
- fsn_properties:leave: trigger@fsn_properties/cl_properties.lua; handler@fsn_properties/sv_properties.lua
- fsn_properties:menu:access:allow: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:access:revoke: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:access:view: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:inventory:deposit: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:inventory:take: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:money:deposit: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:money:withdraw: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:police:breach: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:police:empty: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:police:search: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:police:seize: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:rent:check: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:rent:pay: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:robbery: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:weapon:deposit: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:menu:weapon:take: register@fsn_storagelockers/client.lua; trigger@fsn_storagelockers/client.lua
- fsn_properties:realator:clock: handler@fsn_properties/sv_properties.lua
- fsn_properties:rent:check: trigger@fsn_properties/cl_properties.lua; handler@fsn_properties/sv_properties.lua
- fsn_properties:rent:pay: trigger@fsn_properties/cl_properties.lua; handler@fsn_properties/sv_properties.lua
- fsn_properties:request: trigger@fsn_properties/cl_properties.lua; handler@fsn_properties/sv_properties.lua
- fsn_properties:requestKeys: trigger@fsn_properties/cl_properties.lua
- fsn_properties:updateXYZ: register@fsn_properties/cl_properties.lua; handler@fsn_properties/cl_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua
- fsn_spawnmanager:start: trigger@fsn_main/initial/client.lua; register@fsn_spawnmanager/client.lua; handler@fsn_spawnmanager/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_apartments/client.lua
- fsn_store:boughtOne: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; handler@fsn_store/server.lua
- fsn_store:closedStore: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_inventory/cl_inventory.lua; handler@fsn_store/server.lua
- fsn_store:recieveItemsForStore: trigger@fsn_inventory/sv_presets.lua; register@fsn_store/server.lua; handler@fsn_store/server.lua
- fsn_store:request: trigger@fsn_inventory/cl_inventory.lua; trigger@fsn_store/client.lua; trigger@fsn_store/client.lua; handler@fsn_store/server.lua
- fsn_store_guns:boughtOne: handler@fsn_store_guns/server.lua
- fsn_store_guns:closedStore: handler@fsn_store_guns/server.lua
- fsn_store_guns:request: trigger@fsn_store_guns/client.lua; handler@fsn_store_guns/server.lua
- fsn_stripclub:client:update: register@fsn_stripclub/client.lua; handler@fsn_stripclub/client.lua
- fsn_stripclub:server:claimBooth: trigger@fsn_stripclub/client.lua
- fsn_teleporters:teleport:coordinates: trigger@fsn_dev/server/server.lua; register@fsn_teleporters/client.lua; handler@fsn_teleporters/client.lua; trigger@fsn_commands/server.lua
- fsn_teleporters:teleport:waypoint: trigger@fsn_dev/server/server.lua; register@fsn_teleporters/client.lua; handler@fsn_teleporters/client.lua; trigger@fsn_commands/server.lua
- fsn_timeandweather:notify: register@fsn_timeandweather/client.lua; register@fsn_timeandweather/client.lua; handler@fsn_timeandweather/client.lua; handler@fsn_timeandweather/client.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua
- fsn_timeandweather:requestSync: trigger@fsn_timeandweather/client.lua; trigger@fsn_timeandweather/client.lua; handler@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua
- fsn_timeandweather:updateTime: register@fsn_timeandweather/client.lua; register@fsn_timeandweather/client.lua; handler@fsn_timeandweather/client.lua; handler@fsn_timeandweather/client.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua
- fsn_timeandweather:updateWeather: register@fsn_timeandweather/client.lua; register@fsn_timeandweather/client.lua; handler@fsn_timeandweather/client.lua; handler@fsn_timeandweather/client.lua; trigger@fsn_timeandweather/server.lua; trigger@fsn_timeandweather/server.lua
- fsn_vehiclecontrol:damage:repair: register@fsn_vehiclecontrol/damage/client.lua; handler@fsn_vehiclecontrol/damage/client.lua; trigger@fsn_commands/server.lua
- fsn_vehiclecontrol:damage:repairkit: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_vehiclecontrol/damage/client.lua; handler@fsn_vehiclecontrol/damage/client.lua
- fsn_vehiclecontrol:flagged:add: register@fsn_vehiclecontrol/speedcameras/client.lua; handler@fsn_vehiclecontrol/speedcameras/client.lua
- fsn_vehiclecontrol:getKeys: trigger@fsn_vehiclecontrol/keys/server.lua; register@fsn_vehiclecontrol/engine/client.lua; handler@fsn_vehiclecontrol/engine/client.lua
- fsn_vehiclecontrol:giveKeys: register@fsn_vehiclecontrol/engine/client.lua; handler@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_menu/main_client.lua
- fsn_vehiclecontrol:givekeys: handler@fsn_vehiclecontrol/keys/server.lua; trigger@fsn_vehiclecontrol/engine/client.lua
- fsn_vehiclecontrol:keys:carjack: register@fsn_vehiclecontrol/engine/client.lua; handler@fsn_vehiclecontrol/engine/client.lua; trigger@fsn_cargarage/client.lua; trigger@fsn_criminalmisc/lockpicking/client.lua
- fsn_vehiclecontrol:trunk:forceIn: register@fsn_vehiclecontrol/trunk/client.lua; handler@fsn_vehiclecontrol/trunk/client.lua; trigger@fsn_vehiclecontrol/trunk/client.lua; handler@fsn_vehiclecontrol/trunk/server.lua; trigger@fsn_vehiclecontrol/trunk/server.lua
- fsn_vehiclecontrol:trunk:forceOut: register@fsn_vehiclecontrol/trunk/client.lua; handler@fsn_vehiclecontrol/trunk/client.lua; trigger@fsn_ems/cl_carrydead.lua
- fsn_voicecontrol:call:answer: trigger@fsn_voicecontrol/client.lua; handler@fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:decline: handler@fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:end: trigger@fsn_voicecontrol/client.lua; trigger@fsn_voicecontrol/client.lua; trigger@fsn_voicecontrol/client.lua; handler@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:hold: trigger@fsn_voicecontrol/client.lua; handler@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:ring: register@fsn_voicecontrol/client.lua; handler@fsn_voicecontrol/client.lua; handler@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:start: trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:unhold: trigger@fsn_voicecontrol/client.lua; handler@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua; trigger@fsn_voicecontrol/server.lua
- fsn_yoga:checkStress: register@fsn_activities/yoga/client.lua; handler@fsn_activities/yoga/client.lua; trigger@fsn_activities/yoga/client.lua
- jCAD:tow: trigger@fsn_jobs/tow/client.lua
- jFarm:payme: trigger@fsn_jobs/farming/client.lua
- jTow:afford: register@fsn_jobs/tow/client.lua; handler@fsn_jobs/tow/client.lua
- jTow:mark: register@fsn_jobs/tow/client.lua; handler@fsn_jobs/tow/client.lua
- jTow:return: trigger@fsn_jobs/tow/client.lua
- jTow:spawn: trigger@fsn_jobs/tow/client.lua
- jTow:success: trigger@fsn_jobs/tow/client.lua
- mhacking:hide: trigger@fsn_bankrobbery/cl_frontdesks.lua; trigger@fsn_bankrobbery/cl_frontdesks.lua
- mhacking:show: trigger@fsn_bankrobbery/cl_frontdesks.lua
- mhacking:start: trigger@fsn_bankrobbery/cl_frontdesks.lua
- mythic_hospital:client:FieldTreatBleed: register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:FieldTreatLimbs: register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:ReduceBleed: register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:RemoveBleed: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_ems/client.lua; register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/beds/client.lua
- mythic_hospital:client:ResetLimbs: trigger@fsn_ems/client.lua; register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/beds/client.lua
- mythic_hospital:client:SyncBleed: register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:UseAdrenaline: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:UsePainKiller: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/cl_uses.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; trigger@fsn_inventory/_old/items.lua; register@fsn_ems/cl_advanceddamage.lua; handler@fsn_ems/cl_advanceddamage.lua
- mythic_hospital:server:SyncInjuries: trigger@fsn_ems/cl_advanceddamage.lua; trigger@fsn_ems/cl_advanceddamage.lua
- mythic_notify:SendAlert: trigger@fsn_inventory/sv_inventory.lua
- mythic_notify:client:SendAlert: trigger@fsn_inventory/sv_vehicles.lua; trigger@fsn_inventory/pd_locker/sv_locker.lua; trigger@fsn_inventory/pd_locker/sv_locker.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_bankrobbery/sv_frontdesks.lua; trigger@fsn_gangs/cl_gangs.lua; trigger@fsn_gangs/sv_gangs.lua; trigger@fsn_gangs/sv_gangs.lua; trigger@fsn_gangs/sv_gangs.lua; trigger@fsn_gangs/sv_gangs.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_properties/sv_properties.lua; trigger@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua; trigger@fsn_boatshop/sv_boatshop.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_criminalmisc/streetracing/server.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_inventory_dropping/sv_dropping.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_commands/server.lua; trigger@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; trigger@fsn_carstore/sv_carstore.lua; trigger@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/sv_evidence.lua; trigger@fsn_evidence/sv_evidence.lua
- onClientResourceStart: handler@fsn_customs/lscustoms.lua; handler@fsn_newchat/cl_chat.lua; handler@fsn_jobs/mechanic/client.lua
- onResourceStart: handler@fsn_inventory/sv_presets.lua; handler@fsn_store/server.lua; handler@fsn_admin/server/server.lua; handler@fsn_main/misc/version.lua; handler@fsn_police/armory/sv_armory.lua
- onResourceStop: handler@fsn_customanimations/client.lua
- onServerResourceStart: handler@fsn_newchat/sv_chat.lua
- pNotify:SendNotification: trigger@fsn_inventory/_item_misc/dm_laundering.lua; trigger@fsn_jail/client.lua; trigger@fsn_jail/client.lua; trigger@fsn_jail/server.lua; trigger@fsn_jail/server.lua; trigger@fsn_ems/client.lua; trigger@fsn_ems/client.lua; trigger@fsn_notify/server.lua; register@fsn_notify/cl_notify.lua; handler@fsn_notify/cl_notify.lua; trigger@fsn_notify/cl_notify.lua; trigger@fsn_notify/cl_notify.lua; trigger@fsn_notify/cl_notify.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/tow/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_jobs/farming/client.lua; trigger@fsn_jobs/farming/client.lua
- pNotify:SetQueueMax: register@fsn_notify/cl_notify.lua; handler@fsn_notify/cl_notify.lua
- playerConnecting: handler@fsn_main/misc/version.lua; handler@fsn_main/playermanager/server.lua; handler@fsn_main/banmanager/sv_bans.lua
- playerDropped: handler@fsn_ems/server.lua; handler@fsn_newchat/sv_chat.lua; handler@fsn_store/server.lua; handler@fsn_store_guns/server.lua; handler@fsn_main/sv_utils.lua; handler@fsn_main/playermanager/server.lua; handler@fsn_main/initial/server.lua; handler@fsn_main/initial/server.lua; handler@fsn_police/server.lua; handler@fsn_police/armory/sv_armory.lua; handler@fsn_phones/sv_phone.lua; handler@fsn_apartments/server.lua
- playerSpawned: handler@fsn_main/playermanager/client.lua; handler@fsn_timeandweather/client.lua; handler@fsn_timeandweather/client.lua; handler@fsn_carstore/cl_menu.lua
- police:setAnimData: trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua; trigger@fsn_emotecontrol/walktypes/client.lua
- safe:success: trigger@fsn_bankrobbery/cl_safeanim.lua
- safecracking:loop: register@fsn_bankrobbery/cl_safeanim.lua; handler@fsn_bankrobbery/cl_safeanim.lua; trigger@fsn_bankrobbery/cl_safeanim.lua
- safecracking:start: register@fsn_bankrobbery/cl_safeanim.lua; handler@fsn_bankrobbery/cl_safeanim.lua; trigger@fsn_bankrobbery/cl_safeanim.lua
- spawnme: register@fsn_main/initial/client.lua; handler@fsn_main/initial/client.lua; trigger@fsn_spawnmanager/client.lua; trigger@fsn_spawnmanager/client.lua
- tow:CAD:tow: register@fsn_jobs/tow/client.lua; handler@fsn_jobs/tow/client.lua
- xgc-tuner:openTuner: trigger@fsn_inventory/cl_uses.lua; trigger@fsn_dev/server/server.lua; trigger@fsn_commands/server.lua

- sc: fsn_admin/server/server.lua, fsn_admin/server/server.lua

Automatic extraction may miss dynamic or runtime-generated behaviors. Further manual review may be needed.
DOCS COMPLETE —
*Description:* --------------------------------------------------- Drug stuffs
*Events:* trigger:fsn_notify:displayNotification, trigger:fsn_police:dispatch, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_inventory:item:add, trigger:fsn_inventory:item:take, trigger:fsn_notify:displayNotification

### fsn_jail/agents.md
*Role:* shared
*Description:* AGENTS.md

### fsn_jail/server.lua
*Role:* server
*Events:* register:fsn_jail:spawn, register:fsn_jail:sendsuspect, register:fsn_jail:update:database, handler:fsn_main:updateCharacters, handler:fsn_jail:spawn, handler:fsn_jail:sendsuspect, handler:fsn_jail:update:database
*DB Calls:* MySQL.Async, MySQL.Async, MySQL.Async

### fsn_jail/client.lua
*Role:* client
*Description:* print(maff..' not larger than '..timetick..', waiting')
*Events:* register:fsn_jail:spawn:recieve, register:fsn_jail:sendme, register:fsn_jail:releaseme, register:fsn_jail:init, trigger:fsn_jail:sendme, trigger:fsn_jail:update:database, trigger:pNotify:SendNotification, trigger:fsn_hungerandthirst:pause, trigger:fsn_jail:update:database, trigger:pNotify:SendNotification, trigger:fsn_hungerandthirst:unpause, trigger:fsn_jail:spawn, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_notify:displayNotification, trigger:fsn_jail:releaseme, trigger:fsn_jail:update:database, handler:fsn_jail:spawn:recieve, handler:fsn_jail:sendme, handler:fsn_jail:releaseme, handler:fsn_jail:init

### fsn_jail/fxmanifest.lua
*Role:* shared
*Description:* [[/	:FSN:	\]]--
*DB Calls:* MySQL.lua

## Cross-Index
### Events
- 1a4d29ac-5c1a-427e-ab18-461ae6b76e8b: fsn_customanimations/client.lua
- 321236ce-42a6-43d8-af3d-e0e30c9e66b7: fsn_customanimations/client.lua
- 394084c7-ac07-424a-982b-ab2267d8d55f: fsn_customanimations/client.lua
- AnimSet:Alien: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Brave: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Business: fsn_emotecontrol/walktypes/client.lua
- AnimSet:ChiChi: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Hobo: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Hurry: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Injured: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Joy: fsn_emotecontrol/walktypes/client.lua
- AnimSet:ManEater: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Money: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Moon: fsn_emotecontrol/walktypes/client.lua
- AnimSet:NonChalant: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Posh: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Sad: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Sassy: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Sexy: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Shady: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Swagger: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Tipsy: fsn_emotecontrol/walktypes/client.lua
- AnimSet:Tired: fsn_emotecontrol/walktypes/client.lua
- AnimSet:ToughGuy: fsn_emotecontrol/walktypes/client.lua
- AnimSet:default: fsn_emotecontrol/walktypes/client.lua
- Cam:ToggleCam: fsn_jobs/news/client.lua
- DoLongHudText: fsn_bankrobbery/cl_safeanim.lua
- EngineToggle:Engine: fsn_menu/main_client.lua, fsn_vehiclecontrol/engine/client.lua
- EngineToggle:RPDamage: fsn_vehiclecontrol/engine/client.lua
- InteractSound_SV:PlayWithinDistance: fsn_doormanager/cl_doors.lua, fsn_phones/cl_phone.lua, fsn_police/client.lua, fsn_voicecontrol/client.lua
- Mic:ToggleMic: fsn_jobs/news/client.lua
- PlayerSpawned: fsn_main/initial/client.lua
- Tackle:Client:TacklePlayer: fsn_police/tackle/client.lua
- Tackle:Server:TacklePlayer: fsn_police/tackle/client.lua, fsn_police/tackle/server.lua
- __cfx_internal:commandFallback: fsn_newchat/sv_chat.lua
- __cfx_internal:serverPrint: fsn_newchat/cl_chat.lua
- _chat:messageEntered: fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua
- binoculars:Activate: fsn_inventory/_item_misc/binoculars.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- c: fsn_phones/sv_phone.lua
- camera:Activate: fsn_jobs/news/client.lua
- chat:addMessage: fsn_admin/client/client.lua, fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua
- chat:addSuggestion: fsn_customanimations/client.lua, fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua
- chat:addSuggestions: fsn_newchat/cl_chat.lua
- chat:addTemplate: fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua
- chat:clear: fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua
- chat:init: fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua
- chat:removeSuggestion: fsn_customanimations/client.lua, fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua
- chatMessage: fsn_admin/client.lua, fsn_admin/server.lua, fsn_apartments/client.lua, fsn_apartments/server.lua, fsn_bankrobbery/client.lua, fsn_boatshop/sv_boatshop.lua, fsn_carstore/sv_carstore.lua, fsn_commands/client.lua, fsn_commands/server.lua, fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_customanimations/client.lua, fsn_doj/judges/server.lua, fsn_emotecontrol/client.lua, fsn_ems/client.lua, fsn_inventory/_item_misc/dm_laundering.lua, fsn_inventory/_old/client.lua, fsn_inventory/sv_inventory.lua, fsn_jobs/hunting/client.lua, fsn_jobs/mechanic/client.lua, fsn_jobs/scrap/client.lua, fsn_jobs/trucker/client.lua, fsn_menu/main_client.lua, fsn_newchat/cl_chat.lua, fsn_newchat/sv_chat.lua, fsn_notify/cl_notify.lua, fsn_phones/cl_phone.lua, fsn_playerlist/client.lua, fsn_police/MDT/mdt_client.lua, fsn_police/client.lua, fsn_police/dispatch.lua, fsn_police/radar/client.lua, fsn_police/tackle/client.lua, fsn_priority/administration.lua, fsn_properties/cl_properties.lua
- clothes:changemodel: fsn_clothing/client.lua
- clothes:firstspawn: fsn_clothing/client.lua, fsn_clothing/server.lua
- clothes:loaded: fsn_clothing/client.lua
- clothes:save: fsn_clothing/client.lua
- clothes:setComponents: fsn_clothing/client.lua
- clothes:spawn: fsn_apartments/client.lua, fsn_clothing/client.lua, fsn_spawnmanager/client.lua
- freecam:onTick: fsn_dev/client/cl_noclip.lua
- fs_freemode:displaytext: fsn_bankrobbery/trucks.lua
- fs_freemode:missionComplete: fsn_bankrobbery/trucks.lua
- fs_freemode:notify: fsn_bankrobbery/trucks.lua
- fsn->esx:clothing:spawn: fsn_spawnmanager/client.lua
- fsn:getFsnObject: fsn_admin/server/server.lua, fsn_dev/server/server.lua, fsn_main/sv_utils.lua
- fsn:playerReady: fsn_admin/server/server.lua, fsn_dev/server/server.lua, fsn_main/initial/client.lua
- fsn_admin:FreezeMe: fsn_admin/client.lua, fsn_admin/client/client.lua
- fsn_admin:enableAdminCommands: fsn_admin/server/server.lua
- fsn_admin:enableModeratorCommands: fsn_admin/server/server.lua
- fsn_admin:fix: fsn_admin/server.lua
- fsn_admin:recieveXYZ: fsn_admin/client.lua, fsn_admin/client/client.lua
- fsn_admin:requestXYZ: fsn_admin/client.lua, fsn_admin/client/client.lua
- fsn_admin:sendXYZ: fsn_admin/client.lua, fsn_admin/client/client.lua, fsn_admin/server.lua
- fsn_admin:spawnCar: fsn_admin/server.lua
- fsn_admin:spawnVehicle: fsn_admin/client/client.lua
- fsn_apartments:characterCreation: fsn_apartments/client.lua
- fsn_apartments:createApartment: fsn_apartments/client.lua, fsn_apartments/server.lua
- fsn_apartments:getApartment: fsn_apartments/server.lua, fsn_spawnmanager/client.lua
- fsn_apartments:instance

RegisterServerEvent(: fsn_apartments/sv_instancing.lua
- fsn_apartments:instance:debug: fsn_apartments/cl_instancing.lua
- fsn_apartments:instance:join: fsn_apartments/cl_instancing.lua, fsn_apartments/sv_instancing.lua
- fsn_apartments:instance:leave: fsn_apartments/cl_instancing.lua, fsn_apartments/client.lua, fsn_apartments/sv_instancing.lua, fsn_criminalmisc/robbing/cl_houses.lua
- fsn_apartments:instance:new: fsn_apartments/client.lua, fsn_apartments/sv_instancing.lua, fsn_criminalmisc/robbing/cl_houses.lua
- fsn_apartments:instance:update: fsn_apartments/cl_instancing.lua
- fsn_apartments:inv:update: fsn_apartments/client.lua, fsn_inventory/cl_inventory.lua
- fsn_apartments:outfit:add: fsn_apartments/client.lua
- fsn_apartments:outfit:list: fsn_apartments/client.lua
- fsn_apartments:outfit:remove: fsn_apartments/client.lua
- fsn_apartments:outfit:use: fsn_apartments/client.lua
- fsn_apartments:saveApartment: fsn_apartments/client.lua, fsn_apartments/server.lua
- fsn_apartments:sendApartment: fsn_apartments/client.lua
- fsn_apartments:stash:add: fsn_apartments/client.lua
- fsn_apartments:stash:take: fsn_apartments/client.lua
- fsn_bank:change:bankAdd: fsn_jobs/client.lua, fsn_jobs/garbage/client.lua, fsn_jobs/taxi/client.lua, fsn_main/money/client.lua, fsn_spawnmanager/client.lua
- fsn_bank:change:bankMinus: fsn_ems/client.lua, fsn_jobs/garbage/client.lua, fsn_jobs/taxi/client.lua, fsn_jobs/trucker/client.lua, fsn_main/money/client.lua
- fsn_bank:change:bankandwallet: fsn_bank/client.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_ems/client.lua, fsn_main/money/client.lua
- fsn_bank:change:walletAdd: fsn_apartments/client.lua, fsn_boatshop/cl_boatshop.lua, fsn_criminalmisc/pawnstore/cl_pawnstore.lua, fsn_criminalmisc/robbing/cl_houses.lua, fsn_inventory/_item_misc/burger_store.lua, fsn_inventory/_item_misc/dm_laundering.lua, fsn_jobs/farming/client.lua, fsn_jobs/taxi/client.lua, fsn_jobs/tow/client.lua, fsn_jobs/trucker/client.lua, fsn_main/money/client.lua, fsn_properties/cl_properties.lua, fsn_store/client.lua, fsn_vehiclecontrol/holdup/client.lua
- fsn_bank:change:walletMinus: fsn_apartments/client.lua, fsn_bikerental/client.lua, fsn_boatshop/cl_boatshop.lua, fsn_boatshop/cl_menu.lua, fsn_cargarage/client.lua, fsn_carstore/cl_carstore.lua, fsn_carstore/cl_menu.lua, fsn_clothing/config.lua, fsn_crafting/client.lua, fsn_customs/lscustoms.lua, fsn_inventory/_item_misc/cl_breather.lua, fsn_inventory/_item_misc/dm_laundering.lua, fsn_inventory/cl_inventory.lua, fsn_jobs/mechanic/mechmenu.lua, fsn_jobs/taxi/client.lua, fsn_jobs/tow/client.lua, fsn_jobs/trucker/client.lua, fsn_licenses/client.lua, fsn_main/initial/client.lua, fsn_main/money/client.lua, fsn_needs/vending.lua, fsn_properties/cl_properties.lua, fsn_store/client.lua, fsn_store_guns/client.lua, fsn_vehiclecontrol/carwash/client.lua, fsn_vehiclecontrol/fuel/client.lua
- fsn_bank:database:update: fsn_bank/server.lua
- fsn_bank:request:both: fsn_bank/client.lua, fsn_main/money/client.lua
- fsn_bank:transfer: fsn_bank/client.lua, fsn_bank/server.lua
- fsn_bank:update:both: fsn_bank/client.lua, fsn_main/money/client.lua
- fsn_bankrobbery:LostMC:spawn: fsn_bankrobbery/client.lua, fsn_criminalmisc/lockpicking/client.lua
- fsn_bankrobbery:closeDoor: fsn_bankrobbery/client.lua
- fsn_bankrobbery:desks:doorUnlock: fsn_bankrobbery/sv_frontdesks.lua, fsn_criminalmisc/lockpicking/client.lua
- fsn_bankrobbery:desks:endHack: fsn_bankrobbery/cl_frontdesks.lua, fsn_bankrobbery/sv_frontdesks.lua
- fsn_bankrobbery:desks:receive: fsn_bankrobbery/cl_frontdesks.lua, fsn_criminalmisc/lockpicking/client.lua
- fsn_bankrobbery:desks:request: fsn_bankrobbery/cl_frontdesks.lua, fsn_bankrobbery/sv_frontdesks.lua
- fsn_bankrobbery:desks:startHack: fsn_bankrobbery/cl_frontdesks.lua, fsn_bankrobbery/sv_frontdesks.lua
- fsn_bankrobbery:init: fsn_bankrobbery/client.lua, fsn_bankrobbery/server.lua
- fsn_bankrobbery:openDoor: fsn_bankrobbery/client.lua
- fsn_bankrobbery:payout: fsn_bankrobbery/client.lua, fsn_bankrobbery/server.lua
- fsn_bankrobbery:start: fsn_bankrobbery/client.lua, fsn_bankrobbery/server.lua
- fsn_bankrobbery:timer: fsn_bankrobbery/client.lua
- fsn_bankrobbery:vault:close: fsn_bankrobbery/client.lua, fsn_bankrobbery/server.lua
- fsn_bankrobbery:vault:open: fsn_bankrobbery/client.lua, fsn_bankrobbery/server.lua
- fsn_boatshop:floor:ChangeBoat: fsn_boatshop/cl_menu.lua, fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:Request: fsn_boatshop/cl_boatshop.lua, fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:Update: fsn_boatshop/cl_boatshop.lua
- fsn_boatshop:floor:Updateboat: fsn_boatshop/cl_boatshop.lua
- fsn_boatshop:floor:color:One: fsn_boatshop/cl_boatshop.lua, fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:color:Two: fsn_boatshop/cl_boatshop.lua, fsn_boatshop/sv_boatshop.lua
- fsn_boatshop:floor:commission: fsn_boatshop/cl_boatshop.lua, fsn_boatshop/sv_boatshop.lua
- fsn_cargarage:buyVehicle: fsn_boatshop/cl_boatshop.lua, fsn_carstore/cl_carstore.lua, fsn_main/initial/server.lua
- fsn_cargarage:checkStatus: fsn_cargarage/client.lua
- fsn_cargarage:impound: fsn_cargarage/server.lua, fsn_commands/client.lua
- fsn_cargarage:makeMine: fsn_admin/client/client.lua, fsn_admin/server.lua, fsn_boatshop/cl_boatshop.lua, fsn_cargarage/client.lua, fsn_carstore/cl_carstore.lua, fsn_commands/client.lua, fsn_dev/client/client.lua, fsn_doj/judges/client.lua, fsn_inventory/_item_misc/dm_laundering.lua, fsn_jobs/delivery/client.lua, fsn_jobs/farming/client.lua, fsn_jobs/garbage/client.lua, fsn_jobs/taxi/client.lua, fsn_jobs/tow/client.lua, fsn_jobs/trucker/client.lua
- fsn_cargarage:receiveVehicles: fsn_cargarage/client.lua
- fsn_cargarage:requestVehicles: fsn_cargarage/client.lua, fsn_cargarage/server.lua
- fsn_cargarage:reset: fsn_cargarage/client.lua, fsn_cargarage/server.lua
- fsn_cargarage:updateVehicle: fsn_cargarage/server.lua, fsn_customs/lscustoms.lua, fsn_jobs/mechanic/mechmenu.lua
- fsn_cargarage:vehicle:toggleStatus: fsn_cargarage/client.lua, fsn_cargarage/server.lua
- fsn_cargarage:vehicleStatus: fsn_cargarage/client.lua
- fsn_carstore:floor:ChangeCar: fsn_carstore/cl_menu.lua, fsn_carstore/sv_carstore.lua
- fsn_carstore:floor:Request: fsn_carstore/cl_carstore.lua, fsn_carstore/sv_carstore.lua
- fsn_carstore:floor:Update: fsn_carstore/cl_carstore.lua
- fsn_carstore:floor:UpdateCar: fsn_carstore/cl_carstore.lua
- fsn_carstore:floor:color:One: fsn_carstore/cl_carstore.lua, fsn_carstore/sv_carstore.lua
- fsn_carstore:floor:color:Two: fsn_carstore/cl_carstore.lua, fsn_carstore/sv_carstore.lua
- fsn_carstore:floor:commission: fsn_carstore/cl_carstore.lua, fsn_carstore/sv_carstore.lua
- fsn_characterdetails:recievetattoos: fsn_characterdetails/tattoos/client.lua
- fsn_clothing:menu: fsn_apartments/client.lua, fsn_clothing/client.lua
- fsn_clothing:requestDefault: fsn_clothing/server.lua
- fsn_clothing:save: fsn_clothing/server.lua
- fsn_commands:airlift: fsn_commands/client.lua
- fsn_commands:clothing:glasses: fsn_commands/client.lua
- fsn_commands:clothing:hat: fsn_commands/client.lua
- fsn_commands:clothing:mask: fsn_commands/client.lua
- fsn_commands:dev:fix: fsn_commands/client.lua
- fsn_commands:dev:spawnCar: fsn_commands/client.lua
- fsn_commands:dev:weapon: fsn_commands/client.lua
- fsn_commands:dropweapon: fsn_commands/client.lua
- fsn_commands:ems:adamage:inspect: fsn_commands/server.lua, fsn_ems/cl_advanceddamage.lua
- fsn_commands:getHDC: fsn_commands/client.lua, fsn_menu/main_client.lua
- fsn_commands:hc:takephone: fsn_commands/client.lua
- fsn_commands:me: fsn_commands/client.lua, fsn_commands/server.lua, fsn_criminalmisc/lockpicking/client.lua, fsn_emotecontrol/client.lua, fsn_inventory/_old/client.lua, fsn_menu/main_client.lua, fsn_police/MDT/mdt_client.lua, fsn_vehiclecontrol/client.lua, fsn_vehiclecontrol/engine/client.lua
- fsn_commands:me:3d: fsn_commands/client.lua
- fsn_commands:police:boot: fsn_commands/client.lua
- fsn_commands:police:booted: fsn_commands/client.lua, fsn_commands/server.lua
- fsn_commands:police:car: fsn_commands/client.lua
- fsn_commands:police:cpic:trigger: fsn_commands/client.lua
- fsn_commands:police:extra: fsn_commands/client.lua
- fsn_commands:police:extras: fsn_commands/client.lua
- fsn_commands:police:fix: fsn_commands/client.lua
- fsn_commands:police:gsrMe: fsn_police/dispatch.lua
- fsn_commands:police:gsrResult: fsn_commands/server.lua, fsn_police/dispatch.lua
- fsn_commands:police:impound: fsn_commands/client.lua
- fsn_commands:police:impound2: fsn_commands/client.lua
- fsn_commands:police:livery: fsn_commands/client.lua
- fsn_commands:police:lock: fsn_jewellerystore/client.lua
- fsn_commands:police:pedcarry: fsn_commands/client.lua
- fsn_commands:police:pedrevive: fsn_commands/client.lua
- fsn_commands:police:rifle: fsn_commands/client.lua
- fsn_commands:police:shotgun: fsn_commands/client.lua
- fsn_commands:police:towMark: fsn_commands/client.lua
- fsn_commands:police:unboot: fsn_commands/client.lua
- fsn_commands:police:unbooted: fsn_commands/client.lua, fsn_commands/server.lua
- fsn_commands:police:updateBoot: fsn_commands/client.lua
- fsn_commands:printxyz: fsn_commands/client.lua, fsn_commands/server.lua
- fsn_commands:requestHDC: fsn_commands/client.lua, fsn_commands/server.lua
- fsn_commands:sendxyz: fsn_commands/client.lua
- fsn_commands:service:addPing: fsn_commands/client.lua, fsn_commands/server.lua
- fsn_commands:service:pingAccept: fsn_commands/client.lua
- fsn_commands:service:pingStart: fsn_commands/client.lua
- fsn_commands:service:request: fsn_commands/client.lua
- fsn_commands:service:sendrequest: fsn_commands/client.lua, fsn_commands/server.lua
- fsn_commands:vehdoor:close: fsn_commands/client.lua
- fsn_commands:vehdoor:open: fsn_commands/client.lua
- fsn_commands:walk:set: fsn_commands/client.lua
- fsn_commands:window: fsn_commands/client.lua
- fsn_criminalmisc:drugs:effects:cocaine: fsn_criminalmisc/drugs/_effects/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- fsn_criminalmisc:drugs:effects:meth: fsn_criminalmisc/drugs/_effects/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- fsn_criminalmisc:drugs:effects:smokeCigarette: fsn_criminalmisc/drugs/_effects/client.lua, fsn_inventory/cl_uses.lua
- fsn_criminalmisc:drugs:effects:weed: fsn_criminalmisc/drugs/_effects/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- fsn_criminalmisc:drugs:streetselling:area: fsn_inventory/_old/items.lua
- fsn_criminalmisc:drugs:streetselling:radio: fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/drugs/_streetselling/server.lua
- fsn_criminalmisc:drugs:streetselling:request: fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/drugs/_streetselling/server.lua
- fsn_criminalmisc:drugs:streetselling:send: fsn_criminalmisc/drugs/_streetselling/client.lua
- fsn_criminalmisc:handcuffs:requestCuff: fsn_criminalmisc/handcuffs/client.lua, fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:requestunCuff: fsn_criminalmisc/handcuffs/client.lua, fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:handcuffs:startCuffed: fsn_criminalmisc/handcuffs/client.lua
- fsn_criminalmisc:handcuffs:startCuffing: fsn_criminalmisc/handcuffs/client.lua
- fsn_criminalmisc:handcuffs:startunCuffed: fsn_criminalmisc/handcuffs/client.lua
- fsn_criminalmisc:handcuffs:startunCuffing: fsn_criminalmisc/handcuffs/client.lua
- fsn_criminalmisc:handcuffs:toggleEscort: fsn_criminalmisc/handcuffs/client.lua, fsn_criminalmisc/handcuffs/server.lua
- fsn_criminalmisc:houserobbery:try: fsn_criminalmisc/robbing/cl_houses.lua, fsn_inventory/cl_uses.lua
- fsn_criminalmisc:lockpicking: fsn_criminalmisc/lockpicking/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- fsn_criminalmisc:racing:createRace: fsn_criminalmisc/streetracing/client.lua, fsn_menu/main_client.lua
- fsn_criminalmisc:racing:joinRace: fsn_criminalmisc/streetracing/client.lua, fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:racing:newRace: fsn_criminalmisc/streetracing/client.lua, fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:racing:putmeinrace: fsn_criminalmisc/streetracing/client.lua
- fsn_criminalmisc:racing:update: fsn_criminalmisc/streetracing/client.lua
- fsn_criminalmisc:racing:win: fsn_criminalmisc/streetracing/client.lua, fsn_criminalmisc/streetracing/server.lua
- fsn_criminalmisc:robbing:requesRob: fsn_criminalmisc/handcuffs/client.lua
- fsn_criminalmisc:robbing:startRobbing: fsn_criminalmisc/handcuffs/client.lua, fsn_criminalmisc/robbing/client.lua, fsn_ems/cl_carrydead.lua
- fsn_criminalmisc:toggleDrag: fsn_criminalmisc/handcuffs/client.lua
- fsn_criminalmisc:weapons:add: fsn_criminalmisc/weaponinfo/client.lua
- fsn_criminalmisc:weapons:add:police: fsn_commands/client.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_police/client.lua
- fsn_criminalmisc:weapons:add:tbl: fsn_apartments/client.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_properties/cl_properties.lua
- fsn_criminalmisc:weapons:add:unknown: fsn_commands/client.lua, fsn_criminalmisc/weaponinfo/client.lua
- fsn_criminalmisc:weapons:addDrop: fsn_criminalmisc/weaponinfo/client.lua, fsn_criminalmisc/weaponinfo/server.lua
- fsn_criminalmisc:weapons:destroy: fsn_apartments/client.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_properties/cl_properties.lua
- fsn_criminalmisc:weapons:drop: fsn_criminalmisc/weaponinfo/client.lua
- fsn_criminalmisc:weapons:equip: fsn_clothing/client.lua, fsn_criminalmisc/weaponinfo/client.lua
- fsn_criminalmisc:weapons:info: fsn_criminalmisc/weaponinfo/client.lua
- fsn_criminalmisc:weapons:pickup: fsn_criminalmisc/weaponinfo/client.lua, fsn_criminalmisc/weaponinfo/server.lua
- fsn_criminalmisc:weapons:updateDropped: fsn_criminalmisc/weaponinfo/client.lua
- fsn_dev:debug: fsn_inventory/_old/client.lua
- fsn_developer:deleteVehicle: fsn_dev/client/client.lua
- fsn_developer:enableDeveloperCommands: fsn_dev/server/server.lua
- fsn_developer:fixVehicle: fsn_dev/client/client.lua
- fsn_developer:getKeys: fsn_dev/client/client.lua
- fsn_developer:noClip:enabled: fsn_dev/client/cl_noclip.lua
- fsn_developer:printXYZ: fsn_dev/client/client.lua, fsn_dev/server/server.lua
- fsn_developer:sendXYZ: fsn_dev/client/client.lua
- fsn_developer:spawnVehicle: fsn_dev/client/client.lua
- fsn_doj:court:remandMe: fsn_doj/judges/client.lua
- fsn_doj:judge:spawnCar: fsn_doj/judges/client.lua
- fsn_doj:judge:toggleLock: fsn_teleporters/client.lua
- fsn_doormanager:doorLocked: fsn_doormanager/client.lua
- fsn_doormanager:doorUnlocked: fsn_doormanager/client.lua
- fsn_doormanager:lockDoor: fsn_doormanager/client.lua, fsn_doormanager/server.lua
- fsn_doormanager:request: fsn_doormanager/cl_doors.lua, fsn_doormanager/sv_doors.lua
- fsn_doormanager:requestDoors: fsn_doormanager/client.lua, fsn_doormanager/server.lua
- fsn_doormanager:sendDoors: fsn_doormanager/client.lua
- fsn_doormanager:toggle: fsn_doormanager/cl_doors.lua, fsn_doormanager/sv_doors.lua
- fsn_doormanager:unlockDoor: fsn_doormanager/client.lua, fsn_doormanager/server.lua
- fsn_emotecontrol:dice:roll: fsn_emotecontrol/client.lua
- fsn_emotecontrol:phone:call1: fsn_emotecontrol/client.lua
- fsn_emotecontrol:play: fsn_emotecontrol/client.lua, fsn_stripclub/client.lua
- fsn_emotecontrol:police:tablet: fsn_emotecontrol/client.lua, fsn_police/MDT/mdt_client.lua
- fsn_emotecontrol:police:ticket: fsn_emotecontrol/client.lua
- fsn_ems:911: fsn_ems/client.lua
- fsn_ems:911r: fsn_ems/client.lua
- fsn_ems:CAD:10-43: fsn_ems/client.lua
- fsn_ems:ad:stopBleeding: fsn_ems/cl_advanceddamage.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- fsn_ems:adamage:request: fsn_ems/cl_advanceddamage.lua
- fsn_ems:bed:health: fsn_ems/beds/client.lua, fsn_ems/beds/server.lua
- fsn_ems:bed:leave: fsn_ems/beds/server.lua
- fsn_ems:bed:occupy: fsn_ems/beds/client.lua, fsn_ems/beds/server.lua
- fsn_ems:bed:restraintoggle: fsn_ems/beds/client.lua, fsn_ems/beds/server.lua
- fsn_ems:bed:update: fsn_ems/beds/client.lua
- fsn_ems:carried:end: fsn_ems/cl_carrydead.lua
- fsn_ems:carried:start: fsn_ems/cl_carrydead.lua
- fsn_ems:carry:end: fsn_ems/cl_carrydead.lua, fsn_ems/sv_carrydead.lua, fsn_vehiclecontrol/trunk/client.lua
- fsn_ems:carry:start: fsn_ems/cl_carrydead.lua, fsn_ems/sv_carrydead.lua
- fsn_ems:killMe: fsn_ems/client.lua, fsn_needs/client.lua
- fsn_ems:offDuty: fsn_ems/client.lua, fsn_ems/server.lua
- fsn_ems:onDuty: fsn_ems/client.lua, fsn_ems/server.lua
- fsn_ems:requestUpdate: fsn_ems/client.lua, fsn_ems/server.lua
- fsn_ems:reviveMe: fsn_ems/beds/client.lua, fsn_ems/client.lua, fsn_needs/client.lua
- fsn_ems:reviveMe:force: fsn_ems/client.lua, fsn_spawnmanager/client.lua
- fsn_ems:set:WalkType: fsn_ems/cl_advanceddamage.lua
- fsn_ems:update: fsn_commands/server.lua, fsn_ems/client.lua, fsn_ems/server.lua
- fsn_ems:updateLevel: fsn_ems/client.lua
- fsn_evidence:collect: fsn_evidence/cl_evidence.lua, fsn_evidence/sv_evidence.lua
- fsn_evidence:destroy: fsn_evidence/cl_evidence.lua, fsn_evidence/sv_evidence.lua
- fsn_evidence:display: fsn_evidence/cl_evidence.lua
- fsn_evidence:drop:blood: fsn_ems/cl_advanceddamage.lua, fsn_evidence/sv_evidence.lua
- fsn_evidence:drop:casing: fsn_evidence/casings/cl_casings.lua, fsn_evidence/sv_evidence.lua
- fsn_evidence:ped:addState: fsn_crafting/client.lua, fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_evidence/ped/cl_ped.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua, fsn_police/dispatch.lua
- fsn_evidence:ped:update: fsn_evidence/ped/cl_ped.lua, fsn_evidence/ped/sv_ped.lua
- fsn_evidence:ped:updateDamage: fsn_ems/cl_advanceddamage.lua, fsn_evidence/ped/cl_ped.lua
- fsn_evidence:receive: fsn_evidence/cl_evidence.lua
- fsn_evidence:request: fsn_evidence/cl_evidence.lua, fsn_evidence/sv_evidence.lua
- fsn_evidence:weaponInfo: fsn_evidence/casings/cl_casings.lua, fsn_inventory/cl_inventory.lua
- fsn_fuel:set: fsn_commands/client.lua, fsn_vehiclecontrol/fuel/client.lua
- fsn_fuel:update: fsn_commands/client.lua, fsn_dev/client/client.lua, fsn_jobs/delivery/client.lua, fsn_jobs/garbage/client.lua, fsn_jobs/mechanic/client.lua, fsn_jobs/taxi/client.lua, fsn_jobs/tow/client.lua, fsn_jobs/trucker/client.lua, fsn_vehiclecontrol/fuel/client.lua, fsn_vehiclecontrol/fuel/server.lua
- fsn_gangs:garage:enter: fsn_gangs/cl_gangs.lua, fsn_gangs/sv_gangs.lua
- fsn_gangs:hideout:enter: fsn_gangs/cl_gangs.lua, fsn_gangs/sv_gangs.lua
- fsn_gangs:hideout:leave: fsn_gangs/cl_gangs.lua, fsn_gangs/sv_gangs.lua
- fsn_gangs:inventory:request: fsn_gangs/sv_gangs.lua
- fsn_gangs:recieve: fsn_gangs/cl_gangs.lua
- fsn_gangs:request: fsn_gangs/cl_gangs.lua, fsn_gangs/sv_gangs.lua
- fsn_gangs:tryTakeOver: fsn_gangs/cl_gangs.lua, fsn_gangs/sv_gangs.lua
- fsn_garages:vehicle:update: fsn_cargarage/client.lua, fsn_cargarage/server.lua
- fsn_hungerandthirst:pause: fsn_jail/client.lua, fsn_needs/client.lua
- fsn_hungerandthirst:unpause: fsn_jail/client.lua, fsn_needs/client.lua
- fsn_inventory:apt:recieve: fsn_apartments/client.lua, fsn_inventory/cl_inventory.lua
- fsn_inventory:buyItem: fsn_inventory/_old/client.lua, fsn_main/initial/client.lua
- fsn_inventory:database:update: fsn_inventory/_old/client.lua, fsn_inventory/cl_inventory.lua, fsn_main/initial/server.lua
- fsn_inventory:drops:collect: fsn_inventory_dropping/cl_dropping.lua, fsn_inventory_dropping/sv_dropping.lua
- fsn_inventory:drops:drop: fsn_inventory/cl_inventory.lua, fsn_inventory_dropping/sv_dropping.lua
- fsn_inventory:drops:request: fsn_inventory_dropping/cl_dropping.lua, fsn_inventory_dropping/sv_dropping.lua
- fsn_inventory:drops:send: fsn_inventory_dropping/cl_dropping.lua
- fsn_inventory:empty: fsn_criminalmisc/weaponinfo/client.lua, fsn_inventory/_old/client.lua
- fsn_inventory:floor:update: fsn_inventory/_old/client.lua
- fsn_inventory:gasDoorunlock: fsn_jewellerystore/client.lua, fsn_jewellerystore/server.lua
- fsn_inventory:gui:display: fsn_inventory/cl_inventory.lua
- fsn_inventory:init: fsn_inventory/_old/client.lua
- fsn_inventory:initChar: fsn_inventory/_old/client.lua, fsn_needs/client.lua, fsn_spawnmanager/client.lua
- fsn_inventory:item:add: fsn_bankrobbery/client.lua, fsn_bankrobbery/trucks.lua, fsn_crafting/client.lua, fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/lockpicking/client.lua, fsn_dev/server/server.lua, fsn_inventory/_item_misc/burger_store.lua, fsn_inventory/_old/_item_misc/_drug_selling.lua, fsn_inventory/_old/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_inventory.lua, fsn_inventory/cl_uses.lua, fsn_inventory/sv_inventory.lua, fsn_jewellerystore/client.lua, fsn_jobs/hunting/client.lua, fsn_jobs/scrap/client.lua, fsn_main/initial/client.lua, fsn_store/client.lua, fsn_vehiclecontrol/holdup/client.lua
- fsn_inventory:item:drop: fsn_inventory/_old/client.lua
- fsn_inventory:item:dropped: fsn_inventory/_old/client.lua, fsn_inventory/_old/server.lua
- fsn_inventory:item:give: fsn_inventory/_old/client.lua
- fsn_inventory:item:take: fsn_bankrobbery/client.lua, fsn_commands/client.lua, fsn_crafting/client.lua, fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/lockpicking/client.lua, fsn_criminalmisc/pawnstore/cl_pawnstore.lua, fsn_criminalmisc/robbing/cl_houses.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_inventory/_item_misc/burger_store.lua, fsn_inventory/_item_misc/dm_laundering.lua, fsn_inventory/_old/_item_misc/_drug_selling.lua, fsn_inventory/_old/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_inventory.lua, fsn_inventory/cl_uses.lua, fsn_jobs/hunting/client.lua, fsn_needs/hud.lua, fsn_vehiclecontrol/damage/client.lua
- fsn_inventory:item:use: fsn_inventory/_old/client.lua
- fsn_inventory:itemhasdropped: fsn_inventory/_old/client.lua
- fsn_inventory:itempickup: fsn_inventory/_old/client.lua, fsn_inventory/_old/server.lua
- fsn_inventory:items:add: fsn_commands/client.lua, fsn_criminalmisc/robbing/cl_houses.lua, fsn_inventory/_item_misc/cl_breather.lua, fsn_inventory/cl_inventory.lua, fsn_jobs/scrap/client.lua, fsn_police/client.lua
- fsn_inventory:items:addPreset: fsn_criminalmisc/robbing/cl_houses.lua, fsn_inventory/cl_inventory.lua
- fsn_inventory:items:emptyinv: fsn_ems/client.lua, fsn_inventory/cl_inventory.lua
- fsn_inventory:locker:empty: fsn_inventory/pd_locker/cl_locker.lua, fsn_inventory/pd_locker/sv_locker.lua
- fsn_inventory:locker:request: fsn_inventory/pd_locker/cl_locker.lua, fsn_inventory/pd_locker/sv_locker.lua
- fsn_inventory:locker:save: fsn_inventory/cl_inventory.lua, fsn_inventory/pd_locker/sv_locker.lua
- fsn_inventory:me:update: fsn_inventory/cl_inventory.lua
- fsn_inventory:pd_locker:recieve: fsn_inventory/cl_inventory.lua
- fsn_inventory:ply:done: fsn_inventory/cl_inventory.lua
- fsn_inventory:ply:finished: fsn_inventory/cl_inventory.lua, fsn_inventory/sv_inventory.lua
- fsn_inventory:ply:recieve: fsn_inventory/cl_inventory.lua
- fsn_inventory:ply:request: fsn_inventory/cl_inventory.lua
- fsn_inventory:ply:update: fsn_inventory/cl_inventory.lua, fsn_inventory/sv_inventory.lua
- fsn_inventory:police_armory:recieve: fsn_inventory/cl_inventory.lua
- fsn_inventory:prebuy: fsn_inventory/_old/client.lua
- fsn_inventory:prop:recieve: fsn_inventory/cl_inventory.lua, fsn_properties/cl_properties.lua
- fsn_inventory:rebreather:use: fsn_inventory/_item_misc/cl_breather.lua, fsn_inventory/cl_uses.lua
- fsn_inventory:recieveItems: fsn_inventory/cl_presets.lua
- fsn_inventory:removedropped: fsn_inventory/_old/client.lua
- fsn_inventory:sendItems: fsn_inventory/cl_presets.lua, fsn_inventory/sv_presets.lua
- fsn_inventory:sendItemsToArmory: fsn_inventory/sv_presets.lua, fsn_police/armory/sv_armory.lua
- fsn_inventory:sendItemsToStore: fsn_inventory/sv_presets.lua, fsn_store/server.lua
- fsn_inventory:store:recieve: fsn_inventory/cl_inventory.lua
- fsn_inventory:store_gun:recieve: fsn_inventory/cl_inventory.lua
- fsn_inventory:sys:request: fsn_criminalmisc/robbing/client.lua, fsn_inventory/sv_inventory.lua
- fsn_inventory:sys:send: fsn_inventory/cl_inventory.lua, fsn_inventory/sv_inventory.lua
- fsn_inventory:update: fsn_inventory/_old/client.lua
- fsn_inventory:use:drink: fsn_ems/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua, fsn_needs/client.lua, fsn_needs/vending.lua
- fsn_inventory:use:food: fsn_ems/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua, fsn_needs/client.lua
- fsn_inventory:useAmmo: fsn_inventory/cl_inventory.lua, fsn_inventory/cl_uses.lua
- fsn_inventory:useArmor: fsn_inventory/cl_uses.lua, fsn_needs/hud.lua
- fsn_inventory:veh:finished: fsn_inventory/cl_inventory.lua, fsn_inventory/sv_vehicles.lua
- fsn_inventory:veh:glovebox: fsn_inventory/cl_vehicles.lua
- fsn_inventory:veh:glovebox:recieve: fsn_inventory/cl_inventory.lua
- fsn_inventory:veh:request: fsn_inventory/cl_vehicles.lua, fsn_inventory/sv_vehicles.lua, fsn_vehiclecontrol/trunk/client.lua
- fsn_inventory:veh:trunk:recieve: fsn_inventory/cl_inventory.lua
- fsn_inventory:veh:update: fsn_inventory/cl_inventory.lua, fsn_inventory/sv_vehicles.lua
- fsn_jail:init: fsn_jail/client.lua, fsn_spawnmanager/client.lua
- fsn_jail:releaseme: fsn_jail/client.lua
- fsn_jail:sendme: fsn_jail/client.lua
- fsn_jail:sendsuspect: fsn_commands/server.lua, fsn_doj/judges/server.lua, fsn_jail/server.lua, fsn_police/MDT/mdt_client.lua
- fsn_jail:spawn: fsn_jail/client.lua, fsn_jail/server.lua
- fsn_jail:spawn:recieve: fsn_jail/client.lua
- fsn_jail:update:database: fsn_jail/client.lua, fsn_jail/server.lua
- fsn_jewellerystore:case:rob: fsn_jewellerystore/client.lua, fsn_jewellerystore/server.lua
- fsn_jewellerystore:case:startrob: fsn_jewellerystore/client.lua
- fsn_jewellerystore:cases:request: fsn_jewellerystore/server.lua
- fsn_jewellerystore:cases:update: fsn_jewellerystore/client.lua
- fsn_jewellerystore:doors:Lock: fsn_jewellerystore/server.lua
- fsn_jewellerystore:doors:State: fsn_jewellerystore/client.lua
- fsn_jewellerystore:doors:toggle: fsn_jewellerystore/client.lua
- fsn_jewellerystore:gasDoor:toggle: fsn_jewellerystore/client.lua
- fsn_jobs:ems:request: fsn_ems/client.lua
- fsn_jobs:mechanic:toggle: fsn_jobs/mechanic/client.lua, fsn_jobs/mechanic/server.lua
- fsn_jobs:mechanic:toggleduty: fsn_jobs/mechanic/client.lua
- fsn_jobs:news:role:Set: fsn_jobs/news/client.lua
- fsn_jobs:paycheck: fsn_jobs/client.lua
- fsn_jobs:quit: fsn_jobs/client.lua
- fsn_jobs:taxi:accepted: fsn_jobs/taxi/client.lua
- fsn_jobs:taxi:request: fsn_jobs/taxi/client.lua
- fsn_jobs:tow:mark: fsn_commands/server.lua, fsn_jobs/tow/server.lua
- fsn_jobs:tow:marked: fsn_jobs/tow/client.lua
- fsn_jobs:tow:request: fsn_jobs/tow/client.lua
- fsn_jobs:whitelist:access:add: fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:add: fsn_jobs/whitelists/client.lua, fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:clock:in: fsn_jobs/whitelists/client.lua, fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:clock:out: fsn_jobs/whitelists/client.lua, fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:remove: fsn_jobs/whitelists/client.lua, fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:request: fsn_jobs/whitelists/client.lua, fsn_jobs/whitelists/server.lua
- fsn_jobs:whitelist:update: fsn_jobs/whitelists/client.lua
- fsn_licenses:chat: fsn_licenses/client.lua, fsn_licenses/server.lua
- fsn_licenses:check: fsn_licenses/client.lua, fsn_licenses/server.lua
- fsn_licenses:display: fsn_licenses/client.lua, fsn_menu/main_client.lua
- fsn_licenses:giveID: fsn_inventory/cl_inventory.lua, fsn_licenses/cl_desk.lua
- fsn_licenses:id:display: fsn_inventory/cl_uses.lua, fsn_inventory/sv_inventory.lua
- fsn_licenses:id:request: fsn_licenses/cl_desk.lua, fsn_licenses/sv_desk.lua
- fsn_licenses:infraction: fsn_licenses/client.lua
- fsn_licenses:police:give: fsn_licenses/client.lua, fsn_store/client.lua, fsn_store_guns/client.lua
- fsn_licenses:setinfractions: fsn_licenses/client.lua
- fsn_licenses:showid: fsn_licenses/client.lua, fsn_menu/main_client.lua
- fsn_licenses:update: fsn_licenses/client.lua, fsn_licenses/server.lua
- fsn_lscustoms:check: fsn_main/money/client.lua
- fsn_lscustoms:check2: fsn_main/money/client.lua
- fsn_lscustoms:check3: fsn_main/money/client.lua
- fsn_lscustoms:receive: fsn_main/money/client.lua
- fsn_lscustoms:receive2: fsn_main/money/client.lua
- fsn_lscustoms:receive3: fsn_main/money/client.lua
- fsn_main:blip:add: fsn_ems/client.lua, fsn_jobs/tow/client.lua, fsn_police/dispatch.lua, fsn_police/dispatch/client.lua
- fsn_main:blip:clear: fsn_police/dispatch/client.lua
- fsn_main:charMenu: fsn_main/initial/client.lua, fsn_main/playermanager/client.lua
- fsn_main:character: fsn_bankrobbery/client.lua, fsn_cargarage/client.lua, fsn_commands/client.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_ems/client.lua, fsn_inventory/cl_inventory.lua, fsn_jobs/taxi/client.lua, fsn_licenses/cl_desk.lua, fsn_licenses/client.lua, fsn_main/initial/client.lua, fsn_phones/cl_phone.lua, fsn_properties/cl_properties.lua, fsn_spawnmanager/client.lua
- fsn_main:characterSaving: fsn_criminalmisc/weaponinfo/client.lua, fsn_inventory/cl_inventory.lua, fsn_main/initial/client.lua
- fsn_main:createCharacter: fsn_main/initial/client.lua, fsn_main/initial/server.lua
- fsn_main:debug_toggle: fsn_main/debug/sh_debug.lua, fsn_main/debug/sh_scheduler.lua
- fsn_main:displayBankandMoney: fsn_bank/client.lua, fsn_main/money/client.lua
- fsn_main:getCharacter: fsn_main/initial/client.lua, fsn_main/initial/server.lua
- fsn_main:gui:bank:change: fsn_main/hud/client.lua, fsn_main/money/client.lua
- fsn_main:gui:both:display: fsn_main/hud/client.lua, fsn_main/money/client.lua
- fsn_main:gui:money:change: fsn_main/hud/client.lua, fsn_main/money/client.lua
- fsn_main:initiateCharacter: fsn_main/initial/client.lua
- fsn_main:logging:addLog: fsn_bank/client.lua, fsn_commands/server.lua, fsn_criminalmisc/weaponinfo/server.lua, fsn_errorcontrol/client.lua, fsn_inventory/_old/server.lua, fsn_inventory/cl_inventory.lua, fsn_main/misc/logging.lua, fsn_main/money/server.lua, fsn_newchat/sv_chat.lua, fsn_police/armory/sv_armory.lua, fsn_store/server.lua, fsn_store_guns/server.lua
- fsn_main:money:bank:Add: fsn_bankrobbery/server.lua, fsn_main/money/client.lua, fsn_main/money/server.lua
- fsn_main:money:bank:Minus: fsn_bankrobbery/server.lua, fsn_main/money/client.lua, fsn_main/money/server.lua
- fsn_main:money:bank:Set: fsn_main/money/client.lua, fsn_main/money/server.lua
- fsn_main:money:initChar: fsn_main/initial/server.lua, fsn_main/money/server.lua
- fsn_main:money:update: fsn_main/money/client.lua
- fsn_main:money:updateSilent: fsn_main/money/client.lua
- fsn_main:money:wallet:Add: fsn_main/money/client.lua, fsn_main/money/server.lua
- fsn_main:money:wallet:GiveCash: fsn_commands/server.lua, fsn_main/money/server.lua
- fsn_main:money:wallet:Minus: fsn_main/money/client.lua, fsn_main/money/server.lua
- fsn_main:money:wallet:Set: fsn_commands/server.lua, fsn_main/money/client.lua, fsn_main/money/server.lua
- fsn_main:requestCharacters: fsn_main/initial/client.lua, fsn_main/initial/server.lua
- fsn_main:saveCharacter: fsn_characterdetails/tattoos/client.lua, fsn_main/initial/client.lua, fsn_main/initial/server.lua
- fsn_main:sendCharacters: fsn_main/initial/client.lua
- fsn_main:update:myCharacter: fsn_main/initial/server.lua
- fsn_main:updateCharNumber: fsn_main/initial/server.lua, fsn_phones/sv_phone.lua
- fsn_main:updateCharacters: fsn_commands/server.lua, fsn_jail/server.lua, fsn_main/initial/server.lua, fsn_main/sv_utils.lua, fsn_playerlist/client.lua
- fsn_main:updateMoneyStore: fsn_main/money/server.lua, fsn_main/sv_utils.lua
- fsn_main:validatePlayer: fsn_main/initial/server.lua, fsn_main/playermanager/server.lua
- fsn_menu:requestInventory: fsn_inventory/_old/client.lua
- fsn_needs:stress:add: fsn_bankrobbery/cl_frontdesks.lua, fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/robbing/cl_houses.lua, fsn_needs/client.lua
- fsn_needs:stress:remove: fsn_activities/yoga/client.lua, fsn_criminalmisc/drugs/_effects/client.lua, fsn_ems/client.lua, fsn_needs/client.lua
- fsn_notify:displayNotification: fsn_admin/client/client.lua, fsn_admin/server.lua, fsn_apartments/client.lua, fsn_bank/client.lua, fsn_bankrobbery/client.lua, fsn_bankrobbery/trucks.lua, fsn_bikerental/client.lua, fsn_boatshop/cl_menu.lua, fsn_cargarage/client.lua, fsn_carstore/cl_menu.lua, fsn_commands/client.lua, fsn_crafting/client.lua, fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/handcuffs/client.lua, fsn_criminalmisc/lockpicking/client.lua, fsn_criminalmisc/streetracing/client.lua, fsn_criminalmisc/weaponinfo/client.lua, fsn_customs/lscustoms.lua, fsn_dev/client/client.lua, fsn_doj/judges/client.lua, fsn_ems/beds/client.lua, fsn_ems/client.lua, fsn_inventory/_item_misc/burger_store.lua, fsn_inventory/_item_misc/dm_laundering.lua, fsn_inventory/_old/_item_misc/_drug_selling.lua, fsn_inventory/_old/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua, fsn_inventory_dropping/cl_dropping.lua, fsn_jail/client.lua, fsn_jobs/client.lua, fsn_jobs/delivery/client.lua, fsn_jobs/garbage/client.lua, fsn_jobs/hunting/client.lua, fsn_jobs/mechanic/client.lua, fsn_jobs/mechanic/mechmenu.lua, fsn_jobs/news/client.lua, fsn_jobs/taxi/client.lua, fsn_jobs/trucker/client.lua, fsn_licenses/client.lua, fsn_main/initial/client.lua, fsn_main/money/client.lua, fsn_menu/main_client.lua, fsn_needs/client.lua, fsn_notify/cl_notify.lua, fsn_notify/server.lua, fsn_phones/cl_phone.lua, fsn_phones/darkweb/cl_order.lua, fsn_police/K9/client.lua, fsn_police/MDT/mdt_client.lua, fsn_police/client.lua, fsn_police/dispatch.lua, fsn_police/dispatch/client.lua, fsn_shootingrange/client.lua, fsn_store/client.lua, fsn_store_guns/client.lua, fsn_stripclub/client.lua, fsn_teleporters/client.lua, fsn_vehiclecontrol/carwash/client.lua, fsn_vehiclecontrol/client.lua, fsn_vehiclecontrol/damage/client.lua, fsn_vehiclecontrol/engine/client.lua, fsn_vehiclecontrol/fuel/client.lua, fsn_vehiclecontrol/holdup/client.lua, fsn_weaponcontrol/client.lua
- fsn_odometer:addMileage: fsn_vehiclecontrol/odometer/client.lua, fsn_vehiclecontrol/odometer/server.lua
- fsn_odometer:getMileage: fsn_vehiclecontrol/odometer/server.lua
- fsn_odometer:resetMileage: fsn_vehiclecontrol/odometer/server.lua
- fsn_odometer:setMileage: fsn_vehiclecontrol/odometer/server.lua
- fsn_phone:recieveMessage: fsn_bankrobbery/trucks.lua, fsn_criminalmisc/drugs/_streetselling/client.lua
- fsn_phone:togglePhone: fsn_inventory/_old/items.lua
- fsn_phones:GUI:notification: fsn_phones/cl_phone.lua
- fsn_phones:SYS:addCall: fsn_phones/cl_phone.lua
- fsn_phones:SYS:addTransaction: fsn_bank/client.lua, fsn_phones/cl_phone.lua
- fsn_phones:SYS:newNumber: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:SYS:receiveGarage: fsn_phones/cl_phone.lua
- fsn_phones:SYS:recieve:details: fsn_phones/cl_phone.lua
- fsn_phones:SYS:request:details: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:SYS:requestGarage: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:SYS:sendTweet: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:SYS:set:details: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:SYS:updateAdverts: fsn_phones/cl_phone.lua
- fsn_phones:SYS:updateNumber: fsn_phones/cl_phone.lua
- fsn_phones:USE:Email: fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_phones/cl_phone.lua
- fsn_phones:USE:Message: fsn_phones/cl_phone.lua
- fsn_phones:USE:Phone: fsn_phones/cl_phone.lua
- fsn_phones:USE:Tweet: fsn_phones/cl_phone.lua
- fsn_phones:USE:darkweb:order: fsn_phones/darkweb/cl_order.lua
- fsn_phones:USE:requestAdverts: fsn_phones/sv_phone.lua
- fsn_phones:USE:sendAdvert: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:USE:sendMessage: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:UTIL:chat: fsn_phones/cl_phone.lua, fsn_phones/sv_phone.lua
- fsn_phones:UTIL:displayNumber: fsn_phones/cl_phone.lua
- fsn_police:911: fsn_police/client.lua
- fsn_police:911r: fsn_police/client.lua
- fsn_police:CAD:10-43: fsn_ems/client.lua
- fsn_police:GetInVehicle: fsn_menu/main_client.lua, fsn_police/K9/client.lua
- fsn_police:MDT:receivewarrants: fsn_police/MDT/mdt_client.lua
- fsn_police:MDT:requestwarrants: fsn_police/MDT/mdt_client.lua, fsn_police/MDT/mdt_server.lua
- fsn_police:MDT:toggle: fsn_police/MDT/mdt_client.lua
- fsn_police:MDT:vehicledetails: fsn_police/client.lua
- fsn_police:MDT:warrant: fsn_police/MDT/mdt_client.lua, fsn_police/MDT/mdt_server.lua
- fsn_police:MDTremovewarrant: fsn_police/MDT/mdt_client.lua, fsn_police/MDT/mdt_server.lua
- fsn_police:Sit: fsn_menu/main_client.lua, fsn_police/K9/client.lua
- fsn_police:ToggleFollow: fsn_menu/main_client.lua
- fsn_police:ToggleK9: fsn_menu/main_client.lua, fsn_police/K9/client.lua
- fsn_police:armory:boughtOne: fsn_inventory/cl_inventory.lua, fsn_police/armory/sv_armory.lua
- fsn_police:armory:closedArmory: fsn_inventory/cl_inventory.lua, fsn_police/armory/sv_armory.lua
- fsn_police:armory:recieveItemsForArmory: fsn_inventory/sv_presets.lua, fsn_police/armory/sv_armory.lua
- fsn_police:armory:request: fsn_inventory/cl_inventory.lua, fsn_police/armory/cl_armory.lua, fsn_police/armory/sv_armory.lua
- fsn_police:chat:ticket: fsn_main/initial/server.lua, fsn_police/MDT/mdt_client.lua
- fsn_police:command:duty: fsn_police/client.lua
- fsn_police:cuffs:requestCuff: fsn_police/client.lua, fsn_police/server.lua
- fsn_police:cuffs:requestunCuff: fsn_police/client.lua, fsn_police/server.lua
- fsn_police:cuffs:startCuffed: fsn_police/client.lua
- fsn_police:cuffs:startCuffing: fsn_police/client.lua
- fsn_police:cuffs:startunCuffed: fsn_police/client.lua
- fsn_police:cuffs:startunCuffing: fsn_police/client.lua
- fsn_police:cuffs:toggleEscort: fsn_police/client.lua, fsn_police/server.lua
- fsn_police:cuffs:toggleHard: fsn_police/client.lua, fsn_police/server.lua
- fsn_police:database:CPIC: fsn_police/MDT/mdt_client.lua, fsn_police/MDT/mdt_server.lua
- fsn_police:database:CPIC:search: fsn_commands/client.lua, fsn_police/MDT/mdt_server.lua
- fsn_police:database:CPIC:search:result: fsn_police/MDT/mdt_client.lua
- fsn_police:dispatch: fsn_bankrobbery/client.lua, fsn_criminalmisc/drugs/_streetselling/client.lua, fsn_criminalmisc/lockpicking/client.lua, fsn_criminalmisc/robbing/cl_houses.lua, fsn_ems/client.lua, fsn_inventory/_old/_item_misc/_drug_selling.lua, fsn_jewellerystore/client.lua, fsn_police/dispatch.lua, fsn_police/server.lua, fsn_store/client.lua, fsn_vehiclecontrol/client.lua, fsn_vehiclecontrol/damage/cl_crashes.lua, fsn_vehiclecontrol/holdup/client.lua, fsn_vehiclecontrol/speedcameras/client.lua
- fsn_police:dispatch:toggle: fsn_police/dispatch.lua
- fsn_police:dispatchcall: fsn_ems/client.lua, fsn_police/dispatch.lua
- fsn_police:init: fsn_doormanager/cl_doors.lua, fsn_doormanager/client.lua, fsn_police/client.lua, fsn_spawnmanager/client.lua
- fsn_police:k9:search:person:end: fsn_police/K9/client.lua, fsn_police/K9/server.lua
- fsn_police:k9:search:person:finish: fsn_police/K9/client.lua
- fsn_police:k9:search:person:me: fsn_police/K9/client.lua
- fsn_police:offDuty: fsn_police/client.lua, fsn_police/server.lua
- fsn_police:onDuty: fsn_police/client.lua, fsn_police/server.lua
- fsn_police:pd:toggleDrag: fsn_police/client.lua
- fsn_police:ply:toggleDrag: fsn_police/client.lua
- fsn_police:putMeInVeh: fsn_police/client.lua
- fsn_police:radar:toggle: fsn_police/radar/client.lua
- fsn_police:requestUpdate: fsn_police/client.lua, fsn_police/server.lua
- fsn_police:runplate: fsn_commands/server.lua, fsn_police/server.lua
- fsn_police:runplate::target: fsn_commands/client.lua, fsn_police/server.lua
- fsn_police:runplate:target: fsn_commands/client.lua
- fsn_police:search:end:inventory: fsn_inventory/_old/client.lua, fsn_police/server.lua
- fsn_police:search:end:money: fsn_main/money/client.lua, fsn_police/server.lua
- fsn_police:search:end:weapons: fsn_criminalmisc/weaponinfo/client.lua, fsn_police/server.lua
- fsn_police:search:start:inventory: fsn_inventory/_old/client.lua
- fsn_police:search:start:money: fsn_main/money/client.lua
- fsn_police:search:start:weapons: fsn_criminalmisc/weaponinfo/client.lua
- fsn_police:search:strip: fsn_criminalmisc/weaponinfo/client.lua
- fsn_police:ticket: fsn_commands/server.lua, fsn_doj/judges/server.lua, fsn_police/MDT/mdt_client.lua, fsn_police/server.lua
- fsn_police:toggleHandcuffs: fsn_police/server.lua
- fsn_police:update: fsn_commands/server.lua, fsn_doormanager/cl_doors.lua, fsn_police/client.lua, fsn_police/server.lua
- fsn_police:updateLevel: fsn_police/client.lua
- fsn_properties:access: fsn_properties/cl_properties.lua, fsn_properties/sv_properties.lua
- fsn_properties:buy: fsn_properties/cl_properties.lua, fsn_properties/sv_properties.lua, fsn_storagelockers/client.lua
- fsn_properties:inv:closed: fsn_inventory/cl_inventory.lua, fsn_properties/cl_properties.lua
- fsn_properties:inv:update: fsn_inventory/cl_inventory.lua, fsn_properties/cl_properties.lua
- fsn_properties:keys:give: fsn_properties/cl_manage.lua
- fsn_properties:leave: fsn_properties/cl_properties.lua, fsn_properties/sv_properties.lua
- fsn_properties:menu:access:allow: fsn_storagelockers/client.lua
- fsn_properties:menu:access:revoke: fsn_storagelockers/client.lua
- fsn_properties:menu:access:view: fsn_storagelockers/client.lua
- fsn_properties:menu:inventory:deposit: fsn_storagelockers/client.lua
- fsn_properties:menu:inventory:take: fsn_storagelockers/client.lua
- fsn_properties:menu:money:deposit: fsn_storagelockers/client.lua
- fsn_properties:menu:money:withdraw: fsn_storagelockers/client.lua
- fsn_properties:menu:police:breach: fsn_storagelockers/client.lua
- fsn_properties:menu:police:empty: fsn_storagelockers/client.lua
- fsn_properties:menu:police:search: fsn_storagelockers/client.lua
- fsn_properties:menu:police:seize: fsn_storagelockers/client.lua
- fsn_properties:menu:rent:check: fsn_storagelockers/client.lua
- fsn_properties:menu:rent:pay: fsn_storagelockers/client.lua
- fsn_properties:menu:robbery: fsn_storagelockers/client.lua
- fsn_properties:menu:weapon:deposit: fsn_storagelockers/client.lua
- fsn_properties:menu:weapon:take: fsn_storagelockers/client.lua
- fsn_properties:realator:clock: fsn_properties/sv_properties.lua
- fsn_properties:rent:check: fsn_properties/cl_properties.lua, fsn_properties/sv_properties.lua
- fsn_properties:rent:pay: fsn_properties/cl_properties.lua, fsn_properties/sv_properties.lua
- fsn_properties:request: fsn_properties/cl_properties.lua, fsn_properties/sv_properties.lua
- fsn_properties:requestKeys: fsn_properties/cl_properties.lua
- fsn_properties:updateXYZ: fsn_properties/cl_properties.lua
- fsn_spawnmanager:start: fsn_apartments/client.lua, fsn_main/initial/client.lua, fsn_spawnmanager/client.lua
- fsn_store:boughtOne: fsn_inventory/cl_inventory.lua, fsn_store/server.lua
- fsn_store:closedStore: fsn_inventory/cl_inventory.lua, fsn_store/server.lua
- fsn_store:recieveItemsForStore: fsn_inventory/sv_presets.lua, fsn_store/server.lua
- fsn_store:request: fsn_inventory/cl_inventory.lua, fsn_store/client.lua, fsn_store/server.lua
- fsn_store_guns:boughtOne: fsn_store_guns/server.lua
- fsn_store_guns:closedStore: fsn_store_guns/server.lua
- fsn_store_guns:request: fsn_store_guns/client.lua, fsn_store_guns/server.lua
- fsn_stripclub:client:update: fsn_stripclub/client.lua
- fsn_stripclub:server:claimBooth: fsn_stripclub/client.lua
- fsn_teleporters:teleport:coordinates: fsn_teleporters/client.lua
- fsn_teleporters:teleport:waypoint: fsn_teleporters/client.lua
- fsn_timeandweather:notify: fsn_timeandweather/client.lua
- fsn_timeandweather:requestSync: fsn_timeandweather/client.lua, fsn_timeandweather/server.lua
- fsn_timeandweather:updateTime: fsn_timeandweather/client.lua
- fsn_timeandweather:updateWeather: fsn_timeandweather/client.lua
- fsn_vehiclecontrol:damage:repair: fsn_vehiclecontrol/damage/client.lua
- fsn_vehiclecontrol:damage:repairkit: fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua, fsn_vehiclecontrol/damage/client.lua
- fsn_vehiclecontrol:flagged:add: fsn_vehiclecontrol/speedcameras/client.lua
- fsn_vehiclecontrol:getKeys: fsn_vehiclecontrol/engine/client.lua
- fsn_vehiclecontrol:giveKeys: fsn_menu/main_client.lua, fsn_vehiclecontrol/engine/client.lua
- fsn_vehiclecontrol:givekeys: fsn_vehiclecontrol/engine/client.lua, fsn_vehiclecontrol/keys/server.lua
- fsn_vehiclecontrol:keys:carjack: fsn_cargarage/client.lua, fsn_criminalmisc/lockpicking/client.lua, fsn_vehiclecontrol/engine/client.lua
- fsn_vehiclecontrol:trunk:forceIn: fsn_vehiclecontrol/trunk/client.lua, fsn_vehiclecontrol/trunk/server.lua
- fsn_vehiclecontrol:trunk:forceOut: fsn_ems/cl_carrydead.lua, fsn_vehiclecontrol/trunk/client.lua
- fsn_voicecontrol:call:answer: fsn_voicecontrol/client.lua, fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:decline: fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:end: fsn_voicecontrol/client.lua, fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:hold: fsn_voicecontrol/client.lua, fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:ring: fsn_voicecontrol/client.lua, fsn_voicecontrol/server.lua
- fsn_voicecontrol:call:unhold: fsn_voicecontrol/client.lua, fsn_voicecontrol/server.lua
- fsn_yoga:checkStress: fsn_activities/yoga/client.lua
- jCAD:tow: fsn_jobs/tow/client.lua
- jFarm:payme: fsn_jobs/farming/client.lua
- jTow:afford: fsn_jobs/tow/client.lua
- jTow:mark: fsn_jobs/tow/client.lua
- jTow:return: fsn_jobs/tow/client.lua
- jTow:spawn: fsn_jobs/tow/client.lua
- jTow:success: fsn_jobs/tow/client.lua
- mhacking:hide: fsn_bankrobbery/cl_frontdesks.lua
- mhacking:show: fsn_bankrobbery/cl_frontdesks.lua
- mhacking:start: fsn_bankrobbery/cl_frontdesks.lua
- mythic_hospital:client:FieldTreatBleed: fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:FieldTreatLimbs: fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:ReduceBleed: fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:RemoveBleed: fsn_ems/beds/client.lua, fsn_ems/cl_advanceddamage.lua, fsn_ems/client.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- mythic_hospital:client:ResetLimbs: fsn_ems/beds/client.lua, fsn_ems/cl_advanceddamage.lua, fsn_ems/client.lua
- mythic_hospital:client:SyncBleed: fsn_ems/cl_advanceddamage.lua
- mythic_hospital:client:UseAdrenaline: fsn_ems/cl_advanceddamage.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- mythic_hospital:client:UsePainKiller: fsn_ems/cl_advanceddamage.lua, fsn_inventory/_old/items.lua, fsn_inventory/cl_uses.lua
- mythic_hospital:server:SyncInjuries: fsn_ems/cl_advanceddamage.lua
- mythic_notify:client:SendAlert: fsn_gangs/cl_gangs.lua, fsn_spawnmanager/client.lua
- onClientResourceStart: fsn_customs/lscustoms.lua, fsn_jobs/mechanic/client.lua, fsn_newchat/cl_chat.lua
- onResourceStart: fsn_admin/server/server.lua, fsn_inventory/sv_presets.lua, fsn_main/misc/version.lua, fsn_police/armory/sv_armory.lua, fsn_store/server.lua
- onResourceStop: fsn_customanimations/client.lua
- onServerResourceStart: fsn_newchat/sv_chat.lua
- pNotify:SendNotification: fsn_ems/client.lua, fsn_inventory/_item_misc/dm_laundering.lua, fsn_jail/client.lua, fsn_jobs/farming/client.lua, fsn_jobs/tow/client.lua, fsn_notify/cl_notify.lua
- pNotify:SetQueueMax: fsn_notify/cl_notify.lua
- playerConnecting: fsn_main/banmanager/sv_bans.lua, fsn_main/misc/version.lua, fsn_main/playermanager/server.lua
- playerDropped: fsn_apartments/server.lua, fsn_ems/server.lua, fsn_main/initial/server.lua, fsn_main/playermanager/server.lua, fsn_main/sv_utils.lua, fsn_newchat/sv_chat.lua, fsn_phones/sv_phone.lua, fsn_police/armory/sv_armory.lua, fsn_police/server.lua, fsn_store/server.lua, fsn_store_guns/server.lua
- playerSpawned: fsn_carstore/cl_menu.lua, fsn_main/playermanager/client.lua, fsn_timeandweather/client.lua
- police:setAnimData: fsn_emotecontrol/walktypes/client.lua
- safe:success: fsn_bankrobbery/cl_safeanim.lua
- safecracking:loop: fsn_bankrobbery/cl_safeanim.lua
- safecracking:start: fsn_bankrobbery/cl_safeanim.lua
- spawnme: fsn_main/initial/client.lua, fsn_spawnmanager/client.lua
- tow:CAD:tow: fsn_jobs/tow/client.lua
- xgc-tuner:openTuner: fsn_inventory/cl_uses.lua
### Commands
- addmoney: fsn_dev/server/server.lua
- adminmenu: fsn_admin/server/server.lua
- amenu: fsn_admin/server/server.lua
- announce: fsn_admin/server/server.lua
- ban: fsn_admin/server/server.lua
- blackout: fsn_timeandweather/server.lua
- bring: fsn_admin/server/server.lua
- carryplayer: fsn_dev/server/server.lua
- ce: fsn_customanimations/client.lua
- debug: fsn_dev/server/server.lua
- dv: fsn_dev/server/server.lua
- evening: fsn_timeandweather/server.lua
- evi_clothing: fsn_evidence/__descriptions.lua
- fixveh: fsn_dev/server/server.lua
- freeze: fsn_admin/server/server.lua
- freezetime: fsn_timeandweather/server.lua
- freezeweather: fsn_timeandweather/server.lua
- fsn_debug: fsn_main/debug/sh_debug.lua
- getkeys: fsn_dev/server/server.lua
- giveitem: fsn_dev/server/server.lua
- goto: fsn_admin/server/server.lua
- insidedebug: fsn_dev/server/server.lua
- inv: fsn_dev/server/server.lua
- kick: fsn_admin/server/server.lua
- kill: fsn_dev/server/server.lua
- mdt: fsn_dev/server/server.lua
- morning: fsn_timeandweather/server.lua
- night: fsn_timeandweather/server.lua
- noclip: fsn_dev/server/server.lua
- noon: fsn_timeandweather/server.lua
- pdduty: fsn_dev/server/server.lua
- revive: fsn_dev/server/server.lua
- reviveplayer: fsn_dev/server/server.lua
- say: fsn_newchat/sv_chat.lua
- sc: fsn_admin/server/server.lua
- setinfractions: fsn_dev/server/server.lua
- softlog: fsn_dev/server/server.lua
- spawnveh: fsn_dev/server/server.lua
- testanimation: fsn_customanimations/client.lua
- time: fsn_timeandweather/server.lua
- tpc: fsn_dev/server/server.lua
- tpm: fsn_dev/server/server.lua
- tuner: fsn_dev/server/server.lua
- vehinspect: fsn_jobs/mechanic/client.lua
- vehrepair: fsn_jobs/mechanic/client.lua
- weather: fsn_timeandweather/server.lua
- xyz: fsn_dev/server/server.lua
### Exports
- sub_frame_time: fsn_main/debug/cl_subframetime.js
### NUI Callbacks
- booking-submit-now: fsn_police/MDT/mdt_client.lua
- booking-submit-warrant: fsn_police/MDT/mdt_client.lua
- camToLoc: fsn_spawnmanager/client.lua
- chatResult: fsn_newchat/cl_chat.lua
- closeMDT: fsn_police/MDT/mdt_client.lua
- createCharacter: fsn_main/initial/client.lua
- depositMoney: fsn_bank/client.lua
- dropSlot: fsn_inventory/cl_inventory.lua
- escape: fsn_apartments/client.lua, fsn_bikerental/client.lua, fsn_menu/main_client.lua
- loaded: fsn_newchat/cl_chat.lua
- mdt-remove-warrant: fsn_police/MDT/mdt_client.lua
- mdt-request-warrants: fsn_police/MDT/mdt_client.lua
- messageactive: fsn_phones/cl_phone.lua
- messageinactive: fsn_phones/cl_phone.lua
- rentBike: fsn_bikerental/client.lua
- setWaypoint: fsn_police/MDT/mdt_client.lua
- spawnAtLoc: fsn_spawnmanager/client.lua
- spawnCharacter: fsn_main/initial/client.lua
- toggleGUI: fsn_bank/client.lua
- transferMoney: fsn_bank/client.lua
- useSlot: fsn_inventory/cl_inventory.lua
- withdrawMoney: fsn_bank/client.lua
### DB Usage
- fsn_criminalmisc/fxmanifest.lua: MySQL.lua
- fsn_weaponcontrol/fxmanifest.lua: MySQL.lua
- fsn_store/fxmanifest.lua: MySQL.lua
- fsn_doj/fxmanifest.lua: MySQL.lua
- fsn_doj/judges/server.lua: MySQL.Async
- fsn_entfinder/fxmanifest.lua: MySQL.lua
- fsn_carstore/fxmanifest.lua: MySQL.lua
- fsn_bikerental/fxmanifest.lua: MySQL.lua
- fsn_activities/fxmanifest.lua: MySQL.lua
- fsn_handling/fxmanifest.lua: MySQL.lua
- fsn_clothing/fxmanifest.lua: MySQL.lua
- fsn_bankrobbery/fxmanifest.lua: MySQL.lua
- fsn_steamlogin/fxmanifest.lua: MySQL.lua
- fsn_voicecontrol/fxmanifest.lua: MySQL.lua
- fsn_inventory_dropping/fxmanifest.lua: MySQL.lua
- fsn_doormanager/fxmanifest.lua: MySQL.lua
- fsn_main/fxmanifest.lua: MySQL.lua
- fsn_main/misc/db.lua: MySQL.Async, MySQL.ready
- fsn_main/money/server.lua: MySQL.Sync
- fsn_main/initial/server.lua: MySQL.Async, MySQL.Sync
- fsn_main/banmanager/sv_bans.lua: MySQL.Sync
- fsn_main/playermanager/server.lua: MySQL.Async, MySQL.Sync, MySQL.ready
- fsn_police/server.lua: MySQL.Async
- fsn_police/fxmanifest.lua: MySQL.lua
- fsn_police/MDT/mdt_server.lua: MySQL.Async
- fsn_gangs/fxmanifest.lua: MySQL.lua
- fsn_storagelockers/server.lua: MySQL.Async, MySQL.ready
- fsn_storagelockers/fxmanifest.lua: MySQL.lua
- fsn_admin/server.lua: MySQL.Async
- fsn_admin/oldresource.lua: MySQL.lua
- fsn_admin/fxmanifest.lua: MySQL.lua
- fsn_admin/server/server.lua: MySQL.Async
- fsn_evidence/fxmanifest.lua: MySQL.lua
- fsn_commands/server.lua: MySQL.Sync
- fsn_commands/fxmanifest.lua: MySQL.lua
- fsn_apartments/server.lua: MySQL.Sync
- fsn_apartments/fxmanifest.lua: MySQL.lua
- fsn_jewellerystore/fxmanifest.lua: MySQL.lua
- fsn_dev/oldresource.lua: MySQL.lua
- fsn_dev/fxmanifest.lua: MySQL.lua
- fsn_errorcontrol/fxmanifest.lua: MySQL.lua
- fsn_customanimations/fxmanifest.lua: MySQL.lua
- fsn_timeandweather/fxmanifest.lua: MySQL.lua
- fsn_emotecontrol/fxmanifest.lua: MySQL.lua
- fsn_phones/sv_phone.lua: MySQL.Async
- fsn_phones/fxmanifest.lua: MySQL.lua
- fsn_bennys/fxmanifest.lua: MySQL.lua
- fsn_properties/sv_properties.lua: MySQL.Async, MySQL.Sync, MySQL.ready
- fsn_properties/fxmanifest.lua: MySQL.lua
- fsn_spawnmanager/fxmanifest.lua: MySQL.lua
- fsn_store_guns/fxmanifest.lua: MySQL.lua
- fsn_jobs/fxmanifest.lua: MySQL.lua
- fsn_jobs/whitelists/server.lua: MySQL.Async, MySQL.ready
- fsn_vehiclecontrol/fxmanifest.lua: MySQL.lua
- fsn_vehiclecontrol/odometer/server.lua: MySQL.Async, MySQL.ready
- fsn_notify/fxmanifest.lua: MySQL.lua
- fsn_priority/server.lua: MySQL.Async, MySQL.ready
- fsn_priority/administration.lua: MySQL.Async, MySQL.Sync
- fsn_priority/fxmanifest.lua: MySQL.lua
- fsn_licenses/server.lua: MySQL.Async
- fsn_licenses/fxmanifest.lua: MySQL.lua
- fsn_cargarage/server.lua: MySQL.Async, MySQL.Sync
- fsn_cargarage/fxmanifest.lua: MySQL.lua
- fsn_ems/fxmanifest.lua: MySQL.lua
- fsn_customs/fxmanifest.lua: MySQL.lua
- fsn_shootingrange/fxmanifest.lua: MySQL.lua
- fsn_builders/fxmanifest.lua: MySQL.lua
- fsn_boatshop/fxmanifest.lua: MySQL.lua
- fsn_crafting/fxmanifest.lua: MySQL.lua
- fsn_bank/server.lua: MySQL.Sync
- fsn_bank/fxmanifest.lua: MySQL.lua
- fsn_stripclub/fxmanifest.lua: MySQL.lua
- fsn_characterdetails/fxmanifest.lua: MySQL.lua
- fsn_progress/fxmanifest.lua: MySQL.lua
- fsn_teleporters/fxmanifest.lua: MySQL.lua
- fsn_inventory/fxmanifest.lua: MySQL.lua
- fsn_jail/server.lua: MySQL.Async
- fsn_jail/fxmanifest.lua: MySQL.lua

## Gaps & Inferences
No unscanned files remain; descriptions are derived from first in-file comment and detected symbols.

DOCS COMPLETE