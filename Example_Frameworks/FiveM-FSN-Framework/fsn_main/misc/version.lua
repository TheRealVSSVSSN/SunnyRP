local current_version = '2.1.4'
local current_release = false

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    PerformHttpRequest('https://fsn.rocks/api/public/version', function(_, body)
        current_release = current_version
        if body ~= current_version then
            PerformHttpRequest('https://fsn.rocks/api/public/changelog', function(_, changelog)
                changelog = json.decode(changelog or '[]')
                print('')
                print('^1----------------- ATTENTION ------------------')
                print('--^0 :FSN: Framework Update Available ('..body..')')
                print('^1--^0')
                print('^1--^0 Change log:')
                for _, v in pairs(changelog) do
                    print('^1--^3 > ^0'..v)
                end
                print('^1----------------------------------------------')
                print('^0')
            end)
        end
    end)
end)

AddEventHandler('playerConnecting', function(playername)
    if current_release then
        TriggerClientEvent('fsn_main:version', source, current_version, current_release)
    else
        print('^1ERROR:^0 Cannot send versiondata to '..playername..', check for lua errors.')
    end
end)