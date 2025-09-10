--[[
    -- Type: Table
    -- Name: liveryNames
    -- Use: Maps livery hash keys to display names
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local liveryNames = {
    ["0x6D529881"] = "Sloth Prime Towing",
    ["0x9F157C06"] = "6STR Tuner Shop",
    ["0xB4D4A784"] = "Gomer Colton",
    ["0x54C1675B"] = "Victor Mason",
    ["0x467F4AD7"] = "Reserved",
    ["0x760429B0"] = "Reserved",
    ["0x6C4B163E"] = "Reserved",
    ["0xE9C39161"] = "Reserved",
    ["0x1B8574E4"] = "Reserved",
    ["0x5722BBA7"] = "Reserved",
    ["0x4276926B"] = "Reserved",
    ["0x5855BE29"] = "Reserved",
    ["0x8F12ABA2"] = "Reserved",
    ["0x74DA7732"] = "Reserved",
    ["0xAFADECD8"] = "Reserved",
    ["0x7D4F081B"] = "Reserved",
    ["0xCC1BA5B7"] = "Reserved",
    ["0x99C1C100"] = "Reserved",
    ["0x00B68ED0"] = "Reserved",
    ["0x4C0DA41D"] = "Reserved"
}

--[[
    -- Type: Function
    -- Name: applyLiveryNames
    -- Use: Registers custom livery names with the game
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function applyLiveryNames()
    for hash, name in pairs(liveryNames) do
        AddTextEntry(hash, name)
    end
end

--[[
    -- Type: Thread
    -- Name: liveryNameThread
    -- Use: Applies livery name registration on resource start
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    applyLiveryNames()
end)
