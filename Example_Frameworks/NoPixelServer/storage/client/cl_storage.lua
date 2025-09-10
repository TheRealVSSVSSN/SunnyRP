local vector2Type = type(vector2(0.0, 0.0))
local vector3Type = type(vector3(0.0, 0.0, 0.0))
local vector4Type = type(vector4(0.0, 0.0, 0.0, 0.0))

local TYPES = {
    int = function(key)
        return GetResourceKvpInt(key)
    end,
    float = function(key)
        return GetResourceKvpFloat(key)
    end,
    string = function(key)
        return GetResourceKvpString(key)
    end,
    vector2 = function(key)
        return vector2(
            GetResourceKvpFloat(("Vec2_[%s]_X"):format(key)),
            GetResourceKvpFloat(("Vec2_[%s]_Y"):format(key))
        )
    end,
    vector3 = function(key)
        return vector3(
            GetResourceKvpFloat(("Vec3_[%s]_X"):format(key)),
            GetResourceKvpFloat(("Vec3_[%s]_Y"):format(key)),
            GetResourceKvpFloat(("Vec3_[%s]_Z"):format(key))
        )
    end,
    vector4 = function(key)
        return vector4(
            GetResourceKvpFloat(("Vec4_[%s]_X"):format(key)),
            GetResourceKvpFloat(("Vec4_[%s]_Y"):format(key)),
            GetResourceKvpFloat(("Vec4_[%s]_Z"):format(key)),
            GetResourceKvpFloat(("Vec4_[%s]_W"):format(key))
        )
    end,
    table = function(key)
        local result = GetResourceKvpString("Json_" .. key)
        if result then
            return json.decode(result)
        end
        return nil
    end
}

--[[
    -- Type: Function
    -- Name: getStorage
    -- Use: Internal helper to pull data by type from KVP storage
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function getStorage(storageType, key)
    local reader = TYPES[storageType]
    if reader then
        return reader(key)
    end
    print("[Storage] - [Error] - [Failed to find data type] - x1")
    return nil
end

--[[
    -- Type: Function
    -- Name: set
    -- Use: Stores value under key using appropriate KVP native
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function set(value, key)
    local valueType = type(value)

    if valueType == "number" then
        if math.type(value) == "integer" then
            SetResourceKvpInt("IsSet_" .. key, 1)
            SetResourceKvpInt(key, value)
        elseif math.type(value) == "float" then
            SetResourceKvpInt("IsSet_" .. key, 1)
            SetResourceKvpFloat(key, value)
        else
            print("[Storage] - [Error] - [Failed to find data type] - x3")
        end
        return
    end

    if valueType == "string" then
        SetResourceKvpInt("IsSet_" .. key, 1)
        SetResourceKvp(key, value)
    elseif valueType == vector2Type then
        SetResourceKvpInt("IsSet_" .. key, 1)
        SetResourceKvpFloat(("Vec2_[%s]_X"):format(key), value.x)
        SetResourceKvpFloat(("Vec2_[%s]_Y"):format(key), value.y)
    elseif valueType == vector3Type then
        SetResourceKvpInt("IsSet_" .. key, 1)
        SetResourceKvpFloat(("Vec3_[%s]_X"):format(key), value.x)
        SetResourceKvpFloat(("Vec3_[%s]_Y"):format(key), value.y)
        SetResourceKvpFloat(("Vec3_[%s]_Z"):format(key), value.z)
    elseif valueType == vector4Type then
        SetResourceKvpInt("IsSet_" .. key, 1)
        SetResourceKvpFloat(("Vec4_[%s]_X"):format(key), value.x)
        SetResourceKvpFloat(("Vec4_[%s]_Y"):format(key), value.y)
        SetResourceKvpFloat(("Vec4_[%s]_Z"):format(key), value.z)
        SetResourceKvpFloat(("Vec4_[%s]_W"):format(key), value.w)
    elseif valueType == "table" then
        SetResourceKvpInt("IsSet_" .. key, 1)
        SetResourceKvp("Json_" .. key, json.encode(value))
    else
        print("[Storage] - [Error] - [Failed to find data type] - x4")
    end
end

--[[
    -- Type: Function
    -- Name: remove
    -- Use: Deletes stored value and associated keys
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function remove(key)
    local entries = {
        key,
        ("IsSet_%s"):format(key),
        ("Vec2_[%s]_X"):format(key), ("Vec2_[%s]_Y"):format(key),
        ("Vec3_[%s]_X"):format(key), ("Vec3_[%s]_Y"):format(key), ("Vec3_[%s]_Z"):format(key),
        ("Vec4_[%s]_X"):format(key), ("Vec4_[%s]_Y"):format(key), ("Vec4_[%s]_Z"):format(key), ("Vec4_[%s]_W"):format(key),
        ("Json_%s"):format(key)
    }

    for _, entry in ipairs(entries) do
        DeleteResourceKvp(entry)
    end
end

--[[
    -- Type: Function
    -- Name: tryGet
    -- Use: Retrieves stored value if it exists, else false
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function tryGet(storageType, key)
    if GetResourceKvpInt("IsSet_" .. key) ~= 0 then
        return getStorage(storageType, key)
    end
    return false
end
