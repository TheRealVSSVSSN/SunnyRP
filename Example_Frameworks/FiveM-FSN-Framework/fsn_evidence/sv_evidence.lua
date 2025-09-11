local evidence = {}

--[[
    -- Type: Event Handler
    -- Name: fsn_evidence:request
    -- Use: Sends current evidence table to requesting client
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_evidence:request', function()
    TriggerClientEvent('fsn_evidence:receive', source, evidence)
end)

--[[
    -- Type: Event Handler
    -- Name: fsn_evidence:collect
    -- Use: Handles collection of evidence by police
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_evidence:collect', function(id)
    local e = evidence[id]
    if e then
        TriggerClientEvent('fsn_evidence:display', source, e)
        evidence[id] = nil
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'This evidence has already gone.' })
    end
    TriggerClientEvent('fsn_evidence:receive', -1, evidence)
end)

--[[
    -- Type: Event Handler
    -- Name: fsn_evidence:destroy
    -- Use: Handles destruction of evidence by civilians
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_evidence:destroy', function(id)
    local e = evidence[id]
    if e then
        evidence[id] = nil
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You destroyed this evidence!' })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'This evidence has already gone.' })
    end
    TriggerClientEvent('fsn_evidence:receive', -1, evidence)
end)

-- evidence dropping
RegisterNetEvent('fsn_evidence:drop:casing', function(wep, loc)
    evidence[#evidence + 1] = {
        e_type = 'casing',
        loc = loc,
        details = {
            ammoType = wep.ammoType,
            serial = wep.Serial,
            owner = wep.Owner
        },
        expire = os.time() + 300
    }
    TriggerClientEvent('fsn_evidence:receive', -1, evidence)
end)

RegisterNetEvent('fsn_evidence:drop:blood', function(charid, loc)
    evidence[#evidence + 1] = {
        e_type = 'blood',
        loc = loc,
        details = { dnastring = charid },
        expire = os.time() + 300
    }
    TriggerClientEvent('fsn_evidence:receive', -1, evidence)
end)

CreateThread(function()
    while true do
        Wait(1000)
        if next(evidence) then
            for k, e in pairs(evidence) do
                if e.expire <= os.time() then
                    evidence[k] = nil
                end
            end
            TriggerClientEvent('fsn_evidence:receive', -1, evidence)
        end
    end
end)

