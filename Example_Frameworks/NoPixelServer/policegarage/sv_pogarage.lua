local function signOnRadio(src)
        local user = exports['np-base']:getModule('Player'):GetUser(src)
        local char = user:getCurrentCharacter()

        local q = [[SELECT id, owner, cid, job, callsign, rank FROM jobs_whitelist WHERE cid = @cid AND (job = 'police' or job = 'doc')]]
        local v = { cid = char.id }

        exports.ghmattimysql:execute(q, v, function(results)
                if results and results[1] then
                        local callsign = results[1].callsign
                        if not callsign or callsign == '' then callsign = 'TBD' end
                        if char.first_name and char.last_name then
                                TriggerClientEvent('SignOnRadio', src, callsign)
                        else
                                TriggerClientEvent('DoLongHudText', src, 'Sessioned!?', 2)
                        end
                else
                        TriggerClientEvent('DoLongHudText', src, 'Sessioned!?', 2)
                end
        end)
end

RegisterNetEvent('attemptduty')
AddEventHandler('attemptduty', function(pJobType)
        local src = source
        local user = exports['np-base']:getModule('Player'):GetUser(src)
        local jobs = exports['np-base']:getModule('JobManager')
        local job = pJobType or 'police'
        jobs:SetJob(user, job, false, function()
                TriggerClientEvent('nowCopGarage', src)
                TriggerClientEvent('DoLongHudText', src, '10-41 and Restocked.', 17)
                TriggerClientEvent('startSpeedo', src)
                TriggerClientEvent('police:officerOnDuty', src)
                signOnRadio(src)
        end)
end)
