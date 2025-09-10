--[[
    -- Type: Function
    -- Name: GetPrivs
    -- Use: Retrieves permission flags for a given player source.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function GetPrivs(source)
    return {
        canServer = IsPlayerAceAllowed(source, 'command.run'),
        canClient = IsPlayerAceAllowed(source, 'command.crun'),
        canSelf = IsPlayerAceAllowed(source, 'runcode.self'),
    }
end

--[[
    -- Type: Command
    -- Name: run
    -- Use: Executes Lua code on the server and prints the result.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterCommand('run', function(source, args, rawCommand)
    local res, err = RunCode('lua', rawCommand:sub(5))
    local output = err or tostring(res)

    if source == 0 then
        print(output)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'runcode', output }
        })
    end
end, true)

--[[
    -- Type: Command
    -- Name: crun
    -- Use: Executes Lua code on a client from the server.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterCommand('crun', function(source, args, rawCommand)
    if source == 0 then
        return
    end

    TriggerClientEvent('runcode:gotSnippet', source, -1, 'lua', rawCommand:sub(5))
end, true)

--[[
    -- Type: Command
    -- Name: runcode
    -- Use: Opens the runcode UI for privileged players.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterCommand('runcode', function(source, args, rawCommand)
    if source == 0 then
        return
    end

    local df = LoadResourceFile(GetCurrentResourceName(), 'data.json')
    local saveData = {}

    if df then
        saveData = json.decode(df)
    end

    local p = GetPrivs(source)

    if not p.canServer and not p.canClient and not p.canSelf then
        return
    end

    p.saveData = saveData

    TriggerClientEvent('runcode:openUi', source, p)
end, true)