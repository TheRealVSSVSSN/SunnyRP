--[[
    -- Type: Module
    -- Name: Schema
    -- Use: Provides schema loading and XML serialization utilities
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local Schemas = {}
_G.Schemas = Schemas

--[[
	This is for fancy error handling
	TODO: Move to fsn_core
]]
local errprefix = "^3[fsn_builders]^7 ^1ERROR:^7 "

--[[
    -- Type: Function
    -- Name: drop_guard
    -- Use: Ensures a field definition supplies a name before the function exits
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function drop_guard(err)
        local safe = false

        local meta = {
                __gc   = function() assert(safe, errprefix..err) end,
                __call = function() safe = true end
        }
        return setmetatable({}, meta)
end



--[[
	Schema types
]]
local types = {}


--[[
    -- Type: Function
    -- Name: types.string
    -- Use: Serializes a simple string field
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function types.string(field, val)
        return XML():inline(field, tostring(val))
end

--[[
    -- Type: Function
    -- Name: types.float
    -- Use: Serializes a floating point field
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function types.float(field, val)
        val = tonumber(val)
        assert(val, errprefix.."Expected number for field "..field)
        val = ("%f"):format(val)
        return XML():void(field, {value=val})
end

--[[
    -- Type: Function
    -- Name: types.integer
    -- Use: Serializes an integer field
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function types.integer(field, val)
        val = tonumber(val)
        assert(val, errprefix.."Expected number for field "..field)
        val = ("%d"):format(math.floor(val))
        return XML():void(field, {value=val})
end

--[[
    -- Type: Function
    -- Name: types.vector
    -- Use: Serializes a three dimensional vector field
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function types.vector(field, val)
        assert(type(val) == "table", errprefix.."Expected table for field "..field)
        local attrs = {
                x = ("%f"):format(tonumber(val.x or val[1])),
                y = ("%f"):format(tonumber(val.y or val[2])),
                z = ("%f"):format(tonumber(val.z or val[3]))
        }

        return XML():void(field, attrs)
end

--[[
    -- Type: Function
    -- Name: types.SubHandlingData
    -- Use: Serializes sub handling data entries
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function types.SubHandlingData(field, val)
        local xml = XML():open("SubHandlingData")
        for i=1, 3 do
                if val[i] then
                        xml:append(val[i])
                else
                        xml:void("Item", {type="NULL"})
                end
        end
        return xml:close()
end




--[[
	Schema loading
]]
--[[
    -- Type: Function
    -- Name: env_for_schema
    -- Use: Creates environment for schema definition files
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function env_for_schema(class)
	local cur_group = "None"
	local cur_field

	local env = {}
	function env.Group(group)
		cur_group = group
	end

	function env.Field(type)
		local guard = drop_guard("A field definition requires a field name")

		return function(field)
			guard()

			cur_field = {}
			cur_field.Group = cur_group
			cur_field.Type  = assert(types[type], "Unknown type "..type)

			Schemas[class][field] = cur_field
		end
	end

	for _, v in pairs({"Desc", "Doc", "Default", "Source", "Limit"}) do
		env[v] = function(str) cur_field[v] = str end
	end

	-- __index is so we can populate default values of arbitrary types
	-- Unfortunately this depends on the order of schema loads
	return setmetatable(env, { __index=Schemas })
end

--[[
    -- Type: Function
    -- Name: serialize
    -- Use: Turns a table of data into XML based on class schema
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function serialize(class, data)
        local xml = XML():open("Item", {type=class})
        for f, fd in pairs(Schemas[class]) do
                local val = data[fd.Source or f]
                        or assert(fd.Default, "No (default) value given for field "..f)
                xml:append(fd.Type(f, val))
        end
        return xml:close()
end

--[[
    -- Type: Function
    -- Name: LoadSchema
    -- Use: Loads and registers a schema definition file
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function LoadSchema(class, file)
        Schemas[class] = setmetatable({}, {
                __call = function(self, ...) return serialize(class, ...) end
        })

        local res = GetCurrentResourceName()
        local err = errprefix.."Failed to %s ^0'^5"..file.."^0'^7"

        local code = assert(
                LoadResourceFile(res, "schemas/"..file),
                err:format("load"))

        local fn = assert(
                load(code, "SCHEMA: schemas/"..file, "t", env_for_schema(class)),
                err:format("parse"))

        local ok, msg = pcall(fn)
        assert(ok, errprefix..msg)

        return Schemas[class]
end

_G.LoadSchema = LoadSchema
