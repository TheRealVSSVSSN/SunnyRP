local function GetPrivs(source)
    return {
        canServer = IsPlayerAceAllowed(source, 'command.run'),
        canClient = IsPlayerAceAllowed(source, 'command.crun'),
        canSelf   = IsPlayerAceAllowed(source, 'runcode.self')
    }
end

RegisterCommand('run', function(source, args)
    if #args == 0 then
        return
    end

    RunCode('lua', table.concat(args, ' '))
end, true)

RegisterCommand('crun', function(source, args)
    if not source or #args == 0 then
        return
    end

    TriggerClientEvent('runcode:gotSnippet', source, -1, 'lua', table.concat(args, ' '))
end, true)

RegisterCommand('runcode', function(source)
    if not source then
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

