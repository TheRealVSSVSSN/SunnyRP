--[[
    -- Type: Module
    -- Name: Jobs Stub
    -- Use: Placeholder for job actions
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

local M = {}

function M.default()
    return { status = 501, message = 'Not implemented in failover path' }
end

return setmetatable(M, {
    __index = function()
        return M.default
    end
})
