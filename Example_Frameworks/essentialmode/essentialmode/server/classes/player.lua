--[[
    -- Type: Class
    -- Name: Player
    -- Use: Represents a connected player and exposes money/permission helpers
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

Player = {}
Player.__index = Player

setmetatable(Player, {
    __call = function(self, source, permission_level, money, identifier, group)
        local pl = {
            source = source,
            permission_level = permission_level,
            money = money,
            identifier = identifier,
            group = group,
            coords = {x = 0.0, y = 0.0, z = 0.0},
            session = {}
        }
        return setmetatable(pl, Player)
    end
})

local function refreshMoney(self)
    TriggerClientEvent('es:activateMoney', self.source, self.money)
end

--[[
    -- Type: Function
    -- Name: getPermissions
    -- Use: Returns the permission level of the player
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:getPermissions()
    return self.permission_level
end

--[[
    -- Type: Function
    -- Name: setPermissions
    -- Use: Updates permission level and persists to DB
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:setPermissions(p)
    TriggerEvent('es:setPlayerData', self.source, 'permission_level', p, function()
        self.permission_level = p
    end)
end

--[[
    -- Type: Function
    -- Name: setCoords
    -- Use: Stores player coordinates
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:setCoords(x, y, z)
    self.coords.x, self.coords.y, self.coords.z = x, y, z
end

--[[
    -- Type: Function
    -- Name: kick
    -- Use: Disconnects the player with a reason
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:kick(reason)
    DropPlayer(self.source, reason)
end

--[[
    -- Type: Function
    -- Name: setMoney
    -- Use: Sets player money and updates UI
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:setMoney(m)
    local prev = self.money
    self.money = m
    if m > prev then
        TriggerClientEvent('es:addedMoney', self.source, m - prev)
    else
        TriggerClientEvent('es:removedMoney', self.source, prev - m)
    end
    refreshMoney(self)
end

--[[
    -- Type: Function
    -- Name: addMoney
    -- Use: Adds to player money and updates UI
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:addMoney(m)
    self.money = self.money + m
    TriggerClientEvent('es:addedMoney', self.source, m)
    refreshMoney(self)
end

--[[
    -- Type: Function
    -- Name: removeMoney
    -- Use: Removes from player money and updates UI
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:removeMoney(m)
    self.money = self.money - m
    TriggerClientEvent('es:removedMoney', self.source, m)
    refreshMoney(self)
end

--[[
    -- Type: Function
    -- Name: setSessionVar
    -- Use: Saves temporary session data
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:setSessionVar(key, value)
    self.session[key] = value
end

--[[
    -- Type: Function
    -- Name: getSessionVar
    -- Use: Retrieves temporary session data
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function Player:getSessionVar(key)
    return self.session[key]
end
