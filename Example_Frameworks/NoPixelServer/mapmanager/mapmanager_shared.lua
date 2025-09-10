--[[
    -- Type: Module
    -- Name: mapmanager_shared
    -- Use: Shared helpers for loading and unloading map directives
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

mapFiles = {}

--[[
    -- Type: Function
    -- Name: addMap
    -- Use: Registers a map file for later loading
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function addMap(file, owningResource)
    if not mapFiles[owningResource] then
        mapFiles[owningResource] = {}
    end

    table.insert(mapFiles[owningResource], file)
end

undoCallbacks = {}

--[[
    -- Type: Function
    -- Name: loadMap
    -- Use: Parses all map files for a resource
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function loadMap(res)
    if mapFiles[res] then
        for _, file in ipairs(mapFiles[res]) do
            parseMap(file, res)
        end
    end
end

--[[
    -- Type: Function
    -- Name: unloadMap
    -- Use: Reverts map directives registered by a resource
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function unloadMap(res)
    if undoCallbacks[res] then
        for _, cb in ipairs(undoCallbacks[res]) do
            cb()
        end

        undoCallbacks[res] = nil
        mapFiles[res] = nil
    end
end

--[[
    -- Type: Function
    -- Name: parseMap
    -- Use: Executes a map file within a sandboxed environment
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function parseMap(file, owningResource)
    if not undoCallbacks[owningResource] then
        undoCallbacks[owningResource] = {}
    end

    local env = {
        math = math, pairs = pairs, ipairs = ipairs, next = next, tonumber = tonumber, tostring = tostring,
        type = type, table = table, string = string,
        vector3 = vector3, quat = quat, vec = vec, vector2 = vector2
    }

    env._G = env

    TriggerEvent('getMapDirectives', function(key, cb, undocb)
        env[key] = function(...)
            local state = {}

            state.add = function(k, v)
                state[k] = v
            end

            local result = cb(state, ...)
            local args = table.pack(...)

            table.insert(undoCallbacks[owningResource], function()
                undocb(state)
            end)

            return result
        end
    end)

    local mt = {
        __index = function(t, k)
            if rawget(t, k) ~= nil then return rawget(t, k) end

            -- as we're not going to return nothing here (to allow unknown directives to be ignored)
            local f = function()
                return f
            end

            return function() return f end
        end
    }

    setmetatable(env, mt)
    
    local fileData = LoadResourceFile(owningResource, file)
    local mapFunction, err = load(fileData, file, 't', env)

    if not mapFunction then
        print("Couldn't load map " .. file .. ": " .. err .. " (type of fileData: " .. type(fileData) .. ")")
        return
    end

    local ok, execErr = pcall(mapFunction)
    if not ok then
        print("Error executing map " .. file .. ": " .. tostring(execErr))
    end
end
