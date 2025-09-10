local resourceName = GetCurrentResourceName()

--[[
    -- Type: Function
    -- Name: sanitizeName
    -- Use: Replaces non-alphanumeric characters in a string with underscores
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function sanitizeName(name)
    return name:gsub('[^%w]', '_')
end

--[[
    -- Type: Command
    -- Name: /pos
    -- Use: Requests the client to send its current coordinates
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterCommand('pos', function(source)
    TriggerClientEvent('coordsaver:savePosition', source)
end, false)

--[[
    -- Type: Event
    -- Name: coordsaver:save
    -- Use: Writes player coordinates to a per-player file within the resource
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('coordsaver:save', function(x, y, z)
    local playerName = sanitizeName(GetPlayerName(source) or 'unknown')
    local fileName = playerName .. '-Coords.txt'
    local existing = LoadResourceFile(resourceName, fileName) or ''
    local line = string.format('{%.2f, %.2f, %.2f},\n', x, y, z)
    local data = existing .. line
    SaveResourceFile(resourceName, fileName, data, #data)
end)

