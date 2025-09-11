--[[
    -- Type: Module
    -- Name: handling_builder
    -- Use: Builds handling.meta files from schema definitions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local errprefix = "^3[fsn_builders]^7 ^1ERROR:^7 "
--[[
        Translators
]]
local CCarHandlingData = LoadSchema("CCarHandlingData", "ccarhandlingdata.lua")
local CBikeHandlingData = LoadSchema("CBikeHandlingData", "cbikehandlingdata.lua")
local CHandlingData    = LoadSchema("CHandlingData", "chandlingdata.lua")

--[[
    -- Type: Function
    -- Name: load_file
    -- Use: Loads a Lua handling definition file within a sandboxed environment
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function load_file(res, file)
        local err = errprefix.."Failed to %s ^0'^5@"..res.."/"..file.."^0'^7"

        local code = assert(
                LoadResourceFile(res, file),
                err:format("load"))

        local env = setmetatable({}, {
                __index = function(_, key) return Schemas[key] or _G[key] end
        })

        local fn = assert(
                load(code, "@"..res.."/"..file, "t", env),
                err:format("parse"))

        return fn()
end


--[[
	FiveM Builder
]]
local builder = {}

--[[
    -- Type: Function
    -- Name: shouldBuild
    -- Use: Determines if a resource contains handling metadata
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function builder.shouldBuild(res)
        return GetNumResourceMetadata(res, "fsn_handling") > 0
end

--[[
    -- Type: Function
    -- Name: build
    -- Use: Generates the handling.meta file for a resource
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function builder.build(res, finished)
        local xml = XML():open("CHandlingDataMgr")
                :open("HandlingData")

        local count = GetNumResourceMetadata(res, "fsn_handling")
        for i=0, count - 1 do
                local file = GetResourceMetadata(res, "fsn_handling", i)
                xml:comment(file)

                local ok, data = pcall(load_file, res, file)
                if not ok then
                        return finished(false, data)
                end

                for _, handling in pairs(data) do
                        xml:append(handling)
                end
        end

        local out = xml:close()
                :close()
                :serialize()

        SaveResourceFile(res, "out/handling.meta", out, #out)
        finished(true)
end

--[[
    -- Type: Function
    -- Name: factory
    -- Use: Returns the builder instance for the build task factory
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function factory()
        return builder
end
RegisterResourceBuildTaskFactory("fsn_handling", factory)
