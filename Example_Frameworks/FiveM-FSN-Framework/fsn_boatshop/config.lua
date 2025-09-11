--[[
    -- Type: Module
    -- Name: BoatShopConfig
    -- Use: Shared configuration for boat shop spots and catalogue
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]

Config = {}

Config.Spots = {
    { coords = vector4(-723.8487, -1327.9862, -0.4744, 230.5208) },
    { coords = vector4(-730.0563, -1334.4949, -0.4744, 230.5208) },
    { coords = vector4(-735.4115, -1341.6735, -0.4744, 230.5208) },
    { coords = vector4(-740.7567, -1348.8313, -0.1161, 230.5208) },
    { coords = vector4(-745.9460, -1355.8922, -0.4746, 230.5208) }
}

Config.Boats = {
    { name = "Dinghy 4 Seater", model = "dinghy", price = 85000, rental = 17000 },
    { name = "SeaShark", model = "seashark", price = 15000, rental = 3000 },
    { name = "SeaShark Yacht", model = "seashark3", price = 18000, rental = 32000 },
    { name = "Speeder", model = "speeder", price = 105000, rental = 21000 },
    { name = "Squalo", model = "squalo", price = 110000, rental = 22000 },
    { name = "SunTrap", model = "suntrap", price = 75000, rental = 15000 },
    { name = "Toro", model = "toro", price = 150000, rental = 30000 },
    { name = "Toro Yacht", model = "toro2", price = 155000, rental = 31000 },
    { name = "Tropic", model = "tropic", price = 175000, rental = 35000 },
    { name = "Tropic Yacht", model = "tropic2", price = 178000, rental = 35600 },
    { name = "Dinghy 2 Seater", model = "dinghy2", price = 90000, rental = 18000 },
    { name = "Jetmax", model = "jetmax", price = 140000, rental = 28000 },
    { name = "Marquis", model = "marquis", price = 250000, rental = 100000 }
}

return Config
