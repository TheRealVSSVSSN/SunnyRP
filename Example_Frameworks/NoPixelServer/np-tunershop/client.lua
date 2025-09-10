--[[
    -- Type: Client Script
    -- Name: client.lua
    -- Use: Initializes the tuner shop warehouse IPLs on client start
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

CreateThread(function()
    if ImportVehicleWarehouse and ImportVehicleWarehouse.LoadDefault then
        ImportVehicleWarehouse.LoadDefault()
    end
end)

