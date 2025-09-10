--[[
    -- Type: Thread
    -- Name: MRPDInteriorLoader
    -- Use: Loads and refreshes MRPD interior entity sets
    -- Created: 2024-06-19
    -- By: VSSVSSN
--]]

CreateThread(function()
    RequestIpl("gabz_mrpd_milo_")

    local interiorId = GetInteriorAtCoords(451.0129, -993.3741, 29.1718)

    if IsValidInterior(interiorId) then
        for i = 1, 31 do
            EnableInteriorProp(interiorId, string.format("v_gabz_mrpd_rm%d", i))
        end

        RefreshInterior(interiorId)
    end
end)
