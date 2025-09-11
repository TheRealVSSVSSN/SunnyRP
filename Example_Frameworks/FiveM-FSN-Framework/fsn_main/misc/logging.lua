-- External logging system shit	
function fsn_AddLog(src, Category, Description)
        local steamId = 'notset'
        if src then
                steamId = GetPlayerIdentifiers(src)[1]
        else
                steamId = GetPlayerIdentifiers(source)[1]
        end
        local payload = json.encode({
                key = 'LF20',
                cat = Category,
                steamid = steamId,
                info = Description
        })
        PerformHttpRequest('http://nocf.fsn.rocks/add-log.php', function() end, 'POST', payload, {
                ['Content-Type'] = 'application/json'
        })
end

RegisterServerEvent('fsn_main:logging:addLog')
AddEventHandler('fsn_main:logging:addLog', function(src, Category, Description)
        Description = Description or ''
        fsn_AddLog(src, Category, Description)
end)