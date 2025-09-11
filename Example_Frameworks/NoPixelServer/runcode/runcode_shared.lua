local runners = {}

--[[
    -- Type: Function
    -- Name: runners.lua
    -- Use: Executes Lua code snippets and returns results or errors.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function runners.lua(arg)
    local env = setmetatable({}, { __index = _G })
    local code, err = load('return ' .. arg, '@runcode', 't', env)

    -- if failed, try without implicit return
    if err then
        code, err = load(arg, '@runcode', 't', env)
    end

    if err then
        return nil, err
    end

    local status, result = pcall(code)
    if status then
        return result
    end

    return nil, result
end

--[[
    -- Type: Function
    -- Name: runners.js
    -- Use: Executes JavaScript snippets through the runcode.js export.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function runners.js(arg)
    return table.unpack(exports[GetCurrentResourceName()]:runJS(arg))
end

--[[
    -- Type: Function
    -- Name: RunCode
    -- Use: Dispatches code execution to the proper language runner.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function RunCode(lang, str)
    local runner = runners[lang]
    if not runner then
        return nil, ('Unsupported language: %s'):format(lang)
    end

    return runner(str)
end