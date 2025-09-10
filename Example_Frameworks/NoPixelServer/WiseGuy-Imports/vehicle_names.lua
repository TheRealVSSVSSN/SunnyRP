--[[
    -- Type: Thread
    -- Name: vehicleNameThread
    -- Use: Registers imported vehicle names on client start
    -- Created: 2024-11-29
    -- By: VSSVSSN
--]]

CreateThread(function()
    local vehicleNames = {
        [0x0EA2DDE8] = 'BMW M4 F82',
        [0x3639EAA1] = 'BMW M4 F82',
        [0x631F22C7] = 'Honda',
        [0xFBBBD1B8] = 'NSX Rocket Bunny',
        [0x3C7666C0] = 'BRZ Pandem V3',
        [0x39CF1938] = 'Subaru',
        [0x5E701E79] = 'Golf MK7 Pandem'
    }

    for hash, name in pairs(vehicleNames) do
        AddTextEntryByHash(hash, name)
    end
end)

