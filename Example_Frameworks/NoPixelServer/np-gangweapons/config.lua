--[[
    -- Type: Shared
    -- Name: config.lua
    -- Use: Configuration for gang weapon shop
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]

Config = {}

Config.Shop = {
    location = vector3(1397.3756, 1163.9972, 114.3337),
    drawDistance = 2.0
}

Config.Categories = {
    {
        name = 'Melee',
        label = 'Melee Weapons',
        items = {
            { label = 'Petrol Can', weapon = 'WEAPON_PETROLCAN', price = 100 },
            { label = 'Flare', weapon = 'WEAPON_FLARE', price = 100 },
            { label = 'Knife', weapon = 'WEAPON_KNIFE', price = 100 },
            { label = 'Hammer', weapon = 'WEAPON_HAMMER', price = 180 },
            { label = 'Bat', weapon = 'WEAPON_BAT', price = 50 },
            { label = 'Crowbar', weapon = 'WEAPON_CROWBAR', price = 230 },
            { label = 'Golf Club', weapon = 'WEAPON_GOLFCLUB', price = 120 },
            { label = 'Bottle', weapon = 'WEAPON_BOTTLE', price = 20 },
            { label = 'Dagger', weapon = 'WEAPON_DAGGER', price = 120 },
            { label = 'Hatchet', weapon = 'WEAPON_HATCHET', price = 1200 },
            { label = 'Knuckle Duster', weapon = 'WEAPON_KNUCKLE', price = 1200 },
            { label = 'Machete', weapon = 'WEAPON_MACHETE', price = 3000 },
            { label = 'Flashlight', weapon = 'WEAPON_FLASHLIGHT', price = 120 },
            { label = 'Switch Blade', weapon = 'WEAPON_SWITCHBLADE', price = 120 },
            { label = 'Pool Cue', weapon = 'WEAPON_POOLCUE', price = 120 },
            { label = 'Wrench', weapon = 'WEAPON_WRENCH', price = 100 }
        }
    },
    {
        name = 'Pistols',
        label = 'Pistols',
        items = {
            { label = 'Pistol', weapon = 'WEAPON_PISTOL', price = 1500 },
            { label = 'Combat Pistol', weapon = 'WEAPON_COMBATPISTOL', price = 2000 },
            { label = 'Vintage Pistol', weapon = 'WEAPON_VINTAGEPISTOL', price = 3000 },
            { label = 'Stun Gun', weapon = 'WEAPON_STUNGUN', price = 3500 }
        }
    },
    {
        name = 'MachineGuns',
        label = 'Machine Guns',
        items = {
            { label = 'Micro SMG (Illegal)', weapon = 'WEAPON_MICROSMG', price = 20000 },
            { label = 'SMG (Illegal)', weapon = 'WEAPON_SMG', price = 20000 },
            { label = 'Assault SMG (Illegal)', weapon = 'WEAPON_ASSAULTSMG', price = 22800 },
            { label = 'Gusenberg (Illegal)', weapon = 'WEAPON_GUSENBERG', price = 32000 }
        }
    },
    {
        name = 'Shotguns',
        label = 'Shotguns',
        items = {
            { label = 'Sawed-off Shotgun (Illegal)', weapon = 'WEAPON_SAWNOFFSHOTGUN', price = 15000 },
            { label = 'Bullpup Shotgun (Illegal)', weapon = 'WEAPON_BULLPUPSHOTGUN', price = 20000 },
            { label = 'Assault Shotgun (Illegal)', weapon = 'WEAPON_ASSAULTSHOTGUN', price = 20000 },
            { label = 'Heavy Shotgun (Illegal)', weapon = 'WEAPON_HEAVYSHOTGUN', price = 20000 },
            { label = 'Auto Shotgun (Illegal)', weapon = 'WEAPON_AUTOSHOTGUN', price = 33000 }
        }
    },
    {
        name = 'AssaultRifles',
        label = 'Assault Rifles',
        items = {
            { label = 'Assault Rifle (Illegal)', weapon = 'WEAPON_ASSAULTRIFLE', price = 45000 },
            { label = 'Carbine Rifle (Illegal)', weapon = 'WEAPON_CARBINERIFLE', price = 45000 },
            { label = 'Advanced Rifle (Illegal)', weapon = 'WEAPON_ADVANCEDRIFLE', price = 55000 },
            { label = 'Special Carbine (Illegal)', weapon = 'WEAPON_SPECIALCARBINE', price = 55000 },
            { label = 'Bullpup Rifle (Illegal)', weapon = 'WEAPON_BULLPUPRIFLE', price = 62000 }
        }
    },
    {
        name = 'SniperRifles',
        label = 'Sniper Rifles',
        items = {
            { label = 'Sniper Rifle (Illegal)', weapon = 'WEAPON_SNIPERRIFLE', price = 150000 },
            { label = 'Heavy Sniper (Illegal)', weapon = 'WEAPON_HEAVYSNIPER', price = 200000 },
            { label = 'Marksman Rifle (Illegal)', weapon = 'WEAPON_MARKSMANRIFLE', price = 250000 }
        }
    },
    {
        name = 'HeavyWeapons',
        label = 'Heavy Weapons',
        items = {
            { label = 'Firework', weapon = 'WEAPON_FIREWORK', price = 200000 }
        }
    },
    {
        name = 'ThrownWeapons',
        label = 'Thrown Weapons',
        items = {
            { label = 'Fire Extinguisher', weapon = 'WEAPON_FIREEXTINGUISHER', price = 9000 }
        }
    }
}

Config.ItemPrices = {}
for _, cat in ipairs(Config.Categories) do
    for _, item in ipairs(cat.items) do
        Config.ItemPrices[item.weapon] = item.price
    end
end

