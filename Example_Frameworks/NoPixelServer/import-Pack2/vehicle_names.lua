--[[
    -- Type: Client Script
    -- Name: vehicle_names
    -- Use: Registers display names for custom vehicles
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local vehicleNames = {
    CIVICDS = "Honda Civic Del Sol EG",
    ["a80"] = "Toyota Supra MkIV",
    SSTI = "Subaru WRX STI",
    rmodmustang = "Ford Mustang RMod",
    rx7rb = "Mazda RX-7 Rocket Bunny",
    Mustang = "Ford Mustang",
    LP700R = "Lamborghini Aventador LP700R",
    czl1 = "Chevrolet Camaro ZL1",
    ["911 (993)"] = "Porsche 911 (993)",
    EVO10 = "Mitsubishi Lancer Evo X",
    LWGTR = "Nissan GT-R Liberty Walk",
    ["66fastback"] = "Ford Mustang 66 Fastback",
    ["911TURBOS"] = "Porsche 911 Turbo S",
    ["370Z"] = "Nissan 370Z",
    CHEETAH = "Grotti Cheetah",
    ["510"] = "Datsun 510",
    ["m3 e46"] = "BMW M3 E46",
    s200 = "Honda S2000"
}

CreateThread(function()
    for key, value in pairs(vehicleNames) do
        AddTextEntry(key, value)
    end
end)
