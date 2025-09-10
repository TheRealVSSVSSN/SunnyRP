--[[
    -- Type: Class
    -- Name: Group
    -- Use: Permission group hierarchy utilities
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

groups = {}

Group = {}
Group.__index = Group

setmetatable(Group, {
    __eq = function(self)
        return self.group
    end,
    __tostring = function(self)
        return self.group
    end,
    __call = function(self, group, inherit)
        local gr = {group = group, inherits = inherit}
        groups[group] = gr
        return setmetatable(gr, Group)
    end
})

--[[
    -- Type: Function
    -- Name: canTarget
    -- Use: Determines if a group can affect another
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Group:canTarget(gr)
    if self.group == 'user' then
        return false
    end
    if self.group == gr or self.inherits == gr or self.inherits == 'superadmin' then
        return true
    elseif self.inherits == 'user' then
        return false
    else
        return groups[self.inherits]:canTarget(gr)
    end
end

-- Default groups
user = Group('user', '')
admin = Group('admin', 'user')
superadmin = Group('superadmin', 'admin')

--[[
    -- Type: Event
    -- Name: es:addGroup
    -- Use: Registers a new group at runtime
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
AddEventHandler('es:addGroup', function(group, inherit, cb)
    if inherit == 'user' then
        admin.inherits = group
    end
    local rtVal = Group(group, inherit)
    cb(rtVal)
end)

--[[
    -- Type: Event
    -- Name: es:getAllGroups
    -- Use: Returns current group definitions
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
AddEventHandler('es:getAllGroups', function(cb)
    cb(groups)
end)
