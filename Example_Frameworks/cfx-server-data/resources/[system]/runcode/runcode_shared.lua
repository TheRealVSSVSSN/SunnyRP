local runners = {}

function runners.lua(arg)
    local code, err = load('return ' .. arg, '@runcode', 't')

    -- if failed, try without return
    if err then
        code, err = load(arg, '@runcode', 't')
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

function runners.js(arg)
    return table.unpack(exports[GetCurrentResourceName()]:runJS(arg))
end

function RunCode(lang, str)
    return runners[lang](str)
end

