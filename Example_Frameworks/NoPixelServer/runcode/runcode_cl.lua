RegisterNetEvent('runcode:gotSnippet')

--[[
    -- Type: Event
    -- Name: runcode:gotSnippet
    -- Use: Executes code sent from the server and returns the result.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('runcode:gotSnippet', function(id, lang, code)
    local res, err = RunCode(lang, code)

    if not err then
        local rType = type(res)
        if rType == 'vector3' or rType == 'vector4' then
            res = json.encode({ table.unpack(res) })
        elseif rType == 'table' then
            res = json.encode(res)
        elseif res ~= nil then
            res = tostring(res)
        end
    end

    TriggerServerEvent('runcode:gotResult', id, res, err)
end)