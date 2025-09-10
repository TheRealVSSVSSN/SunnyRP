local LICENSE_VALIDITY = 30 * 24 * 60 * 60 -- seconds
local SUSPEND_THRESHOLD = 15

--[[
    -- Type: Event
    -- Name: fsn_licenses:chat
    -- Use: Broadcast license or ID details to specified players
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:chat')
AddEventHandler('fsn_licenses:chat', function(name, license, players)
    for _, pid in ipairs(players) do
        local msg
        if license.type == 'id' then
            msg = ('^1ID^0 | %s | %s | Ticket# %s | ID# %s'):format(name, license.job, source, license.charid)
        else
            msg = ('^1LICENSE^0 | %s | T:%s | I:%s | S:%s'):format(name, license.type, license.infractions, license.status)
        end
        TriggerClientEvent('chatMessage', pid, '', {255, 255, 255}, msg)
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:check
    -- Use: Validate license status based on infractions and expiry
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:check')
AddEventHandler('fsn_licenses:check', function(licenseType, infractions, issueDate)
    local status = 'ACTIVE'
    local current = os.time()
    if issueDate > 9999999999 then
        issueDate = math.floor(issueDate / 1000)
    end
    local expiry = issueDate + LICENSE_VALIDITY

    if current > expiry then
        status = 'EXPIRED'
    elseif infractions > SUSPEND_THRESHOLD then
        status = 'SUSPENDED'
    end

    if status ~= 'ACTIVE' then
        TriggerClientEvent('fsn_licenses:updateStatus', source, licenseType, status)
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:save
    -- Use: Persist license data for a character
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:save')
AddEventHandler('fsn_licenses:save', function(charid, licenses_json)
    MySQL.Async.execute('UPDATE `fsn_characters` SET `char_licenses` = @licenses WHERE `char_id` = @charid', {
        ['@charid'] = charid,
        ['@licenses'] = licenses_json
    })
end)

