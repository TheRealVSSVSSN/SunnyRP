--[[
    -- Type: Script
    -- Name: PillboxHospitalLoader
    -- Use: Loads the Gabz Pillbox Hospital interior and removes default hospital IPLs.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local PILLBOX_IPL = 'gabz_pillbox_milo_'
local PILLBOX_COORDS = vector3(311.2546, -592.4204, 42.32737)
local DEFAULT_IPLS = {
    'rc12b_fixed',
    'rc12b_destroyed',
    'rc12b_default',
    'rc12b_hospitalinterior_lod',
    'rc12b_hospitalinterior'
}

CreateThread(function()
    RequestIpl(PILLBOX_IPL)

    local interior = GetInteriorAtCoords(PILLBOX_COORDS.x, PILLBOX_COORDS.y, PILLBOX_COORDS.z)
    if interior ~= 0 and IsValidInterior(interior) then
        for _, ipl in ipairs(DEFAULT_IPLS) do
            RemoveIpl(ipl)
        end

        LoadInterior(interior)
        RefreshInterior(interior)
    end
end)
